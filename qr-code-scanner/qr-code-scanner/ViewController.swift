//
//  ViewController.swift
//  qr-code-scanner
//
//  Created by Gernaine Heng on 21/10/25.
//

import UIKit
import AVFoundation
import QRScanner

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    
    enum LayoutStyle {
        case grid
        case list
    }

    private var currentLayoutStyle: LayoutStyle = .grid
    
    private var qrCodes: [QRCodeItem] = []
    
    private var qrScannerView: QRScannerView?
    
    private var collectionView: UICollectionView!
    
    private var segmentedControl = UISegmentedControl(items: ["Grid", "List"])
    
    //Layout toggle
    private var gridLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(
            width: (UIScreen.main.bounds.width - 30) / 2,
            height: (UIScreen.main.bounds.width - 30) / 2 + 40
        )
        return layout
    }()

    private var listLayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.itemSize = CGSize(
            width: UIScreen.main.bounds.width - 20,
            height: 100 //
            
        )
        return layout
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Background
        view.backgroundColor = UIColor.white

        // Navigation title
        navigationItem.title = "My QR Codes"
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.systemBlue,
            .font: UIFont.systemFont(ofSize: 20, weight: .bold)
        ]

        // Add segmented control below navigation bar
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        segmentedControl.addTarget(self, action: #selector(layoutChanged), for: .valueChanged)

        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            segmentedControl.heightAnchor.constraint(equalToConstant: 32)
        ])

        // Right add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(scanNewQRCode)
        )

        setupCollectionView()
        setupLayout()
        loadDummyData()
    }

    
    private func loadDummyData() {
            let dummyItems = [
                QRCodeItem(image: generateQRCode(from: "https://www.apple.com") ?? UIImage(systemName: "qrcode")!,
                          description: "https://www.apple.com",
                          timestamp: "21/10/25 10:30"),
                QRCodeItem(image: generateQRCode(from: "https://www.google.com") ?? UIImage(systemName: "qrcode")!,
                          description: "https://www.google.com",
                          timestamp: "21/10/25 11:45"),
                QRCodeItem(image: generateQRCode(from: "Test QR Code 1234") ?? UIImage(systemName: "qrcode")!,
                          description: "Test QR Code 1234",
                          timestamp: "21/10/25 12:15"),
                QRCodeItem(image: generateQRCode(from: "https://github.com") ?? UIImage(systemName: "qrcode")!,
                          description: "https://github.com",
                          timestamp: "21/10/25 14:20"),
                QRCodeItem(image: generateQRCode(from: "Sample Text") ?? UIImage(systemName: "qrcode")!,
                          description: "Sample Text",
                          timestamp: "21/10/25 15:00")
            ]
            qrCodes.append(contentsOf: dummyItems)
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
        currentLayoutStyle = segmentedControl.selectedSegmentIndex == 0 ? .grid : .list
        let layout = currentLayoutStyle == .grid ? gridLayout : listLayout

        UIView.performWithoutAnimation {
            collectionView.setCollectionViewLayout(layout, animated: false)
            collectionView.reloadData()
            collectionView.collectionViewLayout.invalidateLayout()
            collectionView.layoutIfNeeded()
        }
    }


    private func setupCollectionView() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: gridLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        collectionView.register(QRCodeGridViewCell.self,
                                forCellWithReuseIdentifier: QRCodeGridViewCell.identifier)
        collectionView.register(QRCodeListViewCell.self,
                                forCellWithReuseIdentifier: QRCodeListViewCell.identifier)

        view.addSubview(collectionView)
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 8),
                    collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       // 10
        return qrCodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let item = qrCodes[indexPath.item]
        
        if currentLayoutStyle == .grid {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QRCodeGridViewCell.identifier, for: indexPath) as! QRCodeGridViewCell
            cell.configure(with: item.image, description: item.description, timestamp: item.timestamp)
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: QRCodeListViewCell.identifier, for: indexPath) as! QRCodeListViewCell
            cell.configure(with: item.image, description: item.description, timestamp: item.timestamp)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = qrCodes[indexPath.item]
        presentQRCodeModal(qrImage: item.image)
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
            self.presentQRCodeModal(qrImage: qrImage)
        }
    }
}
