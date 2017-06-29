//
//  PMDStack
//  PMDCollections
//
//  Created by Pavel Malkov on 28.06.17.
//  Copyright (c) 2014-2017 Prime Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// LIFO

@interface PMDStack<__covariant ObjectType> : NSObject <NSCopying, NSFastEnumeration, NSSecureCoding>

@property (nonatomic, assign, readonly) NSUInteger count;

- (nonnull instancetype)init;

- (nonnull instancetype)initWithSet:(nullable NSSet<ObjectType> *)set;

- (nonnull instancetype)initWithArray:(nullable NSArray<ObjectType> *)array NS_DESIGNATED_INITIALIZER;

- (void)push:(nonnull ObjectType)object;

- (nullable ObjectType)pop;

- (nullable ObjectType)peek;

- (BOOL)isEqual:(id)other;

- (NSUInteger)hash;

@end

NS_ASSUME_NONNULL_END