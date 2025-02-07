//
//  ContentView.swift
//  WhatsPopping
//
//  Created by Mei-An Blatchford on 3/3/22.
//

import SwiftUI
import Foundation
import CoreLocation
import Combine


struct ReviewView: View {
    @EnvironmentObject private var reviewList: ReviewList
    @ObservedObject var textBindingManager = TextBindingManager(limit: 200)
    @State private var reviewEntry:String = ""
    @State private var selectedBar: Bars =  .bents
    // Variables for the star thing
    @State private var rating: Int = 0
    private var formatter = DateFormatter()
    
    var maxRating = 5
    
    var offImage: Image?
    var onImage = Image(systemName: "star.fill")
    
    var offColor = Color.gray
    var onColor = Color.yellow
    
    func image(for number: Int) -> Image {
        if number > rating {
                return offImage ?? onImage
        }
        return onImage
    }
    

    var body: some View {
        VStack (spacing:0){
            //Text("What's Popping").padding().font(.title).foregroundColor(.blue)
            NavigationView{
                Form {
                    Text("Enter your review:")
                    TextEditor(text: $textBindingManager.text)
                        .frame(width: 300, height: 200)
                    Section {
                        Picker("Bar:", selection: $selectedBar) {
                            ForEach(Bars.allCases, id: \.self) { value in
                                Text(value.rawValue)
                            }
                        }
                        
                        // STAR RATING CODE
                        HStack {
                            Text("Rating:")

                            ForEach(1..<maxRating + 1, id: \.self) { number in
                                image(for: number)
                                    .foregroundColor(number > rating ? offColor : onColor)
                                    .onTapGesture {
                                        rating = number
                                    print("rating in RatingView was: \(rating)")
                                    }
                            }
                        }.navigationTitle("What's Popping")
                        // End of star rating code
                    }
                    
                    HStack{
                        Button(action: {
                        print("Cancel Button Tapped")
                            reviewEntry = ""
                        }) {
                        Text("Cancel")
                        }.buttonStyle(.bordered)
                        Spacer()
                        Button(action: {
                        print("Submit Button Tapped")
                            if textBindingManager.text.isEmpty {
                                print("Empty Review")
                            }else{
                                reviewList.addReview(review: Review(bar: selectedBar, text:textBindingManager.text, rating: rating, upvotes: 0,
                                    timePosted: formatter.getDate(date: Date())))
                                
                                textBindingManager.text = ""
                                rating = 0
                                reviewList.resort()
                            }
                        }) {
                        Text("Add a Review")
                        }.buttonStyle(.bordered)
                    }
                }
            }
        }
        
    }
}


struct HomeView: View {
    @EnvironmentObject private var reviewList: ReviewList
    
    var body: some View {
        
        VStack {
            Text("Reviews:").padding().font(.title).foregroundColor(.blue)
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(0..<reviewList.reviews().count, id:\.self) {
                        i in
                        let review = reviewList.reviews()[i]
                        VStack(alignment: .leading, spacing: 10){
                            HStack {
                                Text("\(review.text)")
                                Spacer()
                                VStack {
                                    Image(systemName: "chevron.up").scaleEffect(1.5).onTapGesture {
                                        reviewList.upVoteReview(idx: i)
                                        reviewList.resort()
                                    }
                                    Text("\(review.upvotes)")
                                    Image(systemName: "chevron.down").scaleEffect(1.5).onTapGesture {
                                        reviewList.downVoteReview(idx: i)
                                        reviewList.resort()
                                    }
                                }
                            }
                            RatingView(rating: review.rating, posted: true)
                            HStack {
                                Image(systemName: "location")
                                Text("\(review.bar.rawValue)")
                                Divider()
                                Text("\(review.timePosted)")
                            }
                            Divider()
                        }
                    }
                }
            }.padding()
        }
    }
}

struct InfoView: View {
    @StateObject var locationManager = LocationManager()
    
    var userLatitude: String {
        return "\(locationManager.lastLocation?.coordinate.latitude ?? 0)"
    }
    var userLongitude: String {
        return "\(locationManager.lastLocation?.coordinate.longitude ?? 0)"
    }
    
    var cstoneDistance: String {
        let your_loc = locationManager.lastLocation ?? CLLocation(latitude: 38.980000000000000, longitude: -76.93000000000000)
        let distance = your_loc.distance(from: Locations._cstone)
        return String(format:"%.02f", (distance/1609.34))
    }
    
    var bentsDistance: String {
        let your_loc = locationManager.lastLocation ?? CLLocation(latitude: 38.980000000000000, longitude: -76.93000000000000)
        let distance = your_loc.distance(from: Locations._bents)
        return String(format:"%.02f", (distance/1609.34))
    }
    
    var thcpDistance: String {
        let your_loc = locationManager.lastLocation ?? CLLocation(latitude: 38.980000000000000, longitude: -76.93000000000000)
        let distance = your_loc.distance(from: Locations._thcp)
        return String(format:"%.02f", (distance/1609.34))
    }
    
    var looneysDistance: String {
        let your_loc = locationManager.lastLocation ?? CLLocation(latitude: 38.980000000000000, longitude: -76.93000000000000)
        let distance = your_loc.distance(from: Locations._looneys)
        return String(format:"%.02f", (distance/1609.34))
    }
    
