//
//  InfoView.swift
//  VimeoPlayer
//
//  Created by Ali on 3/12/23.
//

import SwiftUI

struct InfoView: View {
    var data:VimeoResponse.Data
    var body: some View {
        HStack{
            Spacer()
            StatusView(icon: ImageResource.getName(for: .play_icon),
                       count:  data.stats?.plays ?? 0)
            Spacer()
            StatusView(icon: ImageResource.getName(for: .comment_icon),
                       count: data.metadata?.connections?.comments?.total ?? 0)
            Spacer()
            StatusView(icon: ImageResource.getName(for: .like_icon),
                       count:data.metadata?.connections?.likes?.total ?? 0)
            Spacer()
        }
    }
}


struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView(data: sample_data)
    }
}
