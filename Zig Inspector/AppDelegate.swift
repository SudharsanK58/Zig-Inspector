//
//  AppDelegate.swift
//  Zig Inspector
//
//  Created by Sudharsan on 07/06/23.
//

import UIKit
import CocoaMQTT
import UserNotifications

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let defaultHost = "mqtt.zusan.in"
    var mqtt: CocoaMQTT?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        requestNotificationAuthorization()
        UNUserNotificationCenter.current().delegate = self
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
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func requestNotificationAuthorization() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("Failed to request authorization for notifications: \(error)")
            } else if granted {
                print("Permission granted for notifications.")
            } else {
                print("Permission denied for notifications.")
            }
        }
    }


}
extension AppDelegate: CocoaMQTTDelegate,UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            completionHandler([.banner, .sound]) // Change this to your preferred options
        }
    func mqtt(_ mqtt: CocoaMQTT, didConnectAck ack: CocoaMQTTConnAck) {
        print("ack: \(ack)")
        if ack == .accept {
            print("Successfully connected to MQTT")
            mqtt.subscribe("/Here", qos: CocoaMQTTQoS.qos1)
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
        scheduleNotification(with: "New MQTT Message", body: message.string ?? "Empty Message")
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
    func scheduleNotification(with title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)

        let center = UNUserNotificationCenter.current()
        center.add(request) { (error) in
            if let error = error {
                print("Error scheduling notification: \(error)")
            }
        }
    }
}

