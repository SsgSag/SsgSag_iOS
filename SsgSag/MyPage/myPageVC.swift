//
//  myPageVC.swift
//  SsgSag
//
//  Created by admin on 01/01/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

class myPageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var imagePicker: UIImagePickerController = {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.allowsEditing = true
        return picker
    }()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var idLabel: UILabel!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var schoolLabel: UILabel!
    @IBOutlet weak var majorLabel: UILabel!
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
        profileImageView.applyRadius(radius: profileImageView.frame.height / 2)
        
        // Do any additional setup after loading the view.
    }
    

    @IBAction func touchUpCameraButton(_ sender: UIButton) {
        self.present(self.imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImage: UIImage?
        if let editedImage: UIImage = info[.editedImage] as? UIImage {
            selectedImage = editedImage
            self.profileImageView.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        } else if let originalImage: UIImage = info[.originalImage] as? UIImage {
            selectedImage = originalImage
            self.profileImageView.image = selectedImage!
            picker.dismiss(animated: true, completion: nil)
        }
//        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getData(careerType: String) {
        
//        let json: [String:Any] = [
//            "status": 200,
//            "message": "회원 정보 조회 성공",
//            "data": {
//                "userIdx": 1,
//                "userEmail": "gumgim95@naver.com",
//                "userPw": "784512",
//                "userId" : "heo0807",
//                "userName": "김현수",
//                "userUniv": "인하대학교",
//                "userMajor": "컴퓨터공학과",
//                "userStudentNum": "14",
//                "userGender": "male",
//                "userBirth": "951107",
//                "userSignOutDate": "2019-01-05 07:38:00",
//                "userSignInDate": "2019-01-05 07:38:00",
//                "userPushAllow": 1,
//                "userIsSeeker": 0,
//                "userCnt": 15,
//                "userInfoAllow": 1,
//                "userProfileUrl": "https://s3.ap-northeast-2.amazonaws.com/project-hs/857bcdee4d3149e19230a08d7a99ee94.jpg",
//                "userAlreadyOut": 0,
//                "userGrade": 0
//            }
//        ]
        
        let json: [String: Any] = ["careerType" : careerType]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        let url = URL(string: "http://54.180.79.158:8080/users/info")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let key2 = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJEb0lUU09QVCIsInVzZXJfaWR4IjoxfQ.5lCvAqnzYP4-2pFx1KTgLVOxYzBQ6ygZvkx5jKCFM08"
        request.addValue(key2, forHTTPHeaderField: "Authorization")
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            
            guard let data = data else { return }
            
            print(data)
            print("gggg")
            print(response)
            
            do {
                let apiResponse = try JSONDecoder().decode(Career.self, from: data)
                print("orders: \(apiResponse)")
                if careerType == "0" {
                    print("00000000")
//                    self.activityList = apiResponse.data
                    DispatchQueue.main.async {
//                        self.activityTableView.reloadData()
                    }
                }
            } catch (let err) {
                print(err.localizedDescription)
                print("sladjalsdjlasjdlasjdlajsldjas")
            }
            
            //            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            //            if let responseJSON = responseJSON as? [String: Any] {
            //                //print("responseJSON \(responseJSON)")
            //                //print(responseJSON["data"])
            //                var a = responseJSON["data"]
            //                print(a)
            //                print("1")
            //            }
        }
        task.resume()
    }
}



