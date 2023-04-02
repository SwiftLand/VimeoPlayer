//
//  AppFlow.swift
//  VimoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import RxFlow
class AppFlow: Flow {
    
    var root: Presentable {
        return self.rootViewController
    }
    
    private lazy var rootViewController: UINavigationController = {
        let viewController = UINavigationController()
        viewController.setNavigationBarHidden(false, animated: true)
        return viewController
    }()
    
    func navigate(to step: RxFlow.Step) -> FlowContributors {
        guard let step = step as? AppSteps else { return .none }
        
        switch step {
        case .showList:
            return navigateToListPage()
        case .showDetail(let detail):
            return navigateToDetailPage(data:detail)
        }
    }
    
    private func navigateToListPage() -> FlowContributors {
        let vc:ListViewController =  UIStoryboard(storyboard: .Main).initVC()
        vc.viewModel = ListViewModel()
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
    
    private func navigateToDetailPage(data: VimoResponse.Data) -> FlowContributors {
        let vc:DetailViewController = UIStoryboard(storyboard: .Main).initVC()
        vc.viewModel = DetailViewModel(data: data)
        self.rootViewController.pushViewController(vc, animated: true)
        return .one(flowContributor: .contribute(withNextPresentable: vc, withNextStepper: vc.viewModel))
    }
}

