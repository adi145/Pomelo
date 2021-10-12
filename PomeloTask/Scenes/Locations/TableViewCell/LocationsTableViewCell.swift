//
//  LocationsTableViewCell.swift
//  PomeloTask
//
//  Created by Adinarayana Machavarapu on 10/10/21.
//

import UIKit

class LocationsTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var distanceLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectLocationImage: UIImageView!

    var locationDisplayViewModel : LocationsDisplayViewModel! {
        didSet {
            self.nameLabel.text   = locationDisplayViewModel.alias.uppercased()
            self.addressLabel.text    = locationDisplayViewModel.address1
            self.cityLabel.text = locationDisplayViewModel.city
            self.distanceLabel.text = String(format: "%.01f km", locationDisplayViewModel.distance)
            if self.locationDisplayViewModel.shouldShowDistance{
                self.distanceHeightConstraint.constant = 80
                self.distanceLeadingConstraint.constant = 10
            } else {
                self.distanceHeightConstraint.constant = 0
                self.distanceLeadingConstraint.constant = 0
            }
        }
    }
    
    func isLocationSelected(selectedIndexPath: IndexPath, currentIndex: IndexPath) {
        self.selectLocationImage.image = UIImage(systemName: "checkmark.circle.fill")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        if selectedIndexPath == currentIndex {
            self.selectLocationImage.isHidden = false
        } else {
            self.selectLocationImage.isHidden = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
