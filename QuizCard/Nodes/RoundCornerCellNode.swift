//
//  RoundCornerCellNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit

class RoundCornerCellNode: ASCellNode {
    
    private struct Const {
        static let cornerRadius: CGFloat = 15
        static let contentsNodeBackgroundColor: UIColor = .systemBackground
    }
    
    lazy var contentsNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = Const.contentsNodeBackgroundColor
        node.automaticallyManagesSubnodes = true
        node.layoutSpecBlock = { [weak self] (_, _) in
            guard let `self` = self else { return ASLayoutSpec()  }
            return self.contentsNodeLayoutSpec()
        }
        return node
    }()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        backgroundColor = .clear
        
        let corners = roundCorners()
        onDidLoad { [weak self] _ in
            self?.contentsNode.layer.maskedCorners = corners
            self?.contentsNode.layer.cornerRadius = Const.cornerRadius
        }
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let lineSeperatorLayoutSpec = ASLayoutSpec()
        lineSeperatorLayoutSpec.style.height = .init(unit: .points, value: 1.0)
        contentsNode.style.flexGrow = 1.0
        contentsNode.style.width = .init(unit: .points, value: .infinity)
        return ASStackLayoutSpec(direction: .vertical,
                                 spacing: .zero,
                                 justifyContent: .start,
                                 alignItems: .start,
                                 children: [contentsNode, lineSeperatorLayoutSpec])
    }
    
    func contentsNodeLayoutSpec() -> ASLayoutSpec {
        return ASLayoutSpec()
    }
    
    func roundCorners() -> CACornerMask {
        return [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
    }
}
