//
//  ContentView.swift
//  assign2
//
//  Created by Mei-An Blatchford on 3/28/22.
//

import SwiftUI
enum Mode : String, CaseIterable, Identifiable {
    case random, deterministic
    var id: Self { self }
}

struct ContentView: View {
    @EnvironmentObject var t: Triples
    var body: some View {
        TabView {
            Board().tabItem {
                Label("Board", systemImage: "gamecontroller")
            }
            Scores().tabItem {
                Label("Scores", systemImage: "list.dash")
            }
            About().tabItem {
                Label("About", systemImage: "info.circle")
            }
        }.environmentObject(t)
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Triples())
    }
}
