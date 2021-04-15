//
//  HomeCoordinator.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/14.
//

import UIKit
import RxSwift

final class HomeCoordinator: BaseCoordinator {
    
    var disposeBag = DisposeBag()
    
    override func start(data: Any? = nil) {
        let dataManager = HomeDataManager()
        let viewModel = HomeViewModel(dataManager: dataManager)
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: false)
        
        viewModel.output.selectedItem
            .subscribe(onNext: { [weak self] in
                self?.moveToQuestionList($0)
            })
            .disposed(by: disposeBag)

        viewModel.output.presentAddListView
            .subscribe(onNext: { [weak self] in
                self?.presentAddListView()
            })
            .disposed(by: disposeBag)
    }
    
    private func moveToQuestionList(_ questionList: QuestionListType) {
        let questionListCoordinator = QuestionsCoordinator()
        start(questionListCoordinator, data: questionList)
    }
    
    private func presentAddListView() {
        let dataManager = AddListDataManager()
        let viewModel = AddListViewModel(dataManager: dataManager)
        let viewController = AddListViewController(viewModel: viewModel)
        navigationController?.present(viewController, animated: true)
    }
}
