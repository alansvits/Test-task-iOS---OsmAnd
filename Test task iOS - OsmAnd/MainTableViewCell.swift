//
//  MainTableViewCell.swift
//  Test task iOS - OsmAnd
//
//  Created by Stas Shetko on 2/03/20.
//  Copyright © 2020 Stas Shetko. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {

    @IBOutlet weak var mapImageView: UIImageView!
    @IBOutlet weak var downloadImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var topCountryNameLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var downloadProgressView: UIProgressView! {
        didSet {
            downloadProgressView.isHidden = true
        }
    }
    
    var isDownloading = false {
        didSet {
            downloadProgressView?.isHidden = !isDownloading
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        downloadProgressView?.isHidden = true
//        isDownloading = fal
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func toggleDownloanProgressView() {
        downloadProgressView.isHidden = !downloadProgressView.isHidden
        if downloadProgressView.isHidden == true {
            topCountryNameLabelConstraint.constant = 11
        } else {
            topCountryNameLabelConstraint.constant = 6

        }
    }
    
    func toggleDownloaded() {
        topCountryNameLabelConstraint.constant = 11
    }
    

}
