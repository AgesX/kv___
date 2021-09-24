//
//  NSObject+LGKVO.m
//  003---自定义KVO
//
//  Created by cooci on 2019/1/5.
//  Copyright © 2019 cooci. All rights reserved.
//

#import "NSObject+LGKVO.h"
#import <objc/message.h>

static NSString *const kLGKVOPrefix = @"LGKVONotifying_";
static NSString *const kLGKVOAssiociateKey = @"kLGKVO_AssiociateKey";

@implementation NSObject (LGKVO)

- (void)lg_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context{
    
    // 1: 验证是否存在setter方法 : 不让实例进来
    [self judgeSetterMethodFromKeyPath:keyPath];
    // 2: 动态生成子类
    Class newClass = [self createChildClassWithKeyPath:keyPath];
    // 3: isa的指向 : LGKVONotifying_LGPerson
    object_setClass(self, newClass);
    // 4: 保存观察者
    objc_setAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey), observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)lg_removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath{
    // 指回给父类
    Class superClass = [self class];
    object_setClass(self, superClass);
}

#pragma mark - 验证是否存在setter方法
- (void)judgeSetterMethodFromKeyPath:(NSString *)keyPath{
    Class superClass    = object_getClass(self);
    SEL setterSeletor   = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod(superClass, setterSeletor);
    if (!setterMethod) {
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:[NSString stringWithFormat:@"老铁没有当前%@的setter",keyPath] userInfo:nil];
    }
}

#pragma mark -
- (Class)createChildClassWithKeyPath:(NSString *)keyPath{
    
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClassName = [NSString stringWithFormat:@"%@%@",kLGKVOPrefix,oldClassName];
    Class newClass = NSClassFromString(newClassName);
    // 防止重复创建生成新类
    if (newClass) return newClass;
    /**
     * 如果内存不存在,创建生成
     * 参数一: 父类
     * 参数二: 新类的名字
     * 参数三: 新类的开辟的额外空间
     */
    // 2.1 : 申请类
    newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);
    // 2.2 : 注册类
    objc_registerClassPair(newClass);
    // 2.3.1 : 添加class : class的指向是LGPerson
    SEL classSEL = NSSelectorFromString(@"class");
    Method classMethod = class_getInstanceMethod([self class], classSEL);
    const char *classTypes = method_getTypeEncoding(classMethod);
    class_addMethod(newClass, classSEL, (IMP)lg_class, classTypes);
    // 2.3.2 : 添加setter
    SEL setterSEL = NSSelectorFromString(setterForGetter(keyPath));
    Method setterMethod = class_getInstanceMethod([self class], setterSEL);
    const char *setterTypes = method_getTypeEncoding(setterMethod);
    class_addMethod(newClass, setterSEL, (IMP)lg_setter, setterTypes);
    return newClass;
}











static void lg_setter(id self,SEL _cmd,id newValue){
    NSLog(@"来了:%@",newValue);
    // 4: 消息转发 : 转发给父类
    // 改变父类的值 --- 可以强制类型转换
    
    
    
    
    
    // 给父类发消息，比起直接发消息
    // 据说，可以解决依赖性
    void (*lg_msgSendSuper)(void *,SEL , id) = (void *)objc_msgSendSuper;
    
    
    
    // void /* struct objc_super *super, SEL op, ... */
    struct objc_super superStruct = {
        .receiver = self,                                 // 具体的对象
       // .super_class = class_getSuperclass([self class])               // 闪退大法， [self class] ， 伪
      //  .super_class = class_getSuperclass(object_getClass(self))   // 类里面，有方法列表
        .super_class = [self class]                         // 这里有一个，等价
    };
    //objc_msgSendSuper(&superStruct,_cmd,newValue)
    lg_msgSendSuper(&superStruct,_cmd,newValue);
    
    // 既然观察到了,下一步不就是回调 -- 让我们的观察者调用
    // - (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
    // 1: 拿到观察者
    id observer = objc_getAssociatedObject(self, (__bridge const void * _Nonnull)(kLGKVOAssiociateKey));
    
    // 2: 消息发送给观察者
    SEL observerSEL = @selector(observeValueForKeyPath:ofObject:change:context:);
    NSString *keyPath = getterForSetter(NSStringFromSelector(_cmd));
    
    
    void (*deng_objc_msgSend)(id, SEL , id, id, id, id) = (void *)objc_msgSend;
    
    deng_objc_msgSend(observer,observerSEL,keyPath,self, @{keyPath:newValue}, NULL);
    
}






//  用来，鱼目混珠
Class lg_class(id self,SEL _cmd){
    
    
    // object, 通过对象
    return class_getSuperclass(object_getClass(self));
    
    
    
    
    // objc , 通过名字
    //  objc_getClass(const char * _Nonnull name)
    
    
    
    
    /*
     
     
     
     error: Execution was interrupted,
     
     
     reason: EXC_BAD_ACCESS (code=2, address=0x16bb37fe0).
     
     
     The process has been returned to the state before expression evaluation.
     
     
     */
    
    
    //  死循环，大法
    
    
    //  return class_getSuperclass([self class]);
}







#pragma mark - 从get方法获取set方法的名称 key ===>>> setKey:
static NSString *setterForGetter(NSString *getter){
    
    if (getter.length <= 0) { return nil;}
    
    NSString *firstString = [[getter substringToIndex:1] uppercaseString];
    NSString *leaveString = [getter substringFromIndex:1];
    
    return [NSString stringWithFormat:@"set%@%@:",firstString,leaveString];
}

#pragma mark - 从set方法获取getter方法的名称 set<Key>:===> key
static NSString *getterForSetter(NSString *setter){
    
    if (setter.length <= 0 || ![setter hasPrefix:@"set"] || ![setter hasSuffix:@":"]) { return nil;}
    
    NSRange range = NSMakeRange(3, setter.length-4);
    NSString *getter = [setter substringWithRange:range];
    NSString *firstString = [[getter substringToIndex:1] lowercaseString];
    return  [getter stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:firstString];
}


@end
