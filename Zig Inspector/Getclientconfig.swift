// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - WelcomeElement
struct Getclientconfig {
    let id: Int?
    let clientname: String?
    let radius: Int?
    let clientlat, clientlng, clientuuid: String?
    let clientpayment: Bool?
    let serviceinterval, status, clienttype, scaninterval: Int?
    let createddate: String?
    let macaddresslist: [Macaddresslist]?
    let beveragelist: [Beveragelist]?
    let clientimage: String?
    let clientdesc, rssvalue: String?
    let maxticket: Int?
    let quantityres: Bool?
    let hardwareurl, clientdisclaimer: String?
    let clientmiscimage: String?
    let freeticket: Int?
    let price: NSNull?
    let activatestatus: Bool?
    let activatedate, message: String?
    let scanintervalo: Int?
    let documentverifyurl: String?
    let beaconRadius: Int?
    let aMacaddress: String?
    let locationpermission: Bool?
    let productCategory: NSNull?
    let productdetails: Productdetails?
    let beverageInstructionText, beverageTitle: String?
    let ageVerification, enableTicket, beverageMainValidationStatus, enableTripPlanner: Bool?
    let sendOutData: Bool?
    let verificationTitle, verificationSubTitle, verificationDesc: String?
    let verificationStatus: Bool?
    let step1Text, step2Text, primaryColorcode, secondaryColorcode: String?
    let payButtonText, orderConfirmedSubtitle, orderConfirmedTitle: String?
    let clientSecondaryaryColorcode, clientPrimaryColorcode, clientSubDesc: NSNull?
    let faremessage, miscfee: String?
    let farepageTitle: NSNull?
    let bibobRssi: String?
    let validationmode: Int?
    let paymentinfotxt: String?
    let enableVIP: Bool?
    let validationmodeB: Int?
    let bibobRssiIos, rssiIos: String?
    let payment: Payment?
    let ibeaconStatus: Int?
}

// MARK: - Beveragelist
struct Beveragelist {
    let id, clientid: Int?
    let bevname: String?
    let status: Int?
    let price: Double?
    let bevdesc: String?
}

// MARK: - Macaddresslist
struct Macaddresslist {
    let biboOMacaddress, biboAMacaddress: String?
    let iBiboMacaddress: NSNull?
    let macaddress: String?
    let clientid: Int?
    let bibolat, bibolng, major, minor: String?
    let busSerialno: String?
    let beaconType: Int?
}

// MARK: - Payment
struct Payment {
    let sanbox: Sanbox?
    let live: NSNull?
}

// MARK: - Sanbox
struct Sanbox {
    let sanboxTaTokenGlobal, sanboxKAPIKey, sanboxKAPISecret, sanboxKToken: String?
    let sanboxKURL, sanboxSURL, sanboxPURL: String?
}

// MARK: - Productdetails
struct Productdetails {
    let productCategory: [ProductCategory]?
    let rating: Int?
    let description: String?
    let travelduration: Int?
    let subTitle: String?
    let paymentmodes: [Paymentmode]?
    let blePermission: Bool?
}

enum Paymentmode {
    case applePay
    case googlePay
    case masterCard
    case visa
}

enum ProductCategory {
    case museum
    case restaturant
    case themePark
}
