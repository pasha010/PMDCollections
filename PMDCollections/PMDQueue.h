//
//  PMDQueue
//  PMDCollections
//
//  Created by Pavel Malkov on 28.06.17.
//  Copyright (c) 2014-2017 Prime Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// FIFO
@interface PMDQueue<__covariant ObjectType> : NSObject <NSCopying, NSFastEnumeration, NSSecureCoding>

@property (nonatomic, assign, readonly) NSUInteger count;

+ (nonnull instancetype)queue;

+ (nonnull instancetype)queueWithArray:(nullable NSArray<ObjectType> *)array;

- (nonnull instancetype)init;

- (nonnull instancetype)initWithArray:(nullable NSArray<ObjectType> *)array NS_DESIGNATED_INITIALIZER;

- (void)enqueue:(nonnull ObjectType)object;

- (nullable ObjectType)dequeue;

- (BOOL)isEqual:(id)other;

- (NSUInteger)hash;

@end

NS_ASSUME_NONNULL_END