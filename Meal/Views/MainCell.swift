//
//  MainCell.swift
//  Meal
//
//  Created by Iyin Raphael on 6/22/23.
//

import UIKit

class MainCell: UICollectionViewCell {
    
    private let imageCache = NSCache<NSString, AnyObject>()
    static let reuseId = "Cell"
    
    // MARK:- Outlets
    var nameLabel: UILabel!
    var mealImageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpViews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mealImageView.image = nil
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.backgroundColor = UIColor.white.cgColor
        layer.contentsGravity = .center
        layer.magnificationFilter = .linear
        layer.cornerRadius = 8
        layer.borderWidth = 0.1
        layer.borderColor = UIColor.white.cgColor
        layer.shadowOpacity = 0.4
        layer.shadowOffset = CGSize(width: 0, height: 3)
        layer.shadowRadius = 3.0
        layer.isGeometryFlipped = false
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- Internal methods
    private func setUpViews() {
        let spacing: CGFloat = 5
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = UIStackView.spacingUseSystem
        addSubview(stackView)
        
        mealImageView = UIImageView()
        mealImageView.contentMode = .scaleAspectFill
        mealImageView.clipsToBounds = true
        mealImageView.layer.cornerRadius = 5
        stackView.addArrangedSubview(mealImageView)
        
        nameLabel = UILabel()
        nameLabel.font = .systemFont(ofSize: 10)
        nameLabel.textColor = .systemGray
        nameLabel.numberOfLines = 0
        stackView.addArrangedSubview(nameLabel)
        NSLayoutConstraint.activate(
            [
                stackView.topAnchor.constraint(equalTo: topAnchor, constant: spacing),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: spacing),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -spacing),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
                mealImageView.topAnchor.constraint(equalTo: stackView.topAnchor),
                mealImageView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.8),
                mealImageView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
            ]
        )
    }
    
    func updateView(with meal: Meal) {
            nameLabel.text = meal.strMeal
            downloadImageFrom(imageStr: meal.strMealThumb)
    }
    
    private func downloadImageFrom(imageStr: String) {
        if let cachedImage = imageCache.object(
            forKey: imageStr as NSString) as?  UIImage {
            self.mealImageView.image = cachedImage
            
        }else {
            guard let imageURL = URL(string: imageStr) else { fatalError()}
            let imageTo = UIImage(contentsOfFile: imageStr)
            
            URLSession.shared.dataTask(with: imageURL) { data, _, _ in
                guard let data = data, let imageToCache = UIImage(data: data)
                else { fatalError("could not retrieve image")}
                
                self.imageCache.setObject(imageToCache, forKey: imageStr as NSString)
                
                DispatchQueue.main.async { [weak self] in
                    self?.mealImageView.image = imageToCache
                }
            }.resume()
        }
    }
}
