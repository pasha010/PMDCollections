//
//  PMDBinaryHeapTest.m
//  PMDCollections
//
//  Created by Pavel Malkov on 29.06.17.
//  Copyright (c) 2017 Prime Digital. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <PMDCollections/PMDCollections.h>

@interface PMDBinaryHeapTest : XCTestCase

@end

@implementation PMDBinaryHeapTest
@end

@implementation PMDBinaryHeapTest (Default)

- (void)test_topAndCount {
    PMDBinaryHeap<NSNumber *> *heap = [PMDBinaryHeap binaryHeap];

    NSArray<NSNumber *> *array = @[@-4, @-3, @-2, @-1, @0, @1, @2, @3, @4];
    [array enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        [heap addObject:obj];
    }];

    XCTAssertEqualObjects(heap.topObject, @(-4), @"-4 is the smallest number so it should be on top.");
    XCTAssertEqual(heap.count, 9, @"9 objects were inserted.");

    [heap removeTopObject];

    XCTAssertEqualObjects(heap.topObject, @(-3));
    XCTAssertEqual(heap.count, 8);

    [heap removeTopObject];

    XCTAssertEqualObjects(heap.topObject, @(-2));
    XCTAssertEqual(heap.count, 7);

    [heap removeTopObject];

    XCTAssertEqualObjects(heap.topObject, @(-1));
    XCTAssertEqual(heap.count, 6);

    [heap removeTopObject];

    XCTAssertEqualObjects(heap.topObject, @0);
    XCTAssertEqual(heap.count, 5);

    [heap removeTopObject]; // count = 4

    XCTAssertEqualObjects(heap.topObject, @1);
    XCTAssertEqual(heap.count, 4);

    [heap removeTopObject]; // count = 3

    XCTAssertEqualObjects(heap.topObject, @2);
    XCTAssertEqual(heap.count, 3);

    [heap removeTopObject]; // count = 2

    XCTAssertEqualObjects(heap.topObject, @3);
    XCTAssertEqual(heap.count, 2);

    [heap removeTopObject]; // count = 1

    XCTAssertEqualObjects(heap.topObject, @4);
    XCTAssertEqual(heap.count, 1);

    [heap removeTopObject];
    XCTAssertEqualObjects(heap.topObject, nil);
    XCTAssertEqual(heap.count, 0);
}

- (void)test_addNilObject {
    PMDBinaryHeap<NSNumber *> *heap = [PMDBinaryHeap binaryHeap];
    [heap addObject:@1];
    [heap addObject:@2];
    [heap addObject:nil];
    XCTAssertEqual(heap.count, 2);
}

- (void)test_countOfObject {
    PMDBinaryHeap<NSNumber *> *heap = [PMDBinaryHeap binaryHeap];
    [heap addObject:@1];
    [heap addObject:@2];
    [heap addObject:@3];
    [heap addObject:@3];
    [heap addObject:@3];
    [heap addObject:@3];
    [heap addObject:@2];

    XCTAssertEqual([heap countOfObject:@2], 2);
    XCTAssertEqual([heap countOfObject:@3], 4);
}

- (void)test_containsObject {
    PMDBinaryHeap<NSNumber *> *heap = [PMDBinaryHeap binaryHeap];
    [heap addObject:@1];
    [heap addObject:@2];
    [heap addObject:@3];

    XCTAssertEqual(heap.count, 3);

    XCTAssert([heap containsObject:@2]);
    [heap removeTopObject];
    XCTAssert([heap containsObject:@2]);

    [heap removeTopObject];
    XCTAssertFalse([heap containsObject:@2]);
}

- (void)test_removeAllObjects {
    PMDBinaryHeap<NSNumber *> *heap = [PMDBinaryHeap binaryHeap];
    [heap addObject:@1];
    [heap addObject:@2];
    [heap addObject:@3];

    XCTAssertEqual(heap.count, 3);

    [heap removeAllObjects];

    XCTAssertEqual(heap.count, 0);
}

- (void)test_removeAllObjectsFromEmptyHeap {
    PMDBinaryHeap<NSNumber *> *heap = [PMDBinaryHeap binaryHeap];

    XCTAssertEqual(heap.count, 0);

    [heap removeAllObjects];

    XCTAssertEqual(heap.count, 0);
}

- (void)test_topFromEmptyHeap {
    PMDBinaryHeap<NSNumber *> *heap = [PMDBinaryHeap binaryHeap];

    XCTAssertEqual(heap.count, 0);

    XCTAssertNil(heap.topObject);
}

- (void)test_popTopObject {
    PMDBinaryHeap<NSNumber *> *heap = [PMDBinaryHeap binaryHeap];
    [heap addObject:@1];
    [heap addObject:@2];
    [heap addObject:@3];

    XCTAssertEqual(heap.count, 3);
    XCTAssertEqualObjects(heap.topObject, @1);

    XCTAssertEqualObjects([heap popTopObject], @1);
    XCTAssertEqual(heap.count, 2);
}

