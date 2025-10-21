import UIKit

class QRModalViewController: UIViewController {

    private let qrImage: UIImage

    init(qrImage: UIImage) {
        self.qrImage = qrImage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let imageView = UIImageView(image: qrImage)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)

        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
        ])
    }
}

/* function to present qrcode modal in main view controller
 
 func presentQRCodeModal(qrImage: UIImage) {
     let modalVC = QRModalViewController(qrImage: qrImage)
     modalVC.modalPresentationStyle = .pageSheet

     if let sheet = modalVC.sheetPresentationController {
         sheet.detents = [.medium()]
         sheet.prefersGrabberVisible = true
     }

     present(modalVC, animated: true)
}
 */
