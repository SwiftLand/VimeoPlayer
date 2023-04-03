//
//  ListView.swift
//  VimeoPlayer
//
//  Created by Ali on 3/8/23.
//

import SwiftUI

struct ListView: View {
    
    @State var searchText:String = ""
    @State var showList:Bool = false
    @StateObject var viewModel:ListViewModel
    @EnvironmentObject var store: Store
    
    var body: some View {
        ZStack{
            
            List(viewModel.data) { item in
                ListCellView(data: item)
                    .frame(maxWidth:.infinity)
                    .frame(height:store.orientation.isLandscape ? 150 : 100)
                    .onTapGesture {
                        self.viewModel.selectItem(with: item)
                    }
            }.listStyle(PlainListStyle())
          
            switch viewModel.status{
                
            case .loading:
                ProgressView(){
                    Text(StringResource.get(.loading))
                }.scaleEffect(1.5, anchor: .center)
                
            case .fetched:
                EmptyView()
                
            case .error(let error):
                VStack{
                    Image(systemName:ImageResource.getName(for: .error_icon))
                        .resizable()
                        .foregroundColor(.red)
                        .frame(width:40,height: 40)
                    Text(StringResource.getMessage(for: error))
                }
                
            default:
                VStack(spacing:16){
                    Image(uiImage: ImageResource.getImage(for: .magnifying_glass)).resizable()
                        .frame(width:40,height: 40)
                    Text(StringResource.get(.search_something))
                }
            }
            
        }.searchable(text: $searchText,prompt: StringResource.get(.search_something))
            .onSubmit(of: .search, {viewModel.search(for:SearchRequest(query: searchText))})
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(viewModel: ListViewModel())
    }
}

