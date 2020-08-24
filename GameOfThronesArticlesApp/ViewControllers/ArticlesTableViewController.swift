//
//  ViewController.swift
//  GameOfThronesArticlesApp
//
//  Created by Karolczyk, Maciej on 06/08/2020.
//  Copyright © 2020 Karolczyk, Maciej. All rights reserved.
//

import UIKit

class ArticlesTableViewController: BaseViewController {
    
    var visibleRows:[IndexPath]?
    var isFavoriteFiltered: Bool = false
    var expandedIndexSet: IndexSet = []
    var articlesBackup:[Article]?
    var articles:[Article]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    let tableView: UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.separatorStyle = .none
        table.register(ArticleTableViewCell.self, forCellReuseIdentifier: "cell")
        table.rowHeight = UITableView.automaticDimension
        table.estimatedRowHeight = 200
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Navbar
        self.title = Strings.ArticlesTableViewControllerTitle
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "favorite_empty"), style: .plain, target: self, action: #selector(onFilterFavorites))
        
        // Request Articles
        networkLayer.getData(urlString: Constants.topArticlesEndpoint, parameters: Constants.getTopArticlesParameters(), successHandler: { (response:ArticlesResponseModel) in
            let articles = response.articles
            self.articles = articles
            self.changeLoading(false)
        }) { errorString in
            self.changeLoading(false)
            print(errorString)
        }
        
//        ServiceManager.sharedInstance.requestTopArticles(completion: { articles in
//            self.articles = articles
//            self.changeLoading(false)
//        }, errorBlock: { errorString in
//            self.changeLoading(false)
//            print(errorString)
//        })
    }
    
    override func setupLayout() {
        super.setupLayout()
    
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        view.bringSubviewToFront(loading)
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.cancelsTouchesInView = false
        tableView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func onFilterFavorites() {
        isFavoriteFiltered = !isFavoriteFiltered
        expandedIndexSet.removeAll()
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: isFavoriteFiltered ? #imageLiteral(resourceName: "favorite_filled") : #imageLiteral(resourceName: "favorite_empty"), style: .plain, target: self, action: #selector(onFilterFavorites))
        if (isFavoriteFiltered) {
            articlesBackup = articles
            articles = articles!.filter {$0.isFavorite == true}
        } else {
            articles = articlesBackup
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { context in
                self.visibleRows = self.tableView.indexPathsForVisibleRows
                context.viewController(forKey: UITransitionContextViewControllerKey.from)
            }, completion: { context in
                let offset = self.tableView.contentOffset.y;
                guard let visibleRows = self.visibleRows, visibleRows.count > 0 else {return}
                self.tableView.scrollToRow(at: offset <= 0 ? visibleRows[0] : visibleRows[1], at: .top, animated: false)
            })
    }
    
    @objc func handleLongPress(longPressGesture: UILongPressGestureRecognizer) {
        let touchPoint = longPressGesture.location(in: self.tableView)
        let indexPath = self.tableView.indexPathForRow(at: touchPoint)
        if let indexPath = indexPath {
            if longPressGesture.state == UIGestureRecognizer.State.began {
                if(expandedIndexSet.contains(indexPath.row)){
                    expandedIndexSet.remove(indexPath.row)
                } else {
                    expandedIndexSet.insert(indexPath.row)
                }
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
        }
    }
}

extension ArticlesTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if articles?.count == 0 {
            setNoFavoritesView()
        } else {
            tableView.restoreNormalView()
        }
        return articles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ArticleTableViewCell
        cell.delegate = self
        cell.selectionStyle = .none
        cell.articleModel = articles?[indexPath.row]
        cell.changeAbstractLength(shouldExpand: expandedIndexSet.contains(indexPath.row))
        return cell
    }
    
    func changeFavoriteStatus(articleId:Int, isCurrentlyFavorite:Bool, completion: () -> Void) {
        if let index = articles?.firstIndex(where: { $0.id == articleId }) {
            articles?[index].isFavorite = !isCurrentlyFavorite
            if let backupIndex = articlesBackup?.firstIndex(where: { $0.id == articleId }) {
                articlesBackup?[backupIndex].isFavorite = !isCurrentlyFavorite
                completion()
            } else {
                completion()
            }
        }
    }
    
    func setNoFavoritesView() {
        tableView.setEmptyView(title: Strings.noFavArticles, message: Strings.noFavArticlesDescription)
    }
}

extension ArticlesTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let articleModel = articles?[indexPath.row] else {return}
        let controller = ArticleDetailViewController()
        controller.delegate = self
        controller.isFavorite = articleModel.isFavorite
        controller.articleId = articleModel.id
        self.navigationController?.pushViewController(controller, animated: false)
    }
    
}

extension ArticlesTableViewController: ArticleTableViewCellDelegate {
    func didPressFavoriteButton(cell: ArticleTableViewCell) {
        guard let articleId = cell.articleModel?.id, let isCurrentlyFavorite = cell.articleModel?.isFavorite else {return}
        changeFavoriteStatus(articleId: articleId, isCurrentlyFavorite: isCurrentlyFavorite) {
            if isFavoriteFiltered {
                articles = articles!.filter {$0.isFavorite == true}
            }
            self.displayFavoriteToast(isCurrentlyFavorite: isCurrentlyFavorite)
        }
    }
}

extension ArticlesTableViewController: ArticleDetailDelegate {
    func didPressFavoriteButton(detailsController:ArticleDetailViewController) {
        guard let articleDetails = detailsController.detailsModel else {return}
        let isCurrentlyFavorite = detailsController.isFavorite
        
        changeFavoriteStatus(articleId: articleDetails.id, isCurrentlyFavorite: isCurrentlyFavorite) {
            detailsController.isFavorite = !isCurrentlyFavorite
            detailsController.displayFavoriteToast(isCurrentlyFavorite: isCurrentlyFavorite)
        }
    }
}

