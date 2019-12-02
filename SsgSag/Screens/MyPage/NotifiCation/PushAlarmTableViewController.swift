//
//  PushAlarmTableViewController.swift
//  SsgSag
//
//  Created by admin on 21/05/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit
import FirebaseMessaging
import UserNotifications
import Firebase

class PushAlarmTableViewController: UITableViewController, MessagingDelegate, UNUserNotificationCenterDelegate {
    
    @IBOutlet weak var deadlineSwitch: UISwitch!
    
    @IBOutlet weak var todayCardSwitch: UISwitch!
    
    private lazy var backButton = UIBarButtonItem(image: UIImage(named: "ic_ArrowBack"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(touchUpBackButton))
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        setNavigationBar(color: .white)
        navigationItem.leftBarButtonItem = backButton
        navigationController?.navigationBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(willEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)

        
        tableView.allowsSelection = false
        tableView.separatorStyle = .none
        
        deadlineSwitch.tintColor = .lightGray
        deadlineSwitch.layer.cornerRadius = deadlineSwitch.frame.height / 2
        deadlineSwitch.backgroundColor = .lightGray
        
        todayCardSwitch.tintColor = .lightGray
        todayCardSwitch.layer.cornerRadius = deadlineSwitch.frame.height / 2
        todayCardSwitch.backgroundColor = .lightGray
        
        setupSwitchWithSetting()
    }
    
    private func setupSwitchWithSetting() {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            if settings.authorizationStatus == .denied {
                DispatchQueue.main.async {
                    self?.todayCardSwitch.isOn = false
                }
            } else if settings.authorizationStatus == .authorized {
                DispatchQueue.main.async {
                    self?.todayCardSwitch.isOn = true
                }
            }
        }
    }
    
    @objc private func touchUpBackButton() {
        navigationController?.popViewController(animated: true)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    @objc func willEnterForeground() {
        setupSwitchWithSetting()
    }
    
    @IBAction func dissMissPushAlarm(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func arriveCard(_ sender: UISwitch) {
        UNUserNotificationCenter.current().getNotificationSettings { [weak self] settings in
            DispatchQueue.main.async {
                let alertController
                    = UIAlertController(title: "알림 설정",
                                        message: "설정에서 알림 여부를 변경해주세요",
                                        preferredStyle: .alert)
                
                let settingsAction = UIAlertAction(title: "설정으로 이동",
                                                   style: .default) { _ in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl){ success in
                            print("Settings opened: \(success)")
                        }
                    }
                }
                
                let cancelAction = UIAlertAction(title: "취소", style: .default) { _ in
                    sender.isOn = !sender.isOn
                }
                
                alertController.addAction(settingsAction)
                alertController.addAction(cancelAction)

                alertController.modalPresentationStyle = .fullScreen
                self?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    private func setFirebaseRemoteInstanceIDtoken() {
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            
            UIApplication.shared.registerUserNotificationSettings(settings)
        }
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
            }
        }
        
    }
    
    @IBAction func alarmTodoList(_ sender: Any) {
        simplerAlert(title: "준비중입니다.")
    }
    
    
}
