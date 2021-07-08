//
//  CXContactUtils.h
//  Pods
//
//  Created by wshaolin on 2019/4/15.
//

#import "CXIndexList.h"

typedef NS_ENUM(NSInteger, CXContactsAuthStatus){
    CXContactsAuthStatusNotDetermined  = 0,
    CXContactsAuthStatusRestricted     = 1,
    CXContactsAuthStatusDenied         = 2,
    CXContactsAuthStatusAuthorized     = 3
};

@interface CXContact : NSObject <CXIndexPinyinObject>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *pinyin; // CXIndexPinyinObject

@end

typedef void(^CXContactsEnumerateBlock)(CXContact *contact);
typedef void(^CXContactsFetchCompletionBlock)(NSArray<CXContact *> *contacts);
typedef void(^CXContactsAuthCompletionBlock)(CXContactsAuthStatus status);

@interface CXContactUtils : NSObject

+ (CXContactsAuthStatus)contactsAuthStatus;

+ (void)requestAuthorization:(CXContactsAuthCompletionBlock)completion;

+ (void)fetchContacts:(CXContactsFetchCompletionBlock)completion;

+ (void)fetchContactsGroup:(CXIndexListBlock)completion; // 按首字母分组

@end
