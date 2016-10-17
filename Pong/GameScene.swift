//
//  GameScene.swift
//  Pong
//
//  Created by Omar Baradei on 10/13/16.
//  Copyright © 2016 Omar Baradei. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var ball = SKSpriteNode()
    var enemy = SKSpriteNode()
    var main = SKSpriteNode()
    var leftScoreLabel = SKLabelNode()
    var rightScoreLabel = SKLabelNode()
    var leftScore = 0
    var rightScore = 0
    var numCollisions = 0
    var resetBallForMain = false
    var resetBallForEnemy = false
    var enemySpeed = 0.18
    
    override func didMove(to view: SKView) {
        
        ball = self.childNode(withName: "ball") as! SKSpriteNode
        enemy = self.childNode(withName: "enemy") as! SKSpriteNode
        main = self.childNode(withName: "main") as! SKSpriteNode
        leftScoreLabel = self.childNode(withName: "leftScore") as! SKLabelNode
        rightScoreLabel = self.childNode(withName: "rightScore") as! SKLabelNode
        
        let border = SKPhysicsBody(edgeLoopFrom: self.frame)
        border.friction = 0
        border.restitution = 1
        self.physicsBody = border
        self.physicsBody?.categoryBitMask = 0x3
        physicsWorld.contactDelegate = self
        
        let delay = SKAction.wait(forDuration: 1.5)
        self.run(delay) {
            //run code here after 2 sec
            self.leftScoreLabel.isHidden = true
            self.rightScoreLabel.isHidden = true
            self.ball.physicsBody?.applyImpulse(CGVector(dx: 17, dy: 19))
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            main.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            main.run(SKAction.moveTo(x: location.x, duration: 0.1))
        }
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        if (contact.bodyA.categoryBitMask == 3 && contact.bodyB.categoryBitMask == 2) || (contact.bodyB.categoryBitMask == 2 && contact.bodyB.categoryBitMask == 3) {
            if contact.contactPoint.y > 653 {
                leftScore += 1
                resetBallForEnemy = true
                enemySpeed = 0.15
            } else if contact.contactPoint.y < -653 {
                rightScore += 1
                resetBallForMain = true
                enemySpeed = 0.15
            }
        } else {
            if ((ball.physicsBody?.velocity.dx)! > CGFloat(0) && (ball.physicsBody?.velocity.dy)! > CGFloat(0)) {
                ball.physicsBody?.velocity.dx += 38
                ball.physicsBody?.velocity.dy += 41
                if (enemySpeed > 0.05) {
                    enemySpeed -= 0.01
                }
            } else {
                ball.physicsBody?.velocity.dx -= 38
                ball.physicsBody?.velocity.dy -= 41
                if (enemySpeed > 0.05) {
                    enemySpeed -= 0.01
                }
            }
        }
    }
    
    func didEnd(_ contact: SKPhysicsContact) {
        // this gets called automatically when two objects end contact with each other
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        if ((ball.physicsBody?.velocity.dy)! > CGFloat(0) && ball.position.y > 0) {
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: enemySpeed))
        } else if ((ball.physicsBody?.velocity.dy)! < CGFloat(0) && ball.position.y > 0) {
            enemy.run(SKAction.moveTo(x: 0, duration: 0.45))
        } else if ((ball.physicsBody?.velocity.dy)! < CGFloat(0) && ball.position.y < 0) {
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: enemySpeed + 0.8))
        } else {
            enemy.run(SKAction.moveTo(x: ball.position.x, duration: enemySpeed + 0.2))
        }
        if (resetBallForEnemy) {
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            leftScoreLabel.text = String(leftScore)
            leftScoreLabel.isHidden = false
            rightScoreLabel.isHidden = false
            ball.position = CGPoint(x: 0, y: 0)
            let delay = SKAction.wait(forDuration: 1.5)
            self.run(delay) {
                //run code here after 1.5 secs
                self.leftScoreLabel.isHidden = true
                self.rightScoreLabel.isHidden = true
                self.ball.physicsBody?.applyImpulse(CGVector(dx: 17, dy: 19))
            }
            resetBallForEnemy = false
        } else if (resetBallForMain) {
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
            rightScoreLabel.text = String(rightScore)
            leftScoreLabel.isHidden = false
            rightScoreLabel.isHidden = false
            ball.position = CGPoint(x: 0, y: 0)
            let delay = SKAction.wait(forDuration: 1.5)
            self.run(delay) {
                //run code here after 1.5 secs
                self.leftScoreLabel.isHidden = true
                self.rightScoreLabel.isHidden = true
                self.ball.physicsBody?.applyImpulse(CGVector(dx: -17, dy: -19))
            }
            resetBallForMain = false
        } else if ((ball.physicsBody?.velocity.dy)! < CGFloat(5) && (ball.physicsBody?.velocity.dy)! > CGFloat(0)) {
            print("speeding up ball")
            ball.physicsBody?.velocity.dy += 8
        } else if ((ball.physicsBody?.velocity.dy)! > CGFloat(-5) && (ball.physicsBody?.velocity.dy)! < CGFloat(0)) {
            print("speeding up ball")
            ball.physicsBody?.velocity.dy -= 8
        }
    }
}
