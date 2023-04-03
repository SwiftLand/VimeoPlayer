//
//  RetryView.swift
//  VimeoPlayer
//
//  Created by Ali on 2/14/23.
//

import Foundation
import UIKit

@IBDesignable
class ImageTextView:UIControl{
    
    
    private(set) weak var stackView:UIStackView!
    private(set) weak var imageView:UIImageView!
    private(set) weak var textLabel:UILabel!
    private var imageSizeConstraint:NSLayoutConstraint!
    
    @IBInspectable
    var imageSize:CGFloat = 20 {
        didSet{
            updateImageSize(imageSize)
        }
    }
    
    @IBInspectable
    var padding:CGFloat = 4 {
        didSet{
            updatePadding( padding)
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
        
        
        let stackView = UIStackView()
        self.stackView = stackView
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = padding
        stackView.addArrangedSubview(imageView)
        stackView.addArrangedSubview(textLabel)
        
        
        addSubview(stackView)
    }
    
    private func setupConstraint(){
        stackView.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageSizeConstraint = imageView.heightAnchor.constraint(equalToConstant:imageSize)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.topAnchor.constraint(equalTo: topAnchor),
            imageSizeConstraint,
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
    
    private func updateImageSize (_ size:CGFloat){
        imageSizeConstraint.constant = imageSize
        layoutIfNeeded()
    }
    private func updatePadding(_ padding:CGFloat){
        stackView.spacing = padding
        layoutIfNeeded()
    }
}
