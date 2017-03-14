//
//  ViewController.swift
//  Chess
//
//  Created by Liam Kelly on 3/6/17.
//  Copyright © 2017 LiamKelly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    struct UISpace {
        var button:UIButton
        var location:CGPoint
        var piece:Board.Piece
    }
    
    //TODO: Check if piece can be picked up (to prevent a piece pinned on the king from being picked up)
        // Run getMoves for every piece on the board without the piece in question. If King is hit, don't allow interaction 
        // with that piece
    
    
    // checks for whether or not you can castle. These are changed after a move is
    // played that removes castling from your playable list.
    var blackKingSideCastle:Bool = true
    var blackQueenSideCastle:Bool = true
    var whiteKingSideCastle:Bool = true
    var whiteQueenSideCastle:Bool = true

    var alreadyToggled:Bool = false
    var board:Board = Board()
    let moves:Moves = Moves()
    
    var possibleMoveLocations:[UIImageView] = []
    
    
    @IBOutlet weak var boardView:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        board.boardSetup()
        createBoard()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // create the dimensions and starting point for the board
    func createBoard() {
        
        //Set up dimensions and origin of board
        let sideLength = self.view.frame.width
        let startingPoint = (self.view.frame.height - sideLength)/2
        boardView.frame.size.width = sideLength
        boardView.frame.size.height = sideLength
        boardView.frame.origin = CGPoint(x: 0, y: startingPoint)
        
        //Set up array of space positions for board
        board.attachSpaceLocations(startingPoint: boardView.frame.origin, width: sideLength)
        
        
        //Create array of UIPieces
        
        
        
        for row in board.board {
            for space in row {
                // Add tapped on piece function
                space.piece.button.addTarget(self, action: #selector(tappedOnPiece(sender:)), for: UIControlEvents.touchUpInside)
            }
        }
    }
    
    // TODO: This will crash if assets aren't available
    func createButton(named:String) -> UIButton {
        let size = self.view.frame.height/8
        let square = CGRect(x: 0, y: 0, width: size , height: size)
        let button = UIButton(frame: square)
        button.imageView?.image = UIImage(named: named)
        
        
        return button
    }
    
    func tappedOnPiece(sender:UIButton) {
        let pieceOrigin = sender.frame.origin
        let piece = board.getPieceByLocation(location: pieceOrigin)
        if(alreadyToggled == true) {
            toggleOffOptions()
        }
       // toggleOptionsForPiece(piece:piece, location:)
        alreadyToggled = true
        
        
    }
    
    
    func toggleOptionsForPiece(piece:Board.Piece) {
        // create squares to highlight, add them to possibleMoveLocation array, make them playable
        let coordinates = moves.movesForPiece(boardObject: board, piece: piece, position: [])
    }
    
    func toggleOffOptions() {
        for option in possibleMoveLocations {
            option.removeFromSuperview()
        }
    }
    

    func updateBackBoard() {

    }
    
    
    
    
    
    
    

}

