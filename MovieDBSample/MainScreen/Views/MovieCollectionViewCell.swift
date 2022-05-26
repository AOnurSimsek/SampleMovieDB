//
//  MovieCollectionViewCell.swift
//  MovieDBSample
//
//  Created by Onur Şimşek on 25.05.2022.
//

import UIKit
import SDWebImage

class MovieCollectionViewCell: UICollectionViewCell {

    static let identifier : String = "MovieCollectionViewCellIdentifier"
    static let nibName : String = "MovieCollectionViewCell"

    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overViewLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setCell(imagePath: URL?,
                 title: String,
                 overView: String,
                 year: String) {
        
            self.cellImageView.sd_setImage(with: imagePath) { [weak self] image, _, _, _ in
                guard let self = self else { return }
                if image == nil {
                    self.cellImageView.image = UIImage(named: "placeholderImage")
                }
        }
        
        titleLabel.text = title + " " + year
        overViewLabel.text = overView
        
    }

}
