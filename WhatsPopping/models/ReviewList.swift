//
//  BarList.swift
//  WhatsPopping
//
//  Created by Mei-An Blatchford on 3/3/22.
// Use ShowList from class example

import Foundation
import SwiftUI
import FirebaseDatabase


let reviewsDBKey: String = "reviews"

//Bars in College Park Area
enum Bars: String, Equatable, CaseIterable, Codable {
    case cstone = "Cornerstone Loft & Grill"
    case bents = "RJ Bentleys"
    case thcp = "The Hall CP"
    case looneys = "Looney's Pub"
    case turf = "Terrapin Turf"
}

struct Review: Comparable, Codable {
    static func < (lhs: Review, rhs: Review) -> Bool {
        lhs.upvotes > rhs.upvotes
    }
    
    var bar: Bars
    var text: String
    var rating: Int
    var upvotes: Int
    var timePosted: String
    
    var nsdict: NSDictionary {
        NSDictionary(dictionary: [
            "bar" : bar.rawValue,
            "text" : text,
            "rating" : rating,
            "upvotes" : upvotes,
            "timePosted" : timePosted
        ])
    }
    
    static func fromDict( _ d: NSDictionary) -> Review? {
        guard let bar = d["bar"]  else { return nil }
        guard let text = d["text"] else { return nil }
        guard let rating = d["rating"] else { return nil }
        guard let upvotes = d["upvotes"] else { return nil }
        guard let timePosted = d["timePosted"] else { return nil }
        return Review(bar: Bars(rawValue: bar as! String)!, text: text as! String, rating: rating as! Int, upvotes: upvotes as! Int, timePosted: timePosted as! String)
    }
}

class ReviewList: ObservableObject {
    @Published private var _reviews: [Review]
    @Published var curReview: Int
    init () {
        _reviews = []
        curReview = 0
        
        let rootRef = Database.database().reference()
        rootRef.getData { err, snapshot in
            DispatchQueue.main.async {
                for child in snapshot.children {
                    if let item = child as? DataSnapshot {
                        if let val = item.value as? NSArray {
                            print("val.count=\(val.count)")
                            for i in 0..<val.count {
                                if let rev = Review.fromDict(val[i] as! NSDictionary) {
                                    self._reviews.append(rev)
                                }
                            }
                        }
                    }
                }
                self.filterReviews()
            }
        }
        
        /*
        rootRef.observe(.childAdded) { snapshot in
            if let v = snapshot.value as? NSDictionary,
               let rev = Review.fromDict(v) {
                self._reviews.append(rev)
            }
        }*/
        /*
        rootRef.observe(.childRemoved) { snapshot in
            self._reviews.removeValue(forKey: snapshot.key)
            
        }
        rootRef.observe(.childChanged) {
            
        }*/
    }
    
    func filterReviews() {
        print("filterReviews with reviews=\(self._reviews)")
        var idxs: [Int] = []
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        for idx in 0..<self._reviews.count {
            print("filtering idx:\(idx)")
            if _reviews[idx].upvotes <= -3 {
                idxs.append(idx)
                
            }
            else {
                // the value of 22 needs to be set to however many years since 2000 it is currently
                let date = Calendar.current.date(byAdding: .year, value: 22, to: formatter.date(from:_reviews[idx].timePosted)!)!
                let now = Date()
                if let sixHrsAgo = Calendar.current.date(byAdding: .hour, value: -6, to: now) {
                    /*
                    print("date:", date)
                    print("now:", now)
                    print("sixHrsAgo:", sixHrsAgo)
                    print("Date().timeIntervalSince(now)=\(Date().timeIntervalSince(now))")
                    print("sixHrsAgo.timeIntervalSince(now)",sixHrsAgo.timeIntervalSince(now))
                    print("now.timeIntervalSince(date)",now.timeIntervalSince(date))
                    print("sixHrsAgo.timeIntervalSince(date)",sixHrsAgo.timeIntervalSince(date)) */
                    if (sixHrsAgo.timeIntervalSince(date) > 0) {
                        idxs.append(idx)
                    }
                }
            }
        }
        for i in idxs.reversed() {
            self._reviews.remove(at: i)
        }
    }
    
    func updateDB() {
        
        // remove reviews that were created yesterday or have less than -3 downvotes
        self.filterReviews()
        
        
        DispatchQueue.global(qos: .background).async {
            /*let enc = JSONEncoder()
            if let d = try? enc.encode(self._reviews) {
                try? d.write(to: self._url)
            }*/
            
            
            
            
            
            
            let rootRef = Database.database().reference()
            let reviewsRef = rootRef.child(reviewsDBKey)
            let reviewsArray = NSArray(array: self._reviews.map {
                r in r.nsdict } )
            reviewsRef.setValue(reviewsArray)
        }
    }
    
    func addReview(review: Review) {
        _reviews.append(review)
        self.updateDB()
    }
    
    func reviews() -> [Review] {
        return _reviews
    }
    
    func upVoteReview(idx: Int) {
        _reviews[idx].upvotes += 1
        self.updateDB()
    }
    
    func downVoteReview(idx: Int) {
        _reviews[idx].upvotes -= 1
        self.updateDB()
    }
    
    func votes(idx: Int) -> Int {
        return _reviews[idx].upvotes
    }
    
    func resort(){
        _reviews.sort()
        self.updateDB()
    }
}
