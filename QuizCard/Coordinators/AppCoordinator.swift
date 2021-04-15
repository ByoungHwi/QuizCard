//
//  AppCoordinator.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/14.
//

import UIKit

final class AppCoordinator: BaseCoordinator {
    
    private let window: UIWindow?
    
    init(with window: UIWindow?) {
        self.window = window
        super.init()
    }
    
    override func start(data: Any? = nil) {
        let navigationController = UINavigationController()
        self.navigationController = navigationController
        navigationController.navigationBar.barTintColor = AppConst.edgeColor
        navigationController.navigationBar.tintColor = AppConst.appThemeColor
        let coordinator = HomeCoordinator()
        window?.makeKeyAndVisible()
        window?.rootViewController = navigationController
        
        start(coordinator)
    }
}
