//
//  GameScene.swift
//  FlappyCone
//
//  Created by Diana Febrina Lumbantoruan on 25/11/25.
//

import SpriteKit
import GameplayKit

enum PhysicsCategory {
    static let none: UInt32 = 0
    static let bird: UInt32 = 0b1
    static let obstacle: UInt32 = 0b10
    static let ground: UInt32 = 0b100
    static let scoreGap: UInt32 = 0b1000
}

class GameScene: SKScene {
    var owlNode: SKSpriteNode?
    var scoreLabel: SKLabelNode?
    var backgroundMusic: SKAudioNode?
    var isGameRunning = false
    var score = 0
    
    override func didMove(to view: SKView) {
        setupPhysicsWorld()
        setupBird()
        setupGround()
        setupScore()
        playBackgroundMusic()
        setupStartGameLabel()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !isGameRunning {
            if childNode(withName: "gameOverLabel") != nil {
                resetGame()
            } else {
                startGame()
            }
        } else {
            startJump()
        }
    }
    
    func setupPhysicsWorld() {
        physicsWorld.gravity = CGVector(dx: 0, dy: -6.0)
        physicsWorld.contactDelegate = self
    }
    
    func setupBird() {
        let owlLabel = SKLabelNode(text: "🦉")
        owlLabel.fontSize = 80
        owlLabel.position = CGPoint(x: 2, y: 2)
        owlLabel.verticalAlignmentMode = .center
        owlNode = SKSpriteNode(color: .clear, size: CGSize(width: 40, height: 40))
        owlNode?.position = CGPoint(x: -100, y: 0)
        owlNode?.physicsBody = SKPhysicsBody(circleOfRadius: (owlNode?.size.width ?? 40) / 2)
        owlNode?.physicsBody?.categoryBitMask = PhysicsCategory.bird
        owlNode?.physicsBody?.collisionBitMask = PhysicsCategory.obstacle | PhysicsCategory.ground
        owlNode?.physicsBody?.contactTestBitMask = PhysicsCategory.obstacle | PhysicsCategory.ground | PhysicsCategory.scoreGap
        owlNode?.zPosition = 5
        owlNode?.physicsBody?.allowsRotation = false
        owlNode?.physicsBody?.isDynamic = false
        owlNode?.addChild(owlLabel)
        if let owlNode = owlNode { addChild(owlNode) }
    }
    
    func setupGround() {
        let ground = SKSpriteNode(color: .brown, size: CGSize(width: size.width * 2, height: 20))
        ground.position = CGPoint(x: 0, y: -size.height/2 + 10)
        ground.physicsBody = SKPhysicsBody(rectangleOf: ground.size)
        ground.physicsBody?.isDynamic = false
        ground.zPosition = 10
        ground.physicsBody?.categoryBitMask = PhysicsCategory.ground
        addChild(ground)
    }
    
    func setupScore() {
        scoreLabel = SKLabelNode(fontNamed: "Avenir-Black")
        scoreLabel?.fontSize = 60
        scoreLabel?.text = "0"
        scoreLabel?.position = CGPoint(x: 0, y: size.height/2 - 150)
        scoreLabel?.zPosition = 100
        if let scoreLabel = scoreLabel { addChild(scoreLabel) }
    }
    
    func playBackgroundMusic() {
        if let musicURL = Bundle.main.url(forResource: "bg-music-flappy-cone", withExtension: "wav") {
            backgroundMusic = SKAudioNode(url: musicURL)
            backgroundMusic?.autoplayLooped = true
            if let backgroundMusic = backgroundMusic { addChild(backgroundMusic) }
        }
    }
    
    func setupStartGameLabel() {
        let startLabel = SKLabelNode(text: "Tap to Start")
        startLabel.fontName = "Avenir-Black"
        startLabel.fontSize = 50
        startLabel.fontColor = .red
        startLabel.position = CGPoint(x: 0, y: 100)
        startLabel.name = "startLabel"
        addChild(startLabel)
    }
    
