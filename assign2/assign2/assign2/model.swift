//
//  model.swift
//  assign2
//
//  Created by Mei-An Blatchford on 3/28/22.
//


import Foundation

enum Direction{
    case up
    case down
    case left
    case right
}

//var board: [[Int]]
//var score:  = <#initializer#>Int

class Triples: ObservableObject {
    @Published public var board: [[Int]]  // array of array of ints
    @Published public var score: Int
    var seededGenerator = SeededGenerator(seed: 14)
    init(){

        self.board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
        self.score = 0
        
    }
    func newgame(rand: Bool) {
        if(rand){
            self.board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
            self.score = 0
            self.seededGenerator = SeededGenerator(seed: UInt64(Int.random(in:1...1000)))
        }else{
            self.board = Array(repeating: Array(repeating: 0, count: 4), count: 4)
            self.score = 0
            self.seededGenerator = SeededGenerator(seed: 14)
        }
    }                   // re-inits 'board', and any other state you define
    
    
    func spawn(){
        var empty: [(Int, Int)] = []
        for i in 0...3 {
            for j in 0...3{
                if (self.board[i][j] == 0){
                    empty.append((i,j))
                }
            }
        }
        let value = Int.random(in: 1...2, using: &self.seededGenerator)
        print(value)
        
        let replace = Int.random(in: 0...(empty.count - 1), using: &self.seededGenerator)
        print(replace)
        let (x, y) = empty[replace]
        print( (x,y))
        empty.removeAll()
        self.board[x][y] = value
        self.score = value + score
        
    }
    func rotate() {
        //first col becomes first row
        
        var temp: Int
        let length = self.board.count;
        for i in 0..<length{
            for j in 0..<i{
                temp = self.board[i][j]
                self.board[i][j] = self.board[j][i]
                self.board[j][i] = temp
            }
        }
        for k in 0..<4{
            for l in 0..<length/2{
                temp = self.board[k][l]
                self.board[k][l] = self.board[k][length - l - 1]
                self.board[k][length - l - 1] = temp
            }
        }
    }                    // rotate a square 2D Int array clockwise
    
    func shift() { //collapse each row to the left
        // combined 2+1, 3+3 if the result if mod 3 == 0
        //then add rightmost element to be zero
        var j = 0
        for i in 0..<4{
            j = 0
            while j < 3{
                if(board[i][j] == 0){
                    //shift board down
                    var k = j
                    while k < 3{
                        board[i][k] = board[i][k+1]
                        k = k + 1
                    }
                    board[i][k] = 0
                    j = 4
                }else if(board[i][j] + board[i][j+1] == 3){
                    board[i][j] = 3
                    self.score = score + 3
                    var k = j + 1
                    while k < 3{
                        board[i][k] = board[i][k + 1]
                        k = k + 1
                    }
                    board[i][k] = 0
                    j =  4
                    
                }else if((board[i][j] == board[i][j+1]) && board[i][j] >= 3){
                    board[i][j] = board[i][j] * 2 //set value to double
                    board[i][j + 1] = 0
                    var k = j + 1
                    self.score = score + (board[i][j] * 2)
                    while k < 3{
                        board[i][k] = board[i][k + 1]
                        k = k + 1
                    }
                    board[i][k] = 0
                    j =  4
                }
                j = j + 1
                
            }
        }
        
    }                     // collapse to the left
    func collapse(dir: Direction) {    // collapse in specified direction using shift() and rotate()
        switch dir {
            case .left:
                self.shift()
            case .right:
                self.rotate()
                self.rotate()
                self.shift()
                self.rotate()
                self.rotate()
            case .up:
                self.rotate()
                self.rotate()
                self.rotate()
                self.shift()
                self.rotate()
            case .down:
                self.rotate()
                self.shift()
                self.rotate()
                self.rotate()
                self.rotate()
        }
    }

}
public func rotate2DInts(input: [[Int]]) -> [[Int]] {
    var result = input
    var temp: Int
    let length = result.count;
    for i in 0..<length{
        for j in 0..<i{
            temp = result[i][j]
            result[i][j] = result[j][i]
            result[j][i] = temp
        }
    }
    for k in 0..<4{
        for l in 0..<length/2{
            temp = result[k][l]
            result[k][l] = result[k][length - l - 1]
            result[k][length - l - 1] = temp
        }
    }
    return result
}


public func rotate2D<T>(input: [[T]]) -> [[T]] {
    var result = input
    var temp: T
    let length = result.count;
    for i in 0..<length{
        for j in 0..<i{
            temp = result[i][j]
            result[i][j] = result[j][i]
            result[j][i] = temp
        }
    }
    for k in 0..<4{
        for l in 0..<length/2{
            temp = result[k][l]
            result[k][l] = result[k][length - l - 1]
            result[k][length - l - 1] = temp
        }
    }
    return result
}


