//
//  Moves.swift
//  Chess
//
//  Created by Liam Kelly on 3/9/17.
//  Copyright © 2017 LiamKelly. All rights reserved.
//

import Foundation

/*
 *  Moves takes in a board state, piece, and location and returns all playable positions
 *  for that piece in that board state
 */
class Moves {
    
    //TODO: Implement Castling
    //TODO: En Pessent
    // for weird pawn capture: When getting moves for a pawn that moves 2 spaces, save the first 
    // space in front of it to a capture array, check during movesForPawn. 
    // en pessent only lasts for one move.
    var enPessent:Bool = false
    var enPessentPos:[Int] = [Int]()
    var enPessentColor:String = String()
    
    func movesForPiece(boardObject:Board, piece:Board.Piece, position:[Int]) -> [[Int]] {
        let whitePieces = boardObject.whitePieceLocations
        let blackPieces = boardObject.blackPieceLocations
        
        let row = position[0]
        let col = position[1]
        
        var allPlayableSpaces:[[Int]] = [[Int]]()
        
        
        /*
         * Any piece that can move a set amount each turn has the viable moves updated
         * to remove all positions it can't go to (out of bounds, friendly pieces).
         */
        
        switch piece.type {
            
        case "Pawn":
            allPlayableSpaces = movesForPawn(boardObject: boardObject, piece: piece, position: position, color: piece.color, white: whitePieces, black:blackPieces)
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
        
        case "Queen":
            allPlayableSpaces = queenMoves(board: boardObject, position: [row,col], color: piece.color)
            
        default:
            return [[0,0]]
        }
        
        // Remove positions out of bounds / on top of friendly pieces if the piece has a set number of spots it can move
        if(piece.type != "Rook"  && piece.type != "Bishop" && piece.type != "Queen") {
            allPlayableSpaces = cleanPlayableSpaces(blackPieceLocations: blackPieces, whitePieceLocations: whitePieces, currentPositions: allPlayableSpaces, color: piece.color)
        }
        
        return allPlayableSpaces
    }
    
    // Returns all playable positions for a pawn
    func movesForPawn(boardObject:Board, piece:Board.Piece, position:[Int], color:String, white:[[Int]], black:[[Int]]) -> [[Int]] {
        var allPlayableSpaces = [[Int]]()
        let row = position[0]
        let col = position[1]
        
        // Pawns are the only pieces that both move in only one direction or move differently to capture
        if (piece.color == "Black" && (row + 1 < 7)) {
            if (!boardObject.board[1 + row][col].isOccupied) {
                allPlayableSpaces = [[1 + row,col]]
            }
        } else if (piece.color == "White" && (row - 1 > 0)) {
            if (!boardObject.board[-1 + row][col].isOccupied) {
                allPlayableSpaces = [[-1 + row,col]]
            }
        }
    
        // If pawn was on its original row, let it move two spaces forward
        if(piece.color == "Black" && row == 1 && boardObject.board[row+1][col].isOccupied == false && boardObject.board[row+2][col].isOccupied == false) {
            allPlayableSpaces.append([row+2,col])
        } else if (piece.color == "White" && row == 6 && boardObject.board[row-1][col].isOccupied == false && boardObject.board[row-2][col].isOccupied == false) {
            allPlayableSpaces.append([row-2,col])
        }
        allPlayableSpaces = checkForPawnCapture(boardObject: boardObject, position: [row,col], color: piece.color, playableSpaces: allPlayableSpaces)
        
        return allPlayableSpaces
    }
    
    // Check if the pawn chosen can take an opposing piece
    func checkForPawnCapture(boardObject:Board, position:[Int], color:String, playableSpaces:[[Int]]) -> [[Int]] {
        var newPlayableSpaces = playableSpaces
        let row = position[0]
        let col = position[1]
        
        let board = boardObject.board
        
        // Check if can capture en pessent
        if color == "Black" && row != 7 {
            if(enPessent) {
                if enPessentColor == "White" {
                    if(enPessentPos == [row + 1, col + 1]) {
                        newPlayableSpaces.append([row + 1, col + 1])
                    } else if (enPessentPos == [row + 1, col - 1]) {
                        newPlayableSpaces.append([row + 1,col - 1])
                    }
                }
            }
            
            // If there is a white piece at 1,1 or 1,-1 from the pawn, then add to playable spaces
            if(col != 7 && board[row + 1][col + 1].piece.color == "White") {
                newPlayableSpaces.append([row+1,col+1])
            }
            if (col != 0 && board[row + 1][col - 1].piece.color == "White") {
                newPlayableSpaces.append([row+1,col-1])
            }
        } else if row != 0 {
            
            if(enPessent) {
                if enPessentColor == "Black" {
                    if(enPessentPos == [row - 1, col + 1]) {
                        newPlayableSpaces.append([row - 1, col + 1])
                    } else if (enPessentPos == [row - 1, col - 1]) {
                        newPlayableSpaces.append([row - 1,col - 1])
                    }
                }
            }
            // If there is a black piece at -1,-1 or -1,1 from the pawn, then add to playable spaces
            if (col != 0 && board[row - 1][col - 1].piece.color == "Black") {
                newPlayableSpaces.append([row-1,col-1])
            }
            if (col != 7 && board[row - 1][col + 1].piece.color == "Black") {
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
        var sameColor:[[Int]]
        
        // Removes positions that land outside the board
        for position in newPositions {
            if (position[0] > 7 || position[0] < 0 || position[1] > 7 || position[1] < 0) {
                newPositions.remove(at: index)
            }  else {
                index+=1
            }
        }
        
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
        
        var lineArray:[[Int]] = [[Int]]()
        
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
            if(board[rowToAdd][columnToAdd].isOccupied) {
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
    
    // Create a new board to test against, remove the piece in question and
    // test all possible moves by opposing color, return false if King is attacked
    //TODO: Implement function to prevent piece from moving into checkmate
    func noCheckmate(piece:Board.Piece, board:Board) -> Bool {
        var noCheckmate:Bool = true
        let color = piece.color
        let newBoard = board
        var kingPosition:[Int] = [Int]()
        
        var spacesHit:[[Int]] = [[Int]]()
        var piecesToCheck:[[Int]] = [[Int]]()
        var row = 0
        var col = 0
        // remove the piece from the board and get the King's position
        for Row in board.board {
            for _ in Row {
                if ((board.board[row][col].piece.type == piece.type) && (board.board[row][col].piece.color == piece.color)) {
                    newBoard.board[row][col].isOccupied = false
                    newBoard.board[row][col].piece.color = ""
                    newBoard.board[row][col].piece.type = ""
                }
                if ((board.board[row][col].piece.type == "King") && (board.board[row][col].piece.color == piece.color)) {
                    kingPosition = board.board[row][col].piece.currentPos
                }
                col+=1
            }
            col = 0
            row+=1
        }
        row = 0
        col = 0
        
        if color == "Black" {
            piecesToCheck = newBoard.blackPieceLocations
        } else {
            piecesToCheck = newBoard.whitePieceLocations
        }
        
        // get all positions hit from the opposing color
        for position in piecesToCheck {
                spacesHit+=movesForPiece(boardObject: newBoard, piece: newBoard.board[position[0]][position[1]].piece, position: position)
        }
        
        for space in spacesHit {
            if space == kingPosition {
                noCheckmate = false
            }
        }
        return noCheckmate
    }
}
