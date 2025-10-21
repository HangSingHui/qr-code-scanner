//
//  ViewController.swift
//  qr-code-scanner
//
//  Created by Gernaine Heng on 21/10/25.
//

import UIKit


class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    private var collectionView: UICollectionView!
    
    private var segmentedControl = UISegmentedControl(items: ["Grid", "List"])
    
    //Layout toggle
     private var gridLayout: UICollectionViewFlowLayout = {
         let layout = UICollectionViewFlowLayout()
         let width = (UIScreen.main.bounds.width - 30) / 2
         layout.itemSize = CGSize(width: width, height: width)
         layout.minimumInteritemSpacing = 10
         layout.minimumLineSpacing = 10
         return layout
     }()

     private var listLayout: UICollectionViewFlowLayout = {
         let layout = UICollectionViewFlowLayout()
         let width = UIScreen.main.bounds.width - 20
         layout.itemSize = CGSize(width: width, height: 80)
         layout.minimumLineSpacing = 10
         return layout
     }()
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.titleView = segmentedControl
        //Setup segmented control
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.addTarget(self, action: #selector(layoutChanged), for: .valueChanged)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(scanNewQRCode)
        )
            
        setupCollectionView()
        setupLayout()
    }
    
   
    
//    @objc func scanNewQRCode(){
//        print("scanning")
//    }
    
    @objc func scanNewQRCode(){
        let linkText = "https://google.com"
        if let qrImage = generateQRCode(from: linkText) {
            presentQRCodeModal(qrImage: qrImage)
        } else {
            print("Failed to generate QR code")
        }
    }

    
    @objc private func layoutChanged() {
        let layout = segmentedControl.selectedSegmentIndex == 0 ? gridLayout : listLayout
        collectionView.setCollectionViewLayout(layout, animated: true)
    }


    
    private func setupCollectionView() {
//        let layout = UICollectionViewFlowLayout()
//
//
//        layout.itemSize = CGSize(width: 100, height: 100)
//        layout.minimumLineSpacing = 10
//        layout.minimumInteritemSpacing = 10
//        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(QRCodeCollectionViewCell.self,
                                forCellWithReuseIdentifier: QRCodeCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
    }


    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
               withReuseIdentifier: QRCodeCollectionViewCell.identifier,
               for: indexPath
           ) as? QRCodeCollectionViewCell else {
               fatalError("Unable to dequeue QRCodeCollectionViewCell")
           }
        
        let dummyImage = UIImage(systemName: "qrcode")!
        let dummyDescription = "QR Code \(indexPath.item + 1)"
        let dummyTimestamp = "21/10/25"
        
        cell.configure(with: dummyImage, description: dummyDescription, timestamp: dummyTimestamp)
        
        cell.onQRCodeTapped = { [weak self] in
            guard let self = self else { return }
            let dummyImage = UIImage(systemName: "qrcode")!
            self.presentQRCodeModal(qrImage: dummyImage)
        }

        return cell
        
    }

    func presentQRCodeModal(qrImage: UIImage) {
        let modalVC = QRModalViewController(qrImage: qrImage)
        modalVC.modalPresentationStyle = .pageSheet
        
        if let sheet = modalVC.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        
        present(modalVC, animated: true)
    }
    
    private func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)

        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            filter.setValue("Q", forKey: "inputCorrectionLevel")
            
            if let outputImage = filter.outputImage {
                let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
                return UIImage(ciImage: scaledImage)
            }
        }

        return nil
    }

}
    

#Preview {
    ViewController()
}

