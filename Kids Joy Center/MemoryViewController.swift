//
//  MemoryViewController.swift
//  Kids Joy Center
//
//  Created by Wes Bosman on 3/19/17.
//  Copyright © 2017 Wes Bosman. All rights reserved.
//

import UIKit
import GameplayKit
import AVFoundation

class MemoryViewController:
    UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    
    var difficulty:String     = String()
    let backgroundImageView   = UIImageView(image: Globals.memoryBackground)
    let questionMarkImageView = UIImageView(image: Globals.questionMark)
    let scoreImageView        = UIImageView(image: Globals.scoreImage)
    let timeImageView         = UIImageView(image: Globals.timeImage)
    var timeImageMinute       = UIImageView(image: Globals.imageZero.imageView.image)
    var timeImageTensSecond   = UIImageView(image: Globals.imageZero.imageView.image)
    var timeImageSecond       = UIImageView(image: Globals.imageZero.imageView.image)
    var scoreImageHundred     = UIImageView(image: Globals.imageZero.imageView.image)
    var scoreImageTens        = UIImageView(image: Globals.imageZero.imageView.image)
    var scoreImageOnes        = UIImageView(image: Globals.imageZero.imageView.image)
    var customAnimalImages = [AnimalImage(image: UIImage(named: "MemoryCat")!,
                                          name: "MemoryCat"),
                            AnimalImage(image: UIImage(named: "MemoryDog")!,
                                        name: "MemoryDog"),
                            AnimalImage(image: UIImage(named: "MemoryLion")!,
                                        name: "MemoryLion"),
                            AnimalImage(image: UIImage(named: "MemoryBird")!,
                                        name: "MemoryBird"),
                            AnimalImage(image: UIImage(named: "MemoryHorse")!,
                                        name: "MemoryHorse"),
                            AnimalImage(image: UIImage(named: "MemoryZebra")!,
                                        name: "MemoryZebra"),
                            AnimalImage(image: UIImage(named: "MemoryMonkey")!,
                                        name: "MemoryMonkey"),
                            AnimalImage(image: UIImage(named: "MemoryRooster")!,
                                        name: "MemoryRooster"),
                            AnimalImage(image: UIImage(named: "MemoryAligator")!,
                                        name: "MemoryAligator"),
                            AnimalImage(image: UIImage(named: "MemoryGiraffe")!,
                                        name: "MemoryGiraffe")   ]

    var previousCell: MemoryCollectionViewCell? = nil
    var collectionView: UICollectionView!
    var collectionViewHeight = 650
    var collectionViewWidth  = 500
    var collectionCellWidth  = 100
    var collectionCellHeight = 150
    var numberOfCards        = 20
    let memoryCellID         = "MemoryCell"
    var animalSubset:[AnimalImage] = []
    var randomIndexes:[Int]        = []
    var gameTimer = Timer()
    var gameWon   = false
    var count     = 0
    var score     = 0
    var memoryAudioPlayer = AVAudioPlayer()
    var correctCount      = 0
    var previousCellDate: Date? = nil
    var currentCellDate:  Date? = nil
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set navigation item title, set collection view, run game
        self.navigationItem.title = "Memory Game"
        runGame()
        setUpCollectionView()
    }
    
    func runGame(){
        // Set background image and difficulty
        Globals.setUpBackgroundImage(view: self.view,
                                     backgroundImageView: backgroundImageView)
        Globals.setUpScoreAndTimeLabels(view: self.view,
                                        timeImageView: timeImageView,
                                        timeImageMinute: timeImageMinute,
                                        timeImageTensSecond:
            timeImageTensSecond,
                                        timeImageSecond: timeImageSecond,
                                        scoreImageView: scoreImageView,
                                        scoreImageHundred: scoreImageHundred,
                                        scoreImageTens: scoreImageTens,
                                        scoreImageOnes: scoreImageOnes)
        setDifficulty(level: difficulty)
    }
    
    func setUpCollectionView(){
        // Set up date formatter
        dateFormatter.dateFormat = "mm:ss"
        
        // Programatically create collection view.
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width:  collectionCellWidth,
                                 height: collectionCellHeight)
        layout.sectionInset = UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
        collectionView = UICollectionView(frame: CGRect(x: 200, y: 200, width: collectionViewWidth, height: collectionViewHeight), collectionViewLayout: layout)
        
        collectionView.dataSource = self
        collectionView.delegate   = self
        collectionView.register(MemoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: memoryCellID)
        collectionView.center = self.view.center
        collectionView.frame.origin.y = 125
        collectionView.backgroundColor = UIColor.clear
        collectionView.allowsMultipleSelection = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isScrollEnabled = false
        self.view.addSubview(collectionView)
    }

    func setDifficulty(level: String){
        switch(difficulty){
            case "Easy":
                print("Easy return 4 x 3 rows")
                numberOfCards = 12
                count = 120
                generateRandomSubset(number: numberOfCards)
                gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            
            case "Medium":
                print("Medium return 4 x 4 rows")
                numberOfCards = 16
                count = 105
                generateRandomSubset(number: numberOfCards)
                gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)

            case "Hard":
                print("Hard return 4 x 5 rows")
                numberOfCards = 20
                collectionViewWidth = 650
                count = 90
                generateRandomSubset(number: numberOfCards)
                gameTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)

            default:
                print("Should not enter default case")
        }
    }
    
    func updateTime(){
        // Update the count
        count = count - 1
        let minute = (count % 3600) / 60
        let second = (count % 3600) % 60
        
        print("Minute: \(minute) Seconds: \(second)")
        
        if gameWon{
            gameTimer.invalidate()
            
            // Add high score
            let order = Globals.getOrder()
            let highScore = HighScore(order: order, score: self.score, diff: self.difficulty, game: "Memory Game")
            HighScoreList.sharedInstance.addHighScore(highScore: highScore)
            
            
            let alert = UIAlertController(title: "You Won", message: "Would you like to play again?", preferredStyle: .alert)
            let noAction = UIAlertAction(title: "No", style: .default, handler: {Void in
                self.performSegue(withIdentifier: "UnwindFromMemory", sender: self)
            })
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: { Void in
//                Globals.replayBalloonGame = true
//                self.performSegue(withIdentifier: "UnwindFromMemory", sender: self)
            })
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }
        
        // Update the game image
        Globals.updateImageForTime(timeImageMinute: timeImageMinute,
                                   timeImageTensSecond: timeImageTensSecond,
                                   timeImageSecond: timeImageSecond,
                                   minute: minute, second: second)
        
        if count == 0{
            // Update the time image to 0:00
            let minute = (count % 3600) / 60
            let second = (count % 3600) % 60
            Globals.updateImageForTime(timeImageMinute: timeImageMinute,
                                       timeImageTensSecond: timeImageTensSecond,
                                       timeImageSecond: timeImageSecond,
                                       minute: minute, second: second)
            // Invalidate the timer
            gameTimer.invalidate()
            
            // User lost
            if !gameWon{
                let alert = UIAlertController(title: "You Lose",
                                              message: "Would you like to play again?",
                                              preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes",
                                              style: .default,
                                              handler: {(action) in
                    // Reset the Game
//                    Globals.replayMemoryGame = true
//                    self.performSegue(withIdentifier: "UnwindFromMemory", sender: self)
                })
                
                let noAction = UIAlertAction(title: "No",
                                             style: .cancel,
                                             handler: {(action) in
                    // Return to the Home Screen
                    self.performSegue(withIdentifier: "UnwindFromMemory", sender: self)
                })
                alert.addAction(noAction)
                alert.addAction(yesAction)
                self.present(alert,
                             animated: true,
                             completion: nil)
            }
            
        }

    }
    
    func generateRandomSubset(number: Int){
        // Get half of the random images
        for _ in 0..<(number / 2){
            let num = customAnimalImages.count - 1
            var randomNum = Globals.generateRandomInt(min: 0, max: num)
            while (randomIndexes.contains(randomNum)) {
                randomNum = Globals.generateRandomInt(min: 0, max: num)
            }
            
            // Get the animal Image then remove it so we don't have more than
            // One pair of the same animal
            let animal = customAnimalImages[randomNum]
            customAnimalImages.remove(at: randomNum)
            animalSubset.append(animal)
            animalSubset.append(animal)
        }
        
        // Use gameplaykit to shuffle the array 
        animalSubset = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: animalSubset) as! [AnimalImage]
    }
    
    func updateScore(currentDate: Date){
        let calendar = Calendar.current
        if let prev = previousCellDate{
            let prevComp = calendar.dateComponents([.minute, .second], from: prev)
            let currComp = calendar.dateComponents([.minute, .second], from: currentDate)
            
            if let currMin = currComp.minute,
                let currSec = currComp.second,
                let prevMin = prevComp.minute,
                let prevSec = prevComp.second{
                
                let minuteDiff = currMin - prevMin
                let secondDiff = currSec - prevSec
                
                print("Minute Diff: \(minuteDiff)")
                print("Second Diff: \(secondDiff)")
                
                if secondDiff <= 3{
                    // Add five points
                    score = score + 5
                    if score >= 10{
                        let tens = score / 10
                        let ones = score % 10
                        Globals.updateScoreOrTime(imageView: scoreImageOnes,
                                          number: ones)
                        Globals.updateScoreOrTime(imageView: scoreImageTens,
                                          number: tens)
                    }
                    else{
                        Globals.updateScoreOrTime(imageView: scoreImageOnes,
                                          number: score)
                    }
                }
                else if secondDiff <= 7{
                    // Add four points
                    score = score + 4
                    if score >= 10{
                        let tens = score / 10
                        let ones = score % 10
                        Globals.updateScoreOrTime(imageView: scoreImageOnes,
                                          number: ones)
                        Globals.updateScoreOrTime(imageView: scoreImageTens,
                                          number: tens)
                    }
                    else{
                        Globals.updateScoreOrTime(imageView: scoreImageOnes,
                                          number: score)
                    }
                }
                else if secondDiff > 7{
                    // Add three points
                    score = score + 3
                    if score >= 10{
                        let tens = score / 10
                        let ones = score % 10
                        Globals.updateScoreOrTime(imageView: scoreImageOnes,
                                          number: ones)
                        Globals.updateScoreOrTime(imageView: scoreImageTens,
                                          number: tens)
                    }
                    else{
                        Globals.updateScoreOrTime(imageView: scoreImageOnes,
                                          number: score)
                    }
                }
            }
        }
    }
    
    // MARK - Collection View Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numberOfCards
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: memoryCellID, for: indexPath) as! MemoryCollectionViewCell

        let randomAnimal     = animalSubset[indexPath.row]
        let name             = randomAnimal.name
        let front            = UIImageView(image: randomAnimal.image)
        let back             = UIImageView(image: Globals.questionMark)
        cell.frontView       = front
        cell.backView        = back
        cell.name            = name
        cell.backgroundView  = back
        cell.tag             = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionCellWidth, height: collectionCellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10,left: 10,bottom: 10,right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Item Selected at row: \(indexPath.row)")
        
        if let cell = collectionView.cellForItem(at: indexPath) as? MemoryCollectionViewCell{
            
            // Flip the collection view cell
            cell.flipCard()
            
            // Keep track of the previously selected cell
            if previousCell == nil{
                previousCell = cell
                previousCellDate = Date()
            }
            else{
                
                if let previous = previousCell{
                    
                    // The two cells are not equal
                    if previous.name != cell.name{
                        print("Did not find a matching pair")
                        
                        // Wait then flip both cards back over
                        Timer.scheduledTimer(withTimeInterval: 1,
                                             repeats: false,
                                             block: {_ in
                                            // Flip the two cards back over
                                            previous.flipCard()
                                            cell.flipCard()
                                            self.previousCell = nil
                                                
                        })
                    }
                    else{
                        // The two cards are equal leave the cards out add to the score
                        print("Found a matching pair")
                        
                        previousCell = nil
                        
                        // Play a cheer sound
                        Globals.playSuccessSound()
                        
                        // Adjust the score
                        currentCellDate = Date()
                        updateScore(currentDate: currentCellDate!)
                        
                        // Add one to the correct count
                        correctCount = correctCount + 1
                        
                        // If the player wins
                        if correctCount == numberOfCards / 2{
                            print("You Won!")
                            gameWon = true
                            
                            // Add the score to the list
                            
                            
                        }
                        
                        // Get the indexes of the previous and current cell
                        let prevIndex = IndexPath(row: previous.tag,
                                                  section: 0)
                        let currIndex = IndexPath(row: cell.tag,
                                                  section: 0)
                        
                        if let previousC = collectionView.cellForItem(at: prevIndex) as? MemoryCollectionViewCell,
                            let currentC  = collectionView.cellForItem(at: currIndex) as? MemoryCollectionViewCell{
                            print("Disable the interaction of the two cells")
                            
                            // Set user interaction to false
                            previousC.isUserInteractionEnabled = false
                            currentC.isUserInteractionEnabled  = false
                        }
                    }
                }
            }
        }
        // Deselect the collection view cell
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

