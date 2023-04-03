//
//  StatusView.swift
//  VimeoPlayer
//
//  Created by Ali on 3/12/23.
//

import SwiftUI

struct StatusView: View {
    var icon:String
    var count:Int
    
    var body: some View {
        VStack{
            Image(systemName: icon).padding(.all,4)
            Text(Formatter.formatNumber(count)).font(.system(size: 12, weight: .bold, design: .default))
        }
    }
}

struct StatusView_Previews: PreviewProvider {
    static var previews: some View {
        StatusView(icon: ImageResource.getName(for: .play_icon), count: 10)
    }
}
