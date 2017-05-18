//
//  SortingViewController.swift
//  Kids Joy Center
//
//  Created by Wes Bosman on 3/19/17.
//  Copyright © 2017 Wes Bosman. All rights reserved.
//

import UIKit

class SortingViewController: UIViewController {
    
    var vehicles:[VehicleImage] = [VehicleImage(imageView: UIImageView(image:Globals.boat1), name: "Boat"),
                                   
        VehicleImage(imageView: UIImageView(image: Globals.boat2) ,
                     name: "Boat2"),
                     
        VehicleImage(imageView: UIImageView(image: Globals.boat3) ,
                     name: "Boat3"),
                     
        VehicleImage(imageView: UIImageView(image: Globals.boat4) ,
                     name: "Boat4"),
        
        VehicleImage(imageView: UIImageView(image: Globals.boat5) ,
                    name: "Boat5"),
        
        VehicleImage(imageView: UIImageView(image: Globals.airPlane) ,
                    name: "AirPlane"),
        
        VehicleImage(imageView: UIImageView(image: Globals.airRocket) ,
                    name: "AirRocket"),
        
        VehicleImage(imageView: UIImageView(image: Globals.airBalloon) ,
                    name: "AirBalloon"),
        
        VehicleImage(imageView: UIImageView(image: Globals.airHeli) ,
                    name: "AirHelicopter"),
                     
        VehicleImage(imageView: UIImageView(image: Globals.airDrone) ,
                    name: "AirDrone"),
                     
        VehicleImage(imageView: UIImageView(image: Globals.landBike) ,
                    name: "LandBike"),
                     
        VehicleImage(imageView: UIImageView(image: Globals.landCar) ,
                    name: "LandCar"),
        
        VehicleImage(imageView: UIImageView(image: Globals.landVan) ,
                    name: "LandVan"),
        
        VehicleImage(imageView: UIImageView(image: Globals.landTruck) ,
                    name: "LandTruck"),
                     
        VehicleImage(imageView: UIImageView(image: Globals.landDirtBike),
                    name: "LandDirtBike") ]
    
