//
//  GameScene.swift
//  Project11
//
//  Created by Nicolas Audren on 17/03/2016.
//  Copyright (c) 2016 Nicosoft. All rights reserved.
//

import GameplayKit
import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // MARK: Properties
    let gameObjectNames = ["ball", "bouncer", "goodSlot", "badSlot", "glow", "particles"]
    
    var remainingBallsLabel: SKLabelNode!
    
    var remainingBalls: Int = 10 {
        didSet {
            remainingBallsLabel.text = "Remaining Balls: \(remainingBalls)"
        }
    }
    
    var scoreLabel: SKLabelNode!
    
    var score: Int = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)/\(level!.scoreNeededToClear)"
            if score >= level!.scoreNeededToClear {
                currentLevel += 1
            }
        }
    }
    
    var restartLabel: SKLabelNode!
    
    var level : LevelData?
    
    var currentLevel : Int = 0 {
        didSet {
            clearLevel()
            loadLevel()
            if (level != nil) {
                createLevel()
            }
            
        }
    }
    
    // MARK: SKScene
    
    override func didMoveToView(view: SKView) {
        clearLevel()
        initialiseGame()
        currentLevel = 1
        if (level != nil) {
            createLevel()
        }
    }
    
    func loadLevel() {
        if let levelPath = NSBundle.mainBundle().pathForResource("Level\(currentLevel)", ofType: "txt") {
            if let levelData = NSData(contentsOfFile: levelPath){
                level = LevelData(fromJSON: JSON(data: levelData))
            }
        }
        else {
            level = nil
            removeAllChildren()
            showEndGameScreen()
        }
    }
    
    func showEndGameScreen() {
        // Create the background image
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.zPosition = -1
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        addChild(background)
        
        //UI
        let congratsLabel = SKLabelNode(fontNamed: "Chalkduster")
        congratsLabel.text = "Congratulations!"
        congratsLabel.horizontalAlignmentMode = .Center
        congratsLabel.position = CGPoint(x: 512, y: 384)
        addChild(congratsLabel)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        /* Called when a touch begins */
        
        if let touch = touches.first {
            let location = touch.locationInNode(self)
            
            let objects = nodesAtPoint(location) as [SKNode]
            
            if objects.contains(restartLabel){
                restartGame()
            }
            else if (level != nil){
                makeBallAt(location)
            }
        }
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
    }
    
    func restartGame() {
        removeAllChildren()
        initialiseGame()
        clearLevel()
        if (level != nil) {
            createLevel()
        }
    }
    
    
    func initialiseGame() {
        
        // Create the background image
        let background = SKSpriteNode(imageNamed: "background.jpg")
        background.zPosition = -1
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .Replace
        addChild(background)
        
        
        //Physics
        physicsBody = SKPhysicsBody(edgeLoopFromRect: frame) //put border around whole scene
        physicsWorld.contactDelegate = self
        
        //UI
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .Right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)
        
        remainingBallsLabel = SKLabelNode(fontNamed: "Chalkduster")
        remainingBallsLabel.text = "Remaining Balls: \(remainingBalls)"
        remainingBallsLabel.horizontalAlignmentMode = .Right
        remainingBallsLabel.position = CGPoint(x: 980, y: 650)
        addChild(remainingBallsLabel)
        
        restartLabel = SKLabelNode(fontNamed: "Chalkduster")
        restartLabel.text = "Restart"
        restartLabel.position = CGPoint(x: 80, y: 700)
        addChild(restartLabel)
        
    }
    
    func createLevel() {
        // Add Slots
        for slot in level!.slots {
            makeSlotAt(slot.position, type: slot.type)
        }
        
        // Add Bouncers
        
        for bouncer in level!.bouncers {
            makeBouncer(fromData: bouncer)
        }

        score = 0
        remainingBalls = level!.startingBalls
    }
    
    func clearLevel() {
        

        var gameObjects = [SKNode]()
        for node in children {
            if isGameObject(node) {
                gameObjects.append(node)
            }
        }
        
        removeChildrenInArray(gameObjects)
        
        //debug print nodes
        var i : Int = 1
        for child in children{
            print("\(i) - ")
            print(child, separator: "", terminator: "\n")
            i += 1
        }        
    }
    
    func isGameObject(node: SKNode) -> Bool {
        if let nodeName = node.name {
            if gameObjectNames.contains(nodeName){
                return true
            }
            
        }
        return false
    }
    
    // MARK: - makeObjectAt
    
    func makeBallAt(position: CGPoint) {
        if remainingBalls > 0 {
            var imageName = ""
            switch level!.scorePerBall {
            case 1:
                imageName = "ballRed"
            case 2:
                imageName = "ballBlue"
            case 3:
                imageName = "ballCyan"
            case 4:
                imageName = "ballGreen"
            case 5:
                imageName = "ballYellow"
            default:
                imageName = ""
            }
            let ball = SKSpriteNode(imageNamed: imageName)
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
            ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
            ball.physicsBody!.restitution = 0.4
            ball.position = position
            ball.position.y = 700
            ball.name = "ball"
            remainingBalls -= 1
            addChild(ball)
        }
        
    }
    
    func makeBouncer(fromData data: BouncerData) {
        let position = data.position
        switch data.moveDirection {
        case .None:
            makeBouncerAt(position)
            
        case .Left,.Right:
            
            let xDelta = data.moveDistance * data.moveDirection.multiplier()
            
            let endPos = CGPoint(x: position.x + xDelta, y: position.y)
            
            let firstAction = SKAction.moveTo(endPos, duration: data.moveDuration)
            let secondAction = SKAction.moveTo(position, duration: data.moveDuration)
            
            let bouncerMovement = SKAction.repeatActionForever(SKAction.sequence([firstAction,secondAction]))
            
            makeBouncerAt(position, withAction: bouncerMovement)
        }
    }
    
    func makeBouncerAt(position: CGPoint) -> SKSpriteNode {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody!.contactTestBitMask = bouncer.physicsBody!.collisionBitMask
        bouncer.physicsBody!.dynamic = false
        bouncer.name = "bouncer"
        addChild(bouncer)
        return bouncer
    }
    
    func makeBouncerAt(position: CGPoint, withAction action: SKAction) {
        let bouncer = makeBouncerAt(position)
        //bouncer.name = "movingBouncer"
        bouncer.runAction(action)
    }
    
    func makeSlotAt(position: CGPoint, type: SlotType) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode
        var spin: SKAction
        switch type {
        case .Good:
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotBase.name = "goodSlot"
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            spin = SKAction.rotateByAngle(CGFloat(-M_PI_2), duration: 1.5)
        case .Bad:
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotBase.name = "badSlot"
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            spin = SKAction.rotateByAngle(CGFloat(M_PI_2), duration: 1.5)
        default:
            return
        }
        
        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOfSize: slotBase.size)
        slotBase.physicsBody!.dynamic = false
        
        slotGlow.position = position
        slotGlow.name = "glow"
        
        addChild(slotBase)
        addChild(slotGlow)
        
        let spinForever = SKAction.repeatActionForever(spin)
        slotGlow.runAction(spinForever)
    }
    
    // MARK: - Physics
    
    func collisionBetweenBall(ball: SKNode, object: SKNode) {
        if object.name == "goodSlot" {
            score += level!.scorePerBall
            remainingBalls += 1
            destroyBall(ball)
        } else if object.name == "badSlot" {
            if score > 0 {
                score -= 1
            }
            
            destroyBall(ball)
        }
    }
    
    func destroyBall(ball: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "SparkParticle") {
            fireParticles.position = ball.position
            fireParticles.name = "particles"
            addChild(fireParticles)
        }
        ball.removeFromParent()
    }
    
    // MARK: - SKPhysicsContactDelegate
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.node!.name == "ball" {
            collisionBetweenBall(contact.bodyA.node!, object: contact.bodyB.node!)
        } else if contact.bodyB.node!.name == "ball" {
            collisionBetweenBall(contact.bodyB.node!, object: contact.bodyA.node!)
        }
    }
}