    var turfDistance: String {
        let your_loc = locationManager.lastLocation ?? CLLocation(latitude: 38.980000000000000, longitude: -76.93000000000000)
        let distance = your_loc.distance(from: Locations._turf)
        return String(format:"%.02f", (distance/1609.34))
    }
    
    
    var body: some View {
        VStack {
            Text("Bar Info").padding().font(.title)
            List {
                VStack {
                    ScrollView {
                        VStack {
                            Text("Cornerstone").font(.title)
                            Text("Address: 7325 Baltimore Ave, College Park, MD 20740")
                            Text("Phone Number: 301-779-7044")
                            Text("Your Distance: \(cstoneDistance) miles")
                        }
                        Divider()
                        VStack {
                            Text("RJ Bentleys").font(.title)
                            Text("Address: 7323 Baltimore Ave, College Park, MD 20740")
                            Text("Phone Number: 301-277-8898")
                            Text("Your Distance: \(bentsDistance) miles")
                        }
                        Divider()
                        VStack {
                            Text("The Hall CP").font(.title)
                            Text("Address: 4656 Hotel Dr, College Park, MD 20742")
                            Text("Phone Number: 301-403-8961")
                            Text("Your Distance: \(thcpDistance) miles")
                        }
                        Divider()
                        VStack {
                            Text("Looney's Pub").font(.title)
                            Text("Address: 8150 Baltimore Ave, College Park, MD 20740")
                            Text("Phone Number: 240-542-4510")
                            Text("Your Distance: \(looneysDistance) miles")
                        }
                        Divider()
                        VStack {
                            Text("Terrapin Turf").font(.title)
                            Text("Address: 4410 Knox Rd, College Park, MD 20740")
                            Text("Phone Number: 301-277-8377")
                            Text("Your Distance: \(turfDistance) miles")
                        }
                        
                    }.padding()
                }
            }
        }
    }
}

struct SettingView: View {
    @State private var username = UserDefaults.standard.string(forKey: "username")
    @State private var name: String = ""
    var body: some View{
        if (username != nil) {
            VStack{
                
                Text("Settings:").padding().font(.title).foregroundColor(.blue)
                Text("You are logged in")
                Text(username!)
                Button(action: {
                    UserDefaults.standard.set(nil, forKey: "username")
                    username = nil
                    }){
                    Text("Logout")
                    }
            }
        }
        else {
            VStack{
                Text("What's Poppin").padding().font(.title).foregroundColor(.blue)
                HStack {
                    Image(systemName: "person")
                    TextField("Enter a username", text: $name)
                }.padding()
                Button(action: {
                    if name != "" {
                        UserDefaults.standard.set(name, forKey: "username")
                        username = name
                    }
                    }){
                    Text("Sign In")
                }.padding()
            }.padding()
        }
    }
}

struct ContentView: View {
    @EnvironmentObject private var reviewList: ReviewList
    @EnvironmentObject var loginController: LoginController
    
    var body: some View {
        
        TabView {
            HomeView().environmentObject(reviewList).tabItem {
                Image(systemName: "house.fill")
                Text("Home Tab").font(.system(size:30, weight: .bold, design: .rounded))
            }
            ReviewView().environmentObject(reviewList).tabItem {
                Image(systemName: "square.and.pencil")
                Text("Submit Review").font(.system(size:30, weight: .bold, design: .rounded))
            }
            InfoView().tabItem {
                Image(systemName: "info.circle")
                Text("Bar Info").font(.system(size:30, weight: .bold, design: .rounded))
            }
            SettingView().tabItem {
                Image(systemName: "gearshape")
                Text("Settings").font(.system(size:30, weight: .bold, design: .rounded))
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView().environmentObject(ReviewList())
        }
    }
}

class TextBindingManager: ObservableObject {
    @Published var text = "" {
        didSet {
            if text.count > characterLimit && oldValue.count <= characterLimit {
                text = oldValue
            }
        }
    }
    let characterLimit: Int

    init(limit: Int = 5){
        characterLimit = limit
    }
}

extension DateFormatter {
    func getDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, h:mm a"
        return formatter.string(from: date)
    }
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {

    private let locationManager = CLLocationManager()
    @Published var locationStatus: CLAuthorizationStatus?
    @Published var lastLocation: CLLocation?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

   
    
    var statusString: String {
        guard let status = locationStatus else {
            return "unknown"
        }
        
        switch status {
        case .notDetermined: return "notDetermined"
        case .authorizedWhenInUse: return "authorizedWhenInUse"
        case .authorizedAlways: return "authorizedAlways"
        case .restricted: return "restricted"
        case .denied: return "denied"
        default: return "unknown"
        }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        locationStatus = status
        print(#function, statusString)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        lastLocation = location
        print(#function, location)
    }
}

enum Locations: String, CaseIterable, Identifiable {
    var id: String { self.rawValue }
    case cstone = "Cornerstone Loft & Grill"
    case bents = "RJ Bentleys"
    case thcp = "The Hall CP"
    case looneys = "Looney's Pub"
    case turf = "Terrapin Turf"
    
    static let _cstone = CLLocation(latitude: 38.980805461959385,
                                                       longitude: -76.93762714625424)
    static let _bents = CLLocation(latitude:38.980649441772265,
                                                            longitude: -76.9376624750897)
    static let _thcp = CLLocation(latitude: 38.986506982314005,
                                                              longitude: -76.9337045615958)
    static let _looneys = CLLocation(latitude: 38.9911177475402,
                                                       longitude: -76.93429631557035)
    static let _turf = CLLocation(latitude: 38.98118404141311,
                                                            longitude: -76.93837924440616)
}
