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
        
        mutating func isOccupied() -> Bool {
            if(piece.type == "") { return false } else { return true }
        }
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
    
    
    
    /* returns all possible moves for a specified piece
     *      ex. a2 pawn (at [7][0]) with a black piece it can capture will return:
     *          [[6,0],[6,1]]
     */
    func movesForPiece(piece:Piece, position:[Int]) -> [[Int]] {
        
        let row = position[0]
        let col = position[1]
        
        var allPlayableSpaces:[[Int]]
        
        switch piece.type {
            
        case "Pawn":
            // Pawns are the only pieces that both move in only one direction or move differently to capture
            (piece.color == "black") ? (allPlayableSpaces = [[1 + row,col]]) : (allPlayableSpaces = [[-1 + row,col]])
            allPlayableSpaces = checkForPawnCapture(position: [row,col], color: piece.color, playableSpaces: allPlayableSpaces)
            
        case "Knight":
            allPlayableSpaces = [
                    [2 + row,1 + col],[2  + row,-1 + col],
                    [1 + row,2 + col],[1 + row,-2 + col],
                    [-2 + row,1 + col],[-2 + row,-1 + col],
                    [-1 + row,2 + col],[-1 + row,-2 + col]
                   ]
            
        case "Rook":
            return [[[0][0]]]
            
        case "Bishop":
            return [[[0][0]]]
            
        case "King":
            allPlayableSpaces = [
                    [-1 + row,-1 + col],[-1 + row,col],[-1 + row,1 + col],
                    [row,-1 + col],/******************/[row,1 + col],
                    [1 + row,-1 + col], [1 + row,col], [1 + row,1 + col]
                   ]
            
        case "Queen":
            return [[[0][0]]]
        
        default:
            return [[[0][0]]]
        }
        
        // deletes all spaces that land outside the board
        allPlayableSpaces = cleanPlayableSpaces(currentPositions: allPlayableSpaces)
        
        return allPlayableSpaces
    
    
    }
    
    // Check if the pawn chosen can take an opposing piece
    func checkForPawnCapture(position:[Int], color:String, playableSpaces:[[Int]]) -> [[Int]] {
        var newPlayableSpaces = playableSpaces
        let row = position[0]
        let col = position[1]
        
        if color == "black" {
            // If there is a white piece at 1,1 or 1,-1 from the pawn, then add to playable spaces
            if (board[row + 1][col + 1].piece.color == "White") {
                newPlayableSpaces.append([row+1,col+1])
            }
            if (board[row + 1][col - 1].piece.color == "White") {
                newPlayableSpaces.append([row+1,col-1])
            }
            
        } else {
            // If there is a black piece at -1,-1 or -1,1 from the pawn, then add to playable spaces
            if (board[row - 1][col - 1].piece.color == "Black") {
                newPlayableSpaces.append([row-1,col-1])
            }
            if (board[row - 1][col + 1].piece.color == "Black") {
                newPlayableSpaces.append([row-1,col+1])
            }
        }
        return newPlayableSpaces
    }
    
    // delete all positions that land outside the board
    func cleanPlayableSpaces(currentPositions:[[Int]]) -> [[Int]] {
        var newPositions = currentPositions
        var index = 0
        for position in newPositions {
            print(position)
            if (position[0] > 8 || position[0] < 0 || position[1] > 8 || position[1] < 0) {
                newPositions.remove(at: index)
            } else {
                index+=1
            }
        }
        return newPositions
    }

    
}
