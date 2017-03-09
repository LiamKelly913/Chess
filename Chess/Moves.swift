//
//  Moves.swift
//  Chess
//
//  Created by Liam Kelly on 3/9/17.
//  Copyright © 2017 LiamKelly. All rights reserved.
//

import Foundation

class Moves {
    

    
    func movesForPiece(boardObject:Board, piece:Board.Piece, position:[Int]) -> [[Int]] {
        let whitePieces = boardObject.whitePieceLocations
        let blackPieces = boardObject.blackPieceLocations
        
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
            // If pawn was on its original row, let it move two spaces forward
            if(piece.color == "Black" && row == 1) {
                allPlayableSpaces.append([row+2,col])
            } else if (piece.color == "White" && row == 6) {
                allPlayableSpaces.append([row-2,col])
            }
            allPlayableSpaces = checkForPawnCapture(boardObject: boardObject, position: [row,col], color: piece.color, playableSpaces: allPlayableSpaces)
        case "Night":
            allPlayableSpaces = [
                [2 + row,1 + col],[2  + row,-1 + col],
                [1 + row,2 + col],[1 + row,-2 + col],
                [-2 + row,1 + col],[-2 + row,-1 + col],
                [-1 + row,2 + col],[-1 + row,-2 + col]
            ]
            
        case "Rook":
            allPlayableSpaces = horizontalVertical(boardObject: boardObject, position: [row,col], color: piece.color)
            
        case "Bishop":
            allPlayableSpaces = diagonal(boardObject: boardObject, position: [row,col], color: piece.color)
            
        case "King":
            allPlayableSpaces = [
                [-1 + row,-1 + col],[-1 + row,col],[-1 + row,1 + col],
                [row,-1 + col],/******************/[row,1 + col],
                [1 + row,-1 + col], [1 + row,col], [1 + row,1 + col]
            ]
            // deletes all spaces that land outside the board and spaces occupied by friendly pieces
            
            
        case "Queen":
            allPlayableSpaces = queenMoves(boardObject: boardObject, position: [row,col], color: piece.color)
            
        default:
            return [[0,0]]
        }
        
        // Remove positions out of bounds / on top of friendly pieces if the piece has a set number of spots it can move
        if(piece.type != "Rook" && piece.type != "Night" && piece.type != "Bishop" && piece.type != "Queen") {
            allPlayableSpaces = cleanPlayableSpaces(blackPieceLocations: blackPieces, whitePieceLocations: whitePieces, currentPositions: allPlayableSpaces, color: piece.color)
        }
        
        print("these are playable spaces for a " + piece.color + " " + piece.type + " on " + String(describing: position))
        print(allPlayableSpaces)
        
        return allPlayableSpaces
    }
    
    
    // Check if the pawn chosen can take an opposing piece
    func checkForPawnCapture(boardObject:Board, position:[Int], color:String, playableSpaces:[[Int]]) -> [[Int]] {
        var newPlayableSpaces = playableSpaces
        let row = position[0]
        let col = position[1]
        
        let board = boardObject.board
        
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
    func cleanPlayableSpaces(blackPieceLocations:[[Int]], whitePieceLocations:[[Int]], currentPositions:[[Int]], color:String) -> [[Int]] {
        
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
    
    func horizontalVertical(boardObject:Board, position:[Int], color:String) -> [[Int]] {
        var board = boardObject.board
        var horizontalVerticle:[[Int]] = [[]]
        var openLane:Bool = true
        var indexToAdd:Int = 1 + position[0]
        
        // Below rook
        if (indexToAdd > 7) {
            openLane = false
        }
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
        if (indexToAdd < 0) {
            openLane = false
        }
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
        if (indexToAdd > 7) {
            openLane = false
        }
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
        if (indexToAdd < 0) {
            openLane = false
        }
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
    
    // Adds any playable spaces in a diagonal line to an array. Used for
    // Bishops and Queens.
    func diagonal(boardObject:Board, position:[Int], color:String) -> [[Int]] {
        var board = boardObject.board
        var diagonalMoves:[[Int]] = [[]]
        var openLane:Bool = true
        var rowToAdd:Int = position[0] + 1
        var columnToAdd:Int = position[1] + 1
        
        // Bottom right of piece
        if(rowToAdd > 7 || columnToAdd > 7) {
            openLane = false
        }
        while(openLane) {
            if(board[rowToAdd][columnToAdd].isOccupied()) {
                if(board[rowToAdd][columnToAdd].getColor() != color) {
                    diagonalMoves.append([rowToAdd, columnToAdd])
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
        
        
        
        // Top right of piece
        openLane = true
        rowToAdd = position[0] - 1
        columnToAdd = position[1] + 1
        if(rowToAdd < 0 || columnToAdd > 7) {
            openLane = false
        }
        while(openLane) {
            if(board[rowToAdd][columnToAdd].isOccupied()) {
                if(board[rowToAdd][columnToAdd].getColor() != color) {
                    diagonalMoves.append([rowToAdd, columnToAdd])
                    openLane = false
                } else {
                    openLane = false
                }
            } else {
                diagonalMoves.append([rowToAdd,columnToAdd])
                if (rowToAdd > 0  && columnToAdd < 7) {
                    rowToAdd-=1
                    columnToAdd+=1
                } else {
                    openLane = false
                }
            }
        }
        
        
        
        
        // Bottom left of piece
        openLane = true
        rowToAdd = position[0] + 1
        columnToAdd = position[1] - 1
        if(rowToAdd > 7 || columnToAdd < 0) {
            openLane = false
        }
        while(openLane) {
            if(board[rowToAdd][columnToAdd].isOccupied()) {
                if(board[rowToAdd][columnToAdd].getColor() != color) {
                    diagonalMoves.append([rowToAdd, columnToAdd])
                    openLane = false
                } else {
                    openLane = false
                }
            } else {
                diagonalMoves.append([rowToAdd,columnToAdd])
                if (rowToAdd < 7  && columnToAdd > 0) {
                    rowToAdd+=1
                    columnToAdd-=1
                } else {
                    openLane = false
                }
            }
        }
        
        
        // Top left of piece
        openLane = true
        rowToAdd = position[0] - 1
        columnToAdd = position[1] - 1
        if(rowToAdd < 0 || columnToAdd < 0) {
            openLane = false
        }
        while(openLane) {
            if(board[rowToAdd][columnToAdd].isOccupied()) {
                if(board[rowToAdd][columnToAdd].getColor() != color) {
                    diagonalMoves.append([rowToAdd, columnToAdd])
                    openLane = false
                } else {
                    openLane = false
                }
            } else {
                diagonalMoves.append([rowToAdd,columnToAdd])
                if (rowToAdd > 0  && columnToAdd > 0) {
                    rowToAdd-=1
                    columnToAdd-=1
                } else {
                    openLane = false
                }
            }
        }
        return diagonalMoves
    }
    
    // Uses horizontal + vertical function to return playable spaces
    func queenMoves(boardObject:Board, position:[Int], color:String) -> [[Int]] {

        let queenMoves = diagonal(boardObject: boardObject, position: position, color: color) + horizontalVertical(boardObject: boardObject, position: position, color: color)
        return queenMoves
    }
    
    
    // checks if the rook can castle
    func checkForCastle(position:[Int], color:String) -> [Int] {
        let row = position[0]
        let col = position[1]
        var castleTo:[Int] = []
        
        if(color == "Black" && row == 0 && col == 0) {
            castleTo = [0,4]
            
        }
        
        
        return castleTo
    }
    
}
