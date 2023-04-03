//
//  PlayerControllerView.swift
//  VimeoPlayer
//
//  Created by Ali on 3/10/23.
//

import SwiftUI

struct PlayerControllerView1: View {
    
    @EnvironmentObject var playerVM:PlayerViewModel
    
    var body: some View {
        HStack{

            Button {
                playerVM.player.togglePlay()
            } label: {
                Image(systemName:
                        ImageResource.getName(for: playerVM.isPlay ? .pause_icon :.play_icon))
                    .foregroundColor(Color(UIColor.darkGray))
            }
            PlayerSliderView(value:$playerVM.progressValue,
                             event:.init(onDragStart:playerVM.onDrageSliderStart,
                                         onDragEnd:playerVM.onDrageSliderEnd))
                .frame(maxWidth:.infinity)
                .frame(height: 20)
            
            Button {
                playerVM.player.toggleMute()
            } label: {
                Image(systemName:
                        ImageResource.getName(for: playerVM.player.isMuted ? .mute_icon : .unMute_icon))
                    .foregroundColor(Color(UIColor.darkGray))
            }
            Button {
                playerVM.isExpanded.toggle()
            } label: {
                Image(systemName:
                        ImageResource.getName(for:playerVM.isExpanded ? .collapse_icon : .expand_icon))
                    .foregroundColor(Color(UIColor.darkGray))
            }
        }.padding(.all,8).background{
            Color.white.opacity(0.5)
                .clipShape(RoundedRectangle(cornerRadius:playerVM.isExpanded ? 4 : 0,style: .continuous))
        }
    }
}
struct PlayerControllerView_Previews: PreviewProvider {
    static var previews: some View {
        return PlayerControllerView1().environmentObject( PlayerViewModel())
    }
}
