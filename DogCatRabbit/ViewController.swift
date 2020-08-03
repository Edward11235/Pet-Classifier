//
//  ViewController.swift
//  DogCatRabbit
//
//  Created by 李春霖 on 2020/8/3.
//  Copyright © 2020 Edward_Li. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let uiImage = info[.editedImage] as? UIImage {
            
            guard let ciImage = CIImage(image: uiImage) else {
                fatalError("Cannot convert uiImage to ciImage")
            }
            
            imageView.image = uiImage
            
            //convert to ciImage
            
            detect(petImage: ciImage)
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    func detect(petImage: CIImage) {
        
        //Initiate the pre-built ML model
        guard let model = try? VNCoreMLModel(for: PetImageClassifier().model) else {
            fatalError("Cannot initiate ML Model")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results?.first as? VNClassificationObservation else {
                fatalError("fail to get classfication result")
            }
            
            self.navigationItem.title = result.identifier.capitalized
            
        }
        
        let handler = VNImageRequestHandler(ciImage: petImage)
        
        do {
            try handler.perform([request])
        } catch {
            print("Fail to perform request: \(error)")
        }
    }
    
    
    @IBAction func cameraButtonPressed(_ sender: UIBarButtonItem) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
}

