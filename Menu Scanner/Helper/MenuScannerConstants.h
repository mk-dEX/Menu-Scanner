//
//  MenuScannerConstants.h
//  Menu Scanner
//
//  Created by Marc Kirchmann on 13.03.13.
//  Copyright (c) 2013 Marc Kirchmann. All rights reserved.
//


#pragma mark - SecurityManager

#define KEYCHAIN_KEY @"user_name"
#define KEYCHAIN_RESTORE @"do_restore_credentials"
#define KEYCHAIN_SERVICE @"Menu Scanner"


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


#pragma mark - REST

#define REQUEST_TIMEOUT 10.0
#define REST_BASE @"http://api.codingduck.de"
#define REST_ORDERS @"/orders"
#define REST_LOGIN @"/login/check"
#define REST_CATEGORIES @"/categories"
#define REST_ITEMS @"/items"



#pragma mark - Order Collection Mappings

#define ORDER_COLLECTION_ID @"id"
#define ORDER_COLLECTION_HASH @"hash"
#define ORDER_COLLECTION_TIME @"orderTime"


#pragma mark - Order Mappings

#define ORDER_TOTAL_COSTS @"total"
#define ORDER_PRODUCTS @"items"
#define ORDER_ID @"id"
#define ORDER_TIME @"orderTime"


#pragma mark - Product Mappings

#define PRODUCT_ID @"id"
#define PRODUCT_NAME @"name"
#define PRODUCT_CATEGORY @"category"
#define PRODUCT_CATEGORY_ID @"category_id"
#define PRODUCT_DESCR @"desc"
#define PRODUCT_COUNT @"count"
#define PRODUCT_UNIT @"unit"
#define PRODUCT_PRICE @"price"
#define PRODUCT_PRICE_DEFAULT @"defaultPrice"
#define PRODUCT_IMAGE @"imageURL"


#pragma mark - Category Collection Mappings

#define CATEGORY_COLLECTION_NAME @"name"
#define CATEGORY_COLLECTION_ID @"id"


#pragma mark - HTTP Code Mappings

#define REST_HTTP_RESPONSE @"error"
#define REST_HTTP_CODE @"code"


#pragma mark - Secure REST Connection

#define SEC_USERNAME @"QRAuth_username"
#define SEC_TIMESTAMP @"QRAuth_timestamp"
#define SEC_SIGNATURE @"QRAuth_signature"



