//
//  User.swift
//  CrewIn-project
//
//  Created by Yusuf ali cezik on 11.11.2019.
//  Copyright © 2019 Yusuf Ali Cezik. All rights reserved.
//

import Foundation
struct User : Decodable{
    var KULLANICI_ID,TC_NO:Double?
    var AD,SOYADI,ULKE_ADI,SEHIR_ADI,POZISYON,E_MAIL,KULLANICI_ADI,DOGUM_TARIHI,LIMAN_CUZDAN_NO,RESIM_URL,
    MEDENI_DURUMU,CINSIYET,SGK_NO,ASKERLIK_DURUMU,ASKERLIK_BIT_TARIHI,EV_TEL,CEP_TEL,
    ADRES,FACEBOOK,LINKEDIN,SKYPE,QQ,WE_CHAT,KAN_GRUBU,BOY,KILO,BEDEN,IS_DURUMU,HAKKINDA,SEFER,BAYRAK:String?
    
}

struct UserResponse:Decodable{
    var user:[User]
}
