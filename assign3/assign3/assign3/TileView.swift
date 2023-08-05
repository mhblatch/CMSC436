//
//  TileView.swift
//  assign3
//
//  Created by Mei-An Blatchford on 4/14/22.
//
import SwiftUI
import Foundation

struct TileView: View {
    var tile = Tile(val: 0, id: 0, row: 0, col: 0)
    
    init(tile: Tile) {
        self.tile = tile
    }
    func changeBkColor(color: Int) -> Color{
        if(color == 0)
        {
            return Color.white
        }
        else if(color == 1)
        {
            return Color(0x56CFE1);
        }
        else if(color == 2)
        {
            return Color(0x4EA8DE);
        }else if(color == 3)
        {
            return Color(0x5E60CE);
        }
        else
        {
            return Color(0x6930C3);
        }
    }
    var body: some View {
        Text("\(tile.val)")
            .frame(width: 50, height: 50)
            .background(changeBkColor(color: tile.val))
        
    }

}

extension Color {
  init(_ hex: UInt, alpha: Double = 1) {
    self.init(
      .sRGB,
      red: Double((hex >> 16) & 0xFF) / 255,
      green: Double((hex >> 8) & 0xFF) / 255,
      blue: Double(hex & 0xFF) / 255,
      opacity: alpha
    )
  }
}
