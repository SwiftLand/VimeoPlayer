//
//  PlayerContainerView.swift
//  VimeoPlayer
//
//  Created by Ali on 3/10/23.
//

import SwiftUI
import AVFoundation

struct PlayerContainerView: UIViewRepresentable {
 
    typealias UIViewType = PlayerUIView
    
    let player: AVPlayer
    let gravity: PlayerGravity
    
    init(player: AVPlayer, gravity: PlayerGravity) {
        self.player = player
        self.gravity = gravity
    }
    
    func makeUIView(context: Context) -> PlayerUIView {
        return PlayerUIView(player: player, gravity: gravity)
    }
    
    func updateUIView(_ uiView: PlayerUIView, context: Context) { }
}

struct PlayerContainerView_Previews: PreviewProvider {
    static var previews: some View {
        PlayerContainerView(player: AVPlayer(), gravity: .aspectFill)
    }
}
