import UIKit
import SuperPuperDuperLayout
import MagicalRecord

class CardViewController: UIViewController {
    lazy var cardView: BCardView = {
        let cardView = BCardView(frame: .zero)
        return cardView
    }()
    
    
    
    
    //
    //    @NSManaged public var name: String?
    //    @NSManaged public var patronymic: String?
    //    @NSManaged public var phone: String?
    //    @NSManaged public var mail: String?
    //    @NSManaged public var organization: String?
    //    @NSManaged public var address: String?
    //    @NSManaged public var lastname: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.bookmarks, tag: 1)
        view.backgroundColor = .white
        view.addSubview(cardView)
        Layout.to(cardView, {
            $0.top.equalToSuperview.top.value(80)
            $0.leading.equalToSuperview.leading.value(8)
            $0.trailing.equalToSuperview.trailing.value(-8)
            $0.height.equal.value(UIScreen.main.bounds.width * 0.75)
        })
        let defaults = UserDefaults.standard

        if defaults.string(forKey: "name") != nil {
            reload()
        } else {
            DispatchQueue.main.async { [weak self] in

                let vc = AddCardViewController(nibName: nil, bundle: nil)
                vc.delegate = self
                let nav = UINavigationController(rootViewController: vc)
                self?.present(nav, animated: true, completion: nil)

            }
        }
        
        let gest = UITapGestureRecognizer(target: self, action: #selector(tap(_:)))
        cardView.addGestureRecognizer(gest)

    }
    
    @objc
    func tap(_ gest: UITapGestureRecognizer) {
        let vc = AddCardViewController(nibName: nil, bundle: nil)
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        self.present(nav, animated: true, completion: nil)
        
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "name") ?? ""
        let patronymic = defaults.string(forKey: "patronymic") ?? ""
        let phone1 = defaults.string(forKey: "phone1") ?? ""
        let phone2 = defaults.string(forKey: "phone2") ?? ""
        let mail = defaults.string(forKey: "mail") ?? ""
        let address = defaults.string(forKey: "address") ?? ""
        let lastname = defaults.string(forKey: "lastname") ?? ""
        let group = defaults.string(forKey: "group")
        let facul = defaults.string(forKey: "facul")
        let isStudent = defaults.bool(forKey: "isStudent")
        let uid = defaults.string(forKey: "uid")

        let model = BCardModel(name: name,
                               lastname: lastname,
                               patronymic: patronymic,
                               phone1: phone1,
                               phone2: phone2,
                               isStudent: isStudent,
                               mail: mail,
                               address: address,
                               facul: facul,
                               group: group,
                               uid: uid)
        
        vc.update(with: model)
    }
    
    func reload() {
        let defaults = UserDefaults.standard
        let name = defaults.string(forKey: "name") ?? ""
        let patronymic = defaults.string(forKey: "patronymic") ?? ""
        let phone1 = defaults.string(forKey: "phone1") ?? ""
        let phone2 = defaults.string(forKey: "phone2") ?? ""
        let mail = defaults.string(forKey: "mail") ?? ""
        let address = defaults.string(forKey: "address") ?? ""
        let lastname = defaults.string(forKey: "lastname") ?? ""
        let group = defaults.string(forKey: "group")
        let facul = defaults.string(forKey: "facul")
        let uid = defaults.string(forKey: "uid")
        let isStudent = defaults.bool(forKey: "isStudent")
        
        

//        let red = CGFloat(Int.random(in: 0 ..< 255))
//        let green = CGFloat(Int.random(in: 0 ..< 255))
//        let blue = CGFloat(Int.random(in: 0 ..< 255))
        
//        cardView.backgroundColor = UIColor(red: red / 255, green: green / 255, blue: blue / 255, alpha: 1)
        do {
            let model = BCardModel(name: name,
                                   lastname: lastname,
                                   patronymic: patronymic,
                                   phone1: phone1,
                                   phone2: phone2,
                                   isStudent: isStudent,
                                   mail: mail,
                                   address: address,
                                   facul: facul,
                                   group: group,
                                   uid: uid)
            let data = try JSONEncoder().encode(model)
            let qrCode = QRCode(data: data)
            //                let image = try qrCode.image()
            let container = BCardModelContainer.init(model: model, qrCode: qrCode)
            cardView.setup(with: container)
        } catch {
            
        }
    }
}

