//
//  BPMarkdownViewController.m
//  BypassSample
//
//  Created by Damian Carrillo on 3/13/13.
//  Copyright (c) 2013 Uncodin. All rights reserved.
//

#import "BPMarkdownViewController.h"

const CGFloat kUIStandardMargin = 8.f; // UI* widgets seem to use 8 pts of margin in general

@interface BPMarkdownViewController ()
@property (strong, nonatomic) IBOutlet                           UIScrollView *scrollView;
@property (strong, nonatomic) IBOutletCollection(BPMarkdownView) NSArray      *pageViews;
@end

@implementation BPMarkdownViewController

- (void)viewWillAppear:(BOOL)animated
{
    if ([self pageViews] == nil) {
        NSString *sample = [self sampleMarkdown];
        BPParser *parser = [[BPParser alloc] init];
        BPDocument *document = [parser parse:sample];

        CGSize pageSize = CGSizeMake(CGRectGetWidth([[self view] bounds]) - 2 * kUIStandardMargin,
                                     CGRectGetHeight([[self view] bounds]));
        
        BPDocumentRenderer *renderer = [[BPDocumentRenderer alloc] initWithPageSize:pageSize];
        CGSize suggestedContainerSize;
        NSArray *pageViews = [renderer renderDocument:document suggestedContainerSize:&suggestedContainerSize];
        
        
        [[self scrollView] setContentInset:UIEdgeInsetsMake(1.5 * kUIStandardMargin,
                                                            kUIStandardMargin,
                                                            4 * kUIStandardMargin,
                                                            0)];
        [[self scrollView] setContentSize:suggestedContainerSize]; // note: this will typically truncate the last page
        
        for (BPMarkdownView *pageView in pageViews) {
            [pageView setLinkDelegate:self];
            [[self scrollView] addSubview:pageView];
        }
        
        [self setPageViews:pageViews];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [[self scrollView] flashScrollIndicators];
}

#pragma mark BPMarkdownViewLinkHandler

- (void)markdownView:(BPMarkdownView *)markdownView didHaveLinkClicked:(NSString *)link
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:link]];
}

@end
