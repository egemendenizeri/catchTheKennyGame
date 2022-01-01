//
//  ViewController.swift
//  catchTheKenny
//
//  Created by egemen denizeri on 1.01.2022.
//

import UIKit

class ViewController: UIViewController {
    
    var timerLabel = UILabel()
    var scoreLabel = UILabel()
    var gameTitleLabel = UILabel()
    var kennyImage = UIImageView()
    var kennyLogoImage = UIImageView()
    var kennyLogoRotation = 0.3
    var highscoreLabel = UILabel()
    var playButton = UIButton()
    var score = 0
    
    // Creating global screen width and height variables
    var screenWidth : CGFloat = 0
    var screenHeight : CGFloat = 0
    
    // Kenny's Coordinates
    var kennyX = 0.5
    var kennyY = 0.525
    
    // Kenny Location options
    let widthOptions = [0.25, 0.5, 0.75]
    let heigthOptions = [0.35, 0.525, 0.7]
    
    // Timer
    var countDown = Timer()
    var counter = 0
    
    // Timer to change location of Kenny
    var timerToChangeImage = Timer()
    // timer for logo image
    var timerForLogo = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // assign width and height
        let width = view.frame.size.width
        let height = view.frame.size.height
        screenWidth = width
        screenHeight = height
        
        
        // Logo Image
        kennyLogoImage.image = UIImage(named: "KennyMcCormick")
        kennyLogoImage.frame = CGRect(x: screenWidth * 0.5 - screenWidth * 0.25 / 2, y: screenHeight * 0.475 - screenHeight*0.15/2, width: screenWidth * 0.25, height: screenHeight*0.15)
        view.addSubview(kennyLogoImage)
        kennyLogoImage.transform = kennyLogoImage.transform.rotated(by: kennyLogoRotation)

