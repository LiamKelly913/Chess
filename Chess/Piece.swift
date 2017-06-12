//
//  Piece.swift
//  Chess
//
//  Created by Liam Kelly on 6/12/17.
//  Copyright © 2017 LiamKelly. All rights reserved.
//

import Foundation
import UIKit

class Piece {
    
    let type:String?
    let color:String?
    
    var boardLocation:[Int] = [Int]()
    var screenLocation:CGPoint = CGPoint()
    
    init(type:String, color:String) {
        self.type = type
        self.color = color
    }
    
    
}
