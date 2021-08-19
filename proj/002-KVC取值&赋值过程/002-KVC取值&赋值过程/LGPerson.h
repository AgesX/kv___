//
//  LGPerson.h
//  002-KVC取值&赋值过程
//
//  Created by Cooci on 2019/12/7.
//  Copyright © 2019 Cooci. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGStudent.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGPerson : NSObject{
    
    @public                     //          按顺序，来处理，
                                //          来赋值 , assign value
        
        NSString *_name;
        NSString *_isName;
        NSString *name;
        NSString *isName;
        
        //
    
        
    
    

}

@property (nonatomic, strong) NSArray *arr;
@property (nonatomic, strong) NSSet   *set;

@property (nonatomic, copy) NSString   *deng;

@end






@interface Bull : NSObject{
    
    @public                     //          按顺序，来处理，
                                //          来赋值 , assign value
        NSString *_isName;
        NSString *name;
        NSString *isName;
        
// 注意这里
    
    
}


@end


NS_ASSUME_NONNULL_END



//  我还以为，这里会有啥协议





