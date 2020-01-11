//
//  MoviewDetailViewController.swift
//  MarsDemo
//
//  Created by Mobikasa on 1/8/20.
//  Copyright © 2020 Mars. All rights reserved.
//

import UIKit

class MoviewDetailViewController: UIViewController {
    
    //MARK:- Outlets of the views Declairations
    @IBOutlet weak var containerView:UIView?
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel?
    @IBOutlet weak var movieTypeLabel: UILabel!
    @IBOutlet weak var releaseYearAgoLabel: UILabel!
     
    //MARK:- Variable Declairations
    var movieData:Search?
    let dateFormat = DateFormatter()
    private var formattedTimeString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addShadowOnContainerView()
        loadDataFromViewModel()
    }
    
    //MARK:- Apply shadows on views
    private func addShadowOnContainerView(){
        self.navigationItem.title = "MovieDetails"
        self.dateFormat.dateFormat = Date.dateFormat
        containerView?.layer.shadowColor = UIColor.black.cgColor
        containerView?.layer.shadowOpacity = 0.33
        containerView?.layer.shadowOffset = .zero
        containerView?.layer.shadowRadius = 10
        containerView?.layer.cornerRadius = 10
    }
    //MARK:- Load data from view model
    private func loadDataFromViewModel(){
        guard let movie = movieData else { return }
            if let strUrl = movie.poster?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
              let imgUrl = URL(string: strUrl)  {
                do {
                    let data = try Data(contentsOf: imgUrl)
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        self.imageView.image = image
                    }
                } catch _ { }
            }
            DispatchQueue.main.async {
                self.movieNameLabel?.text = movie.title
                self.movieTypeLabel.text = movie.type
                if let year = movie.year, let date = self.dateFormat.date(from: year) {
                    self.formattedTimeString = date.yearAgoSinceDate()
                }
                self.releaseYearAgoLabel.text = self.formattedTimeString
            }

    }
   
}
