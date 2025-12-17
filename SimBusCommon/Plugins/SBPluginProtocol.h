//
//  SBPluginProtocol.h
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <AppKit/AppKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SBEngine;
@class SBSignal;
@class SBEvent;

@protocol SBPlugin <NSObject>

/*****************************************************************************\
|* Return the name to use for this plugin, both instance and class
\*****************************************************************************/
+ (NSString *) pluginName;
- (NSString *) pluginName;

/*****************************************************************************\
|* Return a list of signals of interest to this plugin
\*****************************************************************************/
- (NSArray<SBSignal *> *) signals;

/*****************************************************************************\
|* Tell the plugin which engine it is associated with
\*****************************************************************************/
- (void) setEngine:(SBEngine *)engine;

/*****************************************************************************\
|* Return the view controller used
\*****************************************************************************/
- (NSViewController *)uiViewControllerForPopover:(NSPopover *)popover;

/*****************************************************************************\
|* Allow the plugin to add events into the list of events for a clock-cycle
\*****************************************************************************/
- (void) addEventsTo:(NSMutableArray<SBEvent *> *)list;

/*****************************************************************************\
|* Tell the plugin to process the event that it previously added
\*****************************************************************************/
- (void) process:(SBEvent *)event withSignals:(NSArray<SBSignal *> *)signals;

@end

NS_ASSUME_NONNULL_END
