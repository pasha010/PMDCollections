//
//  NSArrayFilterTest.m
//  PMDCollections
//
//  Created by Pavel Malkov on 29.06.17.
//  Copyright (c) 2017 Prime Digital. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSArray+PMDCollections.h"

@interface NSArrayFilterTest : XCTestCase

@end

@implementation NSArrayFilterTest

- (void)testFilter_block {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];

    __block NSArray<NSNumber *> *newArray;

    [self measureBlock:^{
        newArray = [array filter:^BOOL(NSNumber *element) {
            return element.integerValue % 2 == 0;
        }];
    }];

    NSArray<NSNumber *> *expected = @[@0, @2, @4];

    XCTAssertEqualObjects(newArray, expected);
}

- (void)testFilter_blockEqualToNil {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];
    NSArray<NSNumber *> *newArray = [array filter:nil];
    XCTAssertEqualObjects(newArray, array);
}

- (void)testFilter_blockThrowsError {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];
    NSArray<NSNumber *> *newArray = [array filter:^BOOL(NSNumber *element) {
        if (element.integerValue % 2 != 0) {
            @throw [NSError errorWithDomain:@"pm.error" code:-2 userInfo:nil];
            return NO;
        }
        return YES;
    }];

    NSArray<NSNumber *> *expected = @[@0, @2, @4];

    XCTAssertEqualObjects(newArray, expected);
}

- (void)testFilter_blockThrowsException {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];
    NSArray<NSNumber *> *newArray = [array filter:^BOOL(NSNumber *element) {
        if (element.integerValue % 2 != 0) {
            @throw [NSException exceptionWithName:@"FilterWithBlockException" reason:@"no reason" userInfo:nil];
            return NO;
        }
        return YES;
    }];

    NSArray<NSNumber *> *expected = @[@0, @2, @4];

    XCTAssertEqualObjects(newArray, expected);
}

- (BOOL)someFilterMethod:(NSNumber *)number {
    return number.integerValue % 2 != 0;
}

- (void)testFilter_selector {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];

    __block NSArray<NSNumber *> *newArray;

    [self measureBlock:^{
        newArray = [array filterByTarget:self withSelector:@selector(someFilterMethod:)];
    }];

    NSArray<NSNumber *> *expected = @[@1, @3, @5];

    XCTAssertEqualObjects(newArray, expected);
}

- (BOOL)throwsError:(NSNumber *)number {
    if (number.integerValue % 2 == 0) {
        @throw [NSError errorWithDomain:@"pm.error" code:-2 userInfo:nil];
        return NO;
    }
    return YES;
}

- (void)testFilter_selectorThrowsError {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];

    NSArray<NSNumber *> *newArray = [array filterByTarget:self withSelector:@selector(throwsError:)];

    NSArray<NSNumber *> *expected = @[@1, @3, @5];

    XCTAssertEqualObjects(newArray, expected);
}

- (BOOL)throwsException:(NSNumber *)number {
    if (number.integerValue % 2 == 0) {
        @throw [NSException exceptionWithName:@"FilterWithSelectorException" reason:@"no reason" userInfo:nil];
        return NO;
    }
    return YES;
}

- (void)testFilter_selectorThrowsException {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];

    NSArray<NSNumber *> *newArray = [array filterByTarget:self withSelector:@selector(throwsException:)];

    NSArray<NSNumber *> *expected = @[@1, @3, @5];

    XCTAssertEqualObjects(newArray, expected);
}

- (void)testFilter_selectorEqualToNil {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];

    NSArray<NSNumber *> *newArray = [array filterByTarget:self withSelector:nil];

    XCTAssertEqualObjects(newArray, array);
}

- (void)testFilter_selectorEqualToUnrecognized {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];

    NSArray<NSNumber *> *newArray = [array filterByTarget:self withSelector:@selector(someUnrecognizedSelector)];

    XCTAssertEqualObjects(newArray, array);
}

- (void)testFilter_selectorWhereTargetIsNil {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];

    NSArray<NSNumber *> *newArray = [array filterByTarget:nil withSelector:@selector(description)];

    XCTAssertEqualObjects(newArray, array);
}

@end
