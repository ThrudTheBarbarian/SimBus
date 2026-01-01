//
//  ModulesDataSource.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <SimBusCommon/SimBusCommon.h>

#import "Defines.h"
#import "ModulesDataSource.h"
#import "ModulesItem.h"
#import "ModulesItemView.h"
#import "SignalExpansionController.h"

@interface ModulesDataSource()
@property(strong, nonatomic) IBOutlet NSCollectionView *        itemsView;
@property(assign, nonatomic) CGFloat                            splitWidth;
@property(strong, nonatomic)
NSMutableDictionary<NSIndexPath *,ModulesItem *> *              itemMap;
@end

@implementation ModulesDataSource

/*****************************************************************************\
|* Initialise a new data-source object
\*****************************************************************************/
- (instancetype) init
    {
    if (self = [super init])
        {
        _items                      = [NSMutableArray new];
        _splitWidth                 = 200;
        _itemMap                    = [NSMutableDictionary new];
        
        NSNotificationCenter *nc    = NSNotificationCenter.defaultCenter;

        // Listen for the user adding items from the UI
        [nc addObserver:self
               selector:@selector(_itemWasAdded:)
                   name:kAddItemNotification
                 object:nil];

        // Listen for the splitview being resized
        [nc addObserver:self
               selector:@selector(_splitViewWasResized:)
                   name:kModulesWidthChangedNotification
                 object:nil];

        // Listen for the user expanding/collapsing a signal
        [nc addObserver:self
               selector:@selector(_modulesNeedLayout:)
                   name:kModulesReconfiguredNotification
                 object:nil];
        }
    return self;
    }
   
/*****************************************************************************\
|* Clean up
\*****************************************************************************/
- (void) dealloc
	{
	NSNotificationCenter *nc = NSNotificationCenter.defaultCenter;
	[nc removeObserver:self];
	}

/*****************************************************************************\
|* Return the number of items in this collection. In our case, the number
|* of plugin objects (which can be multiple-instantiated)
\*****************************************************************************/
- (NSInteger) collectionView:(NSCollectionView *) cv
      numberOfItemsInSection:(NSInteger) section
    {
    [cv setDelegate:self];
    return _items.count;
    }


/*****************************************************************************\
|* Return the item at a given index-path
\*****************************************************************************/
- (NSCollectionViewItem *) collectionView:(NSCollectionView *) cv
      itemForRepresentedObjectAtIndexPath:(NSIndexPath *) indexPath
    {
	NSUserInterfaceItemIdentifier identifier = @"ModulesItem";
	NSCollectionViewItem *item = [cv makeItemWithIdentifier:identifier
											   forIndexPath:indexPath];
	if (![item isKindOfClass:[ModulesItem class]])
		return item;

    ModulesItem *entry  = (ModulesItem *) item;
    _itemMap[indexPath] = entry;
    
	NSInteger idx = indexPath.item;
	if ((idx >=0) && (idx < _items.count))
		[entry.textField setStringValue:_items[idx].pluginName];
    
    [entry setPlugin:_items[idx]];
 
    NSSize size = [self _sizeForItemAtIndexPath:indexPath];
    [entry.view setFrameSize:size];
    
	return item;
    }

#pragma mark - Notifications

/*****************************************************************************\
|* We got a new item added
\*****************************************************************************/
- (void) _itemWasAdded:(NSNotification *)n
    {
    NSNumber * isAuto = (NSNumber *)(n.userInfo[kAutomaticInstantiation]);
    BOOL autoAdd      = isAuto ? isAuto.boolValue : NO;
    
    [_items addObject:n.object];
    [[SBEngine sharedInstance] addPlugin:n.object autoAdd:autoAdd];
    [_itemsView reloadData];
    }

/*****************************************************************************\
|* The user dragged the split-view splitter, resize to fit
\*****************************************************************************/
- (void) _splitViewWasResized:(NSNotification *)n
    {
    NSCollectionViewFlowLayout *layout  = _itemsView.collectionViewLayout;
    
    NSSize size     = layout.itemSize;
    size.width      = ((NSNumber *)(n.object)).floatValue;
    _splitWidth     = size.width;
    layout.itemSize = size;
    [layout invalidateLayout];
    }

/*****************************************************************************\
|* Calculate the size for an item
\*****************************************************************************/
- (NSSize) _sizeForItemAtIndexPath:(NSIndexPath *) indexPath
    {
    NSSize size                     = NSZeroSize;
	NSInteger idx                   = indexPath.item;
    SignalExpansionController *sep  = SignalExpansionController.sharedInstance;
   
    // The first time through this loop, the ModulesItem will not have been
    // set up in the itemMap, but in that case the signal should not be
    // expanded anyway, so we're ok
	if ((idx >=0) && (idx < _items.count))
		{
        id <SBPlugin> item    = _items[idx];
        CGFloat height      = 45;
        for (SBSignal *signal in item.signals)
            {
            BOOL expanded = [sep isExpanded:signal inPlugin:item];
            height += SIGNAL_VSPACE * (expanded ? signal.width + 1 : 1);
            }
        size = NSMakeSize(_splitWidth, height);
       }
    else
        NSLog(@"Cannot find size for item at %@", indexPath);
    return size;
    }
    
/*****************************************************************************\
|* Handle the size of the collection-view item
\*****************************************************************************/
- (NSSize) collectionView:(NSCollectionView *) cv
                   layout:(NSCollectionViewLayout *) collectionViewLayout
   sizeForItemAtIndexPath:(NSIndexPath *) indexPath
    {
    return [self _sizeForItemAtIndexPath:indexPath];
    }
  
/*****************************************************************************\
|* One of our item-views was resized, re-layout
\*****************************************************************************/
- (void) _modulesNeedLayout:(NSNotification *)n
    {
    NSCollectionViewFlowLayout *layout  = _itemsView.collectionViewLayout;
    [layout invalidateLayout];
    }

@end
