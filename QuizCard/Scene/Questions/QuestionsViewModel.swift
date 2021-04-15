//
//  QuestionsViewModel.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import Foundation
import RxSwift
import RxRelay

typealias NewQuestionObserver = PublishRelay<(question: String, answer: String)>

final class QuestionsViewModel: ViewModelType {
    
    struct Input {
        let viewWillAppear = PublishRelay<Void>()
        let cellShouldDelete = PublishRelay<IndexPath>()
        let addButtonTapped = PublishRelay<Void>()
        let testStartButtonTapped = PublishRelay<Void>()
        let shuffleButtonTapped = PublishRelay<Void>()
        let newQuestion = PublishRelay<(question: String, answer: String)>()
    }
    
    struct Output {
        let shuffleState = BehaviorRelay<Bool>(value: UserData.shared.shouldShuffle)
        let presentAddQuestionView = PublishRelay<NewQuestionObserver>()
        let pushTestView = PublishRelay<[QuestionType]>()
        let questionList = BehaviorRelay<[TableSection]>(value: [])
        let saveResult = PublishRelay<Bool>()
        let isTestStartButtonEnable = PublishRelay<Bool>()
    }
    
    var input: Input
    var output: Output
    let disposeBag = DisposeBag()
    let dataManager: QuestionsDataManagable
    
    init(dataManager: QuestionsDataManagable) {
        input = Input()
        output = Output()
        self.dataManager = dataManager
        bind()
    }
    
    private func bind() {
        input.viewWillAppear
            .subscribe(onNext: { [weak self] _ in
                self?.dataManager.performFetch()
            })
            .disposed(by: disposeBag)
        
        input.addButtonTapped
            .compactMap { [weak self] in
                self?.input.newQuestion
            }
            .bind(to: output.presentAddQuestionView)
            .disposed(by: disposeBag)

        dataManager.dataObserver
            .map { [weak self] in
                guard let `self` = self else { return [] }
                let fetchedData = TableSection(items: $0)
                if $0.isEmpty { self.output.presentAddQuestionView.accept(self.input.newQuestion) }
                self.output.isTestStartButtonEnable.accept(!$0.isEmpty)
                return [fetchedData]
            }
            .bind(to: output.questionList)
            .disposed(by: disposeBag)
        
        input.cellShouldDelete
            .subscribe(onNext: { [weak self] index in
                self?.updateCellCornerIfNeeded(index: index)
                self?.dataManager.delete(at: index)
            })
            .disposed(by: disposeBag)
        
        input.newQuestion
            .compactMap { [weak self] in
                self?.dataManager.create(question: $0.question, answer: $0.answer)
            }
            .bind(to: output.saveResult)
            .disposed(by: disposeBag)
        
        input.testStartButtonTapped.withLatestFrom(dataManager.dataObserver)
            .compactMap {
                if UserData.shared.shouldShuffle {
                    return $0.shuffled()
                }
                return $0
            }
            .bind(to: output.pushTestView)
            .disposed(by: disposeBag)
        
        input.shuffleButtonTapped
            .map {
                UserData.shared.shouldShuffle.toggle()
                return UserData.shared.shouldShuffle
            }
            .bind(to: output.shuffleState)
            .disposed(by: disposeBag)
    }
    
    private func updateCellCornerIfNeeded(index: IndexPath) {
        guard index.row == 0 else { return }
        var currentData = output.questionList.value
        if currentData[index.section].items.count > 1 {
            currentData[index.section].items[1].isFirst = true
            output.questionList.accept(currentData)
        }
    }
}
