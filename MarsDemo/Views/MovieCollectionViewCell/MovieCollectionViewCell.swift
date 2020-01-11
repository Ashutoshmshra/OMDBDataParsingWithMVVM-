//
//  MoviesListViewController.swift
//  MarsDemo
//
//  Created by Mobikasa on 1/8/20.
//  Copyright © 2020 Mars. All rights reserved.

import UIKit

class MovieCollectionViewCell: UICollectionViewCell {
    
    //MARK:- Variable Declairations
    static let nib = UINib.init(nibName: "MovieCollectionViewCell", bundle: nil)
    static let cellId = "MovieCollectionViewCell"
    let dateFormat = DateFormatter()
    private var formattedTimeString: String?
    
    //MARK:- Outlets of the Views
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var imagePoster: ImageLoader!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblTime: UILabel!
    
    //MARK:- register cell for the table views
    class func registerCell(`for` collectionView: UICollectionView) {
        collectionView.register(nib, forCellWithReuseIdentifier: cellId)
    }
    
    //MARK:- show data on views
    func cellData(at indexPath: IndexPath, with movie: Search){
        self.lblName.text = movie.title
        self.lblType.text = movie.type
        if let year = movie.year, let date = dateFormat.date(from: year) {
            formattedTimeString = date.yearAgoSinceDate()
        }
        self.lblTime.text =  formattedTimeString
        if let strUrl = movie.poster?.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let imgUrl = URL(string: strUrl) {
            if strUrl == "N/A"{
                self.imagePoster.image = UIImage(named: "placeholderImage")
            }
            else{
                self.imagePoster.loadImageWithUrl(imgUrl)
            }
        }
        
    }
    //MARK:- Add shadows on view, Register date formatter
    override func awakeFromNib() {
        super.awakeFromNib()
        self.dateFormat.dateFormat = Date.dateFormat
        self.viewContainer.layer.borderWidth = 1
        self.viewContainer.layer.cornerRadius = 5
        self.viewContainer.layer.borderColor = UIColor.clear.cgColor
        self.viewContainer.layer.masksToBounds = true
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowRadius = 5
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
    }
}
