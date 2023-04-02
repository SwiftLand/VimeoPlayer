//
//  ImageLoaderProxy.swift
//  VimoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import Nuke
import RxNuke
import RxSwift

class ImageLoaderProxy{
 
   static func load(url:URL)->Observable<UIImage>{
       return ImagePipeline.shared.rx.loadImage(with: url).map{$0.image as UIImage}.asObservable()
    }
}
