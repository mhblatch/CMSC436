//
//  UploadView.swift
//  assign5
//
//  Created by Mei-An Blatchford on 5/15/22.
//

import Foundation
import SwiftUI
import Firebase

struct UploadView: View {
   @State var url = ""
   @State var descript = ""
    func getDescription() -> String{
        return descript
    }
    func getURL() -> String{
        return url
    }
    func upload() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        let root = Database.database().reference()
        root.child("urls").childByAutoId().setValue(["url": url,"name": descript, "likes": 0])
    }
    var body: some View{
        VStack{
            Form {
                TextField(text: $descript, prompt: Text("Enter a description")) {
                    Text("Enter a description")
                }
                TextField(text: $url, prompt: Text("Enter a URL")) {
                    Text("Enter a URL")
                }
                Button( "Upload",
                    action: {
                    upload()
                    descript = ""
                    url = ""
                    print("Upload button hit")
                })
            }
        }

    }
}
