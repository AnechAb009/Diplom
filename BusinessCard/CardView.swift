//
//  CardView.swift
//  BusinessCard
//
//  Created by Maksim Kolesnik on 02/04/2019.
//  Copyright © 2019 Maksim Kolesnik. All rights reserved.
//

import UIKit
import SuperPuperDuperLayout
import Wallet

struct BCardModelContainer: Equatable {
    var model: BCardModel
    //    var qrCode: UIImage
    var qrCode: QRCode
}

struct BCardModel: Codable, Equatable {
    var name: String?
    var lastname: String?
    var patronymic: String?
    var phone1: String?
    var phone2: String?
    var isStudent: Bool
    var mail: String?
    var address: String?
    var facul: String?
    var group: String?
    var uid: String?

    
}

class BCardView: CardView {
    lazy var nameLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        label.textColor = UIColor(r: 31, g: 58, b: 149, a: 1)
        label.text = "nameLabel"
        return label
    }()
    
    lazy var patronymicLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.semibold)
        label.textColor = UIColor(r: 31, g: 58, b: 149, a: 1)
        label.text = "patronymicLabel"
        return label
    }()
    
    lazy var phoneLabel1: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "phoneLabel1"
        label.textColor = UIColor(r: 31, g: 58, b: 149, a: 1)
        return label
    }()
    
    lazy var phoneLabel2: UILabel = {
        let label = UILabel(frame: .zero)
        //        label.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        label.text = "phoneLabel2"
        label.textColor = UIColor(r: 31, g: 58, b: 149, a: 1)
        return label
    }()
    
    lazy var mailLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "mailLabel"
        label.textColor = UIColor(r: 31, g: 58, b: 149, a: 1)
        return label
    }()
    
    lazy var organizationLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "organizationLabel"
        label.textColor = UIColor(r: 31, g: 58, b: 149, a: 1)
        return label
    }()
    
    lazy var addressLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textAlignment = NSTextAlignment.center
        label.text = "addressLabel"
        label.textColor = UIColor(r: 31, g: 58, b: 149, a: 1)
        return label
    }()
    
    lazy var faculLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "faculLabel"
        label.textColor = UIColor(r: 31, g: 58, b: 149, a: 1)
        return label
    }()
    
    lazy var groupLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "groupLabel"
        label.textColor = UIColor(r: 31, g: 58, b: 149, a: 1)
        return label
    }()
    
    
    lazy var qrImageView: QRCodeView = {
        let image = QRCodeView(frame: .zero)
        image.contentMode = UIView.ContentMode.scaleAspectFit
        return image
    }()
    
    lazy var backImageView: UIImageView = {
        let image = UIImageView(frame: .zero)
        image.contentMode = UIView.ContentMode.scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = self.cornerRadius
        image.image = UIImage(named: "back")
        return image
    }()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layout()
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented")  }
    
    func layout() {
        containerView.removeFromSuperview()
        addSubview(containerView)
        containerView.backgroundColor = .green
        Layout.to(containerView, {
            $0.edges.equalToSuperview.value(.zero)
        })
        containerView.addSubview(backImageView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(patronymicLabel)
        containerView.addSubview(phoneLabel1)
        containerView.addSubview(phoneLabel2)
        containerView.addSubview(mailLabel)
        containerView.addSubview(organizationLabel)
        containerView.addSubview(addressLabel)
        containerView.addSubview(qrImageView)
        containerView.addSubview(faculLabel)
        containerView.addSubview(groupLabel)
        
        
        
        
        Layout.to(backImageView, {
            $0.edges.equalToSuperview.value(.zero)
        })
        
        Layout.to(nameLabel, {
            $0.leading.equalToSuperview.leading.value(16)
            $0.top.equalToSuperview.top.value(94)
        })
        
        Layout.to(patronymicLabel, {
            $0.leading.equalToSuperview.leading.value(16)
            $0.top.equalToSuperview.top.value(118)
        })
        
        
        Layout.to(addressLabel, {
            $0.leading.equalToSuperview.leading.value(16)
            $0.trailing.equalToSuperview.trailing.value(-16)
            $0.top.equal(to: mailLabel).bottom.value(10)
        })
        
        Layout.to(qrImageView, {
            $0.trailing.equalToSuperview.trailing.value(-16)
            $0.top.equalToSuperview.top.value(16)
            $0.size.equal.value(.init(width: 100, height: 100))
        })
        
        Layout.to(phoneLabel1, {
            $0.trailing.equalToSuperview.trailing.value(-16)
            $0.top.equal(to: qrImageView).bottom.value(8)
        })
        
        Layout.to(phoneLabel2, {
            $0.trailing.equalToSuperview.trailing.value(-16)
            $0.top.equal(to: phoneLabel1).bottom.value(8)
        })
        
        Layout.to(mailLabel, {
            $0.trailing.equalToSuperview.trailing.value(-16)
            $0.top.equal(to: phoneLabel2).bottom.value(8)
        })
        
        if _model?.model.isStudent ?? false {
            Layout.to(groupLabel, {
                $0.leading.equalToSuperview.leading.value(16)
                $0.top.equal(to: patronymicLabel).bottom.value(12)
            })            
        }
        Layout.to(faculLabel, {
            $0.leading.equalToSuperview.leading.value(16)
            $0.top.equal(to: groupLabel).bottom.value(8)
        })
        
        
        
        layer.backgroundColor = UIColor.clear.cgColor
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 1.0)
        layer.shadowOpacity = 0.2
        layer.shadowRadius = 4.0
        
        // set the cornerRadius of the containerView's layer
        containerView.layer.cornerRadius = cornerRadius
        containerView.layer.masksToBounds = true
    }
    let containerView = UIView()
    
    var _model: BCardModelContainer?
    
    func setup(with model: BCardModelContainer) {
        _model = model
        if let name = model.model.name, let lastname = model.model.lastname {
            self.nameLabel.text = "\(name) \(lastname) "
            
        }
        self.patronymicLabel.text = model.model.patronymic
        self.phoneLabel1.text = model.model.phone1
        self.phoneLabel2.text = model.model.phone2
        self.mailLabel.text = model.model.mail
        self.addressLabel.text = model.model.address
        self.groupLabel.text = model.model.group
        self.faculLabel.text = model.model.facul
        
        self.qrImageView.qrCode = model.qrCode
        
        
        DispatchQueue.main.async { [weak self] in
            self?.layoutIfNeeded()
            self?.layout()

        }
        layout()

        
    }
    private var shadowLayer: CAShapeLayer!
    private var cornerRadius: CGFloat = 10
    private var fillColor: UIColor = .blue // the color applied to the shadowLayer, rather than the view's backgroundColor
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //        if shadowLayer == nil {
        //            shadowLayer = CAShapeLayer()
        //
        //            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        //            shadowLayer.fillColor = fillColor.cgColor
        //
        //            shadowLayer.shadowColor = UIColor.black.cgColor
        //            shadowLayer.shadowPath = shadowLayer.path
        //            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        //            shadowLayer.shadowOpacity = 0.2
        //            shadowLayer.shadowRadius = 3
        //
        //            layer.insertSublayer(shadowLayer, at: 0)
        //        }
    }
}
