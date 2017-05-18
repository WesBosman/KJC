//
//  HighScoreList.swift
//  Kids Joy Center
//
//  Created by Wes Bosman on 3/28/17.
//  Copyright © 2017 Wes Bosman. All rights reserved.
//

import UIKit

// Highscore object to store in User Defaults
class HighScore: NSObject, NSCoding{
    var order: Int
    var score: Int
    var difficulty: String
    var game:       String
    
    init(order: Int, score: Int, diff: String, game: String){
        self.order = order
        self.score = score
        self.difficulty = diff
        self.game = game
    }
    
    required convenience init(coder aDecoder: NSCoder){
        let order = aDecoder.decodeInteger(forKey: "order")
        let score = aDecoder.decodeInteger(forKey: "score")
        let difficulty  = aDecoder.decodeObject(forKey: "difficulty") as! String
        let game  = aDecoder.decodeObject(forKey: "game") as! String
        self.init(order: order, score: score, diff: difficulty , game: game)
    }
    
    func encode(with aCoder: NSCoder){
        aCoder.encode(order, forKey: "order")
        aCoder.encode(score, forKey: "score")
        aCoder.encode(difficulty,  forKey: "difficulty")
        aCoder.encode(game,  forKey: "game")
    }
    
}

// This highscore list should be able to be saved in user defaults
class HighScoreList {
    static let sharedInstance = HighScoreList()
    var highScores: [HighScore] = [HighScore]()
    let key = "HighScoreKey"
    let defaults = UserDefaults.standard

    func addHighScore(highScore: HighScore){
        if highScores.count <= 5{
            highScores.append(highScore)
            let encodedData = NSKeyedArchiver.archivedData(withRootObject: highScores)
            UserDefaults.standard.set(encodedData, forKey: key)
        }
        else{
            print("Trying to add too many high scores!")
        }
        
    }
    
    func getList() ->[HighScore]?{
        // retrieving a value for a key
        if let data = UserDefaults.standard.data(forKey: key),
        let myHighScoreList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [HighScore]{
            return myHighScoreList
        }
        else {
            return nil
        }
    }
    
    
    
}
