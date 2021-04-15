//
//  CardContainerNode.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

protocol CardContainerNodeDataSource: class {
    func bufferSize(in node: CardContainerNode) -> Int
    func numberOfCards(in node: CardContainerNode) -> Int
    func cardContainerNode(node: CardContainerNode, cardForIndexAt index: Int) -> CardNode
}

extension CardContainerNodeDataSource {
    func bufferSize(in node: CardContainerNode) -> Int {
        return 3
    }
}

protocol CardContainerNodeDelegate: class {
    func cardDidMoveLeft(node: CardContainerNode)
    func cardDidMoveRight(node: CardContainerNode)
    func containerDidBecomeEmpty(node: CardContainerNode)
}

class CardContainerNode: ASDisplayNode {
    
    weak var dataSource: CardContainerNodeDataSource?
    weak var delegate: CardContainerNodeDelegate?
    
    private let defaultBufferSize = 3
    private let fetchBound = 2
    
    private(set) var loadedCards: [CardNode] = []
    private(set) var currentIndex = 0
    private(set) var rightCount = 0
    private(set) var leftCount = 0
    
    var displayingCard: CardNode? {
        loadedCards.first
    }
    
    var bufferSize: Int {
        dataSource?.bufferSize(in: self) ?? defaultBufferSize
    }
    
    lazy var baseNode: ASDisplayNode = {
        let node = ASDisplayNode()
        return node
    }()
    
    override init() {
        super.init()
        automaticallyManagesSubnodes = true
    }
    
    private func cardOverayLayout(cardIndex: Int, baseLayout: ASLayoutSpec) -> ASLayoutSpec {
        guard cardIndex < loadedCards.count else { return baseLayout }
        return ASOverlayLayoutSpec(child: cardOverayLayout(cardIndex: cardIndex + 1, baseLayout: baseLayout), overlay: loadedCards[cardIndex])
    }
    
    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let baseLayout = ASInsetLayoutSpec(insets: .zero, child: baseNode)
        let cardsLayout = cardOverayLayout(cardIndex: 0, baseLayout: baseLayout)
        return cardsLayout
    }
    
    private func addNewCards() {
        var index = currentIndex + loadedCards.count
        while loadedCards.count < bufferSize {
            guard let numberOfCards = dataSource?.numberOfCards(in: self),
                  index < numberOfCards,
                  let newCard = dataSource?.cardContainerNode(node: self, cardForIndexAt: index) else {
                return
            }
            newCard.delegate = self
            loadedCards.append(newCard)
            index += 1
        }
    }
    
    private func removeFirstCard() {
        guard !loadedCards.isEmpty else { return }
        loadedCards.removeFirst()
    }
    
    private func updateLayoutIfNeeded() {
        guard bufferSize <= fetchBound || currentIndex % (bufferSize - fetchBound) == 0 else { return
        }
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func reloadData() {
        currentIndex = 0
        loadedCards = []
        addNewCards()
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @objc func leftAction() {
        displayingCard?.removeCard(to: .left)
    }
    
    func rightAction() {
        displayingCard?.removeCard(to: .right)
    }
    
    @objc dynamic func cardDidMoveLeft() {
        delegate?.cardDidMoveLeft(node: self)
    }
    
    @objc dynamic func cardDidMoveRight() {
        delegate?.cardDidMoveRight(node: self)
    }
    
    @objc dynamic func didBecomeEmpty() {
        delegate?.containerDidBecomeEmpty(node: self)
    }
}

extension CardContainerNode: CardNodeDelegate {
    func didCardRemove(node: CardNode, direction: CardNode.Direction) {
        switch direction {
        case .left:
            cardDidMoveLeft()
        case .right:
            cardDidMoveRight()
        }
        currentIndex += 1
        
        if currentIndex == dataSource?.numberOfCards(in: self) {
            didBecomeEmpty()
            return
        }
        
        removeFirstCard()
        addNewCards()
        updateLayoutIfNeeded()
    }
}

extension Reactive where Base: CardContainerNode {
   
    var cardDidMoveLeft: Observable<Int> {
        return methodInvoked(#selector(CardContainerNode.cardDidMoveLeft))
            .map { _ in
                base.currentIndex - 1
            }
    }
    
    var cardDidMoveRight: Observable<Int> {
        return methodInvoked(#selector(CardContainerNode.cardDidMoveRight))
            .map { _ in
                base.currentIndex - 1
            }
    }
    
    var finished: Observable<Void> {
        return methodInvoked(#selector(CardContainerNode.didBecomeEmpty))
            .map { _ in return }
    }
   
}
