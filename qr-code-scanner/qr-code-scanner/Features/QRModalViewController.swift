import UIKit

class QRModalViewController: UIViewController {

    private let item: QRCodeItem

    init(item: QRCodeItem) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    private func setupUI() {
        // MARK: - UI elements
        
        let titleLabel: UILabel = {
            let label = UILabel()
            label.text = "Hold another device to scan this code"
            label.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()

        let imageView: UIImageView = {
            let imageView = UIImageView(image: item.image)
            imageView.contentMode = .scaleAspectFit
            return imageView
        }()

        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = item.description
            label.font = UIFont.systemFont(ofSize: 16)
            label.textAlignment = .center
            label.numberOfLines = 0
            return label
        }()

        let timestampLabel: UILabel = {
            let label = UILabel()
            label.text = "Scanned: " + item.timestamp
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .secondaryLabel
            label.textAlignment = .center
            return label
        }()

        let openLinkButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Open Link", for: .normal)
            button.addTarget(self, action: #selector(openLinkTapped), for: .touchUpInside)
            return button
        }()

        // MARK: - Stack View

        let stack: UIStackView = {
            let stack = UIStackView(arrangedSubviews: [
                titleLabel,
                imageView,
                descriptionLabel,
                timestampLabel,
                openLinkButton
            ])
            stack.axis = .vertical
            stack.spacing = 16
            stack.alignment = .center
            return stack
        }()

        // MARK: - Layout

        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        imageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }

    @objc private func openLinkTapped() {
        guard let url = URL(string: item.description),
              UIApplication.shared.canOpenURL(url) else {
            let alert = UIAlertController(
                title: "Invalid Link",
                message: "URL not valid.",
                preferredStyle: .alert
            )
            alert.addAction(.init(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        UIApplication.shared.open(url)
    }
}
