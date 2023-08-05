//
//  GPXPoint.swift
//  assign4
//
//  Created by Mei-An Blatchford on 5/9/22.
//

import Foundation
struct GPXPoint: Codable {
    var latitude: Double
    var longitude: Double
    var altitude: Double
    var time: Date
}

struct GPXSegment: Codable {
    var coords : [GPXPoint]
}

struct GPXTrack : Codable {
    var name : String
    var link : String
    var time : String
    var segments : [GPXSegment] = []
    var distance = "-"
    var feetClimbed = "-"
}
