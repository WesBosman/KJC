//
//  BalloonViewController.swift
//  Kids Joy Center
//
//  Created by Wes Bosman on 3/19/17.
//  Copyright © 2017 Wes Bosman. All rights reserved.
//
import UIKit
import AVFoundation

class BalloonViewController: UIViewController {
    let balloonColors: [UIImage] = [UIImage(named:"BalloonRed")!,
                                    UIImage(named:"BalloonPink")!,
                                    UIImage(named:"BalloonBlue")!,
                                    UIImage(named:"BalloonBlack")!,
                                    UIImage(named:"BalloonBrown")!,
                                    UIImage(named:"BalloonWhite")!,
                                    UIImage(named:"BalloonGreen")!,
                                    UIImage(named:"BalloonYellow")!,
                                    UIImage(named:"BalloonPurple")!,
                                    UIImage(named:"BalloonOrange")!]
    
    var balloonNumbers: [NumberImage] = [Globals.imageOne,
                                         Globals.imageTwo,
                                         Globals.imageThree,
                                         Globals.imageFour,
                                         Globals.imageFive,
                                         Globals.imageSix,
                                         Globals.imageSeven,
                                         Globals.imageEight,
                                         Globals.imageNine]
    
    let scoreImage                   = UIImage(named: "Score")!
    let timeImage                    = UIImage(named: "Time")!
    let backgroundImageView          = UIImageView(image: UIImage(named: "SkyBackground")!)
    var boxes: [CGPoint]             = []
    var gameTimer                    = Timer()
    var bonusTimer                   = Timer()
    var killerTimer                  = Timer()
    var difficulty: String           = String()
    let timeColonLabel: UILabel      = UILabel()
    let scoreImageView               = UIImageView(image: Globals.scoreImage)
    let timeImageView                = UIImageView(image: Globals.timeImage)
    var scoreDigitOne: UIImageView   = UIImageView(image: Globals.imageZero.imageView.image)
    var scoreDigitTwo: UIImageView   = UIImageView(image: Globals.imageZero.imageView.image)
    var scoreDigitThree: UIImageView = UIImageView(image: Globals.imageZero.imageView.image)
    var timeDigitOne: UIImageView    = UIImageView(image: Globals.imageZero.imageView.image)
    var timeDigitTwo: UIImageView    = UIImageView(image: Globals.imageZero.imageView.image)
    var timeDigitThree: UIImageView  = UIImageView(image: Globals.imageZero.imageView.image)
    var balloonsOnScreen: [UIImageView] = []
    var balloonAudioPlayer    = AVAudioPlayer()
    var normalBalloonDuration = 0
    var killerBalloonDuration = 0
    var bonusBalloonDuration  = 0
    var lastTenSeconds        = false
    var playerLost            = false
    var count                 = 0
    var score                 = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Set navigation title and run the game
        self.navigationItem.title = "Balloon Game"
        runGame()
    }
    
    func runGame(){
        createBoxes()
        Globals.setUpBackgroundImage(view: self.view,
                                     backgroundImageView: backgroundImageView)
        
        Globals.setUpScoreAndTimeLabels(view: self.view,
                                        timeImageView: timeImageView,
                                        timeImageMinute: timeDigitThree,
                                        timeImageTensSecond: timeDigitTwo,
                                        timeImageSecond: timeDigitOne,
                                        scoreImageView: scoreImageView,
                                        scoreImageHundred: scoreDigitThree,
                                        scoreImageTens: scoreDigitTwo,
                                        scoreImageOnes: scoreDigitOne)
        setDifficulty(level: difficulty)
    }
    
    func createBoxes(){
        // X value of the first box
        var firstX:CGFloat = 60
        
        // Create boxes
        for _ in 0..<10{
            boxes.append(CGPoint(x: firstX, y: self.view.bounds.maxY + 50))
            firstX += 100
        }
    }
    
    // HAVE TO CODE LOSING THE GAME where user does not bust balloon in last ten seconds of the game
    
    func setDifficulty(level: String){
        let bonusInterval = Double(Globals.generateRandomInt(min: 20, max: 25))
        let killerInterval = Double(Globals.generateRandomInt(min: 20, max: 25))
        
        switch(level){
        case "Easy":
            // 1 minute
            count = 60
            gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {[unowned self](timer) -> Void in
                
                // Balloons from 1 to 9
                // Speed of balloons should increase
                // 1 balloon added a second
                self.normalBalloonDuration = 7
                self.getRandomBox()
                self.updateTime()
            })
            
            // Bonus Timer
            self.bonusBalloonDuration = 5
            bonusTimer = Timer.scheduledTimer(timeInterval: bonusInterval, target: self, selector: #selector(bonusBalloon), userInfo: nil, repeats: true)
            
            // Killer Timer
            self.killerBalloonDuration = 9
            killerTimer = Timer.scheduledTimer(timeInterval: killerInterval, target: self, selector: #selector(killerBalloon), userInfo: nil, repeats: true)
            
        case "Medium":
            // 45 seconds
            count = 45
            gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer) -> Void in
                // Balloons from 1 to 7
                // Speed of balloons should increase
                // 1 or 2 balloons added with 50% chance
                self.balloonNumbers = [Globals.imageOne,
                                       Globals.imageTwo,
                                       Globals.imageThree,
                                       Globals.imageFour,
                                       Globals.imageFive,
                                       Globals.imageSix,
                                       Globals.imageSeven]
                self.normalBalloonDuration = 5
                self.getRandomBox()
                self.updateTime()
            })
            
            // Bonus Timer
            self.bonusBalloonDuration = 3
            bonusTimer = Timer.scheduledTimer(timeInterval: bonusInterval, target: self, selector: #selector(bonusBalloon), userInfo: nil, repeats: true)
            
            // Killer Timer
            self.killerBalloonDuration = 7
            killerTimer = Timer.scheduledTimer(timeInterval: killerInterval, target: self, selector: #selector(killerBalloon), userInfo: nil, repeats: true)
            
        case "Hard":
            // 30 seconds
            count = 30
            gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer) -> Void in
                // Balloons from 1 to 5
                // Speed of balloons should increase
                // Two or three balloons added with 33.3% chance
                self.balloonNumbers = [Globals.imageOne,
                                       Globals.imageTwo,
                                       Globals.imageThree,
                                       Globals.imageFour,
                                       Globals.imageFive]
                self.normalBalloonDuration = 3
                self.getRandomBox()
                self.updateTime()
            })
            
            // Bonus Timer
            self.bonusBalloonDuration = 2
            bonusTimer = Timer.scheduledTimer(timeInterval: bonusInterval, target: self, selector: #selector(bonusBalloon), userInfo: nil, repeats: true)
            
            // Killer Timer
            self.killerBalloonDuration = 5
            killerTimer = Timer.scheduledTimer(timeInterval: killerInterval, target: self, selector: #selector(killerBalloon), userInfo: nil, repeats: true)
            
        default:
            print("Default should not fire")
        }
    }
    
    func killerBalloon(){
        let randomBox = Globals.generateRandomInt(min: 0, max: boxes.count - 1)
        let box = boxes[randomBox]
        let balloonNumberImage = Globals.imageSkull
        let randomColor = Globals.generateRandomInt(min: 0,
                                             max: balloonColors.count - 1)
        let balloonColor = balloonColors[randomColor]
        let balloonImageView = UIImageView(image: balloonColor)
        balloonImageView.frame.size = CGSize(width: 100, height: 100)
        
        let numberImageView = UIImageView(image: balloonNumberImage.imageView.image)
        numberImageView.center = balloonImageView.center
        numberImageView.bounds = CGRect(origin: balloonImageView.center,
                                        size: CGSize(width: 50, height: 50))
        balloonImageView.addSubview(numberImageView)
        balloonImageView.center = box
        setBalloonTag(balloon: balloonImageView, name: balloonNumberImage.name)
        self.view.addSubview(balloonImageView)
        self.balloonsOnScreen.append(balloonImageView)
        
        // Move the newly created balloon image
        moveBalloon(balloon: balloonImageView, type: "Killer")
    }
    
    func bonusBalloon(){
        let randomBox = Globals.generateRandomInt(min: 0, max: boxes.count - 1)
        let box = boxes[randomBox]
        let balloonNumberImage = Globals.imageStar
        let randomColor = Globals.generateRandomInt(min: 0,
                                             max: balloonColors.count - 1)
        let balloonColor = balloonColors[randomColor]
        let balloonImageView = UIImageView(image: balloonColor)
        balloonImageView.frame.size = CGSize(width: 100, height: 100)
        
        let numberImageView = UIImageView(image: balloonNumberImage.imageView.image)
        numberImageView.center = balloonImageView.center
        numberImageView.bounds = CGRect(origin: balloonImageView.center,
                                        size: CGSize(width: 50, height: 50))
        balloonImageView.addSubview(numberImageView)
        balloonImageView.center = box
        setBalloonTag(balloon: balloonImageView, name: balloonNumberImage.name)
        self.view.addSubview(balloonImageView)
        self.balloonsOnScreen.append(balloonImageView)
        
        // Move the newly created balloon image
        moveBalloon(balloon: balloonImageView, type: "Bonus")
        
    }
    
    func updateTime(){
        // Update the count
        count = count - 1
        let minute = (count % 3600) / 60
        let second = (count % 3600) % 60
        print("Minute: \(minute) Seconds: \(second)")
        
        if minute == 0 && second <= 10{
            print("Last Ten Seconds")
            lastTenSeconds = true
        }
        
        Globals.updateImageForTime(timeImageMinute: timeDigitThree,
                                   timeImageTensSecond: timeDigitTwo,
                                   timeImageSecond: timeDigitOne,
                                   minute: minute, second: second)
        
        if count == 0{
            print("Game Over")
            
            // Invalidate the timers and remove the balloons from the screen
            gameTimer.invalidate()
            bonusTimer.invalidate()
            killerTimer.invalidate()
            
            for balloon in balloonsOnScreen{
                balloon.removeFromSuperview()
                if let index = balloonsOnScreen.index(of: balloon){
                    balloonsOnScreen.remove(at: index)
                }
            }
            
            // If the user lost 
            if playerLost{
                print("Player Lost")
                // User has lost
                let alert = UIAlertController(title: "Game Lost",
                                              message: "Would you like to play again?", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes",
                                              style: .default,
                                              handler: { Void in
                    // Replay the game
//                    Globals.replayBalloonGame = true
//                    self.performSegue(withIdentifier: "UnwindFromBalloon", sender: self)
                })
                let noAction = UIAlertAction(title: "No",
                                             style: .cancel,
                                             handler: { Void in
                    // Do not replay the game
                    self.performSegue(withIdentifier: "UnwindFromBalloon", sender: self)
                })
                alert.addAction(noAction)
                alert.addAction(yesAction)
                self.present(alert, animated: true, completion: nil)
            }
            // If the user did not lose
            else{
                print("Player Won!")
                // Add the score to the list of highscores
                switch(self.difficulty){
                case "Easy":
                    let order = Globals.getOrder()
                    let highScore = HighScore(order: order,
                                              score: self.score,
                                              diff:  "Easy",
                                              game:  "Balloon Game")
                    HighScoreList.sharedInstance.addHighScore(highScore: highScore)
                    
                case "Medium":
                    let order = Globals.getOrder()
                    let highScore = HighScore(order: order,
                                              score: self.score,
                                              diff:  "Medium",
                                              game:  "Balloon Game")
                    HighScoreList.sharedInstance.addHighScore(highScore: highScore)
                    
                case "Hard":
                    let order = Globals.getOrder()
                    let highScore = HighScore(order: order,
                                              score: self.score,
                                              diff:  "Hard",
                                              game:  "Balloon Game")
                    HighScoreList.sharedInstance.addHighScore(highScore: highScore)
                    
                default:
                    break
                }
                
                let alert = UIAlertController(title: "Game Over",
                                              message: "Would you like to play again?",
                                              preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "Yes",
                                              style: .default,
                                              handler: {(action) in
//                                              Globals.replayBalloonGame = true
//                                              self.performSegue(withIdentifier: "UnwindFromBalloon", sender: self)
                                              
                })
                
                let noAction = UIAlertAction(title: "No",
                                             style: .cancel,
                                             handler: {(action) in
                                             // Segue back to home view controller
                                             self.performSegue(withIdentifier: "UnwindFromBalloon",
                                                               sender: self)
                })
                
                alert.addAction(noAction)
                alert.addAction(yesAction)
                self.present(alert, animated: true, completion: nil)
            }
            
        }
    }
    
    func setBalloonTag(balloon: UIImageView, name: String){
        switch(name){
        case "NumberOne":   balloon.tag = 1
        case "NumberTwo":   balloon.tag = 2
        case "NumberThree": balloon.tag = 3
        case "NumberFour":  balloon.tag = 4
        case "NumberFive":  balloon.tag = 5
        case "NumberSix":   balloon.tag = 6
        case "NumberSeven": balloon.tag = 7
        case "NumberEight": balloon.tag = 8
        case "NumberNine":  balloon.tag = 9
        default: break
        }
    }
    
    func updateScore(balloon: UIImageView){
        switch(balloon.tag){
        case 1:   score += 1
        case 2:   score += 2
        case 3:   score += 3
        case 4:   score += 4
        case 5:   score += 5
        case 6:   score += 6
        case 7:   score += 7
        case 8:   score += 8
        case 9:   score += 9
        default:  break
        }
        
        if score < 10{
            // Only update the ones digits
            Globals.updateScoreOrTime(imageView: scoreDigitOne, number: score)
        }
        else if score >= 10 && score < 100{
            let tens = score / 10
            let ones = score % 10
            // Update tens and ones digits
            Globals.updateScoreOrTime(imageView: scoreDigitTwo,
                                      number: tens)
            Globals.updateScoreOrTime(imageView: scoreDigitOne,
                                      number: ones)
        }
        else if score >= 100{
            let hundreds = (score / 100)
            let tens     = (score % 100) / 10
            let ones     = (score % 10)

            // Update the hundreds, tens and ones digits
            Globals.updateScoreOrTime(imageView: scoreDigitThree,
                                      number: hundreds)
            Globals.updateScoreOrTime(imageView: scoreDigitTwo,
                                      number: tens)
            Globals.updateScoreOrTime(imageView: scoreDigitOne,
                                      number: ones)
        }
        
    }
    
    // Get random box for balloon
    func getRandomBox(){
        // Locations of balloons should be different if multiple are added at once
        let random = Globals.generateRandomInt(min: 0,
                                               max: boxes.count - 1)
        let box = boxes[random]
        getRandomBalloon(point: box)
    }
    
    // Get random balloon color
    func getRandomBalloon(point: CGPoint){
        let random = Globals.generateRandomInt(min: 0,
                                                max: balloonColors.count - 1)
        let balloon = balloonColors[random]
        let balloonImageView = UIImageView(image: balloon)
        balloonImageView.frame.size = CGSize(width: 100, height: 100)
        getRandomBalloonNumber(balloon: balloonImageView, point: point)
    }
    
    // Get random number and put it on the balloon
    func getRandomBalloonNumber(balloon: UIImageView, point: CGPoint){
        let random = Globals.generateRandomInt(min: 0,
                                               max: balloonNumbers.count - 1)
        let number = balloonNumbers[random]
        let numberImageView = UIImageView(image: number.imageView.image)
        numberImageView.center = balloon.center
        numberImageView.bounds = CGRect(origin: balloon.center,
                                        size: CGSize(width: 50, height: 50))
        balloon.addSubview(numberImageView)
        balloon.center = point
        setBalloonTag(balloon: balloon, name: number.name)
        self.view.addSubview(balloon)
        self.balloonsOnScreen.append(balloon)
        
        // Move the newly created balloon image
        moveBalloon(balloon: balloon, type: "Normal")
    }
    
    func moveBalloon(balloon: UIImageView, type: String){
        if type == "Normal"{
            UIView.animate(withDuration: Double(self.normalBalloonDuration),
                           delay: 0,
                           options: .allowUserInteraction,
                           animations: {
                                // Animate the view off the screen
                                balloon.frame.origin.y -= self.view.frame.maxY + CGFloat(100)
                            },
                           completion: { _ in
                            // Remove the balloon from the view
                            balloon.removeFromSuperview()
                            
                            
                            if let index = self.balloonsOnScreen.index(of: balloon){
                                self.balloonsOnScreen.remove(at: index)
                            }
            })
        }
        else if type == "Bonus"{
            UIView.animate(withDuration: Double(self.bonusBalloonDuration),
                           delay: 0,
                           options: .allowUserInteraction,
                           animations: {
                            // Animate the view off the screen
                            balloon.frame.origin.y -= self.view.frame.maxY + CGFloat(100)
            },
                           completion: { _ in
                            // Remove the balloon from the view
                            balloon.removeFromSuperview()
                            
                            
                            if let index = self.balloonsOnScreen.index(of: balloon){
                                self.balloonsOnScreen.remove(at: index)
                            }
            })
        }
        else if type == "Killer"{
            UIView.animate(withDuration: Double(self.killerBalloonDuration),
                           delay: 0,
                           options: .allowUserInteraction,
                           animations: {
                            // Animate the view off the screen
                            balloon.frame.origin.y -= self.view.frame.maxY + CGFloat(100)
            },
                           completion: { _ in
                            // Remove the balloon from the view
                            balloon.removeFromSuperview()
                            
                            
                            if let index = self.balloonsOnScreen.index(of: balloon){
                                self.balloonsOnScreen.remove(at: index)
                            }
            })
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        let location = touch?.location(in: self.view)
        
        for balloon in balloonsOnScreen{
            if balloon.layer.presentation()?.hitTest(location!) != nil{
                print("Touched balloon")
                
                // Play a balloon pop sound
                if let sound = NSDataAsset(name: "BalloonPopSound"){
                    do {
                        try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                        try AVAudioSession.sharedInstance().setActive(true)
                        
                        balloonAudioPlayer = try AVAudioPlayer(data: sound.data)
                        balloonAudioPlayer.prepareToPlay()
                        balloonAudioPlayer.play()
                    } catch let error as NSError {
                        print("Error: \(error.localizedDescription)")
                    }
                }
                
                // Remove balloon from superview
                let index = balloonsOnScreen.index(of: balloon)
                balloonsOnScreen.remove(at: index!)
                balloon.removeFromSuperview()
                
                // Add to the score
                updateScore(balloon: balloon)
                
                // If the balloon is the skull or bonus then speed up or slow down
                
                if lastTenSeconds{
                    playerLost = false
                }
            }
//            else{
//                print("No Balloon Tapped")
//                // If it is was the last ten seconds an no balloon was hit
//                if lastTenSeconds{
//                    print("Player Lost")
//                    playerLost = true
//                }
//            }
            
        }
        
//        if touch == nil{
//            print("Touch is nil")
//            if lastTenSeconds {
//                print("Last Ten Seconds is also true")
//                playerLost = true
//            }
//        }
        
    }
}
