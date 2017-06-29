//
//  PMDQueueTest.m
//  PMDCollections
//
//  Created by Pavel Malkov on 29.06.17.
//  Copyright (c) 2017 Prime Digital. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <PMDCollections/PMDCollections.h>

@interface PMDQueueTest : XCTestCase

@end

@implementation PMDQueueTest

- (void)test_queueCreation {
    PMDQueue<NSNumber *> *queue1 = [PMDQueue queue];
    XCTAssertNotNil(queue1);
    XCTAssertEqual(queue1.count, 0);

    PMDQueue<NSNumber *> *queue2 = [PMDQueue queueWithArray:@[@1, @2, @3]];
    XCTAssertNotNil(queue2);
    XCTAssertEqual(queue2.count, 3);

    PMDQueue<NSNumber *> *queue3 = [[PMDQueue alloc] init];
    XCTAssertNotNil(queue3);
    XCTAssertEqual(queue3.count, 0);
}

- (void)test_enqueue {
    PMDQueue<NSNumber *> *queue = [PMDQueue queueWithArray:@[@1, @2, @3]];
    [queue enqueue:@4];
    XCTAssertEqual(queue.count, 4);
}

- (void)test_dequeue {
    PMDQueue<NSNumber *> *queue = [PMDQueue queueWithArray:@[@1, @2, @3]];
    NSNumber *number = [queue dequeue];
    XCTAssertEqualObjects(number, @1);
    XCTAssertEqual(queue.count, 2);

    number = [queue dequeue];
    XCTAssertEqualObjects(number, @2);
    XCTAssertEqual(queue.count, 1);

    number = [queue dequeue];
    XCTAssertEqualObjects(number, @3);
    XCTAssertEqual(queue.count, 0);
}

- (void)test_enqueueNil {
    PMDQueue<NSNumber *> *queue = [PMDQueue queue];
    [queue enqueue:nil];
    XCTAssertEqual(queue.count, 0);
}

- (void)test_dequeueFromEmpty {
    PMDQueue<NSNumber *> *queue = [PMDQueue queue];
    NSNumber *number = [queue dequeue];
    XCTAssertNil(number);
}

- (void)test_queueCopying {
    PMDQueue<NSNumber *> *queue = [PMDQueue queueWithArray:@[@1, @2, @3]];
    PMDQueue<NSNumber *> *newQueue = [queue copy];
    XCTAssertEqualObjects(@1, [newQueue dequeue]);
    XCTAssertEqualObjects(@2, [newQueue dequeue]);
    XCTAssertEqualObjects(@3, [newQueue dequeue]);
}

- (void)test_equalsToQueue {
    PMDQueue<NSNumber *> *queue = [PMDQueue queueWithArray:@[@1, @2, @3]];
    PMDQueue<NSNumber *> *newQueue = [PMDQueue queueWithArray:@[@1, @2, @3]];
    XCTAssertEqualObjects(queue, newQueue);
}

- (void)test_notEqualsToQueue {
    PMDQueue<NSNumber *> *queue = [PMDQueue queueWithArray:@[@1, @2, @3]];
    PMDQueue<NSNumber *> *newQueue = [PMDQueue queueWithArray:@[@1]];
    XCTAssertNotEqualObjects(queue, newQueue);
}

- (void)test_equalsToSelf {
    PMDQueue<NSNumber *> *queue = [PMDQueue queueWithArray:@[@1, @2, @3]];
    XCTAssertTrue([queue isEqual:queue]);
}

- (void)test_equalsToNil {
    PMDQueue<NSNumber *> *queue = [PMDQueue queueWithArray:@[@1, @2, @3]];
    XCTAssertNotEqualObjects(queue, nil);
}

- (void)test_equalsToOtherObject {
    PMDQueue<NSNumber *> *queue = [PMDQueue queueWithArray:@[@1, @2, @3]];
    NSArray *other = @[@1, @2, @3];
    XCTAssertNotEqualObjects(queue, other);
}

- (void)test_hashEquals {
    PMDQueue<NSNumber *> *queue = [PMDQueue queueWithArray:@[@1, @2, @3]];
    PMDQueue<NSNumber *> *newQueue = [PMDQueue queueWithArray:@[@1, @2, @3]];
    XCTAssertEqual([queue hash], [newQueue hash]);
}

- (void)test_hashNotEquals {
    PMDQueue<NSNumber *> *queue = [PMDQueue queueWithArray:@[@1, @2, @3]];
    PMDQueue<NSNumber *> *newQueue = [PMDQueue queueWithArray:@[@1, @2]];
    XCTAssertNotEqual([queue hash], [newQueue hash]);
}

- (void)test_enumeration {
    PMDQueue<NSNumber *> *queue = [PMDQueue queueWithArray:@[@1, @2, @3]];
    NSMutableArray<NSNumber *> *array = [NSMutableArray array];
    for (NSNumber *number in queue) {
        [array addObject:number];
    }
    NSArray *expected = @[@1, @2, @3];
    XCTAssertEqualObjects(array, expected);
}

- (void)test_coding {
    PMDQueue<NSNumber *> *encodedQueue = [PMDQueue queueWithArray:@[@1, @2, @3]];

    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    archiver.requiresSecureCoding = YES;
    [archiver encodeObject:encodedQueue forKey:NSKeyedArchiveRootObjectKey];
    [archiver finishEncoding];

    XCTAssertNotNil(archiver.encodedData);

    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:archiver.encodedData];
    unarchiver.requiresSecureCoding = YES;
    PMDQueue *decodedQueue = [unarchiver decodeObjectOfClasses:[NSSet setWithArray:@[NSArray.class, PMDQueue.class]]
                                                        forKey:NSKeyedArchiveRootObjectKey];

    XCTAssertNotNil(decodedQueue);
    XCTAssertEqualObjects(encodedQueue, decodedQueue);
}

@end
