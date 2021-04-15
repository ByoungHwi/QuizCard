//
//  HomeDisplayNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit

final class HomeDisplayNode: ASDisplayNode {
    
    private struct Const {
        
        static let addButtonNodeImageConfiguration = UIImage.SymbolConfiguration(pointSize: 24,
                                                                             weight: .medium)
        static let addButtonNodeImageName = "folder.badge.plus"
        
        static let addButtonNodeInsets = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 24)
        
        static let tableNodeInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        static let bottomLineSeperatorColor = UIColor.systemGray5
    }
    
    lazy var tableNode: ASTableNode = {
        let node = ASTableNode()
        node.view.tableFooterView = UIView()
        node.backgroundColor = AppConst.backgroundColor
        node.view.separatorStyle = .none
        node.view.showsVerticalScrollIndicator = false
        return node
    }()
    
    lazy var addButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        let image = UIImage(systemName: Const.addButtonNodeImageName,
                            withConfiguration: Const.addButtonNodeImageConfiguration)
        node.setImage(image, for: .normal)
        node.contentMode = .scaleAspectFill
        node.imageNode.imageModificationBlock = ASImageNodeTintColorModificationBlock(AppConst.appThemeColor)
        return node
    }()
    
    lazy var bottomNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.automaticallyManagesSubnodes = true
        node.layoutSpecBlock = { [weak self] (_, _) in
            guard let `self` = self else { return ASLayoutSpec() }
            return self.bottomNodeLayoutSepc()
        }
        node.backgroundColor = AppConst.edgeColor
        return node
    }()
    
    override init() {
        super.init()
        backgroundColor = AppConst.backgroundColor
        automaticallyManagesSubnodes = true
        automaticallyRelayoutOnSafeAreaChanges = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let tableNodeLayout = tableNodeLayoutSpec()
        tableNodeLayout.style.flexGrow = 1.0
        
        let lineSeperatorNode = ASDisplayNode()
        lineSeperatorNode.backgroundColor = Const.bottomLineSeperatorColor
        lineSeperatorNode.style.height = .init(unit: .points, value: 1.0)
        
        let stackLayout = ASStackLayoutSpec(direction: .vertical,
                                            spacing: .zero,
                                            justifyContent: .start,
                                            alignItems: .stretch,
                                            children: [tableNodeLayout, lineSeperatorNode, bottomNode])
        
        var insets = UIEdgeInsets()
        insets.top = safeAreaInsets.top
        return ASInsetLayoutSpec(insets: insets, child: stackLayout)
    }
    
    private func tableNodeLayoutSpec() -> ASLayoutSpec {
        var insets = Const.tableNodeInsets
        insets.left += safeAreaInsets.left
        insets.right += safeAreaInsets.right
        return ASInsetLayoutSpec(insets: insets, child: tableNode)
    }
    
    private func bottomNodeLayoutSepc() -> ASLayoutSpec {
        addButtonNode.style.flexGrow = 1.0
        var insets = Const.addButtonNodeInsets
        insets.bottom += safeAreaInsets.bottom
        insets.right += safeAreaInsets.right
        let insetLayoutSpec = ASInsetLayoutSpec(insets: insets, child: addButtonNode)
    
        return ASRelativeLayoutSpec(horizontalPosition: .end,
                                    verticalPosition: .center,
                                    sizingOption: .minimumSize,
                                    child: insetLayoutSpec)
    }
    
}
