//
//  TutrorialViewController.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa

final class TutorialViewController: ASDKViewController<TutorialDisplayNode> {
    
    let disposeBag = DisposeBag()
    
    override init() {
        let node = TutorialDisplayNode()
        super.init(node: node)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        node.closeButtonNode.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        node.showOnceButtonNode.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                UserData.shared.isTutorialOff = true
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
}
