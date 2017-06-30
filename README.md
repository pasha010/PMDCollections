# PMDCollections

## Что это?
Касаемо NSArray:
Вспомогательные методы для удобного использования (об этом ниже) и генерация NSArray из NSNumber с помощью стартового и конечного объекта (как Sequence в Swift).

Касаемо структур данных:

Реализованы BinaryHeap, Queue, Stack.

## Функции NSArray

- `map`
- `filter`
- `find`
- `shuffle`

Каждая из них имеет 2 способа вызова:
- блок
- селектор

Примеры использования (более подробно смотреть в [тесты](ссылка))
```
NSArray<NSNumber *> *array = @[@1, @2, @3, @4, @5];
NSLog(@"%@", [array map:^NSString *(NSNumber *element) {
    return [NSString stringWithFormat:@"new value is %@", element.stringValue];
}]);
// print: (newValue is 1, newValue is 2, newValue is 3, newValue is 4, newValue is 5)


```

