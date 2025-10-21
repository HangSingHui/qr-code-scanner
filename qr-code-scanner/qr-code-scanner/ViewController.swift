//
//  ViewController.swift
//  qr-code-scanner
//
//  Created by Gernaine Heng on 21/10/25.
//

import UIKit
import AVFoundation
import QRScanner

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    private var qrCodes: [QRCodeItem] = []
    
    private var qrScannerView: QRScannerView?
    
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
    
    private func setupQRScanner() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupQRScannerView()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async { [weak self] in
                        self?.setupQRScannerView()
                    }
                }
            }
        default:
            showAlert()
        }
    }
    
    private func setupQRScannerView() {
        if qrScannerView != nil { return }

        let scanner = QRScannerView(frame: view.bounds)
        view.addSubview(scanner)
        scanner.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        scanner.startRunning()
        qrScannerView = scanner
    }

    private func showAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let alert = UIAlertController(title: "Error", message: "Camera is required to use in this application", preferredStyle: .alert)
            alert.addAction(.init(title: "OK", style: .default))
            self?.present(alert, animated: true)
        }
    }
    
    func removeQRScannerView() {
        qrScannerView?.stopRunning()
        qrScannerView?.removeFromSuperview()
        qrScannerView = nil
    }
    
    @objc func scanNewQRCode() {
        setupQRScanner()
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
        collectionView.register(QRCodeGridViewCell.self,
                                forCellWithReuseIdentifier: QRCodeGridViewCell.identifier)
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
        //qrCodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
               withReuseIdentifier: QRCodeGridViewCell.identifier,
               for: indexPath
           ) as? QRCodeGridViewCell else {
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
        
//        let item = qrCodes[indexPath.item]
//        cell.configure(with: item.image, description: item.description, timestamp: item.timestamp)
//        cell.onQRCodeTapped = { [weak self] in
//            guard let self = self else { return }
//            self.presentQRCodeModal(qrImage: item.image)
//        }
//        
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

extension ViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error)
        removeQRScannerView()
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String) {
        print("Scanned code:", code)
        
        guard let qrImage = generateQRCode(from: code) else {
            print("Failed to generate QR code image")
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yy HH:mm"
        let timestamp = formatter.string(from: Date())
        let newItem = QRCodeItem(image: qrImage, description: code, timestamp: timestamp)
        qrCodes.append(newItem)
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.removeQRScannerView()
        }
    }

}

#Preview {
    ViewController()
}

