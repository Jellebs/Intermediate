//
//  SongCell.swift
//  myFavoriteSongs
//
//  Created by Jesper Bertelsen on 08/04/2021.
//

import UIKit

class SongCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var albumLbl: UILabel!
    @IBOutlet weak var dateAddedLbl: UILabel!
    @IBOutlet weak var songLengthLbl: UILabel!
    
    static let identifier = "SongCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(title: String?, artist: String?, album: String?, dateAdded: String?, songLength: String?) {
        
        titleLbl.text = title
        artistLbl.text = artist
        albumLbl.text = album
        dateAddedLbl.text = dateAdded
        songLengthLbl.text = songLength
    }

}
