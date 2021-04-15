//
//  AddListDisplayNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit

final class AddListDisplayNode: AddingModalDisplayNode {
    
    private struct Const {
        
        static let textInputNodeTitleText = "질문 목록명"
        static let textInputNodePlacehoderText = "새 질문 목록"
        static let folderListNodeTitleText = "폴더"
        static let addButtonNodeTitleText = "저장"
        
        static let titleTextAttr = AppConst.mediumFont(size: 17)
        static let titleTextNodeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
        static let titleInputNodeCornerRadius: CGFloat = 10
        static let titleInputNodeContainerInset = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let placeholderTextAttr = AppConst.font(size: 15.0, color: .systemGray)
        static let typingTextAttr = AppConst.font(size: 15.0)
        
        static let addButtonTitleTextAttr = AppConst.font(size: 23, color: .white)
        static let addButtonNodeColor = AppConst.appThemeColor
        static let addButtonNodeContentsInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        static let addButtonCornerRadius: CGFloat = 10.0

        static let contentsInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
    }

    lazy var titleTextNode: ASTextNode = {
        let node = ASTextNode()
        node.truncationMode = .byTruncatingTail
        node.maximumNumberOfLines = 1
        node.attributedText = NSAttributedString(string: Const.textInputNodeTitleText,
                                                 attributes: Const.titleTextAttr)
        return node
    }()
    
    lazy var titleInputNode: ASEditableTextNode = {
        let node = ASEditableTextNode()
        node.maximumLinesToDisplay = 1
        node.textView.textContainer.maximumNumberOfLines = 1
        node.backgroundColor = .white
        node.textContainerInset = Const.titleInputNodeContainerInset
        node.autocorrectionType = .no
        node.cornerRadius = Const.titleInputNodeCornerRadius
        node.clipsToBounds = true
        node.attributedPlaceholderText = NSAttributedString(string: Const.textInputNodePlacehoderText,
                                                            attributes: Const.placeholderTextAttr)
        node.textView.typingAttributes = Const.typingTextAttr
    
        return node
    }()
    
    lazy var folderListNode: TitledListNode = {
        let node = TitledListNode()
        node.title = Const.folderListNodeTitleText
        return node
    }()
    
    override func contentsLayoutSpec() -> ASLayoutSpec {
        folderListNode.style.flexGrow = 1.0
        let titleInputLayout = titleInputLayoutSpec()
        let contentsStackLayoutSpec =  ASStackLayoutSpec(direction: .vertical,
                                                         spacing: 30.0,
                                                         justifyContent: .center,
                                                         alignItems: .stretch,
                                                         children: [titleInputLayout, folderListNode])
        contentsStackLayoutSpec.style.flexGrow = 1
        return ASInsetLayoutSpec(insets: Const.contentsInset, child: contentsStackLayoutSpec)
    }
    
    private func titleInputLayoutSpec() -> ASLayoutSpec {
        let insetLayout = ASInsetLayoutSpec(insets: Const.titleTextNodeInsets, child: titleTextNode)
        return ASStackLayoutSpec(direction: .vertical,
                                 spacing: 15.0,
                                 justifyContent: .start,
                                 alignItems: .stretch,
                                 children: [insetLayout, titleInputNode])
    }
}
