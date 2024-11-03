//
//  FramesTableViewController.swift
//  YaAnimator
//
//  Created by Vlad Eliseev on 30.10.2024.
//

import UIKit

final class FrameTableViewCell: UITableViewCell {
    
    private let frameTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .boldSystemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    private let previewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(frame: Frame, frameTitle: String) {
        frameTitleLabel.text = frameTitle
        self.previewImageView.image = nil
        DispatchQueue.global().async {
            guard let currentFrameImageData = try? Data(contentsOf: frame.frameSource) else { return }
            DispatchQueue.main.async {
                let image = UIImage(data: currentFrameImageData)
                self.previewImageView.image = image
            }
        }
    }
    
    private func setup() {
        contentView.addSubview(previewImageView)
        contentView.addSubview(frameTitleLabel)
        
        NSLayoutConstraint.activate([
            frameTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            frameTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            frameTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            frameTitleLabel.heightAnchor.constraint(equalToConstant: 20),
            
            previewImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            previewImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            previewImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            previewImageView.bottomAnchor.constraint(equalTo: frameTitleLabel.topAnchor, constant: -16)
        ])
    }
}

protocol FramesTableViewControllerDelegate: AnyObject {
    
    func didSelectFrame(frame: Frame)
}

class FramesTableViewController: UIViewController {
    
    private let tableView = UITableView()
    
    private let framesManager: FramesManager
    
    weak var delegate: FramesTableViewControllerDelegate?
    
    init(framesManager: FramesManager) {
        self.framesManager = framesManager
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        ])

        self.tableView.register(FrameTableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }
}

extension FramesTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return framesManager.frames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath) as! FrameTableViewCell
        let frame = framesManager.frames[indexPath.row]
        cell.configure(frame: frame, frameTitle: "Frame \(indexPath.row)")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.didSelectFrame(frame: framesManager.frames[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
}
