//
//  ViewController.swift
//  Kids Joy Center
//
//  Created by Wes Bosman on 3/16/17.
//  Copyright © 2017 Wes Bosman. All rights reserved.
//

import UIKit
import AVFoundation

struct Globals{
    static var imageOne   = NumberImage(imageView: UIImageView(image: UIImage(named: "NumberOne")!),
                                        name: "NumberOne")
    static var imageTwo   = NumberImage(imageView: UIImageView(image: UIImage(named: "NumberTwo")!),
                                        name: "NumberTwo")
    static var imageThree = NumberImage(imageView: UIImageView(image: UIImage(named: "NumberThree")!),
                                        name: "NumberThree")
    static var imageFour  = NumberImage(imageView: UIImageView(image: UIImage(named: "NumberFour")!),
                                        name: "NumberFour")
    static var imageFive  = NumberImage(imageView: UIImageView(image: UIImage(named: "NumberFive")!),
                                        name: "NumberFive")
    static var imageSix   = NumberImage(imageView: UIImageView(image: UIImage(named: "NumberSix")!),
                                        name: "NumberSix")
    static var imageSeven = NumberImage(imageView: UIImageView(image: UIImage(named: "NumberSeven")!),
                                        name: "NumberSeven")
    static var imageEight = NumberImage(imageView: UIImageView(image: UIImage(named: "NumberEight")!),
                                        name: "NumberEight")
    static var imageNine  = NumberImage(imageView: UIImageView(image: UIImage(named: "NumberNine")!),
                                        name: "NumberNine")
    static var imageZero  = NumberImage(imageView: UIImageView(image: UIImage(named: "NumberZero")!),
                                        name: "NumberZero")
    static var imageBomb  = NumberImage(imageView: UIImageView(image: UIImage(named: "Bomb")!),
                                        name: "Bomb")
    static var imageSkull = NumberImage(imageView: UIImageView(image: UIImage(named: "Skull")!),
                                        name: "Skull")
    static var imageStar  = NumberImage(imageView: UIImageView(image: UIImage(named: "Star")!),
                                        name: "Star")
    static var questionMark = UIImage(named: "MemoryQuestionMark")!
    static var memoryBackground = UIImage(named: "MemoryBackground")!
    static var timeImage  = UIImage(named: "Time")!
    static var scoreImage = UIImage(named: "Score")!
    
    // Land Images
    static var landCar      = UIImage(named: "SortingLandCar")!
    static var landVan      = UIImage(named: "SortingLandVan")!
    static var landBike     = UIImage(named: "SortingLandBike")!
    static var landTruck    = UIImage(named: "SortingLandTruck")!
    static var landDirtBike = UIImage(named: "SortingLandDirtBike")!

    // Air Images
    static var airBalloon = UIImage(named: "SortingHotAirBalloon")!
    static var airPlane   = UIImage(named: "SortingPlane")!
    static var airDrone   = UIImage(named: "SortingDrone")!
    static var airHeli    = UIImage(named: "SortingHelicopter")!
    static var airRocket  = UIImage(named: "SortingRocket")!

    // Water Images
    static var boat1 = UIImage(named: "SortingBoat")!
    static var boat2 = UIImage(named: "SortingBoat2")!
    static var boat3 = UIImage(named: "SortingBoat3")!
    static var boat4 = UIImage(named: "SortingBoat4")!
    static var boat5 = UIImage(named: "SortingBoat5")!
    
    // Sorting Game Shapes
    static var waterShape = CAShapeLayer()
    static var skyShape   = CAShapeLayer()
    static var landShape  = CAShapeLayer()
    
    // Replay booleans
    static var replayBalloonGame = false
    static var replayMemoryGame  = false
    static var replaySortingGame = false
    
    static var sortingGameScore = 0
    static var sortingCorrect   = 0
    static var correctCount: Int? = nil
    
    static var audioPlayer = AVAudioPlayer()
    