    var difficulty: String = String()
    let background  = UIImage(named: "SortingGameBackground")
    let timeView    = UIImageView(image: Globals.timeImage)
    let scoreView   = UIImageView(image: Globals.scoreImage)
    var timeMin     = UIImageView(image: Globals.imageZero.imageView.image)
    var timeTensSec = UIImageView(image: Globals.imageZero.imageView.image)
    var timeOnesSec = UIImageView(image: Globals.imageZero.imageView.image)
    var scoreHund   = UIImageView(image: Globals.imageZero.imageView.image)
    var scoreTens   = UIImageView(image: Globals.imageZero.imageView.image)
    var scoreOnes   = UIImageView(image: Globals.imageZero.imageView.image)
    var gameTimer   = Timer()
    static var count                 = 0
    var vehicleHolder                = UIView()
    let vehicleHolderHeight: CGFloat = 120
    let navBarHeight:CGFloat         = 65
    var vehicleBoxes: [CGPoint]      = []
    var firstX: CGFloat              = 60
    var numberOfVehicles             = 0
    var vehiclesOnScreen:[VehicleImage] = []
    var randomGeneratedInts: [Int]      = []
    var lastCorrectCount: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Nav title and run the game
        self.navigationItem.title = "Sorting Game"
        runGame()
    }
    
    func restartGame(){
        timeMin     = UIImageView(image: Globals.imageZero.imageView.image)
        timeTensSec = UIImageView(image: Globals.imageZero.imageView.image)
        timeOnesSec = UIImageView(image: Globals.imageZero.imageView.image)
        scoreHund   = UIImageView(image: Globals.imageZero.imageView.image)
        scoreTens   = UIImageView(image: Globals.imageZero.imageView.image)
        scoreOnes   = UIImageView(image: Globals.imageZero.imageView.image)
        gameTimer   = Timer()
        SortingViewController.count       = 0
        vehicleHolder.removeFromSuperview()
        
        randomGeneratedInts.removeAll()
        
        for vehicle in vehiclesOnScreen{
            vehicle.removeFromSuperview()
        }
        
        vehiclesOnScreen.removeAll()
        self.reloadInputViews()
        
        runGame()
    }
    
    // Run the Game
    func runGame(){
        setUpBackgroundImage()
        setDifficulty(difficulty: difficulty)
        setUpScoreAndTimeLabels(view: self.view,
                                timeImageView:       timeView,
                                timeImageMinute:     timeMin,
                                timeImageTensSecond: timeTensSec,
                                timeImageSecond:     timeOnesSec,
                                scoreImageView:      scoreView,
                                scoreImageHundred:   scoreHund,
                                scoreImageTens:      scoreTens,
                                scoreImageOnes:      scoreOnes)
        createAreaViews()
        createBoxes()
    }
    
    func setUpBackgroundImage(){
        // Set up the background image
        vehicleHolder = UIView(frame: CGRect(x: 0, y: navBarHeight,
                                                 width: self.view.frame.maxX,
                                                 height: vehicleHolderHeight))
        vehicleHolder.backgroundColor = UIColor.cyan
        let backgroundImageView = UIImageView(image: background)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.clipsToBounds = true
        backgroundImageView.center = view.center
        backgroundImageView.frame = CGRect(x: 0, y: (navBarHeight + vehicleHolderHeight),
                                           width: view.frame.maxX,
                                           height: view.frame.maxY - (navBarHeight + vehicleHolderHeight))
        view.addSubview(vehicleHolder)
        view.addSubview(backgroundImageView)
        view.sendSubview(toBack: backgroundImageView)
    }
    
    // Set the score and time labels
    func setUpScoreAndTimeLabels(view: UIView,
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
        
        let height = navBarHeight + vehicleHolderHeight + 20
        
        // Time Image
        timeImageView.frame = CGRect(x: view.bounds.minX + timeImageView.frame.width / 2, y: (view.bounds.minY + timeImageView.frame.height / 2) + height, width: 150, height: 50)
        timeImageView.center = CGPoint(x: view.bounds.minX + timeImageView.frame.width / 2, y: (view.bounds.minY + timeImageView.frame.height / 2) + height)
        
        // Time background view
        backgroundViewForTime.frame = CGRect(x: timeImageView.frame.minX, y: timeImageView.frame.minX, width: 125, height: 50)
        backgroundViewForTime.center = CGPoint(x: (timeImageView.frame.maxX + backgroundViewForTime.frame.width / 2), y: (backgroundViewForTime.frame.maxY / 2) + height)
        
        // Time Minutes and seconds
        timeImageMinute.frame = CGRect(x: 10, y: 0, width: 30, height: 50)
        timeColonLabel.frame = CGRect(x: timeImageMinute.frame.maxX, y: 0, width: 10, height: 50)
        timeImageTensSecond.frame = CGRect(x: timeImageMinute.frame.maxX + 15, y: 0, width: 30, height: 50)
        timeImageSecond.frame = CGRect(x: timeImageTensSecond.frame.maxX + 2, y: 0, width: 30, height: 50)
        
        // Score Image
        scoreImageView.frame = CGRect(x: view.bounds.maxX - scoreImageView.frame.width / 2, y: (view.bounds.minY + scoreImageView.frame.height / 2) + height, width: 125, height: 50)
        scoreImageView.center = CGPoint(x: (view.bounds.maxX - scoreImageView.frame.width / 2) - 150, y: (view.bounds.minY + scoreImageView.frame.height / 2) + height)
        
        // Score background view
        backgroundScoreView.frame = CGRect(x: view.bounds.maxX - scoreImageView.frame.width / 2, y: (view.bounds.minY + scoreImageView.frame.height / 2) + height, width: 135, height: 50)
        backgroundScoreView.center = CGPoint(x: (scoreImageView.frame.maxX + backgroundScoreView.frame.width / 2), y: (view.bounds.minY + scoreImageView.frame.height / 2) + height)
        
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

    
    func setDifficulty(difficulty: String){
        // 8 for easy. i minute
        // 10 medium. 45 seconds
        // 12 hard. 30 seconds
        
        switch(difficulty){
        case "Easy":
            SortingViewController.count = 60
            numberOfVehicles = 8
            gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer) in
                // Get random boxes
                self.updateTime()
                self.updateScore()
            })
            
        case "Medium":
            SortingViewController.count = 45
            numberOfVehicles = 10
            gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer) in
                // Get random boxes
                self.updateTime()
                self.updateScore()
                
            })
            
        case "Hard":
            SortingViewController.count = 30
            numberOfVehicles = 12
            gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: {(timer) in
                // Get random boxes
                self.updateTime()
                self.updateScore()
            })
            
        default:
            break
        }
    }
    
    func updateScore(){
        if let newCount = Globals.correctCount{
            if newCount != lastCorrectCount{
            
                lastCorrectCount = newCount
                let countDiff = newCount - SortingViewController.count
                
                if countDiff <= 2{
                    Globals.sortingGameScore += 5
                }
                else if countDiff > 2 && countDiff <= 4{
                    Globals.sortingGameScore += 4
                }
                else if countDiff > 4{
                    Globals.sortingGameScore += 3
                }
                
                if Globals.sortingGameScore < 10{
                    Globals.updateScoreOrTime(imageView: scoreOnes, number: Globals.sortingGameScore)
                }
                else if Globals.sortingGameScore > 10{
                    let tens = Globals.sortingGameScore / 10
                    let ones = Globals.sortingGameScore % 10
                    Globals.updateScoreOrTime(imageView: scoreOnes, number: ones)
                    Globals.updateScoreOrTime(imageView: scoreTens, number: tens)
                }
            }
        }
    }
    
    // Update the game timer
    func updateTime(){
        SortingViewController.count = SortingViewController.count - 1
        let minute = (SortingViewController.count % 3600) / 60
        let second = (SortingViewController.count % 3600) % 60
        
        if Globals.sortingCorrect == numberOfVehicles{
            // User Won
            gameTimer.invalidate()
            
            // Create a highscore 
            let order = Globals.getOrder()
            let highScore = HighScore(order: order, score: Globals.sortingGameScore, diff: difficulty, game: "Sorting")
            HighScoreList.sharedInstance.addHighScore(highScore: highScore)
            
            // Show an alert
            let alert = UIAlertController(title: "You Won!",
                                          message: "Would you like to play again?",
                                          preferredStyle: .alert)
            let yesAction = UIAlertAction(title: "Yes", style: .default, handler: {(action) in
                // Replay the game
//                Globals.replaySortingGame = true
//                self.performSegue(withIdentifier: "UnwindFromSorting", sender: self)
                
            })
            
            let noAction = UIAlertAction(title: "No",
                                         style: .cancel, handler: {(action) in
                // Return to the home screen
                self.performSegue(withIdentifier: "UnwindFromSorting", sender: self)
            })
            
            alert.addAction(noAction)
            alert.addAction(yesAction)
            self.present(alert, animated: true, completion: nil)
        }


        Globals.updateImageForTime(timeImageMinute: timeMin,
                                   timeImageTensSecond: timeTensSec,
                                   timeImageSecond: timeOnesSec,
                                   minute: minute,
                                   second: second)
        
        if SortingViewController.count == 0{
            gameTimer.invalidate()
            
        }
    }
    
    // Create the boxes on which to spawn the images
    func createBoxes(){
        
        switch(numberOfVehicles){
        case 8:
            print("create 8 vehicles")
            firstX = 225
            for _ in 0..<8{
                let point = CGPoint(x: firstX, y: navBarHeight - 5)
                vehicleBoxes.append(point)
                firstX += 85
            }
            placeImagesToSort()
            
        case 10:
            print("create 10 vehicles")
            firstX = 125
            for _ in 0..<10{
                let point = CGPoint(x: firstX, y: navBarHeight - 5)
                vehicleBoxes.append(point)
                firstX += 85
            }
            placeImagesToSort()
            
        case 12:
            print("create 12 vehicles")
            firstX = 35
            for _ in 0..<12{
                let point = CGPoint(x: firstX, y: navBarHeight - 5)
                vehicleBoxes.append(point)
                firstX += 85
            }
            placeImagesToSort()
            
        default:
            break
        }
    }
    
    func getRandom() -> Int{
        var random = Globals.generateRandomInt(min: 0,
                                               max: vehicles.count - 1)
        if randomGeneratedInts.count == 0{
            randomGeneratedInts.append(random)
            return random
        }
        else{
            if randomGeneratedInts.contains(random){
                random = getRandom()
            }
            
            randomGeneratedInts.append(random)
            return random
            
        }
    }
    
    func placeImagesToSort(){

        for point in vehicleBoxes{
            print("Point: \(point)")
            let random = getRandom()
            let vehicle = vehicles[random]
            print("Vehicle name: \(vehicle.name)")
            vehicle.center = point
            let origin = CGPoint(x: (vehicle.center.x - 30),
                                 y: (vehicle.center.y - 50))
            let size = CGSize(width: 75, height: 100)
            
            vehicle.frame = CGRect(origin: origin, size: size)
//            vehicle.backgroundColor = UIColor.red
            vehicle.isUserInteractionEnabled = true
            vehicle.tag = vehicleBoxes.index(of: point)!
            vehicleHolder.addSubview(vehicle)
            vehiclesOnScreen.append(vehicle)
        }
    }
    
    // Create the background area shapes for hit testing
    func createAreaViews(){
        // Water Shape
        Globals.waterShape = CAShapeLayer()
        view.layer.addSublayer(Globals.waterShape)
        Globals.waterShape.opacity = 0.0
        Globals.waterShape.lineWidth = 1.0
        Globals.waterShape.lineJoin = kCALineJoinRound
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: view.frame.minX, y: 520))
        path.addLine(to: CGPoint(x: 732, y: 520))
        path.addLine(to: CGPoint(x: 712, y: 541))
        path.addLine(to: CGPoint(x: 761, y: 627))
        path.addLine(to: CGPoint(x: 709, y: 655))
        path.addLine(to: CGPoint(x: 524, y: 670))
        path.addLine(to: CGPoint(x: 488, y: 697))
        path.addLine(to: CGPoint(x: 499, y: view.frame.maxY))
        path.addLine(to: CGPoint(x: view.frame.minX, y: view.frame.maxY))
        path.addLine(to:  CGPoint(x: view.frame.minX, y: 520))
        path.close()
        Globals.waterShape.path = path.cgPath
        
        // Sky Shape
        Globals.skyShape = CAShapeLayer()
        view.layer.addSublayer(Globals.skyShape)
        Globals.skyShape.opacity = 0.0
        Globals.skyShape.lineWidth = 1.0
        Globals.skyShape.lineJoin = kCALineJoinRound
        
        let skyPath = UIBezierPath()
        skyPath.move(to: CGPoint(x: 0, y: 185))
        skyPath.addLine(to: CGPoint(x: 1020, y: 185))
        skyPath.addLine(to: CGPoint(x: 1020, y: 519))
        skyPath.addLine(to: CGPoint(x: 0, y: 519))
        skyPath.addLine(to: CGPoint(x: 0, y: 185))
        skyPath.close()
        Globals.skyShape.path = skyPath.cgPath
        
        // Land Shape
        Globals.landShape = CAShapeLayer()
        view.layer.addSublayer(Globals.landShape)
        Globals.landShape.opacity = 0.0
        Globals.landShape.lineWidth = 1.0
        Globals.landShape.lineJoin = kCALineJoinRound
        
        let landPath = UIBezierPath()
        landPath.move(to: CGPoint(x: 733, y: 520))
        landPath.addLine(to: CGPoint(x: view.frame.maxX, y: 520))
        landPath.addLine(to: CGPoint(x: view.frame.maxX, y: view.frame.maxY))
        landPath.addLine(to: CGPoint(x: 500, y: view.frame.maxY))
        landPath.addLine(to: CGPoint(x: 489, y: 697))
        landPath.addLine(to: CGPoint(x: 525, y: 670))
        landPath.addLine(to: CGPoint(x: 710, y: 655))
        landPath.addLine(to: CGPoint(x: 762, y: 627))
        landPath.addLine(to: CGPoint(x: 713, y: 541))
        landPath.close()
        Globals.landShape.path = landPath.cgPath
    }
}
