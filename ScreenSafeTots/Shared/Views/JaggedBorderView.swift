//
//  CurveBorderView.swift
//  Challenge
//
//  Created by Md. Mehedi Hasan on 24/9/20.
//

import UIKit

class JaggedBorderView: UIView {
    
    enum BorderDirection: Int {
        case horizontal
        case vertical
        case all
    }
    
    enum Position: Int {
        case top
        case bottom
        case left
        case right
    }
    
    var borderDirection: BorderDirection!
    var horizontalVertexDistance: CGFloat = 8
    var verticalVertexDistance: CGFloat = 8
    var borderLineWidth: CGFloat = 1
    var fillColor: UIColor = UIColor.lightGray
    var bottomShadow: Bool = false
    
    init(borderDirection: BorderDirection) {
        self.borderDirection = borderDirection
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let borderWidth = self.borderLineWidth
        let fillColor = self.fillColor
        draw(borderDirection, fillColor: fillColor, borderWidth: borderWidth)
    }
    
    func draw(_ direction: BorderDirection, fillColor: UIColor, borderWidth: CGFloat) {
        
        let drawBorder: ((_ borderPosition: Position) -> Void)? = { [weak self] borderPosition in
            guard let self = self else { return }
            
            if borderPosition == .top || borderPosition == .bottom {
                let path = UIBezierPath()
                path.lineWidth = borderWidth
                var x: CGFloat = 0
                var y: CGFloat = borderPosition == .top ? 0 : self.frame.height
                path.move(to: CGPoint(x: x, y: y))
                
                let verticalDisplacement = self.verticalVertexDistance
                let horizontalDisplacement = self.horizontalVertexDistance
                x += horizontalDisplacement
                
                var shouldMoveUp = borderPosition == .top ? false : true
                while x <= self.frame.width {
                    
                    if shouldMoveUp {
                        y += verticalDisplacement
                    } else {
                        y -= verticalDisplacement
                    }
                    path.addLine(to: CGPoint(x: x, y: y))
                    
                    shouldMoveUp = !shouldMoveUp
                    
                    x += horizontalDisplacement
                }
                
                x = self.frame.width
                y = borderPosition == .top ? 0 : self.frame.height
                path.addLine(to: CGPoint(x: x, y: y))
                path.close()
                
                let shape = CAShapeLayer()
                shape.path = path.cgPath
                shape.fillColor = fillColor.cgColor
                
                self.layer.insertSublayer(shape, at: 0)
                
            } else if borderPosition == .left || borderPosition == .right {
                
                let path = UIBezierPath()
                path.lineWidth = borderWidth
                var y: CGFloat = 0
                var x: CGFloat = borderPosition == .left ? 0 : self.frame.width
                path.move(to: CGPoint(x: CGFloat(x), y: CGFloat(y)))
                let verticalDisplacement = self.verticalVertexDistance
                let horizontalDisplacement = self.horizontalVertexDistance
                
                y += horizontalDisplacement
                var shouldMoveUp = borderPosition == .left ? false : true
                while y <= self.frame.height {
                    
                    if shouldMoveUp {
                        x += verticalDisplacement
                    } else {
                        x -= verticalDisplacement
                    }
                    path.addLine(to: CGPoint(x: x, y: y))
                    
                    shouldMoveUp = !shouldMoveUp
                    
                    y += horizontalDisplacement
                }
                
                
                x = borderPosition == .left ? 0 : self.frame.width
                y = self.frame.height
                path.addLine(to: CGPoint(x: x, y: y))
                path.close()
                
                let shape = CAShapeLayer()
                shape.path = path.cgPath
                shape.fillColor = fillColor.cgColor
                
                self.layer.insertSublayer(shape, at: 0)
            }
        }
        
        switch direction {
        case .horizontal:
            drawBorder?(.top)
            drawBorder?(.bottom)
        case .vertical:
            drawBorder?(.left)
            drawBorder?(.right)
        case .all:
            drawBorder?(.top)
            drawBorder?(.bottom)
            drawBorder?(.left)
            drawBorder?(.right)
        }
        
        if bottomShadow {
            layer.shadowRadius = verticalVertexDistance
            layer.shadowOpacity = 0.16
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize.zero
            layer.shadowPath = UIBezierPath(rect: CGRect(x: 0,
                                                         y: frame.size.height,
                                                         width: bounds.width,
                                                         height: verticalVertexDistance)).cgPath
        }
    }
    
    func draw(_ path: UIBezierPath?) {
        fillColor.setFill()
        path?.close()
        path?.fill()
        path?.stroke()
    }
}
