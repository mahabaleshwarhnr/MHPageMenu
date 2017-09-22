//
//  UIView+Extension.swift
//  MHPageMenu
//
//  Created by Mahabaleshwar Hegde on 22/09/17.
//  Copyright © 2017 Mahabaleshwar Hegde. All rights reserved.
//

import UIKit

extension UIView {
    
    func addShadowToView() {
        self.layer.masksToBounds =  false
        self.layer.shadowColor = UIColor.lightGray.cgColor;
        self.layer.shadowOffset = CGSize(width: 5.0, height: 5.0)
        self.layer.shadowOpacity = 1.0
    }
    
    enum  BorderPosition {
        case left
        case right
        case top
        case bottom
    }
    
    /// Add borders to UIView based on position.
    @discardableResult
    func addBorder(borderPostion: BorderPosition, borderColor: UIColor = UIColor.white, borderWidth: CGFloat = 1.0) -> UIView {
        
        
        
        let border = UIView()
        border.backgroundColor = borderColor
        //        border.masksToBounds = true
        //        border.name = borderName
        
        switch borderPostion {
        case .top:
            self.removeBorder()
            border.frame = CGRect(x: 0, y: 0, width: self.bounds.size.width, height: borderWidth)
        case .bottom:
            self.removeBorder()
            border.frame = CGRect(x: 0, y: self.bounds.size.height - borderWidth, width: self.bounds.size.width, height: borderWidth)
        case .left:
            self.removeBorder()
            border.frame = CGRect(x: 0, y: 0, width: borderWidth, height: self.bounds.size.height)
        case .right:
            self.removeBorder()
            border.frame = CGRect(x: self.bounds.size.width - borderWidth, y: 0, width: borderWidth, height: self.bounds.size.height)
        }
        
        border.tag = 1
        self.addSubview(border)
        return border
    }
    
    func removeBorder(borderName: String = "bottomBorder") {
        let borderName = "bottomBorder"
        
        if let sublayers = self.layer.sublayers {
            let bottomLayer = sublayers.filter({$0.name == borderName})
            bottomLayer.forEach({$0.removeFromSuperlayer()})
        }
        
        let bottomLayer = self.subviews.filter({$0.tag == 1})
        
        bottomLayer.forEach({$0.removeFromSuperview()})
    }
    
    
}
