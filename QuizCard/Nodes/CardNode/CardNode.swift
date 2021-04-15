//
//  CardNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit

protocol CardNodeDelegate: class {
    func didCardRemove(node: CardNode, direction: CardNode.Direction)
}

class CardNode: ASDisplayNode {
    
    enum Direction {
        case left
        case right
    }
    
    private struct Const {
        static let contentsContainerInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        static let contentsCornerRadius: CGFloat = 10.0
        static let textAttr = AppConst.font(size: 17.0, alignment: .center)
        
        static let overlaySize = CGSize(width: 120, height: 60)
        static let minScale: CGFloat = 0.90
        
        static let rightOverlayInsets = UIEdgeInsets(top: 30, left: 20, bottom: 0, right: 0)
        static let wrongOverlayInsets = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 20)
    }
    
    lazy var contentsNode: FlippableNode = {
        let node = FlippableNode()
        node.frontNode = questionTextNode
        node.backNode = answerTextNode
        return node
    }()
    
    lazy var questionTextNode: VCenterEditableTextNode = {
        let node = VCenterEditableTextNode()
        node.textContainerInset = Const.contentsContainerInsets
        node.isUserInteractionEnabled = false
        node.clipsToBounds = true
        node.cornerRadius = Const.contentsCornerRadius
        node.backgroundColor = .white
        return node
    }()
    
    lazy var answerTextNode: VCenterEditableTextNode = {
        let node = VCenterEditableTextNode()
        node.textContainerInset = Const.contentsContainerInsets
        node.isUserInteractionEnabled = false
        node.clipsToBounds = true
        node.cornerRadius = Const.contentsCornerRadius
        node.backgroundColor = .white
        return node
    }()
    
    lazy var rightOverlayNode: RightOverlayNode = {
        let node = RightOverlayNode()
        node.alpha = 0.0
        return node
    }()
    
    lazy var wrongOverlayNode: WrongOverlayNode = {
        let node = WrongOverlayNode()
        node.alpha = 0.0
        return node
    }()
    
    weak var delegate: CardNodeDelegate?
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    convenience init(questionText: String?, answerText: String?) {
        self.init()
        questionTextNode.attributedText = NSAttributedString(string: questionText ?? "",
                                                             attributes: Const.textAttr)
        answerTextNode.attributedText = NSAttributedString(string: answerText ?? "",
                                                             attributes: Const.textAttr)
    }
    
    override func didLoad() {
        super.didLoad()
        configureGestureRecognizer()
        configureShadow()
    }
    
    private func configureGestureRecognizer() {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(cardDidDrag(_:)))
        panGesture.delegate = self
        view.addGestureRecognizer(panGesture)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardDidTap(_:)))
        tapGesture.delegate = self
        view.addGestureRecognizer(tapGesture)
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        questionTextNode.style.flexGrow = 1.0
        answerTextNode.style.flexGrow = 1.0
        rightOverlayNode.style.preferredSize = Const.overlaySize
        let rightInsetLayout = ASInsetLayoutSpec(insets: Const.rightOverlayInsets, child: rightOverlayNode)
        let rightOverlayLayout = ASRelativeLayoutSpec(horizontalPosition: .start,
                                                      verticalPosition: .start,
                                                      sizingOption: .minimumSize,
                                                      child: rightInsetLayout)
        
        wrongOverlayNode.style.preferredSize = Const.overlaySize
        let wrongInsetLayout = ASInsetLayoutSpec(insets: Const.wrongOverlayInsets, child: wrongOverlayNode)
        let wrongOverlayLayout = ASRelativeLayoutSpec(horizontalPosition: .end,
                                                      verticalPosition: .start,
                                                      sizingOption: .minimumSize,
                                                      child: wrongInsetLayout)
        
        let layout = ASOverlayLayoutSpec(child: contentsNode, overlay: rightOverlayLayout)
   
        return ASOverlayLayoutSpec(child: layout, overlay: wrongOverlayLayout)
    }
    
    func configureShadow() {
        shadowColor = UIColor.black.cgColor
        shadowOffset = CGSize(width: 5, height: 5)
        shadowOpacity = 0.2
        shadowRadius = 2.0
    }
    
    func flip() {
        contentsNode.flip()
    }
}

extension CardNode: UIGestureRecognizerDelegate {
    
