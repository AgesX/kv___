//
//  LGPerson.m
//  002-KVC取值&赋值过程
//
//  Created by Cooci on 2019/12/7.
//  Copyright © 2019 Cooci. All rights reserved.
//

#import "LGPerson.h"

@implementation LGPerson

#pragma mark - 关闭或开启实例变量赋值



// 这个，有意思
+ (BOOL)accessInstanceVariablesDirectly{
    return YES;
}


//MARK: - setKey. 的流程分析
- (void)setDeng:(NSString *)dd{
    NSLog(@"\n\n\n%s - %@\n\n\n_",__func__,dd);
  //  self.deng = dd;     // 死循环
    _deng = dd;
}




//MARK: - setKey. 的流程分析
- (void)setName:(NSString *)name{
    NSLog(@"%s - %@",__func__,name);
    
    //  这样就 gg
    //  self->name = name;
    
    self->_name = name;  // 这样 OK
    
    //  _name = name;
    
}

//- (void)_setName:(NSString *)name{
//    NSLog(@"%s - %@",__func__,name);
//}

//- (void)setIsName:(NSString *)name{
//    NSLog(@"%s - %@",__func__,name);
//}















// 没有调用
//- (void)_setIsName:(NSString *)name{
//    NSLog(@"%s - %@",__func__,name);






//      这个方法，是 LG 的， 编的






//}




















//MARK: - valueForKey 流程分析 - get<Key>, <key>, is<Key>, or _<key>,

//- (NSString *)getName{
//    return NSStringFromSelector(_cmd);
//}
//
//- (NSString *)name{
//    return NSStringFromSelector(_cmd);
//}

//- (NSString *)isName{
//    return NSStringFromSelector(_cmd);
//}
//
//- (NSString *)_name{
//    return NSStringFromSelector(_cmd);
//}


//MARK: - 集合类型的走

// 个数
- (NSUInteger)countOfPens{
    NSLog(@"%s",__func__);
    return [self.arr count];
}

// 获取值
- (id)objectInPensAtIndex:(NSUInteger)index {
    NSLog(@"%s",__func__);
    return [NSString stringWithFormat:@"pens %lu", index];
}

//MARK: - set

// 个数
- (NSUInteger)countOfBooks{
    NSLog(@"%s",__func__);
    return [self.set count];
}

// 是否包含这个成员对象
- (id)memberOfBooks:(id)object {
    NSLog(@"%s",__func__);
    return [self.set containsObject:object] ? object : nil;
}

// 迭代器
- (id)enumeratorOfBooks {
    // objectEnumerator
    NSLog(@"来了 迭代编译");
    return [self.arr reverseObjectEnumerator];
}


@end
