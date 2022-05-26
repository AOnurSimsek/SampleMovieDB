//
//  MainScreenViewController.swift
//  MovieDBSample
//
//  Created by Onur Şimşek on 25.05.2022.
//

import UIKit

final class MainScreenViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    
    private let viewModel = MainScreenViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        setTableView()
        setCollectionView()
        setStyle()
        setRefreshControl()
        setScrollView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
    }
    
    private func setViewModel(){
        viewModel.setDelegate(delegate: self)
    }
    
    private func setRefreshControl(){
        scrollView.refreshControl = UIRefreshControl()
        scrollView.refreshControl?.bounds.origin.y = -50
        scrollView.refreshControl?.insetsLayoutMarginsFromSafeArea = true
        scrollView.refreshControl?.addTarget(self, action: #selector(getData), for: .valueChanged)
    }

    private func setScrollView(){
        scrollView.delegate = self
    }
    
    private func setStyle(){
        pageControl.isUserInteractionEnabled = false
        
        scrollView.contentInsetAdjustmentBehavior = .never
        tableView.contentInsetAdjustmentBehavior = .never
        
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func getNextPage(){
        LoadingView.shared.startLoadingView(vc: self)
        viewModel.getNextPage()
    }
    
    @objc private func getData(){
        LoadingView.shared.startLoadingView(vc: self)
        viewModel.getData()
        scrollView.refreshControl?.endRefreshing()
    }
}

//MARK: - TableView
extension MainScreenViewController : UITableViewDelegate, UITableViewDataSource {
    private func setTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: MovieTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: MovieTableViewCell.identifier)
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.bounces = false
        tableView.isScrollEnabled = false
    }
    
    private func setScrollViewHeight(){
        let cellCount = viewModel.getUpcomingMoviesCount()
        if cellCount != 0 {
            let height : CGFloat = CGFloat((cellCount * 136) + 256)
            mainViewHeight.constant = height
            mainView.layoutIfNeeded()
            scrollView.layoutIfNeeded()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getUpcomingMoviesCount()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 136
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MovieTableViewCell.identifier, for: indexPath) as! MovieTableViewCell
        
        if let model = viewModel.getUpcomingMovie(indexPathRow: indexPath.row) {
            cell.setCell(imgPath: model.getPosterPath(),
                         title: model.getTitle(),
                         releaseDate: model.getReleaseDate(),
                         overView: model.getOverView(),
                         year: model.getYear())
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = viewModel.getUpcomingMovie(indexPathRow: indexPath.row) {
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
            detailVC.movieId = model.getId()
            detailVC.movieTitle = model.getTitle() + " " + model.getYear()
            self.navigationController?.pushViewController(detailVC, animated: true)
        } else {
            showAlert(erroType: .defaultError)
        }
    }
}

//MARK: - CollectionView
extension MainScreenViewController : UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
        
    private func setCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(UINib(nibName: MovieCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier: MovieCollectionViewCell.identifier)
        collectionView.bounces = false
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 256)
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, minimumLineSpacingForSectionAt _: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNowPlayingMoviesCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell
            .identifier, for: indexPath) as! MovieCollectionViewCell
        
        if let model = viewModel.getNowPlayingMovie(indexPathRow: indexPath.row) {
            cell.setCell(imagePath: model.getPosterPath(),
                         title: model.getTitle(),
                         overView: model.getOverView(),
                         year: model.getYear())
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let model = viewModel.getNowPlayingMovie(indexPathRow: indexPath.row) {
            let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MovieDetailViewController") as! MovieDetailViewController
            detailVC.movieId = model.getId()
            detailVC.movieTitle = model.getTitle() + " " + model.getYear()
            self.navigationController?.pushViewController(detailVC, animated: true)
        } else {
            showAlert(erroType: .defaultError)
        }
    }
}

//MARK: - ScrollView Delegates
extension MainScreenViewController: UIScrollViewDelegate {
    //For creating a slider effect on collectionView
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let _ = scrollView as? UICollectionView {
            collectionView.scrollToNearestVisibleCollectionViewCell()
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if let _ = scrollView as? UICollectionView, !decelerate {
            collectionView.scrollToNearestVisibleCollectionViewCell()
        }
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)
     {
         //For pageControl
         if let _ = scrollView as? UICollectionView {
             let pageWidth = scrollView.frame.width
             self.pageControl.currentPage = Int((scrollView.contentOffset.x + pageWidth / 2) / pageWidth)
         }
         
         //For pagination
         let maximumVerticalOffset : CGFloat = tableView.contentSize.height - scrollView.frame.size.height
         let currentOffset : CGPoint = scrollView.contentOffset
         let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
         
         if currentVerticalOffset > maximumVerticalOffset {
            getNextPage()
             scrollView.setContentOffset(currentOffset, animated: false)
         }
     }
}

//MARK: - Data Delegates
extension MainScreenViewController: MainScreenDelegate {
    func dataReached() {
        LoadingView.shared.stopLoadingView()
        tableView.reloadData()
        collectionView.reloadData()
        setScrollViewHeight()
    }
    
    func errorOccured(error: serviceErrors) {
        LoadingView.shared.stopLoadingView()
        if error == .internetError {
            showAlert(erroType: error) { [unowned self] action in
                self.getData()
            }
        } else {
            showAlert(erroType: error)
        }
    }
    
    func paginationDataReached() {
        LoadingView.shared.stopLoadingView()
        self.tableView.reloadData()
        setScrollViewHeight()
    }
}



