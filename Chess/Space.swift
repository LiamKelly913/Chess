//
//  Space.swift
//  Chess
//
//  Created by Liam Kelly on 6/12/17.
//  Copyright © 2017 LiamKelly. All rights reserved.
//

import Foundation
import UIKit

class Space {
    var boardLocation:[Int] = [Int]()
    var screenLocation:CGPoint = CGPoint()
    var occupiedBy:Piece?
    
    
    init(boardLocation:[Int], screenLocation:CGPoint) {
        self.boardLocation = boardLocation
        self.screenLocation = screenLocation
    }
    
    func isOccupied() -> Bool {
        if occupiedBy != nil {
            return true
        } else {
            return false
        }
    }
    
    
}
