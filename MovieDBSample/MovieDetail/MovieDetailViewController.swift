//
//  MovieDetailViewController.swift
//  MovieDBSample
//
//  Created by Onur Şimşek on 25.05.2022.
//

import UIKit
import SDWebImage
import SafariServices

class MovieDetailViewController: UIViewController {
    private var viewModel : MovieDetailScreenViewModel?
    var movieId : Int?
    var movieTitle : String?
    
    @IBOutlet weak var topBar: TopNavBar!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var imdbLogoImageView: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var seperatorDotView: UIView!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var mainViewHeight: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var mainView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initViewModel()
        initTopBar()
        setStyle()
        addImdbTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getData()
        setScrollView()
    }
    
    private func initViewModel(){
        viewModel = MovieDetailScreenViewModel(delegate: self)
    }
    
    private func initTopBar(){
        topBar.setTitle(title: movieTitle ?? "-")
        topBar.goBackAction = {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    private func setStyle(){
        seperatorDotView.layer.cornerRadius = 2
        seperatorDotView.backgroundColor = UIColor.init(hexString: "E6B91E")
        
    }
    
    private func setScrollView(){
        scrollView.isScrollEnabled = false
    }
    
    private func setHeight(){
        overviewLabel.layoutIfNeeded()
        if overviewLabel.frame.height + 309 > UIScreen.main.bounds.height {
            let heightDifference = overviewLabel.frame.height + 500 - UIScreen.main.bounds.height
            mainViewHeight.constant += heightDifference
            scrollView.isScrollEnabled = true
        } else {
            scrollView.isScrollEnabled = false
        }
    }

    private func getData(){
        if let id = movieId {
            LoadingView.shared.startLoadingView(vc: self)
            viewModel?.getData(movieId: id)
        } else {
            self.showAlert(erroType: .defaultError)
        }
    }
    
    private func createAttributedText(text: String)->NSMutableAttributedString{
        let attributedString = NSMutableAttributedString(string: text, attributes: [
          .font: UIFont(name: "SFProText-Medium", size: 13.0)!,
          .foregroundColor: UIColor.init(hexString: "2B2D42")
        ])
        
        let range = attributedString.mutableString.range(of: "/10")
        attributedString.addAttribute(.foregroundColor, value: UIColor.init(hexString: "ADB5BD"), range: range)
        
        return attributedString
    }
    
    private func addImdbTarget(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(imdbButtonPressed(_:)))
        self.imdbLogoImageView.addGestureRecognizer(gesture)
        self.imdbLogoImageView.isUserInteractionEnabled = true
    }
    
    @objc func imdbButtonPressed(_ sender: UITapGestureRecognizer){
        if let imdbId = viewModel?.getImdbId() {
            let urlString = "https://www.imdb.com/title/" + imdbId
            guard let url = URL(string: urlString)
            else {
                self.showAlert(erroType: .defaultError)
                return
            }
            let vc = SFSafariViewController(url: url)
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
        }
        else {
            self.showAlert(erroType: .defaultError)
        }
    }
    
}

//MARK: - Screen Delegate
extension MovieDetailViewController: MovieDetailProtocol {
    func dataReached(data: MovieDetailModel) {
        print(rateLabel.font)
        LoadingView.shared.stopLoadingView()
        overviewLabel.text = data.getOverview()
        releaseDateLabel.text = data.getReleaseDate()
        rateLabel.attributedText =  createAttributedText(text: data.getVoteAverage())
        posterImageView.sd_setImage(with: data.getPosterPath(), completed: nil)
        setHeight()
    }
    
    func errorFound(error: serviceErrors) {
        LoadingView.shared.stopLoadingView()
        if error == .internetError {
            showAlert(erroType: error) { [unowned self] action in
                self.getData()
            }
        } else {
            showAlert(erroType: error)
        }
    }
}
