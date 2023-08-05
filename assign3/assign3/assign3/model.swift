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
struct Tile: Equatable {
    var val : Int
    var id : Int
    var row: Int    // recommended
    var col: Int    // recommended
}

struct Score: Hashable, Equatable{
    var score: Int
    var time: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
    }
    
    init(score: Int, time: Date) {
        self.score = score
        self.time = time
    }
}

class Triples: ObservableObject {
    @Published public var board: [[Tile?]]  // array of array of ints
    @Published public var score: Int
    @Published public var isOver: Bool
    @Published public var scoreList: [Score]
    var id = 1;
    var seededGenerator = SeededGenerator(seed: 14)
    let currentDateTime = Date()
    init(){
        self.board = [[Tile?]](repeating: [Tile?](repeating: nil, count: 4), count: 4)
        self.isOver = false
        self.score = 0
        self.scoreList = []
        for i in 0...3{
            for j in 0...3{
                self.board[i][j] = Tile(val: 0, id: self.id, row: i, col: j)
                self.id += 1
            }
        }
        self.scoreList.append(Score(score: 200, time: currentDateTime))
        self.scoreList.append(Score(score: 300, time: currentDateTime))
        
    }
    func newgame(rand: Bool) {
        self.isOver = true
        self.isGameOver()
        if(rand){
            self.board = [[Tile?]](repeating: [Tile?](repeating: nil, count: 4), count: 4)
            self.id = 1
            for i in 0...3{
                for j in 0...3{
                    self.board[i][j] = Tile(val: 0, id: self.id, row: i, col: j)
                    self.id += 1
                }
            }
            self.score = 0
            self.seededGenerator = SeededGenerator(seed: UInt64(Int.random(in:1...1000)))
            self.isOver = false
        }else{
            self.board = [[Tile?]](repeating: [Tile?](repeating: nil, count: 4), count: 4)
            self.id = 1
            for i in 0...3{
                for j in 0...3{
                    self.board[i][j] = Tile(val: 0, id: self.id, row: i, col: j)
                    self.id += 1
                }
            }
            self.score = 0
            self.seededGenerator = SeededGenerator(seed: 14)
            self.isOver = false
        }
    }                   // re-inits 'board', and any other state you define
    
    func isGameOver() -> Bool{
        let currentDateTime = Date()
        if self.isOver  && self.score != 0 {
            self.scoreList.append(Score(score: self.score, time: currentDateTime))
        }
        print("GAME IS OVER")
        self.scoreList = self.scoreList.sorted(by: { $0.score > $1.score })
        return self.isOver
    }
    func flipIsOver(){
        self.isOver = !self.isOver
    }
    func getTile(tid: Int) -> Tile{
        var tile: Tile = Tile(val: 0, id: 0, row: 0, col: 0)
        for i in 0...3{
            for j in 0...3{
                if board[i][j]!.id == tid{
                    tile = board[i][j]!
                }
            }
        }
        return tile
    }
    func spawn(){
        var empty: [(Int, Int)] = []
        for i in 0...3 {
            for j in 0...3{
                if (self.board[i][j]!.val == 0){
                    empty.append((i,j))
                }
            }
        }
        let value = Int.random(in: 1...2, using: &self.seededGenerator)
        print(value)
        if empty.count == 0 {
            let tempBoard = self.board
            self.collapse(dir: .left)
            self.collapse(dir: .right)
            self.collapse(dir: .up)
            self.collapse(dir: .down)
            var notequal = false
            for i in 0...3{
                for j in 0...3{
                    if tempBoard[i][j] != self.board[i][j]{
                        notequal = true
                        break;
                    }
                }
            }
            if(notequal){
                self.board = tempBoard
                self.isOver = false
            }else{
                self.isOver = true
            }
        }else{
            let replace = Int.random(in: 0...(empty.count - 1), using: &self.seededGenerator)
            print(replace)
            let (x, y) = empty[replace]
            print( (x,y))
            empty.removeAll()
            self.board[x][y]?.val = value
            self.score = value + score
        }
        
    }
    func rotate() {
        //first col becomes first row
        
        var temp: Int
        let length = self.board.count;
        for i in 0..<length{
            for j in 0..<i{
                temp = self.board[i][j]!.val
                self.board[i][j]!.val = self.board[j][i]!.val
                self.board[j][i]!.val = temp
            }
        }
        for k in 0..<4{
            for l in 0..<length/2{
                temp = self.board[k][l]!.val
                self.board[k][l]!.val = self.board[k][length - l - 1]!.val
                self.board[k][length - l - 1]!.val = temp
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
                if(board[i][j]!.val == 0){
                    //shift board down
                    var k = j
                    while k < 3{
                        board[i][k]!.val = board[i][k+1]!.val
                        k = k + 1
                    }
                    board[i][k]!.val = 0
                    j = 4
                }else if(board[i][j]!.val + board[i][j+1]!.val == 3){
                    board[i][j]!.val = 3
                    //self.score = score + 3
                    var k = j + 1
                    while k < 3{
                        board[i][k]!.val = board[i][k + 1]!.val
                        k = k + 1
                    }
                    board[i][k]!.val = 0
                    j =  4
                    
                }else if((board[i][j]!.val == board[i][j+1]!.val) && board[i][j]!.val >= 3){
                    board[i][j]!.val = board[i][j]!.val * 2 //set value to double
                    board[i][j + 1]!.val = 0
                    var k = j + 1
                    //self.score = score + (board[i][j]!.val * 2)
                    while k < 3{
                        board[i][k]!.val = board[i][k + 1]!.val
                        k = k + 1
                    }
                    board[i][k]!.val = 0
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
        var sum = 0
        for i in 0...3{
            for j in 0...3{
                let tile = board[i][j]
                sum += tile!.val
            }
        }
        self.score = sum
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


