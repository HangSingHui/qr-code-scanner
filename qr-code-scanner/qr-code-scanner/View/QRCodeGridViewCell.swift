import UIKit

class QRCodeGridViewCell: UICollectionViewCell {
    
    static let identifier = "QRCodeGridViewCell"
    
    private let qrImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.tintColor = .label
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let linkLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.numberOfLines = 2
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
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
        
        NSLayoutConstraint.activate([
            qrImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            qrImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            qrImageView.widthAnchor.constraint(equalToConstant: 80),
            qrImageView.heightAnchor.constraint(equalToConstant: 80),
            
            linkLabel.topAnchor.constraint(equalTo: qrImageView.bottomAnchor, constant: 8),
            linkLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            linkLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            
            timeLabel.topAnchor.constraint(equalTo: linkLabel.bottomAnchor, constant: 4),
            timeLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 4),
            timeLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            timeLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with qrImage: UIImage, description: String, timestamp: String) {
        qrImageView.image = qrImage
        linkLabel.text = description
        timeLabel.text = timestamp
    }
}