    // Play success sound
    static func playSuccessSound(){
        
        if let sound = NSDataAsset(name: "SuccessSound"){
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                audioPlayer = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    // Play error sound
    static func playErrorSound(){
        
        if let sound = NSDataAsset(name: "ErrorSound"){
            do{
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                try AVAudioSession.sharedInstance().setActive(true)
                
                audioPlayer = try AVAudioPlayer(data: sound.data, fileTypeHint: AVFileTypeMPEGLayer3)
                audioPlayer.prepareToPlay()
                audioPlayer.play()
            } catch let error as NSError {
                print("error: \(error.localizedDescription)")
            }
        }
    }
    
    // Set the background image
    static func setUpBackgroundImage(view: UIView, backgroundImageView: UIImageView){
            backgroundImageView.contentMode = .scaleAspectFill
            backgroundImageView.clipsToBounds = true
            backgroundImageView.center = view.center
            backgroundImageView.frame  = view.bounds
            view.addSubview(backgroundImageView)
            view.sendSubview(toBack: backgroundImageView)
    }
    
    // Set the score and time labels
    static func setUpScoreAndTimeLabels(view: UIView,
                                        timeImageView: UIImageView,
                                        timeImageMinute: UIImageView,
                                        timeImageTensSecond: UIImageView,
                                        timeImageSecond: UIImageView,
                                        scoreImageView: UIImageView,
                                        scoreImageHundred: UIImageView,
                                        scoreImageTens: UIImageView,
                                        scoreImageOnes: UIImageView){
        let backgroundViewForTime = UIView()
        let backgroundScoreView   = UIView()
        let timeColonLabel        = UILabel()
        timeColonLabel.text = ":"
        timeColonLabel.font = UIFont(name: timeColonLabel.font.fontName,
                                     size: 50)
        
        // Time Image
        timeImageView.frame = CGRect(x: view.bounds.minX + timeImageView.frame.width / 2, y: (view.bounds.minY + timeImageView.frame.height / 2) + 65, width: 150, height: 50)
        timeImageView.center = CGPoint(x: view.bounds.minX + timeImageView.frame.width / 2, y: (view.bounds.minY + timeImageView.frame.height / 2) + 65)
        
        // Time background view
        backgroundViewForTime.frame = CGRect(x: timeImageView.frame.minX, y: timeImageView.frame.minX, width: 125, height: 50)
        backgroundViewForTime.center = CGPoint(x: (timeImageView.frame.maxX + backgroundViewForTime.frame.width / 2), y: (backgroundViewForTime.frame.maxY / 2) + 65)
        
        // Time Minutes and seconds
        timeImageMinute.frame = CGRect(x: 10, y: 0, width: 30, height: 50)
        timeColonLabel.frame = CGRect(x: timeImageMinute.frame.maxX, y: 0, width: 10, height: 50)
        timeImageTensSecond.frame = CGRect(x: timeImageMinute.frame.maxX + 15, y: 0, width: 30, height: 50)
        timeImageSecond.frame = CGRect(x: timeImageTensSecond.frame.maxX + 2, y: 0, width: 30, height: 50)
        
        // Score Image
        scoreImageView.frame = CGRect(x: view.bounds.maxX - scoreImageView.frame.width / 2, y: (view.bounds.minY + scoreImageView.frame.height / 2) + 65, width: 125, height: 50)
        scoreImageView.center = CGPoint(x: (view.bounds.maxX - scoreImageView.frame.width / 2) - 150, y: (view.bounds.minY + scoreImageView.frame.height / 2) + 65)
        
        // Score background view
        backgroundScoreView.frame = CGRect(x: view.bounds.maxX - scoreImageView.frame.width / 2, y: (view.bounds.minY + scoreImageView.frame.height / 2) + 65, width: 135, height: 50)
        backgroundScoreView.center = CGPoint(x: (scoreImageView.frame.maxX + backgroundScoreView.frame.width / 2), y: (view.bounds.minY + scoreImageView.frame.height / 2) + 65)
        
        // Score Images
        scoreImageHundred.frame = CGRect(x: 10,
                                         y: 0, width: 30, height: 50)
        scoreImageTens.frame = CGRect(x: scoreImageHundred.frame.maxX + 10,
                                      y: 0, width: 30, height: 50)
        scoreImageOnes.frame = CGRect(x: scoreImageTens.frame.maxX + 10,
                                      y: 0, width: 30, height: 50)
        
        backgroundViewForTime.backgroundColor = UIColor.cyan
        backgroundViewForTime.addSubview(timeImageMinute)
        backgroundViewForTime.addSubview(timeColonLabel)
        backgroundViewForTime.addSubview(timeImageTensSecond)
        backgroundViewForTime.addSubview(timeImageSecond)
        
        backgroundScoreView.backgroundColor = UIColor.cyan
        backgroundScoreView.addSubview(scoreImageHundred)
        backgroundScoreView.addSubview(scoreImageTens)
        backgroundScoreView.addSubview(scoreImageOnes)
        
        view.addSubview(timeImageView)
        view.addSubview(scoreImageView)
        view.addSubview(backgroundViewForTime)
        view.addSubview(backgroundScoreView)
    }
    
    
    // Update the actual images of the score or time
    static func updateScoreOrTime(imageView: UIImageView, number: Int){
        switch(number){
        case 0: imageView.image = #imageLiteral(resourceName: "NumberZero")
        case 1: imageView.image = #imageLiteral(resourceName: "NumberOne")
        case 2: imageView.image = #imageLiteral(resourceName: "NumberTwo")
        case 3: imageView.image = #imageLiteral(resourceName: "NumberThree")
        case 4: imageView.image = #imageLiteral(resourceName: "NumberFour")
        case 5: imageView.image = #imageLiteral(resourceName: "NumberFive")
        case 6: imageView.image = #imageLiteral(resourceName: "NumberSix")
        case 7: imageView.image = #imageLiteral(resourceName: "NumberSeven")
        case 8: imageView.image = #imageLiteral(resourceName: "NumberEight")
        case 9: imageView.image = #imageLiteral(resourceName: "NumberNine")
        default: break
        }
    }
    
    static func getOrder() -> Int{
        let count = HighScoreList.sharedInstance.highScores.count
        if count == 0{
            return 1
        }
        else if count == 1{
            return 2
        }
        else if count == 2{
            return 3
        }
        else if count == 3{
            return 4
        }
        
        return 5
    
    }
    
    // Update the images for the time
    static func updateImageForTime(timeImageMinute: UIImageView,
                                   timeImageTensSecond: UIImageView,
                                   timeImageSecond: UIImageView,
                                   minute: Int,
                                   second: Int){
        let tensSecond = second / 10
        let onesSecond = second % 10
        Globals.updateScoreOrTime(imageView: timeImageMinute,
                                  number: minute)
        Globals.updateScoreOrTime(imageView: timeImageTensSecond,
                                  number: tensSecond)
        Globals.updateScoreOrTime(imageView: timeImageSecond,
                                  number: onesSecond)
    }
    
    // Generate a random integer
    static func generateRandomInt(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}


class ViewController:
    UIViewController,
    UITableViewDelegate,
    UITableViewDataSource{

    @IBOutlet weak var balloonGameButton: UIButton!
    @IBOutlet weak var memoryGameButton: UIButton!
    @IBOutlet weak var sortingGameButton: UIButton!
    @IBOutlet weak var easyButton: UIButton!
    @IBOutlet weak var mediumButton: UIButton!
    @IBOutlet weak var hardButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    var balloonGameWasSelected = false
    var memoryGameWasSelected  = false
    var sortingGameWasSelected = false
    var easyWasSelected = false
    var mediumWasSelected = false
    var hardWasSelected = false
    var uiView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set selectors for game buttons
        balloonGameButton.addTarget(self,
                                    action: #selector(updateImageButtons),
                                    for: .touchUpInside)
        memoryGameButton.addTarget(self,
                                   action: #selector(updateImageButtons),
                                   for: .touchUpInside)
        sortingGameButton.addTarget(self,
                                    action: #selector(updateImageButtons),
                                    for: .touchUpInside)
        
        // Set selectors for the level of difficulty
        easyButton.addTarget(self,
                             action: #selector(updateLevelImageButtons),
                             for: .touchUpInside)
        mediumButton.addTarget(self,
                               action: #selector(updateLevelImageButtons),
                               for: .touchUpInside)
        hardButton.addTarget(self,
                             action: #selector(updateLevelImageButtons),
                             for: .touchUpInside)
    }
    
    
    @IBAction func highScoresClicked(_ sender: Any) {
        uiView = UIView(frame: CGRect(x: 350,
                                      y: 250,
                                      width: 300,
                                      height: 300))
        uiView.backgroundColor = UIColor.blue
        uiView.layer.cornerRadius = 10
        uiView.layer.borderWidth = 2
        uiView.layer.borderColor = UIColor.white.cgColor
        let tableView = UITableView()
        tableView.frame = CGRect(x: 25,
                                 y: 40,
                                 width: 250,
                                 height: 200)
        tableView.backgroundColor = UIColor.orange
        tableView.tableHeaderView = UIView()
        let highScoreLabel = UILabel()
        highScoreLabel.frame = CGRect(x: 90,
                                      y: 15,
                                      width: 100,
                                      height: 20)
        highScoreLabel.text = "High Scores"
        
        tableView.dataSource = self
        tableView.delegate   = self
        let cancelButton = UIButton()
        cancelButton.frame = CGRect(x: 50,
                                    y: 250,
                                    width: 200,
                                    height: 35)
        cancelButton.titleLabel?.text = "Cancel"
        cancelButton.setTitleColor(UIColor.black, for: .normal)
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.layer.backgroundColor = UIColor.cyan.cgColor
        cancelButton.addTarget(self, action: #selector(cancelPopUp), for: .touchUpInside)
        
        uiView.addSubview(highScoreLabel)
        uiView.addSubview(cancelButton)
        uiView.addSubview(tableView)
        uiView.addSubview(cancelButton)
        self.view.addSubview(uiView)
        
    }
    
    func cancelPopUp(){
        uiView.removeFromSuperview()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return HighScoreList.sharedInstance.highScores.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let orderLabel = UILabel(frame: CGRect(x: 5, y: 10,
                                               width: 20, height: 45))
        orderLabel.backgroundColor = UIColor.orange
        
        let gameLabel = UILabel(frame: CGRect(x: orderLabel.frame.maxX + 5,
                                              y: 10, width: 150, height: 20))
        gameLabel.backgroundColor = UIColor.green
        
        let difficultyLabel = UILabel(frame: CGRect(x: gameLabel.frame.minX,
                                                    y: gameLabel.frame.maxY + 5, width: 150, height: 20))
        difficultyLabel.backgroundColor = UIColor.yellow
        
        let scoreLabel = UILabel(frame: CGRect(x: difficultyLabel.frame.maxX + 5, y: 10, width: 100, height: 45))
        scoreLabel.backgroundColor = UIColor.cyan
        
        if let highscoreList = HighScoreList.sharedInstance.getList(){
            let highscore = highscoreList[indexPath.row]
            let score = highscore.score
            let order = highscore.order
            let game  = highscore.game
            let diff  = highscore.difficulty
            
            orderLabel.text = String(order)
            scoreLabel.text = String(score)
            gameLabel.text = game
            difficultyLabel.text = diff
        }
        
        cell.addSubview(orderLabel)
        cell.addSubview(gameLabel)
        cell.addSubview(difficultyLabel)
        cell.addSubview(scoreLabel)
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    
    func updateLevelImageButtons(){
        print("Updating Level Image Buttons")
        
        highlightEasyButton()
        highlightMediumButton()
        highlightHardButton()
    }
    
    func highlightEasyButton(){
        if easyWasSelected{
            easyButton.layer.borderWidth = 5
            easyButton.layer.cornerRadius = 70
            easyButton.layer.borderColor = UIColor.orange.cgColor
        }
        else{
            easyButton.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func highlightMediumButton(){
        if mediumWasSelected{
            mediumButton.layer.borderWidth = 5
            mediumButton.layer.cornerRadius = 70
            mediumButton.layer.borderColor = UIColor.orange.cgColor
        }
        else{
            mediumButton.layer.borderColor = UIColor.clear.cgColor
        }

    }
    
    func highlightHardButton(){
        if hardWasSelected{
            hardButton.layer.borderWidth = 5
            hardButton.layer.cornerRadius = 70
            hardButton.layer.borderColor = UIColor.orange.cgColor
        }
        else{
            hardButton.layer.borderColor = UIColor.clear.cgColor
        }

    }
    
    func highlightBalloonButton(){
        if balloonGameWasSelected{
            balloonGameButton.layer.borderWidth = 5
            balloonGameButton.layer.cornerRadius = 30
            balloonGameButton.layer.borderColor = UIColor.orange.cgColor
        }
        else{
            balloonGameButton.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func highlightMemoryButton(){
        if memoryGameWasSelected{
            memoryGameButton.layer.borderWidth = 5
            memoryGameButton.layer.cornerRadius = 30
            memoryGameButton.layer.borderColor = UIColor.orange.cgColor
        }
        else{
            memoryGameButton.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func highlightSortingButton(){
        if sortingGameWasSelected{
            sortingGameButton.layer.borderWidth = 5
            sortingGameButton.layer.cornerRadius = 32
            sortingGameButton.layer.borderColor = UIColor.orange.cgColor
        }
        else{
            sortingGameButton.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func updateImageButtons(){
        print("Updating Image Buttons")
        
        highlightBalloonButton()
        highlightMemoryButton()
        highlightSortingButton()
    }
    

    @IBAction func balloonGameSelected(_ sender: Any) {
        balloonGameWasSelected = true
        memoryGameWasSelected = false
        sortingGameWasSelected = false
        balloonGameButton.alpha = 1.0
        memoryGameButton.alpha = 0.5
        sortingGameButton.alpha = 0.5
    }
    
    @IBAction func memoryGameSelected(_ sender: Any) {
        balloonGameWasSelected = false
        memoryGameWasSelected = true
        sortingGameWasSelected = false
        balloonGameButton.alpha = 0.5
        memoryGameButton.alpha = 1.0
        sortingGameButton.alpha = 0.5
    }
    
    @IBAction func sortingGameSelected(_ sender: Any) {
        balloonGameWasSelected = false
        memoryGameWasSelected = false
        sortingGameWasSelected = true
        balloonGameButton.alpha = 0.5
        memoryGameButton.alpha = 0.5
        sortingGameButton.alpha = 1.0
        
    }
    
    @IBAction func easyButtonSelected(_ sender: Any) {
        easyWasSelected = true
        mediumWasSelected = false
        hardWasSelected = false
        easyButton.alpha = 1.0
        mediumButton.alpha = 0.5
        hardButton.alpha = 0.5
    }
    

    @IBAction func mediumButtonSelected(_ sender: Any) {
        easyWasSelected = false
        mediumWasSelected = true
        hardWasSelected = false
        easyButton.alpha = 0.5
        mediumButton.alpha = 1.0
        hardButton.alpha = 0.5
    }
    
    @IBAction func hardButtonSelected(_ sender: Any) {
        easyWasSelected = false
        mediumWasSelected = false
        hardWasSelected = true
        easyButton.alpha = 0.5
        mediumButton.alpha = 0.5
        hardButton.alpha = 1.0
    }
    
    @IBAction func nextButtonSelected(_ sender: Any) {
        print("Next Button Selected")
        if balloonGameWasSelected
            && (easyWasSelected || mediumWasSelected || hardWasSelected){
            print("Segue to balloon game")
            performSegue(withIdentifier: "BalloonGameSegue", sender: self)
            
        }
        else if memoryGameWasSelected && (easyWasSelected || mediumWasSelected || hardWasSelected){
            print("Segue to memory game")
            performSegue(withIdentifier: "MemoryGameSegue", sender: self)
        }
        else if sortingGameWasSelected && (easyWasSelected || mediumWasSelected || hardWasSelected){
            print("Segue to sorting game")
            performSegue(withIdentifier: "SortingGameSegue", sender: self)
        }
        else{
            print("Error should occur here")
            let alert = UIAlertController(title: "Error", message: "Please select a game and a difficulty level to continue", preferredStyle: .alert)
            let dismissAction = UIAlertAction(title: "Dismiss",
                                              style: .cancel,
                                              handler: nil)
            alert.addAction(dismissAction)
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK - Navigation
    @IBAction func unwindToHome(segue: UIStoryboardSegue){
        print("Unwind to home segue")
//        if Globals.replayBalloonGame{
//            Globals.replayBalloonGame = false
//            self.performSegue(withIdentifier: "BalloonGameSegue", sender: self)
//        }
//        else if Globals.replayMemoryGame{
//            Globals.replayMemoryGame = false
//            self.performSegue(withIdentifier: "MemoryGameSegue", sender: self)
//        }
//        else if Globals.replaySortingGame{
//            Globals.replaySortingGame = false
//            self.performSegue(withIdentifier: "SortingGameSegue", sender: self)
//        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get segue identifier
        if let identifier = segue.identifier{
            print("Segue \(identifier)")
            
            if let destination = segue.destination as? BalloonViewController{
                print("Destination Balloon View Controller")
                if easyWasSelected{
                    destination.difficulty = "Easy"
                }
                else if mediumWasSelected{
                    destination.difficulty = "Medium"
                }
                else if hardWasSelected{
                    destination.difficulty = "Hard"
                }
            }
            
            if let destination = segue.destination as? MemoryViewController{
                print("Destination Memory View Controller")
                if easyWasSelected{
                    destination.difficulty = "Easy"
                }
                else if mediumWasSelected{
                    destination.difficulty = "Medium"
                }
                else if hardWasSelected{
                    destination.difficulty = "Hard"
                }
            }
            
            if let destination = segue.destination as? SortingViewController{
                print("Destination Sorting View Controller")
                if easyWasSelected{
                    destination.difficulty = "Easy"
                }
                else if mediumWasSelected{
                    destination.difficulty = "Medium"
                }
                else if hardWasSelected{
                    destination.difficulty = "Hard"
                }
            }
        }
    }
}