    @objc func cardDidDrag(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .changed:
            setOverlayAlpha(gestureRecognizer)
            moveCardByDragging(gestureRecognizer)
        case .ended:
            cardDraggingDidFinish(gestureRecognizer)
        default:
            return
        }
    }
    
    @objc func cardDidTap(_ gestureRecognizer: UITapGestureRecognizer) {
        flip()
    }
    
    private func moveCardByDragging(_ gestureRecognizer: UIPanGestureRecognizer) {
        let xCenter = gestureRecognizer.translation(in: self.view).x
        let yCenter = gestureRecognizer.translation(in: self.view).y
        
        let movementPercent = xCenter / UIScreen.main.bounds.size.width
        let rotationAngle = .pi/8 * -1 * movementPercent
        let scale = max(1 - abs(movementPercent)/4, Const.minScale)

        let transforms = CGAffineTransform(rotationAngle: rotationAngle)
        let scaleTransform: CGAffineTransform = transforms.scaledBy(x: scale, y: scale)
        let moveTransform: CGAffineTransform = scaleTransform.translatedBy(x: xCenter, y: yCenter)
        transform = CATransform3DMakeAffineTransform(moveTransform)
        
        questionTextNode.textView.alignTextCenterVertically()
    }
    
    private func cardDraggingDidFinish(_ gestureRecognizer: UIPanGestureRecognizer) {
        let xCenter = gestureRecognizer.translation(in: self.view).x
        let yCenter = gestureRecognizer.translation(in: self.view).y
        
        guard abs(xCenter) > UIScreen.main.bounds.width/6 ||
                abs(yCenter) > UIScreen.main.bounds.height/6  else {
            setCardOrigin()
            setOverlayInvisible()
            return
        }
        removeCard(x: xCenter, y: yCenter)
    }
    
    private func setOverlayAlpha(_ gestureRecognizer: UIPanGestureRecognizer) {
        let xCenter = gestureRecognizer.translation(in: self.view).x
        let displayingOverlay = xCenter > 0 ? rightOverlayNode : wrongOverlayNode
        let noneDisplayingOverlay = xCenter > 0 ? wrongOverlayNode : rightOverlayNode
        displayingOverlay.alpha = abs(xCenter)/(UIScreen.main.bounds.width/2)
        noneDisplayingOverlay.alpha = 0.0
    }
    
    private func setCardOrigin() {
        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.transform = CATransform3DMakeAffineTransform(CGAffineTransform.identity)
        }
    }
    
    private func setOverlayInvisible() {
        rightOverlayNode.alpha = 0.0
        wrongOverlayNode.alpha = 0.0
    }
    
    private func animateCard(toX x: CGFloat, toY y: CGFloat) {
        UIView.animate(withDuration: 0.4) { [weak self] in
            guard let `self` = self else { return }
            let originTransform = CATransform3DGetAffineTransform(self.transform)
            let moveTransform = originTransform.translatedBy(x: x, y: y)
            self.transform = CATransform3DMakeAffineTransform(moveTransform)
        } completion: { [weak self] _ in
            guard let `self` = self else { return }
            let direction: Direction = x > 0 ? .right : .left
            self.delegate?.didCardRemove(node: self, direction: direction)
            self.removeFromSupernode()
        }
    }
    
    private func removeCard(x: CGFloat, y: CGFloat) {
        let targetX = x > 0 ? UIScreen.main.bounds.size.width : -UIScreen.main.bounds.size.width
        let targetY = abs(y) < UIScreen.main.bounds.size.height/8 ? y : y*abs(UIScreen.main.bounds.height/y)
        
        animateCard(toX: targetX, toY: targetY)
    }
    
    func removeCard(to direction: Direction) {
        var targetX: CGFloat
        let targetY: CGFloat = UIScreen.main.bounds.height * 1/4
        
        let transforms = CGAffineTransform(rotationAngle: direction == .left ? 0.2 : -0.2)
        let scaleTransform: CGAffineTransform = transforms.scaledBy(x: 0.9, y: 0.9)
        transform = CATransform3DMakeAffineTransform(scaleTransform)
        
        switch direction {
        case .right:
            rightOverlayNode.alpha = 1.0
            targetX = UIScreen.main.bounds.size.width * 2
        case .left:
            wrongOverlayNode.alpha = 1.0
            targetX = -UIScreen.main.bounds.size.width * 2
        }
        
        animateCard(toX: targetX, toY: targetY)
    }
}
