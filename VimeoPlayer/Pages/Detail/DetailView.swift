//
//  DetailView.swift
//  VimeoPlayer
//
//  Created by Ali on 3/10/23.
//

import SwiftUI

struct DetailView: View {
    
    @StateObject var viewModel:DetailViewModel
    @StateObject var playerVM:PlayerViewModel = PlayerViewModel()
    @EnvironmentObject var store: Store
    
    var body: some View {
        ZStack{
            if store.orientation.isLandscape {
                LandscapeView(viewModel: viewModel, playerVM:playerVM)
            } else {
                PortraitView(viewModel: viewModel, playerVM:playerVM)
            }
        }.onAppear{
            viewModel.viewDidAppear(with: playerVM)
            
        }
        .navigationBarHidden(playerVM.isExpanded)
        .animation(.easeInOut,value: playerVM.isExpanded)
    }
}

fileprivate struct PortraitView:View{
    @ObservedObject var viewModel:DetailViewModel
    @ObservedObject var playerVM:PlayerViewModel
    
    @State var playerFullScreenSize:CGFloat = 0
    @State var playerSize:CGFloat = 0
    
    var titleHeight:CGFloat = 30
    
    var body:some View{
        GeometryReader{
            gr in
            ZStack(alignment: .top){
                VStack{
                    Text(viewModel.data.name ?? "")
                        .font(.system(size: 20, weight: .bold, design: .default))
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .padding(.leading)
                        .padding(.trailing)
                        .frame(maxWidth: .infinity)
                        .frame(height: titleHeight)
                    
                    Spacer()
                        .frame(maxWidth:.infinity)
                        .frame(height:playerSize)
                    
                    InfoView(data: viewModel.data)
                        .frame(maxWidth:.infinity)
                    
                    ScrollView {
                        Text(viewModel.data.description ?? "")
                            .font(.system(size: 14, weight: .regular, design: .default))
                            .lineLimit(nil)
                            .padding()
                            .padding(.bottom,80)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                    }.frame(maxWidth:.infinity)
                    
                }.offset(y:gr.safeAreaInsets.top)
                
                PlayerView(viewModel: playerVM)
                    .padding(.all,playerVM.isExpanded ? 0 : 16)
                    .frame(maxWidth:.infinity)
                    .frame(height:playerVM.isExpanded ? playerFullScreenSize: playerSize)
                    .offset(y:playerVM.isExpanded ? 0 : titleHeight+gr.safeAreaInsets.top+8)
                    .animation(.spring(), value: playerVM.isExpanded)
                
            }.onAppear{
                playerSize = gr.size.height*0.35
                playerFullScreenSize = gr.size.height +
                gr.safeAreaInsets.top +
                gr.safeAreaInsets.bottom
            }.ignoresSafeArea(.all)
        }
    }
}

fileprivate struct LandscapeView:View{
    @ObservedObject var viewModel:DetailViewModel
    @ObservedObject var playerVM:PlayerViewModel
    
    var body:some View{
        GeometryReader{
            gr in
            ZStack(alignment:.leading){
                
                HStack(alignment: .center){
                    
                    Spacer().frame(width: gr.size.width*0.5 ,
                                   height:gr.size.height*0.75)
                    VStack{
                        Text(viewModel.data.name ?? "")
                            .font(.system(size: 20, weight: .bold, design: .default))
                            .lineLimit(2)
                            .minimumScaleFactor(0.5)
                            .padding(.leading)
                            .padding(.trailing)
                            .frame(maxWidth: .infinity)
                            .frame(height: 30)
                        
                        InfoView(data: viewModel.data)
                            .frame(maxWidth:.infinity)
                        
                        ScrollView {
                            Text(viewModel.data.description ?? "")
                                .font(.system(size: 14, weight: .regular, design: .default))
                                .lineLimit(nil)
                                .padding()
                                .padding(.bottom,20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                        }.frame(height: gr.size.height*0.5)
                        
                    }.frame(maxHeight: .infinity)
                }
                
                PlayerView(viewModel: playerVM)
                    .frame(width:playerVM.isExpanded ?
                           gr.size.width : gr.size.width*0.5 ,
                           height:playerVM.isExpanded ?
                           gr.size.height : gr.size.height*0.75)
                
                    .animation(.spring(), value: playerVM.isExpanded)
                    .onAppear{
                        viewModel.viewDidAppear(with: playerVM)
                    }
            }.padding(.all,playerVM.isExpanded ? 0 : 16)
                .padding(.trailing,playerVM.isExpanded ? 0 : 32)
        }
        .ignoresSafeArea(.all)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        DetailView(viewModel: DetailViewModel(data: sample_data))
            .environmentObject(Store(orientation: .portrait))
        
        DetailView(viewModel: DetailViewModel(data: sample_data))
            .environmentObject(Store(orientation:.landscapeLeft))
            .previewInterfaceOrientation(.landscapeLeft)
    }
}