- (void)test_allValues {
    PMDBinaryHeap<NSNumber *> *heap = [PMDBinaryHeap binaryHeap];
    [heap addObject:@3];
    [heap addObject:@8];
    [heap addObject:@5];
    [heap addObject:@2];
    [heap addObject:@4];
    [heap addObject:@4];
    [heap addObject:@6];
    [heap addObject:@1];
    [heap addObject:@7];

    NSArray<NSNumber *> *result = @[@1, @2, @3, @4, @4, @5, @6, @7, @8];
    XCTAssertEqualObjects(heap.allValues, result);
}

- (void)test_allValuesFromEmptyHeap {
    PMDBinaryHeap<NSNumber *> *heap = [PMDBinaryHeap binaryHeap];
    XCTAssertNil(heap.allValues);
}

- (void)test_enumeration {
    PMDBinaryHeap<NSNumber *> *heap = [PMDBinaryHeap binaryHeap];
    [heap addObject:@3];
    [heap addObject:@8];
    [heap addObject:@5];

    NSMutableArray<NSNumber *> *array = [NSMutableArray array];
    [heap enumerateObjectsUsingBlock:^(NSNumber *element) {
        [array addObject:element];
    }];
    NSArray<NSNumber *> *expected = @[@3, @5, @8];
    XCTAssertEqualObjects(array, expected);
}

- (void)test_enumerationThrowsException {
    PMDBinaryHeap<NSNumber *> *heap = [PMDBinaryHeap binaryHeap];
    [heap addObject:@3];
    [heap addObject:@8];
    [heap addObject:@5];

    NSMutableArray<NSNumber *> *array = [NSMutableArray array];
    XCTAssertThrows([heap enumerateObjectsUsingBlock:^(NSNumber *element) {
        if (element.integerValue == 8) {
            @throw [NSError errorWithDomain:@"pm.error" code:-4 userInfo:nil];
        }
        [array addObject:element];
    }]);

    NSArray<NSNumber *> *expected = @[@3, @5];
    XCTAssertEqualObjects(array, expected);
}

- (void)test_copying {
    PMDBinaryHeap<NSNumber *> *heap = [PMDBinaryHeap binaryHeap];
    [heap addObject:@3];
    [heap addObject:@8];
    [heap addObject:@5];

    PMDBinaryHeap<NSNumber *> *newHeap = [heap copy];
    XCTAssertEqualObjects(heap.allValues, newHeap.allValues);
}

@end

@implementation PMDBinaryHeapTest (Descending)

- (void)test_desc_topAndCount {
    PMDBinaryHeap<NSNumber *> *heap = [PMDBinaryHeap binaryHeapWithComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        return [obj2 compare:obj1];
    }];

    NSArray<NSNumber *> *array = @[@-4, @-3, @-2, @-1, @0, @1, @2, @3, @4];
    [array enumerateObjectsUsingBlock:^(NSNumber *obj, NSUInteger idx, BOOL *stop) {
        [heap addObject:obj];
    }];

    XCTAssertEqualObjects(heap.topObject, @4, @"4 is the smallest number so it should be on top.");
    XCTAssertEqual(heap.count, 9, @"9 objects were inserted.");

    [heap removeTopObject];

    XCTAssertEqualObjects(heap.topObject, @3);
    XCTAssertEqual(heap.count, 8);

    [heap removeTopObject];

    XCTAssertEqualObjects(heap.topObject, @2);
    XCTAssertEqual(heap.count, 7);

    [heap removeTopObject];

    XCTAssertEqualObjects(heap.topObject, @1);
    XCTAssertEqual(heap.count, 6);

    [heap removeTopObject];

    XCTAssertEqualObjects(heap.topObject, @0);
    XCTAssertEqual(heap.count, 5);

    [heap removeTopObject]; // count = 4

    XCTAssertEqualObjects(heap.topObject, @-1);
    XCTAssertEqual(heap.count, 4);

    [heap removeTopObject]; // count = 3

    XCTAssertEqualObjects(heap.topObject, @-2);
    XCTAssertEqual(heap.count, 3);

    [heap removeTopObject]; // count = 2

    XCTAssertEqualObjects(heap.topObject, @-3);
    XCTAssertEqual(heap.count, 2);

    [heap removeTopObject]; // count = 1

    XCTAssertEqualObjects(heap.topObject, @-4);
    XCTAssertEqual(heap.count, 1);

    [heap removeTopObject];
    XCTAssertEqualObjects(heap.topObject, nil);
    XCTAssertEqual(heap.count, 0);
}

@end
