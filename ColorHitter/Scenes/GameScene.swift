//
//  GameScene.swift
//  ColorHitter
//
//  Created by Ricardo Moreira on 05/06/2020.
//  Copyright © 2020 Ricardo Moreira. All rights reserved.
//

import SpriteKit

enum GameColors{
    static let colors = [
        UIColor.init(red: 231/255, green: 76/255, blue: 60/255, alpha: 1.0),
        UIColor.init(red: 241/255, green: 146/255, blue: 15/255, alpha: 1.0),
        UIColor.init(red: 46/255, green: 204/255, blue: 113/255, alpha: 1.0),
        UIColor.init(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
    ]
}

enum SwitchState: Int{
    case red, yellow, green, blue // Since none is specified, we just get the raw values [0-3]
}

class GameScene: SKScene {
        
    var colorSwitch : SKSpriteNode!
    var switchState = SwitchState.red // the red is @ the image top
    var currentColorIndex: Int?
    
    let scoreLabel = SKLabelNode(text: "0")
    var score = 0
    
    override func didMove(to view: SKView) {
        setupPhysics()
        layoutScene()
    }
    
    func setupPhysics(){
        physicsWorld.gravity = CGVector(dx: 0.0, dy: -2.0) // Slows the gravity from regular (-9,8) to -2,0
        physicsWorld.contactDelegate = self
    }
    
    func layoutScene(){
        backgroundColor = UIColor(red: 44/255, green: 62/255, blue: 80/255, alpha: 1.0)
        
        colorSwitch = SKSpriteNode(imageNamed: "ColorCircle")
        colorSwitch.size = CGSize(width: frame.size.width/3, height: frame.size.width/3)
        colorSwitch.position = CGPoint(x: frame.midX, y: frame.minY + colorSwitch.size.height)
        colorSwitch.zPosition = ZPositions.colorSwitch
        colorSwitch.physicsBody = SKPhysicsBody(circleOfRadius: colorSwitch.size.width/2)
        colorSwitch.physicsBody?.categoryBitMask = PhysicsCategories.switchCategory
        colorSwitch.physicsBody?.isDynamic = false // The color switch is no longer affected by physics!! :)))
        
        addChild(colorSwitch)
        
        scoreLabel.fontName = "AvenirNext-Bold"
        scoreLabel.fontSize = 60.0
        scoreLabel.fontColor = UIColor.white
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        scoreLabel.zPosition = ZPositions.label
        addChild(scoreLabel)
        
        spawnBall()
    }
    
    func updateScore(){
        scoreLabel.text = "\(score)"
    }
    
    func spawnBall(){
        currentColorIndex = Int(arc4random_uniform(UInt32(4))) // Create a random number between 0 and 3
        
        let ball = SKSpriteNode(texture: SKTexture(imageNamed: "ball"), color: GameColors.colors[currentColorIndex!], size: CGSize(width: 30.0, height: 30.0))
        ball.colorBlendFactor = 1.0 // Assigns the color value to the texture
        ball.name = "Ball"
        ball.position = CGPoint(x: frame.midX, y: frame.maxY)
        ball.zPosition = ZPositions.ball
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width/2) // Half the ball's diameter
        ball.physicsBody?.categoryBitMask = PhysicsCategories.ballCategory
        ball.physicsBody?.contactTestBitMask = PhysicsCategories.switchCategory
        ball.physicsBody?.collisionBitMask = PhysicsCategories.none
        
        addChild(ball)
    }
    
    func rotateSwitch(){
        // Preventing switch to go any higher than the max value
        if let newState = SwitchState(rawValue: switchState.rawValue + 1){
            switchState = newState
        } else {
            switchState = .red
        }
        
        colorSwitch.run(SKAction.rotate(byAngle: .pi/2, duration: 0.25))
    }
    
    func gameOver(){
        UserDefaults.standard.set(score, forKey: "RecentScore")
        
        if score > UserDefaults.standard.integer(forKey: "Highscore"){ // If there is no value, returns 0
            UserDefaults.standard.set(score, forKey: "Highscore")
        }
        
        let menuScene = MenuScene(size: view!.bounds.size)
        view?.presentScene(menuScene)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        rotateSwitch()
    }
}

extension GameScene: SKPhysicsContactDelegate{
    func didBegin(_ contact: SKPhysicsContact) {
        
        // Since the bit masks are something like 01 and 10, their sum will be 11
        
        let contactMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if contactMask == PhysicsCategories.ballCategory | PhysicsCategories.switchCategory{ // Contact between the ball and the color switch
            // Check if the body is the ball and assign it to the constant ball
            if let ball = contact.bodyA.node?.name == "Ball" ? contact.bodyA.node as? SKSpriteNode : contact.bodyB.node as? SKSpriteNode{
                if currentColorIndex == switchState.rawValue{
                    score += 1
                    updateScore()
                    ball.run(SKAction.fadeOut(withDuration: 0.25), completion: {
                        // Remove old ball
                        ball.removeFromParent()
                        // Spawn new ball
                        self.spawnBall()
                    })
                }else{
                    gameOver()
                }
            }
        }
    }
}
