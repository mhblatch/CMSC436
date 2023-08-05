//
//  Scores.swift
//  assign3
//
//  Created by Mei-An Blatchford on 4/17/22.
//

import Foundation
import SwiftUI

struct Scores: View{
    @EnvironmentObject var myboard: Triples
    let dateformat = DateFormatter()
    
    func format(d: Date)-> String{
        dateformat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formatted = dateformat.string(from: d)
        return formatted
        
    }
    var body: some View{
        VStack{
            VStack{
                List(){
                    ForEach(0...myboard.scoreList.count-1, id: \.self){ i in
                        HStack{
                            Text("\(myboard.scoreList[i].score)")
                            Spacer()
                            let date = myboard.scoreList[i].time
                            Text(format(d: date))
                        }
                    }
                }
            }
        }
    }
}
