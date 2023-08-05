//
//  ContentView.swift
//  assign2
//
//  Created by Mei-An Blatchford on 3/28/22.
//

import SwiftUI
enum Mode : String, CaseIterable, Identifiable {
    case random, deterministic
    var id: Self { self }
}
    
struct ContentView: View {
    @EnvironmentObject var myboard: Triples
    @State private var selectedMode: Mode = .random
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
                Text(String(myboard.board[0][0])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[0][0]))
                Text(String(myboard.board[0][1])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[0][1]))
                Text(String(myboard.board[0][2])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[0][2]))
                Text(String(myboard.board[0][3])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[0][3]))
            }.padding(10)
            HStack(alignment: .top) {
                Text(String(myboard.board[1][0])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[1][0]))
                Text(String(myboard.board[1][1])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[1][1]))
                Text(String(myboard.board[1][2])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[1][2]))
                Text(String(myboard.board[1][3])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[1][3]))
            }.padding(10)
            HStack(alignment: .top) {
                Text(String(myboard.board[2][0])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[2][0]))
                Text(String(myboard.board[2][1])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[2][1]))
                Text(String(myboard.board[2][2])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[2][2]))
                Text(String(myboard.board[2][3])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[2][3]))
            }.padding(10)
            HStack(alignment: .top) {
                Text(String(myboard.board[3][0])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[3][0]))
                Text(String(myboard.board[3][1])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[3][1]))
                Text(String(myboard.board[3][2])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[3][2]))
                Text(String(myboard.board[3][3])).frame(width: 50, height: 50).background(changeBkColor(color: myboard.board[3][3]))
            }.padding(10)
        }.padding(.top, 20).frame(
            minWidth: 100,
            maxWidth: 400,
            minHeight: 0,
            maxHeight: 400
          )
        VStack {
            Spacer().frame(height: 100)
            Button(
              "Up",
              action: {
                print("Up button clicked")
                  myboard.collapse(dir: .up)
                  myboard.spawn()
              }
            ).buttonStyle(.bordered)
            HStack{
                Button(
                  "Left",
                  action: {
                      print("Left button clicked")
                      myboard.collapse(dir: .left)
                      myboard.spawn()
                  }
                ).buttonStyle(.bordered)
                Spacer().frame(width: 100)
                Button(
                  "Right",
                  action: {
                      print("Right button clicked")
                      myboard.collapse(dir: .right)
                      myboard.spawn()
                  }
                ).buttonStyle(.bordered)
            }.padding()
            Button(
              "Down",
              action: {
                  print("Down button clicked")
                  myboard.collapse(dir: .down)
                  myboard.spawn()
              }
            ).buttonStyle(.bordered)
            Button(
              "New Game",
              action: {
                  print("New Game button clicked")
                  print(String(myboard.score))
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
              }
            ).buttonStyle(.bordered)
            Text("Score: " + String(myboard.score))
            Picker("Mode", selection: $selectedMode) {
                    ForEach(Mode.allCases) {  mode in
                        Text(mode.rawValue.capitalized)
                    }
            }.pickerStyle(.segmented).frame(maxHeight: .infinity, alignment: .bottom)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Triples())
    }
}

func changeBkColor(color: Int) -> Color
{
    if(color == 0)
    {
        return Color.clear;
    }
    else if(color == 1)
    {
        return Color.purple;
    }
    else if(color == 2)
    {
        return Color.pink;
    }else if(color == 3)
    {
        return Color.red;
    }
    else
    {
        return Color.blue;
    }
}


