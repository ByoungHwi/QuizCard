//
//  BaseTableDataSource.swift
//  QuizCard
//
//  Created by Byoung-Hwi Yoon on 2021/04/15.
//

import RxDataSources_Texture

final class BaseTableDataSource: RxASTableSectionedAnimatedDataSource<TableSection> {
    
    init() {
        let animation = AnimationConfiguration(animated: true,
                                               insertAnimation: .none,
                                               reloadAnimation: .none,
                                               deleteAnimation: .automatic)
        super.init(animationConfiguration: animation,
                   configureCellBlock: { dataSource, node, _, item in
                    return {
                        return ListCellNode(with: item)
                    }
                   },
                   titleForHeaderInSection: { dataSource, index in
                    dataSource.sectionModels[index].header
                   },
                   canEditRowAtIndexPath: { _, _ in
                    return true
                   }
        )
    }
    
}

//lazy var dataSource: RxASTableSectionedAnimatedDataSource<TableSection> = {
//    let animation = AnimationConfiguration(animated: true,
//                                           insertAnimation: .top,
//                                           reloadAnimation: .none,
//                                           deleteAnimation: .automatic)
//    let dataSource = RxASTableSectionedAnimatedDataSource<TableSection>(
//        animationConfiguration: animation,
//        configureCellBlock: { _, _, _, item in
//            return {
//                let node = ListCellNode(with: item)
//                return node
//            }
//        },
//        canEditRowAtIndexPath: { _, _ in
//            return true
//        }
//    )
//    return dataSource
//}()

//lazy var dataSource: RxASTableSectionedAnimatedDataSource<TableSection> = {
//    let animation = AnimationConfiguration(animated: true,
//                                           insertAnimation: .none,
//                                           reloadAnimation: .none,
//                                           deleteAnimation: .automatic)
//    let dataSource = RxASTableSectionedAnimatedDataSource<TableSection>(
//        animationConfiguration: animation,
//        configureCellBlock: { _, node, _, item in
//            return {
//                let node = ListCellNode(with: item)
//                return node
//            }
//        },
//        canEditRowAtIndexPath: { _, _ in
//            return true
//        }
//    )
//    return dataSource
//}()
