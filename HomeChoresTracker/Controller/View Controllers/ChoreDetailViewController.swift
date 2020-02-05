//
//  ChoreDetailViewController.swift
//  HomeChoresTracker
//
//  Created by Chad Rutherford on 2/5/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import PhotosUI

class ChoreDetailViewController: UIViewController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Outlets
    @IBOutlet private weak var choreTitleLabel: UILabel!
    @IBOutlet private weak var choreImageView: UIImageView!
    @IBOutlet private weak var choreInformationTextView: UITextView!
    @IBOutlet private weak var choreDueDateLabel: UILabel!
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    var childController: ChildController?
    var chore: ChoreRepresentation? {
        didSet {
            updateViews()
        }
    }
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - View Controller Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        choreImageView.isUserInteractionEnabled = true
        choreImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showImagePicker)))
        updateViews()
    }
    
    private func updateViews() {
        guard let chore = chore, self.isViewLoaded else { return }
        choreTitleLabel.text = chore.title
        if let imageData = chore.image {
            choreImageView.image = UIImage(data: imageData)
        }
        choreInformationTextView.text = chore.information
        choreDueDateLabel.text = "Due Date: \(dateFormatter.string(from: chore.dateFromString))"
    }
    
    @objc private func showImagePicker() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        let status = PHPhotoLibrary.authorizationStatus()
        switch status {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { newStatus in
                switch newStatus {
                case .authorized:
                    DispatchQueue.main.async {
                        self.present(imagePicker, animated: true)
                    }
                default:
                    break
                }
            }
        case .restricted, .denied:
            break
        case .authorized:
            self.present(imagePicker, animated: true)
        @unknown default:
            break
        }
    }
}

extension ChoreDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.choreImageView.image = image
        dismiss(animated: true)
    }
}
