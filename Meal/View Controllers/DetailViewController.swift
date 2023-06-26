//
//  DetailViewController.swift
//  Meal
//
//  Created by Iyin Raphael on 6/22/23.
//

import UIKit
import Combine

class DetailViewController: UIViewController {

    // MARK: - Properties
    private let titleIngredient = NSLocalizedString(" Ingredients", comment: "Ingredient Label title")
    private let titleInstruction = NSLocalizedString(" Instructions", comment: "Instruction label title")
    private var subscription: Set<AnyCancellable> = []

    
    // MARK: - Outlets
    var instructionsTextView: UITextView?
    var ingredientsTextView: UITextView?
    var mealImageView: UIImageView?
    let scrollView = UIScrollView()
    let contentView = UIView()

    
    var detailViewModel: DetailViewModel?
    
    // MARK: - View cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViewLayout()
        updateViews()
    }

    // MARK: - Internal Methods
    private func setUpViewLayout() {
        navigationController?.navigationBar.tintColor = .systemGray
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor : UIColor.systemGray
        ]
        view.backgroundColor = .systemBackground
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
        stackview.axis =  .vertical
        stackview.distribution = .fill
        stackview.alignment = .fill
        stackview.spacing = UIStackView.spacingUseSystem
        contentView.addSubview(stackview)
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 12
        stackview.addArrangedSubview(imageView)
        self.mealImageView = imageView
        
        let instructionLabel = UILabel()
        instructionLabel.text = titleInstruction
        instructionLabel.textColor = .red
        instructionLabel.font = .boldSystemFont(ofSize: 16)
        stackview.addArrangedSubview(instructionLabel)
        
        let instructionsTextView = UITextView()
        instructionsTextView.isEditable = false
        instructionsTextView.isScrollEnabled = false
        instructionsTextView.sizeToFit()
        instructionsTextView.textColor = .systemGray
        instructionsTextView.font = .systemFont(ofSize: 12)
        stackview.addArrangedSubview(instructionsTextView)
        self.instructionsTextView = instructionsTextView

        let ingredientLabel = UILabel()
        ingredientLabel.text = titleIngredient
        ingredientLabel.textColor = .red
        ingredientLabel.font = .boldSystemFont(ofSize: 16)
        stackview.addArrangedSubview(ingredientLabel)

        let ingredientsTextView = UITextView()
        ingredientsTextView.isEditable = false
        ingredientsTextView.isScrollEnabled = false
        ingredientsTextView.sizeToFit()
        ingredientsTextView.isUserInteractionEnabled = false
        ingredientsTextView.font = .systemFont(ofSize: 12)
        ingredientsTextView.textColor = .systemGray
        stackview.addArrangedSubview(ingredientsTextView)
        self.ingredientsTextView = ingredientsTextView
                        
        NSLayoutConstraint.activate([
            scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            scrollView.widthAnchor.constraint(equalTo: view.widthAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            
            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.9),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            
            stackview.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackview.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stackview.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            stackview.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            imageView.heightAnchor.constraint(equalTo: scrollView.heightAnchor, multiplier: 0.4),
        ])

    }
    
    private func updateViews() {
        if let detailViewModel {
            detailViewModel.mealDetails
                .sink { _ in
                } receiveValue: { [weak self] mealDetals in
                    let meal = mealDetals[0]
                    guard let mealName = meal["strMeal"],
                    let mealInstructions = meal["strInstructions"],
                    let mealImage = meal["strMealThumb"] else { return }
                    let ingrindients = detailViewModel.cleanIngredients(from: meal)
                    
                    DispatchQueue.main.async {
                        self?.title = mealName
                        self?.mealImageView?.loadImage(from: mealImage!)
                        self?.instructionsTextView?.text = mealInstructions
                        self?.ingredientsTextView?.text = ingrindients
                    }
                }.store(in: &subscription)

        }
    }
    

}
