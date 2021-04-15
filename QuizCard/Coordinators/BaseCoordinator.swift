//
//  BaseCoordinator.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/14.
//

import UIKit

protocol Coordinator: NSObject, UINavigationControllerDelegate {
    var navigationController: UINavigationController? { get set }
    var parentCoordinator: Coordinator? { get set }
    
    func start(data: Any?)
    func start(_ coordinator: Coordinator, data: Any?)
    func didFinish(_ coordinator: Coordinator)
    func removeChildCoordinators()
}

class BaseCoordinator: NSObject, Coordinator {
    var navigationController: UINavigationController?
    var childCoordinators = [Coordinator]()
    var parentCoordinator: Coordinator?
    
    func start(data: Any? = nil) {
        fatalError("start() has not been implemented")
    }
    
    func start(_ coordinator: Coordinator, data: Any? = nil) {
        coordinator.parentCoordinator = self
        coordinator.navigationController = navigationController
        childCoordinators.append(coordinator)
        navigationController?.delegate = coordinator
        coordinator.start(data: data)
    }
    
    func removeChildCoordinators() {
        childCoordinators.forEach { $0.removeChildCoordinators() }
        childCoordinators.removeAll()
    }
    
    func didFinish(_ coordinator: Coordinator) {
        childCoordinators.removeAll { $0 === coordinator }
    }
}

extension BaseCoordinator: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController,
                              didShow viewController: UIViewController,
                              animated: Bool) {
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
              !navigationController.viewControllers.contains(poppedViewController) else {
            return
        }
        
        didPop(viewController: poppedViewController)
    }
    
    @objc func didPop(viewController: UIViewController) { }
}
