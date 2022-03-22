//
//  CircleProgressBar.swift
//  BandLabSongs
//
//  Created by Nikolay Mikhaylov on 18.03.2022.
//

import Foundation
import UIKit

@IBDesignable
class CircleProgressBar: UIView {
    
    @IBInspectable var barTintColor: UIColor = .red {
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var barBackgroundColor: UIColor = .white {
        didSet { setNeedsDisplay() }
    }

    @IBInspectable var lineWidth: CGFloat = 4{
        didSet { setNeedsDisplay() }
    }
    @IBInspectable var duration: CGFloat = 1.2
    
    var progress: CGFloat = 0 {
        didSet { setNeedsDisplay() }
    }
    
    private var progressLayer = CAShapeLayer()
    private var backgroundMask = CAShapeLayer()
    private let gradientLayer = CAGradientLayer()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupLayers()
    }
    
    override func draw(_ rect: CGRect) {
        let circlePath = UIBezierPath(ovalIn: rect.insetBy(dx: lineWidth / 2,
                                                           dy: lineWidth / 2))
        
        backgroundMask.path = circlePath.cgPath
        progressLayer.path = circlePath.cgPath
        progressLayer.lineCap = .round
        progressLayer.strokeStart = 0
        progressLayer.strokeEnd = progress
        progressLayer.strokeColor = barTintColor.cgColor

        layer.backgroundColor = barBackgroundColor.cgColor
        
        backgroundMask.lineWidth = lineWidth
        progressLayer.lineWidth = lineWidth
    }
    
    private func setupLayers() {

        backgroundMask.fillColor = nil
        backgroundMask.strokeColor = UIColor.black.cgColor
        layer.mask = backgroundMask

        progressLayer.fillColor = nil

        layer.addSublayer(progressLayer)
        layer.transform = CATransform3DMakeRotation(CGFloat(90 * Double.pi / 180), 0, 0, -1)

    }
    
    
}
