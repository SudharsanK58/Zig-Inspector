//
//  mqttLogViewerController.swift
//  Zig Inspector
//
//  Created by Sudharsan on 27/07/23.
//

import UIKit
import CocoaMQTT

class mqttLogViewerController: UIViewController {
    let defaultHost = "mqtt.zig-web.com"

    var mqtt: CocoaMQTT?
    
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
                mqtt.subscribe("chat/", qos: CocoaMQTTQoS.qos1)
                mqtt.publish("Nie", withString: "Hai")
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
