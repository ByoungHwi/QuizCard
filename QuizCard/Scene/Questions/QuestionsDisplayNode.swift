//
//  QuestionsDisplayNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit

final class QuestionListDisplayNode: ASDisplayNode {
    
    private struct Const {
        
        static let questionListNodeTitleText = "질문"
        static let titleTextAttr = AppConst.boldFont(size: 27.0)
        
        static let testStartButtonText = "테스트 시작"
        static let buttonFont = UIFont(name: "HelveticaNeue-Bold", size: 21)
        static let buttonTextColor: UIColor = .white
        static let buttonCornerRadius: CGFloat = 10.0
        static let buttonInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        static let shuffleButtonImageConfig = UIImage.SymbolConfiguration(pointSize: 27,
                                                                          weight: .bold)
        static let shuffleImageName = "shuffle"
        static let shuffleButtonSize = CGSize(width: 55.0, height: 55.0)
        
        static let contentsInset = UIEdgeInsets(top: 30, left: 30, bottom: 30, right: 30)
    }
    
    lazy var titleTextNode: ASTextNode = {
        let node = ASTextNode()
        node.truncationMode = .byTruncatingTail
        node.maximumNumberOfLines = 2
        return node
    }()
    
    lazy var questionListNode: TitledListNode = {
        let node = TitledListNode()
        node.title = Const.questionListNodeTitleText
        return node
    }()
    
    lazy var testStartButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setTitle(Const.testStartButtonText,
                      with: Const.buttonFont,
                      with: Const.buttonTextColor,
                      for: .normal)
        node.backgroundColor = AppConst.appThemeColor
        node.cornerRadius = Const.buttonCornerRadius
        node.contentEdgeInsets = Const.buttonInsets
        return node
    }()
    
    private lazy var _shuffleButtonNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.setViewBlock {
            let view = UIButton()
            let image = UIImage(systemName: Const.shuffleImageName,
                                withConfiguration: Const.shuffleButtonImageConfig)
            view.setImage(image, for: .normal)
            return view
        }
        return node
    }()
    
    var shuffleButton: UIButton? {
        return _shuffleButtonNode.view as? UIButton
    }
    
    var title: String? = nil {
        didSet {
            titleTextNode.attributedText = NSAttributedString(string: title ?? "",
                                                              attributes: Const.titleTextAttr)
        }
    }
    
    override init() {
        super.init()
        backgroundColor = AppConst.backgroundColor
        automaticallyManagesSubnodes = true
        automaticallyRelayoutOnSafeAreaChanges = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        questionListNode.style.flexGrow = 0.6
        let buttonsLayout = buttonsLayoutSpec()
        let contentsStackLayoutSpec =  ASStackLayoutSpec(direction: .vertical,
                                                         spacing: 20.0,
                                                         justifyContent: .start,
                                                         alignItems: .stretch,
                                                         children: [titleTextNode, questionListNode, buttonsLayout])
        let insetLayoutSpec = ASInsetLayoutSpec(insets: Const.contentsInset, child: contentsStackLayoutSpec)
        return ASInsetLayoutSpec(insets: safeAreaInsets, child: insetLayoutSpec)
    }
    
    private func buttonsLayoutSpec() -> ASLayoutSpec {
        testStartButtonNode.style.flexGrow = 1.0
        _shuffleButtonNode.style.preferredSize = Const.shuffleButtonSize
        let stackLayout = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: 5,
                                            justifyContent: .start,
                                            alignItems: .stretch,
                                            children: [testStartButtonNode, _shuffleButtonNode])
        return stackLayout
    }
    
    func updateShuffleButton(shouldShuffle: Bool) {
        shuffleButton?.tintColor = shouldShuffle ? AppConst.appThemeColor : .gray
    }
}
