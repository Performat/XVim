//  XVim
//
//  Created by Tomas Lundell on 8/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XVimTextObjectEvaluator.h"
#import "XVimSourceView.h"
#import "XVimSourceView+Vim.h"
#import "XVimWindow.h"
#import "XVimKeyStroke.h"
#import "XVimKeymapProvider.h"
#import "XVimMotionOption.h"

@interface XVimTextObjectEvaluator() {
}
@end

@implementation XVimTextObjectEvaluator
@synthesize inner = _inner;
@synthesize textobject = _textobject;
@synthesize bigword = _bigword;

- (id)initWithWindow:window inner:(BOOL)inner{
	if (self = [super initWithWindow:window]) {
        _inner = inner;
        _bigword = NO;
	}
	return self;
}

- (void)dealloc{
    [super dealloc];
}

- (float)insertionPointHeightRatio{
    return 0.5;
}

- (BOOL)isRelatedTo:(XVimEvaluator*)other {
	return [super isRelatedTo:other] || other == self.parent;
}

- (XVimKeymap*)selectKeymapWithProvider:(id<XVimKeymapProvider>)keymapProvider {
	return [keymapProvider keymapForMode:MODE_OPERATOR_PENDING];
}

- (XVimEvaluator*)executeActionForRange:(NSRange)r{
	if (r.location != NSNotFound) {
		[[self sourceView] clampRangeToBuffer:&r];
        return nil;
        // TODO FIXME
		//return [_operatorAction motionFixedFrom:r.location To:r.location+r.length Type:CHARACTERWISE_EXCLUSIVE inWindow:window];
	}
    return nil;
}

- (XVimEvaluator*)b{
    self.textobject = TEXTOBJECT_PARENTHESES;
    return nil;
}

- (XVimEvaluator*)B{
    self.textobject = TEXTOBJECT_BRACES;
    return nil;
}

-(XVimEvaluator*)p{
    self.textobject = TEXTOBJECT_PARAGRAPH;
    return nil;
}

- (XVimEvaluator*)w{
    self.textobject = TEXTOBJECT_WORD;
    return nil;
}

- (XVimEvaluator*)W{
    self.textobject = TEXTOBJECT_WORD;
    self.bigword = YES;
    return nil;
}

- (XVimEvaluator*)LSQUAREBRACKET{
    self.textobject = TEXTOBJECT_SQUAREBRACKETS;
    return nil;
}

- (XVimEvaluator*)RSQUAREBRACKET{
	return [self LSQUAREBRACKET];
}

- (XVimEvaluator*)LBRACE{
	return [self B];
}

- (XVimEvaluator*)RBRACE{
	return [self B];
}

- (XVimEvaluator*)LESSTHAN{
    self.textobject = TEXTOBJECT_ANGLEBRACKETS;
    return nil;
}

- (XVimEvaluator*)GREATERTHAN{
	return [self LESSTHAN];
}

- (XVimEvaluator*)LPARENTHESIS{
	return [self b];
}

- (XVimEvaluator*)RPARENTHESIS{
	return [self b];
}

- (XVimEvaluator*)SQUOTE{
    self.textobject = TEXTOBJECT_SQUOTE;
    return nil;
}

- (XVimEvaluator*)DQUOTE{
    self.textobject = TEXTOBJECT_DQUOTE;
    return nil;
}

- (XVimRegisterOperation)shouldRecordEvent:(XVimKeyStroke*) keyStroke inRegister:(XVimRegister*)xregister {
    if (xregister.isRepeat && [keyStroke instanceResponds:self] ) {
		return REGISTER_APPEND;
	}
    
    return [super shouldRecordEvent:keyStroke inRegister:xregister];
}

@end
