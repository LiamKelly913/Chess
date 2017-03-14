//
//  Moves.swift
//  Chess
//
//  Created by Liam Kelly on 3/9/17.
//  Copyright © 2017 LiamKelly. All rights reserved.
//

import Foundation

class Moves {
    
    //TODO: Castling
    //TODO: Weird pawn capture thing
    
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
            allPlayableSpaces = horizontalMoves(board: boardObject, position: [row,col], color: piece.color)
            
        case "Bishop":
            allPlayableSpaces = diagonalMoves(board: boardObject, position: [row,col], color: piece.color)
            
        case "King":
            allPlayableSpaces = [
                [-1 + row,-1 + col],[-1 + row,col],[-1 + row,1 + col],
                [row,-1 + col],/******************/[row,1 + col],
                [1 + row,-1 + col], [1 + row,col], [1 + row,1 + col]
            ]
            // deletes all spaces that land outside the board and spaces occupied by friendly pieces
            
            
        case "Queen":
            allPlayableSpaces = queenMoves(board: boardObject, position: [row,col], color: piece.color)
            
        default:
            return [[0,0]]
        }
        
        // Remove positions out of bounds / on top of friendly pieces if the piece has a set number of spots it can move
        if(piece.type != "Rook"  && piece.type != "Bishop" && piece.type != "Queen") {
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
        print("Cleaning")
        var newPositions = currentPositions
        var index = 0
        var wasRemoved:Bool = false
        var sameColor:[[Int]]
        for position in newPositions {
            if (position[0] > 7 || position[0] < 0 || position[1] > 7 || position[1] < 0) {
                newPositions.remove(at: index)
            }  else {
                index+=1
            }
        }

        print(whitePieceLocations)
        print()
        print()
        (color == "Black") ? (sameColor = blackPieceLocations) : (sameColor = whitePieceLocations)
        index = 0

            for position in newPositions {
                wasRemoved = false
                for location in sameColor {
                    if position == location {
                        newPositions.remove(at: index)
                        wasRemoved = true
                    }
                }
                if wasRemoved == false {
                    index+=1
                }
            }

        return newPositions
    }
    
    // Returns all possible moves in a specified direction from one point
    func straightLine(boardObject:Board, origin:[Int], direction:String, color:String) -> [[Int]] {
        var board = boardObject.board
        var rowLimit:Int = 0
        var columnLimit:Int = 0
        var openLane:Bool = true
        var rowToAdd = origin[0]
        var columnToAdd = origin[1]
        var columnChange:Int = 0
        var rowChange:Int = 0
        
        var lineArray:[[Int]] = [[]]
        
        switch direction {
        case "Left":
            rowChange = 0
            columnChange = -1
            rowLimit = -1
            columnLimit = 0
            
            if(columnToAdd == 0) {
                openLane = false
            }
            
        case "TopLeft":
            rowChange = -1
            columnChange = -1
            rowLimit = 0
            columnLimit = 0
            
            if(rowToAdd == 0 || columnToAdd == 0) {
                openLane = false
            }
        case "Up":
            rowChange = -1
            columnChange = 0
            rowLimit = 0
            columnLimit = -1
            
            if(rowToAdd == 0) {
                openLane = false
            }
        case "TopRight":
            rowChange = -1
            columnChange = 1
            rowLimit = 0
            columnLimit = 7
            
            if(rowToAdd == 0 || columnToAdd == 7) {
                openLane = false
            }
        case "Right":
            rowChange = 0
            columnChange = 1
            rowLimit = -1
            columnLimit = 7
            
            if(columnToAdd == 7) {
                openLane = false
            }
        case "BottomRight":
            rowChange = 1
            columnChange = 1
            rowLimit = 7
            columnLimit = 7
            
            if(rowToAdd == 7 || columnToAdd == 7) {
                openLane = false
            }
        case "Down":
            rowChange = 1
            columnChange = 0
            rowLimit = 7
            columnLimit = -1
            
            if(rowToAdd == 7) {
                openLane = false
            }
        case "BottomLeft":
            rowChange = 1
            columnChange = -1
            rowLimit = 7
            columnLimit = 0
            
            if(rowToAdd == 7 || columnToAdd == 0) {
                openLane = false
            }
            
        default:
            break
        }

        while(openLane) {
            rowToAdd+=rowChange
            columnToAdd+=columnChange
            if(board[rowToAdd][columnToAdd].isOccupied()) {
                if(board[rowToAdd][columnToAdd].getColor() != color) {
                    lineArray.append([rowToAdd, columnToAdd])
                    openLane = false
                } else {
                    openLane = false
                }
            } else {
                lineArray.append([rowToAdd,columnToAdd])
                if (rowToAdd == rowLimit  || columnToAdd == columnLimit) {
                    openLane = false
                }
            }
        }
        
        return lineArray
    }
    
    func diagonalMoves(board:Board, position:[Int], color:String) -> [[Int]] {
        var diagonal = straightLine(boardObject: board, origin: position, direction: "TopLeft", color: color)
        diagonal+=straightLine(boardObject: board, origin: position, direction: "TopRight", color: color)
        diagonal+=straightLine(boardObject: board, origin: position, direction: "BottomRight", color: color)
        diagonal+=straightLine(boardObject: board, origin: position, direction: "BottomLeft", color: color)
        
        return diagonal
    }
    
    func horizontalMoves(board:Board, position:[Int], color:String) -> [[Int]] {
        var horizontal = straightLine(boardObject: board, origin: position, direction: "Left", color: color)
        horizontal+=straightLine(boardObject: board, origin: position, direction: "Up", color: color)
        horizontal+=straightLine(boardObject: board, origin: position, direction: "Right", color: color)
        horizontal+=straightLine(boardObject: board, origin: position, direction: "Down", color: color)
        
        return horizontal
    }
    
    func queenMoves(board:Board, position:[Int], color:String) -> [[Int]] {
        let queenMoves = horizontalMoves(board: board, position: position, color: color) + diagonalMoves(board: board, position: position, color: color)
        return queenMoves
        
    }
    
    
}
