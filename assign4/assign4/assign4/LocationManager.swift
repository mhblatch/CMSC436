//
//  LocationManager.swift
//  assign4
//
//  Created by Mei-An Blatchford on 5/9/22.
//

import Foundation
import CoreLocation
import MapKit
import UniformTypeIdentifiers

class LocationManager: NSObject, ObservableObject {
    private let locationManager = CLLocationManager()
    @Published var location: CLLocation?
    @Published var region = MKCoordinateRegion()
    @Published var allLocations: [Pin] = []
    
    
    var show: Bool = false
    override init(){
        super.init()
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
    }
    func writeFile(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"//this your string date format
        let d = Date()
        var fname = dateFormatter.string(from: d)
        fname = fname + ".json"
        print(fname)
        var gpxseg = GPXSegment(coords: [])
        for i in 0..<self.allLocations.count{
            gpxseg.coords.append(GPXPoint(latitude: allLocations[i].coordinate.latitude, longitude: allLocations[i].coordinate.longitude, altitude: 0.0, time: d))
        }
        let gpxtrack = GPXTrack(name: fname, link: fname, time: "", segments: [gpxseg], distance: "", feetClimbed: "")
        
        if let docRoot = try? FileManager.default.url(for: .documentDirectory,
        in: .userDomainMask, appropriateFor: nil, create: true) {
        if let d = try? JSONEncoder().encode(gpxtrack) {
        do {
        try d.write(to: docRoot.appendingPathComponent(gpxtrack.link))
            print("writing to file bitch")
            print("d: \(d)")
        } catch {}
        }
        }
        clearRoute()
        print("Route Cleared")
    }
    func clearRoute(){
        self.allLocations = []
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        guard let location = locations.last else { return }
        if (show) {
            self.allLocations.append(Pin(coordinate: location.coordinate))
        }
        self.location = location
        self.region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude), latitudinalMeters: 300, longitudinalMeters: 300)
        
    }
}

struct Pin: Identifiable {
    var coordinate: CLLocationCoordinate2D
    let id = UUID()
}

/*
 let coordinates = locations.map { (location) -> CLLocationCoordinate2D in
         return location.coordinate
     }
 
   
 */
