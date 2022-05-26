//
//  MovieTableViewCell.swift
//  MovieDBSample
//
//  Created by Onur Şimşek on 24.05.2022.
//

import UIKit
import SDWebImage

class MovieTableViewCell: UITableViewCell {

    static let identifier : String = "MovieTableViewCellIdentifier"
    static let nibName : String = "MovieTableViewCell"
    
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setStyle()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setStyle(){
        cellImageView.layer.cornerRadius = 8
    }
    
    func setCell(imgPath: URL?,
                 title: String,
                 releaseDate: String,
                 overView: String,
                 year: String){
        
        cellImageView.sd_setImage(with: imgPath) { [weak self] image, _, _, _ in
            guard let self = self else { return }
            if image == nil {
                self.cellImageView.image = UIImage(named: "placeholderImage")
            }
        }
        titleLabel.text = title + " " + year
        releaseDateLabel.text = releaseDate
        overviewLabel.text = overView
    }
    
}
