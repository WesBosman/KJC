//
//  VehicleImage.swift
//  Kids Joy Center
//
//  Created by Wes Bosman on 3/28/17.
//  Copyright © 2017 Wes Bosman. All rights reserved.
//

import UIKit

class VehicleImage: UIImageView {
    var imageView: UIImageView = UIImageView()
    var name:      String      = String()
    var startingPoint: CGPoint = CGPoint()
    
    init(imageView: UIImageView, name: String){
        self.imageView = imageView
        self.name = name
        super.init(image: imageView.image)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func sendImageBackToStart(){
        UIView.animateKeyframes(withDuration: 2, delay: 0,
                                options: .calculationModePaced,
                                animations: {Void in
                                    self.center = self.startingPoint
        }, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touched Image")
        let touch = touches.first
        if let location = touch?.location(in: self.superview){
            
            // Get the touched point and set is as starting point
            let start = self.center
            self.startingPoint = start
            print("Point Touched in image \(location.x) , \(location.y)")
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self.superview){
            
            // Get the new point to move the image to
            let point = CGPoint(x: location.x, y: location.y)
            self.center = point
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Touches Ended in image")
        let touch = touches.first
        if let location = touch?.location(in: self.superview){
            
            // Get the new point to move the image to
            let point = CGPoint(x: location.x, y: location.y)
            self.center = point
            
            if self.name.hasPrefix("Air"){
                print("This image is an air vehicle")
                
                if let skyPath = Globals.skyShape.path{
                    if skyPath.contains(self.center){
                        print("Successfully Placed Air vehicle!")
                        Globals.playSuccessSound()
                        Globals.sortingCorrect += 1
                        Globals.correctCount = SortingViewController.count
                        
                    }
                    else{
                        print("This is the wrong spot for an air vehicle")
                        Globals.playErrorSound()
                        sendImageBackToStart()
                    }
                }
                
            }
            else if self.name.hasPrefix("Land"){
                print("This image is a land vehicle")
                
                if let landPath = Globals.landShape.path{
                    if landPath.contains(self.center){
                        print("Successfully Placed Land vehicle!")
                        Globals.playSuccessSound()
                        Globals.sortingCorrect += 1
                        Globals.correctCount = SortingViewController.count
                        
                    }
                    else{
                        print("This is the wrong spot for a land vehicle")
                        Globals.playErrorSound()
                        sendImageBackToStart()
                    }
                }
                
            }
            else if self.name.hasPrefix("Boat"){
                print("This image is a boat")
                
                if let waterPath = Globals.waterShape.path{
                    if waterPath.contains(self.center){
                        print("Successfully Placed Boat vehicle!")
                        Globals.playSuccessSound()
                        Globals.sortingCorrect += 1
                        Globals.correctCount = SortingViewController.count
                        
                        
                    }
                    else{
                        print("This is the wrong spot for a boat vehicle")
                        Globals.playErrorSound()
                        sendImageBackToStart()
                    }
                }
            }
        }
    }
}
