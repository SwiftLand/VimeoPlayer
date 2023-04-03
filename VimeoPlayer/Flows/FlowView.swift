//
//  FlowView.swift
//  VimeoPlayer
//
//  Created by Ali on 3/9/23.
//

import Foundation
import SwiftUI


struct FlowView: View {
    
    @StateObject var viewModel = FlowViewModel()
    @StateObject var store = Store()
    
    var body: some View {
       return NavigationStack(path: $viewModel.navigationPath) {
           ListView(viewModel: viewModel.getListViewModel())//root
                .navigationDestination(for: Screen.self) {screen in
                    switch screen {
                    case .detail(let vm):
                        DetailView(viewModel: vm)
                    case .list(vm: let vm):
                        ListView(viewModel: vm)
                    }
                }
        }.onRotate { newOrientation in
            store.orientation = newOrientation
        }.environmentObject(store)
    }
}
