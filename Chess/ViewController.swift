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
    //TODO: Add a 'lost pieces' view
    //TODO: Add move history
    //TODO: Add 'undo'
    
    // checks for whether or not you can castle. These are changed after a move is
    // played that removes castling from your playable list.
    var blackKingSideCastle:Bool = true
    var blackQueenSideCastle:Bool = true
    var whiteKingSideCastle:Bool = true
    var whiteQueenSideCastle:Bool = true

    var alreadyToggled:Bool = false
    var board:Board = Board()
    let moves:Moves = Moves()
    var selectedPiece:Board.Piece = Board.Piece()
    var selectedButton:UIButton = UIButton()
    
    var possibleMoveLocations:[UIButton] = []
    var piecesOnBoard:[UIButton] = []
    
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

        //Set up dimensions and origin of board, add 'remove highlights' if board is tapped
        let sideLength = self.view.frame.width
        let startingPoint = (self.view.frame.height - sideLength)/2
        boardView.frame.size.width = sideLength
        boardView.frame.size.height = sideLength
        boardView.frame.origin = CGPoint(x: 0, y: startingPoint)
        boardView.image = UIImage(named: "Board")
        boardView.isUserInteractionEnabled = true
        let tapOnBoard = UITapGestureRecognizer(target: self, action: #selector(toggleOffOptions))
        boardView.addGestureRecognizer(tapOnBoard)
        
        //Set up array of space positions for board
        board.attachSpaceLocations(startingPoint: boardView.frame.origin, width: sideLength)
        
        var row = 0
        var col = 0
        for Row in board.board {
            for space in Row {
                // Add 'tapped on piece' function to each button
                if(space.isOccupied) {
                    let button = UIButton()
                    button.addTarget(self, action: #selector(tappedOnPiece(sender:)), for: UIControlEvents.touchUpInside)
                    button.frame = getSquareForScreen(pos: [row,col])
                    let assetName = space.piece.color + space.piece.type
                    button.setImage(UIImage(named: assetName), for: UIControlState())
                    piecesOnBoard.append(button)
                    view.addSubview(button)
                }
                col+=1
            }
            col = 0
            row+=1
        }
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
        selectedPiece = piece
        selectedButton = sender
        
        if(alreadyToggled == true) {
            toggleOffOptions()
        }
        toggleOptionsForPiece(piece: piece)
        alreadyToggled = true
    }
    
    
    func toggleOptionsForPiece(piece:Board.Piece) {
        // create squares to highlight, add them to possibleMoveLocation array, make them playable
        let coordinatesToHighlight = moves.movesForPiece(boardObject: board, piece: piece, position: piece.currentPos)
        for rc in coordinatesToHighlight {
            createHighlightForPos(pos: rc)
        }
    }
    
    // Removes all highlighted options from superview, deletes the contents of the highlightedmove array
    func toggleOffOptions() {
        for option in possibleMoveLocations {
            option.removeFromSuperview()
        }
        possibleMoveLocations.removeAll()
    }
    

    // Adds a clickable button to move a piece to
    func createHighlightForPos(pos:[Int]) {
        let rect = getSquareForScreen(pos: pos)
        let highlightedButton = UIButton(frame: rect)
        highlightedButton.setImage(UIImage(named: "Option"), for: UIControlState())

        highlightedButton.addTarget(self, action: #selector(choseHighlightedSpace(sender:)), for: UIControlEvents.touchUpInside)
        possibleMoveLocations.append(highlightedButton)
        view.addSubview(highlightedButton)
    }
    
    
    
    // attached to the highlighted spaces, updates board state and animates piece moving
    func choseHighlightedSpace(sender:UIButton) {
        toggleOffOptions()
        
        let endOrigin:CGPoint = sender.frame.origin
        let endPos:[Int] = board.getRCforXY(location: endOrigin)
        if board.getPieceByLocation(location: endOrigin).type != "" {
            for button in piecesOnBoard {
                if button.frame.origin == endOrigin {
                    button.removeFromSuperview()
                }
            }
        }
        // updates board state
        selectedPiece.button.frame.origin = CGPoint(x: CGFloat(300), y: CGFloat(300))
        board.movePiece(piece: selectedPiece, to: endPos)
        board.printBoard()
        UIView.animate(withDuration: 0.5) { 
            self.selectedButton.frame.origin = self.board.getXYForPos(pos: endPos)
        }
        
        board.printOccupiedBoard()
    }

}

