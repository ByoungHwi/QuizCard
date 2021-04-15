//
//  WrongButtonNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit

final class WrongButtonNode: ASButtonNode {
    
    override init() {
        super.init()
        isOpaque = false
        backgroundColor = .white
    }
    
    override class func draw(_ bounds: CGRect, withParameters parameters: Any?, isCancelled isCancelledBlock: () -> Bool, isRasterizing: Bool) {
        let context = UIGraphicsGetCurrentContext()
        context?.saveGState()
        SymbolBuilder()
            .in(bounds)
            .color(.systemRed)
            .fill(0.4)
            .lineWidth(7.0)
            .drawWrongSymbol()
        
        context?.restoreGState()
    }
    
    override func layout() {
        super.layout()
        cornerRadius = min(bounds.width, bounds.height)/2
    }
}
