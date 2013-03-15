//
//  MenuScannerConstants.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 13.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//


#pragma mark - SecurityManager

#define KEYCHAIN_KEY @"user_name"


#pragma mark - Alert View

#define ALRT_TITLE_WARNING @"Warnung"
#define ALRT_TITLE_ERROR @"Fehler"
#define ALRT_BTN_ACCEPT @"OK"
#define ALRT_BTN_CANCEL @"Abbrechen"
#define ALRT_INFO_TEXTFIELD_NOT_FILLED @"Einige Felder sind nicht korrekt ausgefüllt."
#define ALRT_INFO_CAM_NOT_AVAILABLE @"Die Funktion ist zurzeit leider nicht verfügbar."
#define ALRT_INFO_PASSWORD_AUTHENTICATION_FAILURE @"Das von dir eingegebene Passwort stimmt nicht. Bitte versuche es noch einmal."
#define ALRT_INFO_PASSWORD_STORAGE_FAILURE @"Fehler beim Abspeichern des Passworts."


#pragma mark - Login

#define PLACEHOLDER_LOGIN @"Benutzername"
#define PLACEHOLDER_PASSWORD @"Passwort"
#define LOGIN_STATE_RUNNING @"Anmeldung erfolgt …"
#define LOGIN_STATE_WAITING @"Anmelden"


#pragma mark - Order Collection

#define ORDER_COUNT_ONE @"Bestellung"
#define ORDER_COUNT_MANY @"Bestellungen"


#pragma mark - Order Detail

#define NAV_BTN_REGISTER_NEW_PRODUCT @"Neues Produkt"
#define EMPTY_ORDER_HEADER @"Die Bestellung ist leer"
#define ORDER_COSTS_PRE_CLAUSE @"Gesamt: "
#define ORDER_DATE_PRE_CLAUSE @"Bestellung vom "


#pragma mark - Reader

#define READER_TITLE @"QR Scan"


#pragma mark - Order Updater

#define ORDER_UPDATER_URL @"http://api.codingduck.de/orders/"
#define ORDER_UPDATER_METHOD @"DELETE"


#pragma mark - Login Checker

#define LOGIN_CHECKER_URL @"http://api.codingduck.de/login/check"


#pragma mark - Order Collection Downloader

#define ORDER_COLLECTION_DOWNLOADER_URL @"http://api.codingduck.de/orders/"
#define ORDER_COLLECTION_DOWNLOADER_ID @"id"
#define ORDER_COLLECTION_DOWNLOADER_HASH @"hash"
#define ORDER_COLLECTION_DOWNLOADER_TIME @"orderTime"


#pragma mark - Product Info Downloader

#define PRODUCT_INFO_DOWNLOADER_URL @"http://api.codingduck.de/orders/"
#define PRODUCT_INFO_DOWNLOADER_TOTAL_COSTS @"total"
#define PRODUCT_INFO_DOWNLOADER_PRODUCTS @"items"
#define PRODUCT_INFO_DOWNLOADER_ID @"id"
#define PRODUCT_INFO_DOWNLOADER_TIME @"orderTime"
#define PRODUCT_INFO_DOWNLOADER_PRODUCT_NAME @"name"
#define PRODUCT_INFO_DOWNLOADER_PRODUCT_CATEGORY @"category"
#define PRODUCT_INFO_DOWNLOADER_PRODUCT_DESCR @"desc"
#define PRODUCT_INFO_DOWNLOADER_PRODUCT_COUNT @"count"
#define PRODUCT_INFO_DOWNLOADER_PRODUCT_UNIT @"unit"
#define PRODUCT_INFO_DOWNLOADER_PRODUCT_PRICE @"price"
#define PRODUCT_INFO_DOWNLOADER_PRODUCT_IMAGE @"imageURL"


#pragma mark - Secure REST Connection

#define SECURE_REST_CONNECTION_BASE_URL @"http://api.codingduck.de"
#define SECURE_REST_CONNECTION_USERNAME @"QRAuth_username"
#define SECURE_REST_CONNECTION_TIMESTAMP @"QRAuth_timestamp"
#define SECURE_REST_CONNECTION_SIGNATURE @"QRAuth_signature"



