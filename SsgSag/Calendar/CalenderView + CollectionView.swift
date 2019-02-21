//
//  CalenderView + CollectionView.swift
//  SsgSag
//
//  Created by CHOMINJI on 02/02/2019.
//  Copyright © 2019 wndzlf. All rights reserved.
//

import Foundation

extension CalenderView: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        reValue = 0
        if numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 1 > 35 {
            reValue = 42
        }else {
            reValue = 35
        }
        return reValue
    }
    
    fileprivate func drawDotAndLineView(_ indexPath: IndexPath, _ cell: DayCollectionViewCell) {
        let eventNum = eventDictionary[indexPath.row]!.count
        print("eventNum \(indexPath.item) : \(eventNum)")
        
        cell.dotAndLineView1.isHidden = true
        cell.dotAndLineView2.isHidden = true
        cell.dotAndLineView3.isHidden = true
        cell.dotAndLineView4.isHidden = true
        cell.dotAndLineView5.isHidden = true
        
        cell.dotAndLineView1.backgroundColor = .clear
        cell.dotAndLineView2.backgroundColor = .clear
        cell.dotAndLineView3.backgroundColor = .clear
        cell.dotAndLineView4.backgroundColor = .clear
        cell.dotAndLineView5.backgroundColor = .clear
        
            if cell.todoStatus == -1 {
                let event = eventDictionary[indexPath.row]!
                var eventCategoryList: [Int] = []
                
                for i in event {
                    eventCategoryList.append(i.categoryIdx)
                }
                
                let dotWidth = cell.frame.width * 0.1
                let dotTopAnchor = cell.lbl.frame.origin.y + cell.lbl.frame.height + 5
                switch eventNum {
                case 1:
                    cell.dotAndLineView1TopAnchor?.isActive = false
                    cell.dotAndLineView1WidthAnchor?.isActive = false
                    cell.dotAndLineView1HeightAnchor?.isActive = false
                    cell.dotAndLineView1CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView1TopAnchor = cell.dotAndLineView1.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor, constant: 4)
                    cell.dotAndLineView1WidthAnchor = cell.dotAndLineView1.widthAnchor.constraint(equalToConstant: dotWidth)
                    cell.dotAndLineView1HeightAnchor = cell.dotAndLineView1.heightAnchor.constraint(equalToConstant: dotWidth)
                    cell.dotAndLineView1CenterXAnchor = cell.dotAndLineView1.centerXAnchor.constraint(equalTo: cell.centerXAnchor)

                    cell.dotAndLineView1TopAnchor?.isActive = true
                    cell.dotAndLineView1WidthAnchor?.isActive = true
                    cell.dotAndLineView1HeightAnchor?.isActive = true
                    cell.dotAndLineView1CenterXAnchor?.isActive = true
                    
                    cell.dotAndLineView1.isHidden = false
                case 2:
                    cell.dotAndLineView1TopAnchor?.isActive = false
                    cell.dotAndLineView1WidthAnchor?.isActive = false
                    cell.dotAndLineView1HeightAnchor?.isActive = false
                    cell.dotAndLineView1CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView2TopAnchor?.isActive = false
                    cell.dotAndLineView2WidthAnchor?.isActive = false
                    cell.dotAndLineView2HeightAnchor?.isActive = false
                    cell.dotAndLineView2CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView1TopAnchor = cell.dotAndLineView1.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor, constant: 4)
                    cell.dotAndLineView1WidthAnchor = cell.dotAndLineView1.widthAnchor.constraint(equalToConstant: cell.frame.width * 0.1)
                    cell.dotAndLineView1HeightAnchor = cell.dotAndLineView1.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.1)
                    cell.dotAndLineView1CenterXAnchor = cell.dotAndLineView1.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: -3)
                    
                    cell.dotAndLineView2TopAnchor = cell.dotAndLineView2.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor, constant: 4)
                    cell.dotAndLineView2WidthAnchor = cell.dotAndLineView2.widthAnchor.constraint(equalToConstant: cell.frame.width * 0.1)
                    cell.dotAndLineView2HeightAnchor = cell.dotAndLineView2.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.1)
                    cell.dotAndLineView2CenterXAnchor = cell.dotAndLineView2.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: 3)
                    
                    cell.dotAndLineView1TopAnchor?.isActive = true
                    cell.dotAndLineView1CenterXAnchor?.isActive = true
                    cell.dotAndLineView1WidthAnchor?.isActive = true
                    cell.dotAndLineView1HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView2TopAnchor?.isActive = true
                    cell.dotAndLineView2CenterXAnchor?.isActive = true
                    cell.dotAndLineView2WidthAnchor?.isActive = true
                    cell.dotAndLineView2HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView1.isHidden = false
                    cell.dotAndLineView2.isHidden = false
                case 3:
                    cell.dotAndLineView1TopAnchor?.isActive = false
                    cell.dotAndLineView1WidthAnchor?.isActive = false
                    cell.dotAndLineView1HeightAnchor?.isActive = false
                    cell.dotAndLineView1CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView2TopAnchor?.isActive = false
                    cell.dotAndLineView2WidthAnchor?.isActive = false
                    cell.dotAndLineView2HeightAnchor?.isActive = false
                    cell.dotAndLineView2CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView3TopAnchor?.isActive = false
                    cell.dotAndLineView3WidthAnchor?.isActive = false
                    cell.dotAndLineView3HeightAnchor?.isActive = false
                    cell.dotAndLineView3CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView1TopAnchor = cell.dotAndLineView1.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor)
                    cell.dotAndLineView1WidthAnchor = cell.dotAndLineView1.widthAnchor.constraint(equalToConstant: cell.frame.width * 0.1)
                    cell.dotAndLineView1HeightAnchor = cell.dotAndLineView1.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.1)
                    cell.dotAndLineView1CenterXAnchor = cell.dotAndLineView1.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: -5)
                    
                    cell.dotAndLineView2TopAnchor = cell.dotAndLineView2.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor)
                    cell.dotAndLineView2WidthAnchor = cell.dotAndLineView2.widthAnchor.constraint(equalToConstant: cell.frame.width * 0.1)
                    cell.dotAndLineView2HeightAnchor = cell.dotAndLineView2.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.1)
                    cell.dotAndLineView2CenterXAnchor = cell.dotAndLineView2.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView3TopAnchor = cell.dotAndLineView3.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor)
                    cell.dotAndLineView3WidthAnchor = cell.dotAndLineView3.widthAnchor.constraint(equalToConstant: cell.frame.width * 0.1)
                    cell.dotAndLineView3HeightAnchor = cell.dotAndLineView3.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.1)
                    cell.dotAndLineView3CenterXAnchor = cell.dotAndLineView3.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: 5)
                    
                    cell.dotAndLineView1TopAnchor?.isActive = true
                    cell.dotAndLineView1CenterXAnchor?.isActive = true
                    cell.dotAndLineView1WidthAnchor?.isActive = true
                    cell.dotAndLineView1HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView2TopAnchor?.isActive = true
                    cell.dotAndLineView2CenterXAnchor?.isActive = true
                    cell.dotAndLineView2WidthAnchor?.isActive = true
                    cell.dotAndLineView2HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView3TopAnchor?.isActive = true
                    cell.dotAndLineView3CenterXAnchor?.isActive = true
                    cell.dotAndLineView3WidthAnchor?.isActive = true
                    cell.dotAndLineView3HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView1.isHidden = false
                    cell.dotAndLineView2.isHidden = false
                    cell.dotAndLineView3.isHidden = false
                case 4:
                    cell.dotAndLineView1TopAnchor?.isActive = false
                    cell.dotAndLineView1WidthAnchor?.isActive = false
                    cell.dotAndLineView1HeightAnchor?.isActive = false
                    cell.dotAndLineView1CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView2TopAnchor?.isActive = false
                    cell.dotAndLineView2WidthAnchor?.isActive = false
                    cell.dotAndLineView2HeightAnchor?.isActive = false
                    cell.dotAndLineView2CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView3TopAnchor?.isActive = false
                    cell.dotAndLineView3WidthAnchor?.isActive = false
                    cell.dotAndLineView3HeightAnchor?.isActive = false
                    cell.dotAndLineView3CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView4TopAnchor?.isActive = false
                    cell.dotAndLineView4WidthAnchor?.isActive = false
                    cell.dotAndLineView4HeightAnchor?.isActive = false
                    cell.dotAndLineView4CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView1TopAnchor = cell.dotAndLineView1.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor)
                    cell.dotAndLineView1WidthAnchor = cell.dotAndLineView1.widthAnchor.constraint(equalToConstant: cell.frame.width * 0.1)
                    cell.dotAndLineView1HeightAnchor = cell.dotAndLineView1.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.1)
                    cell.dotAndLineView1CenterXAnchor = cell.dotAndLineView1.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: -5)
                    
                    cell.dotAndLineView2TopAnchor = cell.dotAndLineView2.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor)
                    cell.dotAndLineView2WidthAnchor = cell.dotAndLineView2.widthAnchor.constraint(equalToConstant: cell.frame.width * 0.1)
                    cell.dotAndLineView2HeightAnchor = cell.dotAndLineView2.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.1)
                    cell.dotAndLineView2CenterXAnchor = cell.dotAndLineView2.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: -2)
                    
                    cell.dotAndLineView3TopAnchor = cell.dotAndLineView3.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor)
                    cell.dotAndLineView3WidthAnchor = cell.dotAndLineView3.widthAnchor.constraint(equalToConstant: cell.frame.width * 0.1)
                    cell.dotAndLineView3HeightAnchor = cell.dotAndLineView3.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.1)
                    cell.dotAndLineView3CenterXAnchor = cell.dotAndLineView3.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: 2)
                    
                    cell.dotAndLineView4TopAnchor = cell.dotAndLineView4.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor)
                    cell.dotAndLineView4WidthAnchor = cell.dotAndLineView4.widthAnchor.constraint(equalToConstant: cell.frame.width * 0.1)
                    cell.dotAndLineView4HeightAnchor = cell.dotAndLineView4.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.1)
                    cell.dotAndLineView4CenterXAnchor = cell.dotAndLineView4.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: 5)
                    
                    cell.dotAndLineView1TopAnchor?.isActive = true
                    cell.dotAndLineView1CenterXAnchor?.isActive = true
                    cell.dotAndLineView1WidthAnchor?.isActive = true
                    cell.dotAndLineView1HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView2TopAnchor?.isActive = true
                    cell.dotAndLineView2CenterXAnchor?.isActive = true
                    cell.dotAndLineView2WidthAnchor?.isActive = true
                    cell.dotAndLineView2HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView3TopAnchor?.isActive = true
                    cell.dotAndLineView3CenterXAnchor?.isActive = true
                    cell.dotAndLineView3WidthAnchor?.isActive = true
                    cell.dotAndLineView3HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView4TopAnchor?.isActive = true
                    cell.dotAndLineView4CenterXAnchor?.isActive = true
                    cell.dotAndLineView4WidthAnchor?.isActive = true
                    cell.dotAndLineView4HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView1.isHidden = false
                    cell.dotAndLineView2.isHidden = false
                    cell.dotAndLineView3.isHidden = false
                    cell.dotAndLineView4.isHidden = false
                case 5:
                    cell.dotAndLineView1TopAnchor?.isActive = false
                    cell.dotAndLineView1WidthAnchor?.isActive = false
                    cell.dotAndLineView1HeightAnchor?.isActive = false
                    cell.dotAndLineView1CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView2TopAnchor?.isActive = false
                    cell.dotAndLineView2WidthAnchor?.isActive = false
                    cell.dotAndLineView2HeightAnchor?.isActive = false
                    cell.dotAndLineView2CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView3TopAnchor?.isActive = false
                    cell.dotAndLineView3WidthAnchor?.isActive = false
                    cell.dotAndLineView3HeightAnchor?.isActive = false
                    cell.dotAndLineView3CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView4TopAnchor?.isActive = false
                    cell.dotAndLineView4WidthAnchor?.isActive = false
                    cell.dotAndLineView4HeightAnchor?.isActive = false
                    cell.dotAndLineView4CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView5TopAnchor?.isActive = false
                    cell.dotAndLineView5WidthAnchor?.isActive = false
                    cell.dotAndLineView5HeightAnchor?.isActive = false
                    cell.dotAndLineView5CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView1TopAnchor = cell.dotAndLineView1.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor)
                    cell.dotAndLineView1WidthAnchor = cell.dotAndLineView1.widthAnchor.constraint(equalToConstant: cell.frame.width * 0.1)
                    cell.dotAndLineView1HeightAnchor = cell.dotAndLineView1.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.1)
                    cell.dotAndLineView1CenterXAnchor = cell.dotAndLineView1.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: -6)
                    
                    cell.dotAndLineView2TopAnchor = cell.dotAndLineView2.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor)
                    cell.dotAndLineView2WidthAnchor = cell.dotAndLineView2.widthAnchor.constraint(equalToConstant: cell.frame.width * 0.1)
                    cell.dotAndLineView2HeightAnchor = cell.dotAndLineView2.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.1)
                    cell.dotAndLineView2CenterXAnchor = cell.dotAndLineView2.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: -2.5)
                    
                    cell.dotAndLineView3TopAnchor = cell.dotAndLineView3.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor)
                    cell.dotAndLineView3WidthAnchor = cell.dotAndLineView3.widthAnchor.constraint(equalToConstant: cell.frame.width * 0.1)
                    cell.dotAndLineView3HeightAnchor = cell.dotAndLineView3.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.1)
                    cell.dotAndLineView3CenterXAnchor = cell.dotAndLineView3.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView4TopAnchor = cell.dotAndLineView4.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor)
                    cell.dotAndLineView4WidthAnchor = cell.dotAndLineView4.widthAnchor.constraint(equalToConstant: cell.frame.width * 0.1)
                    cell.dotAndLineView4HeightAnchor = cell.dotAndLineView4.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.1)
                    cell.dotAndLineView4CenterXAnchor = cell.dotAndLineView4.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: 2.5)
                    
                    cell.dotAndLineView5TopAnchor = cell.dotAndLineView5.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor)
                    cell.dotAndLineView5WidthAnchor = cell.dotAndLineView5.widthAnchor.constraint(equalToConstant: cell.frame.width * 0.1)
                    cell.dotAndLineView5HeightAnchor = cell.dotAndLineView5.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.1)
                    cell.dotAndLineView5CenterXAnchor = cell.dotAndLineView5.centerXAnchor.constraint(equalTo: cell.centerXAnchor, constant: 6)
                    
                    cell.dotAndLineView1TopAnchor?.isActive = true
                    cell.dotAndLineView1CenterXAnchor?.isActive = true
                    cell.dotAndLineView1WidthAnchor?.isActive = true
                    cell.dotAndLineView1HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView2TopAnchor?.isActive = true
                    cell.dotAndLineView2CenterXAnchor?.isActive = true
                    cell.dotAndLineView2WidthAnchor?.isActive = true
                    cell.dotAndLineView2HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView3TopAnchor?.isActive = true
                    cell.dotAndLineView3CenterXAnchor?.isActive = true
                    cell.dotAndLineView3WidthAnchor?.isActive = true
                    cell.dotAndLineView3HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView4TopAnchor?.isActive = true
                    cell.dotAndLineView4CenterXAnchor?.isActive = true
                    cell.dotAndLineView4WidthAnchor?.isActive = true
                    cell.dotAndLineView4HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView5TopAnchor?.isActive = true
                    cell.dotAndLineView5CenterXAnchor?.isActive = true
                    cell.dotAndLineView5WidthAnchor?.isActive = true
                    cell.dotAndLineView5HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView1.isHidden = false
                    cell.dotAndLineView2.isHidden = false
                    cell.dotAndLineView3.isHidden = false
                    cell.dotAndLineView4.isHidden = false
                    cell.dotAndLineView5.isHidden = false
                    
                default:
                    print("no event")
                    
                }
            } else {
                let event = eventDictionary[indexPath.item]!
                var eventCategoryList: [Int] = []
                
                for i in event {
                    eventCategoryList.append(i.categoryIdx)
                }
                
                print("here \(indexPath.item)")
                
                
                switch eventNum {
                case 1:
                    cell.dotAndLineView1TopAnchor?.isActive = false
                    cell.dotAndLineView1WidthAnchor?.isActive = false
                    cell.dotAndLineView1HeightAnchor?.isActive = false
                    cell.dotAndLineView1CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView1TopAnchor = cell.dotAndLineView1.topAnchor.constraint(equalTo: cell.lbl.bottomAnchor, constant: 4)
                    cell.dotAndLineView1WidthAnchor = cell.dotAndLineView1.widthAnchor.constraint(equalToConstant: cell.frame.width)
                    cell.dotAndLineView1HeightAnchor = cell.dotAndLineView1.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.08)
                    cell.dotAndLineView1CenterXAnchor = cell.dotAndLineView1.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView1TopAnchor?.isActive = true
                    cell.dotAndLineView1WidthAnchor?.isActive = true
                    cell.dotAndLineView1HeightAnchor?.isActive = true
                    cell.dotAndLineView1CenterXAnchor?.isActive = true
                    
                    cell.dotAndLineView1.isHidden = false
                case 2:
                    //1
                    cell.dotAndLineView1WidthAnchor?.isActive = false
                    cell.dotAndLineView1HeightAnchor?.isActive = false
                    cell.dotAndLineView1CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView1WidthAnchor = cell.dotAndLineView1.widthAnchor.constraint(equalToConstant: cell.bounds.width)
                    cell.dotAndLineView1HeightAnchor = cell.dotAndLineView1.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.08)
                    cell.dotAndLineView1CenterXAnchor = cell.dotAndLineView1.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView1CenterXAnchor?.isActive = true
                    cell.dotAndLineView1WidthAnchor?.isActive = true
                    cell.dotAndLineView1HeightAnchor?.isActive = true

                    
                    //2
                    cell.dotAndLineView2TopAnchor?.isActive = false
                    cell.dotAndLineView2WidthAnchor?.isActive = false
                    cell.dotAndLineView2HeightAnchor?.isActive = false
                    cell.dotAndLineView2CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView2TopAnchor = cell.dotAndLineView2.topAnchor.constraint(equalTo: cell.dotAndLineView1.bottomAnchor, constant: 2.5)
                    cell.dotAndLineView2WidthAnchor = cell.dotAndLineView2.widthAnchor.constraint(equalToConstant: cell.bounds.width)
                    cell.dotAndLineView2HeightAnchor = cell.dotAndLineView2.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.08)
                    cell.dotAndLineView2CenterXAnchor = cell.dotAndLineView2.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView2TopAnchor?.isActive = true
                    cell.dotAndLineView2WidthAnchor?.isActive = true
                    cell.dotAndLineView2HeightAnchor?.isActive = true
                    cell.dotAndLineView2CenterXAnchor?.isActive = true

                    
                    cell.dotAndLineView1.isHidden = false
                    cell.dotAndLineView2.isHidden = false
                case 3:
                    //1
                    cell.dotAndLineView1WidthAnchor?.isActive = false
                    cell.dotAndLineView1HeightAnchor?.isActive = false
                    cell.dotAndLineView1CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView1WidthAnchor = cell.dotAndLineView1.widthAnchor.constraint(equalToConstant: cell.bounds.width)
                    cell.dotAndLineView1HeightAnchor = cell.dotAndLineView1.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.08)
                    cell.dotAndLineView1CenterXAnchor = cell.dotAndLineView1.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView1CenterXAnchor?.isActive = true
                    cell.dotAndLineView1WidthAnchor?.isActive = true
                    cell.dotAndLineView1HeightAnchor?.isActive = true
                    

                    
                    //2
                    cell.dotAndLineView2TopAnchor?.isActive = false
                    cell.dotAndLineView2WidthAnchor?.isActive = false
                    cell.dotAndLineView2HeightAnchor?.isActive = false
                    cell.dotAndLineView2CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView2TopAnchor = cell.dotAndLineView2.topAnchor.constraint(equalTo: cell.dotAndLineView1.bottomAnchor, constant: 2.5)
                    
                    cell.dotAndLineView2WidthAnchor = cell.dotAndLineView2.widthAnchor.constraint(equalToConstant: cell.bounds.width)
                    cell.dotAndLineView2HeightAnchor = cell.dotAndLineView2.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.08)
                    cell.dotAndLineView2CenterXAnchor = cell.dotAndLineView2.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView2TopAnchor?.isActive = true
                    cell.dotAndLineView2WidthAnchor?.isActive = true
                    cell.dotAndLineView2HeightAnchor?.isActive = true
                    cell.dotAndLineView2CenterXAnchor?.isActive = true

                    
                    //3
                    cell.dotAndLineView3TopAnchor?.isActive = false
                    cell.dotAndLineView3WidthAnchor?.isActive = false
                    cell.dotAndLineView3HeightAnchor?.isActive = false
                    cell.dotAndLineView3CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView3TopAnchor = cell.dotAndLineView3.topAnchor.constraint(equalTo: cell.dotAndLineView2.bottomAnchor, constant: 2.5)
                    
                    cell.dotAndLineView3WidthAnchor = cell.dotAndLineView3.widthAnchor.constraint(equalToConstant: cell.bounds.width)
                    cell.dotAndLineView3HeightAnchor = cell.dotAndLineView3.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.08)
                    cell.dotAndLineView3CenterXAnchor = cell.dotAndLineView3.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView3TopAnchor?.isActive = true
                    cell.dotAndLineView3WidthAnchor?.isActive = true
                    cell.dotAndLineView3HeightAnchor?.isActive = true
                    cell.dotAndLineView3CenterXAnchor?.isActive = true
                    

                    cell.dotAndLineView1.isHidden = false
                    cell.dotAndLineView2.isHidden = false
                    cell.dotAndLineView3.isHidden = false
                case 4:
                    //1
                    cell.dotAndLineView1WidthAnchor?.isActive = false
                    cell.dotAndLineView1HeightAnchor?.isActive = false
                    cell.dotAndLineView1CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView2TopAnchor?.isActive = false
                    cell.dotAndLineView2WidthAnchor?.isActive = false
                    cell.dotAndLineView2HeightAnchor?.isActive = false
                    cell.dotAndLineView2CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView3TopAnchor?.isActive = false
                    cell.dotAndLineView3WidthAnchor?.isActive = false
                    cell.dotAndLineView3HeightAnchor?.isActive = false
                    cell.dotAndLineView3CenterXAnchor?.isActive = false

                    cell.dotAndLineView4TopAnchor?.isActive = false
                    cell.dotAndLineView4WidthAnchor?.isActive = false
                    cell.dotAndLineView4HeightAnchor?.isActive = false
                    cell.dotAndLineView4CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView1WidthAnchor = cell.dotAndLineView1.widthAnchor.constraint(equalToConstant: cell.bounds.width)
                    cell.dotAndLineView1HeightAnchor = cell.dotAndLineView1.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.08)
                    cell.dotAndLineView1CenterXAnchor = cell.dotAndLineView1.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView2TopAnchor = cell.dotAndLineView2.topAnchor.constraint(equalTo: cell.dotAndLineView1.bottomAnchor, constant: 2.5)
                    cell.dotAndLineView2WidthAnchor = cell.dotAndLineView2.widthAnchor.constraint(equalToConstant: cell.bounds.width)
                    cell.dotAndLineView2HeightAnchor = cell.dotAndLineView2.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.08)
                    cell.dotAndLineView2CenterXAnchor = cell.dotAndLineView2.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView3TopAnchor = cell.dotAndLineView3.topAnchor.constraint(equalTo: cell.dotAndLineView2.bottomAnchor, constant: 2.5)
                    cell.dotAndLineView3WidthAnchor = cell.dotAndLineView3.widthAnchor.constraint(equalToConstant: cell.bounds.width)
                    cell.dotAndLineView3HeightAnchor = cell.dotAndLineView3.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.08)
                    cell.dotAndLineView3CenterXAnchor = cell.dotAndLineView3.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView4TopAnchor = cell.dotAndLineView4.topAnchor.constraint(equalTo: cell.dotAndLineView3.bottomAnchor, constant: 2.5)
                    cell.dotAndLineView4WidthAnchor = cell.dotAndLineView4.widthAnchor.constraint(equalToConstant: cell.bounds.width)
                    cell.dotAndLineView4HeightAnchor = cell.dotAndLineView4.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.08)
                    cell.dotAndLineView4CenterXAnchor = cell.dotAndLineView4.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView1CenterXAnchor?.isActive = true
                    cell.dotAndLineView1WidthAnchor?.isActive = true
                    cell.dotAndLineView1HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView2TopAnchor?.isActive = true
                    cell.dotAndLineView2WidthAnchor?.isActive = true
                    cell.dotAndLineView2HeightAnchor?.isActive = true
                    cell.dotAndLineView2CenterXAnchor?.isActive = true
                    
                    cell.dotAndLineView3TopAnchor?.isActive = true
                    cell.dotAndLineView3WidthAnchor?.isActive = true
                    cell.dotAndLineView3HeightAnchor?.isActive = true
                    cell.dotAndLineView3CenterXAnchor?.isActive = true
                    
                    cell.dotAndLineView4TopAnchor?.isActive = true
                    cell.dotAndLineView4WidthAnchor?.isActive = true
                    cell.dotAndLineView4HeightAnchor?.isActive = true
                    cell.dotAndLineView4CenterXAnchor?.isActive = true


                    
                    cell.dotAndLineView1.isHidden = false
                    cell.dotAndLineView2.isHidden = false
                    cell.dotAndLineView3.isHidden = false
                    cell.dotAndLineView4.isHidden = false
                    
                case 5:
                    //1
                    
                    cell.dotAndLineView1WidthAnchor?.isActive = false
                    cell.dotAndLineView1HeightAnchor?.isActive = false
                    cell.dotAndLineView1CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView2TopAnchor?.isActive = false
                    cell.dotAndLineView2WidthAnchor?.isActive = false
                    cell.dotAndLineView2HeightAnchor?.isActive = false
                    cell.dotAndLineView2CenterXAnchor?.isActive = false

                    cell.dotAndLineView3TopAnchor?.isActive = false
                    cell.dotAndLineView3WidthAnchor?.isActive = false
                    cell.dotAndLineView3HeightAnchor?.isActive = false
                    cell.dotAndLineView3CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView4TopAnchor?.isActive = false
                    cell.dotAndLineView4WidthAnchor?.isActive = false
                    cell.dotAndLineView4HeightAnchor?.isActive = false
                    cell.dotAndLineView4CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView5TopAnchor?.isActive = false
                    cell.dotAndLineView5WidthAnchor?.isActive = false
                    cell.dotAndLineView5HeightAnchor?.isActive = false
                    cell.dotAndLineView5CenterXAnchor?.isActive = false
                    
                    cell.dotAndLineView1WidthAnchor = cell.dotAndLineView1.widthAnchor.constraint(equalToConstant: cell.bounds.width)
                    cell.dotAndLineView1HeightAnchor = cell.dotAndLineView1.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.08)
                    cell.dotAndLineView1CenterXAnchor = cell.dotAndLineView1.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView2TopAnchor = cell.dotAndLineView2.topAnchor.constraint(equalTo: cell.dotAndLineView1.bottomAnchor, constant: 2.5)
                    cell.dotAndLineView2WidthAnchor = cell.dotAndLineView2.widthAnchor.constraint(equalToConstant: cell.bounds.width)
                    cell.dotAndLineView2HeightAnchor = cell.dotAndLineView2.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.08)
                    cell.dotAndLineView2CenterXAnchor = cell.dotAndLineView2.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView3TopAnchor = cell.dotAndLineView3.topAnchor.constraint(equalTo: cell.dotAndLineView2.bottomAnchor, constant: 2.5)
                    cell.dotAndLineView3WidthAnchor = cell.dotAndLineView3.widthAnchor.constraint(equalToConstant: cell.bounds.width)
                    cell.dotAndLineView3HeightAnchor = cell.dotAndLineView3.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.08)
                    cell.dotAndLineView3CenterXAnchor = cell.dotAndLineView3.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView4TopAnchor = cell.dotAndLineView4.topAnchor.constraint(equalTo: cell.dotAndLineView3.bottomAnchor, constant: 2.5)
                    cell.dotAndLineView4WidthAnchor = cell.dotAndLineView4.widthAnchor.constraint(equalToConstant: cell.bounds.width)
                    cell.dotAndLineView4HeightAnchor = cell.dotAndLineView4.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.08)
                    cell.dotAndLineView4CenterXAnchor = cell.dotAndLineView4.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView5TopAnchor = cell.dotAndLineView5.topAnchor.constraint(equalTo: cell.dotAndLineView4.bottomAnchor, constant: 2.5)
                    cell.dotAndLineView5WidthAnchor = cell.dotAndLineView5.widthAnchor.constraint(equalToConstant: cell.bounds.width)
                    cell.dotAndLineView5HeightAnchor = cell.dotAndLineView5.heightAnchor.constraint(equalToConstant: cell.frame.height * 0.08)
                    cell.dotAndLineView5CenterXAnchor = cell.dotAndLineView5.centerXAnchor.constraint(equalTo: cell.centerXAnchor)
                    
                    cell.dotAndLineView1CenterXAnchor?.isActive = true
                    cell.dotAndLineView1WidthAnchor?.isActive = true
                    cell.dotAndLineView1HeightAnchor?.isActive = true
                    
                    cell.dotAndLineView2TopAnchor?.isActive = true
                    cell.dotAndLineView2WidthAnchor?.isActive = true
                    cell.dotAndLineView2HeightAnchor?.isActive = true
                    cell.dotAndLineView2CenterXAnchor?.isActive = true
                    
                    cell.dotAndLineView3TopAnchor?.isActive = true
                    cell.dotAndLineView3WidthAnchor?.isActive = true
                    cell.dotAndLineView3HeightAnchor?.isActive = true
                    cell.dotAndLineView3CenterXAnchor?.isActive = true
                    
                    cell.dotAndLineView4TopAnchor?.isActive = true
                    cell.dotAndLineView4WidthAnchor?.isActive = true
                    cell.dotAndLineView4HeightAnchor?.isActive = true
                    cell.dotAndLineView4CenterXAnchor?.isActive = true
                    
                    cell.dotAndLineView5TopAnchor?.isActive = true
                    cell.dotAndLineView5WidthAnchor?.isActive = true
                    cell.dotAndLineView5HeightAnchor?.isActive = true
                    cell.dotAndLineView5CenterXAnchor?.isActive = true

                    cell.dotAndLineView1.isHidden = false
                    cell.dotAndLineView2.isHidden = false
                    cell.dotAndLineView3.isHidden = false
                    cell.dotAndLineView4.isHidden = false
                    cell.dotAndLineView5.isHidden = false
                    
                    
                default:
                    print("no event")
                }
        }
        
        cell.dotAndLineView1.backgroundColor = UIColor(displayP3Red: 96 / 255, green: 118 / 255, blue: 221 / 255, alpha: 1.0)
        cell.dotAndLineView2.backgroundColor = UIColor(displayP3Red: 7 / 255, green: 166 / 255, blue: 255 / 255, alpha: 1.0)
        cell.dotAndLineView3.backgroundColor = UIColor(displayP3Red: 254 / 255, green: 109 / 255, blue: 109 / 255, alpha: 1.0)
        cell.dotAndLineView4.backgroundColor = UIColor(displayP3Red: 255 / 255, green: 160 / 255, blue: 160 / 255, alpha: 1.0)
        cell.dotAndLineView5.backgroundColor = .black
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! DayCollectionViewCell
        
        cell.lbl.layer.cornerRadius = cell.lbl.frame.height / 2
        cell.lbl.backgroundColor = .clear
        cell.backgroundColor = .clear
        
        var beforeMonthIndex = 0
        var beforeYear = 0 //이번달의 전 달이 어떤날에 해당하는지 확인!!
        
        if currentMonth == 1 { //이번달이 1월이면 이전달은 12월
            beforeMonthIndex = 12
            beforeYear = currentYear - 1
        } else {
            beforeMonthIndex = currentMonth - 1
            beforeYear = currentYear
        }
        
        var beforeMonthCount = numOfDaysInMonth[beforeMonthIndex-1]
        if beforeMonthIndex == 2 {
            if currentYear % 4 == 0 {
                beforeMonthCount = numOfDaysInMonth[beforeMonthIndex-1] + 1
            } else {
                beforeMonthCount = numOfDaysInMonth[beforeMonthIndex-1]
            }
        }
        
        var nextYear = 0
        var nextMonth = 0
        
        if currentMonth == 12 {
            nextYear = currentYear + 1
            nextMonth = 1
        } else {
            nextYear = currentYear
            nextMonth = currentMonth + 1
        }
        var nextDay = 0
        
        if indexPath.item <= firstWeekDayOfMonth - 2 { //이전달의 표현해야 하는 날짜들
            cell.isHidden=false
            cell.lbl.textColor = UIColor.rgb(red: 224, green: 224, blue: 224)
            cell.lbl.text = "\(beforeMonthCount-firstWeekDayOfMonth+indexPath.row+2)"
            if currentDay == beforeMonthCount-firstWeekDayOfMonth+indexPath.row+2 {
                
            }
            cell.isUserInteractionEnabled=false
        } else { //오늘 이후 날짜
            let calcDate = indexPath.row-firstWeekDayOfMonth+2 //1~31일까지
            cell.isHidden=false
            cell.lbl.text="\(calcDate)"
            cell.isUserInteractionEnabled=true
            cell.lbl.textColor = Style.activeCellLblColor
            cell.lbl.backgroundColor = .clear
            
            if calcDate == currentDay && currentYear == presentYear && currentMonth == presentMonthIndex { //오늘날짜
                todaysIndexPath = indexPath
                let lbl = cell.subviews[1] as! UILabel
//                lbl.layer.cornerRadius = (cell.frame.width * 0.47) / 2
                lbl.layer.cornerRadius = lbl.frame.height / 2
                lbl.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.7921568627, blue: 0.2862745098, alpha: 1)
                lbl.textColor=UIColor.white
            }
            
            if indexPath.row % 7 == 0 {
                cell.lbl.textColor = .red
            }
            
            nextDay = (calcDate + firstWeekDayOfMonth - 1) - (numOfDaysInMonth[currentMonth-1] + firstWeekDayOfMonth - 1)
            //다음달 일수 출력
            if nextDay >= 1 {
                let calcDate = nextDay
                cell.isHidden=false
                cell.lbl.text="\(calcDate)"
                cell.isUserInteractionEnabled=false
                cell.lbl.textColor = .lightGray
            }
        }
        
        var cellYear = currentYear
        var cellMonth = currentMonth
        var cellDay = indexPath.row-firstWeekDayOfMonth+2
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 00:00:00"
        
        var currentCellDateTime = formatter.date(from: cellDateString)
        
        eventDictionary[indexPath.row] = []
        
        for tuple in posterTuples {
            //현재 셀의 연, 월 , 일 == tuple의 연 월 일이 모두 같아야만 그려준다.
            if let currentCellDate = currentCellDateTime {
                let currentCellYear = Calendar.current.component(.year, from: currentCellDate)
                let currentCellMonth = Calendar.current.component(.month, from: currentCellDate)
                let currentCellDay = Calendar.current.component(.day, from: currentCellDate)
                let currentPosterYear = Calendar.current.component(.year, from: tuple.endDate)
                let currentPosterMonth = Calendar.current.component(.month, from: tuple.endDate)
                let currentPosterDay = Calendar.current.component(.day, from: tuple.endDate)
                
                if (currentCellYear ==  currentPosterYear) && (currentCellMonth == currentPosterMonth) && (currentCellDay == currentPosterDay) {
                    
                    print("그려라라라라 \(currentCellDate) \(tuple.categoryIdx)  \(tuple.endDate.addingTimeInterval(60.0 * 60.0 * 9.0))")
                    
                    print("\(currentCellYear) \(currentCellMonth) \(currentCellDay) | \(currentPosterYear) \(currentPosterMonth) \(currentPosterDay) ")
                    
                    //Dictionary에 이벤트 추가
                    eventDictionary[indexPath.row]?.append(event.init(eventDate: tuple.endDate, title: tuple.title, categoryIdx: tuple.categoryIdx))
                }
            }
        }
        
