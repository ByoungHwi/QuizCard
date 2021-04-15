//
//  AddQuestionViewController.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit
import RxSwift
import RxRelay

final class AddQuestionViewController: ASDKViewController<AddQuestionDisplayNode> {
    
    let disposeBag = DisposeBag()
    let newQuestionObserver: NewQuestionObserver
    
    init(observer: NewQuestionObserver) {
        newQuestionObserver = observer
        let node = AddQuestionDisplayNode()
        super.init(node: node)
        bindSelf()
        node.questionTextNode.observeContentSize()
        node.answerTextNode.observeContentSize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindSelf() {
        self.rx.viewWillAppear
            .subscribe(onNext: { [weak self] in
                self?.node.questionTextNode.becomeFirstResponder()
            })
            .disposed(by: disposeBag)
        
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .asObservable()
            .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue }
            .asDriver(onErrorJustReturn: .zero)
            .drive(onNext: { [weak self] keyboardFrame in
                self?.keyboardWillShow(keyboardFrame: keyboardFrame)
            })
            .disposed(by: disposeBag)
        
        node.cancelButtonNode.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        let textObserver = Observable.combineLatest(node.questionTextNode.textView.rx.text,
                                                    node.answerTextNode.textView.rx.text)
        node.confirmButtonNode.rx.tap
            .withLatestFrom(textObserver)
            .subscribe(onNext: { [weak self] in
                self?.confirmButtonDidTap(questionText: $0, answerText: $1)
            })
            .disposed(by: disposeBag)
    }
    
    private func confirmButtonDidTap(questionText: String?, answerText: String?) {
        switch node.flipNode.currentState {
        case .front:
            node.flipNode.rx.state.onNext(.back)
            node.answerTextNode.becomeFirstResponder()
            node.setConfirmButtonText()
        case .back:
            newQuestionObserver.accept((questionText ?? "", answerText ?? ""))
            dismiss(animated: true)
        }
    }
    
    private func keyboardWillShow(keyboardFrame: CGRect) {
        node.setBottomInset(keyboardFrame.height - view.safeAreaInsets.bottom)
    }
}