        timerForLogo = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(logoTimerFunc), userInfo: nil, repeats: true)
        
        // Game title Label
        gameTitleLabel.text = "Catch the Kenny"
        gameTitleLabel.textAlignment = .center
        gameTitleLabel.numberOfLines = 3
        gameTitleLabel.frame = CGRect(x: screenWidth * 0.50 - screenWidth * 0.4 / 2, y: screenHeight * 0.3 - screenHeight*0.2/2, width: screenWidth * 0.4, height: screenHeight*0.2)
        gameTitleLabel.font=UIFont.boldSystemFont(ofSize: 44)
        view.addSubview(gameTitleLabel)
        
        // Play button
        playButton.setTitle("PLAY!", for: UIControl.State.normal)
        playButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
        playButton.titleLabel?.font =  UIFont.boldSystemFont(ofSize: 84)
        playButton.backgroundColor = .clear
        playButton.layer.cornerRadius = 20
        playButton.layer.borderWidth = 0
        playButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        playButton.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
        playButton.layer.shadowOpacity = 1.0
        playButton.layer.shadowRadius = 0.0
        playButton.layer.masksToBounds = false
        playButton.layer.cornerRadius = 4.0
        playButton.layer.borderColor = UIColor.black.cgColor
        playButton.frame = CGRect(x: screenWidth * 0.5 - screenWidth * 0.6 / 2, y: screenHeight * 0.7 - screenHeight*0.1/2, width: screenWidth * 0.6, height: screenHeight*0.1)
        playButton.addTarget(self, action: #selector(ViewController.startGame), for: UIControl.Event.touchUpInside)
        view.addSubview(playButton)

        
        // Count Down Timer Label
        counter = 10
        timerLabel.isHidden = true
        timerLabel.text = "\(counter)"
        timerLabel.textAlignment = .center
        timerLabel.frame = CGRect(x: screenWidth * 0.5 - screenWidth * 0.8 / 2, y: screenHeight * 0.15 - screenHeight*0.08/2, width: screenWidth * 0.8, height: screenHeight*0.08)
        timerLabel.font=UIFont.systemFont(ofSize: 32)
        view.addSubview(timerLabel)
        
        
        // Score Label
        scoreLabel.isHidden = true
        scoreLabel.text = "Score: \(score)"
        scoreLabel.textAlignment = .center
        scoreLabel.frame = CGRect(x: screenWidth * 0.5 - screenWidth * 0.8 / 2, y: screenHeight * 0.22 - screenHeight*0.04/2, width: screenWidth * 0.8, height: screenHeight*0.04)
        scoreLabel.font=UIFont.systemFont(ofSize: 18)
        view.addSubview(scoreLabel)
        
        // Kenny Image
        kennyImage.isUserInteractionEnabled = false
        kennyImage.isHidden = true
        kennyImage.image = UIImage(named: "KennyMcCormick")
        kennyImage.frame = CGRect(x: screenWidth * kennyX - screenWidth * 0.25 / 2, y: screenHeight * kennyY - screenHeight*0.15/2, width: screenWidth * 0.25, height: screenHeight*0.15)
        view.addSubview(kennyImage)
        
        // Kenny Image Gesture Recognizer
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(addScore))
        kennyImage.addGestureRecognizer(gestureRecognizer)
        
        
        // Highscore Label
        highscoreLabel.isHidden = true
        if let highscore = UserDefaults.standard.object(forKey: "highscore") as? Int{
            highscoreLabel.text = "Highscore: \(highscore)"
        } else{
            highscoreLabel.text = "Highscore: 0"
        }
        highscoreLabel.textAlignment = .center
        highscoreLabel.frame = CGRect(x: screenWidth * 0.5 - screenWidth * 0.8 / 2, y: screenHeight * 0.85 - screenHeight*0.04/2, width: screenWidth * 0.8, height: screenHeight*0.04)
        highscoreLabel.font=UIFont.systemFont(ofSize: 18)
        view.addSubview(highscoreLabel)
     
    }
    // LogoKenny rotation animation
    @objc func logoTimerFunc(){
        kennyLogoRotation *= -1
        kennyLogoImage.transform = kennyLogoImage.transform.rotated(by: kennyLogoRotation)
    }
    
    @objc func startGame(){
        // Hiding openning screen
        playButton.isHidden = true
        gameTitleLabel.isHidden = true
        kennyLogoImage.isHidden = true
        timerForLogo.invalidate()
        // showing the game
        timerLabel.isHidden = false
        scoreLabel.isHidden = false
        kennyImage.isHidden = false
        kennyImage.isUserInteractionEnabled = true
        highscoreLabel.isHidden = false
        // Count Down Timer Label
        countDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        // Timer to change location of Kenny
        timerToChangeImage = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(changeLocationOfKenny), userInfo: nil, repeats: true)
    }
    
    @objc func changeLocationOfKenny(){
        // Kenny's new location won't be the same with the previous location
        while true {
            let newKennyX = widthOptions.randomElement()!
            let newKennyY = heigthOptions.randomElement()!
            if kennyX != newKennyX && kennyY != newKennyY{
                kennyX = newKennyX
                kennyY = newKennyY
                break
            }
        }
        // Placing Kenny in his new location
        kennyImage.frame = CGRect(x: screenWidth * kennyX - screenWidth * 0.25 / 2, y: screenHeight * kennyY - screenHeight*0.15/2, width: screenWidth * 0.25, height: screenHeight*0.15)
    }
    
    
    @objc func checkHighscore(){
        if let highscore = UserDefaults.standard.object(forKey: "highscore") as? Int{
            if score > highscore{
                UserDefaults.standard.set(score, forKey: "highscore")
                highscoreLabel.text = "Highscore: \(score)"
            }
        }else{
            UserDefaults.standard.set(score, forKey: "highscore")
            highscoreLabel.text = "Highscore: \(score)"
        }
    }
    
    @objc func addScore(){
        score += 1
        scoreLabel.text = "Score: \(score)"
        checkHighscore()
    }
    
    @objc func timerFunction(){
        timerLabel.text = "\(counter)"
        counter -= 1
        
        if counter < 0 {
            // hide kenny
            kennyImage.isHidden = true
            kennyImage.isUserInteractionEnabled = false
            // stop timers
            countDown.invalidate()
            timerToChangeImage.invalidate()
            makeAlert(titleInput: "Time is up!", messageInput: "Do you want to play again?")
        }
        changeLocationOfKenny()
    }

    
    @objc func makeAlert(titleInput: String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default) {
            (UIAlertAction) in
            //ok function
            self.score = 0
            self.scoreLabel.text = "Score: \(self.score)"
            self.counter = 10
            self.timerLabel.text = "\(self.counter)"
            // resets the timers
            self.timerLabel.isHidden = true
            self.scoreLabel.isHidden = true
            self.kennyImage.isHidden = true
            self.kennyImage.isUserInteractionEnabled = false
            self.highscoreLabel.isHidden = true
            self.playButton.isHidden = false
            self.gameTitleLabel.isHidden = false
            self.kennyLogoImage.isHidden = false
            self.timerForLogo = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(self.logoTimerFunc), userInfo: nil, repeats: true)
        }
        alert.addAction(okButton)
        
        let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) {
            (UIAlertAction) in
            //replay function
            self.score = 0
            self.scoreLabel.text = "Score: \(self.score)"
            self.counter = 10
            self.timerLabel.text = "\(self.counter)"
            // resets the timers
            self.countDown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerFunction), userInfo: nil, repeats: true)
            self.timerToChangeImage = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(self.changeLocationOfKenny), userInfo: nil, repeats: true)
            // show kenny again
            self.kennyImage.isHidden = false
            self.kennyImage.isUserInteractionEnabled = true
        }
        alert.addAction(replayButton)
        self.present(alert, animated: true, completion: nil)
    }

}



