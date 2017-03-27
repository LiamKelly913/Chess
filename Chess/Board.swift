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
        var type:String = String()
        var color:String = String()
        var button:UIButton = UIButton()
        var currentPos:[Int] = [Int]()
    }
    
    //TODO: Add current space to the piece in question when generating baord
    struct Space {
        var position:String = String()
        var piece:Piece
        var location:CGPoint
        var isOccupied = false
        
        func getColor() -> String {
            if self.isOccupied {
                return self.piece.color
            } else {
                return "Unnocupied"
            }
        }
    }
    
    var blackPieceLocations:[[Int]] = [[Int]]()
    var whitePieceLocations:[[Int]] = [[Int]]()
    var deadWhite:[Piece] = [Piece]()
    var deadBlack:[Piece] = [Piece]()
    
    
    var board = Array(repeating: Array(repeating: Space(position: "", piece: Piece(), location: CGPoint(x: 0, y: 0), isOccupied: false), count: 8), count: 8)
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
        for _ in 1...8 {
            board[0][col].piece.type = backLine[col]
            blackPieceLocations.append([0,col])
            board[0][col].piece.currentPos = [0, col]
            board[0][col].isOccupied = true
            board[0][col].piece.color = "Black"
            
            board[1][col].piece.type = "Pawn"
            blackPieceLocations.append([1,col])
            board[1][col].piece.currentPos = [1, col]
            board[1][col].isOccupied = true
            board[1][col].piece.color = "Black"
            
            
            board[7][col].piece.type = backLine[col]
            whitePieceLocations.append([7,col])
            board[7][col].piece.currentPos = [7, col]
            board[7][col].isOccupied = true
            board[7][col].piece.color = "White"
            
            
            board[6][col].piece.type = "Pawn"
            whitePieceLocations.append([6,col])
            board[6][col].piece.currentPos = [6, col]
            board[6][col].isOccupied = true
            board[6][col].piece.color = "White"
            
            col+=1
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
                    break
                }
            }
        }
        return piece
    }
    
    func getRCforXY(location:CGPoint) -> [Int] {
        var RC:[Int] = [Int]()
        var row = 0
        var col = 0
        for spot in board {
            for space in spot {
                if space.location == location {
                    RC = [row,col]
                }
                col+=1
            }
            col = 0
            row+=1
        }
        return RC
    }
    
    
    func getXYForPos(pos:[Int]) -> CGPoint {
        var xy:CGPoint!
        var currRow:Int = 0
        var col:Int = 0
        for row in board {
            for space in row {
                if ([currRow,col] == pos) {
                    xy = space.location
                    break
                }
                col+=1
            }
            col = 0
            currRow+=1
        }
        if(xy != nil) {
            return xy
        } else {
            return CGPoint(x: CGFloat(1), y: CGFloat(1))
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
                if (board[row][col].isOccupied == false) {
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
                if (board[row][col].isOccupied && found == false) {
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
    
    // Removes a selected piece from its current spot to a new spot
    func movePiece(piece:Piece, to:[Int]) {
        var newPiece = piece
        var oldPos = piece.currentPos
        let row = to[0]
        let col = to[1]
        
        // this can only happen if a piece is being taken
        if(board[row][col].isOccupied) {
            let pieceToRemove = board[row][col].piece
            if(piece.color == "Black") {
                deadWhite.append(pieceToRemove)
            } else {
                deadBlack.append(pieceToRemove)
            }
        }
        newPiece.currentPos = to
        board[row][col].piece = newPiece
        board[row][col].isOccupied = true
        board[oldPos[0]][oldPos[1]].isOccupied = false
        board[oldPos[0]][oldPos[1]].piece.color = ""
        
        if(piece.color == "Black") {
            blackPieceLocations.append(to)
            blackPieceLocations = blackPieceLocations.filter() {$0 != oldPos}
        } else {
            whitePieceLocations.append(to)
            whitePieceLocations = whitePieceLocations.filter() {$0 != oldPos}
        }
    }
    
    
    // Prints the board state w/ a T if the board position is occupied
    func printOccupiedBoard() {
        var row = 0
        var col = 0
        for _ in 1 ... 8 {
            for _ in 1 ... 8 {
                if (board[row][col].isOccupied == false) {
                    print("• ", terminator: "")
                } else {
                    print("T ", terminator: "")
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


