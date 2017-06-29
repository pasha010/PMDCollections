//
//  Copyright © 2014-2017 Prime Digital. All rights reserved.
// 
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
// 
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
// 
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
//  Created by Pavel Malkov on 29.06.17.
//

#import "NSArray+PMDCreation.h"

//  неплохо бы создать имплементацию без добавлению кучи элементов в массив

@implementation NSArray (PMDCreationFromRange)

+ (nullable NSArray<NSNumber *> *)arrayFromIndex:(NSInteger)startIndex toIndex:(NSInteger)endIndex {
    if (startIndex >= endIndex) {
        return nil;
    }

    NSMutableArray<NSNumber *> *array = [NSMutableArray array];
    for (NSInteger i = startIndex; i < (endIndex + 1); i++) {
        [array addObject:@(i)];
    }
    return array;
}

@end
