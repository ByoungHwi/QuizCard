//
//  AddingModalDisplayNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit

class AddingModalDisplayNode: ASDisplayNode {
    
    private struct Const {
        static let backgroundColor: UIColor = AppConst.backgroundColor
        
        static let cancelButtonTitle = "Cancel"
        static let cancelButtonSize = CGSize(width: 66, height: 44)
        static let cancelButtonInsets = UIEdgeInsets(top: 20, left: 10, bottom: 0, right: 0)
        
        static let confirmButtonTitle = "저장"
        static let confirmButtonHeight: CGFloat = 50.0
        static let confirmButtonCornerRadius: CGFloat = 10.0
        static let confirmButtonInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
    }
    
    lazy var cancelButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setTitle(Const.cancelButtonTitle, with: nil, with: AppConst.appThemeColor, for: .normal)
        node.style.preferredSize = Const.cancelButtonSize
        node.contentVerticalAlignment = .top
        
        return node
    }()
    
    lazy var confirmButtonNode: ASButtonNode = {
        let node = ASButtonNode()
        node.setTitle(Const.confirmButtonTitle, with: nil, with: .white, for: .normal)
        node.backgroundColor = AppConst.appThemeColor
        node.style.height = .init(unit: .points, value: Const.confirmButtonHeight)
        node.cornerRadius = Const.confirmButtonCornerRadius
        return node
    }()
    
    lazy var bottomInsetNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = Const.backgroundColor
        node.style.width = .init(unit: .fraction, value: 1.0)
        node.style.height = .init(unit: .points, value: 10)
        return node
    }()
    
    lazy var contentsNode: ASDisplayNode = {
        let node = ASDisplayNode()
        node.backgroundColor = Const.backgroundColor
        node.automaticallyManagesSubnodes = true
        node.layoutSpecBlock = { [weak self] node, _ in
            guard let `self` = self else { return ASLayoutSpec() }
            return self.commonLayoutSpec()
        }
        return node
    }()
    
    override init() {
        super.init()
        backgroundColor = .clear
        automaticallyManagesSubnodes = true
        automaticallyRelayoutOnSafeAreaChanges = true
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        contentsNode.style.flexGrow = 1.0
        let stackLayout = ASStackLayoutSpec(direction: .vertical,
                                            spacing: 0,
                                            justifyContent: .start,
                                            alignItems: .stretch,
                                            children: [contentsNode, bottomInsetNode])
        
        return ASInsetLayoutSpec(insets: safeAreaInsets, child: stackLayout)
    }
    
    open func contentsLayoutSpec() -> ASLayoutSpec {
        return ASLayoutSpec()
    }
    
    func setBottomInset(_ inset: CGFloat) {
        bottomInsetNode.style.height = .init(unit: .points, value: inset)
        bottomInsetNode.setNeedsLayout()
        bottomInsetNode.layoutIfNeeded()
    }
    
    private func commonLayoutSpec() -> ASLayoutSpec {
        let contentsLayout = contentsLayoutSpec()
        let cancelButtonLayout = cancelButtonLayoutSpec()
        let confirmButtonLayout = confirmButtonLayoutSpec()
        
        contentsLayout.style.flexGrow = 1.0
        cancelButtonLayout.style.alignSelf = .start
        
        return ASStackLayoutSpec(direction: .vertical,
                                 spacing: 0,
                                 justifyContent: .start,
                                 alignItems: .stretch,
                                 children: [cancelButtonLayout, contentsLayout, confirmButtonLayout])
    }
    
    private func cancelButtonLayoutSpec() -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: Const.cancelButtonInsets, child: cancelButtonNode)
    }
    
    private func confirmButtonLayoutSpec() -> ASLayoutSpec {
        return ASInsetLayoutSpec(insets: Const.confirmButtonInsets, child: confirmButtonNode)
    }
}
