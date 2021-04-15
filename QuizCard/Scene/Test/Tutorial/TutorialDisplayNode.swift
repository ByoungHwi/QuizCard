//
//  TutorialDisplayNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit

final class TutorialDisplayNode: ASDisplayNode {
    
    struct Const {
        static let swipeLottieName = "SwipeLottie"
        static let tapLottieName = "TapLottie"
        static let swipeRightExplainText = "정답을 알고있다면"
        static let swipeLeftExplainText = "정답을 모르겠다면"
        static let tapExplainText = "정답을 확인하려면"
        static let closeButtonText = "닫기"
        static let showOnceButtonText = "더 이상 보지 않기"
        
        static let lottieSize = CGSize(width: 150, height: 150)
    }
    
    lazy var swipeRightLottieNode: LottieNode = {
        let node = LottieNode(name: Const.swipeLottieName)
        node.loopMode = .loop
        node.reverseHorizontally()
        node.play()
        return node
    }()
    
    lazy var swipeLeftLottieNode: LottieNode = {
        let node = LottieNode(name: Const.swipeLottieName)
        node.loopMode = .loop
        node.play()
        return node
    }()
    
    lazy var tapLottieNode: LottieNode = {
        let node = LottieNode(name: Const.tapLottieName)
        node.loopMode = .loop
        node.play()
        return node
    }()
    
    lazy var swipeRightExplainTextNode: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: Const.swipeRightExplainText,
                                                 attributes: AppConst.boldFont(size: 21, color: .white))
        return node
    }()
    
    lazy var swipeLeftExplainTextNode: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: Const.swipeLeftExplainText,
                                                 attributes: AppConst.boldFont(size: 21, color: .white))
        return node
    }()
    
    lazy var tapExplainTextNode: ASTextNode = {
        let node = ASTextNode()
        node.attributedText = NSAttributedString(string: Const.tapExplainText,
                                                 attributes: AppConst.boldFont(size: 21, color: .white))
        return node
    }()
    
    lazy var closeButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        let nodeTitle = NSAttributedString(string: Const.closeButtonText,
                                           attributes: AppConst.font(size: 17, color: .white))
        node.setAttributedTitle(nodeTitle, for: .normal)
        return node
    }()
    
    lazy var showOnceButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        let nodeTitle = NSAttributedString(string: Const.showOnceButtonText,
                                           attributes: AppConst.font(size: 17, color: .white))
        node.setAttributedTitle(nodeTitle, for: .normal)
        return node
    }()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
        automaticallyRelayoutOnSafeAreaChanges = true
        backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.8)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let contentsLayout = contentsLayoutSpec()
        let buttonsLayout = buttonsLayoutSpec()
        
        contentsLayout.style.flexBasis = .init(unit: .fraction, value: 0.5)
        buttonsLayout.style.height = .init(unit: .fraction, value: 0.25)
        
        let stackLayout = ASStackLayoutSpec(direction: .vertical,
                                            spacing: 0.0,
                                            justifyContent: .end,
                                            alignItems: .stretch,
                                            children: [contentsLayout,
                                                       buttonsLayout])
   
        return ASInsetLayoutSpec(insets: safeAreaInsets, child: stackLayout)
    }
    
    private func contentsLayoutSpec() -> ASLayoutSpec {
        let swipeLeftLayout = swipeLeftLayoutSpec()
        let swipeRightLayout = swipeRightLayoutSpec()
        let tapLayout = tapLayoutSpec()
        
        swipeLeftLayout.style.flexBasis = .init(unit: .fraction, value: 0.33)
        swipeRightLayout.style.flexBasis = .init(unit: .fraction, value: 0.33)
        tapLayout.style.flexBasis = .init(unit: .fraction, value: 0.33)
        
        let stackLayout = ASStackLayoutSpec(direction: .vertical,
                                            spacing: 0.0,
                                            justifyContent: .center,
                                            alignItems: .stretch,
                                            children: [swipeRightLayout,
                                                       swipeLeftLayout,
                                                       tapLayout])
        
        return stackLayout
    }
    
    private func swipeLeftLayoutSpec() -> ASLayoutSpec {
        swipeLeftLottieNode.style.preferredSize = Const.lottieSize
        return ASStackLayoutSpec(direction: .horizontal,
                                 spacing: 5.0,
                                 justifyContent: .center,
                                 alignItems: .center,
                                 children: [swipeLeftExplainTextNode, swipeLeftLottieNode])
    }
    
    private func swipeRightLayoutSpec() -> ASLayoutSpec {
        swipeRightLottieNode.style.preferredSize = Const.lottieSize
        return ASStackLayoutSpec(direction: .horizontal,
                                 spacing: 5.0,
                                 justifyContent: .center,
                                 alignItems: .center,
                                 children: [swipeRightExplainTextNode, swipeRightLottieNode])
    }
    
    private func tapLayoutSpec() -> ASLayoutSpec {
        tapLottieNode.style.preferredSize = Const.lottieSize
        return ASStackLayoutSpec(direction: .horizontal,
                                 spacing: 5.0,
                                 justifyContent: .center,
                                 alignItems: .center,
                                 children: [tapExplainTextNode, tapLottieNode])
    }
    
    private func buttonsLayoutSpec() -> ASLayoutSpec {
        let stackLayout = ASStackLayoutSpec(direction: .horizontal,
                                            spacing: 0.0,
                                            justifyContent: .spaceAround,
                                            alignItems: .center,
                                            children: [closeButtonNode, showOnceButtonNode])
        return ASCenterLayoutSpec(centeringOptions: [],
                                  sizingOptions: [],
                                  child: stackLayout)
    }
    
}
