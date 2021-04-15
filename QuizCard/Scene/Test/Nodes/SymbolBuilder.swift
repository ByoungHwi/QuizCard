//
//  SymbolBuilder.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import UIKit

final class SymbolBuilder {
    
    private var rect: CGRect = .zero
    private var color: UIColor = .black
    private var percent: CGFloat = 1.0
    private var lineWidth: CGFloat = 1.0
    private var insets: UIEdgeInsets = .zero

    private var verticalInset: CGFloat {
        insets.top + insets.bottom
    }
    
    private var horizontalInset: CGFloat {
        insets.left + insets.right
    }
    
    private var symbolSize: CGFloat {
        min(rect.width * percent - horizontalInset, rect.height * percent - verticalInset)
    }
    
    private var originX: CGFloat {
        (rect.width - symbolSize)/2 + rect.origin.x
    }
    
    private var originY: CGFloat {
        (rect.height - symbolSize)/2 + rect.origin.y
    }
    
    func `in`(_ rect: CGRect) -> SymbolBuilder {
        self.rect = rect
        return self
    }
    
    func color(_ color: UIColor) -> SymbolBuilder {
        self.color = color
        return self
    }
    
    func lineWidth(_ lineWidth: CGFloat) -> SymbolBuilder {
        self.lineWidth = lineWidth
        return self
    }
    
    func fill(_ percent: CGFloat) -> SymbolBuilder {
        self.percent = percent
        return self
    }
    
    func insets(_ insets: UIEdgeInsets) -> SymbolBuilder {
        self.insets = insets
        return self
    }
   
    @discardableResult
    func drawWrongSymbol() -> UIBezierPath {
     
        let path = UIBezierPath()
        path.lineCapStyle = .round
        path.move(to: CGPoint(x: originX, y: originY))
        path.addLine(to: CGPoint(x: originX + symbolSize, y: originY + symbolSize))
        path.move(to: CGPoint(x: originX + symbolSize, y: originY))
        path.addLine(to: CGPoint(x: originX, y: originY + symbolSize))
        color.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
        path.close()
        
        return path
    }
    
    @discardableResult
    func drawRightSymbol() -> UIBezierPath {
        let path = UIBezierPath(ovalIn: CGRect(x: originX,
                                               y: originY,
                                               width: symbolSize,
                                               height: symbolSize))
        color.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
        path.close()
        return path
    }
    
    @discardableResult
    func drawFlipSymbol() -> UIBezierPath {
     
        let path = UIBezierPath()
        path.lineCapStyle = .round
        
        path.move(to: CGPoint(x: originX + symbolSize/3, y: originY))
        path.addLine(to: CGPoint(x: path.currentPoint.x,
                                 y: path.currentPoint.y + symbolSize))
        
        path.move(to: CGPoint(x: originX + symbolSize/3, y: originY))
        path.addLine(to: CGPoint(x: path.currentPoint.x - symbolSize/6,
                                 y: path.currentPoint.y + symbolSize/6))
        
        path.move(to: CGPoint(x: originX + symbolSize * 2/3, y: originY))
        path.addLine(to: CGPoint(x: path.currentPoint.x,
                                 y: path.currentPoint.y + symbolSize))
        
        path.move(to: CGPoint(x: originX + symbolSize * 2/3, y: originY + symbolSize))
        path.addLine(to: CGPoint(x: path.currentPoint.x + symbolSize/6,
                                 y: path.currentPoint.y - symbolSize/6))
        
        color.setStroke()
        path.lineWidth = lineWidth
        path.stroke()
        path.close()
        
        return path
    }
    
}
