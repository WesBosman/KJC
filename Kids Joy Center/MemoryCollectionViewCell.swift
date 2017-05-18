//
//  MemoryCollectionViewCell.swift
//  Kids Joy Center
//
//  Created by Wes Bosman on 3/21/17.
//  Copyright © 2017 Wes Bosman. All rights reserved.
//

import UIKit

struct NumberImage{
    var imageView: UIImageView
    var name:  String
}
struct AnimalImage{
    var image: UIImage
    var name:  String
}

class MemoryCollectionViewCell: UICollectionViewCell {
    var name: String = String()
    var backView: UIImageView!  = UIImageView()
    var frontView: UIImageView! = UIImageView()
    var showingFront            = false
    
    override func awakeFromNib() {
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.frontView.clipsToBounds = true
        self.backView.clipsToBounds  = true
        self.frontView.frame  = self.frame
        self.frontView.center = self.center
        self.backView.frame   = self.frame
        self.backView.center  = self.center
        contentView.addSubview(frontView)
        contentView.addSubview(backView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func flipCard(){
        // Showing front of card
        if showingFront{
            print("Flipping animal cart to back")
            
            UIView.transition(from: frontView,
                              to:   backView,
                              duration: 0.5,
                              options: .transitionFlipFromLeft,
                              completion: nil)
            showingFront = false
        }
        // Showing back of card
        else{
            print("Flipping animal card to front")
            // Need to set the frame so the front image is in the same spot
            let front = frontView!
            front.frame = (self.backgroundView?.frame)!
            
            UIView.transition(from: backView,
                              to:   front,
                              duration: 0.5,
                              options: .transitionFlipFromRight,
                              completion: nil)
            showingFront = true
        }
    }
}
