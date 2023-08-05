//
//  assign5App.swift
//  assign5
//
//  Created by Mei-An Blatchford on 5/15/22.
//

import SwiftUI
import Firebase

@main
struct assign5_testApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions:
        [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        if FirebaseApp.app() == nil {
                FirebaseApp.configure()
            }
        return true
    }
}
