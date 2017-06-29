//
//  Copyright © 2014-2017 Prime Digital. All rights reserved.
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Pavel Malkov on 29.06.17.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray<__covariant ObjectType> (PMDMapFunction)

/**
 * map function
 * @param iterate block for iterating (may return nil object which will not added no result array
 * @return new array with new elements
 */
- (nullable NSArray<id> *)map:(id _Nullable (^ _Nullable)(ObjectType _Nonnull element))iterate;

/**
 * map function with selector
 * target is element from array
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

@end

@interface NSArray<__covariant ObjectType> (PMDFilterFunction)

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

@end

@interface NSArray<__covariant ObjectType> (PMDFindFunction)

/**
 * find object by predicate
 * @param predicate filter predicate
 * @return object passed filter predicate
 */
- (nullable ObjectType)find:(BOOL(^ _Nullable)(ObjectType _Nonnull element))predicate;

/**
 * find object with target and selector
 * @param target for selector
 * @param sel filter function
 * @return object passed filter selector
 */
- (nullable ObjectType)findByTarget:(nullable id)target withSelector:(nullable SEL)sel;

@end

@interface NSArray<__covariant ObjectType> (PMDShuffleFunction)

/**
 * shuffle current array
 * @return new array
 */
- (nonnull NSArray<ObjectType> *)shuffle;

@end

NS_ASSUME_NONNULL_END