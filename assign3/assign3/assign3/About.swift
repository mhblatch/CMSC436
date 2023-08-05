//
//  About.swift
//  assign3
//
//  Created by Mei-An Blatchford on 4/17/22.
//

import Foundation
import SwiftUI

struct About: View{
    @State private var rules = ""
    var body: some View{
        VStack{
            Button(action: {
                self.rules = ""
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            self.rules = "Use the buttons or drag your finger across the screen to move the tiles"
                        }
            }){
                Text("Click here for the rules")
            }
            Spacer().frame(height: 60)
            Text(self.rules).animation(.spring())
        }.frame(width: 400, height: 400, alignment: .center)
    }
}
