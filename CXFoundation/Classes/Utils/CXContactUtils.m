//
//  CXContactUtils.m
//  Pods
//
//  Created by wshaolin on 2019/4/15.
//

#import "CXContactUtils.h"
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>
#import "CXDispatchHandler.h"
#import "NSString+CXFoundation.h"

@implementation CXContactUtils

+ (CNContactStore *)sharedContactStore API_AVAILABLE(ios(9.0)){
    static CNContactStore *_contactStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _contactStore = [[CNContactStore alloc] init];
    });
    
    return _contactStore;
}

+ (CXContactsAuthStatus)contactsAuthStatus{
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0)
    switch(ABAddressBookGetAuthorizationStatus()){
        case kABAuthorizationStatusRestricted:
            return CXContactsAuthStatusRestricted;
        case kABAuthorizationStatusDenied:
            return CXContactsAuthStatusDenied;
        case kABAuthorizationStatusAuthorized:
            return CXContactsAuthStatusAuthorized;
        case kABAuthorizationStatusNotDetermined:
        default:
            return CXContactsAuthStatusNotDetermined;
    }
#else
    switch([CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts]){
        case CNAuthorizationStatusDenied:
            return CXContactsAuthStatusDenied;
        case CNAuthorizationStatusAuthorized:
            return CXContactsAuthStatusAuthorized;
        case CNAuthorizationStatusRestricted:
            return CXContactsAuthStatusRestricted;
        case CNAuthorizationStatusNotDetermined:
        default:
            return CXContactsAuthStatusNotDetermined;
    }
#endif
}

+ (void)requestAuthorization:(CXContactsAuthCompletionBlock)completion{
    CXContactsAuthStatus status = [self contactsAuthStatus];
    if(status == CXContactsAuthStatusAuthorized){
        !completion ?: completion(status);
        return;
    }
    
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0)
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
        [CXDispatchHandler asyncOnMainQueue:^{
            !completion ?: completion(granted ? CXContactsAuthStatusAuthorized : CXContactsAuthStatusDenied);
        }];
    });
    
    if(addressBookRef != NULL){
        CFRelease(addressBookRef);
    }
#else
    [[self sharedContactStore] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
        [CXDispatchHandler asyncOnMainQueue:^{
            !completion ?: completion(granted ? CXContactsAuthStatusAuthorized : CXContactsAuthStatusDenied);
        }];
    }];
#endif
}

+ (void)fetchContacts:(CXContactsFetchCompletionBlock)completion{
    if([self contactsAuthStatus] != CXContactsAuthStatusAuthorized){
        completion(nil);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<CXContact *> *contacts = [NSMutableArray array];
        [self enumerateContactsUsingBlock:^(CXContact *contact) {
            [contacts addObject:contact];
        }];
        completion([contacts copy]);
    });
}

+ (void)fetchContactsGroup:(CXIndexListBlock)completion{
    if([self contactsAuthStatus] != CXContactsAuthStatusAuthorized){
        completion(nil);
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray<CXContact *> *contacts = [NSMutableArray array];
        [self enumerateContactsUsingBlock:^(CXContact *contact) {
            [contacts addObject:contact];
        }];
        
        CXIndexList *indexList = [CXIndexList listWithObjects:contacts];
        [CXDispatchHandler asyncOnMainQueue:^{
            completion(indexList);
        }];
    });
}

+ (void)enumerateContactsUsingBlock:(CXContactsEnumerateBlock)block{
#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0)
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    if(addressBookRef == NULL){
        return;
    }
    CFArrayRef arrayRef = ABAddressBookCopyArrayOfAllPeople(addressBookRef);
    NSUInteger count = CFArrayGetCount(arrayRef);
    for(NSUInteger index = 0; index < count; index ++){
        ABRecordRef contactRef = CFArrayGetValueAtIndex(arrayRef, index);
        [self contactRef:contactRef enumeratePhoneNumberUsingBlock:block];
    }
    CFRelease(arrayRef);
    CFRelease(addressBookRef);
#else
    NSArray<id<CNKeyDescriptor>> *fetchKeys = @[[CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName],
                                                CNContactPhoneNumbersKey,
                                                CNContactThumbnailImageDataKey];
    CNContactFetchRequest *contactFetchRequest = [[CNContactFetchRequest alloc] initWithKeysToFetch:fetchKeys];
    [[self sharedContactStore] enumerateContactsWithFetchRequest:contactFetchRequest error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        [self contact:contact enumeratePhoneNumberUsingBlock:block];
    }];
#endif
}

+ (void)contact:(CNContact *)contact enumeratePhoneNumberUsingBlock:(CXContactsEnumerateBlock)block API_AVAILABLE(ios(9.0)){
    NSString *name = [CNContactFormatter stringFromContact:contact style:CNContactFormatterStyleFullName];
    [contact.phoneNumbers enumerateObjectsUsingBlock:^(CNLabeledValue<CNPhoneNumber *> * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *phoneNumber = [obj.value.stringValue cx_phoneNumber];
        if([phoneNumber hasPrefix:@"1"] || [phoneNumber hasPrefix:@"+"]){
            CXContact *_contact = [[CXContact alloc] init];
            _contact.name = name;
            _contact.phoneNumber = phoneNumber;
            _contact.pinyin = CXValidPinyinString([name cx_pinyin]);
            block(_contact);
        }
    }];
}

#if (defined(__IPHONE_OS_VERSION_MAX_ALLOWED) && __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0)
+ (void)contactRef:(ABRecordRef)contactRef enumeratePhoneNumberUsingBlock:(CXContactsEnumerateBlock)block{
    NSString *name = CFBridgingRelease(ABRecordCopyCompositeName(contactRef));
    ABMultiValueRef multiValueRef = ABRecordCopyValue(contactRef, kABPersonPhoneProperty);
    CFIndex count = ABMultiValueGetCount(multiValueRef);
    for(CFIndex index = 0; index < count; index ++){
        NSString *phoneValue = CFBridgingRelease(ABMultiValueCopyValueAtIndex(multiValueRef, index));
        NSString *phoneNumber = [phoneValue cx_phoneNumber];
        if([phoneNumber hasPrefix:@"1"] || [phoneNumber hasPrefix:@"+"]){
            CXContact *contact = [[CXContact alloc] init];
            contact.name = name;
            contact.phoneNumber = phoneNumber;
            contact.pinyin = CXValidPinyinString([name cx_pinyin]);
            block(contact);
        }
    }
    
    CFRelease(multiValueRef);
}
#endif

@end

@implementation CXContact

- (NSString *)pinyinSource{
    return self.name;
}

- (NSString *)uid{
    return self.phoneNumber;
}

@end
