//
//  PMDQueue
//  PMDCollections
//
//  Created by Pavel Malkov on 28.06.17.
//  Copyright (c) 2014-2017 Prime Digital. All rights reserved.
//

#import "PMDQueue.h"


@interface PMDQueue<__covariant id> ()

@property (nonnull, nonatomic, strong) NSMutableArray<id> *array;

@end

@implementation PMDQueue

@dynamic count;

+ (instancetype)queue {
    return [PMDQueue queueWithArray:nil];
}

+ (instancetype)queueWithArray:(nullable NSArray<id> *)array {
    return [[PMDQueue alloc] initWithArray:array];
}

- (instancetype)init {
    return [self initWithArray:nil];
}

- (instancetype)initWithArray:(nullable NSArray<id> *)array {
    self = [super init];
    if (self) {
        _array = [NSMutableArray arrayWithArray:array];
    }
    return self;
}

- (void)enqueue:(nonnull id)object {
    if (object) {
        [_array addObject:object];
    }
}

- (nullable id)dequeue {
    if (_array.count > 0) {
        id object = _array.firstObject;
        [_array removeObjectAtIndex:0];
        return object;
    }
    return NULL;
}

- (NSUInteger)count {
    return _array.count;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[PMDQueue allocWithZone:zone] initWithArray:[_array copy]];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained _Nullable[_Nonnull])buffer count:(NSUInteger)len {
    return [_array countByEnumeratingWithState:state objects:buffer count:len];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:[_array copy] forKey:@"array"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSArray *array = [coder decodeObjectForKey:@"array"];
    return [self initWithArray:array];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }

    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    PMDQueue *queue = (PMDQueue *)other;

    if (_array != queue.array && ![_array isEqualToArray:queue.array]) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash {
    return [_array hash];
}

- (NSString *)description {
    NSString *arrayAsString = [self.array componentsJoinedByString:@", "];
    return [NSString stringWithFormat:@"%@: (%@)", NSStringFromClass([self class]), arrayAsString];
}

@end
