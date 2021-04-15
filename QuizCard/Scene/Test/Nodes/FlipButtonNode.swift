//
//  FlipButtonNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit

final class FlipButtonNode: ASButtonNode {
    
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
            .color(.systemYellow)
            .fill(0.5)
            .lineWidth(5.0)
            .drawFlipSymbol()
        
        context?.restoreGState()
    }
    
    override func layout() {
        super.layout()
        cornerRadius = min(bounds.width, bounds.height)/2
    }
}
