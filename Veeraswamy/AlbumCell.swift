//
//  AlbumCell.swift
//  Veeraswamy
//
//  Created by Veeraswamy on 16/09/20.
//  Copyright © 2020 Orbcomm. All rights reserved.
//

import UIKit

class AlbumCell: UITableViewCell {

    @IBOutlet weak var albumImage: UIImageView!
    @IBOutlet weak var lblAlbum: UILabel!
    @IBOutlet weak var lblArtist: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
