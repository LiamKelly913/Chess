//
//  Board.swift
//  Chess
//
//  Created by Liam Kelly on 3/7/17.
//  Copyright © 2017 LiamKelly. All rights reserved.
//

import Foundation
//
//  Board.swift
//  Chess
//
//  Created by Liam Kelly on 3/6/17.
//  Copyright © 2017 LiamKelly. All rights reserved.
//

import Foundation

class Board {
    
    struct Piece {
        var type:String = ""
        var color:String = ""
        
    }
    
    struct Space {
        var position:String = ""
        var piece:Piece
    }
    
    var board = Array(repeating: Array(repeating: Space(position: "", piece: Piece()), count: 8), count: 8)
    
    let columns = ["a","b","c","d","e","f","g","h"]
    
    let backLine = ["Rook","Knight","Bishop","Queen","King","Bishop","Knight","Rook"]
    
    func boardSetup() {
        setupSpaces()
        setupPieces()
    }
    
    // setup spaces to reference on board (a1,a2,a3)
    func setupSpaces() {
        var row = 0
        var col = 0
        var calledRow = 8
        for _ in 1...8 {
            for _ in 1...8 {
                board[row][col].position = columns[col] + String(calledRow)
                col+=1
            }
            col = 0
            row+=1
            calledRow-=1
        }
    }
    
    // Set up beginning state of board
    func setupPieces() {
        var col = 0
        var backIndex = 7
        for _ in 1...8 {
            board[0][col].piece.type = backLine[col]
            board[0][col].piece.color = "Black"
            board[1][col].piece.type = "Pawn"
            board[1][col].piece.color = "Black"
            
            
            board[7][backIndex].piece.type = backLine[col]
            board[7][backIndex].piece.color = "White"
            board[6][col].piece.type = "Pawn"
            board[6][col].piece.color = "White"
            
            col+=1
            backIndex-=1
        }
    }
    
    func printPositions() {
        print()
        var row = 0
        var col = 0
        for _ in 1 ... 8 {
            for _ in 1 ... 8 {
                print(board[row][col].position + " ", terminator: "")
                col += 1
            }
            print()
            col = 0
            row+=1
        }
        print()
    }
    
    func printBoard() {
        print()
        var row = 0
        var col = 0
        for _ in 1 ... 8 {
            for _ in 1 ... 8 {
                if (board[row][col].piece.type == "") {
                    print("• ", terminator: "")
                } else {
                    print(String(board[row][col].piece.type.characters.prefix(1)) + " ", terminator: "")
                }
                col += 1
            }
            print()
            col = 0
            row+=1
        }
        print()
    }
}
