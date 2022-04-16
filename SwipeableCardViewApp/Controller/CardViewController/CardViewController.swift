//
//  CardViewController.swift
//  SwipeableCardViewApp
//
//  Created by Never Mind on 16/04/22.
//

import UIKit
import Gemini

class CardViewController: UIViewController {
    
    //MARK:- DECLARE @IBOUTLET HERE
    @IBOutlet var cardCollectionView: GeminiCollectionView!
    @IBOutlet var progressView: UIProgressView!
    @IBOutlet var lblStaus: UILabel!
    
    var idArray = [String]()
    var textArray = [String]()
    var imageArray = ["2","1","3","4","5","6","7","4"]
    var totalIDArray = [String]()
    
    var selectedAnimation = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //calling content api
        callingContentApi()
        
        //Removing selected animation name
        UserDefaults.standard.removeObject(forKey: "selectedName")
    }
    
    
    // CREATE BUTTON ACTION HERE
    @IBAction func btnSettings(sender:UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as! SettingsViewController
         selectedAnimation = "Drag"
         vc.delegate = self
        imageArray.removeAll()
        present(vc, animated: true, completion: nil)
    }
    
}


//MARK:- DECLARE COLLECTIONVIEW DELEGATE AND DATASOURCE HERE
extension CardViewController : UICollectionViewDelegate , UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {

    
    // Call animation function
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        cardCollectionView.animateVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return idArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCollectionViewCell", for: indexPath) as! CardCollectionViewCell
        cell.labelText.text = textArray[indexPath.row]
        cell.imgBackground.image = UIImage(named: "\(imageArray[indexPath.row])")
        self.cardCollectionView.animateCell(cell)
        return cell
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? GeminiCell {
            
            if selectedAnimation != "Drag" {
                let percentageChange = (Float(indexPath.row + 1) / Float(totalIDArray.count) ) * 100
                let currentProgress = (percentageChange / 100 ) * 1
                self.progressView.setProgress(Float(currentProgress), animated: true)
                self.cardCollectionView.animateCell(cell)
                self.lblStaus.text = "\(indexPath.row + 1)/\(totalIDArray.count )"

            } else {
                
                let percentageChange = (Float(1.0) / Float(totalIDArray.count) ) * 1
                let updateProgress = (Float(percentageChange * Float(idArray.count)))
                self.progressView.setProgress(Float(updateProgress), animated: true)
                self.lblStaus.text = "\(idArray.count)/\(totalIDArray.count )"
                self.cardCollectionView.animateCell(cell)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        _ = imageArray.remove(at: sourceIndexPath.item)
        print(sourceIndexPath.row)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
}


//MARK:- FOR DRAG CARD VIEW FUNCTION HERE
extension CardViewController {
    
    func longPressGesture() {
        let gesture = UILongPressGestureRecognizer(target:self, action: #selector(longPressGesture(_ : )))
        gesture.minimumPressDuration = 0.2
        cardCollectionView.addGestureRecognizer(gesture)
    }
    
    
    @objc func longPressGesture(_ gesture: UILongPressGestureRecognizer) {
        
        switch (gesture.state) {
            
        case .began:
            guard let  selectedIndexPath = cardCollectionView.indexPathForItem(at: gesture.location(in: cardCollectionView)) else {break}
            cardCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            cardCollectionView.updateInteractiveMovementTargetPosition(gesture.location(in: cardCollectionView))
        case .ended:
            cardCollectionView.endInteractiveMovement()
            
            if idArray.count >= 1 {
                textArray.remove(at: 0)
                idArray.remove(at: 0)
                imageArray.remove(at: 0)
                cardCollectionView.reloadData()
            }
            
        default:
            print("some things")
            
        }
    }
    
}


//MARK:- //CONFIGURE GEMINI ANIMATON AND PROPERTIES
extension CardViewController : settingsProtocol  {
           
    
    func seletedName(_string: String) {
        
        let imageArraySec = ["2","1","3","4","5","6","7","4"]
        imageArray.append(contentsOf: imageArraySec)
        selectedAnimation = UserDefaults.standard.value(forKey: "selectedName") as? String ?? ""

        if _string == "Cube" {
            cardCollectionView.isScrollEnabled = true
            cardCollectionView.gemini
                .cubeAnimation()
                .cubeDegree(90)
            
        } else if _string == "Roll Rotation" {
            cardCollectionView.isScrollEnabled = true
            cardCollectionView.gemini
                .rollRotationAnimation()
                .degree(45)
                .rollEffect(.rollUp)
            
        } else if _string == "Pitch Rotation" {
            cardCollectionView.isScrollEnabled = true
            cardCollectionView.gemini
                .pitchRotationAnimation()
                .degree(45)
                .pitchEffect(.pitchDown)
        } else if _string == "Scale" {
            cardCollectionView.isScrollEnabled = true
            cardCollectionView.gemini
                .scaleAnimation()
                .scale(0.75)
                .scaleEffect(.scaleUp)
        } else if _string == "Custom" {
            cardCollectionView.isScrollEnabled = true
            cardCollectionView.gemini
                .customAnimation()
                .backgroundColor(startColor: .lightGray, endColor: .blue)
                .ease(.easeOutSine)
                .cornerRadius(75)
        } else if _string == "Drag" {
            selectedAnimation = "Drag"
            longPressGesture()
            cardCollectionView.isScrollEnabled = false
            cardCollectionView.reloadData()
        }
        
        callingContentApi()

    }
    
}


//MARK:- API FUNCTION HERE
extension CardViewController {
    
    //MARK:- DECLARE CONTENT API HERE
    func callingContentApi() {
        
        guard let url = URL(string:"https://gist.githubusercontent.com/anishbajpai014/d482191cb4fff429333c5ec64b38c197/raw/b11f56c3177a9ddc6649288c80a004e7df41e3b9/HiringTask.json") else {return}
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data {
                
                // Note :-  Converting josn response into string becase slash "/" is comming at starting of json response so you have to remove first and covert into data again then you can decode that data.
                
                // Converting data into String
                let jsonString = String(data: data, encoding: String.Encoding.utf8)
                
                // Removing slash "/" from json response
                guard let removeSlash = jsonString?.dropFirst(1) else {return}
                
                // Converting into Data
                let convertIntoData = Data(removeSlash.utf8)
                
                do {
                    
                    let contentValue  = try JSONDecoder().decode(baseModel.self, from: convertIntoData)
                    guard let contentList = contentValue.data else {return}
                    
                    //remove array
                    self.idArray.removeAll()
                    self.textArray.removeAll()
                    self.totalIDArray.removeAll()
                    
                    // Appending data in Array
                    for i in contentList {
                        self.idArray.append(i.id ?? "")
                        self.textArray.append(i.text ?? "")
                        self.totalIDArray.append(i.id ?? "")
                    }
                    
                } catch let error {
                    print(error.localizedDescription)
                }
                
            }
            
            DispatchQueue.main.async {
                self.cardCollectionView.reloadData()
            }
            
        } .resume()
    }
}
