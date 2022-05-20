//
//  UIView+Extension.swift
//  WeatherApp
//
//  Created by Nguyen Tran on 18/05/2022.
//

import Foundation
import UIKit

enum DirectionMode: Int {
    case horizontal = 0
    case vertical
    case diagonalFromLeftToRight
    case diagonalFromRightToLeft
}

extension UIView {
    @IBInspectable var borderColor: UIColor? {
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
        set {
            guard let color = newValue else {
                layer.borderColor = nil
                return
            }
            // Fix React-Native conflict issue
            guard String(describing: type(of: color)) != "__NSCFType" else { return }
            layer.borderColor = color.cgColor
        }
    }
    
    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = abs(CGFloat(Int(newValue * 100)) / 100)
        }
    }
    
    @IBInspectable var shadowColor: UIColor? {
        get {
            return layer.shadowColor == nil ? nil : UIColor(cgColor: layer.shadowColor!)
        }
        set {
            layer.shadowColor = newValue?.cgColor
        }
    }
    
    @IBInspectable var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var shadowRadius: Double {
        get {
            return Double(layer.shadowRadius)
        }
        set {
            layer.shadowRadius = CGFloat(newValue)
        }
    }
}

extension UIView {
    func setGradientBackground(startColor: UIColor,
                               endColor: UIColor,
                               _ mode: DirectionMode) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [startColor.cgColor, endColor.cgColor]
        createPointGradient(with: gradientLayer, direction: mode)
        gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func createPointGradient(with gradientLayer: CAGradientLayer,
                             direction mode: DirectionMode) {
        switch mode {
        case .horizontal:
            gradientLayer.startPoint = .init(x: 0, y: 1)
            gradientLayer.endPoint = .init(x: 1, y: 1)
        case .vertical:
            gradientLayer.startPoint = .init(x: 1, y: 0)
            gradientLayer.endPoint = .init(x: 1, y: 1)
        case .diagonalFromLeftToRight:
            gradientLayer.startPoint = .init(x: 0, y: 0)
            gradientLayer.endPoint = .init(x: 1, y: 1)
        case .diagonalFromRightToLeft:
            gradientLayer.startPoint = .init(x: 1, y: 0)
            gradientLayer.endPoint = .init(x: 0, y: 1)
        }
    }
}
