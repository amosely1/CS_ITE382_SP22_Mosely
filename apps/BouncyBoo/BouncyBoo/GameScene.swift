//
//  GameScene.swift
//  BouncyBoo
//
//  Created by Alyson Mosely on 3/24/22.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var Ground = SKSpriteNode()
    var Ghost = SKSpriteNode()
    
    override func didMove(to view: SKView) {
        
        //Add ground from assests
        Ground = SKSpriteNode(imageNamed: "Ground")
      //  Ground.setScale(0.5)
        //Editing position of ground
        Ground.position = CGPoint(x: 0.5, y: -617)
        self.addChild(Ground)
        
        //Set the size of ghost
        Ghost = SKSpriteNode(imageNamed: "GhostIcon")
        Ghost.size = CGSize(width: 800, height: 1000)
        Ghost.position = CGPoint(x: self.frame.width / 2 - Ghost.frame.width, y: self.frame.height / 2)
        self.addChild(Ghost)
        
        createWalls()
        
        

        
        
    
        }


    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        }
    
    func createWalls(){
        
        let wallPair = SKNode()
        
        let topWall = SKSpriteNode(imageNamed: "Wall")
        let btmWall = SKSpriteNode(imageNamed: "Wall")
        
        topWall.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        btmWall.position = CGPoint(x: self.frame.width / 2, y: self.frame.height / 2)
        
        topWall.setScale(0.5)
        btmWall.setScale(0.5)
        
        wallPair.addChild(topWall)
        wallPair.addChild(btmWall)
        
        self.addChild(wallPair)
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
    
}
