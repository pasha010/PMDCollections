//
//  NSArrayMappingTest.m
//  PMDCollections
//
//  Created by Pavel Malkov on 29.06.17.
//  Copyright (c) 2017 Prime Digital. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <PMDCollections/PMDCollections.h>

@interface NSNumber (MapSelectorTest)

- (nullable NSString *)randomNullString;

- (nullable NSString *)everyNullString;

@end

@implementation NSNumber (MapSelectorTest)

- (nullable NSString *)randomNullString {
    if (self.integerValue % 2 == 0) {
        return nil;
    }
    return self.stringValue;
}

- (nullable NSString *)everyNullString {
    return nil;
}

@end

@interface NSArrayMappingTest : XCTestCase

@end

@implementation NSArrayMappingTest

- (void)testMap_block {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];

    __block NSArray<NSString *> *stringArray;
    [self measureBlock:^{
        stringArray = [array map:^NSString *(NSNumber *element) {
            return element.stringValue;
        }];
    }];

    NSArray<NSString *> *result = @[@"1", @"2", @"3", @"4", @"5"];
    XCTAssertEqualObjects(stringArray, result);
}

- (void)testMap_blockThrowsException {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];

    __block NSArray<NSString *> *stringArray;
    [self measureBlock:^{
        stringArray = [array map:^NSString *(NSNumber *element) {
            if (element.integerValue % 2 == 0) {
                @throw [NSException exceptionWithName:@"MapWithBlockException" reason:@"no reason" userInfo:nil];
                return nil;
            }
            return element.stringValue;
        }];
    }];

    NSArray<NSString *> *result = @[@"1", @"3", @"5"];
    XCTAssertEqualObjects(stringArray, result);
}

- (void)testMap_blockThrowsError {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];

    __block NSArray<NSString *> *stringArray;
    [self measureBlock:^{
        stringArray = [array map:^NSString *(NSNumber *element) {
            if (element.integerValue % 2 == 0) {
                @throw [NSError errorWithDomain:@"pm.error" code:-1 userInfo:nil];
                return nil;
            }
            return element.stringValue;
        }];
    }];

    NSArray<NSString *> *result = @[@"1", @"3", @"5"];
    XCTAssertEqualObjects(stringArray, result);
}

- (void)testMap_blockEqualToNil {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];
    NSArray<id> *stringArray = [array map:nil];
    XCTAssertEqualObjects(stringArray, nil);
}

- (void)testMap_blockWhichReturnSomeNils {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];

    NSArray<NSString *> *stringArray = [array map:^NSString *(NSNumber *element) {
        if (element.integerValue % 2 == 0) {
            return nil;
        }
        return element.stringValue;
    }];

    NSArray<NSString *> *result = @[@"1", @"3", @"5"];
    XCTAssertEqualObjects(stringArray, result);
}

- (void)testMap_blockWhichReturnAllNils {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];

    NSArray<id> *nilArray = [array map:^id(NSNumber *element) {
        return nil;
    }];

    XCTAssertEqualObjects(nilArray, @[]);
}

- (void)testMap_selector {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];

    __block NSArray<NSString *> *stringArray;
    [self measureBlock:^{
        stringArray = [array mapBySelector:@selector(stringValue)];
    }];

    NSArray<NSString *> *result = @[@"1", @"2", @"3", @"4", @"5"];
    XCTAssertEqualObjects(stringArray, result);
}

- (void)testMap_selectorEqualToUnrecognized {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];

    __block NSArray<NSString *> *stringArray;
    [self measureBlock:^{
        stringArray = [array mapBySelector:@selector(data)];
    }];

    XCTAssertEqualObjects(stringArray, @[]);
}

- (void)testMap_selectorEqualToNil {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];
    NSArray<NSString *> *stringArray = [array mapBySelector:nil];
    XCTAssertEqualObjects(stringArray, nil);
}

- (void)testMap_selectorWhichReturnSomeNils {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];
    NSArray<NSString *> *stringArray = [array mapBySelector:@selector(randomNullString)];
    NSArray<NSString *> *result = @[@"1", @"3", @"5"];
    XCTAssertEqualObjects(stringArray, result);
}

- (void)testMap_selectorWhichReturnAllNils {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];
    NSArray<NSString *> *stringArray = [array mapBySelector:@selector(everyNullString)];
    XCTAssertEqualObjects(stringArray, @[]);
}

- (NSString *)convertNSNumberToNSString:(NSNumber *)number {
    return [NSString stringWithFormat:@"convert %@", number];
}

- (void)testMap_targetAndSelector {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];

    __block NSArray<NSString *> *stringArray;
    [self measureBlock:^{
        stringArray = [array mapByTarget:self withSelector:@selector(convertNSNumberToNSString:)];
    }];

    NSArray<NSString *> *result = @[@"convert 1", @"convert 2", @"convert 3", @"convert 4", @"convert 5"];
    XCTAssertEqualObjects(stringArray, result);
}

- (void)testMap_targetAndSelectorEqualToUnrecognized {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];
    NSArray<id> *result = [array mapByTarget:self withSelector:@selector(notRealSelector)];
    XCTAssertEqualObjects(result, nil);
}

- (void)testMap_targetAndSelectorEqualToNil {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];
    NSArray<id> *result = [array mapByTarget:self withSelector:nil];
    XCTAssertEqualObjects(result, nil);
}

- (void)testMap_targetAndSelectorWhereTargetIsNil {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];
    NSArray<id> *result = [array mapByTarget:nil withSelector:@selector(description)];
    XCTAssertEqualObjects(result, nil);
}

- (id)throwsError:(NSNumber *)number {
    if (number.integerValue % 2 == 0) {
        @throw [NSError errorWithDomain:@"pm.error" code:-1 userInfo:nil];
        return nil;
    }
    return number.stringValue;
}

- (void)testMap_targetAndSelectorWhichThrowsError {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];

    __block NSArray<NSString *> *stringArray;
    [self measureBlock:^{
        stringArray = [array mapByTarget:self withSelector:@selector(throwsError:)];
    }];

    NSArray<NSString *> *result = @[@"1", @"3", @"5"];
    XCTAssertEqualObjects(stringArray, result);
}

- (id)throwsException:(NSNumber *)number {
    if (number.integerValue % 2 == 0) {
        @throw [NSException exceptionWithName:@"MapWithSelectorException" reason:@"no reason" userInfo:nil];
        return nil;
    }
    return number.stringValue;
}

- (void)testMap_targetAndSelectorWhichThrowsException {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];

    __block NSArray<NSString *> *stringArray;
    [self measureBlock:^{
        stringArray = [array mapByTarget:self withSelector:@selector(throwsException:)];
    }];

    NSArray<NSString *> *result = @[@"1", @"3", @"5"];
    XCTAssertEqualObjects(stringArray, result);
}

- (nullable NSString *)randomNullString:(NSNumber *)number {
    return [number randomNullString];
}

- (nullable NSString *)everyNullString:(NSNumber *)number {
    return [number everyNullString];
}

- (void)testMap_targetAndSelectorWhichReturnSomeNils {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];
    NSArray<NSString *> *stringArray = [array mapByTarget:self withSelector:@selector(randomNullString:)];
    NSArray<NSString *> *result = @[@"1", @"3", @"5"];
    XCTAssertEqualObjects(stringArray, result);
}

- (void)testMap_targetAndSelectorWhichReturnAllNils {
    NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];
    NSArray<NSString *> *stringArray = [array mapByTarget:self withSelector:@selector(everyNullString:)];
    XCTAssertEqualObjects(stringArray, @[]);
}

@end
