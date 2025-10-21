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
    
   
    
    @objc func scanNewQRCode(){
        print("scanning")
    }
    
    @objc func layoutChanged() {
        if segmentedControl.selectedSegmentIndex == 0 {
            print("Grid layout selected")
        } else {
            print("List layout selected")
        }
    }

    
    private func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical

        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
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
        
        cell.onQRCodeTapped = {
            print("Tapped QR at \(indexPath.item + 1)")
        }

        return cell
        
    }
}
    


