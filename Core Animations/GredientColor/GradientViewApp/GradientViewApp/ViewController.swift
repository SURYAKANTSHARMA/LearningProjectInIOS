//
//  ViewController.swift
//  GradientViewApp
//
//  Created by Mac mini on 8/30/18.
//  Copyright © 2018 Mac mini. All rights reserved.
//

import UIKit

enum PanDirections: Int {
    case Right
    case Left
    case Bottom
    case Top
    case TopLeftToBottomRight
    case TopRightToBottomLeft
    case BottomLeftToTopRight
    case BottomRightToTopLeft
}

class ViewController: UIViewController, CAAnimationDelegate {

    var gradientLayer: CAGradientLayer!
    var colorSets = [[CGColor]]()
    var currentColorSet: Int!
    var panDirection: PanDirections!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createColorSets()
        configureGradientLayer()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(gestureRecognizer:)))
        self.view.addGestureRecognizer(tapGestureRecognizer)
        let twoFingerTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTwoFingerTapGesture(gestureRecognizer:)))
        twoFingerTapGestureRecognizer.numberOfTouchesRequired = 2
        self.view.addGestureRecognizer(twoFingerTapGestureRecognizer)
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGestureRecognizer(gestureRecognizer:)))
        self.view.addGestureRecognizer(panGestureRecognizer)
    }
    
    func createColorSets() {
        colorSets.append([UIColor.red.cgColor, UIColor.yellow.cgColor])
        colorSets.append([UIColor.green.cgColor, UIColor.magenta.cgColor])
        colorSets.append([UIColor.gray.cgColor, UIColor.lightGray.cgColor])
        currentColorSet = 0
    }
    
    func configureGradientLayer() {
        gradientLayer = CAGradientLayer()
        gradientLayer.colors = colorSets[currentColorSet] // [UIColor.blue.cgColor, UIColor.red.cgColor, UIColor.orange.cgColor, UIColor.brown.cgColor, UIColor.yellow.cgColor]
        gradientLayer.frame = view.frame
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.5)
        view.layer.addSublayer(gradientLayer )
    }
    
    @objc func handleTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        currentColorSet = (currentColorSet + 1)
        if currentColorSet > colorSets.count - 1 {
            currentColorSet =  currentColorSet % colorSets.count
        }
        print(currentColorSet)
        
        let colorChangingAnimation = CABasicAnimation(keyPath: "colors")
        colorChangingAnimation.duration = 2
        colorChangingAnimation.toValue = colorSets[currentColorSet]
        colorChangingAnimation.fillMode = kCAFillModeForwards
        colorChangingAnimation.isRemovedOnCompletion = false
        colorChangingAnimation.delegate = self
        gradientLayer.add(colorChangingAnimation, forKey: "colorChanged")
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if flag {
            gradientLayer.colors = colorSets[currentColorSet]
        }
    }
    
    @objc func handleTwoFingerTapGesture(gestureRecognizer: UITapGestureRecognizer) {
        let secondColorLocation = arc4random_uniform(100)
        let firstColorLocation = arc4random_uniform(secondColorLocation-1)
        
        gradientLayer.locations = [NSNumber(value: Double(firstColorLocation)/100.0), NSNumber(value: Double(secondColorLocation)/100.0)]
        print(gradientLayer.locations!)
    }
    
    @objc func handlePanGestureRecognizer(gestureRecognizer: UIPanGestureRecognizer) {
        let velocity = gestureRecognizer.velocity(in: self.view)
        
        if gestureRecognizer.state == UIGestureRecognizerState.changed {
        if velocity.x > 300.0 {
            // In this case the direction is generally towards Right.
            // Below are specific cases regarding the vertical movement of the gesture.
            
            if velocity.y > 300.0 {
                // Movement from Top-Left to Bottom-Right.
                panDirection = PanDirections.TopLeftToBottomRight
            }
            else if velocity.y < -300.0 {
                // Movement from Bottom-Left to Top-Right.
                panDirection = PanDirections.BottomLeftToTopRight
            }
            else {
                // Movement towards Right.
                panDirection = PanDirections.Right
            }
        }
        else if velocity.x < -300.0 {
            // In this case the direction is generally towards Left.
            // Below are specific cases regarding the vertical movement of the gesture.
            
            if velocity.y > 300.0 {
                // Movement from Top-Right to Bottom-Left.
                panDirection = PanDirections.TopRightToBottomLeft
            }
            else if velocity.y < -300.0 {
                // Movement from Bottom-Right to Top-Left.
                panDirection = PanDirections.BottomRightToTopLeft
            }
            else {
                // Movement towards Left.
                panDirection = PanDirections.Left
            }
        }
        else {
            // In this case the movement is mostly vertical (towards bottom or top).
            
            if velocity.y > 300.0 {
                // Movement towards Bottom.
                panDirection = PanDirections.Bottom
            }
            else if velocity.y < -300.0 {
                // Movement towards Top.
                panDirection = PanDirections.Top
            }
            else {
                // Do nothing.
                panDirection = nil
            }
        }
     } else if gestureRecognizer.state == UIGestureRecognizerState.ended {
           changeGradientDirection()
      }
    }
    
    func changeGradientDirection() {
            if panDirection != nil {
                switch panDirection.rawValue {
                case PanDirections.Right.rawValue:
                    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
                    gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
                case PanDirections.Left.rawValue:
                    gradientLayer.startPoint = CGPoint(x: 1, y: 0.5)
                    gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)

                case PanDirections.Bottom.rawValue:
                    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
                    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
                case PanDirections.Top.rawValue:
                    gradientLayer.startPoint = CGPoint(x: 0.5, y: 1)
                    gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
                case PanDirections.TopLeftToBottomRight.rawValue:
                    gradientLayer.startPoint = CGPoint(x: 0, y: 0)
                    gradientLayer.endPoint = CGPoint(x: 1, y: 1)
                case PanDirections.TopRightToBottomLeft.rawValue:
                    gradientLayer.startPoint = CGPoint(x: 1, y: 0)
                    gradientLayer.endPoint = CGPoint(x: 0, y: 1)
                case PanDirections.BottomLeftToTopRight.rawValue:
                    gradientLayer.startPoint = CGPoint(x: 0, y: 1)
                    gradientLayer.endPoint = CGPoint(x: 1, y: 0)
                default:
                    gradientLayer.startPoint = CGPoint(x: 1, y: 1)
                    gradientLayer.endPoint = CGPoint(x: 0, y: 0)
                    
                }
            }
        }
        
}

