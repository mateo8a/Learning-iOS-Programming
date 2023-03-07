//
//  ImageSelector.swift
//  Mandala
//
//  Created by Mateo Ochoa on 2023-03-06.
//

import UIKit

class ImageSelector: UIControl {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViewHierarchy()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureViewHierarchy()
    }
    
    var selectedIndex = 0 {
        didSet {
            let imageButton = imageButtons[selectedIndex]
            highlightViewXConstraint = highlightView.centerXAnchor.constraint(equalTo: imageButton.centerXAnchor)
            highlightView.backgroundColor = highlightColor(forIndex: selectedIndex)
        }
    }
    
    private var imageButtons = [UIButton]() {
        didSet {
            oldValue.forEach { $0.removeFromSuperview() }
            imageButtons.forEach { selectorStackView.addArrangedSubview($0) }
        }
    }
    
    var images = [UIImage]() {
        didSet {
            imageButtons = images.map { image in
                let imageButton = UIButton()
                
                imageButton.setImage(image, for: .normal)
                imageButton.imageView?.contentMode = .scaleAspectFit
                imageButton.addTarget(self, action: #selector(imageButtonTapped(_:)), for: .touchUpInside)
                
                return imageButton
            }
            selectedIndex = 0
        }
    }
    
    var highlightColors = [UIColor]() {
        didSet {
            highlightView.backgroundColor = highlightColor(forIndex: selectedIndex)
        }
    }
    
    private func highlightColor(forIndex index: Int) -> UIColor {
        return highlightColors[index]
    }
    
    @objc private func imageButtonTapped(_ sender: UIButton) {
        guard let buttonIndex = imageButtons.firstIndex(of: sender) else {
            preconditionFailure("The buttons and images are not parallel.")
        }
        
        let selectionAnimator = UIViewPropertyAnimator(
            duration: 0.5,
            dampingRatio: 0.5,
            animations: {
                self.selectedIndex = buttonIndex
                self.layoutIfNeeded()
            }
        )
        
        selectionAnimator.startAnimation()
        sendActions(for: .valueChanged)
    }
    
    private let highlightView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let selectorStackView: UIStackView = {
        let stackView = UIStackView()
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        stackView.spacing = 12.0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        return stackView
    }()
    
    private func configureViewHierarchy() {
        addSubview(selectorStackView)
        insertSubview(highlightView, belowSubview: selectorStackView)
        
        NSLayoutConstraint.activate([
            selectorStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            selectorStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            selectorStackView.topAnchor.constraint(equalTo: topAnchor),
            selectorStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            highlightView.heightAnchor.constraint(equalTo: highlightView.widthAnchor),
            highlightView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9),
            highlightView.centerYAnchor.constraint(equalTo: selectorStackView.centerYAnchor)
        ])
    }
    
    private var highlightViewXConstraint: NSLayoutConstraint! {
        didSet {
            oldValue?.isActive = false
            highlightViewXConstraint.isActive = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        highlightView.layer.cornerRadius = highlightView.bounds.height / 2.0
    }
}
