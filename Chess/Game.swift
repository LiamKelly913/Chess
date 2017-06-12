//
//  Game.swift
//  Chess
//
//  Created by Liam Kelly on 6/12/17.
//  Copyright © 2017 LiamKelly. All rights reserved.
//

import Foundation

class Game {
    
    // for AI testing purposes
    let DIFFICULTIES = ["easy","medium","hard"]
    var board:Board?

    var deadWhite:[Piece]?
    var deadBlack:[Piece]?
    
    init(board:Board) {
        self.board = board
    }
    

}
