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

+ (nonnull NSComparator)defaultComparator {
    static dispatch_once_t token;
    static NSComparator defaultComparator = nil;
    dispatch_once(&token, ^{
        defaultComparator = ^NSComparisonResult(id obj1, id obj2) {
            return [obj1 compare:obj2];
        };
    });
    return [defaultComparator copy];
}

+ (nonnull instancetype)binaryHeap {
    return [PMDBinaryHeap binaryHeapWithComparator:PMDBinaryHeap.defaultComparator];
}

+ (nonnull instancetype)binaryHeapWithComparator:(nonnull NSComparator)comparator {
    return [[PMDBinaryHeap alloc] initWithComparator:comparator];
}

+ (instancetype)binaryHeapWithObjects:(nonnull NSArray<id> *)array {
    return [[PMDBinaryHeap alloc] initWithWithObjects:array];
}

+ (instancetype)binaryHeapWithObjects:(nonnull NSArray<id> *)array comparator:(nonnull NSComparator)comparator {
    return [[PMDBinaryHeap alloc] initWithWithObjects:array comparator:comparator];
}

- (nonnull instancetype)initWithComparator:(nonnull NSComparator)comparator {
    return [self initWithWithObjects:@[] comparator:comparator];
}

- (instancetype)initWithWithObjects:(nonnull NSArray<id> *)array {
    return [self initWithWithObjects:array comparator:PMDBinaryHeap.defaultComparator];
}

- (instancetype)initWithWithObjects:(nonnull NSArray<id> *)array comparator:(nonnull NSComparator)comparator {
    if (!comparator) {
        return nil;
    }
    self = [super init];
    if (self) {
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

        [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [self addObject:obj];
        }];
    }
    return self;
}

- (NSUInteger)count {
    CFIndex count = CFBinaryHeapGetCount(_binaryHeap);
    return (NSUInteger) count;
}

- (NSUInteger)countOfObject:(nonnull id)object {
    return (NSUInteger) CFBinaryHeapGetCountOfValue(_binaryHeap, (__bridge const void *)(object));
}

- (BOOL)containsObject:(nonnull id)object {
    return CFBinaryHeapContainsValue(_binaryHeap, (__bridge const void *)(object));
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
    if (!object) {
        return;
    }
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

- (nullable NSArray<id> *)allValues {
    if (self.count == 0) {
        return nil;
    }
    CFIndex size = CFBinaryHeapGetCount(_binaryHeap);
    CFTypeRef *cfValues = calloc((size_t) size, sizeof(CFTypeRef));
    CFBinaryHeapGetValues(_binaryHeap, cfValues);
    CFArrayRef values = CFArrayCreate(kCFAllocatorDefault, cfValues, size, &kCFTypeArrayCallBacks);
    
    NSArray *set = (__bridge NSArray *)values;
    free(cfValues);

    return set;
}

- (void)enumerateObjectsUsingBlock:(void (^ _Nonnull)(id _Nonnull element))block {
    CFBinaryHeapApplyFunction(_binaryHeap, &PMDBinaryHeapApply, (__bridge void *)(block));
}

- (void)dealloc {
    if (_binaryHeap) {
        CFRelease(_binaryHeap);
    }
}

- (id)copyWithZone:(nullable NSZone *)zone {
    PMDBinaryHeap *binaryHeap = [[PMDBinaryHeap allocWithZone:zone] initWithComparator:[_comparator copy]];
    binaryHeap.binaryHeap = CFBinaryHeapCreateCopy(kCFAllocatorDefault, 0, _binaryHeap);
    return binaryHeap;
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    PMDBinaryHeap *heap = other;
    if (![self.allValues isEqualToArray:heap.allValues]) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash {
    return 31u + [self.allValues hash];
}

- (NSString *)description {
    NSString *allValuesAsString = [self.allValues componentsJoinedByString:@", "];
    return [NSString stringWithFormat:@"<%@: (%@)>", NSStringFromClass([self class]), allValuesAsString];
}

@end
