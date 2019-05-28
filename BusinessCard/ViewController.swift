
import UIKit
import Wallet
import MagicalRecord

class ViewController: UIViewController {
    
    @IBOutlet weak var walletHeaderView: UIView!
    @IBOutlet weak var walletView: WalletView!
    
    @IBOutlet weak var addCardViewButton: UIButton!
    @IBOutlet weak var changeButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()

        walletView.walletHeader = walletHeaderView
        
        walletView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        walletView.preferableCardViewHeight = UIScreen.main.bounds.width * 0.75
        
        walletView.didUpdatePresentedCardViewBlock = { [weak self] (_) in
            self?.showAddCardViewButtonIfNeeded()
        }
        
    }
    
    func showAddCardViewButtonIfNeeded() {
        addCardViewButton.alpha = walletView.presentedCardView == nil || walletView.insertedCardViews.count <= 1 ? 1.0 : 0.0
        changeButton.alpha = walletView.presentedCardView == nil || walletView.insertedCardViews.count <= 1 ? 0 : 1.0
        deleteButton.alpha =  walletView.presentedCardView == nil || walletView.insertedCardViews.count <= 1 ? 0 : 1.0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
//        loadData()
    }
    
    @IBAction func deleteModel(_ sender: Any) {
        if let card = walletView.presentedCardView as? BCardView, let model = card._model?.model {
            self.walletView.presentedCardView = nil
            MagicalRecord.save(blockAndWait: { [weak self] (context) in
                let user = User.mr_findFirst(byAttribute: "uid", withValue: model.uid, in: context)
                user?.mr_deleteEntity()
            })
            DispatchQueue.main.async { [weak self] in
//                self?.reqursive(in: self?.walletView)
//                self?.walletView.insertedCardViews = []
//                self?.reqursive(in: self?.walletView)
//                self?.walletView.layoutIfNeeded()
//                self?.walletView.setNeedsLayout()
//                self?.walletView.setNeedsDisplay()
//                self?.view.layoutIfNeeded()
//                self?.walletView.layoutSubviews()
//                self?.view.layoutSubviews()
                self?.walletView.remove(cardView: card)

                self?.walletView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
                
                //                self?.walletView.layoutWalletView()
                //                self?.walletView.calculateLayoutValues()
            }
        }
    }
        
    @IBAction func change(_ sender: Any) {
        if let card = walletView.presentedCardView as? BCardView, let model = card._model?.model {
//            card._model
            let vc = AddCardViewController(nibName: nil, bundle: nil)
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            self.present(nav, animated: true, completion: nil)
            vc.update(with: model)
            
        }
    }
    
    @IBAction func addCardViewAction(_ sender: Any) {
        
        let alert = UIAlertController(title: "Тип добавления", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        alert.addAction(UIAlertAction.init(title: "QR сканирование", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            let vc = ScannerViewController(presenter: ScannerPresenter())
            vc.delegeta = self
            let nav = UINavigationController(rootViewController: vc)
            self?.present(nav, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Вручную", style: UIAlertAction.Style.default, handler: { [weak self] _ in
            let vc = AddCardViewController(nibName: nil, bundle: nil)
            vc.delegate = self
            let nav = UINavigationController(rootViewController: vc)
            self?.present(nav, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Отмена", style: UIAlertAction.Style.cancel, handler: {  _ in }))
        self.present(alert, animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    func loadData() {
        self.reqursive(in: self.walletView)
        self.walletView.insertedCardViews = []
        self.reqursive(in: self.walletView)

        if let users = User.mr_findAll() as? [User] {
            var coloredCardViews = [CardView]()
            for user in users {
                let cardView = BCardView(frame: .zero)
                do {
                    let model = BCardModel(name: user.name,
                                           lastname: user.lastname,
                                           patronymic: user.patronymic,
                                           phone1: user.phone1,
                                           phone2: user.phone2,
                                           isStudent: user.isStudent,
                                           mail: user.mail,
                                           address: user.address,
                                           facul: user.facul,
                                           group: user.group,
                                           uid: user.uid)
                    
                    let data = try JSONEncoder().encode(model)
                    let qrCode = QRCode(data: data)
                    //                let image = try qrCode.image()
                    let container = BCardModelContainer.init(model: model, qrCode: qrCode)
                    cardView.setup(with: container)
                } catch {
                    
                }
                
                coloredCardViews.append(cardView)
            }
            DispatchQueue.main.async { [weak self] in
                self?.reqursive(in: self?.walletView)
                self?.walletView.insertedCardViews = []
                self?.reqursive(in: self?.walletView)
                self?.walletView.reload(cardViews: coloredCardViews)
                self?.walletView.layoutIfNeeded()
                self?.walletView.setNeedsLayout()
                self?.walletView.setNeedsDisplay()
                self?.view.layoutIfNeeded()
                self?.walletView.layoutSubviews()
                self?.view.layoutSubviews()
                self?.walletView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
//                self?.walletView.layoutWalletView()
//                self?.walletView.calculateLayoutValues()
            }
        }
    }
    
    func reqursive(in view: UIView?) {
        guard let view = view else { return }
        for sub in view.subviews {
            if sub is CardView {
                sub.removeFromSuperview()
            } else if let scroll = sub as? UIScrollView {
                scroll.setContentOffset(CGPoint.zero, animated: false)
                reqursive(in: sub)
            } else {
                reqursive(in: sub)
            }
        }
    }
}


extension ViewController: AddCardViewControllerOut {
    func save(_ model: BCardModel) {
        self.reqursive(in: self.walletView)
        self.walletView.remove(cardViews: self.walletView.insertedCardViews)
        self.walletView.insertedCardViews = []
        self.reqursive(in: self.walletView)
        MagicalRecord.save(blockAndWait: { [weak self] (context) in
            do {
                let data = try JSONEncoder().encode(model)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let dict = json as? [AnyHashable: Any] {
                    
                    
                    if let user = User.mr_import(from: [dict], in: context).first as? User {
                        let cardView = BCardView(frame: .zero)
                        do {
                            let model = BCardModel(name: user.name,
                                                   lastname: user.lastname,
                                                   patronymic: user.patronymic,
                                                   phone1: user.phone1,
                                                   phone2: user.phone2,
                                                   isStudent: user.isStudent,
                                                   mail: user.mail,
                                                   address: user.address,
                                                   facul: user.facul,
                                                   group: user.group,
                                                   uid: user.uid)
                            
                            let data = try JSONEncoder().encode(model)
                            let qrCode = QRCode(data: data)
                            //                let image = try qrCode.image()
                            let container = BCardModelContainer.init(model: model, qrCode: qrCode)
                            cardView.setup(with: container)
                        } catch {
                            
                        }
                        DispatchQueue.main.async {
                            self?.loadData()
                        }
                    }
                }
            } catch {
                
            }
        })
    }
    
    
}
