//
//  BaseViewController.swift
//  GameOfThronesArticlesApp
//
//  Created by Karolczyk, Maciej on 08/08/2020.
//  Copyright © 2020 Karolczyk, Maciej. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController: UIViewController {
    
    var networkLayer : NetworkLayer
    let loading: UIActivityIndicatorView = {
        let loading = UIActivityIndicatorView()
        loading.translatesAutoresizingMaskIntoConstraints = false
        loading.hidesWhenStopped = true
        return loading
    }()
    
    init(networkLayer: NetworkLayer = NetworkLayer()) {
        self.networkLayer = networkLayer
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupLayout()
        changeLoading(true)
    }
    
    func setupLayout() {
        self.view.backgroundColor = .systemBackground
        view.addSubview(loading)
        loading.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        loading.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func changeLoading(_ shouldShow:Bool) {
        DispatchQueue.main.async {
            shouldShow ? self.loading.startAnimating() : self.loading.stopAnimating()
        }
    }
    
    func displayFavoriteToast(isCurrentlyFavorite:Bool) {
        Toast.show(message: isCurrentlyFavorite ? Strings.articleSetAsNotFavorite : Strings.articleSetAsFavorite, controller: self)
    }
}
