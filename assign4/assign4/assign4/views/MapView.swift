//
//  MapView.swift
//  assign4
//
//  Created by Mei-An Blatchford on 5/9/22.
//

import Foundation
import SwiftUI
import MapKit
import UniformTypeIdentifiers
import Darwin

struct MapView: View{
    @EnvironmentObject var locationManager: LocationManager
    @State var show: Bool = false
    @State var readFiles: Bool = false
    @State var showRoute: Bool = false
    @State var routeView: RouteView = RouteView(coordinateRegion: MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 38.99, longitude: -76.95), latitudinalMeters: 300, longitudinalMeters: 300), locations: [])
    var body: some View{
        let coord =  locationManager.location?.coordinate
        let lat = coord?.latitude ?? 38.99
        let lon = coord?.longitude ?? -76.95
        if(showRoute){
            VStack{
                Button("Go back to main screen"){
                    print("Go home")
                    showRoute = false
                }
                routeView
            }
        }else{
            VStack{
                if(show){
                    Map(coordinateRegion: $locationManager.region ,
                        interactionModes: .all,
                        showsUserLocation: true,
                        userTrackingMode: .constant(.follow),
                        annotationItems: locationManager.allLocations){ pin in
                        MapAnnotation(coordinate: pin.coordinate){
                            Circle()
                                .fill(Color.red)
                                .frame(width: 10, height: 10)
                        }
                    }
                }else{
                    Map(coordinateRegion: $locationManager.region ,
                        interactionModes: .all,
                        showsUserLocation: true,
                        userTrackingMode: .constant(.follow))
                }
                Text("\(lat) ,  \(lon) )")
                if(show){
                    Button("Stop tracking"){
                        show = false
                        locationManager.show = false
                        locationManager.writeFile()
                        print("Button hit")
                    }.padding().border(Color.blue, width: 5)
                }else{
                    Button("Start tracking"){
                        show = true
                        locationManager.show = true
                        print("Button hit")
                    }.padding().border(Color.blue, width: 5)
                }
                Button("Browse saved routes"){
                    print("show files")
                    readFiles = true
                }.fileImporter(isPresented: $readFiles, allowedContentTypes: [UTType.json]) { res in
                    if let url = try? res.get() {
                        if let data = try? Data(contentsOf: url) {
                            if let f = try? JSONDecoder().decode(GPXTrack.self, from: data) {
                                let fname = f.name
                                print(fname)
                                /* Finding bounds for MK */
                                var minx = Double.infinity
                                var miny = Double.infinity
                                var maxx = Double.infinity * -1
                                var maxy = Double.infinity * -1
                                let segs = f.segments.first?.coords
                                var mypins: [Pin] = []
                                for i in 0..<(f.segments.first?.coords.count)! {
                                    minx =  (minx < segs![i].longitude ? minx : segs![i].longitude)
                                    miny =  (miny < segs![i].latitude ? miny : segs![i].latitude)
                                    maxx =  (maxx > segs![i].longitude ? maxx : segs![i].longitude)
                                    maxy =  (maxy > segs![i].latitude ? maxy : segs![i].latitude)
                                    mypins.append(Pin(coordinate: CLLocationCoordinate2D(latitude: segs![i].latitude, longitude: segs![i].longitude)))
                                }
                                var  centerlog  = (minx + maxx)
                                var centerlat = (miny + maxy)
                                centerlog /= 2
                                centerlat /= 2
                                print(" \(centerlog) \(centerlat)")
                                let c = CLLocationCoordinate2D(latitude: centerlat, longitude: centerlog)
                                routeView = RouteView(coordinateRegion: MKCoordinateRegion(center: c, latitudinalMeters: 300, longitudinalMeters: 300), locations: mypins)
                                showRoute = true
                            }
                        }
                    }
                }.padding().border(Color.blue, width: 5)
                //.frame(width: 250, height: 250, alignment: .center)
            }

        }
        }
}

