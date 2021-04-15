//
//  TestCoordinator.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import UIKit

final class TestCoordinator: BaseCoordinator {
    
    override func start(data: Any?) {
        let questionList = data as? [QuestionType] ?? []
        let viewModel = TestViewModel(cardList: questionList)
        let viewController = TestViewController(viewModel: viewModel)
        navigationController?.pushViewController(viewController, animated: true)
        
        let shouldPresentTutorial = !UserData.shared.isTutorialOff
        
        if shouldPresentTutorial {
            let tutorialViewController = TutorialViewController()
            navigationController?.present(tutorialViewController, animated: true)
        }
    }
    
    override func didPop(viewController: UIViewController) {
        guard viewController is TestViewController else { return }
        removeChildCoordinators()
        parentCoordinator?.didFinish(self)
    }
}
