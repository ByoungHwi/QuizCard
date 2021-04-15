//
//  TestDisplayNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit

final class TestDisplayNode: ASDisplayNode {
    
    struct Const {
        static let resultTextFormat = "%d개의 문제 중 \n %d개의 문제를 맞췄어요"
        static let restartButtonText = "다시 시작"
        static let restartFailedOnltButtonText = "틀린 문제만 다시보기"
        
        static let resultTextAttr = AppConst.boldFont(size: 17, alignment: .center)
        static let mainButtonsSize = CGSize(width: 55.0, height: 55.0)
        static let flipButtonsSize = CGSize(width: 44.0, height: 44.0)
        static let resultButtonsHeight: CGFloat = 44.0
        static let lottieNodeBottomMargin: CGFloat = 50.0
        static let resultButtonsCornerRadius: CGFloat = 10.0
        
        static let cardLayoutInsets = UIEdgeInsets(top: 50.0, left: 50.0, bottom: 50.0, right: 50.0)
        static let buttonsLayoutInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        static let resultLayoutInsets = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    lazy var cardContainerNode: CardContainerNode = {
        let node = CardContainerNode()
        node.baseNode = finishedNode
        return node
    }()
    
    lazy var leftButtonNode: WrongButtonNode = {
        let node = WrongButtonNode()
        return node
    }()
    
    lazy var flipButtonNode: FlipButtonNode = {
        let node = FlipButtonNode()
        return node
    }()
    
    lazy var rightButtonNode: RightButtonNode = {
        let node = RightButtonNode()
        return node
    }()
    
    lazy var resultLottieNode: LottieNode = {
        let node = LottieNode()
        node.loopMode = .loop
        return node
    }()
    
    lazy var resultTextNode: ASTextNode = {
        let node = ASTextNode()
        return node
    }()
    
    lazy var restartButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.backgroundColor = AppConst.appThemeColor
        node.setTitle(Const.restartButtonText, with: nil, with: .white, for: .normal)
        node.cornerRadius = Const.resultButtonsCornerRadius
        return node
    }()
    
    lazy var restartFailedOnlyButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.backgroundColor = AppConst.appThemeColor
        node.setTitle(Const.restartFailedOnltButtonText, with: nil, with: .white, for: .normal)
        node.cornerRadius = Const.resultButtonsCornerRadius
        return node
    }()
    
    lazy var finishedNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.automaticallyManagesSubnodes = true
        node.isHidden = true
        node.layoutSpecBlock  = { [weak self] _, _ in
            return self?.resultLayoutSpec() ?? ASLayoutSpec()
        }
        return node
    }()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        automaticallyRelayoutOnSafeAreaChanges = true
        backgroundColor = AppConst.backgroundColor
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        
        let buttonsLayout = buttonsLayoutSpec()
        cardContainerNode.style.flexGrow = 1.0
        let cardLayout = ASInsetLayoutSpec(insets: Const.cardLayoutInsets, child: cardContainerNode)
        cardLayout.style.flexGrow = 1.0
        cardContainerNode.zPosition = 1
        
        leftButtonNode.style.preferredSize = Const.mainButtonsSize
        rightButtonNode.style.preferredSize = Const.mainButtonsSize
        flipButtonNode.style.preferredSize = Const.flipButtonsSize
        
        let stackLayout = ASStackLayoutSpec(direction: .vertical,
                                            spacing: 10.0,
                                            justifyContent: .end,
                                            alignItems: .stretch,
                                            children: [cardLayout, buttonsLayout])
        
        return ASInsetLayoutSpec(insets: safeAreaInsets, child: stackLayout)
    }
    
    private func buttonsLayoutSpec() -> ASLayoutSpec {
        let stackLayout = ASStackLayoutSpec(direction: .horizontal,
                                      spacing: 20.0,
                                      justifyContent: .center,
                                      alignItems: .center,
                                      children: [leftButtonNode, flipButtonNode, rightButtonNode])
        
        return ASInsetLayoutSpec(insets: Const.buttonsLayoutInsets, child: stackLayout)
    }
    
    private func resultLayoutSpec() -> ASLayoutSpec {
        resultLottieNode.layoutMargins.bottom = Const.lottieNodeBottomMargin
        resultLottieNode.style.flexGrow = 1.0
        restartButtonNode.style.height = .init(unit: .points, value: Const.resultButtonsHeight)
        restartFailedOnlyButtonNode.style.height = .init(unit: .points, value: Const.resultButtonsHeight)
        restartButtonNode.style.flexGrow = 1.0
        
        let buttonsLayout = ASStackLayoutSpec(direction: .vertical,
                                              spacing: 10,
                                              justifyContent: .center,
                                              alignItems: .stretch,
                                              children: [restartButtonNode, restartFailedOnlyButtonNode])
        
        let stackLayout = ASStackLayoutSpec(direction: .vertical,
                                            spacing: 50,
                                            justifyContent: .center,
                                            alignItems: .stretch,
                                            children: [resultLottieNode, resultTextNode, buttonsLayout])

        return ASInsetLayoutSpec(insets: Const.resultLayoutInsets, child: stackLayout)
    }
    
    func setResult(total: Int, rightCount: Int, type: TestResultType) {
        let resultString = String(format: Const.resultTextFormat, arguments: [total, rightCount])
        resultTextNode.attributedText = NSAttributedString(string: resultString,
                                                           attributes: Const.resultTextAttr)
        resultLottieNode.change(to: type.lottieName)
        if total == rightCount {
            restartFailedOnlyButtonNode.isHidden = true
        }
    }
    
    func testWillStart() {
        resultLottieNode.stop()
        restartFailedOnlyButtonNode.isHidden = false
        finishedNode.isHidden = true
        rightButtonNode.isHidden = false
        flipButtonNode.isHidden = false
        leftButtonNode.isHidden = false
    }
    
    func testDidFinish() {
        resultLottieNode.play()
        finishedNode.isHidden = false
        rightButtonNode.isHidden = true
        flipButtonNode.isHidden = true
        leftButtonNode.isHidden = true
    }
}
