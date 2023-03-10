//
//  GradientView.swift
//  MessageCenter
//
//  Created by Alan Taichung on 2023/3/8.
//

import Foundation
import UIKit


class GradientView: UIView {
    private lazy var gradient: CAGradientLayer = CAGradientLayer()
    private var startColor: UIColor
    private var endColor: UIColor

    init(leftColor: UIColor, rightColor: UIColor) {
        self.startColor = leftColor
        self.endColor = rightColor
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = self.bounds
    }

    override public func draw(_ rect: CGRect) {
        gradient.frame = self.bounds
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0)
        if gradient.superlayer == nil {
            layer.insertSublayer(gradient, at: 0)
        }
    }
    
    func changeColor(leftColor: UIColor, rightColor: UIColor) {
        startColor = leftColor
        endColor = rightColor
        gradient.colors = [leftColor.cgColor, rightColor.cgColor]
        self.layer.layoutIfNeeded()
    }
}

