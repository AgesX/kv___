//
//  ViewController.m
//  002-KVC取值&赋值过程
//
//  Created by Cooci on 2019/12/7.
//  Copyright © 2019 Cooci. All rights reserved.
//

#import "ViewController.h"
#import "LGPerson.h"






@interface ViewController ()

@end





@implementation ViewController



- (void) testOne{
    LGPerson *person = [[LGPerson alloc] init];
    
    // 1: KVC - 设置值的过程 setValue 分析调用过程
     [person setValue:@"dd_LG_Cooci" forKey:@"name"];

//     NSLog(@"%@-%@-%@-%@",person->_name,person->_isName,person->name,person->isName);
//     NSLog(@"%@-%@-%@",person->_isName,person->name,person->isName);
//     NSLog(@"%@-%@",person->name,person->isName);
//     NSLog(@"%@",person->isName);

    // setter - getter  - KVC 设值 和 取值的流程
    // 2: KVC - 取值的过程
    // _name
//    person->_name = @"_name";
//    person->_isName = @"_isName";
    
    
    
    
    
    
    person->name = @"name";
//    person->isName = @"isName";

    NSLog(@"Ta  取值:%@",[person valueForKey:@"name"]);
    
    
    person.deng = @"Ha ha ha";

    NSLog(@"deng 取值:%@",[person valueForKey:@"deng"]);
    
    
    
    
    
    /**
     1: setname _
     2: 间接访问其他的变量
     
     1: getter .....
     2: 集合
     3: 间接
     4: 变量
     
     自定义一下KVC
     */
    
    
}




- (void) testTwo{
    // 这个例子，很神奇
    
    LGPerson *person = [[LGPerson alloc] init];
    
    Bull * ox = [[Bull alloc] init];
    
    
    
    person->_isName = @"_isName";

    NSLog(@"Ta  取值:%@\n\n\n--",[person valueForKey:@"name"]);
    
    ox->_isName = @"\n\n\n_isName 666\n\n\n_";

    NSLog(@"俺  取值:%@",[ox valueForKey:@"name"]);
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    Bull * ox = [[Bull alloc] init];
    Happy * sadness = [[Happy alloc] init];
    
    
    ox->name = @"\n\n\n_isName 666\n\n\n_";

    NSLog(@"俺  取值:%@",[ox valueForKey:@"name"]);
    
    sadness->name = @"来来来 name";
    
    NSLog(@"\n\n\n--额  取值:%@",[sadness valueForKey:@"name"]);
}















//MARK: - 集合类型的KVC 注意

- (void)arraysAndSet{
    
    LGPerson *person = [[LGPerson alloc] init];
    // 3: KVC - 集合类型
    person.arr = @[@"pen0", @"pen1", @"pen2", @"pen3"];
    NSArray *array = [person valueForKey:@"pens"];
    NSLog(@"%@",[array objectAtIndex:1]);
    NSLog(@"%d",[array containsObject:@"pen1"]);
    
    // set 集合
    person.set = [NSSet setWithArray:person.arr];
    NSSet *set = [person valueForKey:@"books"];
    [set enumerateObjectsUsingBlock:^(id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"set遍历 %@",obj);
    }];
}


@end
