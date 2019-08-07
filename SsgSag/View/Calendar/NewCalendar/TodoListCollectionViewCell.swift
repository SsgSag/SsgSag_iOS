//
//  TodoListCollectionViewCell.swift
//  SsgSag
//
//  Created by 이혜주 on 30/07/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import UIKit

protocol dismissDelegate: class {
    func touchUpCancelButton()
}

class TodoListCollectionViewCell: UICollectionViewCell {
    weak var delegate: dismissDelegate?
    
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var todoListTableView: UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        setupTableView()
    }
    
    private func setupTableView() {
        let todoNib = UINib(nibName: "DetailTodoListTableViewCell",
                            bundle: nil)
        todoListTableView.register(todoNib,
                                   forCellReuseIdentifier: "todoCell")
    }
    
    @IBAction func touchUpCancelButton(_ sender: UIButton) {
        delegate?.touchUpCancelButton()
    }

}
