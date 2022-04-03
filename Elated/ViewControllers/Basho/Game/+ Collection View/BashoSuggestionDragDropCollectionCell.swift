//
//  BashoSuggestionDragDropCollectionCell.swift
//  Elated
//
//  Created by Marlon on 8/7/21.
//  Copyright © 2021 elatedteam. All rights reserved.
//

import UIKit

class BashoSuggestionDragDropCollectionCell: UICollectionViewCell {
    
    static let identifier = "BashoSuggestionDragDropCollectionCell"
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .futuraMedium(14)
        label.textColor = .sonicSilver
        return label
    }()
    
    private let view: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = .palePurplePantone
        return view
    }()
    
    var model: WordSuggestion!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubViews() {
        
        contentView.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        contentView.layer.borderColor = UIColor.white.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 15
        
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(30)
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.left.right.equalToSuperview().inset(12)
        }
                
    }
    
    func updateData(_ model: WordSuggestion){
        self.model = model
        if !model.word.isEmpty {
            selectedStatus()
            label.text = model.word
        }else{
            normalStatus()
            label.text = ""
        }
    }
    
    func hasContent() -> Bool {
        return !model.word.isEmpty
    }
    
    func moveOverStatus(){
        backgroundColor = UIColor.clear
        view.backgroundColor = UIColor.clear
    }
    
    func normalStatus(){
        backgroundColor = UIColor.clear
        view.backgroundColor = .palePurplePantone
    }
    
    func selectedStatus(){
        backgroundColor = UIColor.clear
        view.backgroundColor = .palePurplePantone
    }
    
}
