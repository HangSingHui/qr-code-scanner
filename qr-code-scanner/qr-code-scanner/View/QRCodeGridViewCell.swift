//
//  QRCodeViewCell.swift
//  qr-code-scanner
//
//  Created by Sing Hui Hang on 21/10/25.
//

import UIKit

class QRCodeGridViewCell: UICollectionViewCell {

    static let identifier = "QRCodeGridViewCell"

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
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var onQRCodeTapped: (() -> Void)?

    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 12
        contentView.backgroundColor = .systemBackground
        contentView.layer.shadowColor = UIColor.black.cgColor
        contentView.layer.shadowOpacity = 0.05
        contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        contentView.layer.shadowRadius = 4

        contentView.addSubview(qrImageView)
        contentView.addSubview(linkLabel)
        contentView.addSubview(timeLabel)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(qrTapped))
        qrImageView.addGestureRecognizer(tapGesture)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize = contentView.bounds.width * 0.4

        qrImageView.frame = CGRect(
            x: (contentView.bounds.width - imageSize) / 2,
            y: 10,
            width: imageSize,
            height: imageSize
        )
        let descriptionHeight = linkLabel.sizeThatFits(CGSize(width: contentView.bounds.width - 10, height: CGFloat.greatestFiniteMagnitude)).height

        linkLabel.frame = CGRect(
            x: 5,
            y: qrImageView.frame.maxY + 8,
            width: contentView.bounds.width - 10,
            height: descriptionHeight
        )
        timeLabel.frame = CGRect(
            x: 5,
            y: linkLabel.frame.maxY + 2,
            width: contentView.bounds.width - 10,
            height: 18
        )

    }
    
    // MARK: - Configuration
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
