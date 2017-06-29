//
//  PMDStack
//  PMDCollections
//
//  Created by Pavel Malkov on 28.06.17.
//  Copyright (c) 2014-2017 Prime Digital. All rights reserved.
//

#import "PMDStack.h"


@interface PMDStack<__covariant ObjectType> ()

@property (nonnull, nonatomic, strong) NSMutableArray<ObjectType> *array;

@end

@implementation PMDStack

@dynamic count;

- (instancetype)initWithCoder:(NSCoder *)coder {
    NSArray *array = [coder decodeObject];
    return [self initWithArray:array];
}

- (instancetype)init {
    return [self initWithArray:nil];
}

- (instancetype)initWithSet:(nullable NSSet<id> *)set {
    return [self initWithArray:set.allObjects];
}

- (instancetype)initWithArray:(nullable NSArray<id> *)array {
    self = [super init];
    if (self) {
        _array = [NSMutableArray arrayWithArray:array];
    }
    return self;
}

- (void)push:(nonnull  id)object {
    if (!object) {
        return;
    }
    [_array addObject:object];
}

- (nullable id)pop {
    if (_array.count > 0) {
        id object = _array.lastObject;
        [_array removeLastObject];
        return object;
    }
    return nil;
}

- (nullable  id)peek {
    if (_array.count > 0) {
        id object = _array.lastObject;
        return object;
    }
    return nil;
}

- (NSUInteger)count {
    return _array.count;
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [[PMDStack allocWithZone:zone] initWithArray:[_array copy]];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained _Nullable[_Nonnull])buffer count:(NSUInteger)len {
    return [_array countByEnumeratingWithState:state objects:buffer count:len];
}

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:_array];
}

- (BOOL)isEqual:(id)other {
    if (other == self) {
        return YES;
    }
    if (!other || ![[other class] isEqual:[self class]]) {
        return NO;
    }

    PMDStack *stack = other;
    if (self.array != stack.array && ![self.array isEqualToArray:stack.array]) {
        return NO;
    }
    return YES;
}

- (NSUInteger)hash {
    return [self.array hash];
}

@end