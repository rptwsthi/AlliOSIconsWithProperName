//
//  CNAViewController.m
//  AllIconsForiOSApplication
//
//  Created by Alcanzar Soft on 03/10/13.
//  Copyright (c) 2013 Arpit. All rights reserved.
//

#import "CNAViewController.h"

@interface CNAViewController ()
@property (strong, nonatomic) IBOutlet UITextView *instructionTextView;

@end

@implementation CNAViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.

    NSLog(@"path  = %@", [self pathForDocumentDirectory]);
    NSArray *iconDetailsArray = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"IconFilesSpecificationList" ofType:@"plist"]];
    
    //drop your high resolution image in document directory
    UIImage *origionalImage = [UIImage imageWithContentsOfFile:[[self pathForDocumentDirectory] stringByAppendingPathComponent:[[[NSFileManager defaultManager] subpathsAtPath:[self pathForDocumentDirectory]] lastObject]]];
    
    if (origionalImage) {
        [_instructionTextView setText:@"preaparing icons..."];
        [self createIconWithDetails:iconDetailsArray withOrigionalImage:origionalImage];
    }else{
        //SET INSTRUCTIONS
        [_instructionTextView setText:[NSString stringWithContentsOfFile:@"Instructions.rtf" encoding:NSUTF8StringEncoding error:nil]];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *) pathForDocumentDirectory{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void) createIconWithDetails : (NSArray *) iconDetailsArray withOrigionalImage : (UIImage *) origionalImage{
    for (NSDictionary *iconDedtailDict in iconDetailsArray) {
        CGSize newSizeForImage = CGSizeMake([[[iconDedtailDict valueForKey:@"dimensions"] valueForKey:@"width"] floatValue], [[[iconDedtailDict valueForKey:@"dimensions"] valueForKey:@"height"] floatValue]);
        
        //resize image
        UIImage *resizedImage = [self imageWithImage:origionalImage convertToSize:newSizeForImage];
        
        //write icon file to document directory
        [UIImagePNGRepresentation(resizedImage) writeToFile:[[self pathForDocumentDirectory] stringByAppendingPathComponent:[iconDedtailDict valueForKey:@"filename"]] atomically:YES];
    }
}

- (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

@end
