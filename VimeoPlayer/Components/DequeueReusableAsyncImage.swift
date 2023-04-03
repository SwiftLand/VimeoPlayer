//
//  DequeueAsyncImage.swift
//  VimeoPlayer
//
//  Created by Ali on 3/9/23.
//

import SwiftUI


struct DequeueReusableAsyncImage<Content> : View where Content : View {
    
    let url: URL?
    
    @ViewBuilder let content: (AsyncImagePhase) -> Content
    @State private var currentUrl: URL?
    
    var body: some View {
        var isFailed:Bool = false
        return AsyncImage(url: currentUrl){
            phase in
            
            switch phase{
            case .failure(_):
                isFailed = true
                break
            default:break
            }
            
            return content(phase)
        }
        .onAppear {
            if isFailed {
                currentUrl = nil
            }
            if currentUrl == nil {
                DispatchQueue.main.async {
                    currentUrl = url
                }
            }
        }
    }
    
}


struct DequeueAsyncImage_Previews: PreviewProvider {
    static var previews: some View {
        DequeueReusableAsyncImage(url: URL(string: "https://picsum.photos/200/300")){
            phase in
            switch phase {
            case .success(let image):
                image.resizable()
            case .failure(_):
                Color.gray
                    .brightness(0.4)//placeholder
            case .empty:
                ZStack{
                    Color.gray
                        .brightness(0.4)//placeholder
                    ProgressView()
                }
            @unknown default:
                Color.gray
                    .brightness(0.4)//placeholder
            }
        }.frame(width: 300,height: 300)
    }
}