extension CardViewController: AddCardViewControllerOut {
    func save(_ model: BCardModel) {
        let defaults = UserDefaults.standard

        defaults.set(model.name, forKey: "name")
        defaults.set(model.lastname, forKey: "lastname")
        defaults.set(model.patronymic, forKey: "patronymic")
        defaults.set(model.mail, forKey: "mail")
        defaults.set(model.group, forKey: "group")
        defaults.set(model.facul, forKey: "facul")
        defaults.set(model.isStudent, forKey: "isStudent")
        defaults.set(model.address, forKey: "address")
        defaults.set(model.phone1, forKey: "phone1")
        defaults.set(model.phone2, forKey: "phone2")
        reload()
    }
}

protocol AddCardViewControllerOut: AnyObject {
    func save(_ model: BCardModel)
}

class AddCardViewController: UIViewController {
    
    weak var delegate: AddCardViewControllerOut?

    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: ["Студент", "Сотрудник"])
        segmentedControl.selectedSegmentIndex = 0
        return segmentedControl
    }()

    lazy var nameLabel: UITextField = {
        let label = UITextField(frame: .zero)
        label.borderStyle = .roundedRect
        label.placeholder = "Имя"
        return label
    }()
    
    lazy var lastnameLabel: UITextField = {
        let label = UITextField(frame: .zero)
        label.borderStyle = .roundedRect
        label.placeholder = "Фамилия"
        return label
    }()
    
    lazy var patronymicLabel: UITextField = {
        let label = UITextField(frame: .zero)
        label.borderStyle = .roundedRect
        label.placeholder = "Отчество"
        return label
    }()
    
    lazy var phoneLabel1: UITextField = {
        let label = UITextField(frame: .zero)
        label.borderStyle = .roundedRect
        label.placeholder = "Номер телефона 1"
        return label
    }()
    
    lazy var phoneLabel2: UITextField = {
        let label = UITextField(frame: .zero)
        label.borderStyle = .roundedRect
        label.placeholder = "Номер телефона 2"
        return label
    }()
    
    lazy var mailLabel: UITextField = {
        let label = UITextField(frame: .zero)
        label.borderStyle = .roundedRect
        label.placeholder = "Почта"
        return label
    }()
    
    lazy var addressLabel: UITextField = {
        let label = UITextField(frame: .zero)
        label.borderStyle = .roundedRect
        label.placeholder = "Адрес"
        return label
    }()
    
    lazy var groupLabel: UITextField = {
        let label = UITextField(frame: .zero)
        label.borderStyle = .roundedRect
        label.placeholder = "Группа"
        return label
    }()
    
    lazy var faculLabel: UITextField = {
        let label = UITextField(frame: .zero)
        label.borderStyle = .roundedRect
        label.placeholder = "Факультет"
        return label
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDoneButton()
        view.backgroundColor = .white
        view.addSubview(segmentedControl)

        Layout.to(segmentedControl, {
            $0.top.equalToSuperview.top.value(80)
            $0.leading.equalToSuperview.leading.value(16)
            $0.trailing.equalToSuperview.trailing.value(-16)
        })
        
        segmentedControl.addTarget(self, action: #selector(change(_:)), for: UIControl.Event.valueChanged)
        self.rebild()
    }
    var _model: BCardModel?
    func update(with model: BCardModel) {
        _model = model
        self.nameLabel.text = model.name
        self.lastnameLabel.text = model.lastname
        self.patronymicLabel.text = model.patronymic
        self.phoneLabel1.text = model.phone1
        self.phoneLabel2.text = model.phone2
        self.mailLabel.text = model.mail
        self.addressLabel.text = model.address
        self.faculLabel.text = model.facul
        self.groupLabel.text = model.group
        self.segmentedControl.selectedSegmentIndex = model.isStudent ? 0 : 1
//        let model = BCardModel(name: ,
//                               lastname: self.lastnameLabel.text,
//                               patronymic: self.patronymicLabel.text,
//                               phone1: self.phoneLabel1.text,
//                               phone2: self.phoneLabel2.text,
//                               isStudent: self.segmentedControl.selectedSegmentIndex == 0,
//                               mail: self.mailLabel.text,
//                               address: self.addressLabel.text,
//                               facul: self.faculLabel.text,
//                               group: self.groupLabel.text)

        
        self.rebild()
        
    }
    
    func rebild() {
        nameLabel.removeFromSuperview()
        lastnameLabel.removeFromSuperview()
        patronymicLabel.removeFromSuperview()
        phoneLabel1.removeFromSuperview()
        phoneLabel2.removeFromSuperview()
        mailLabel.removeFromSuperview()
        addressLabel.removeFromSuperview()
        groupLabel.removeFromSuperview()
        faculLabel.removeFromSuperview()

        view.addSubview(nameLabel)
        view.addSubview(lastnameLabel)
        view.addSubview(patronymicLabel)
        view.addSubview(phoneLabel1)
        view.addSubview(phoneLabel2)
        view.addSubview(mailLabel)
        view.addSubview(addressLabel)
        
        view.addSubview(groupLabel)
        view.addSubview(faculLabel)
        
        
        
        
        Layout.to(nameLabel, {
            $0.top.equal(to: segmentedControl).bottom.value(8)
            $0.leading.equalToSuperview.leading.value(16)
            $0.trailing.equalToSuperview.trailing.value(-16)
        })
        
        Layout.to(lastnameLabel, {
            $0.top.equal(to: nameLabel).bottom.value(8)
            $0.leading.equalToSuperview.leading.value(16)
            $0.trailing.equalToSuperview.trailing.value(-16)
        })
        
        Layout.to(patronymicLabel, {
            $0.top.equal(to: lastnameLabel).bottom.value(8)
            $0.leading.equalToSuperview.leading.value(16)
            $0.trailing.equalToSuperview.trailing.value(-16)
        })
        
        Layout.to(phoneLabel1, {
            $0.top.equal(to: patronymicLabel).bottom.value(8)
            $0.leading.equalToSuperview.leading.value(16)
            $0.trailing.equalToSuperview.trailing.value(-16)
        })
        
        Layout.to(phoneLabel2, {
            $0.top.equal(to: phoneLabel1).bottom.value(8)
            $0.leading.equalToSuperview.leading.value(16)
            $0.trailing.equalToSuperview.trailing.value(-16)
        })
        
        Layout.to(mailLabel, {
            $0.top.equal(to: phoneLabel2).bottom.value(8)
            $0.leading.equalToSuperview.leading.value(16)
            $0.trailing.equalToSuperview.trailing.value(-16)
        })
        
        Layout.to(addressLabel, {
            $0.top.equal(to: mailLabel).bottom.value(8)
            $0.leading.equalToSuperview.leading.value(16)
            $0.trailing.equalToSuperview.trailing.value(-16)
        })
        
        Layout.to(groupLabel, {
            $0.top.equal(to: addressLabel).bottom.value(8)
            $0.leading.equalToSuperview.leading.value(16)
            $0.trailing.equalToSuperview.trailing.value(-16)
        })
        
        if self.segmentedControl.selectedSegmentIndex == 0 {
            Layout.to(faculLabel, {
                $0.top.equal(to: groupLabel).bottom.value(8)
                $0.leading.equalToSuperview.leading.value(16)
                $0.trailing.equalToSuperview.trailing.value(-16)
            })
            groupLabel.placeholder = "Группа"

        } else {
            groupLabel.placeholder = "Должность"
        }
        
        
    }
    
    @objc
    func change(_ sender: Any) {
        self.rebild()
    }
    
    func setupDoneButton() {
        let cancel = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        navigationItem.rightBarButtonItem = cancel
        
    }
    
    @objc func done() {
        let model = BCardModel(name: self.nameLabel.text,
                               lastname: self.lastnameLabel.text,
                               patronymic: self.patronymicLabel.text,
                               phone1: self.phoneLabel1.text,
                               phone2: self.phoneLabel2.text,
                               isStudent: self.segmentedControl.selectedSegmentIndex == 0,
                               mail: self.mailLabel.text,
                               address: self.addressLabel.text,
                               facul: self.faculLabel.text,
                               group: self.groupLabel.text,
                               uid: _model?.uid ?? UUID().uuidString)
        self.delegate?.save(model)
        dismiss(animated: true, completion: nil)
    }
}
