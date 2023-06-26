//
//  MainViewController.swift
//  Meal
//
//  Created by Iyin Raphael on 6/21/23.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    // MARK: - Private Properties
    private var mainViewModel: MainViewModel?
    private let apiEnvironment =  APIEnvironment()
    private var apiService: APIService?
    private var dataSource: UICollectionViewDiffableDataSource<MainViewModel.CategoryType, Meal>?
    private var meals = [Meal]()
    
    private var selectedSegmentIndex = 2
    private let viewTitle = NSLocalizedString("Meals", comment: "View title")
    private var subscription: Set<AnyCancellable> = []

    
    // MARK: - Outlets
    var segmentControl: UISegmentedControl?
    var collectionView: UICollectionView?
    

    // MARK: - View Controller Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = viewTitle
        navigationController?.navigationBar.prefersLargeTitles = true
    
        let apiService = MealAPIService(environmentAPI: apiEnvironment)
        self.apiService = apiService
        mainViewModel = MainViewModel(apiService: apiService)
        
        setUpViews()
        configureDataSource()
        setUpBinding()
    }
    
    // MARK: - Private Methods
    private func setUpViews() {
        let control = UISegmentedControl(items: MainViewModel.CategoryType.allValues())
        control.translatesAutoresizingMaskIntoConstraints = false
        control.selectedSegmentIndex = selectedSegmentIndex
        control.addTarget(self, action: #selector(setUpBinding), for: .valueChanged)
        segmentControl = control
    
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: makeCollectionView())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        self.collectionView = collectionView
        
        view.addSubview(control)
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            control.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            control.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            control.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            collectionView.topAnchor.constraint(equalTo: control.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func makeCollectionView() -> UICollectionViewLayout {
        return UICollectionViewCompositionalLayout { (_, _) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/2), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 8, bottom: 12, trailing: 8)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1/3))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

            let section = NSCollectionLayoutSection(group: group)
            return section
        }
    }
    
    private func configureDataSource() {
        guard let collectionView else { return }
        
        let mealCellRegistration = UICollectionView.CellRegistration<MainCell, Meal>{ cell, indexPath, meal in
            cell.updateView(with: meal)
        }
        
        dataSource = UICollectionViewDiffableDataSource<MainViewModel.CategoryType, Meal>(collectionView: collectionView) {(collectionView, indexPath, item) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: mealCellRegistration, for: indexPath, item: item)
        }
    }
    
    /**
        Set up diffable data source snapshot to update collection view
     -   A publisher is updated whenever a segment index is selected
     */
    @objc private func setUpBinding() {
        var snapshot = NSDiffableDataSourceSnapshot<MainViewModel.CategoryType, Meal>()
        
        selectedSegmentIndex = segmentControl?.selectedSegmentIndex ?? 2
        
        switch selectedSegmentIndex {
        case 0:
            mainViewModel?.starterMealCategoryPublisher
                .sink(receiveCompletion: { _ in
                }, receiveValue: { [weak self] meals in
                    snapshot.appendSections([.starter])
                    snapshot.appendItems(meals)
                    self?.meals = meals
                    self?.dataSource?.apply(snapshot)
                }).store(in: &subscription)
        case 1:
            mainViewModel?.pasterMealCategoryPublisher
                .sink(receiveCompletion: { _ in
                }, receiveValue: { [weak self] meals in
                    snapshot.appendSections([.pasta])
                    snapshot.appendItems(meals)
                    self?.meals = meals
                    self?.dataSource?.apply(snapshot)
                }).store(in: &subscription)
        case 2:
            mainViewModel?.desertMealCategoryPublisher
                .sink(receiveCompletion: { _ in
                }, receiveValue: { [weak self] meals in
                    snapshot.appendSections([.dessert])
                    snapshot.appendItems(meals)
                    self?.meals = meals
                    self?.dataSource?.apply(snapshot)
                }).store(in: &subscription)
        default:
            print("default")
        }
    }
}

// MARK: - Collection Delegate
extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let meal = meals[indexPath.row]
        
        let detailVC = DetailViewController()
        
        let viewModel = DetailViewModel(apiService: apiService!, mealID: meal.idMeal)
        detailVC.detailViewModel = viewModel
        detailVC.modalPresentationStyle = .fullScreen
        
        navigationController?.pushViewController(detailVC, animated: false)
    }
}
