//
//  LGViewController.m
//  002---KVO原理探讨
//
//  Created by cooci on 2019/1/5.
//  Copyright © 2019 cooci. All rights reserved.
//

#import "LGViewController.h"
#import "LGPerson.h"
#import <objc/runtime.h>
#import "LGStudent.h"

@interface LGViewController()
@property (nonatomic, strong) LGPerson *person;
@end

@implementation LGViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // KVO 底层原理
    // 1: 只对属性观察 setter
    // 2: 中间类 - self.person -> LGPerson isa 发生了变化 NSKVONotifying_LGPerson (LGPerson 子类)
    // 3: 有什么东西 - 方法 - 属性 setNickName - class - dealloc - _isKVOA
    //  3.1 继承 - 重写 - 实实在在的 实现
    // 4: setter 子类 - 父类改变 nickName 传值
    //  4.1 willchange 父类的setter  didChange 
    // 5: NSKVONotifying_LGPerson 是否移除 + isa 是否会回来 在移除观察的时候
    
   // [self printClasses:[LGPerson class]];
    self.person = [[LGPerson alloc] init];
    
    
    
    
    [self.person addObserver:self forKeyPath:@"nickName" options:(NSKeyValueObservingOptionNew) context:NULL];
    
    
    
    [self.person addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionNew) context:NULL];
   // [self printClasses:[LGPerson class]];
    
    NSLog(@"\n\n\nLGPerson");
    [self printClassAllMethod:[LGPerson class]];
    NSLog(@"\n\n\nNSKVONotifying_LGPerson");
    [self printClassAllMethod:objc_getClass("NSKVONotifying_LGPerson")];
    NSLog(@"\n\n\nLGStudent");
    [self printClassAllMethod:[LGStudent class]];

}

//-  setNICK:(NSString *)nickname{
//
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"实际情况:%@-%@",self.person.nickName,self.person->name);
    self.person.nickName = @"KC";
    self.person->name    = @"Cooci";
}

#pragma mark - KVO回调
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    NSLog(@"%@",change);
}

- (void)dealloc{
//    [self.person removeObserver:self forKeyPath:@"name"];
    [self.person removeObserver:self forKeyPath:@"nickName"];
}

















#pragma mark - 遍历方法-ivar-property
- (void)printClassAllMethod:(Class)cls{
    unsigned int count = 0;
    Method *methodList = class_copyMethodList(cls, &count);
    for (int i = 0; i<count; i++) {
        Method method = methodList[i];
        SEL sel = method_getName(method);
        IMP imp = class_getMethodImplementation(cls, sel);
        NSLog(@"\n\n\n%d,  %@   \n-  %p", i, NSStringFromSelector(sel), imp);
    }
    free(methodList);
}



// 通过地址，判断对于方法，是继承，还是重写











#pragma mark - 遍历类以及子类
- (void)printClasses:(Class)cls{
    
    // 注册类的总数
    int count = objc_getClassList(NULL, 0);
    // 创建一个数组， 其中包含给定对象
    NSMutableArray *mArray = [NSMutableArray arrayWithObject:cls];
    
    Class* classes = (Class*)malloc(sizeof(Class)*count);
    
    // 获取所有已注册的类
    //  count  = 21789
    objc_getClassList(classes, count);
    
    
    
    for (int i = 0; i<count; i++) {
        if (cls == class_getSuperclass(classes[i])) {
            [mArray addObject:classes[i]];
        }
    }
    free(classes);
    NSLog(@"count  = %d  \n\n,classes = %@", count, mArray);
}









@end
