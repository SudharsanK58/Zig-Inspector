//
//  mqttLogViewerController.swift
//  Zig Inspector
//
//  Created by Sudharsan on 27/07/23.
//

import UIKit
import CocoaMQTT
import MapKit

class mqttLogViewerController: UIViewController {
    let defaultHost = "mqtt.zig-web.com"
    var lastKnownLocation: CLLocationCoordinate2D?
    var mqtt: CocoaMQTT?
    
    @IBOutlet weak var deviceMapViewer: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let clientID = "CocoaMQTT-" + String(ProcessInfo().processIdentifier)
        mqtt = CocoaMQTT(clientID: clientID, host: defaultHost, port: 1883)
        mqtt!.username = ""
        mqtt!.password = ""
        mqtt!.willMessage = CocoaMQTTMessage(topic: "/will", string: "dieout")
        mqtt!.keepAlive = 60
        mqtt!.delegate = self
        mqtt!.enableSSL = false
        let started = mqtt!.connect()
        if started {
            print("Connection attempt started successfully.")
        } else {
            print("Connection attempt failed to start.")
        }

    }
}


extension mqttLogViewerController: CocoaMQTTDelegate {
    
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("ack: \(ack)")
        if ack == .accept {
            print("Successfully connected to MQTT")
            mqtt.subscribe("98:CD:AC:51:4A:BC/log", qos: CocoaMQTTQoS.qos1)
        } else {
            print("Failed to connect to MQTT: \(ack)")
        }
    }

    func mqtt(_ mqtt: CocoaMQTT, didStateChangeTo state: CocoaMQTTConnState) {
        print("new state: \(state)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishMessage message: CocoaMQTTMessage, id: UInt16) {
        print("message: \(message.string!.description), id: \(id)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didPublishAck id: UInt16) {
        print("id: \(id)")
    }

    

    func mqtt(_ mqtt: CocoaMQTT, didReceiveMessage message: CocoaMQTTMessage, id: UInt16 ) {
        print("message: \(message.string!.description), id: \(id)")
        
        guard let messageString = message.string, message.topic == "98:CD:AC:51:4A:BC/log" else { return }
        
        if let data = messageString.data(using: .utf8) {
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    if let gpsData = json["gps"] as? [String: Any] {
                        if let latString = gpsData["latitude"] as? String, let longString = gpsData["longitude"] as? String {
                            let lat = Double(latString)
                            let long = Double(longString)
                            if let lat = lat, let long = long {
                                self.lastKnownLocation = CLLocationCoordinate2D(latitude: lat, longitude: long)
                            }
                        }
                    }
                    
                    // If no new location data, use the last known location
                    if let location = self.lastKnownLocation {
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = location
                        
                        // Set the title and subtitle of the annotation
                        if let deviceData = json["device"] as? [String: Any], let id = deviceData["id"] as? String {
                            annotation.title = "\(id)"
                        }
                        if let gpsData = json["gps"] as? [String: Any], let speed = gpsData["speed"] as? String {
                            annotation.subtitle = "Speed: \(speed)"
                        }
                        
                        DispatchQueue.main.async {
                            // Remove previous annotations
                            let allAnnotations = self.deviceMapViewer.annotations
                            self.deviceMapViewer.removeAnnotations(allAnnotations)
                            
                            // Add new annotation
                            self.deviceMapViewer.addAnnotation(annotation)
                            
                            // Zoom to new annotation
                            let region = MKCoordinateRegion(center: location, latitudinalMeters: 400, longitudinalMeters: 400)
                            self.deviceMapViewer.setRegion(region, animated: true)
                        }
                    }
                }
            } catch {
                print("JSON Serialization error: \(error)")
            }
        }
    }






    func mqtt(_ mqtt: CocoaMQTT, didSubscribeTopics success: NSDictionary, failed: [String]) {
        print("subscribed: \(success), failed: \(failed)")
    }

    func mqtt(_ mqtt: CocoaMQTT, didUnsubscribeTopics topics: [String]) {
        print("topic: \(topics)")
    }

    func mqttDidPing(_ mqtt: CocoaMQTT) {
        print()
    }

    func mqttDidReceivePong(_ mqtt: CocoaMQTT) {
        print()
    }

    func mqttDidDisconnect(_ mqtt: CocoaMQTT, withError err: Error?) {
        print("Error")
    }
}
