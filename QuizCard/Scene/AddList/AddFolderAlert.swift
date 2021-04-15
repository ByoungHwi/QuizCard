//
//  AddFolderAlert.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import UIKit
import RxSwift

final class AddFolderAlert {
    
    private struct Const {
        static let title = "폴더 추가"
        static let message = "새롭게 추가할 폴더의 이름을 입력해주세요."
        static let confirmTitle = "저장"
        static let cancelTitle = "취소"
    }
    
    let controller: UIAlertController
    let result: Observable<String?>
    let disposeBag = DisposeBag()
    
    init() {
        
        let alertController = UIAlertController(title: Const.title,
                                                message: Const.message,
                                                preferredStyle: .alert)
        
        result = Observable.create { observer in
            
            let confirmAction = UIAlertAction(title: Const.confirmTitle, style: .default) { _ in
                observer.onNext(alertController.textFields?.first?.text)
                observer.onCompleted()
            }
            
            let cancelAction = UIAlertAction(title: Const.cancelTitle, style: .cancel) { _ in
                observer.onCompleted()
            }
            
            alertController.addTextField { textField in
                textField.placeholder = AddListViewModel.Const.emptyFolderTitle
            }
            
            alertController.addAction(confirmAction)
            alertController.addAction(cancelAction)
            
            return Disposables.create {
                alertController.dismiss(animated: true)
            }
        }
        
        self.controller = alertController
    }
}
