//
//  ContentView.swift
//  assign5
//
//  Created by Mei-An Blatchford on 5/15/22.
//

import SwiftUI
import Firebase
struct ContentView: View {
    
    var body: some View {
        VStack{
            TabView {
                UploadView().tabItem {
                               Label("Upload", systemImage: "square.and.arrow.up")
                           }

                PlayerView().tabItem {
                               Label("Play", systemImage: "play.fill")
                        }
                   }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
