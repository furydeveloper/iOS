//
//  TheaterCategoryReservationView.swift
//  MegaBox
//
//  Created by Fury on 18/07/2019.
//  Copyright © 2019 Fury. All rights reserved.
//

import UIKit

class TheaterCategoryReservationView: UIView {
  private let shared = MovieDataManager.shared
  var delegate: TheaterCategoryReservationViewDelegate?
  
  let headerView = TheaterCategoryReservationHeaderView()
  
  private var screenCount: Int = 0
  private var movieTitleIdx: Int = 0
  
  private let menuTitleView: UIView = {
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  private let menuTitleDismissButton: UIButton = {
    let button = UIButton(type: .custom)
    button.setImage(#imageLiteral(resourceName: "common_btn_topbar_prev2"), for: .normal)
    button.contentMode = .scaleAspectFit
    button.addTarget(self, action: #selector(touchUpMenuTitleDismissButton(_:)), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
  
  private let menuTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "영화관별 예매"
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let theaterTableView: UITableView = {
    let tableView = UITableView()
    tableView.register(TheaterCategorySectionCell.self, forCellReuseIdentifier: TheaterCategorySectionCell.identifier)
    tableView.register(TheaterCategoryCell.self, forCellReuseIdentifier: TheaterCategoryCell.identifier)
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    theaterTableView.dataSource = self
    theaterTableView.delegate = self
    
    setupProperties()
  }
  
  @objc private func touchUpMenuTitleDismissButton(_ sender: UIButton) {
    delegate?.touchUpMenuTitleDismissButton(sender)
  }
  
  private func calculateMoviesData() {
    
  }
  
  private func setupProperties() {
    self.addSubview(menuTitleView)
    menuTitleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
    menuTitleView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    menuTitleView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    
    self.addSubview(menuTitleLabel)
    menuTitleLabel.topAnchor.constraint(equalTo: menuTitleView.topAnchor, constant: 15).isActive = true
    menuTitleLabel.centerXAnchor.constraint(equalTo: menuTitleView.centerXAnchor).isActive = true
    menuTitleLabel.centerYAnchor.constraint(equalTo: menuTitleView.centerYAnchor).isActive = true
    menuTitleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    
    self.addSubview(menuTitleDismissButton)
    menuTitleDismissButton.leadingAnchor.constraint(equalTo: menuTitleView.leadingAnchor).isActive = true
    menuTitleDismissButton.centerYAnchor.constraint(equalTo: menuTitleView.centerYAnchor).isActive = true
    
    self.addSubview(theaterTableView)
    theaterTableView.topAnchor.constraint(equalTo: menuTitleView.bottomAnchor).isActive = true
    theaterTableView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
    theaterTableView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
    theaterTableView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension TheaterCategoryReservationView: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    let titleCount = shared.sortedTheaterMovieTitle.count
    var screenTotalCount: Int = 0
    
    for (_, data) in shared.sortedTheaterMovieTitle.enumerated() {
      
      screenTotalCount += shared.theaterCategoryDetailMovie[data]!.count
    }
    
    return titleCount + screenTotalCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    if indexPath.row == screenCount {
      let movie = shared.sortedTheaterMovieTitle[movieTitleIdx]
      let screenCount = shared.theaterCategoryDetailMovie[movie]?.count ?? 0
      self.screenCount += (screenCount + 1)
      
      let cell = tableView.dequeueReusableCell(withIdentifier: TheaterCategorySectionCell.identifier, for: indexPath) as! TheaterCategorySectionCell
      
      movieTitleIdx += 1

      let grade = shared.theaterCategoryMovie[movie]![0].age

      var gradeImage = #imageLiteral(resourceName: "booking_middle_filrm_rating_all")
      if grade == "전체 관람" {
        gradeImage = #imageLiteral(resourceName: "booking_middle_filrm_rating_all")
      } else if grade == "12세 관람가" {
        gradeImage = #imageLiteral(resourceName: "booking_middle_filrm_rating_12")
      } else if grade == "15세 관람가" {
        gradeImage = #imageLiteral(resourceName: "booking_middle_filrm_rating_15")
      } else {
        gradeImage = #imageLiteral(resourceName: "booking_middle_filrm_rating_18")
      }
      cell.cellConfigure(gradeImage, movie)
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: TheaterCategoryCell.identifier, for: indexPath) as! TheaterCategoryCell
      return cell
    }
  }
}

extension TheaterCategoryReservationView: UITableViewDelegate {
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    // 해더뷰 고정 해제
    let scrollHeaderHeight = ((UIScreen.main.bounds.width * 495) / 844) - 50
    if scrollView.contentOffset.y <= scrollHeaderHeight {
      if scrollView.contentOffset.y >= 0 {
        scrollView.contentInset = UIEdgeInsets(top: -scrollView.contentOffset.y, left: 0, bottom: 0, right: 0)
      }
    } else if scrollView.contentOffset.y > scrollHeaderHeight {
      scrollView.contentInset = UIEdgeInsets(top: -scrollHeaderHeight, left: 0, bottom: 0, right: 0)
    }
  }
  
  // Tableview Header
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    return headerView
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return (UIScreen.main.bounds.width * 495) / 844
  }
}
