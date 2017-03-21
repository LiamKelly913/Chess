//
//  Board.swift
//  Chess
//
//  Created by Liam Kelly on 3/6/17.
//  Copyright © 2017 LiamKelly. All rights reserved.
//

import Foundation
import UIKit

class Board {
    
    //TODO: Write update board function after a spot has been chosen. Takes in a location, updates the board's pieces
    
    /* Checking for checkmate could call 'movesForPiece' on all pieces, if King position == any of the returned values, then checkmate
     * This could also be used to prevent a piece from being moved (call it when the piece is selected, pretend it's not there and see if
     * there is a checkmate
     */
    
    struct Piece {
        var type:String = ""
        var color:String = ""
        var button:UIButton = UIButton()
        var currentPos:[Int] = []
    }
    
    //TODO: Add current space to the piece in question when generating baord
    struct Space {
        var position:String = ""
        var piece:Piece
        var location:CGPoint
        
        func isOccupied() -> Bool {
            if(piece.type == "") { return false } else { return true }
        }
        
        func getColor() -> String {
            if self.isOccupied() {
                return self.piece.color
            } else {
                return "Unnocupied"
            }
        }
    }
    
    var blackPieceLocations:[[Int]] = [[]]
    var whitePieceLocations:[[Int]] = [[]]
    
    
    
    var board = Array(repeating: Array(repeating: Space(position: "", piece: Piece(), location: CGPoint(x: 0, y: 0)), count: 8), count: 8)
    let columns = ["a","b","c","d","e","f","g","h"]
    
    let backLine = ["Rook","Night","Bishop","Queen","King","Bishop","Night","Rook"]
    
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
            board[0][col].piece.currentPos = [0, col]
            board[0][col].piece.color = "Black"
            board[1][col].piece.type = "Pawn"
            blackPieceLocations.append([1,col])
            board[0][col].piece.currentPos = [0, col]
            board[1][col].piece.color = "Black"
            
            
            board[7][backIndex].piece.type = backLine[col]
            whitePieceLocations.append([7,col])
            board[7][backIndex].piece.currentPos = [7, col]
            board[7][backIndex].piece.color = "White"
            board[6][col].piece.type = "Pawn"
            whitePieceLocations.append([6,col])
            board[6][col].piece.currentPos = [6, col]
            board[6][col].piece.color = "White"
            
            col+=1
            backIndex-=1
        }
    }
    
    
    // Attaches the coordinates for each space once the dimensions of the board are known
    func attachSpaceLocations(startingPoint:CGPoint, width:CGFloat) {
        let oneSpaceLength = width/8
        var currentPoint = startingPoint
        var rowIndex = 0
        var columnIndex = 0
        for _ in 1...8 {
            for _ in 1...8 {
                board[rowIndex][columnIndex].location = CGPoint(x: currentPoint.x, y: currentPoint.y)
                columnIndex+=1
                currentPoint.x+=oneSpaceLength
            }
            currentPoint.x = startingPoint.x
            currentPoint.y+=oneSpaceLength
            columnIndex = 0
            rowIndex+=1
        }
    }
    
    
    func getPieceByLocation(location:CGPoint) -> Piece {
        var piece:Piece!
        for spot in board {
            for space in spot {
                if space.location == location {
                    piece = space.piece
                }
            }
        }
        return piece
    }
    
    
    
    
    func getXYForPos(pos:[Int]) -> CGPoint {
        var xy:CGPoint?
        let test = pos
        var currRow:Int = 0
        var col:Int = 0
        for row in board {
            for space in row {
                if ([currRow,col] == test) {
                    xy = space.location
                    break
                }
                col+=1
            }
            col = 0
            currRow+=1
        }
        return xy!
        
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
    
    func printBoardWithPossibleMoves(playableSpaces:[[Int]]) {
        print()
        var index = 0
        var found = false
        var row = 0
        var col = 0
        for _ in 1 ... 8 {
            for _ in 1 ... 8 {
                // if the current space matches any space in the playable moves array, print an O
                for space in playableSpaces {
                    if ([row,col] == space) {
                        print("O" + " ", terminator: "")
                        found = true
                    }
                    index+=1
                }
                index = 0
                if (board[row][col].piece.type == "" && found == false) {
                    print("• ", terminator: "")
                } else if (found == false) {
                    print(String(board[row][col].piece.type.characters.prefix(1)) + " ", terminator: "")
                }
                col += 1
                found = false
            }
            print()
            col = 0
            row+=1
        }
        print()
    }
    
    
}

























