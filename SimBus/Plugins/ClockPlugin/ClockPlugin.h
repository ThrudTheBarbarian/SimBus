//
//  ClockPlugin.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <Foundation/Foundation.h>
#import "PluginProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface ClockPlugin : NSObject <Plugin>

// List of signals in the clock plugin
@property (strong, nonatomic) NSMutableArray<BusSignal *> *     signals;

// The engine that the clock plugin uses
@property (strong, nonatomic) SBEngine *                        engine;
@end

NS_ASSUME_NONNULL_END
