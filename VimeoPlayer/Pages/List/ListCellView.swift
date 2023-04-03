//
//  ListCellView.swift
//  VimeoPlayer
//
//  Created by Ali on 3/8/23.
//

import SwiftUI

struct ListCellView: View {
    
    var data:VimeoResponse.Data
    
    var body: some View {
        GeometryReader{ geo in
            
            let imageSize = CGSize(width: geo.size.width*0.45,
                                   height:  geo.size.width*0.45)
            
            HStack(alignment:.top){
                ZStack(alignment:.bottomTrailing){
                    
                    if let size = data.pictures?.getSize(for:imageSize),
                       let link = size.link,let url = URL(string: link){
                        
                        ListCellImageView(url: url)
                    }else{
                        Color.gray
                            .brightness(0.4)//placeholder
                    }
                    
                    if let duration = data.duration{
                        
                        Text(Formatter.formateDuration(seacond: duration))
                            .padding(.all,4)
                            .background{
                                Color.gray.clipShape(RoundedRectangle(cornerRadius: 4,style: .continuous))
                            }
                            .foregroundColor(.white)
                            .font(.footnote)
                            .padding(.all,4)
                    }
                    
                    
                }.frame(width:geo.size.height*1.35,
                        height:geo.size.height)
                
                HStack {
                    VStack(alignment: .leading){
                        Text(data.name ?? "").font(.system(size: 14, weight: .bold, design: .default))
                        Text(data.description ?? "" )
                            .font(.system(size: 12, weight: .regular, design: .default)).foregroundColor(.gray)
                        Spacer()
                        HStack{
                            ZStack{
                                if let size = data.user?.pictures?.getSize(for:imageSize),
                                   let link = size.link,let url = URL(string: link){
                                    
                                    ListCellImageView(url: url).clipShape(Circle())
                                        .overlay{
                                            Circle().stroke(.gray, lineWidth: 1)
                                        }
                                    
                                }else{
                                    Image(uiImage: ImageResource.getImage(for: .person))
                                        .resizable()
                                        .clipShape(Circle())
                                        .overlay{
                                            Circle().stroke(.gray, lineWidth: 1)
                                        }
                                    
                                }
                            }.frame(width: geo.size.height*0.25,height: geo.size.height*0.25)
                            
                            Text(data.user?.name ?? StringResource.get(.unkown)).font(.system(size: 12, weight:.semibold, design: .default))
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

private struct ListCellImageView: View {
    
    let url:URL
    var body: some View {
        DequeueReusableAsyncImage(url: url){
            phase in
            switch phase {
                
            case .success(let image):
                image.resizable()
            case .failure(_):
                ZStack{
                    Color.gray
                        .brightness(0.4)
                    Image(systemName: ImageResource.getName(for: .error_icon))
                        .resizable()
                        .foregroundColor(Color.red).frame(width:25,height: 25)
                }
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
        }
    }
}

struct ListCellView_Previews: PreviewProvider {
    static var previews: some View {
        ListCellView(data:sample_data)
            .frame(width: .infinity,height: 150)
    }
}


let sample_data:VimeoResponse.Data = .init(uri: "",
                                          name: "Title",
                                          description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.",
                                          duration: 120,
                                          width: nil,
                                          language: nil,
                                          height: nil,
                                          pictures:.init(uri: nil,
                                                         active: nil,
                                                         type: nil,
                                                         baseLink: nil,
                                                         sizes: [.init(width: 200, height: 300,
                                                                       link: "https://picsum.photos/200/300", linkWithPlayButton: nil)],
                                                         resourceKey: nil,
                                                         defaultPicture: nil),
                                          stats: .init(plays: 5236),
                                          uploader: nil,
                                          metadata: .init(connections: .init(
                                            comments: .init(uri: nil, options: [], total: 5),
                                            credits: .init(uri: nil, options: [], total: 10),
                                            likes: .init(uri: nil, options: [], total: 1024), pictures: nil)),
                                          user: .init(uri: "",
                                                      name: "Author",
                                                      pictures: .init(uri: nil,
                                                                      active: nil,
                                                                      type: nil,
                                                                      baseLink: nil,
                                                                      sizes: [.init(width: 200, height: 300,
                                                                                    link: "https://picsum.photos/200/300", linkWithPlayButton: nil)],
                                                                      resourceKey: nil,
                                                                      defaultPicture: nil),
                                                      resourceKey: nil,
                                                      account: nil))
