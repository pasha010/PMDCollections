//
//  PMDBinaryHeap
//  PMDCollections
// 
//  Created by Pavel Malkov on 28.06.17.
//  Copyright (c) 2014-2017 Prime Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// CFBinaryHeapGetValues, CFBinaryHeapApplyFunction

@interface PMDBinaryHeap<__covariant ObjectType> : NSObject <NSCopying>

@property (class, nonnull, nonatomic, copy, readonly) NSComparator defaultComparator;

@property (nonatomic, readonly) NSUInteger count;  // like CFBinaryHeapGetCount

@property (nullable, nonatomic, readonly) ObjectType topObject;  // like CFBinaryHeapGetMinimum and CFBinaryHeapGetMinimumIfPresent

@property (nullable, nonatomic, readonly) NSArray<ObjectType> *allValues;  // CFBinaryHeapGetValues

+ (nonnull instancetype)binaryHeap;  // ascending by default and default comparator

+ (nonnull instancetype)binaryHeapWithComparator:(nonnull NSComparator)comparator;

+ (nonnull instancetype)binaryHeapWithObjects:(nonnull NSArray<ObjectType> *)array;

+ (nonnull instancetype)binaryHeapWithObjects:(nonnull NSArray<ObjectType> *)array
                                   comparator:(nonnull NSComparator)comparator;

- (nonnull instancetype)init NS_UNAVAILABLE;

- (nonnull instancetype)initWithComparator:(nonnull NSComparator)comparator;

- (nonnull instancetype)initWithWithObjects:(nonnull NSArray<ObjectType> *)array;

/**
 * create new binary heap
 * @param array objects for adding
 * @param comparator compare objects block, not nil block
 * @return new instance, if comparator is nil returns nil
 */
- (nonnull instancetype)initWithWithObjects:(nonnull NSArray<ObjectType> *)array
                                 comparator:(nonnull NSComparator)comparator NS_DESIGNATED_INITIALIZER;  // CFBinaryHeapCreate

- (void)addObject:(nonnull ObjectType)object;  // CFBinaryHeapAddValue

- (NSUInteger)countOfObject:(nonnull ObjectType)object;  // CFBinaryHeapGetCountOfValue

- (BOOL)containsObject:(nonnull ObjectType)object;  // CFBinaryHeapContainsValue

- (nullable ObjectType)popTopObject;  // CFBinaryHeapGetMinimum & CFBinaryHeapRemoveMinimumValue

- (void)removeTopObject;  // CFBinaryHeapRemoveMinimumValue

- (void)removeAllObjects;  // CFBinaryHeapRemoveAllValues

- (void)enumerateObjectsUsingBlock:(void(^_Nonnull)(ObjectType _Nonnull element))block;

- (BOOL)isEqual:(id)other;

- (NSUInteger)hash;  // CFBinaryHeapApplyFunction

@end

NS_ASSUME_NONNULL_END