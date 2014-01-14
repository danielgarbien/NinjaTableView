/*
 * Copyright (c) 2012 Wojciech Nagrodzki
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

#import "NGNinjaTableView.h"


@interface NGNinjaTableViewDelegateAndDataSourceSurrogate()<UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) NSObject<UITableViewDelegate>* tableViewDelegate;
@property (weak, nonatomic) NSObject<UITableViewDataSource>* tableViewDataSource;
@property (weak, nonatomic) NGNinjaTableView * ninjaTableView;

@end


@implementation NGNinjaTableViewDelegateAndDataSourceSurrogate

#pragma mark - Overriden

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
    id target = nil;
    if ([self.tableViewDelegate respondsToSelector:anInvocation.selector]) {
        target = self.tableViewDelegate;
    }
    else if ([self.tableViewDataSource respondsToSelector:anInvocation.selector]) {
        target = self.tableViewDataSource;
    }
    
    if (target != nil) {
        [anInvocation invokeWithTarget:target];
        return;
    }
    
    [super forwardInvocation:anInvocation];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector] == YES)
        return YES;
    
    return [self.tableViewDelegate respondsToSelector:aSelector] || [self.tableViewDataSource respondsToSelector:aSelector];
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if ([self.tableViewDelegate respondsToSelector:selector]) {
        signature = [self.tableViewDelegate methodSignatureForSelector:selector];
    }
    else if ([self.tableViewDataSource respondsToSelector:selector]) {
        signature = [self.tableViewDataSource methodSignatureForSelector:selector];
    }
    
    return signature;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)] == YES)
        [self.tableViewDelegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(willAppearInRowAtIndexPath:)])
        [cell performSelector:@selector(willAppearInRowAtIndexPath:) withObject:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([self.tableViewDelegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)] == YES)
        [self.tableViewDelegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    
    if ([cell respondsToSelector:@selector(didDisappearFromRowAtIndexPath:)])
        [cell performSelector:@selector(didDisappearFromRowAtIndexPath:) withObject:indexPath];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([self.tableViewDelegate respondsToSelector:@selector(scrollViewWillBeginDragging:)] == YES)
        [self.tableViewDelegate scrollViewWillBeginDragging:scrollView];
    
    [scrollView endEditing:YES];
}

@end


@interface NGNinjaTableView ()

@property (strong, nonatomic) NSMutableDictionary * cellData;
@property (strong, nonatomic) NGNinjaTableViewDelegateAndDataSourceSurrogate * delegateAndDataSourceSurrogate;

@end


@implementation NGNinjaTableView

#pragma mark - Overriden

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self){
        [self initialize];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)setDelegate:(id<UITableViewDelegate>)delegate
{
    self.delegateAndDataSourceSurrogate.tableViewDelegate = delegate;
    [super setDelegate:self.delegateAndDataSourceSurrogate];
}

- (void)setDataSource:(id<UITableViewDataSource>)dataSource
{
    self.delegateAndDataSourceSurrogate.tableViewDataSource = dataSource;
    [super setDataSource:self.delegateAndDataSourceSurrogate];
}

#pragma mark - Overidden (isResizingWithContent)

- (void)setContentSize:(CGSize)contentSize
{
    if (CGSizeEqualToSize(self.contentSize, contentSize)){
        return;
    }
    
    [super setContentSize:contentSize];
    [self invalidateIntrinsicContentSize];
}

- (CGSize)intrinsicContentSize
{
    if (self.isResizingWithContent) {
        return self.contentSize;
    }
    return [super intrinsicContentSize];
}

#pragma mark - Instance Methods

- (void)setData:(id)data forIndexPath:(NSIndexPath *)indexPath
{
    if (data == nil)
        [self.cellData removeObjectForKey:indexPath];
    else
        [self.cellData setObject:data forKey:indexPath];
}

- (id)dataForIndexPath:(NSIndexPath *)indexPath
{
    return [self.cellData objectForKey:indexPath];
}

#pragma mark - Private Methods

- (void)initialize
{
    _delegateAndDataSourceSurrogate = [[NGNinjaTableViewDelegateAndDataSourceSurrogate alloc] init];
    _delegateAndDataSourceSurrogate.ninjaTableView = self;
}

#pragma mark - Private Properties

- (NSMutableDictionary *)cellData
{
    if (_cellData == nil) {
        _cellData = [NSMutableDictionary dictionary];
    }
    return _cellData;
}

@end
