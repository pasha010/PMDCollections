//
//  PMDBinaryHeap
//  PMDCollections
// 
//  Created by Pavel Malkov on 28.06.17.
//  Copyright (c) 2014-2017 Prime Digital. All rights reserved.
//

#import <CoreFoundation/CFBinaryHeap.h>
#import <CoreFoundation/CoreFoundation.h>
#import "PMDBinaryHeap.h"

@interface PMDBinaryHeap ()

@property (nonnull, nonatomic) CFBinaryHeapRef binaryHeap;
@property (nonnull, nonatomic, copy, readonly) NSComparator comparator;
@property (nonatomic, assign, readonly) NSComparisonResult ordering;

@end

static const void *PMDBinaryHeapRetain(CFAllocatorRef __unused all, const void *ptr) {
    return (const void *)CFRetain((CFTypeRef)ptr);
}

static void PMDBinaryHeapRelease(CFAllocatorRef __unused all, const void *ptr) {
    CFRelease((CFTypeRef)ptr);
}

static CFComparisonResult PMDBinaryHeapCompare(const void *ptr1, const void *ptr2, void *__unused info) {
    id obj1 = (__bridge id)ptr1;
    id obj2 = (__bridge id) ptr2;
    PMDBinaryHeap *pmdBinaryHeap = (__bridge PMDBinaryHeap *)info;
    return (CFComparisonResult) pmdBinaryHeap.comparator(obj1, obj2);
}

static void PMDBinaryHeapApply(const void *val, void *context) {
    void (^block)(id) = (__bridge void (^)(__strong id))(context);
    if (block) {
        block((__bridge id)(val));
    }
}

@implementation PMDBinaryHeap

@dynamic count;
@dynamic topObject;
@dynamic allValues;

- (instancetype)initWithOrderingType:(NSComparisonResult)ordering comparator:(NSComparator)comparator {
    self = [super init];
    if (self) {
        _ordering = ordering;
        _comparator = [comparator copy];

        CFBinaryHeapCallBacks callbacks = (CFBinaryHeapCallBacks) {
                .version = 0,
                .retain = &PMDBinaryHeapRetain,
                .release = &PMDBinaryHeapRelease,
                .copyDescription = &CFCopyDescription,
                .compare = &PMDBinaryHeapCompare
        };

        CFBinaryHeapCompareContext compareContext = (CFBinaryHeapCompareContext) {
                .version = 0,
                .info = (__bridge void *)(self),
                .retain = NULL,
                .release = NULL,
                .copyDescription = NULL,
        };
        _binaryHeap = CFBinaryHeapCreate(kCFAllocatorDefault, 0, &callbacks, &compareContext);
    }
    return self;
}

- (NSUInteger)count {
    CFIndex count = CFBinaryHeapGetCount(_binaryHeap);
    if (count < 0) {
        return 0;
    }
    return (NSUInteger) count;
}

- (NSUInteger)countOfObject:(nonnull id)object {
    return (NSUInteger) CFBinaryHeapGetCountOfValue(_binaryHeap, (__bridge const void *)(object));
}

- (BOOL)containsObject:(nonnull id)object {
    return CFBinaryHeapContainsValue(_binaryHeap, (__bridge const void *)(object));;
}

- (nullable id)topObject {
    const void *ptr = NULL;
    if (!CFBinaryHeapGetMinimumIfPresent(_binaryHeap, &ptr)) {
        return nil;
    }

    id object = (__bridge id)ptr;

    return object;
}

- (void)addObject:(nonnull id)object {
    CFBinaryHeapAddValue(_binaryHeap, (__bridge void *)object);
}

- (nullable id)popTopObject {
    id topObject = [self topObject];
    if (topObject) {
        [self removeTopObject];
    }
    return topObject;
}

- (void)removeTopObject {
    CFBinaryHeapRemoveMinimumValue(_binaryHeap);
}

- (void)removeAllObjects {
    CFBinaryHeapRemoveAllValues(_binaryHeap);
}

- (nullable NSSet<id> *)allValues {
    if (self.count == 0) {
        return nil;
    }
    NSMutableSet *set = [NSMutableSet set];

    const void **elements = NULL;
    CFBinaryHeapGetValues(_binaryHeap, elements);

    for (NSUInteger i = 0; i < self.count; i++) {
        id element = (__bridge id)&(*elements)[i];
        if (element) {
            [set addObject:element];
        }
    }
    return [set copy];
}

- (void)enumerateObjectsUsingBlock:(void (^ _Nonnull)(id _Nonnull element))block {

}

- (void)dealloc {
    CFRelease(_binaryHeap);
}

// CFBinaryHeapCreateCopy
- (id)copyWithZone:(nullable NSZone *)zone {
    PMDBinaryHeap *binaryHeap = [[PMDBinaryHeap allocWithZone:zone] initWithOrderingType:_ordering comparator:[_comparator copy]];
    binaryHeap.binaryHeap = CFBinaryHeapCreateCopy(kCFAllocatorDefault, 0, _binaryHeap);
    return binaryHeap;
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state
                                  objects:(id __unsafe_unretained _Nullable[_Nonnull])buffer
                                    count:(NSUInteger)len {
    return [self.allValues countByEnumeratingWithState:state objects:buffer count:len];
}


@end