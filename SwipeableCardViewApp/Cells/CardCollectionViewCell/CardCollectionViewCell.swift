//
//  CardViewCollectionViewCell.swift
//  SwipeableCardViewApp
//
//  Created by Never Mind on 16/04/22.
//

import UIKit
import Gemini

class CardCollectionViewCell: GeminiCell {
    
    //MARK:- DECLARE @IBOUTLET HERE
    @IBOutlet weak var customShadowView: UIView!
    @IBOutlet var labelText: UILabel!
    @IBOutlet var imgBackground: UIImageView!
    
    override var shadowView: UIView? {
        return customShadowView
    }
    
}
