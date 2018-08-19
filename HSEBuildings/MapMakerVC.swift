//
//  MapMakerVC.swift
//  HSEBuildings
//
//  Created by Андрей on 17.02.2018.
//  Copyright © 2018 Андрей. All rights reserved.
//

import UIKit
import SpriteKit

class MapMakerVC: UIViewController {

    let figureUser = SKSpriteNode(imageNamed: "circle")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        figureUser.position = CGPoint(x: 25, y: 25)
        
        figureUser.name = "circle"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    private var movingNode: SKNode? = nil
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch = touches.first!
        let touchLocation = touch.location(in: self.figureUser)
//        let node = self.nodesAtPoint(touchLocation)
        
//        if (node.name == "circle") {
//            movingNode = node
//        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard (movingNode != nil) else { return }
        let touch = touches.first
        let touchLocation = touch!.location(in: self.figureUser)
        let moveAction = SKAction.move(to: touchLocation, duration: 0)
        figureUser.run(moveAction)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        movingNode = nil
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
