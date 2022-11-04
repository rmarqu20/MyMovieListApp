//
//  MapTableViewCell.swift
//  MyMovieList
//
//  Created by Richard Marquez on 4/23/22.
//

import UIKit

class MapTableViewCell: UITableViewCell
{
    @IBOutlet weak var theatreNameLabel: UILabel!
    @IBOutlet weak var theatreDistanceLabel: UILabel!
    
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
