//
//  AddQuestionDisplayView.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

final class AddQuestionDisplayNode: AddingModalDisplayNode {
    
    private struct Const {
        
        static let contentsInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
        
        static let titleText = "질문 추가"
        static let questionNodePlaceHolderText = "\n\n새로운 질문을 입력하세요."
        static let answerNodePlaceHolderText = "\n\n답변을 입력하세요."
        static let confirmButtonTextWithFront = "답변 입력하기"
        static let confirmButtonTextWithBack = "저장"
        
        static let titleTextAttr = AppConst.boldFont(size: 21)
        static let typingAttr = AppConst.font(size: 17, alignment: .center)
        static let placeHolderAttr = AppConst.font(size: 17, color: .gray, alignment: .center)
        static let editableTextNodeContainerInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let editableTextNodeCornerRadius: CGFloat = 10.0
    }
    
    lazy var titleTextNode: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: Const.titleText,
                                                 attributes: Const.titleTextAttr)
        return node
    }()
    
    lazy var questionTextNode: VCenterEditableTextNode = {
        let node = VCenterEditableTextNode()
        node.textContainerInset = Const.editableTextNodeContainerInsets
        node.autocorrectionType = .no
        node.attributedPlaceholderText = NSAttributedString(string: Const.questionNodePlaceHolderText,
                                                            attributes: Const.placeHolderAttr)
        node.textView.typingAttributes = Const.typingAttr
        node.clipsToBounds = true
        node.cornerRadius = Const.editableTextNodeCornerRadius
        node.backgroundColor = .white
        return node
    }()
    
    lazy var answerTextNode: VCenterEditableTextNode = {
        let node = VCenterEditableTextNode()
        node.textContainerInset = Const.editableTextNodeContainerInsets
        node.autocorrectionType = .no
        node.attributedPlaceholderText = NSAttributedString(string: Const.answerNodePlaceHolderText,
                                                            attributes: Const.placeHolderAttr)
        node.textView.typingAttributes = Const.typingAttr
        node.clipsToBounds = true
        node.cornerRadius = Const.editableTextNodeCornerRadius
        node.backgroundColor = .white
        return node
    }()
    
    lazy var flipNode: FlippableNode = {
        let node = FlippableNode()
        node.frontNode = questionTextNode
        node.backNode = answerTextNode
        return node
    }()
    
    override init() {
        super.init()
        setConfirmButtonText()
    }
    
    override func contentsLayoutSpec() -> ASLayoutSpec {
        questionTextNode.style.flexGrow = 1.0
        flipNode.style.flexGrow = 1.0
        let stackLayout = ASStackLayoutSpec(direction: .vertical,
                                            spacing: 10,
                                            justifyContent: .start,
                                            alignItems: .stretch,
                                            children: [titleTextNode, flipNode])
        
        let insets = Const.contentsInset
        return ASInsetLayoutSpec(insets: insets, child: stackLayout)
    }
   
    func setConfirmButtonText() {
        let text = flipNode.currentState == .front ? Const.confirmButtonTextWithFront : Const.confirmButtonTextWithBack
        confirmButtonNode.setTitle(text, with: nil, with: .white, for: .normal)
    }
}
