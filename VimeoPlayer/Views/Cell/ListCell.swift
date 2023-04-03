//
//  ListCell.swift
//  VimeoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import UIKit
import RxSwift

class ListCell:UICollectionViewCell{
    
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var durationLabel:UILabel!
    @IBOutlet weak var durationLabelParent:UIView!
    @IBOutlet weak var thumbnailImageView:UIImageView!
    @IBOutlet weak var uploaderImageView:UIImageView!
    @IBOutlet weak var uploaderNameLabel:UILabel!
    
    private var disposeBag = DisposeBag()
    
    
    func config(_ data:VimeoResponse.Data){
        titleLabel.text = data.name
        descriptionLabel.text = data.description
        durationLabel.text = Formatter.formateDuration(seacond: data.duration ?? 0)
        
        uploaderNameLabel.text = data.user?.name
        
        disposeBag = DisposeBag()
        
        
        displayImage(data.pictures?.getSize(for: thumbnailImageView.frame.size), for: thumbnailImageView)
        displayImage(data.uploader?.pictures?.getSize(for: thumbnailImageView.frame.size), for: uploaderImageView)
    }
    
    func displayImage(_ size:VimeoResponse.Size?,for imageView:UIImageView) {
        guard let link = size?.link,let url = URL(string: link) else{
            return
        }
        imageView.image = nil
        ImageLoaderProxy.load(url: url).bind(to: imageView.rx.image).disposed(by: disposeBag)
    }
}
