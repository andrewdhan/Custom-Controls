//
//  CustomControl.swift
//  StarControl
//
//  Created by Andrew Dhan on 8/28/18.
//  Copyright © 2018 Andrew Liao. All rights reserved.
//

import UIKit

@IBDesignable class CustomControl: UIControl {
    
    required init? (coder aCoder: NSCoder){
        super.init(coder: aCoder)
        setup()
    }
    
    func setup(){

        for index in 0...4 {
            //create labels and adds tag
            let x = CGFloat(index)*(componentDimension + 8.0)
            let newLabel = UILabel(frame: CGRect(x: x, y: 0, width: componentDimension, height: componentDimension))
            newLabel.tag = index + 1
            
            //style labels
            newLabel.font = UIFont.boldSystemFont(ofSize: 32.0)
            newLabel.textAlignment = .center
            newLabel.text = "★"
            newLabel.textColor = index == 0 ? componentActiveColor : componentInactiveColor
            
            addSubview(newLabel)
            componentLabels.append(newLabel)
        }
        
    }
    
    override var intrinsicContentSize: CGSize {
        let componentsWidth = CGFloat(componentCount) * componentDimension
        let componentsSpacing = CGFloat(componentCount + 1) * 8.0
        let width = componentsWidth + componentsSpacing
        return CGSize(width: width, height: componentDimension)
    }
    //MARK: - Touch Handling Method
    override func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        updateValue(at: touch)
        return true
    }
    
    override func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let touchPoint = touch.location(in: self)
        if  bounds.contains(touchPoint){
            sendActions(for: [.touchDragInside])
            updateValue(at: touch)

        } else {
            sendActions(for: [.touchDragOutside])
        }
        return true
    }
    
    override func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        guard let touch = touch else {return}
        let touchPoint = touch.location(in: self)
        if bounds.contains(touchPoint){
            sendActions(for: [.touchUpInside])
            updateValue(at: touch)
            self.performFlare()
            
        } else {
            sendActions(for: [.touchUpOutside])
        }
    }
    
    override func cancelTracking(with event: UIEvent?) {
        sendActions(for: [.touchCancel])
    }
    
    func updateValue(at touch: UITouch){
        for label in componentLabels {
            let touchPoint = touch.location(in: label)
            if label.bounds.contains(touchPoint){
                if value == label.tag { return}
                value = label.tag
                for label in componentLabels{
                    label.textColor = label.tag <= value ? componentActiveColor : componentInactiveColor
                }
                sendActions(for: [.valueChanged])
            }
        }
    }
    
    //MARK: - Properties
    private(set) var value: Int = 1
    
    private var componentLabels = [UILabel]()
    private let componentDimension: CGFloat = 40.0
    private let componentCount: Int = 5
    private let componentActiveColor = UIColor.black
    private let componentInactiveColor = UIColor.gray
    
}

extension UIView {
    // "Flare view" animation sequence
    func performFlare() {
        func flare()   { transform = CGAffineTransform(scaleX: 1.6, y: 1.6) }
        func unflare() { transform = .identity }
        
        UIView.animate(withDuration: 0.3,
                       animations: { flare() },
                       completion: { _ in UIView.animate(withDuration: 0.1) { unflare() }})
    }
}
