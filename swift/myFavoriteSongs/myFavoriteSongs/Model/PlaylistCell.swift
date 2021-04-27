//
//  PlaylistCell.swift
//  myFavoriteSongs
//
//  Created by Jesper Bertelsen on 08/04/2021.
//

import UIKit

class PlaylistCell: UITableViewCell {
    @IBOutlet weak var playlistTitleLbl: UILabel!
    @IBOutlet weak var playlistCountLbl: UILabel!
    @IBOutlet weak var playlistDescriptionLbl: UILabel!
    @IBOutlet weak var playlistImg: UIImageView!

    static let identifier = "PlaylistCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configureCell(playlistTitle: String, playlistDescription: String, playlistImg: String, playlistCount: String) {
        playlistTitleLbl.text = playlistTitle
        playlistCountLbl.text = playlistCount
        playlistDescriptionLbl.text = playlistDescription
        self.playlistImg.image = UIImage(named: playlistImg)
        
    }

}
