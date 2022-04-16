//
//  SettingsViewController.swift
//  SwipeableCardViewApp
//
//  Created by Never Mind on 16/04/22.
//

import UIKit

// PROTOCAL TO PASS SELECTED ANIMATAION
protocol settingsProtocol {
    func seletedName(_string:String)
}


class SettingsViewController: UIViewController {

    //MARK:- DECLARE IBOUTLET HERE
    @IBOutlet weak var settingsTableView:UITableView!
    
   // Assigning delegate
    var delegate:settingsProtocol?
    
    
    var nameArray = ["Cube","Roll Rotation", "Pitch Rotation", "Scale" , "Custom", "Drag"]
    
    var selectedName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        selectedName = UserDefaults.standard.value(forKey: "selectedName") as? String ?? ""
        
    }
    
    // CREATE BUTTON ACTION HERE
    @IBAction func btnDismiss(sender:UIButton) {
        dismiss(animated: true)
    }
    
}


//MARK:- DECALRE TABLEVIEW DELEGATE AND DATA SOURCE
extension SettingsViewController:UITableViewDelegate , UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nameArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsTableViewCell") as! SettingsTableViewCell
        cell.lblName.text = nameArray[indexPath.row]
        cell.btnSelect.addTarget(self, action: #selector(seletedSetting), for: .touchUpInside)
        cell.btnSelect.tag = indexPath.row
        
        if selectedName == nameArray[indexPath.row] {
            cell.btnSelect.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
            cell.btnSelect.tintColor = UIColor.black
        } else {
            cell.btnSelect.setImage(UIImage(systemName: "circle.circle"), for: .normal)
            cell.btnSelect.tintColor = UIColor.black
        }
        
        return cell
    }
    
    
    
    // MARK:- DELCARE FUNTION TO SELECT ANIMTATION
    @objc func seletedSetting(_ sender:UIButton) {
        delegate?.seletedName(_string: "\(nameArray[sender.tag])")
        UserDefaults.standard.setValue("\(nameArray[sender.tag])", forKey: "selectedName")
        selectedName = nameArray[sender.tag]
        settingsTableView.reloadData()
    }
    
    
}

