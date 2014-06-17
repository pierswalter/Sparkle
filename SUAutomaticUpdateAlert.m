//
//  SUAutomaticUpdateAlert.m
//  Sparkle
//
//  Created by Andy Matuschak on 3/18/06.
//  Copyright 2006 Andy Matuschak. All rights reserved.
//

#import "SUAutomaticUpdateAlert.h"

#import "SUHost.h"

@implementation SUAutomaticUpdateAlert

- (instancetype)initWithAppcastItem:(SUAppcastItem *)item host:(SUHost *)aHost delegate:(id<SUAutomaticUpdateAlertDelegateProtocol>)del
{
	self = [super initWithHost:aHost windowNibName:@"SUAutomaticUpdateAlert"];
	if (self)
	{
		updateItem = [item retain];
		delegate = del;
		host = [aHost retain];
		[self setShouldCascadeWindows:NO];	
		[[self window] center];
	}
	return self;
}

- (void)dealloc
{
	[host release];
	[updateItem release];
	[super dealloc];
}

- (NSString *)description { return [NSString stringWithFormat:@"%@ <%@, %@>", [self class], [host bundlePath], [host installationPath]]; }

- (IBAction)installNow:sender
{
	[self close];
	[delegate automaticUpdateAlert:self finishedWithChoice:SUInstallNowChoice];
}

- (IBAction)installLater:sender
{
	[self close];
	[delegate automaticUpdateAlert:self finishedWithChoice:SUInstallLaterChoice];
}

- (IBAction)doNotInstall:sender
{
	[self close];
	[delegate automaticUpdateAlert:self finishedWithChoice:SUDoNotInstallChoice];
}

- (NSImage *)applicationIcon
{
	return [host icon];
}

- (NSString *)titleText
{
    if ([updateItem isCriticalUpdate])
    {
        return [NSString stringWithFormat:SULocalizedString(@"An important update to %@ is ready to install", nil), [host name]];
    }
    else
    {
        return [NSString stringWithFormat:SULocalizedString(@"A new version of %@ is ready to install!", nil), [host name]];
    }
}

- (NSString *)descriptionText
{
    if ([updateItem isCriticalUpdate])
    {
        return [NSString stringWithFormat:SULocalizedString(@"%1$@ %2$@ has been downloaded and is ready to use! This is an important update; would you like to install it and relaunch %1$@ now?", nil), [host name], [updateItem displayVersionString]];
    }
    else
    {
        return [NSString stringWithFormat:SULocalizedString(@"%1$@ %2$@ has been downloaded and is ready to use! Would you like to install it and relaunch %1$@ now?", nil), [host name], [updateItem displayVersionString]];
    }
}

@end
