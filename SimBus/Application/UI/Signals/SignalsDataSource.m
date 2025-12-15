//
//  SignalsDataSource.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import <Common/Common.h>

#import "Defines.h"
#import "Notifications.h"
#import "SignalsDataSource.h"
#import "SignalsItem.h"

@interface SignalsDataSource()
@property(strong, nonatomic) IBOutlet NSCollectionView *        itemsView;
@property(assign, nonatomic) CGFloat splitWidth;
@end

@implementation SignalsDataSource

/*****************************************************************************\
|* Initialise a new data-source object
\*****************************************************************************/
- (instancetype) init
    {
    if (self = [super init])
        {
        _items                      = [NSMutableArray new];
        _splitWidth                 = 200;
        
        NSNotificationCenter *nc    = NSNotificationCenter.defaultCenter;

        // Listen for the user adding items from the UI
        [nc addObserver:self
               selector:@selector(_itemWasAdded:)
                   name:kAddItemNotification
                 object:nil];

        // Listen for the splitview being resized
        [nc addObserver:self
               selector:@selector(_splitViewWasResized:)
                   name:kSignalsWidthChangedNotification
                 object:nil];

        // Listen for the user expanding/collapsing a signal
        [nc addObserver:self
               selector:@selector(_signalsNeedLayout:)
                   name:kSignalsReconfiguredNotification
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
	NSUserInterfaceItemIdentifier identifier = @"SignalsItem";
	NSCollectionViewItem *item = [cv makeItemWithIdentifier:identifier
											   forIndexPath:indexPath];
	if (![item isKindOfClass:[SignalsItem class]])
		return item;

    SignalsItem *entry = (SignalsItem *) item;
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
    [_items addObject:n.object];
    [[SBEngine sharedInstance] addPlugin:n.object];
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
    NSSize size   = NSZeroSize;
	NSInteger idx = indexPath.item;
    
	if ((idx >=0) && (idx < _items.count))
		{
        id <Plugin> item    = _items[idx];
        CGFloat height      = 45;
        for (SBSignal *signal in item.signals)
            height += SIGNAL_VSPACE * (signal.expanded ? signal.width + 1 : 1);
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
- (void) _signalsNeedLayout:(NSNotification *)n
    {
    NSCollectionViewFlowLayout *layout  = _itemsView.collectionViewLayout;
    [layout invalidateLayout];
    }
      
    
@end
