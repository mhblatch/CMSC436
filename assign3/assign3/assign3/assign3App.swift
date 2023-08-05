//
//  assign2App.swift
//  assign2
//
//  Created by Mei-An Blatchford on 3/28/22.
//

import SwiftUI

@main
struct assign2App: App {
    @StateObject var myboard: Triples = Triples.init()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(myboard)
        }
    }
}
