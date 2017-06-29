//
//  NSArrayShuffleTest.m
//  PMDCollections
//
//  Created by Pavel Malkov on 29.06.17.
//  Copyright (c) 2017 Prime Digital. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSArray+PMDCollections.h"

@interface NSArrayShuffleTest : XCTestCase

@end

@implementation NSArrayShuffleTest

- (void)testShuffle {
    NSArray<NSNumber *> *array = @[@3, @2, @1, @4, @5];

    __block NSArray<NSNumber *> *shuffledArray;
    [self measureBlock:^{
        shuffledArray = [array shuffle];
    }];

    XCTAssertEqual(array.count, shuffledArray.count, @"count equals");
    XCTAssertNotEqualObjects(array, shuffledArray);

    NSArray<NSNumber *> *sortedArray = [array sortedArrayUsingSelector:@selector(compare:)];
    NSArray<NSNumber *> *sortedShuffledArray = [shuffledArray sortedArrayUsingSelector:@selector(compare:)];

    XCTAssertEqualObjects(sortedArray, sortedShuffledArray);
}

@end
