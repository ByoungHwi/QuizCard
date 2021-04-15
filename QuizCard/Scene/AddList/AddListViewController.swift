//
//  AddListViewController.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxDataSources_Texture

final class AddListViewController: ASDKViewController<AddListDisplayNode> {
    
    let viewModel: AddListViewModel
    let disposeBag = DisposeBag()
    let dataSource = BaseTableDataSource()
    
    init(viewModel: AddListViewModel) {
        self.viewModel = viewModel
        super.init(node: AddListDisplayNode())
        node.folderListNode.tableNode.allowsMultipleSelection = false
        bindSelf()
        bindInput()
        bindOutput()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bindSelf() {
        NotificationCenter.default.rx.notification(UIResponder.keyboardWillShowNotification)
            .compactMap { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue }
            .asDriver(onErrorJustReturn: .zero)
            .drive(onNext: { [weak self] keyboardFrame in
                self?.keyboardWillShow(keyboardFrame: keyboardFrame)
            })
            .disposed(by: disposeBag)
        
        node.folderListNode.tableNode.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        node.folderListNode.addButtonNode.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.showAddFolderAlert()
            })
            .disposed(by: disposeBag)
        
        node.cancelButtonNode.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindInput() {
        self.rx.viewWillAppear
            .do(onNext: { [weak self] in
                self?.node.titleInputNode.becomeFirstResponder()
            })
            .bind(to: viewModel.input.viewWillAppear)
            .disposed(by: disposeBag)
        
        node.titleInputNode.textView.rx.text
            .orEmpty
            .bind(to: viewModel.input.newQuestionListTitle)
            .disposed(by: disposeBag)
        
        node.confirmButtonNode.rx.tap
            .bind(to: viewModel.input.addButtonTapped)
            .disposed(by: disposeBag)
        
        node.folderListNode.tableNode.rx
            .itemDeleted
            .bind(to: viewModel.input.cellShouldDelete)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.folderList
            .asObservable()
            .bind(to: node.folderListNode.tableNode.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        viewModel.output.saveResult
            .filter { $0 }
            .subscribe(onNext: { [weak self] _ in
                self?.dismiss(animated: true)
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isAddButtonEnable
            .subscribe(onNext: { [weak self] in
                self?.node.confirmButtonNode.isEnabled = $0
                self?.node.confirmButtonNode.alpha = $0 ? 1.0 : 0.5
            })
            .disposed(by: disposeBag)
    }
   
    private func showAddFolderAlert() {
        let alert = AddFolderAlert()
        alert.result
            .compactMap { $0 }
            .bind(to: viewModel.input.createNewFolder)
            .disposed(by: disposeBag)
        
        present(alert.controller, animated: true)
    }
    
    private func keyboardWillShow(keyboardFrame: CGRect) {
        node.setBottomInset(keyboardFrame.height - view.safeAreaInsets.bottom)
    }
}

extension AddListViewController: ASTableDelegate {
    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableNode.nodeForRow(at: indexPath) as? ListCellNode else { return }
        cell.contentsNode.backgroundColor = AppConst.appThemeColor
        viewModel.input.selectedIndex.accept(indexPath)
    }
    
    func tableNode(_ tableNode: ASTableNode, didDeselectRowAt indexPath: IndexPath) {
        guard let cell = tableNode.nodeForRow(at: indexPath) as? ListCellNode else { return }
        cell.contentsNode.backgroundColor = .white
    }
}
