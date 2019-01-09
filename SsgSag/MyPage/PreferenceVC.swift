//
//  PreferenceVC.swift
//  SsgSag
//
//  Created by CHOMINJI on 2019. 1. 5..
//  Copyright © 2019년 wndzlf. All rights reserved.
//

import UIKit

class PreferenceVC: UIViewController {
    
    let unActiveButtonImages: [String] = [
        "btPreferenceIdeaUnactive", "btPreferenceCameraUnactive", "btPreferenceDesignUnactive", "btPreferenceMarketingUnactive", "btPreferenceTechUnactive", "btPreferenceLiteratureUnactive", "btPreferenceSholarshipUnactive", "btPreferenceHealthUnactive", "btPreferenceStartupUnactive", "btPreferenceArtUnactive", "btPreferenceEconomyUnactive", "btPreferenceSocietyUnactive"
    ]
    
    let activeButtonImages: [String] = [
        "btPreferenceIdeaActive", "btPreferenceCameraActive", "btPreferenceDesignActive", "btPreferenceMarketingActive", "btPreferenceTechActive", "btPreferenceLiteratureActive", "btPreferenceSholarshipActive", "btPreferenceHealthActive", "btPreferenceStartupActive", "btPreferenceArtActive", "btPreferenceEconomyActive", "btPreferenceSocietyActive"
    ]
    
    var selectedValue: [Bool] = []
    
    @IBOutlet var preferenceButtons: [UIButton]!
    @IBOutlet weak var saveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPreferenceButtons()
        saveButton.isUserInteractionEnabled = false
        
        
    }
    
    func getData() {
        let json: [String: Any] = ["userIdx" : "25",
                                   "categoryIdx": [
                                    "1","3","5"]
                                    ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        
        // create post request
        let url = URL(string: "http://54.180.79.158:8080/interests")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let key2 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJEb0lUU09QVCIsInVzZXJfaWR4IjoxfQ.5lCvAqnzYP4-2pFx1KTgLVOxYzBQ6ygZvkx5jKCFM08"
        request.addValue("token", forHTTPHeaderField: "Application")
        //request.addValue("token", forHTTPHeaderField: "Application")
        
        // insert json data to the request
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            print(data)
            print(response)
            
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                print("responseJSON \(responseJSON)")
            }
        }
        
        task.resume()
    }

    
    @IBAction func touchUpBackButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func touchUpPreferenceButtons(_ sender: UIButton) {
        print(sender.tag)
        myButtonTapped(myButton: sender, tag: sender.tag)
    }
    
    @IBAction func touchUpSaveButton(_ sender: Any) {
        //TODO: - 네트워크 연결
        print("asdgasdgasdg")
        getData()
        
        let myPageStoryBoard = UIStoryboard(name: "MyPageStoryBoard", bundle: nil)
        let popVC = myPageStoryBoard.instantiateViewController(withIdentifier: "PopUp")
        self.addChild(popVC)
        popVC.view.frame = self.view.frame
        self.view.addSubview(popVC.view)
        
        //getPosterData()
        popVC.didMove(toParent: self)
        
    }
    
    func setUpPreferenceButtons() {
        var count = 0
        for button in preferenceButtons {
            button.tag = count
            count += 1
        }
        preferenceButtons.forEach { (button) in
            button.isSelected = false
        }
        for _ in 0 ..< count {
            selectedValue.append(false)
        }
    }
    
    func myButtonTapped(myButton: UIButton, tag: Int) {
        if myButton.isSelected {
            myButton.isSelected = false;
            selectedValue[myButton.tag] = false
            myButton.setImage(UIImage(named: unActiveButtonImages[tag]), for: .normal)
            saveButton.isUserInteractionEnabled = false
        } else {
            myButton.isSelected = true;
            selectedValue[myButton.tag] = true
            myButton.setImage(UIImage(named: activeButtonImages[tag]), for: .normal)
            saveButton.isUserInteractionEnabled = true
        }
        
        if selectedValue.contains(true) {
            saveButton.setImage(UIImage(named: "btSaveMypageActive"), for: .normal)
        } else {
            saveButton.setImage(UIImage(named: "btSaveMypageUnactive"), for: .normal)
        }
    }
    
    func getPosterData() {
        let posterURL = URL(string: "http://54.180.79.158:8080/interests")
        var request = URLRequest(url: posterURL!)
        //request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "PUT"
        let key2 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJEb0lUU09QVCIsInVzZXJfaWR4IjoxfQ.5lCvAqnzYP4-2pFx1KTgLVOxYzBQ6ygZvkx5jKCFM08"
        request.addValue("\(key2)", forHTTPHeaderField: "Application")
        
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                print(error!)
                return
            }
            
            guard let data = data else {
                return
            }
            
            print("data \(data)")
            print("response \(response)")
//            do {
//
//                let order = try JSONDecoder().decode(Json4Swift_Base.self, from: data)
//                print("order \(order)")
//                if let posters = order.data?.posters {
//                    for i in posters {
//                        self.valueArray.append(i)
//                        self.likedArray.append(i)
//
//                        //date parsing
//                        let dateFormatter = DateFormatter()
//                        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//                        guard let startdate = dateFormatter.date(from: i.posterStartDate!) else {
//                            fatalError("ERROR: Date conversion failed due to mismatched format.")
//                        }
//                        guard let regdate = dateFormatter.date(from: i.posterRegDate!) else {
//                            fatalError("ERROR: Date conversion failed due to mismatched format.")
//                        }
//                        guard let endtdate = dateFormatter.date(from: i.posterEndDate!) else {
//                            fatalError("ERROR: Date conversion failed due to mismatched format.")
//                        }
//                    }
//
//                    //main queue에서 리로드하고 카드들을 표현
//                    DispatchQueue.main.async {
//                        self.view.reloadInputViews()
//                        self.loadCardValues()
//                    }
//                }
//            }catch{
//                print("JSON Parising Error")
//            }
        }
        task.resume()
    }
}

