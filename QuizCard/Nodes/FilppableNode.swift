//
//  FilppableNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

class FlippableNode: ASDisplayNode {
    
    enum State {
        case front
        case back
        
        var flipStyle: UIView.AnimationOptions {
            switch self {
            case .front:
                return .transitionFlipFromLeft
            case .back:
                return .transitionFlipFromRight
            }
        }
        
        var flipped: State {
            switch self {
            case .front:
                return .back
            case .back:
                return .front
            }
        }
    }
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    lazy var frontNode: ASDisplayNode =  {
        let node = ASDisplayNode()
        node.automaticallyManagesSubnodes = true
        node.alpha = 1.0
        node.layoutSpecBlock = { [weak self] node, _ in
            guard let `self` = self else { return ASLayoutSpec() }
            return self.frontNodeLayoutSpec(node: node)
        }
        return node
    }()
    
    lazy var backNode: ASDisplayNode =  {
        let node = ASDisplayNode()
        node.automaticallyManagesSubnodes = true
        node.alpha = 0.0
        node.layoutSpecBlock = { [weak self] node, _ in
            guard let `self` = self else { return ASLayoutSpec() }
            return self.backNodeLayoutSpec(node: node)
        }
        return node
    }()
    
    var currentState: State = .front
    
    override func animateLayoutTransition(_ context: ASContextTransitioning) {
        UIView.transition(with: self.view, duration: 0.4, options: currentState.flipStyle) { [weak self] in
            guard let `self` = self else { return }
            self.frontNode.alpha = self.currentState == .front ? 1.0 : 0.0
            self.backNode.alpha = self.currentState == .front ? 0.0 : 1.0
        } completion: {
            context.completeTransition($0)
        }
    }
    
    fileprivate func flipAnimate(completion: (() -> Void)? = nil) {
        transitionLayout(withAnimation: true,
                         shouldMeasureAsync: false,
                         measurementCompletion: completion)
    }
    
    func flip(completion: (() -> Void)? = nil) {
        currentState = currentState.flipped
        flipAnimate(completion: completion)
    }
    
    open func frontNodeLayoutSpec(node: ASDisplayNode) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
    
    open func backNodeLayoutSpec(node: ASDisplayNode) -> ASLayoutSpec {
        return ASLayoutSpec()
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let displayNode = currentState == .front ? frontNode : backNode
        displayNode.style.flexGrow = 1.0
        return ASInsetLayoutSpec(insets: .zero, child: displayNode)
    }
}

extension Reactive where Base: FlippableNode {
    internal var state: Binder<Base.State> {
        return Binder(self.base) { node, state in
            node.currentState = state
            node.flipAnimate()
        }
    }
}
