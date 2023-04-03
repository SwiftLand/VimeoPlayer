//
//  PlayerView.swift
//  VimeoPlayer
//
//  Created by Ali on 3/10/23.
//

import SwiftUI

struct PlayerView: View {
    
    @StateObject var viewModel:PlayerViewModel
    
    var body: some View {
        ZStack(alignment:.bottom){
            PlayerContainerView(player: viewModel.player,
                                gravity:.aspectFill)
            PlayerControllerView1()
                .padding(.all,viewModel.isExpanded ? 16 : 0)
                .padding(.bottom,viewModel.isExpanded ? 32 : 0)
                .environmentObject(viewModel)
        }
    }
}

struct PlayerView_Previews: PreviewProvider {
    
    static var previews: some View {
       return PlayerView(viewModel: PlayerViewModel())
            .frame(maxWidth: .infinity)
            .frame(height:300)
    }
}
