//
//  QRCodeListViewCell.swift
//  qr-code-scanner
//
//  Created by Gernaine Heng on 21/10/25.
//

import UIKit

class QRCodeListViewCell: UICollectionViewCell {
    
    static let identifier = "QRCodeListViewCell"
    
    // MARK: - UI components
    
    let qrImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.tintColor = .label
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let linkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var onQRCodeTapped: (() -> Void)?
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.05
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4
        
        contentView.addSubview(qrImageView)
        contentView.addSubview(linkLabel)
        contentView.addSubview(timeLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(qrTapped))
        contentView.addGestureRecognizer(tapGesture)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Constraints

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            qrImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            qrImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            qrImageView.widthAnchor.constraint(equalToConstant: 60),
            qrImageView.heightAnchor.constraint(equalToConstant: 60),
            
            linkLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            linkLabel.leadingAnchor.constraint(equalTo: qrImageView.trailingAnchor, constant: 12),
            linkLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            timeLabel.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: linkLabel.leadingAnchor),
            timeLabel.trailingAnchor.constraint(equalTo: linkLabel.trailingAnchor),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    // MARK: - configure
    func configure(with qrImage: UIImage, description: String, timestamp: String) {
        qrImageView.image = qrImage
        linkLabel.text = description
        timeLabel.text = timestamp
    }
    
    // MARK: - Action
    @objc private func qrTapped() {
        onQRCodeTapped?()
    }
}
