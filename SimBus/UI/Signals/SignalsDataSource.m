//
//  SignalsDataSource.m
//  SimBus
//
//  Created by ThrudTheBarbarian on 11/12/2025.
//

#import "SignalsDataSource.h"

@implementation SignalsDataSource

/*****************************************************************************\
|* Initialise a new data-source object
\*****************************************************************************/
- (instancetype) init
    {
    if (self = [super init])
        {
        _items = [NSMutableArray new];
        }
    return self;
    }
    
/*****************************************************************************\
|* Return the number of items in this collection. In our case, the number
|* of plugin objects (which can be multiple-instantiated)
\*****************************************************************************/
- (NSInteger) collectionView:(NSCollectionView *) collectionView
      numberOfItemsInSection:(NSInteger) section
    {
    return _items.count;
    }


/*****************************************************************************\
|* Return the item at a given index-path
\*****************************************************************************/
- (NSCollectionViewItem *) collectionView:(NSCollectionView *) collectionView 
      itemForRepresentedObjectAtIndexPath:(NSIndexPath *) indexPath
    {
    return nil;
    }

@end
