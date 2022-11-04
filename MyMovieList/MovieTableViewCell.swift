//
//  MovieTableViewCell.swift
//  MyMovieList
//
//  Created by Richard Marquez on 4/20/22.
//

import UIKit

class MovieTableViewCell: UITableViewCell
{
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var movieReleaseYearLabel: UILabel!
    @IBOutlet weak var moviePersonalRatingLabel: UILabel!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
