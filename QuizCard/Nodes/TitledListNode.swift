//
//  TitledListNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit

final class TitledListNode: ASDisplayNode {
   
    private struct Const {
        static let tableNodeBackgroundColor = AppConst.backgroundColor
        
        static let titleTextAttr = AppConst.mediumFont(size: 17.0)
        
        static let addButtonNodeImageConfiguration = UIImage.SymbolConfiguration(pointSize: 24,
                                                                             weight: .medium)
        static let addButtonNodeImageName = "plus"
        
        static let headerInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    }
    
    lazy var titleTextNode: ASTextNode = {
        let node = ASTextNode()
        node.truncationMode = .byTruncatingTail
        node.maximumNumberOfLines = 1
        return node
    }()
    
    lazy var tableNode: ASTableNode = {
        let node = ASTableNode()
        node.view.tableFooterView = UIView()
        node.backgroundColor = Const.tableNodeBackgroundColor
        node.view.separatorStyle = .none
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
    
    var title: String? {
        didSet {
            titleTextNode.attributedText = NSAttributedString(string: title ?? "",
                                                              attributes: Const.titleTextAttr)
        }
    }
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let headerLayout = headerLayoutSpec()
        headerLayout.style.alignSelf = .stretch
        tableNode.style.alignSelf = .center
        tableNode.style.flexGrow = 1.0
        return ASStackLayoutSpec(direction: .vertical,
                                 spacing: 10.0,
                                 justifyContent: .start,
                                 alignItems: .notSet,
                                 children: [headerLayout, tableNode])
    }
    
    private func headerLayoutSpec() -> ASLayoutSpec {
        let stackLayout = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: .zero,
                                            justifyContent: .spaceBetween,
                                            alignItems: .center,
                                            children: [titleTextNode, addButtonNode])
        return ASInsetLayoutSpec(insets: Const.headerInsets, child: stackLayout)
    }
    
}
