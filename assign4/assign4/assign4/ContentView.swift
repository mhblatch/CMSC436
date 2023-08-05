//
//  ContentView.swift
//  assign4
//
//  Created by Mei-An Blatchford on 5/9/22.
//

import SwiftUI

struct ContentView: View {
    @State var  locationManager = LocationManager()
    var body: some View {
        MapView().environmentObject(locationManager)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
