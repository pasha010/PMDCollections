//
//  NSArray(PMDCollections)
//  PMDCollections
// 
//  Created by Pavel Malkov on 28.06.17.
//  Copyright (c) 2014-2017 Prime Digital. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (PMDCreation)

//+ (nonnull instancetype)arrayWithWeakReferences;


+ (nonnull NSArray<NSNumber *> *)arrayFromIndex:(NSUInteger)startIndex toIndex:(NSUInteger)endIndex;

+ (nonnull NSArray<NSNumber *> *)arrayFromRange:(NSRange)range;
 // create with nsrange

@end

@interface NSArray<__covariant ObjectType> (PMDFunctions)

/**
 * map function
 * @param iterate block for iterating (may return nil object which will not added no result array
 * @return new array with new elements
 */
- (nullable NSArray<id> *)map:(id _Nullable (^ _Nullable)(ObjectType _Nonnull element))iterate;

/**
 * map function with selector
 * used respondsToSelector to find selector for array element
 * @param sel selector for array elements
 * @return new array performs to selector
 */
- (nullable NSArray<id> *)mapBySelector:(nullable SEL)sel;

/**
 * map function with target and its selector
 * used respondsToSelector to find selector for target
 * @param target for selector
 * @param sel mapper
 * @return new array performs to selector for target
 */
- (nullable NSArray<id> *)mapByTarget:(nullable id)target withSelector:(nullable SEL)sel;

/**
 * filter function
 * if predicate is nil, throws NSException/NSError return self instance
 * @param predicate pass block for element, if predicate is nil returns self instance.
 *                  If predicate is nil returns self instance of array
 * @return new array with predicate result
 */
- (nonnull NSArray<ObjectType> *)filter:(BOOL(^ _Nullable)(ObjectType _Nonnull element))predicate;

/**
 * filter function
 * if one of params is nil returns self instance.
 * if target is nil, sel is nil or unrecognized (or throws NSException/NSError) return self instance
 * @param target for selector
 * @param sel filter function
 * @return filtered array
 */
- (nonnull NSArray<ObjectType> *)filterByTarget:(nullable id)target withSelector:(nullable SEL)sel;

/**
 * find object by predicate
 * @param predicate filter predicate
 * @return object object passed predicate
 */
- (nullable ObjectType)find:(BOOL(^ _Nonnull)(ObjectType _Nonnull element))predicate;

- (nullable ObjectType)findBySelector:(BOOL(^ _Nonnull)(ObjectType _Nonnull element))predicate;

/**
 * shuffle current array
 * @return new array
 */
- (nonnull NSArray<ObjectType> *)shuffle;

@end

NS_ASSUME_NONNULL_END