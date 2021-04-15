//
//  QuestionsViewController.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxDataSources_Texture

final class QuestionsViewController: ASDKViewController<QuestionListDisplayNode> {
    
    let viewModel: QuestionsViewModel
    let disposeBag = DisposeBag()
    let dataSource = BaseTableDataSource()
    
    init(viewModel: QuestionsViewModel, title: String? = nil) {
        self.viewModel = viewModel
        super.init(node: QuestionListDisplayNode())
        node.title = title
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindInput()
        bindOutput()
    }
    
    private func bindInput() {
        rx.viewWillAppear
            .bind(to: viewModel.input.viewWillAppear)
            .disposed(by: disposeBag)
        
        node.questionListNode.addButtonNode.rx.tap
            .bind(to: viewModel.input.addButtonTapped)
            .disposed(by: disposeBag)
        
        node.testStartButtonNode.rx.tap
            .bind(to: viewModel.input.testStartButtonTapped)
            .disposed(by: disposeBag)
        
        node.shuffleButton?.rx.tap
            .bind(to: viewModel.input.shuffleButtonTapped)
            .disposed(by: disposeBag)
        
        node.questionListNode.tableNode.rx
            .itemDeleted
            .bind(to: viewModel.input.cellShouldDelete)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.questionList
            .bind(to: node.questionListNode.tableNode.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.shuffleState
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.node.updateShuffleButton(shouldShuffle: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isTestStartButtonEnable
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] in
                self?.node.testStartButtonNode.alpha = $0 ? 1 : 0.5
                self?.node.testStartButtonNode.isEnabled = $0
            })
            .disposed(by: disposeBag)
    }
}
