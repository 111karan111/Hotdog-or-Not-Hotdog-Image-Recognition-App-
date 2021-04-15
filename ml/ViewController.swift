//
//  ViewController.swift
//  ml
//
//  Created by Karan Gandhi on 4/15/21.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    var classificationResults : [VNClassificationObservation] = []
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        
        // Do any additional setup after loading the view.
    }

    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        
        //optional binding
        if let image = info[.originalImage] as? UIImage {
            
            imageView.image = image
            imagePicker.dismiss(animated: true, completion:  nil)
            
            guard let ciImage = CIImage(image: image) else {
            
                fatalError("couldn't convert image to ciImage")
                
                
                
            }
            
            
            detect(image:ciImage)
            
            
            
            
        }
        
        
        
        
        
        
        
    }
    
    
    
    
    func detect(image : CIImage){
        
        
    //. Create Model | Create Request | Create Result | Handler
        
        
    
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else {
            
            fatalError("Can't load the model")
        }
        
        //Request
        
        let request =  VNCoreMLRequest(model: model) { (request, error) in
            
            guard let results = request.results as? [VNClassificationObservation],
                  let topResult = results.first
            

            
            else {
                
                fatalError("Unexpected result type")
            }
            
            
            if topResult.identifier.contains("hotdog") {
                
                DispatchQueue.main.async{
                    self.navigationItem.title = "Hotdog!"
                    self.navigationController?.navigationBar.barTintColor = UIColor.green
                    self.navigationController?.navigationBar.isTranslucent = false
                    
                }
               
            }
            
            
            else {
                DispatchQueue.main.async{
                    self.navigationItem.title = "Not Hotdog!"
                    self.navigationController?.navigationBar.barTintColor = UIColor.red
                    self.navigationController?.navigationBar.isTranslucent = false
                    
                }
                
                
            }
        }
        
        
        //handler
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            
            try handler.perform([request])
            
        }
        
        catch {
            
            print(error)
        }
        
        
        
    }
    
    
    
    
    @IBAction func cameraPressed(_ sender: UIBarButtonItem) {
        
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        present(imagePicker, animated: true, completion: nil)
        
        
    }

}

