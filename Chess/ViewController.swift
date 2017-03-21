//
//  ViewController.swift
//  Chess
//
//  Created by Liam Kelly on 3/6/17.
//  Copyright © 2017 LiamKelly. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
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
    
    var possibleMoveLocations:[UIButton] = []
    
    
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
        
        
        
        
        // add target action to buttons to be tapped
        for row in board.board {
            for space in row {
                // Add tapped on piece function
                space.piece.button.addTarget(self, action: #selector(tappedOnPiece(sender:)), for: UIControlEvents.touchUpInside)
            }
        }
    }
    
    // TODO: This will crash if assets aren't available
    func createButton(named:String, location:CGPoint) -> UIButton {
        let side = self.view.frame.height/8
        let size = CGSize(width: side, height: side)
        let rect = CGRect(origin: location, size: size)
        let button = UIButton(frame: rect)
        button.imageView?.image = UIImage(named: named)
        
        
        return button
    }
    
    
    func getSquareForScreen(pos:[Int]) -> CGRect {
        let side = self.view.frame.width / 8
        let size = CGSize(width: side, height: side)
        let rect = CGRect(origin: board.getXYForPos(pos: pos), size: size)
        
        return rect
    }
    
    func tappedOnPiece(sender:UIButton) {
        let pieceOrigin = sender.frame.origin
        let piece = board.getPieceByLocation(location: pieceOrigin)
        if(alreadyToggled == true) {
            toggleOffOptions()
        }
        toggleOptionsForPiece(piece: piece)
        alreadyToggled = true
        
        
    }
    
    
    func toggleOptionsForPiece(piece:Board.Piece) {
        // create squares to highlight, add them to possibleMoveLocation array, make them playable
        let coordinatesToHighlight = moves.movesForPiece(boardObject: board, piece: piece, position: piece.currentPos)
        for xy in coordinatesToHighlight {
            createHighlightForPos(pos: xy)
            // TODO: change background for this space (add square to highlight)
        }
    }
    
    // Removes all highlighted options from superview, deletes the contents of the highlightedmove array
    func toggleOffOptions() {
        for option in possibleMoveLocations {
            option.removeFromSuperview()
        }
        possibleMoveLocations.removeAll()
    }
    

    //TODO: This own't work if 'Option' asset isn't loaded
    func createHighlightForPos(pos:[Int]) {
        let rect = getSquareForScreen(pos: pos)
        let highlightedButton = UIButton(frame: rect)
        highlightedButton.imageView?.image = UIImage(named: "Option")
        possibleMoveLocations.append(highlightedButton)
    }
    
    
    
    //TODO: write function to attach to highlighted playable spaces
    func choseHighlightedSpace(sender:UIButton) {
        
        // update current baord state, animate piece moving to space
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    

}

