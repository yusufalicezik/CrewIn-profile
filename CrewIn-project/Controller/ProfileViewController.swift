//
//  ViewController.swift
//  CrewIn-project
//
//  Created by Yusuf ali cezik on 11.11.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import UIKit
import SDWebImage
enum InfoType {
    case Kisisel,Iletisim,Hakkinda
}

class ProfileViewController: UIViewController {

    @IBOutlet weak var headerContainerView: UIView!
    @IBOutlet weak var headerProfileImageView: UIImageView!
    @IBOutlet weak var headerUsernameLabel: UILabel!
    @IBOutlet weak var headerNotificationLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var profileEditButton: UIButton!
    @IBOutlet weak var cvEditButton: UIButton!
    @IBOutlet weak var favsButton: UIButton!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var infoStackView: UIStackView!
    @IBOutlet weak var pictureIndicator:UIActivityIndicatorView!
    var user = User()
    var kisiselBilgilerList = [String]()
    var iletisimBilgileriList = [String]()
    var Hakkimda = [""]
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        getDataFromService(userId:1)
    }
    func getDataFromService(userId:Int){
        DataServiceManager.shared.getUserInfo(withID: userId) { (user) in
            self.user = user
            self.prepareInfo()
            DispatchQueue.main.async {
                self.setInfoHeaderView(type: .Kisisel)
                self.setInfoHeaderView(type: .Iletisim)
                self.setInfoHeaderView(type: .Hakkinda)
                self.fillProfile()
            }
        }
    }
    func fillProfile(){
        if let url = user.RESIM_URL{
           profileImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "person.png"))
            headerProfileImageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "person"))
        }else{
            profileImageView.image = UIImage(named: "person")
            headerProfileImageView.image = UIImage(named: "person")
        }
        pictureIndicator.stopAnimating()
        pictureIndicator.isHidden = true
        if let name = user.AD{
            usernameLabel.text = name
            headerUsernameLabel.text = name
        }
    }
    func prepareInfo(){
        //Kisisel Bilgiler listlerinin doldurulmasi
        self.fillDictionaryForPersonalInfo(key: "İsim", value: user.AD)
        self.fillDictionaryForPersonalInfo(key: "Soyad", value: user.SOYADI)
        self.fillDictionaryForPersonalInfo(key: "Pozisyon", value: user.POZISYON)
        self.fillDictionaryForPersonalInfo(key: "E-Mail", value: user.E_MAIL)
        self.fillDictionaryForPersonalInfo(key: "Doğum Tarihi", value: user.DOGUM_TARIHI)
        self.fillDictionaryForPersonalInfo(key: "Gemi Adamı No", value: user.SGK_NO) //gemi adamı no apide yoktu.
        if let tcNo = user.TC_NO{
            self.fillDictionaryForPersonalInfo(key: "TC No", value: String(tcNo))
        }
        self.fillDictionaryForPersonalInfo(key: "Medeni Durum", value: user.MEDENI_DURUMU)
        self.fillDictionaryForPersonalInfo(key: "Cinsiyet", value: user.CINSIYET)
        self.fillDictionaryForPersonalInfo(key: "Sigorta No", value: user.SGK_NO)
        self.fillDictionaryForPersonalInfo(key: "Askerlik Durumu", value: user.ASKERLIK_DURUMU)
        self.fillDictionaryForPersonalInfo(key: "Askerlik Hizmet Bitiş Tarihi", value: user.ASKERLIK_BIT_TARIHI)
        
        //İletisim Bilgileri listlerinin doldurulması
        self.fillDictionaryForContactInfo(key: "Ülke", value: user.ULKE_ADI)
        self.fillDictionaryForContactInfo(key: "Şehir", value: user.SEHIR_ADI)
        self.fillDictionaryForContactInfo(key: "Ev Telefonu", value: user.EV_TEL)
        self.fillDictionaryForContactInfo(key: "Cep Telefonu", value: user.CEP_TEL)
        self.fillDictionaryForContactInfo(key: "Adres", value: user.ADRES)
        self.fillDictionaryForContactInfo(key: "Facebook", value: user.FACEBOOK)
        self.fillDictionaryForContactInfo(key: "Linkedin", value: user.LINKEDIN)
        self.fillDictionaryForContactInfo(key: "Skype", value: user.SKYPE)
        self.fillDictionaryForContactInfo(key: "QQ", value: user.QQ)
        self.fillDictionaryForContactInfo(key: "WeChat", value: user.WE_CHAT)
        
        
    }
    func setup(){
        scrollView.delaysContentTouches = false
        headerContainerView.layer.cornerRadius = 12
        headerContainerView.layer.borderColor = #colorLiteral(red: 0.2588235438, green: 0.7568627596, blue: 0.9686274529, alpha: 1)
        headerContainerView.layer.borderWidth = 1
        headerProfileImageView.layer.cornerRadius = headerProfileImageView.frame.width / 2
        profileImageView.layer.cornerRadius = profileImageView.frame.width/2
        let mViews = [settingsButton, profileEditButton, cvEditButton, favsButton]
        mViews.forEach {
            $0?.layer.cornerRadius = 5
            if $0 != settingsButton{
                $0?.layer.borderWidth = 1
                $0?.layer.borderColor = #colorLiteral(red: 0.1295829713, green: 0.4071484804, blue: 0.7029806972, alpha: 1)
            }
        }
    }
    func setInfoHeaderView(type:InfoType){
        guard let header = Bundle.main.loadNibNamed("InfoHeader", owner: self, options: nil)?.first as? InfoHeader else {return}
        switch type {
        case .Kisisel:
            header.infoTitleNameLabel.text = "Kisisel Bilgiler"
        case .Iletisim:
            header.infoTitleNameLabel.text = "İletişim Bilgileri"
        default:
            header.infoTitleNameLabel.text = "Hakkında"
        }
        self.infoStackView.addArrangedSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.leftAnchor.constraint(equalTo: self.infoStackView.leftAnchor, constant: 0.0).isActive = true
        header.rightAnchor.constraint(equalTo: self.infoStackView.rightAnchor, constant: 0.0).isActive = true
        header.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
        setInfoSubViews(type: type)
    }
    
    func setInfoSubViews(type:InfoType){
        var profileInfoList = [String]()
        var profileInfoDescriptionList = [String]()
        switch type {
        case .Kisisel:
            profileInfoList = kisiselBilgiler
            profileInfoDescriptionList = kisiselBilgilerList
        case .Iletisim:
            profileInfoList = iletisimBilgileri
            profileInfoDescriptionList = iletisimBilgileriList
        default:
            if let hakkinda = user.HAKKINDA{
                profileInfoList = [""]
                profileInfoDescriptionList = [hakkinda]
            }
        }
        for i in 0..<profileInfoDescriptionList.count{
            guard let infoDesc = Bundle.main.loadNibNamed("InfoDesc", owner: self, options: nil)?.first as? InfoDesc else {return}
            infoDesc.infoNameLabel.text = profileInfoList[i]
            infoDesc.infoDescLabel.text = profileInfoDescriptionList[i]
            infoDesc.translatesAutoresizingMaskIntoConstraints = false
            self.infoStackView.addArrangedSubview(infoDesc)
            infoDesc.leftAnchor.constraint(equalTo: self.infoStackView.leftAnchor, constant: 0.0).isActive = true
            infoDesc.rightAnchor.constraint(equalTo: self.infoStackView.rightAnchor, constant: 0.0).isActive = true
            if type == .Hakkinda{
                infoDesc.heightAnchor.constraint(greaterThanOrEqualToConstant: 35.0).isActive = true
            }else{
                infoDesc.heightAnchor.constraint(equalToConstant: 35.0).isActive = true
            }
        }
    }
    
    
    @IBAction func settingsButtonClicked(_ sender: Any) {
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    

}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
extension ProfileViewController{
    func fillDictionaryForPersonalInfo(key:String, value:String?){
        if let mkey = value{
            kisiselBilgilerList.append(mkey)
        }else{
            kisiselBilgilerList.append("")
        }
    }
    
    func fillDictionaryForContactInfo(key:String, value:String?){
        if let mkey = value{
            iletisimBilgileriList.append(mkey)
        }else{
            iletisimBilgileriList.append("")
        }
    }
}
