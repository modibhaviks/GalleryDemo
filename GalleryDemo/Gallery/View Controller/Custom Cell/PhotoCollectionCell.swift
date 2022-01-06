//
//  PhotoCollectionCell.swift
//  GalleryDemo
//
//  Created by Bhavik Modi on 05/01/22.
//

import UIKit

class PhotoCollectionCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var photoImageView: CustomImageView!
    @IBOutlet weak var photoIdLabel: UILabel!
    
    // MARK: - Properties
    static let cellIdentifier = "PhotoCollectionCell"
    var viewModel: RowViewModel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Setup cell content
    func setupCell(rowViewModel: RowViewModel) {
        self.viewModel = rowViewModel
        guard let photo = viewModel.data as? Photos else { return }
        photoImageView.image = #imageLiteral(resourceName: "icn_noImage")
        photoIdLabel.text = "Id #\(photo.id)"
        guard let photoThumbUrl = URL(string: photo.thumbnailUrl) else { return }
        photoImageView.downloadImageFrom(url: photoThumbUrl, imageMode: .scaleAspectFit)
    }
}
