//
//  LGViewController.m
//  003---自定义KVO
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
    
    // 通过哈希表，关联。使用表，保存
    
    // 并没有进行持有
    
    // 并不是同一张表， 我感觉，没有魔法
    
    // 这里没有，强引用，循环引用
    [self.person lg_addObserver:self forKeyPath:@"nickName" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    
    [self printClassAllMethod:NSClassFromString(@"NSKVONotifying_LGPerson")];
    [self printClasses:[LGPerson class]];
    self.person.nickName = @"KC";
    self.person->name    = @"Cooci";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.person.nickName = [NSString stringWithFormat: @"%@ ->", self.person.nickName];
    NSLog(@"实际情况:%@    :    -%@",self.person.nickName,self.person->name);
}

#pragma mark - KVO回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"观察方法:  %@",change);
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
