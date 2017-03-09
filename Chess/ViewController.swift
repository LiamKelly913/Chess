//
//  ViewController.swift
//  Chess
//
//  Created by Liam Kelly on 3/6/17.
//  Copyright © 2017 LiamKelly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    // checks for whether or not you can castle. These are changed after a move is
    // played that removes castling from your playable list.
    var blackKingSideCastle:Bool = true
    var blackQueenSideCastle:Bool = true
    var whiteKingSideCastle:Bool = true
    var whiteQueenSideCastle:Bool = true

    let board:Board = Board()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        board.boardSetup()
        board.printPositions()
        board.printBoard()
        

        
        // CHANGE THESE TO TEST DIFFERENT PIECES AND POSSIBLE MOVES
        // Knight must be called 'Night'
        let type:String = "Rook"
        let color:String = "Black"
        let position:[Int] = [4,6]
        
        
        let piece = Board.Piece(type: type, color: color)
       // board.printBoardWithPossibleMoves(playableSpaces: board.movesForPiece(piece: piece, position: position))
        
        
        let moves:Moves = Moves()
        
        let movesForPiece = moves.movesForPiece(boardObject: board, piece: piece, position: position)
        
        board.printBoardWithPossibleMoves(playableSpaces: movesForPiece)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //TODO: Picking up / selecting piece should highlight playable areas (something like movesForPiece(sender, position) -> [[positions to highlight]])
    //TODO: Putting piece down in playable area should prompt next move
    

}

