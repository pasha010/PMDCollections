//
//  PMDQueueTest.m
//  PMDCollections
//
//  Created by Pavel Malkov on 29.06.17.
//  Copyright (c) 2017 Prime Digital. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <PMDCollections/PMDCollections.h>

@interface PMDStackTest : XCTestCase

@end

@implementation PMDStackTest

- (void)test_stackCreation {
    PMDStack<NSNumber *> *stack1 = [PMDStack stack];
    XCTAssertNotNil(stack1);

    PMDStack *stack2 = [PMDStack stackWithArray:@[@1, @2]];
    XCTAssertNotNil(stack2);
}

- (void)test_push {
    PMDStack<NSNumber *> *stack = [PMDStack stack];
    [stack push:@1];
    XCTAssertEqual(stack.count, 1);
    
    [stack push:@5];
    XCTAssertEqual(stack.count, 2);
}

- (void)test_pushNil {
    PMDStack<NSNumber *> *stack = [PMDStack stack];
    [stack push:nil];
    XCTAssertEqual(stack.count, 0);
}

- (void)test_pop {
    PMDStack<NSNumber *> *stack = [PMDStack stackWithArray:@[@1, @2]];
    NSNumber *element = [stack pop];
    XCTAssertEqual(stack.count, 1);
    XCTAssertEqualObjects(element, @2);
}

- (void)test_popFromEmpty {
    PMDStack<NSNumber *> *stack = [PMDStack stack];
    NSNumber *number = [stack pop];
    XCTAssertNil(number);
    XCTAssertEqual(stack.count, 0);
}

- (void)test_peek {
    PMDStack<NSNumber *> *stack = [PMDStack stackWithArray:@[@1, @2]];
    NSNumber *number = [stack peek];
    XCTAssertEqualObjects(number, @2);
    XCTAssertEqual(stack.count, 2);
}

- (void)test_peekFromEmpty {
    PMDStack<NSNumber *> *stack = [PMDStack stack];
    NSNumber *number = [stack peek];
    XCTAssertNil(number);
    XCTAssertEqual(stack.count, 0);
}

- (void)test_equal {
    PMDStack<NSNumber *> *stack1 = [PMDStack stackWithArray:@[@1, @2]];
    PMDStack<NSNumber *> *stack2 = [PMDStack stackWithArray:@[@1, @2]];
    XCTAssertTrue([stack1 isEqual:stack2]);
}

- (void)test_equalToSelf {
    PMDStack<NSNumber *> *stack = [PMDStack stackWithArray:@[@1, @2]];
    XCTAssertTrue([stack isEqual:stack]);
}

- (void)test_notEqualToNil {
    PMDStack<NSNumber *> *stack = [PMDStack stackWithArray:@[@1, @2]];
    XCTAssertFalse([stack isEqual:nil]);
}

- (void)test_notEqualToOther {
    PMDStack<NSNumber *> *stack1 = [PMDStack stackWithArray:@[@1, @2]];
    PMDStack<NSNumber *> *stack2 = [PMDStack stackWithArray:@[@1, @2, @1]];
    XCTAssertFalse([stack1 isEqual:stack2]);
}

- (void)test_hashEquals {
    PMDStack<NSNumber *> *stack1 = [PMDStack stackWithArray:@[@1, @2]];
    PMDStack<NSNumber *> *stack2 = [PMDStack stackWithArray:@[@1, @2]];
    XCTAssertEqual([stack1 hash], [stack2 hash]);
}

- (void)test_hashNotEquals {
    PMDStack<NSNumber *> *stack1 = [PMDStack stackWithArray:@[@1, @2]];
    PMDStack<NSNumber *> *stack2 = [PMDStack stackWithArray:@[@1, @2, @3]];
    XCTAssertNotEqual([stack1 hash], [stack2 hash]);
}

- (void)test_enumeration {
    PMDStack<NSNumber *> *stack = [PMDStack stackWithArray:@[@1, @2, @3]];
    NSMutableArray<NSNumber *> *array = [NSMutableArray array];
    for (NSNumber *number in stack) {
        [array addObject:number];
    }
    NSArray *expected = @[@3, @2, @1];
    XCTAssertEqualObjects(array, expected);
}

- (void)test_coding {
    PMDStack<NSNumber *> *encodedStack = [PMDStack stackWithArray:@[@1, @2, @3, @4]];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:encodedStack];
    XCTAssertNotNil(data);

    PMDStack<NSNumber *> *decodedStack = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    XCTAssertNotNil(decodedStack);
    XCTAssertEqualObjects(encodedStack, decodedStack);
}

- (void)test_secureCoding {
    PMDStack<NSNumber *> *encodedStack = [PMDStack stackWithArray:@[@1, @2, @3, @4]];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:[NSMutableData data]];
    archiver.requiresSecureCoding = YES;
    [archiver encodeObject:encodedStack forKey:NSKeyedArchiveRootObjectKey];
    [archiver finishEncoding];

    XCTAssertNotNil(archiver.encodedData);

    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:archiver.encodedData];
    unarchiver.requiresSecureCoding = YES;
    PMDStack<NSNumber *> *decodedStack = [unarchiver decodeObjectOfClasses:[NSSet setWithArray:@[NSArray.class, PMDStack.class]]
                                                                    forKey:NSKeyedArchiveRootObjectKey];

    XCTAssertNotNil(decodedStack);
    XCTAssertEqualObjects(encodedStack, decodedStack);
}

- (void)test_copying {
    PMDStack<NSNumber *> *stack1 = [PMDStack stackWithArray:@[@1, @2]];
    PMDStack<NSNumber *> *stack2 = [stack1 copy];
    XCTAssertEqualObjects(stack1, stack2);
}

- (void)test_description {
    PMDStack<NSNumber *> *stack = [PMDStack stackWithArray:@[@1, @2]];
    NSString *description = stack.description;
    XCTAssertEqualObjects(description, @"<PMDStack: (2, 1)>");
}

@end