//
//  HomeViewController.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import AsyncDisplayKit
import RxSwift
import RxCocoa
import RxDataSources_Texture

final class HomeViewController: ASDKViewController<HomeDisplayNode> {
    
    private struct Const {
        static let navigationTitle: String = "질문 목록"
        static let headerHeight: CGFloat = 55.0
    }

    let viewModel: HomeViewModel
    let disposeBag = DisposeBag()
    let dataSource = BaseTableDataSource()
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(node: HomeDisplayNode())
        navigationItem.title = Const.navigationTitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindSelf()
        bindInput()
        bindOutput()
    }
    
    private func bindSelf() {
        node.tableNode.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
    
    private func bindInput() {
        self.rx.viewWillAppear
            .bind(to: viewModel.input.viewWillAppear)
            .disposed(by: disposeBag)
        
        node.addButtonNode.rx.tap
            .bind(to: viewModel.input.addButtonTapped)
            .disposed(by: disposeBag)
        
        node.tableNode.rx.itemDeleted
            .bind(to: viewModel.input.cellShouldDelete)
            .disposed(by: disposeBag)
        
        node.tableNode.rx.itemSelected
            .bind(to: viewModel.input.cellDidSelected)
            .disposed(by: disposeBag)
    }
    
    private func bindOutput() {
        viewModel.output.folderList
            .asObservable()
            .bind(to: node.tableNode.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
    }
}

extension HomeViewController: ASTableDelegate {
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.contentView.backgroundColor = AppConst.backgroundColor
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        Const.headerHeight
    }
}
