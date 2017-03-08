//
//  Board.swift
//  Chess
//
//  Created by Liam Kelly on 3/6/17.
//  Copyright © 2017 LiamKelly. All rights reserved.
//

import Foundation

class Board {
    
    /* Checking for checkmate could call 'movesForPiece' on all pieces, if King position == any of the returned values, then checkmate
     * This could also be used to prevent a piece from being moved (call it when the piece is selected, pretend it's not there and see if
     * there is a checkmate
     */
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
        
        mutating func getColor() -> String {
            if self.isOccupied() {
                return self.piece.color
            } else {
                return "Unnocupied"
            }
        }
    }
    
    var blackPieceLocations:[[Int]] = [[]]
    var whitePieceLocations:[[Int]] = [[]]
    
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
            blackPieceLocations.append([0,col])
            board[0][col].piece.color = "Black"
            board[1][col].piece.type = "Pawn"
            blackPieceLocations.append([1,col])
            board[1][col].piece.color = "Black"
            
            
            board[7][backIndex].piece.type = backLine[col]
            whitePieceLocations.append([7,col])
            board[7][backIndex].piece.color = "White"
            board[6][col].piece.type = "Pawn"
            whitePieceLocations.append([6,col])
            board[6][col].piece.color = "White"
            
            col+=1
            backIndex-=1
        }
        print(blackPieceLocations)
        print()
        print(whitePieceLocations)
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
    
    // Update board array for when a piece has been played
    func playMove() {
     
        //TODO: update list of color locations
    }
    
    
    /* 
     * returns all possible moves for a specified piece
     *      ex. a2 pawn (at [7][0]) with a black piece it can capture will return:
     *          [[6,0],[6,1]]
     */
    func movesForPiece(piece:Piece, position:[Int]) -> [[Int]] {
        
        let row = position[0]
        let col = position[1]
        
        var allPlayableSpaces:[[Int]]
        
        /* 
         * Any piece that can move a set amount each turn has the viable moves updated
         * to remove all positions it can't go to (out of bounds, friendly pieces).
         */
        
        switch piece.type {
            
        case "Pawn":
            // Pawns are the only pieces that both move in only one direction or move differently to capture
            (piece.color == "Black") ? (allPlayableSpaces = [[1 + row,col]]) : (allPlayableSpaces = [[-1 + row,col]])
            allPlayableSpaces = checkForPawnCapture(position: [row,col], color: piece.color, playableSpaces: allPlayableSpaces)
            allPlayableSpaces = cleanPlayableSpaces(currentPositions: allPlayableSpaces, color: piece.color)
            
        case "Knight":
            allPlayableSpaces = [
                    [2 + row,1 + col],[2  + row,-1 + col],
                    [1 + row,2 + col],[1 + row,-2 + col],
                    [-2 + row,1 + col],[-2 + row,-1 + col],
                    [-1 + row,2 + col],[-1 + row,-2 + col]
                   ]
            // deletes all spaces that land outside the board and spaces occupied by friendly pieces
            allPlayableSpaces = cleanPlayableSpaces(currentPositions: allPlayableSpaces, color: piece.color)
            
        case "Rook":
            allPlayableSpaces = horizontalVertical(position: [row,col], color: piece.color)
            
        case "Bishop":
            allPlayableSpaces = diagonal(position: [row,col], color: piece.color)
            
        case "King":
            allPlayableSpaces = [
                    [-1 + row,-1 + col],[-1 + row,col],[-1 + row,1 + col],
                    [row,-1 + col],/******************/[row,1 + col],
                    [1 + row,-1 + col], [1 + row,col], [1 + row,1 + col]
                   ]
            // deletes all spaces that land outside the board and spaces occupied by friendly pieces
            allPlayableSpaces = cleanPlayableSpaces(currentPositions: allPlayableSpaces, color: piece.color)
            
            
        case "Queen":
            allPlayableSpaces = queenMoves(position: [row,col], color: piece.color)
        
        default:
            return [[0,0]]
        }
        
        
      
        print("these are playable spaces for " + piece.type + " on " + String(describing: position))
        print(allPlayableSpaces)

        return allPlayableSpaces
    
    
    }
    
    // Check if the pawn chosen can take an opposing piece
    func checkForPawnCapture(position:[Int], color:String, playableSpaces:[[Int]]) -> [[Int]] {
        var newPlayableSpaces = playableSpaces
        let row = position[0]
        let col = position[1]
        
        if color == "Black" {
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
    
    // delete all positions that land outside the board or on friendly pieces
    func cleanPlayableSpaces(currentPositions:[[Int]], color:String) -> [[Int]] {
        
        var newPositions = currentPositions
        var index = 0
        var wasRemoved:Bool = false
        for position in newPositions {
            if (position[0] > 7 || position[0] < 0 || position[1] > 7 || position[1] < 0) {
                newPositions.remove(at: index)
            }  else {
                index+=1
            }
        }
        
        index = 0
        if color == "Black" {
            for position in newPositions {
                wasRemoved = false
                for blackLocation in blackPieceLocations {
                    if position == blackLocation {
                        newPositions.remove(at: index)
                        wasRemoved = true
                    }
                }
                if wasRemoved == false {
                    index+=1
                }
            }
        }
        
        index = 0
        if color == "White" {
            for position in newPositions {
                wasRemoved = false
                for whiteLocation in whitePieceLocations {
                    if position == whiteLocation {
                        newPositions.remove(at: index)
                        wasRemoved = true
                    }
                }
                if wasRemoved == false {
                    index+=1
                }
            }
        }
        return newPositions
    }
    
    func horizontalVertical(position:[Int], color:String) -> [[Int]] {
        var horizontalVerticle:[[Int]] = [[]]
        var openLane:Bool = true
        var indexToAdd:Int = 1 + position[0]
        
        // Below rook
        while(openLane) {
            // Adds viable moves below rook until it hits an edge or a piece it can take
            if(board[indexToAdd][position[1]].isOccupied()) {
                if(board[indexToAdd][position[1]].getColor() != color) {
                    horizontalVerticle.append([indexToAdd,position[1]])
                    openLane = false
                } else {
                    openLane = false
                }
            } else {
                horizontalVerticle.append([indexToAdd, position[1]])
                if (indexToAdd < 7) {
                    indexToAdd+=1
                } else {
                    openLane = false
                }
            }
        }
        
        // Above rook
        openLane = true
        indexToAdd = position[0] - 1
        while(openLane) {
            // Adds viable above rook until it hits an edge or a piece it can take
            if(board[indexToAdd][position[1]].isOccupied()) {
                if(board[indexToAdd][position[1]].getColor() != color) {
                    horizontalVerticle.append([indexToAdd,position[1]])
                    openLane = false
                } else {
                    openLane = false
                }
            } else {
                horizontalVerticle.append([indexToAdd, position[1]])
                if (indexToAdd > 0) {
                    indexToAdd-=1
                } else {
                    openLane = false
                }
            }
        }
        
        
        // Right of rook
        openLane = true
        indexToAdd = position[1] + 1
        while(openLane) {
            // Adds viable above rook until it hits an edge or a piece it can take
            if(board[position[0]][indexToAdd].isOccupied()) {
                if(board[position[0]][indexToAdd].getColor() != color) {
                    horizontalVerticle.append([position[0],indexToAdd])
                    openLane = false
                } else {
                    openLane = false
                }
            } else {
                horizontalVerticle.append([position[0],indexToAdd])
                if (indexToAdd < 7) {
                    indexToAdd+=1
                } else {
                    openLane = false
                }
            }
        }
        
        // Left of rook
        openLane = true
        indexToAdd = position[1] - 1
        while(openLane) {
            // Adds viable above rook until it hits an edge or a piece it can take
            if(board[position[0]][indexToAdd].isOccupied()) {
                if(board[position[0]][indexToAdd].getColor() != color) {
                    horizontalVerticle.append([position[0],indexToAdd])
                    openLane = false
                } else {
                    openLane = false
                }
            } else {
                horizontalVerticle.append([position[0],indexToAdd])
                if (indexToAdd > 0) {
                    indexToAdd-=1
                } else {
                    openLane = false
                }
            }
        }
        
        return horizontalVerticle
    }
    
    func diagonal(position:[Int], color:String) -> [[Int]] {
        var diagonalMoves:[[Int]] = [[]]
        var openLane:Bool = true
        var rowToAdd:Int = position[0] + 1
        var columnToAdd:Int = position[1] + 1
        
        // Bottom right of piece
        while(openLane) {
            if(board[rowToAdd][columnToAdd].isOccupied()) {
                if(board[rowToAdd][columnToAdd].getColor() != color) {
                    diagonalMoves.append([rowToAdd,columnToAdd])
                    openLane = false
                } else {
                    openLane = false
                }
            } else {
                diagonalMoves.append([rowToAdd,columnToAdd])
                if (rowToAdd < 7 && columnToAdd < 7) {
                    rowToAdd+=1
                    columnToAdd+=1
                } else {
                    openLane = false
                }
            }
            
        }
        
        
        
        
        
        
        return diagonalMoves
    }
    
    func queenMoves(position:[Int], color:String) -> [[Int]] {

        let queenMoves = diagonal(position: position, color: color) + horizontalVertical(position: position, color: color)
        return queenMoves
    }

    
}
