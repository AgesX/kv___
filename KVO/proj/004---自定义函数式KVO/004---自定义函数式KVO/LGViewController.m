//
//  LGViewController.m
//  004---自定义函数式KVO
//
//  Created by cooci on 2019/1/5.
//  Copyright © 2019 cooci. All rights reserved.
//

#import "LGViewController.h"
#import "LGPerson.h"
#import "NSObject+LGKVO.h"
#import <objc/runtime.h>

@interface LGViewController ()
@property (nonatomic, strong) LGPerson *person;
@end

@implementation LGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.person = [[LGPerson alloc] init];
    [self.person lg_addObserver:self forKeyPath:@"nickName" block:^(id  _Nonnull observer, NSString * _Nonnull keyPath, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"%@-%@",oldValue,newValue);
    }];
    
    [self.person lg_addObserver:self forKeyPath:@"age" block:^(id  _Nonnull observer, NSString * _Nonnull keyPath, id  _Nonnull oldValue, id  _Nonnull newValue) {
        NSLog(@"Xxx : %@-%@",oldValue,newValue);
    }];
     
    self.person.nickName = @"KC";
    // 必须要先初始化
    self.person.age = @100;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.person.nickName = [NSString stringWithFormat:@"%@+",self.person.nickName];
    self.person.age = [NSNumber numberWithInt: 10 + self.person.age.intValue ];
}


- (void)dealloc{
    [self.person lg_removeObserver:self forKeyPath:@"nickName"];
}


#pragma mark - 遍历方法-ivar-property
- (void)printClassAllMethod:(Class)cls{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    for (int i = 0; i<count; i++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        //IMP imp = class_getMethodImplementation(cls, sel);
        NSLog(@"%@",NSStringFromSelector(sel));
    }
    free(methodList);
}

#pragma mark - 遍历类以及子类
- (void)printClasses:(Class)cls{
    /// 注册类的总数
    int count = objc_getClassList(NULL, 0);
    /// 创建一个数组， 其中包含给定对象
    NSMutableArray *mArray = [NSMutableArray arrayWithObject:cls];
    /// 获取所有已注册的类
    Class* classes = (Class*)malloc(sizeof(Class)*count);
    objc_getClassList(classes, count);
    for (int i = 0; i<count; i++) {
        if (cls == class_getSuperclass(classes[i])) {
            [mArray addObject:classes[i]];
        }
    }
    free(classes);
    NSLog(@"classes = %@", mArray);
}
@end
