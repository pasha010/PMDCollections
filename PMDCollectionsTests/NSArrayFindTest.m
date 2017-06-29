//
//  NSArrayFindTest.m
//  PMDCollections
//
//  Created by Pavel Malkov on 29.06.17.
//  Copyright (c) 2017 Prime Digital. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <PMDCollections/PMDCollections.h>

@interface NSArrayFindTest : XCTestCase

@end

@implementation NSArrayFindTest

- (void)testFind_block {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];
    __block NSNumber *three = nil;
    [self measureBlock:^{
        three = [array find:^BOOL(NSNumber *element) {
            return element.integerValue == 3;
        }];
    }];
    XCTAssertEqualObjects(three, @3);
}

- (void)testFind_blockNonExistingElement {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];
    NSNumber *obj = [array find:^BOOL(NSNumber *element) {
        return element.integerValue == 323;
    }];
    XCTAssertEqualObjects(obj, nil);
}

- (void)testFind_blockEqualToNil {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];
    NSNumber *obj = [array find:nil];
    XCTAssertEqualObjects(obj, nil);
}

- (void)testFind_blockThrowsError {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];
    NSNumber *three = [array find:^BOOL(NSNumber *element) {
        if (element.integerValue == 2) {
            @throw [NSError errorWithDomain:@"pm.error" code:-3 userInfo:nil];
            return NO;
        }
        return element.integerValue == 3;
    }];
    XCTAssertEqualObjects(three, @3);
}

- (void)testFind_blockThrowsException {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];
    NSNumber *three = [array find:^BOOL(NSNumber *element) {
        if (element.integerValue == 2) {
            @throw [NSException exceptionWithName:@"FindWithBlockException" reason:@"no reason" userInfo:nil];
            return NO;
        }
        return element.integerValue == 3;
    }];
    XCTAssertEqualObjects(three, @3);
}

- (BOOL)findFunction:(NSNumber *)number {
    return number.integerValue == 3;
}

- (void)testFind_selector {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];
    __block NSNumber *three = nil;
    [self measureBlock:^{
        three = [array findByTarget:self withSelector:@selector(findFunction:)];
    }];
    XCTAssertEqualObjects(three, @3);
}

- (BOOL)findNonExistingFunction:(NSNumber *)number {
    return number.integerValue == 3987;
}

- (void)testFind_selectorNonExistingElement {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];
    __block NSNumber *obj = nil;
    [self measureBlock:^{
        obj = [array findByTarget:self withSelector:@selector(findNonExistingFunction:)];
    }];
    XCTAssertEqualObjects(obj, nil);
}

- (void)testFind_selectorEqualToNil {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];
    NSNumber *three = [array findByTarget:self withSelector:nil];
    XCTAssertEqualObjects(three, nil);
}

- (void)testFind_selectorEqualToUnrecognized {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];
    NSNumber *three = [array findByTarget:self withSelector:@selector(someUnercognizedSelector)];
    XCTAssertEqualObjects(three, nil);
}

- (void)testFind_selectorWhereTargetIsNil {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];
    NSNumber *three = [array findByTarget:nil withSelector:@selector(description)];
    XCTAssertEqualObjects(three, nil);
}

- (BOOL)throwsError:(NSNumber *)number {
    if (number.integerValue == 2) {
        @throw [NSError errorWithDomain:@"pm.error" code:-3 userInfo:nil];
        return NO;
    }
    return number.integerValue == 3;
}

- (void)testFind_selectorThrowsError {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];
    NSNumber *three = [array findByTarget:self withSelector:@selector(throwsError:)];
    XCTAssertEqualObjects(three, @3);
}

- (BOOL)throwsException:(NSNumber *)number {
    if (number.integerValue == 2) {
        @throw [NSException exceptionWithName:@"FindWithSelectorException" reason:@"no reason" userInfo:nil];
        return NO;
    }
    return number.integerValue == 3;
}

- (void)testFind_selectorThrowsException {
    NSArray<NSNumber *> *array = @[@0, @1, @2, @3, @4, @5];
    NSNumber *three = [array findByTarget:self withSelector:@selector(throwsException:)];
    XCTAssertEqualObjects(three, @3);
}

@end
