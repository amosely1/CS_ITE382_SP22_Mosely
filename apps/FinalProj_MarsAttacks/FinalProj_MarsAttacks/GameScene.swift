//
//  GameScene.swift
//  FinalProj_MarsAttacks
//
//  Created by Alyson Mosely on 4/9/22.
//

import SpriteKit
import GameplayKit
import AVFoundation

//declare public so other scenes can access
//Set up score for game
    var gameScore = 0

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    
    let scoreLabel = SKLabelNode(fontNamed: "A-Space Black Demo")
    
    //start setting up levels
    var levelNumber = 0
    
    //start setting up lives
    var livesNumber = 3
    let livesLabel = SKLabelNode(fontNamed: "A-Space Black Demo")
    
    
    //Globally declare playerShip to be used in other functions
    let player = SKSpriteNode(imageNamed: "playerShip")
    
    let bulletSound = SKAction.playSoundFileNamed("Fire.wav", waitForCompletion: false)
    let explosionSound = SKAction.playSoundFileNamed("Explosion.wav", waitForCompletion: false)
    let gameOverSound = SKAction.playSoundFileNamed("GameOver.wav", waitForCompletion: true)
    
    //set up game state machine
    enum gameState{
        case preGame //when the game state is before the start of game
        case inGame //during the game
        case afterGame //state after the game
    }
    
    var currentGameState = gameState.inGame

    
    //set up 4 categories for physics body
    struct PhysicsCategories{
        static let None: UInt32 = 0
        static let Player: UInt32 = 0b1 //binary 1
        static let Bullet: UInt32 = 0b10 //binary 2
        static let Enemy: UInt32 = 0b100 //binary 4
    }
    
    //Random function to help spawn enemy ships
    func random() -> CGFloat{
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    func random(min min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    //Find the playable game area
    var gameArea: CGRect
    
    override init(size: CGSize){
        
        let maxAspectRatio: CGFloat = 16.0/9.0
        let playableWidth = size.height / maxAspectRatio
        let margin = (size.width - playableWidth) / 2
        
        //set up game area
        gameArea = CGRect(x: margin, y: 0, width: playableWidth, height: size.height)
        
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Initialize background, player
    override func didMove(to view: SKView) {
        
        gameScore = 0
        
        self.physicsWorld.contactDelegate = self
        
        let background = SKSpriteNode(imageNamed: "background")
        background.size = self.size
        background.position = CGPoint(x: self.size.width/2, y: self.size.height/2)
        background.zPosition = 0
        self.addChild(background)
        
        
        player.setScale(1.5)
        player.position = CGPoint(x: self.size.width/2, y: self.size.height * 0.2)
        player.zPosition = 2
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        //don't let this player be affected by graity
        player.physicsBody!.affectedByGravity = false
        player.physicsBody!.categoryBitMask = PhysicsCategories.Player
        player.physicsBody!.collisionBitMask = PhysicsCategories.None
        player.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(player)
        
        //set up score label
        scoreLabel.text = "Score: 0"
        scoreLabel.fontSize = 70
        scoreLabel.fontColor = SKColor.white
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.left
        scoreLabel.position = CGPoint(x: self.size.width * 0.14, y: self.size.height * 0.9)
        scoreLabel.zPosition = 100 //to make sure it is always on top
        self.addChild(scoreLabel)
        
        
        //set up lives
        livesLabel.text = "Lives: 3"
        livesLabel.fontSize = 70
        livesLabel.fontColor = SKColor.white
        livesLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.right
        livesLabel.position = CGPoint(x: self.size.width*0.85, y: self.size.height*0.9)
        livesLabel.zPosition = 100
        self.addChild(livesLabel)
        
        
        //start the game
        startNewLevel()
        
    }
    
    //function to take away from lives
    func loseALife(){
        
        livesNumber -= 1
        livesLabel.text = "Lives: \(livesNumber)"
        
        //make the label bounce
        let scaleUp = SKAction.scale(to: 1.5, duration: 0.2)
        let scaleDown = SKAction.scale(to: 1, duration: 0.2)
        let scaleSequence = SKAction.sequence([scaleUp, scaleDown])
        livesLabel.run(scaleSequence)
        
        //end the game
        if livesNumber == 0 {
            runGameOver()
        }
    }
    
    
    
    //function to hndle score
    func addScore(){
        
        gameScore += 1
        scoreLabel.text = "Score: \(gameScore)"
        
        //when reach this score, start new level
        if gameScore == 10 || gameScore == 25 || gameScore == 50 {
            startNewLevel()
        }
        
    }
    
    //function to end the game
    func runGameOver() {
        
        //change game state
        currentGameState = gameState.afterGame
        
        //stop everything
        self.removeAllActions()
        
        //stop all bullets
        self.enumerateChildNodes(withName: "Bullet"){bullet, stop in
            bullet.removeAllActions()
        }
        
        //stop all enemies
        self.enumerateChildNodes(withName: "Enemy"){
            enemy, stop in
            
            enemy.removeAllActions()
        }
        
        //change to game over screen
        let changeSceneAction = SKAction.run(changeScene)
        let waitToChangeScene = SKAction.wait(forDuration: 1)
        let changeSceneSequence = SKAction.sequence([waitToChangeScene, gameOverSound, changeSceneAction])
        self.run(changeSceneSequence)
        
        
    
    }
    
    //function to display game over scene file
    func changeScene(){
        
        let sceneToMoveTo = GameOverScene(size: self.size)
        sceneToMoveTo.scaleMode = self.scaleMode
        let myTransition = SKTransition.fade(withDuration: 0.5)
        self.view!.presentScene(sceneToMoveTo, transition: myTransition)
    }
    
    //function on what happens when physics bodies collide
    func didBegin(_ contact: SKPhysicsContact){
        
        var body1 = SKPhysicsBody()
        var body2 = SKPhysicsBody()
        
        //Grab contact num from bodyA and bodyB, if less than then they're already in num order
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            body1 = contact.bodyA
            body2 = contact.bodyB
        } else { //if not in order, put them in order
            body1 = contact.bodyB
            body2 = contact.bodyA
        }
        
        if body1.categoryBitMask == PhysicsCategories.Player && body2.categoryBitMask == PhysicsCategories.Enemy{
            //if the player has hit the enemy
            if body1.node != nil {
                spawnExplosion(spawnPosition: body1.node!.position)
            }
            
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent() //delete player
            body2.node?.removeFromParent() //delete enemy
            
            //end the game
            runGameOver()
        }
        
        if body1.categoryBitMask == PhysicsCategories.Bullet && body2.categoryBitMask == PhysicsCategories.Enemy {
            
            if body2.node! == nil {
                if body2.node!.position.y > self.size.height {
                    return
                    //if the enemy is off the top of the screen, reuturn
                } else {
                    spawnExplosion(spawnPosition: body2.node!.position)
                }
            }
            //if the bullet has hit the enemy
            
            addScore()
            
            if body2.node != nil {
                spawnExplosion(spawnPosition: body2.node!.position)
            }
            
            body1.node?.removeFromParent() //delete bullet
            body2.node?.removeFromParent() //delete enemy
        }
    }
    
    //function to explode sprites
    func spawnExplosion(spawnPosition: CGPoint){
        
        let explosion = SKSpriteNode(imageNamed: "explosion")
        explosion.position = spawnPosition
        explosion.zPosition = 3
        explosion.setScale(0)
        self.addChild(explosion)
        
        let scaleIn = SKAction.scale(to: 1, duration: 0.1)
        let fadeOut = SKAction.fadeIn(withDuration: 0.1)
        let delete = SKAction.removeFromParent()
        
        let explosionSequence = SKAction.sequence([explosionSound, scaleIn, fadeOut, delete])
        
        explosion.run(explosionSequence)
        
        
        
    }
    
    
    func startNewLevel(){
        
        //increment level
        levelNumber += 1
        
        //when we start a new level, stop this action
        if self.action(forKey: "spawningEnemies") != nil{
            self.removeAction(forKey: "spawningEnemies")
        }
        
        //Set up levels with time interal
        var levelDuration = TimeInterval()
        
        switch levelNumber {
        case 1: levelDuration = 1.2
        case 2: levelDuration = 1
        case 3: levelDuration = 0.8
        case 4: levelDuration = 0.5
        default:
            levelDuration = 0.5
            print("cannot find level info")
            
        }
        
        //set up enemy to spawn forever
        let spawn = SKAction.run(spawnEnemy)
        let waitToSpawn = SKAction.wait(forDuration: levelDuration)
        let spawnSequence = SKAction.sequence([waitToSpawn, spawn])
        let spawnForever = SKAction.repeatForever(spawnSequence)
        self.run(spawnForever, withKey: "spawningEnemies")
        
        //can add more code later for multiple levels
    
    }
    
    //funtion to initialize bullet and fire
    func fireBullet() {
        
        let bullet = SKSpriteNode(imageNamed: "bullet")
        bullet.name = "Bullet" //reference name for other functions to use
        bullet.setScale(1)
        bullet.position = player.position
        bullet.zPosition = 1
        bullet.physicsBody = SKPhysicsBody(rectangleOf: bullet.size)
        bullet.physicsBody!.affectedByGravity = false
        bullet.physicsBody!.categoryBitMask = PhysicsCategories.Bullet
        bullet.physicsBody!.collisionBitMask = PhysicsCategories.None
        bullet.physicsBody!.contactTestBitMask = PhysicsCategories.Enemy
        self.addChild(bullet)
        
        let moveBullet = SKAction.moveTo(y: self.size.height + bullet.size.height, duration: 1)
        let deleteBullet = SKAction.removeFromParent()
        let bulletSequence = SKAction.sequence([bulletSound, moveBullet, deleteBullet])
        bullet.run(bulletSequence)
    }
    
    //function to spawn the enemy ships
    func spawnEnemy(){
        
        //Generate random x
        let randomXStart = random(min: gameArea.minX, max: gameArea.maxX)
        let randomXEnd = random(min: gameArea.minX, max: gameArea.maxX)
        
        let startPoint = CGPoint(x: randomXStart, y: self.size.height * 1.2)
        let endPoint = CGPoint(x: randomXEnd, y: -self.size.height * 0.2)
        
        //Generate enemy sprite
        let enemy = SKSpriteNode(imageNamed: "enemyShip")
        enemy.name = "Enemy"
        enemy.setScale(1.5)
        enemy.position = startPoint
        enemy.zPosition = 2
        enemy.physicsBody = SKPhysicsBody(rectangleOf: enemy.size)
        enemy.physicsBody!.affectedByGravity = false
        enemy.physicsBody!.categoryBitMask = PhysicsCategories.Enemy
        enemy.physicsBody!.collisionBitMask = PhysicsCategories.None
        enemy.physicsBody!.contactTestBitMask = PhysicsCategories.Player | PhysicsCategories.Bullet
        self.addChild(enemy)
        
        //move and delete enemy
        let moveEnemy = SKAction.move(to: endPoint, duration: 1.5)
        let deleteEnemy = SKAction.removeFromParent()
        let loseALifeAction = SKAction.run(loseALife)
        let enemySequence = SKAction.sequence([moveEnemy, deleteEnemy, loseALifeAction])
        //only let the enemy run if game state is in, just in case of a possible bug
        if currentGameState == gameState.inGame{
            enemy.run(enemySequence)    //call enemy action sequence
        }
        
        //Rotate enemy ship
        //delta x and delta y
        let dx = endPoint.x - startPoint.x
        let dy = endPoint.y - startPoint.y
        let amountToRotate = atan2(dy, dx) //how much to rotate
        enemy.zRotation = amountToRotate
        
    }
    
    //function to tap to fire
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if currentGameState == gameState.inGame {
            fireBullet()
        }
    }
    
    //Function to drag player
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch: AnyObject in touches{
            
            //Figure out where we're touching
            let pointOfTouch = touch.location(in: self)
            let previousPointOfTouch = touch.previousLocation(in: self)
            
            //figure out how far moved
            let amountDragged = pointOfTouch.x - previousPointOfTouch.x
            
            if currentGameState == gameState.inGame {
                //Update the position
                player.position.x += amountDragged
            }
        
            
            //Set playable game area if too far right
            if player.position.x > gameArea.maxX - player.size.width/2{
                player.position.x = gameArea.maxX - player.size.width/2
            }
            
            //Set playable game area if too far left
            if player.position.x < gameArea.minX + player.size.width/2{
                player.position.x = gameArea.minX + player.size.width/2
            }
        }
    }
    
    }
    