//        let date1 = "2019-02-11 14:59:59"
//        let date2 = "2019-02-11 15:59:59"
//        let date3 = "2019-02-11 16:59:59"
//        let date4 = "2019-02-11 16:59:59"
//
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
//
//        let endDate1 = dateFormatter.date(from: date1)!
//        let endDate2 = dateFormatter.date(from: date2)!
//        let endDate3 = dateFormatter.date(from: date3)!
//        let endDate4 = dateFormatter.date(from: date4)!
        
        //        eventDictionary[indexPath.row]?.append(event.init(eventDate: endDate1, title: "가가", categoryIdx: 1))
        //
        //        eventDictionary[indexPath.row]?.append(event.init(eventDate: endDate2, title: "니나", categoryIdx: 2))
        //
        //        eventDictionary[indexPath.row]?.append(event.init(eventDate: endDate3, title: "다다", categoryIdx: 3))
        
        //        eventDictionary[indexPath.row]?.append(event.init(eventDate: endDate3, title: "라라", categoryIdx: 3))
        //
        //        eventDictionary[indexPath.row]?.append(event.init(eventDate: endDate3, title: "바바", categoryIdx: 3))
        
//        if indexPath.item == 15 {
//            eventDictionary[indexPath.row]?.append(event.init(eventDate: endDate1, title: "가가", categoryIdx: 1))
//
//            eventDictionary[indexPath.row]?.append(event.init(eventDate: endDate2, title: "니나", categoryIdx: 2))
//
//            eventDictionary[indexPath.row]?.append(event.init(eventDate: endDate3, title: "다다", categoryIdx: 3))
//
//            eventDictionary[indexPath.row]?.append(event.init(eventDate: endDate3, title: "라라", categoryIdx: 3))
//
//            eventDictionary[indexPath.row]?.append(event.init(eventDate: endDate3, title: "바바", categoryIdx: 3))
//        }
        
        drawDotAndLineView(indexPath, cell)
        
        print(" indexPath \(indexPath.item)")
        
        let calcDate = indexPath.row - firstWeekDayOfMonth+2 //1~31일까지
        //다른달에 갔다 올때 오늘 날짜의 색
        if lastSelectedDate != nil && calcDate == currentDay && currentYear == presentYear && currentMonth == presentMonthIndex{
            todaysIndexPath = indexPath
            let lbl = cell.subviews[1] as! UILabel
//            lbl.layer.cornerRadius = (cell.frame.width * 0.47) / 2
            lbl.layer.cornerRadius = lbl.frame.height / 2
            lbl.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.7921568627, blue: 0.2862745098, alpha: 1)
            lbl.textColor = UIColor.white
        }
        
        if currentCellDateTime == nil {
            //전달이면
            if indexPath.row < 15 {
                cellYear = beforeYear
                cellMonth = beforeMonthIndex
                cellDay = beforeMonthCount-firstWeekDayOfMonth+indexPath.row+2
                
                cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 00:00:00"
                currentCellDateTime = formatter.date(from: cellDateString)
            } else {
                cellYear = nextYear
                cellMonth = nextMonth
                cellDay = nextDay
                
                cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 00:00:00"
                currentCellDateTime = formatter.date(from: cellDateString)
            }
        }
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        
        let year = components.year!
        let month = components.month!
        let day = components.day!
        
        let currentDateString: String = "\(year)-\(month)-\(day) 00:00:00"
        //        let todayDate = formatter.date(from: currentDateString)
        
        if indexPath == lastSelectedIndexPath {
            cell.lbl.backgroundColor = UIColor.lightGray
            cell.lbl.textColor = UIColor.white
        }
        
        currentPosterTuple = []
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        let lbl = cell?.subviews[1] as! UILabel
        lbl.layer.cornerRadius = lbl.frame.height / 2
        
        lbl.backgroundColor = UIColor.lightGray
        lbl.textColor = UIColor.white
        
        let cellYear = currentYear
        let cellMonth = currentMonth
        let cellDay = indexPath.row - firstWeekDayOfMonth+2
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let cellDateString = "\(cellYear)-\(cellMonth)-\(cellDay) 00:00:00"
        let currentCellDateTime = formatter.date(from: cellDateString)
        
        lastSelectedDate = currentCellDateTime//현재 선택된 셀의 date객체
        lastSelectedIndexPath = indexPath
        
        //CalendarVC에 지금 선택된 날짜를 전송하자.
        let userInfo = [ "currentCellDateTime" : currentCellDateTime ]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "todoUpByDaySelected"), object: nil, userInfo: userInfo as [AnyHashable : Any])
    }
    
    //새로운 셀 선택시 이전셀 복구
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath) as! DayCollectionViewCell
        let lbl = cell.subviews.last as! UILabel
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = Style.activeCellLblColor
        
        if indexPath.row % 7 == 0 { //일요일
            lbl.textColor = UIColor.red
            lbl.backgroundColor = UIColor.clear
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: currentDate)
        
        let year = components.year!
        let month = components.month!
        let day = components.day!
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let currentDateString: String = "\(year)-\(month)-\(day) 00:00:00"
        let todayDate = formatter.date(from: currentDateString)
        
        if lastSelectedDate == todayDate{ //마지막 선택된 날짜가 오늘이라면
            lbl.backgroundColor = #colorLiteral(red: 0.1176470588, green: 0.7921568627, blue: 0.2862745098, alpha: 1)
            lbl.textColor = UIColor.white
        }
    }
    
}

//MARK:- CollectionView Layout
extension CalenderView: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.inset(by: collectionView.layoutMargins).width / 7
        
        
        var height = collectionView.bounds.inset(by: collectionView.layoutMargins).height / 7
        
        if reValue == 35 {
            height = collectionView.bounds.inset(by: collectionView.layoutMargins).height / 5
        } else {
            height = collectionView.bounds.inset(by: collectionView.layoutMargins).height / 6
        }
        
        return CGSize(width: width, height: height)
    }
    
    //minimumLineSpacing  (세로)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    //minimumInteritemSpacing  (가로)
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
