//
//  HeaderView.swift
//  Lucky-Test-burguer
//
//  Created by Miguel Angel Saravia Belmonte on 1/15/23.
//

import UIKit

final class HeaderView: UIView {
    
    private var sizeTitle: CGFloat?
    private var colorText: UIColor?
    private var offertValue: Int?
    private var title: String
    private var titleType: TitleType
    private var topConstrain: NSLayoutConstraint?
    
    private lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        return title
    }()
    
    required init(sizeTitle: CGFloat? = nil,
                  colorText: UIColor? = nil,
                  title: String,
                  titleType: TitleType,
                  offertValue: Int? = nil, frame: CGRect) {
        self.sizeTitle = sizeTitle
        self.colorText = colorText
        self.title = title
        self.titleType = titleType
        self.offertValue = offertValue
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        backgroundColor = .defaultColor
        addSubview(titleLabel)
        
        let offert = offertValue ?? 0
        topConstrain = titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: offert == 0 ? 0 : 15)
        topConstrain?.isActive = true
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
        configDefaultValuesLabel(size: sizeTitle, color: colorText)
    }
    
    private func configDefaultValuesLabel(size: CGFloat? = 12, color: UIColor? = .black) {
        if let currentSize = size {
            switch titleType {
            case .LIGHT:
                titleLabel.font =  UIFont.systemFont(ofSize: currentSize, weight: UIFont.Weight.light)
            case .BOLD:
                titleLabel.font =  UIFont.systemFont(ofSize: currentSize, weight: UIFont.Weight.bold)
            case .MEDIUM:
                titleLabel.font =  UIFont.systemFont(ofSize: currentSize, weight: UIFont.Weight.medium)
            }
        }
        if let currentColor = color {
            titleLabel.textColor = currentColor
        }
        
        if let offert = offertValue {
            titleLabel.text = "\(offert) \(title)"
        } else {
            titleLabel.text = title
        }
    }
}
