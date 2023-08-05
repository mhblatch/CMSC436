//
//  RouteView.swift
//  assign4
//
//  Created by Mei-An Blatchford on 5/9/22.
//

import Foundation
import MapKit
import SwiftUI

struct RouteView: View {
    @State var coordinateRegion: MKCoordinateRegion
    @State var locations: [Pin] = []
    var body: some View{
        VStack{
            Map(coordinateRegion: $coordinateRegion,
                annotationItems: locations){ pin in
                MapAnnotation(coordinate: pin.coordinate){
                    Circle()
                        .fill(Color.red)
                        .frame(width: 10, height: 10)
                }
            }
        }
    }
}
