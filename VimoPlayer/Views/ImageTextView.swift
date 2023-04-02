//
//  RetryView.swift
//  VimoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import UIKit

@IBDesignable
class ImageTextView:UIControl{
    
    
    private(set) weak var imageView:UIImageView!
    private(set) weak var textLabel:UILabel!
    private var imageSizeConstraint:NSLayoutConstraint!
    private var paddingConstraint:NSLayoutConstraint!
    
    
    @IBInspectable
    var imageSize:CGFloat = 20 {
        didSet{
            imageSizeConstraint.constant = imageSize
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var padding:CGFloat = 4 {
        didSet{
            paddingConstraint.constant = padding
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var fontSize:CGFloat = 16 {
        didSet{
            textLabel.font = .boldSystemFont(ofSize: fontSize)
            layoutIfNeeded()
        }
    }
    
    @IBInspectable
    var text:String?{
        didSet{
            textLabel.text = text
            layoutIfNeeded()
        }
    }

    
    public override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
        setupConstraint()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraint()
    }
    
    override func prepareForInterfaceBuilder() {
          super.prepareForInterfaceBuilder()
        setupForInterfaceBuilder()
    }
    
    
    func config(text:String,image:UIImage? = nil){
        textLabel.text = text
        imageView.image = image
    }
    
    private func setupForInterfaceBuilder(){
        textLabel.text = text
        textLabel.font = .boldSystemFont(ofSize: fontSize)
        imageSizeConstraint.constant = imageSize
        imageView.image = ImageResource.image(for: .error_icon)
    }
    
   private func setupView(){
        backgroundColor = .clear
        
        let textLabel =  UILabel()
        textLabel.textAlignment = .center
        textLabel.textColor = .darkGray
        textLabel.font = .boldSystemFont(ofSize: fontSize)
        textLabel.numberOfLines = 0
        self.textLabel = textLabel
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        self.imageView = imageView
        
        addSubview(textLabel)
        addSubview(imageView)
    }
    
   private func setupConstraint(){
        imageSizeConstraint = imageView.heightAnchor.constraint(equalToConstant:imageSize)
        paddingConstraint = textLabel.topAnchor.constraint(equalTo:imageView.bottomAnchor,constant:padding)
       
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageSizeConstraint,
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor),
            imageView.topAnchor.constraint(equalTo: topAnchor,constant: 0),
            
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 0),
            paddingConstraint,
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor,constant: 0),
            textLabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: 0),
         ])
    }
    
   
}
