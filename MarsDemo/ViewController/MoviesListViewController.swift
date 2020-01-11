//
//  MoviesListViewController.swift
//  MarsDemo
//
//  Created by Mobikasa on 1/8/20.
//  Copyright © 2020 Mars. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController {
    
    @IBOutlet weak var moviesCollectionView: UICollectionView!
    
    //MARK:- Variable Declairations
    private var viewModel =  MoviesListViewModel()
    var currentPage: Int = 1
    var endPage: Int = 1
    let loading = UIActivityIndicatorView()
    var isNextPage: Bool = false
    var isLastPageReached: Bool = false
    var isLoadMore: Bool = true
    var isNextPageCallInprogress: Bool = false
    //MARK:- Variable Declairations
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.refreshList(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.black
        
        return refreshControl
    }()
    var flowLayout: UICollectionViewFlowLayout {
        let _flowLayout = UICollectionViewFlowLayout()
        _flowLayout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
        _flowLayout.scrollDirection = UICollectionView.ScrollDirection.vertical
        _flowLayout.minimumInteritemSpacing = 10.0
        return _flowLayout
    }
    var expectedWidth: CGFloat {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        if  (windowScene?.interfaceOrientation == .portrait || windowScene?.interfaceOrientation == .portraitUpsideDown) && (windowScene?.activationState == .foregroundActive)  {
            return ((UIScreen.main.bounds.width - 45) / 2)
        }
        return ((UIScreen.main.bounds.width - 90) / 3)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        moviesCollectionView.collectionViewLayout.invalidateLayout()
    }
    //MARK:- Fetchiching ViewModelData, Register cell nib
    private func initialSetup() {
        self.edgesForExtendedLayout = UIRectEdge.bottom
        self.moviesCollectionView.collectionViewLayout = flowLayout
        MovieCollectionViewCell.registerCell(for: moviesCollectionView)
        CollectionFooterView.registerSupplementaryView(for: moviesCollectionView)
        moviesCollectionView.addSubview(refreshControl)
        viewModel.getMoviesResponse(page: currentPage) { [weak self] in
            DispatchQueue.main.async {
                self?.moviesCollectionView.reloadData()
                self?.viewModel.pageData()
            }
        }
        
    }
    //MARK:- Add pagination call
    func loadMore(){
        currentPage = currentPage+1
        viewModel.getMoviesResponse(page: currentPage) { [weak self] in
            DispatchQueue.main.async {
                self?.moviesCollectionView.reloadData()
            }
        }
    }
    
    // Pull to refresh action
    @objc private func refreshList(_ refreshControl: UIRefreshControl) {
        moviesCollectionView.reloadData()
        currentPage = 1
        viewModel.getMoviesResponse(page: currentPage) { [weak self] in
            DispatchQueue.main.async {
                self?.moviesCollectionView.reloadData()
                refreshControl.endRefreshing()
            }
        }
    }
}
//MARK:- CollectionView Delegate and Datasources
extension MoviesListViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCollectionViewCell", for: indexPath) as! MovieCollectionViewCell
        cell.cellData(at: indexPath, with: self.viewModel.dataAtIndexPath(indexPath))
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: expectedWidth, height: expectedWidth * 1.67)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout
        collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForFooterInSection section: Int) -> CGSize {
        
        if self.viewModel.count > 0 && viewModel.lastpagedReached == false
        {
            return CGSize(width:(collectionView.frame.size.width), height: 100.0)
        }
        return CGSize.zero
    }
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if kind == UICollectionView.elementKindSectionFooter {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionFooterView.identifier, for: indexPath)
            loading.style = UIActivityIndicatorView.Style.medium
            loading.translatesAutoresizingMaskIntoConstraints = false
            loading.tintColor = UIColor.gray
            loading.tag = -123456
            view.addSubview(loading)
            view.addConstraint(NSLayoutConstraint(item: loading, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0))
            view.addConstraint(NSLayoutConstraint(item: loading, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0))
            return view
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            
            if let loadingView = view.viewWithTag(-123456) as? UIActivityIndicatorView{
                if self.viewModel.count > 0 && viewModel.lastpagedReached == false
                {
                    loadingView.startAnimating()
                    self.loadMore()
                }
                else
                {
                    loadingView.stopAnimating()
                    loadingView.removeFromSuperview()
                    self.isLoadMore = false
                }
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter{
            
            if let loadingView = view.viewWithTag(-123456) as? UIActivityIndicatorView{
                loadingView.stopAnimating()
                loadingView.removeFromSuperview()
                
                self.isLoadMore = false
            }
            
        }
    }
    
    //MARK:- Other metods of calling pagination
    
    //        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //                if indexPath.row == self.viewModel.count - 1 {  //numberofitem count
    //                    loadMore()
    //
    //                }
    //        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(identifier: "MoviewDetailViewController") as! MoviewDetailViewController
        vc.movieData = self.viewModel.dataAtIndexPath(indexPath)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
