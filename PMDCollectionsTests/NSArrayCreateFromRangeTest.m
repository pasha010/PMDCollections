//
//  NSArrayCreateFromRangeTest.m
//  PMDCollections
//
//  Created by Pavel Malkov on 29.06.17.
//  Copyright (c) 2017 Prime Digital. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <PMDCollections/PMDCollections.h>

@interface NSArrayCreateFromRangeTest : XCTestCase

@end

@implementation NSArrayCreateFromRangeTest

- (void)testRange_createFromIndexes1 {
    NSArray<NSNumber *> *array = [NSArray arrayFromIndex:50 toIndex:55];
    NSArray<NSNumber *> *expected = @[@50, @51, @52, @53, @54, @55];
    XCTAssertEqualObjects(array, expected);
}

- (void)testRange_createFromIndexes2 {
    NSArray<NSNumber *> *array = [NSArray arrayFromIndex:-50 toIndex:-45];
    NSArray<NSNumber *> *expected = @[@(-50), @(-49), @(-48), @(-47), @(-46), @(-45)];
    XCTAssertEqualObjects(array, expected);
}

- (void)testRange_createFromIndexes3 {
    NSArray<NSNumber *> *array = [NSArray arrayFromIndex:1 toIndex:7];
    NSArray<NSNumber *> *expected = @[@1, @2, @3, @4, @5, @6, @7];
    XCTAssertEqualObjects(array, expected);
}

- (void)testRange_createWithZeros {
    NSArray<NSNumber *> *array = [NSArray arrayFromIndex:0 toIndex:0];
    XCTAssertEqualObjects(array, nil);
}

- (void)testRange_createWithIncorrectInputParams {
    NSArray<NSNumber *> *array = [NSArray arrayFromIndex:2 toIndex:0];
    XCTAssertEqualObjects(array, nil);
}

@end
