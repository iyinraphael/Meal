//
//  MainViewController.swift
//  Meal
//
//  Created by Iyin Raphael on 6/21/23.
//

import UIKit
import Combine

class MainViewController: UIViewController {
    
    private var mainViewModel: MainViewModel?
    private var apiEnvironment =  APIEnvironment()
    
    private var subscription: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        let apiService = MealAPIService(environmentAPI: apiEnvironment)
        mainViewModel = MainViewModel(apiService: apiService)
        
        setUpBinding()
    }
    
    
    func setUpBinding() {
        mainViewModel?.desertMealCategoryPublisher
            .sink(receiveCompletion: { completion in
                print("done")
            }, receiveValue: { meals in
                print(meals)
            }).store(in: &subscription)
        
        mainViewModel?.mealWithRecipe
            .sink(receiveCompletion: { completion in
                print("done")
            }, receiveValue: { meals in
                print(meals)
            }).store(in: &subscription)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
