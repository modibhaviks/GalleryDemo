//
//  PhotoViewController.swift
//  GalleryDemo
//
//  Created by Bhavik Modi on 06/01/22.
//

import UIKit

class PhotoViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var fullPhotoImageView: CustomImageView!
    @IBOutlet weak var photoIdLabel: UILabel!
    
    // MARK: - Properties
    var model: Photos!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView(photo: model)
    }
    
    func setupView(photo: Photos) {
        guard let url = URL(string: photo.url) else { return }
        photoIdLabel.text = "Photo Id #\(photo.id)"
        fullPhotoImageView.downloadImageFrom(url: url, imageMode: .scaleAspectFit)
    }
    
    @IBAction func closeButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
