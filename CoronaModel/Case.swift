//
//  Case.swift
//  CoronaModel
//
//  Created by Caroline on 4/28/20.
//  Copyright © 2020 CarolineEvans. All rights reserved.
//

import UIKit
import SpriteKit


enum caseStatus : CaseIterable {
    case healthy
    case infected
    case recovered
}

class Case: SKSpriteNode {
    var status : caseStatus = .healthy
    // Keep track of how many people I infect 
    var infectedByMe : Int
    var recoversBy : Date!

    
    override init(texture: SKTexture!, color: SKColor!, size: CGSize) {
        self.infectedByMe = 0
        super.init(texture: texture, color: color, size: size)
        /*
            This physicsBody stuff defines how the sprites interact with other
            sprites in the mapScene.
         */
        super.physicsBody = SKPhysicsBody(rectangleOf: size)
        super.physicsBody!.isDynamic = true
        super.physicsBody!.collisionBitMask = 2 // should bounce off of edges but not other people
        super.physicsBody!.contactTestBitMask = 1 // contacts other cases
        super.physicsBody!.categoryBitMask = 1 // is personally of "category" case
        
        let duration : TimeInterval = Double.random(in: 0..<1) < 0.5 ? 14 : 7
        // add probabilistic death case
        // as of April 23 the mortality rate in philly is 11226/443
        let timeNow = Date()
        recoversBy = timeNow.addingTimeInterval(duration)
        
    }
    
    private func remainingTime() -> TimeInterval {
        let rightNow = Date()
        let remainingSeconds = recoversBy.timeIntervalSince(rightNow)
        return max(remainingSeconds, 0)
    }
    
    func update () {
        if self.status == .infected && remainingTime() == 0 {
            self.status = .recovered
            super.color = .blue
        }
        
    }
    
    convenience init(at position: CGPoint, status: caseStatus) {
        let radius = 11
        let size = CGSize(width: radius, height: radius)
        
        
        var color: SKColor
        switch(status) {
        case .healthy:
            color = .green
            break
        case .infected:
            color = .red
            break
        case .recovered:
            color = .blue
        }
        self.init(texture:nil, color: color, size: size)
        super.position = position
        self.status = status
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.status = .healthy
        self.infectedByMe = 0
        super.init(coder: aDecoder)
    }
    
    func didContact (withCase otherCase : Case) -> Bool {
        
        let otherStatus = otherCase.status
        if otherStatus == .infected && self.status == .healthy {
            self.status = .infected
            super.color = .red
            otherCase.infectedByMe += 1
            let duration : TimeInterval = 7;
            let timeNow = Date()
            recoversBy = timeNow.addingTimeInterval(duration)
            return true
        }
        return false
    }
    
    
}
