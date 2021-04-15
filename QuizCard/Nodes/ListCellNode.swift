//
//  ListCellNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit
import RxSwift
import RxDataSources_Texture

final class ListCellNode: RoundCornerCellNode {
    
    private struct Const {
        static let titleTextAttr = AppConst.font(size: 17)
        static let titleTextNodeInsets = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    lazy var titleTextNode: ASTextNode = {
        let node = ASTextNode()
        node.maximumNumberOfLines = 0
        return node
    }()

    var isFirstOfSection: Bool
    var isLastOfSection: Bool
    
    init(with viewModel: CellViewModel) {
        isFirstOfSection = viewModel.isFirst
        isLastOfSection = viewModel.isLast
        super.init()
        titleTextNode.attributedText = NSAttributedString(string: viewModel.title ?? "",
                                                          attributes: Const.titleTextAttr)
        selectionStyle = .none
    }
    
    override func contentsNodeLayoutSpec() -> ASLayoutSpec {
        titleTextNode.style.flexGrow = 1
        let insetLayoutSpec = ASInsetLayoutSpec(insets: Const.titleTextNodeInsets,
                                           child: titleTextNode)
        
        return ASRelativeLayoutSpec(horizontalPosition: .start,
                                    verticalPosition: .center,
                                    sizingOption: [],
                                    child: insetLayoutSpec)
    }
    
    override func roundCorners() -> CACornerMask {
        
        if isFirstOfSection && isLastOfSection {
            return [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner]
        }
        
        if isFirstOfSection {
            return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        if isLastOfSection {
            return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        return []
    }
}
