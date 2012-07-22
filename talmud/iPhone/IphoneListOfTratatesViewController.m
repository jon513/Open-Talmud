//
//  listOfTratatesViewController.m
//  iTalmud
//
//  Created by Jonathan Rose on 2/1/12.
//  Copyright (c) 2012 APPstudio Israel. All rights reserved.
//

#import "IphoneListOfTratatesViewController.h"
#import "TalmudBavli.h"
#import "Mesektah.h"
#import "Daf.h"

@implementation IphoneListOfTratatesViewController
@synthesize dafYomiButton;
@synthesize tableview;

-(int) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[TalmudBavli sharedTalmudBavli] listOfBooks] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"MyCell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] ;
    }

    Mesektah* thisMesektah=[[[TalmudBavli sharedTalmudBavli] listOfBooks] objectAtIndex:indexPath.row];
    cell.textLabel.text=NSLocalizedString( thisMesektah.name,@"");
    cell.detailTextLabel.text=[NSString stringWithFormat:@"%d pages",thisMesektah.rangeOfDafim.length];
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableview deselectRowAtIndexPath:indexPath animated:YES];
}
-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue destinationViewController] respondsToSelector:@selector(setMesektah:)] && [sender isKindOfClass:[UITableViewCell class]]) {
        NSIndexPath *indexPath=[self.tableview indexPathForCell:sender];
        Mesektah* thisMesektah=[[[TalmudBavli sharedTalmudBavli] listOfBooks] objectAtIndex:indexPath.row];

        [segue.destinationViewController performSelector:@selector(setMesektah:) withObject:thisMesektah];
    }
    if ([[segue destinationViewController] respondsToSelector:@selector(setDaf:)] ) {
        Daf* dafyomi=[TalmudBavli dafYomi]; 

        [segue.destinationViewController performSelector:@selector(setDaf:) withObject:dafyomi];
    }
}
-(void) viewDidLoad{
    [super viewDidLoad];
    Daf* dafyomi=[TalmudBavli dafYomi]; 
    self.dafYomiButton.title=dafyomi.displayName;
   
}
-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    Daf* dafyomi=[TalmudBavli dafYomi]; 
    self.dafYomiButton.title=dafyomi.displayName;
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload {
    self.tableview=nil;
    [self setDafYomiButton:nil];
    [super viewDidUnload];
}

- (IBAction)rateApp:(id)sender {

}

- (IBAction)likeOnFacebook:(id)sender {
    NSURL* fackbookLink=[NSURL URLWithString:@"fb://page/168136476631518"];
    if ([[UIApplication sharedApplication] canOpenURL:fackbookLink]) {
        [[UIApplication sharedApplication] openURL:fackbookLink];
    }else{
        NSURL* weblink=[NSURL URLWithString:@"https://www.facebook.com/pages/Open-Talmud/168136476631518"];
        if ([[UIApplication sharedApplication] canOpenURL:weblink]) {
            [[UIApplication sharedApplication] openURL:weblink];
        }
    }
}
-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==0) {
        [self likeOnFacebook:nil];
    }else if(buttonIndex ==1){
        [self performSegueWithIdentifier:@"cache" sender:nil];
    }
}
- (IBAction)more:(id)sender {
   UIActionSheet* actionsheet= [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:NSLocalizedString(@"Cancel", nil) destructiveButtonTitle:nil otherButtonTitles:NSLocalizedString(@"Facebook", nil),  NSLocalizedString(@"Cache", nil), nil];
    
    [actionsheet showFromBarButtonItem:sender animated:YES];
}

- (IBAction)donate:(id)sender {
    NSURL* donatelink=[NSURL URLWithString:@"http://daf-yomi.com/donate.aspx"];
    if( [[UIApplication sharedApplication] canOpenURL:donatelink]){
        [[UIApplication sharedApplication] openURL:donatelink];
    }
}

@end
