//
//  WrongOverlayNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import Foundation

import AsyncDisplayKit

final class WrongOverlayNode: ASDisplayNode {
    
    struct Const {
        static let cornerRadius: CGFloat = 10.0
        static let borderWidth: CGFloat = 5.0
        static let color: UIColor = .systemRed
    }
    
    override init() {
        super.init()
        cornerRadius = Const.cornerRadius
        borderWidth = Const.borderWidth
        borderColor = Const.color.cgColor
        backgroundColor = .clear
        isOpaque = false
        rotate()
    }
    
    override class func draw(_ bounds: CGRect, withParameters parameters: Any?, isCancelled isCancelledBlock: () -> Bool, isRasterizing: Bool) {
        
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
 
        SymbolBuilder()
            .in(bounds)
            .color(Const.color)
            .fill(0.75)
            .lineWidth(10.0)
            .insets(UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5))
            .drawWrongSymbol()
        
        context?.restoreGState()
    }

    private func rotate() {
        let rotateTransform = CGAffineTransform(rotationAngle: 0.5)
        transform = CATransform3DMakeAffineTransform(rotateTransform)
    }
}
