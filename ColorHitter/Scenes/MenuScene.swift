//
//  MenuScene.swift
//  ColorHitter
//
//  Created by Ricardo Moreira on 05/06/2020.
//  Copyright © 2020 Ricardo Moreira. All rights reserved.
//

import SpriteKit

class MenuScene: SKScene {
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        addLogo()
        addFunctionality()
    }
    
    func addLogo(){
        let logo = SKSpriteNode(imageNamed: "logo 2")
        logo.size = CGSize(width: frame.width/4, height: frame.width/4) // Squarish shape
        logo.position = CGPoint(x: frame.midX, y: frame.midY + frame.size.height/4) // Higher than the mid section of the screen
        addChild(logo)
    }
    
    func addFunctionality(){
        let playLabel = SKLabelNode(text: "Tap to Start!")
        playLabel.fontName = "AvenirNext-Bold"
        playLabel.fontSize = 50.0
        playLabel.fontColor = UIColor.white
        playLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(playLabel)
        animate(label: playLabel)
        
        let highestScoreLabel = SKLabelNode(text: "Highscore: \(UserDefaults.standard.integer(forKey: "Highscore"))")
        highestScoreLabel.fontName = "AvenirNext-Bold"
        highestScoreLabel.fontSize = 40.0
        highestScoreLabel.fontColor = UIColor.white
        highestScoreLabel.position = CGPoint(x: frame.midX, y: frame.midY - highestScoreLabel.frame.size.height*4)
        addChild(highestScoreLabel)
        
        let recentScoreLabel = SKLabelNode(text: "Recent score: \(UserDefaults.standard.integer(forKey: "RecentScore"))")
        recentScoreLabel.fontName = "AvenirNext-Bold"
        recentScoreLabel.fontSize = 40.0
        recentScoreLabel.fontColor = UIColor.white
        recentScoreLabel.position = CGPoint(x: frame.midX, y: highestScoreLabel.position.y - recentScoreLabel.frame.size.height*2)
        addChild(recentScoreLabel)
    }
    
    func animate(label: SKLabelNode){
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let fadeIn = SKAction.fadeIn(withDuration: 0.5)
        
        let scaleUp = SKAction.scale(to: 1.1, duration: 0.5)
        let scaleDown = SKAction.scale(to: 1.0, duration: 0.5)
        
        let fadeSequence = SKAction.sequence([fadeIn, fadeOut])
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        let group = SKAction.group([fadeSequence, scaleSequence])
        label.run(SKAction.repeatForever(group))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let gameScene = GameScene(size: view!.bounds.size)
        view?.presentScene(gameScene)
    }
}
