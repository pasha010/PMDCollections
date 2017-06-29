//
//  PMDBinaryHeap
//  PMDCollections
// 
//  Created by Pavel Malkov on 28.06.17.
//  Copyright (c) 2014-2017 Prime Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// TODO CFBinaryHeapGetValues, CFBinaryHeapApplyFunction
@interface PMDBinaryHeap<__covariant ObjectType> : NSObject <NSCopying>

//! CFBinaryHeapGetCount
@property (nonatomic, readonly) NSUInteger count;

//! CFBinaryHeapGetMinimum and CFBinaryHeapGetMinimumIfPresent
@property (nullable, nonatomic, readonly) ObjectType topObject;

//! CFBinaryHeapGetValues
@property (nullable, nonatomic, readonly) NSSet<ObjectType> *allValues;

- (nonnull instancetype)init NS_UNAVAILABLE;

//! CFBinaryHeapCreate
- (nonnull instancetype)initWithOrderingType:(NSComparisonResult)ordering
                                  comparator:(nonnull NSComparator)comparator NS_DESIGNATED_INITIALIZER;

//! CFBinaryHeapGetCountOfValue
- (NSUInteger)countOfObject:(nonnull ObjectType)object;

//! CFBinaryHeapContainsValue
- (BOOL)containsObject:(nonnull ObjectType)object;

//! CFBinaryHeapAddValue
- (void)addObject:(nonnull ObjectType)object;

- (nullable ObjectType)popTopObject;

//! CFBinaryHeapRemoveMinimumValue
- (void)removeTopObject;

//! CFBinaryHeapRemoveAllValues
- (void)removeAllObjects;

//! CFBinaryHeapApplyFunction
- (void)enumerateObjectsUsingBlock:(void(^_Nonnull)(ObjectType _Nonnull element))block;

@end

NS_ASSUME_NONNULL_END