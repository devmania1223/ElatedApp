//
//  LanguageDataProvider.swift
//  Elated
//
//  Created by John Lester Celis on 1/29/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class LanguageDataProvider: NSObject {
    
    var contentList: [String] = ["Arabic",
                                 "Chinese",
                                 "English",
                                 "French",
                                 "German",
                                 "Hindi",
                                 "Italian",
                                 "Portugese",
                                 "Russian",
                                 "Spanish"]
    
    var selectedLanguages = BehaviorRelay<[String]>(value: [])

    override init() {
        super.init()
        
        //do any config
    }
    
}

extension LanguageDataProvider: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      self.contentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let content = contentList[indexPath.row]
        let isSelected = selectedLanguages.value.firstIndex(of: content) != nil
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectionLanguageTableViewCell.identifier,
                                                    for: indexPath) as? SelectionLanguageTableViewCell  ?? SelectionLanguageTableViewCell()
        cell.configureCell(content, checked: isSelected)
        return cell
    }
    
}

extension LanguageDataProvider: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var selected = selectedLanguages.value
        let content = contentList[indexPath.row]
        
        if let existing = selectedLanguages.value.firstIndex(of: content) {
            selected.remove(at: existing)
        } else {
            selected.append(content)
        }
         
        selectedLanguages.accept(selected)
        tableView.reloadData()
    }
    
}
