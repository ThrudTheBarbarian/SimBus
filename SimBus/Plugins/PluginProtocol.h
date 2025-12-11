//
//  PluginProtocol.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <Foundation/Foundation.h>
#import <Common/Common.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Plugin <NSObject>

- (NSArray<BusSignal *> *) signals;

@end

NS_ASSUME_NONNULL_END
