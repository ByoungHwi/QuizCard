//
//  QuestionsCoordinator.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import UIKit
import RxSwift
import RxRelay

final class QuestionsCoordinator: BaseCoordinator {
    
    var disposeBag = DisposeBag()
    
    override func start(data: Any?) {
        
        guard let questionList: QuestionListType = data as? QuestionListType else {
            debugPrint("QuestionListCoordinator Couldn't start because of wrong passed Data")
            return
        }
        
        let dataManager = QuestionsDataManager(targetList: questionList)
        let viewModel = QuestionsViewModel(dataManager: dataManager)
        let viewController = QuestionsViewController(viewModel: viewModel,
                                                     title: questionList.title)
        
        viewModel.output.presentAddQuestionView
            .subscribe(onNext: { [weak self] in
                self?.presentAddQuestion(newQuestionObserver: $0)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.saveResult
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.presentedViewController?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.pushTestView
            .subscribe(onNext: { [weak self] questionList in
                self?.moveToTest(questions: questionList)
            })
            .disposed(by: disposeBag)
        
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func didPop(viewController: UIViewController) {
        guard viewController is QuestionsViewController else { return }
        removeChildCoordinators()
        parentCoordinator?.didFinish(self)
    }
    
    private func presentAddQuestion(newQuestionObserver: PublishRelay<(question: String, answer: String)> ) {
        let viewController = AddQuestionViewController(observer: newQuestionObserver)
        navigationController?.present(viewController, animated: true)
    }
    
    private func moveToTest(questions: [QuestionType]) {
        let coordinator = TestCoordinator()
        start(coordinator, data: questions)
    }
}
