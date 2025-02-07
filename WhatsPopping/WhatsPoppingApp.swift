//
//  WhatsPoppingApp.swift
//  WhatsPopping
//
//  Created by Mei-An Blatchford on 3/3/22.
//

import SwiftUI
import Firebase
import FirebaseAuth

@main
struct WhatsPoppingApp: App {
    @StateObject var loginController: LoginController = LoginController()
    //@State var isLoggedin: Bool = false;
    @StateObject var reviewList: ReviewList = ReviewList.init()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
                ContentView().environmentObject(reviewList).environmentObject(loginController)
        }
    }
}
