//
//  ListVC.swift
//  VimeoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import UIKit
import RxSwift

class ListViewController:UIViewController{
    
    var viewModel: ListViewModeProtocol!
    
    @IBOutlet weak var searchBar:UISearchBar!
    @IBOutlet weak var indicator:UIActivityIndicatorView!
    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var ImageTextView:ImageTextView!
  
    private var disposeBag = DisposeBag()
    private var lastSearchRequest:SearchRequest? = nil
    
    override func viewDidLoad() {
        setUpCollectionView()
        bindViews()
        showInitialView()
    }
    
    private func bindViews(){
       
        searchBar.rx.searchButtonClicked.bind{[weak self] in
            self?.searchBar.endEditing(true)
            self?.requestForNewSearch()
        }.disposed(by: disposeBag)
        
        viewModel.dataRelay.bind(
            to: collectionView.rx.items(
                cellIdentifier: String(describing:ListCell.self),
                cellType: ListCell.self)
        ) { row, model, cell in
            cell.config(model)
        }.disposed(by: disposeBag)
        
        collectionView.rx.modelSelected(VimeoResponse.Data.self).subscribe(onNext: {
            [weak self] item in
            self?.viewModel?.selectItem(with: item)
        }).disposed(by: disposeBag)
        
        collectionView.rx.willDisplayCell.subscribe(onNext: {[weak self] (cell, indexPath) in
            self?.requestLoadMoreIfNeeded(index: indexPath.item)
        }).disposed(by: disposeBag)
        
        
        viewModel.statusRelay.subscribe(onNext: {[weak self] status in
            self?.loadStatusChange(status)
        }).disposed(by: disposeBag)
        
        
        ImageTextView.rx.controlEvent([.touchUpInside]).subscribe(onNext:{[weak self] in
            guard let request = self?.lastSearchRequest else {return}
            self?.viewModel.search(for:request)
        }).disposed(by: disposeBag)
    }
    
    private func setUpCollectionView() {
        collectionView?.register(UINib(nibName: String(describing: ListCell.self), bundle: .main), forCellWithReuseIdentifier: String(describing:ListCell.self))
        collectionView.collectionViewLayout = createLayout()
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                              heightDimension: .fractionalHeight(1))
        

        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = .init(top: 8, leading: 16, bottom:8, trailing: 16)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1),
                                               heightDimension: .estimated(150))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        return UICollectionViewCompositionalLayout(section: section)
    }

    func requestForNewSearch(){
        guard let query = searchBar.text else{return}
        let request = SearchRequest(query: query)
        lastSearchRequest = request
        viewModel.search(for: request)
    }
    
    func requestLoadMoreIfNeeded(index:Int){
        guard let lastRequest = lastSearchRequest else {return}
        if (index+1 == (lastRequest.page*lastRequest.per_page)){
            let moreRequest = SearchRequest(query: lastRequest.query,page:lastRequest.page+1)
            lastSearchRequest = moreRequest
            viewModel.search(for: moreRequest)
        }
    }
    
    func loadStatusChange(_ status:LoadStatus){
        switch status{
        case .fetched:
            hideActivityIndicatorView()
        case .loading:
            hideImageTextView()
            showActivityIndicatorViewIfNeed()
            
        case .error(let error):
            hideActivityIndicatorView()
            showImageTextView(error:error)
        }
    }
  
}

extension ListViewController: UISearchBarDelegate {}


extension ListViewController{
    
   func showActivityIndicatorViewIfNeed(){
       guard lastSearchRequest?.page ?? 1 == 1 else{
           return
       }
       indicator.startAnimating()
    }
    func hideActivityIndicatorView(){
        indicator.stopAnimating()
    }
}

extension ListViewController{
    
    private func showInitialView(){
        showImageTextView(message:StringResource.get(.init_massage),image:ImageResources.image(for: .magnifying_glass))
    }
    
    private func showImageTextView(message:String,image:UIImage?){
        ImageTextView.isHidden = false
        ImageTextView.config(text: message,image: image)
    }
    
    private func showImageTextView(error:Error){
        let image = ImageResources.image(for: .error_icon,color: .red)
        var message = StringResource.getMessage(for:error)
        message.append("\n")
        message.append(StringResource.get(.press_to_retry))
        showImageTextView(message:message,image:image)
    }
    
    private func hideImageTextView(){
        ImageTextView.isHidden = true
    }
}
