//
//  ChoreDetailViewController.swift
//  HomeChoresTracker
//
//  Created by Chad Rutherford on 2/5/20.
//  Copyright © 2020 Lambda School. All rights reserved.
//

import UIKit
import PhotosUI
import CoreData

class ChoreDetailViewController: UIViewController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Outlets
    @IBOutlet private weak var choreTitleLabel: UILabel!
    @IBOutlet private weak var choreImageView: UIImageView!
    @IBOutlet private weak var choreInformationTextView: UITextView!
    @IBOutlet private weak var choreDueDateLabel: UILabel!
    @IBOutlet private weak var choreCommentsTextField: UITextView!
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    var childController: ChildController?
    var chore: ChoreRepresentation? {
        didSet {
            updateViews()
        }
    }
    
    ///Pretty print the date string returned from the API
    var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
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
        choreCommentsTextField.text = chore.comments
        childController?.fetchImage(for: chore) { image in
            if let image = image {
                self.choreImageView.image = image
            }
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
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Actions
    ///save the image to the API, and on disk
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        guard let chore = chore else { return }
        animateDoneButton(doneButton: sender) {
            if let imageData = self.choreImageView.image?.jpegData(compressionQuality: 0.7) {
                self.childController?.uploadImage(for: chore, image: imageData) { url in
                    if let url = url {
                        //get array of ids for searching in CoreData
                        //create fetchRequest and assign predicate as searched id
                        let context = CoreDataStack.shared.backgroundContext
                        context.performAndWait {
                            do {
                                let fetchRequest: NSFetchRequest<Chore> = Chore.fetchRequest()
                                let idArray = [chore.id]
                                fetchRequest.predicate = NSPredicate(format: "id IN %@", idArray)
                                let chore = try context.fetch(fetchRequest)
                                if let firstChore = chore.first {
                                    self.childController?.completeChore(firstChore, with: url, context: context) {
                                        self.navigationController?.popViewController(animated: true)
                                    }
                                }
                                
                            } catch {
                                print(error)
                            }
                        }
                        
                    }
                }
            } else {
                let context = CoreDataStack.shared.backgroundContext
                context.performAndWait {
                    do {
                        let fetchRequest: NSFetchRequest<Chore> = Chore.fetchRequest()
                        let idArray = [chore.id]
                        fetchRequest.predicate = NSPredicate(format: "id IN %@", idArray)
                        let chore = try context.fetch(fetchRequest)
                        if let firstChore = chore.first {
                            self.childController?.completeChore(firstChore, context: context) {
                                self.navigationController?.popViewController(animated: true)
                            }
                        }
                        
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    func animateDoneButton(doneButton: UIButton, complete: @escaping NetworkService.Complete) {
        let animationBlock = {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.2) {
                doneButton.transform = CGAffineTransform(scaleX: 1.7, y: 0.3)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.2, relativeDuration: 0.2) {
                doneButton.transform = CGAffineTransform(scaleX: 0.6, y: 1.7)
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.15) {
                doneButton.transform = CGAffineTransform(scaleX: 1.11, y: 0.9)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.55, relativeDuration: 0.15) {
                doneButton.transform = .identity
            }
        }
        UIView.animateKeyframes(withDuration: 1.15, delay: 0, options: [], animations: animationBlock) { _ in
            complete()
        }
    }
}

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Image Picker Delegate Method
extension ChoreDetailViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        self.choreImageView.image = image
        dismiss(animated: true)
    }
}
