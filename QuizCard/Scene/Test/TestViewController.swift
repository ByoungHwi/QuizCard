//
//  TestViewController.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

final class TestViewController: ASDKViewController<TestDisplayNode> {
    
    let viewModel: TestViewModel
    let disposeBag = DisposeBag()
    var questions: [QuestionType] = []
    
    init(viewModel: TestViewModel) {
        let node = TestDisplayNode()
        self.viewModel = viewModel
        super.init(node: node)
        node.cardContainerNode.dataSource = self
        bindSelf()
        bindOutput()
        bindInput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindSelf() {
        node.leftButtonNode.rx.tap
            .asDriver()
            .throttle(.milliseconds(500), latest: false)
            .drive(onNext: { [weak self] in
                self?.node.cardContainerNode.leftAction()
            })
            .disposed(by: disposeBag)
        
        node.flipButtonNode.rx.tap
            .asDriver()
            .throttle(.milliseconds(500), latest: false)
            .drive(onNext: { [weak self] in
                self?.node.cardContainerNode.displayingCard?.flip()
            })
            .disposed(by: disposeBag)
        
        node.rightButtonNode.rx.tap
            .asDriver()
            .throttle(.milliseconds(500), latest: false)
            .drive(onNext: { [weak self] in
                self?.node.cardContainerNode.rightAction()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindInput() {
        self.rx.viewDidLoad
            .bind(to: viewModel.input.viewDidLoad)
            .disposed(by: disposeBag)
        
        node.cardContainerNode.rx.cardDidMoveLeft
            .bind(to: viewModel.input.cardDidMoveLeft)
            .disposed(by: disposeBag)
        
        node.cardContainerNode.rx.cardDidMoveRight
            .bind(to: viewModel.input.cardDidMoveRight)
            .disposed(by: disposeBag)
        
        node.cardContainerNode.rx.finished
            .bind(to: viewModel.input.testDidFinish)
            .disposed(by: disposeBag)
        
        node.restartButtonNode.rx.tap
            .bind(to: viewModel.input.restartButtonDidTap)
            .disposed(by: disposeBag)
        
        node.restartFailedOnlyButtonNode.rx.tap
            .bind(to: viewModel.input.restartWithFailedOnlyButtonDidTap)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.cardDataList
            .subscribe(onNext: { [weak self] in
                self?.node.testWillStart()
                self?.questions = $0
                self?.node.cardContainerNode.reloadData()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.testResult
            .subscribe(onNext: { [weak self] in
                self?.node.setResult(total: $0.total, rightCount: $0.rightCount, type: $0.type)
                self?.node.testDidFinish()
            })
            .disposed(by: disposeBag)
    }
}

extension TestViewController: CardContainerNodeDataSource {
    
    func numberOfCards(in node: CardContainerNode) -> Int {
        questions.count
    }
    
    func bufferSize(in node: CardContainerNode) -> Int {
        return 5
    }
    
    func cardContainerNode(node: CardContainerNode, cardForIndexAt index: Int) -> CardNode {
        return CardNode(questionText: questions[index].questionText,
                        answerText: questions[index].answerText)
    }
}
