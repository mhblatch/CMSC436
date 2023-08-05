//
//  PlayerView.swift
//  assign5
//
//  Created by Mei-An Blatchford on 5/15/22.
//

import Foundation
import SwiftUI
import Firebase
import AVKit

struct PlayerView: View{
    @State var curr: Video = Video(id: "starwars", url: "https://bit.ly/swswift" , name: "Star Wars", likes: 0)
    @State var videos: [Video] = []
    @State var unseen_videos: [Video] = []
    @State var seen_videos: [Video] = []
    let directoryID = "mhblatch"
    @State var entries: [String:Video] = [:]
    @State var videoIndex = 0
    func printInfo(_ value: Any) {
        let t = type(of: value)
        print("'\(value)' of type '\(t)'")
    }

    func readDB(){
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        let rootRef = Database.database().reference()
        rootRef.child("/urls/").getData { err, snapshot in
                for child in snapshot!.children {
                    if let item = child as? DataSnapshot {
                        if let val = item.value as? NSDictionary{
                            let vid = Video.fromDict(val, id: item.key)
                            self.videos.append(vid!)
                            
                        }
                    }
                }
        }
        for video in videos {
            print(video.url)
        }
    }
    func observeChild(){
        let rootRef = Database.database().reference().child("/urls/")
        rootRef.observe(.childAdded) { snapshot in
            print("Data")
        }
    }
    func prev() {
        self.videoIndex -= 1
        if self.videoIndex < 0{
            self.videoIndex = self.videos.count - 1
        }
    }
    func next(){
        self.videoIndex += 1
        if self.videoIndex >= self.videos.count{
            self.videoIndex = 0
        }
    }
    func likeVid(){
        print("liked video")
        let rootRef = Database.database().reference().child("/urls/" + (self.videos[self.videoIndex].id ?? "") + "//likes/")
        rootRef.setValue([directoryID: 1])
        self.videos[self.videoIndex].likes = 1
        
    }
    func seenVideo(){
        let root = Database.database().reference()
        if !videos.isEmpty{
            root.child("seen/" + directoryID + "/" + (self.videos[self.videoIndex].id ?? "")).setValue(["seen": 1])
        }
        
    }
    var body: some View{
        VStack{
            if( self.videos.isEmpty){
                VStack{
                    Text("Update video list to see any videos")
                }
            }else{
                HStack{
                    Text("\(self.videos[self.videoIndex].name)").padding()
                    Text("Likes: \(self.videos[self.videoIndex].likes)").padding()
                }
                VideoPlayer(player: AVPlayer(url: URL(string: self.videos[self.videoIndex].url)!))
                .frame(height: 400).gesture(DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onEnded({ value in
                        if value.translation.width < 0 {
                            seenVideo()
                            prev()
                        }

                        if value.translation.width > 0 {
                            // right
                            seenVideo()
                            next()
                        }
                    }))
                Button {
                    likeVid()
                } label: {
                    Label("Like", systemImage: "heart.fill")
                }.padding()
                    .foregroundColor(.white)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 5))
                HStack{
                    Button( "Previous",
                        action: {
                        seenVideo()
                        prev()
                    }).padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                    Button( "Next",
                        action: {
                        seenVideo()
                        next()
                    }).padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                }
            }
            Button( "Update",
                action: {
                readDB()
                seenVideo()
                print("Update button hit")
            }).padding()
                .foregroundColor(.white)
                .background(Color.blue)
                .clipShape(RoundedRectangle(cornerRadius: 5))
        }
    }
}


struct Video: Codable, Identifiable {
    var id: String?
    var url: String
    var name: String
    var likes: Int
    
    static func fromDict(_ d: NSDictionary, id: String) -> Video? {
        guard let url = d["url"] as? String else { return nil }
        guard let name = d["name"] as? String else { return nil }
        var updatelikes = 0
        if let mylikes: NSDictionary = d["likes"] as? NSDictionary {
            for l in mylikes.allValues {
                updatelikes = l as! Int
            }
        }
        
        return Video(id: id, url: url, name: name, likes: updatelikes)
    }
}
