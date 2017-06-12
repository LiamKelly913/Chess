//
//  AI.swift
//  Chess
//
//  Created by Liam Kelly on 6/12/17.
//  Copyright © 2017 LiamKelly. All rights reserved.
//

import Foundation

/// An AI object will be instantiated with a difficulty level and a baord object.
/// Depending on the difficulty selected, the decision made will use one of three
/// move-choosing methods.
/// The data returned will be an array of Ints, with index 0 corresponding to the index location it was chosen from,
/// with the following 2 values corresponding to row and col to move to
///      ex.    [4,2,5] 
///           piece,row,col
class AI {
    
    //TODO: Find a way to store pieces and possible locations for piece (board pieces aren't hashable)
    var currentBoard:Board?
    let difficulty:String?
    var decision:[Int] = [Int]()
    init(difficulty:String) {
        self.difficulty = difficulty
    }
    

    func getMoveForState(currentBoard:Board) ->  [Int] {
        self.currentBoard = currentBoard
        switch difficulty! {
        case "easy":
            return easyAI()
        case "difficult" :
            return mediumAI()
        default:
            return hardAI()
        }
    }
    
    //TODO: Print out both the board object being passed in's memory location, and the one stored here. Make sure they are IDENTICAL, so the piece chosen can be referenced when returned
    
    //Functions needed to make these work (required from board or game class)
    // * get all possible moves (return a list of piece and space options)
    // * make one move without updating actual game
    // * take back move
    
    
    /// Returns a random move from all possible moves
    func easyAI() -> [Int] {
        // get all options for all pieces
        let choices:[[[Int]]] = currentBoard!.getAllBlackOptions()
        // return a random index from that array as the decision
        let randPiece = Int(arc4random_uniform(UInt32(choices.count)))
        let randIndex = Int(arc4random_uniform(UInt32(choices[randPiece].count)))
        var randLoc = choices[randPiece][randIndex]
        // This should work but it's not appending correctly for some reason
        decision = randLoc.append(randPiece)
        return decision
    }

    
    
    /// Returns a move that will yield the biggest piece advantage. If no pieces
    /// can be captured then it makes a random move.
    func mediumAI() ->  [Int] {
        
        return decision
    }
    
    
    func hardAI() ->  [Int] {
        
        return decision
    }
}
