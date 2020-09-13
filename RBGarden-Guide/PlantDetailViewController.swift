//
//  PlantDetailViewController.swift
//  RBGarden-Guide
//
//  Created by Stanford on 12/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit

class PlantDetailViewController: UIViewController {
    
    var selectedPlant : Plant?
    var indicator = UIActivityIndicatorView()
    var session : URLSession?
    @IBOutlet weak var sciNameLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var plantNameLabel: UILabel!
    
    @IBOutlet weak var yearLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        plantNameLabel.numberOfLines = 4
        plantNameLabel.lineBreakMode = .byWordWrapping
        
        sciNameLabel.numberOfLines = 4
        sciNameLabel.lineBreakMode = .byWordWrapping
        
        if let commonName = selectedPlant?.plantName{
            plantNameLabel.text = commonName
        }else{
            plantNameLabel.text = "No Common Name"
        }
        
        if let scientificName =  selectedPlant?.scientificName{
            sciNameLabel.text = scientificName
        }else{
            sciNameLabel.text = "No Scientific Name"
        }
        
        if let discoverYear = selectedPlant?.discoverYear{
            yearLabel.text = discoverYear
        }else{
            yearLabel.text = "No Year"
        }
        
        indicator.style = UIActivityIndicatorView.Style.medium
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
        //download image
        
        guard let url = selectedPlant?.imageUrl else {
            self.imageView.image = UIImage(named:"no-image-icon")
            return
        }
        if url == ""{
            self.imageView.image = UIImage(named:"no-image-icon")
            return
        }
        
        
        //        let config = URLSessionConfiguration.background(withIdentifier: plantNameLabel.text!)
        //        session = URLSession(configuration: config, delegate: self, delegateQueue: OperationQueue())
        //
        //        let link = URL(string: url)!
        //        let task = session!.downloadTask(with: link)
        //        task.resume()
        
        indicator.startAnimating()
        indicator.backgroundColor = UIColor.clear
        setImageFromUrl(url: url)
        //        indicator.stopAnimating()
        //invalidate previous session and id
        //URLSession.shared.invalidateAndCancel()
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func setImageFromUrl(url:String){
        let imageURL = URL(string:url)
        
        let task = URLSession.shared.dataTask(with: imageURL!) {
            (data, response, error) in
            // Regardless of response end the loading icon from the main thread
            if let error = error {
                DispatchQueue.main.async{
                    self.imageView.image = UIImage(named:"no-image-icon")
                    self.indicator.stopAnimating()
                }
                print(error)
                return
                
            }
            do {
                if let content = data{
                    DispatchQueue.main.async{
                        self.imageView.image = UIImage(data: content)
                        self.indicator.stopAnimating()
                    }
                }
                
            }
            //catch let err {
            //                    print(err)
            //                }
        }
        task.resume()
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    //    func urlSession(_session: URLSession, downloadTask: URLSessionDownloadTask, didWriteDatabytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
    //        if totalBytesExpectedToWrite > 0 {
    //            let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
    //            debugPrint("Progress \(downloadTask) \(progress)")
    //        }
    //
    //    }
    //
    //    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
    //        do{
    //            let data = try Data(contentsOf: location)
    //            // Images can only be loaded from the main thread
    //            DispatchQueue.main.async{
    //                self.imageView.image = UIImage(data: data)
    //                session.invalidateAndCancel()
    //                self.indicator.stopAnimating()
    //
    //            }
    //        } catch let error {
    //            print(error.localizedDescription)
    //        }
    //    }
    
}



//extension UIImageView{
//    func setImageFromUrl(url:String){
//        let imageURL = URL(string:url)
//
//            let task = URLSession.shared.dataTask(with: imageURL!) {
//                (data, response, error) in
//                // Regardless of response end the loading icon from the main thread
//                if let error = error {
//                    print(error)
//                    return
//                }
//                do {
//                    if let content = data{
//                        DispatchQueue.main.async{
//                            self.image = UIImage(data: content)
//
//                        }
//                    }
//
//                }
//                    //catch let err {
////                    print(err)
////                }
//            }
//            task.resume()
//        }
//    }
