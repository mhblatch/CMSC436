//
//  Board.swift
//  assign3
//
//  Created by Mei-An Blatchford on 4/17/22.
//

import Foundation
import SwiftUI

struct Board: View {
    @EnvironmentObject var myboard: Triples
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var selectedMode: Mode = .random
    @State private var endmessage = ""
    @State var showEndMessage: Bool = false
    func dragMove(v: DragGesture.Value){
        withAnimation(Animation.easeInOut.speed(2)){
            if abs(v.translation.height) > abs(v.translation.width){
                if(v.translation.height > 0){
                    myboard.collapse(dir: .down)
                    myboard.spawn()
                }else if(v.translation.height < 0){
                    myboard.collapse(dir: .up)
                    myboard.spawn()
                }
            }else{
                if(v.translation.width > 0){
                    myboard.collapse(dir: .right)
                    myboard.spawn()
                }else if(v.translation.width < 0){
                    myboard.collapse(dir: .left)
                    myboard.spawn()
                }
            }
        }
    }
    var body: some View {
        if verticalSizeClass == .regular {
            VStack{
                ZStack(alignment: .center) {
                    ZStack(alignment: .center){
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 250, height: 250)
                            .padding(.top, 20)
                        Text("Score: \(myboard.score)").padding(.bottom, 50)
                        Button("Restart",
                               action: {
                            print("Game restarted")
                            if(selectedMode == .random){
                                myboard.newgame(rand: true)
                                myboard.spawn()
                                myboard.spawn()
                                myboard.spawn()
                                myboard.spawn()
                            }else{
                                myboard.newgame(rand: false)
                                myboard.spawn()
                                myboard.spawn()
                                myboard.spawn()
                                myboard.spawn()
                            }
                        }).padding(50)
                    }.padding(50)
                        .zIndex(myboard.isOver ? 1: 0)
                    Rectangle()
                        .fill(Color.gray)
                        .frame(width: 250, height: 250)
                        .padding(.top, 20)
                    VStack(alignment: .center){
                        GeometryReader { g in
                            ForEach(1...16, id: \.self){ i in
                                let mytile = myboard.getTile(tid: i)
                                TileView(tile: mytile)
                                    .offset(x: (CGFloat(mytile.col)*60), y: (CGFloat(mytile.row)*60))
                                    .animation(.easeInOut(duration: 0.5))
                            }
                        }
                    }.padding(.all, 80)
                }
                VStack {
                            Spacer().frame(height: 50)
                            Button(
                              "Up",
                              action: {
                                  if !myboard.isOver{
                                    print("Up button clicked")
                                    myboard.collapse(dir: .up)
                                    myboard.spawn()
                                  }
                              }
                            )
                            HStack{
                                Button(
                                  "Left",
                                  action: {
                                      if !myboard.isOver{
                                          print("Left button clicked")
                                          myboard.collapse(dir: .left)
                                          myboard.spawn()
                                      }
                                  }
                                )
                                Spacer().frame(width: 100)
                                Button(
                                  "Right",
                                  action: {
                                      if !myboard.isOver{
                                          print("Right button clicked")
                                          myboard.collapse(dir: .right)
                                          myboard.spawn()
                                      }
                                  }
                                )
                            }
                            Button(
                              "Down",
                              action: {
                                  if !myboard.isOver{
                                      print("Down button clicked")
                                      myboard.collapse(dir: .down)
                                      myboard.spawn()
                                  }
                              }
                            )
                            Spacer().frame(height: 10)
                            Button(
                              "New Game",
                              action: {
                                  print("New game")
                                  myboard.flipIsOver()
                                })
                            Spacer().frame(height: 10)
                            Text("Score: " + String(myboard.score))
                            Picker("Mode", selection: $selectedMode) {
                                    ForEach(Mode.allCases) {  mode in
                                        Text(mode.rawValue.capitalized)
                                    }
                            }.pickerStyle(.segmented).frame(maxHeight: .infinity, alignment: .bottom)
                        }
            }.gesture(DragGesture().onEnded({ value in
                self.dragMove(v: value )
            }))
        }else{
            HStack{
                VStack{
                    ZStack(alignment: .center){
                        ZStack(alignment: .center){
                            Rectangle()
                                .fill(Color.gray)
                                .frame(width: 250, height: 250)
                                .padding(.top, 20)
                            Text("Score: \(myboard.score)").padding(.bottom, 50)
                            Button("Restart",
                                   action: {
                                print("Game restarted")
                                if(selectedMode == .random){
                                    myboard.newgame(rand: true)
                                    myboard.spawn()
                                    myboard.spawn()
                                    myboard.spawn()
                                    myboard.spawn()
                                }else{
                                    myboard.newgame(rand: false)
                                    myboard.spawn()
                                    myboard.spawn()
                                    myboard.spawn()
                                    myboard.spawn()
                                }
                            }).padding(50)
                        }.padding(50)
                            .zIndex(myboard.isOver ? 1: 0)
                        Rectangle()
                            .fill(Color.gray)
                            .frame(width: 250, height: 250)
                            .padding(.top, 20)
                        VStack(alignment: .center){
                            GeometryReader { g in
                                ForEach(1...16, id: \.self){ i in
                                    let mytile = myboard.getTile(tid: i)
                                    TileView(tile: mytile)
                                        .offset(x: (CGFloat(mytile.col)*60), y: (CGFloat(mytile.row)*60))
                                        .animation(.easeInOut(duration: 0.5))
                                }
                            }
                        }.padding(.leading, 70).padding(.top, 80)
                    }
                }
                VStack(alignment: .center){
                    //UP AND DOWN BUTTON
                    Spacer().frame(height: 100)
                    Button(
                      "Up",
                      action: {
                          if !myboard.isOver{
                            print("Up button clicked")
                            myboard.collapse(dir: .up)
                            myboard.spawn()
                          }
                      }
                    )
                    HStack{
                        Button(
                          "Left",
                          action: {
                              if !myboard.isOver{
                                  print("Left button clicked")
                                  myboard.collapse(dir: .left)
                                  myboard.spawn()
                              }
                          }
                        )
                        Spacer().frame(width: 100)
                        Button(
                          "Right",
                          action: {
                              if !myboard.isOver{
                                  print("Right button clicked")
                                  myboard.collapse(dir: .right)
                                  myboard.spawn()
                              }
                          }
                        )
                    }
                    Button(
                      "Down",
                      action: {
                          if !myboard.isOver{
                              print("Down button clicked")
                              myboard.collapse(dir: .down)
                              myboard.spawn()
                          }
                      }
                    )
                    Spacer().frame(height: 10)
                    Button(
                      "New Game",
                      action: {
                          print("New game")
                          myboard.flipIsOver()
                        })
                    Spacer().frame(height: 10)
                    Text("Score: " + String(myboard.score))
                    Picker("Mode", selection: $selectedMode) {
                            ForEach(Mode.allCases) {  mode in
                                Text(mode.rawValue.capitalized)
                            }
                    }.pickerStyle(.segmented).frame(maxHeight: .infinity, alignment: .bottom)
                }
                //BUTTONS NEED TO GO HERE
                
            }
        }
    }
}