    func startGame() {
        isGameRunning = true
        owlNode?.physicsBody?.isDynamic = true
        
        if let label = childNode(withName: "startLabel") {
            label.removeFromParent()
        }
        
        let spawnAction = SKAction.run { [weak self] in
            self?.spawnPipes()
        }
        let waitAction = SKAction.wait(forDuration: 2.5)
        let sequence = SKAction.sequence([spawnAction, waitAction])
        run(SKAction.repeatForever(sequence), withKey: "spawningPipes")
        
        startJump()
    }
    
    func startJump() {
        owlNode?.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        owlNode?.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 25))
    }
    
    func spawnPipes() {
        let pipeWidth: CGFloat = 60
        let pipeHeight: CGFloat = 500
        let gapHeight: CGFloat = 170
        let randomY = CGFloat.random(in: -100...100)
        
        let pipePair = SKNode()
        pipePair.position = CGPoint(x: size.width/2 + 50, y: 0)
        pipePair.zPosition = 1
    
        let pipeBottomBox = SKSpriteNode(color: .green, size: CGSize(width: pipeWidth, height: pipeHeight))
        pipeBottomBox.position = CGPoint(x: 0, y: -pipeHeight/2 - gapHeight/2 + randomY)
        pipeBottomBox.physicsBody = SKPhysicsBody(rectangleOf: pipeBottomBox.size)
        pipeBottomBox.physicsBody?.isDynamic = false
        pipeBottomBox.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        pipePair.addChild(pipeBottomBox)
        
        let pipeTopBox = SKSpriteNode(color: .green, size: CGSize(width: pipeWidth, height: pipeHeight))
        pipeTopBox.position = CGPoint(x: 0, y: pipeHeight/2 + gapHeight/2 + randomY)
        pipeTopBox.physicsBody = SKPhysicsBody(rectangleOf: pipeTopBox.size)
        pipeTopBox.physicsBody?.isDynamic = false
        pipeTopBox.physicsBody?.categoryBitMask = PhysicsCategory.obstacle
        pipePair.addChild(pipeTopBox)
        
        let scoreNode = SKNode()
        scoreNode.position = CGPoint(x: 0, y: randomY)
        let scoreBody = SKPhysicsBody(rectangleOf: CGSize(width: 10, height: gapHeight))
        scoreBody.isDynamic = false
        scoreBody.categoryBitMask = PhysicsCategory.scoreGap
        scoreNode.physicsBody = scoreBody
        pipePair.addChild(scoreNode)
        
        let moveDistance = size.width + 100
        let moveAction = SKAction.moveBy(x: -moveDistance, y: 0, duration: 4.0)
        let removeAction = SKAction.removeFromParent()
        pipePair.run(SKAction.sequence([moveAction, removeAction]))
        
        addChild(pipePair)
    }
    
    func resetGame() {
        let newScene = GameScene(size: self.size)
        newScene.scaleMode = self.scaleMode
        newScene.anchorPoint = self.anchorPoint
        view?.presentScene(newScene, transition: SKTransition.fade(withDuration: 0.5))
    }
}

extension GameScene: SKPhysicsContactDelegate {
    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        if collision == (PhysicsCategory.bird | PhysicsCategory.obstacle) ||
            collision == (PhysicsCategory.bird | PhysicsCategory.ground) {
            if isGameRunning {
                gameOver()
            }
        }
        
        if collision == (PhysicsCategory.bird | PhysicsCategory.scoreGap) {
            let gapNode = (contact.bodyA.categoryBitMask == PhysicsCategory.scoreGap) ? contact.bodyA.node : contact.bodyB.node
            gapNode?.removeFromParent()
            score += 1
            scoreLabel?.text = "\(score)"
        }
    }
    
    func gameOver() {
        isGameRunning = false
        removeAllActions()
        children.forEach { node in
            node.removeAllActions()
        }
        
        let gameOverLabel = SKLabelNode(text: "Game Over! Tap to Reset")
        gameOverLabel.fontName = "Avenir-Black"
        gameOverLabel.fontColor = .red
        gameOverLabel.fontSize = 50
        gameOverLabel.name = "gameOverLabel"
        addChild(gameOverLabel)
    }
}
