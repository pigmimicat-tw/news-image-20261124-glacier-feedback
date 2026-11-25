// Original editorial artwork. Rebuild with macOS clang and AppKit, no packages.
#import <AppKit/AppKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <math.h>
static CGContextRef cg;
static NSColor *color(NSString *hex) {
 unsigned n=0; [[NSScanner scannerWithString:hex] scanHexInt:&n];
 return [NSColor colorWithCalibratedRed:((n>>16)&255)/255.0 green:((n>>8)&255)/255.0 blue:(n&255)/255.0 alpha:1];
}
static void rect(double x,double y,double w,double h,NSString*c){CGContextSetFillColorWithColor(cg,color(c).CGColor); CGContextFillRect(cg,CGRectMake(x,y,w,h));}
static CGPoint point(NSArray*p){return CGPointMake([p[0] doubleValue],[p[1] doubleValue]);}
static void poly(NSArray *p,NSString*c){CGContextBeginPath(cg);CGPoint a=point(p[0]);CGContextMoveToPoint(cg,a.x,a.y);for(NSArray*v in [p subarrayWithRange:NSMakeRange(1,p.count-1)]){a=point(v);CGContextAddLineToPoint(cg,a.x,a.y);}CGContextClosePath(cg);CGContextSetFillColorWithColor(cg,color(c).CGColor);CGContextFillPath(cg);}
static void line(NSArray *p,NSString*c,double w){CGContextBeginPath(cg);CGPoint a=point(p[0]);CGContextMoveToPoint(cg,a.x,a.y);for(NSArray*v in [p subarrayWithRange:NSMakeRange(1,p.count-1)]){a=point(v);CGContextAddLineToPoint(cg,a.x,a.y);}CGContextSetStrokeColorWithColor(cg,color(c).CGColor);CGContextSetLineWidth(cg,w);CGContextSetLineJoin(cg,kCGLineJoinRound);CGContextSetLineCap(cg,kCGLineCapRound);CGContextStrokePath(cg);}
static void arrow(NSArray*p,NSString*c,double w,double head){line(p,c,w);CGPoint a=point(p[p.count-2]),b=point(p.lastObject);double t=atan2(b.y-a.y,b.x-a.x);poly(@[@[@(b.x),@(b.y)],@[@(b.x-head*cos(t-0.48)),@(b.y-head*sin(t-0.48))],@[@(b.x-head*cos(t+0.48)),@(b.y-head*sin(t+0.48))]],c);}
static void circle(double x,double y,double r,NSString*c){CGContextSetFillColorWithColor(cg,color(c).CGColor);CGContextFillEllipseInRect(cg,CGRectMake(x-r,y-r,2*r,2*r));}
static void text(NSString*s,double x,double y,double pt,NSString*c,BOOL bold){
 CGContextSaveGState(cg);CGContextTranslateCTM(cg,0,1024);CGContextScaleCTM(cg,1,-1);
 NSFont*f=[NSFont fontWithName:bold?@"Arial-BoldMT":@"ArialMT" size:pt];
 NSDictionary*a=@{NSFontAttributeName:f,NSForegroundColorAttributeName:color(c)};
 NSSize z=[s sizeWithAttributes:a];[s drawAtPoint:NSMakePoint(x,1024-y-z.height) withAttributes:a];CGContextRestoreGState(cg);
}
int main(int argc,const char **argv){@autoreleasepool{
 NSBitmapImageRep*b=[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL pixelsWide:1024 pixelsHigh:1024 bitsPerSample:8 samplesPerPixel:4 hasAlpha:YES isPlanar:NO colorSpaceName:NSDeviceRGBColorSpace bytesPerRow:0 bitsPerPixel:0];
 [NSGraphicsContext saveGraphicsState];[NSGraphicsContext setCurrentContext:[NSGraphicsContext graphicsContextWithBitmapImageRep:b]];cg=NSGraphicsContext.currentContext.CGContext;CGContextTranslateCTM(cg,0,1024);CGContextScaleCTM(cg,1,-1);CGContextSetAllowsAntialiasing(cg,true);
 NSString *navy=@"101F30",*cream=@"F5F2E8",*muted=@"A9BBC8",*ice=@"BFEAF0",*orange=@"FFB85D";
rect(0,0,1024,1024,navy);
// A quiet editorial grid, one orange accent, and an explicit edition label.
rect(48,43,8,18,orange);
text(@"CLIMATE / SCIENCE EXPLAINER",68,42,18,cream,YES);
text(@"24 NOV 2026",805,35,21,cream,YES);
text(@"EDITION DATE",805,62,13,muted,YES);
line(@[@[@(48),@(88)],@[@(976),@(88)]],@"405263",1);
text(@"LESS ICE.",44,99,78,cream,YES);
text(@"MORE HEAT.",44,177,78,orange,YES);
text(@"How glacier retreat can reinforce warming",48,272,26,cream,NO);
text(@"CONCEPTUAL ILLUSTRATION",49,316,12,muted,YES);

// Mountain valley: original geometric facets, land ice, and exposed rock.
poly(@[@[@(48),@(671)],@[@(48),@(601)],@[@(197),@(421)],@[@(284),@(473)],@[@(382),@(351)],@[@(496),@(463)],@[@(622),@(385)],@[@(744),@(502)],@[@(832),@(438)],@[@(976),@(594)],@[@(976),@(701)]],@"243A4B");
poly(@[@[@(48),@(671)],@[@(197),@(421)],@[@(302),@(554)],@[@(382),@(351)],@[@(481),@(505)],@[@(622),@(385)],@[@(704),@(562)],@[@(832),@(438)],@[@(976),@(635)],@[@(976),@(702)]],@"3C515D");
poly(@[@[@(197),@(421)],@[@(176),@(497)],@[@(215),@(482)],@[@(243),@(501)]],@"D5E6E5");
poly(@[@[@(382),@(351)],@[@(328),@(451)],@[@(370),@(427)],@[@(390),@(443)],@[@(421),@(417)]],@"F3F4E9");
poly(@[@[@(622),@(385)],@[@(570),@(455)],@[@(612),@(439)],@[@(640),@(466)],@[@(659),@(451)]],@"D5E6E5");
poly(@[@[@(832),@(438)],@[@(792),@(495)],@[@(828),@(481)],@[@(852),@(504)],@[@(870),@(488)]],@"BDCBCD");
// Glacier surface from the upper catchment, spreading through the valley.
poly(@[@[@(390),@(429)],@[@(435),@(447)],@[@(478),@(475)],@[@(518),@(496)],@[@(546),@(542)],@[@(566),@(590)],@[@(616),@(638)],@[@(594),@(678)],@[@(509),@(697)],@[@(403),@(686)],@[@(344),@(661)],@[@(381),@(615)],@[@(415),@(574)],@[@(434),@(533)],@[@(407),@(494)]],@"86C5D4");
poly(@[@[@(390),@(429)],@[@(435),@(447)],@[@(461),@(482)],@[@(490),@(513)],@[@(501),@(552)],@[@(513),@(590)],@[@(540),@(628)],@[@(516),@(657)],@[@(444),@(665)],@[@(389),@(654)],@[@(415),@(617)],@[@(448),@(574)],@[@(456),@(532)],@[@(431),@(486)]],@"E5F6F2");
poly(@[@[@(490),@(513)],@[@(518),@(496)],@[@(546),@(542)],@[@(566),@(590)],@[@(616),@(638)],@[@(594),@(678)],@[@(545),@(669)],@[@(540),@(628)],@[@(513),@(590)],@[@(501),@(552)]],@"AADFE6");
poly(@[@[@(389),@(654)],@[@(444),@(665)],@[@(516),@(657)],@[@(545),@(669)],@[@(594),@(678)],@[@(509),@(697)],@[@(403),@(686)],@[@(344),@(661)]],@"5995AD");
poly(@[@[@(344),@(661)],@[@(403),@(686)],@[@(509),@(697)],@[@(594),@(678)],@[@(584),@(694)],@[@(500),@(713)],@[@(397),@(701)],@[@(330),@(675)]],@"376D86");
// Exposed terrestrial bedrock on the glacier's right flank, never an ocean.
poly(@[@[@(532),@(521)],@[@(622),@(470)],@[@(697),@(530)],@[@(771),@(522)],@[@(861),@(575)],@[@(976),@(643)],@[@(976),@(718)],@[@(724),@(718)],@[@(614),@(676)],@[@(566),@(590)]],@"4D4D49");
poly(@[@[@(622),@(470)],@[@(644),@(545)],@[@(697),@(530)]],@"767367");
poly(@[@[@(644),@(545)],@[@(703),@(603)],@[@(771),@(522)],@[@(697),@(530)]],@"625F54");
poly(@[@[@(703),@(603)],@[@(810),@(641)],@[@(861),@(575)],@[@(771),@(522)]],@"777166");
poly(@[@[@(614),@(676)],@[@(703),@(603)],@[@(810),@(641)],@[@(724),@(718)]],@"5B5B52");
poly(@[@[@(810),@(641)],@[@(899),@(677)],@[@(976),@(643)],@[@(861),@(575)]],@"55554D");
poly(@[@[@(48),@(671)],@[@(182),@(620)],@[@(283),@(673)],@[@(330),@(675)],@[@(397),@(701)],@[@(500),@(713)],@[@(48),@(718)]],@"34483E");
line(@[@[@(432),@(508)],@[@(462),@(517)],@[@(484),@(515)]],@"8BC5D3",2);
line(@[@[@(438),@(545)],@[@(472),@(552)],@[@(498),@(548)]],@"8BC5D3",2);
line(@[@[@(421),@(585)],@[@(460),@(593)],@[@(500),@(583)]],@"8BC5D3",2);
line(@[@[@(393),@(627)],@[@(436),@(635)],@[@(478),@(629)],@[@(514),@(621)]],@"8BC5D3",2);
line(@[@[@(573),@(563)],@[@(620),@(586)],@[@(644),@(612)]],@"878375",2);
line(@[@[@(768),@(648)],@[@(811),@(671)],@[@(849),@(679)]],@"878375",2);
// Small meltwater ribbon stays in a land valley.
poly(@[@[@(500),@(710)],@[@(523),@(707)],@[@(566),@(718)],@[@(620),@(726)],@[@(688),@(732)],@[@(686),@(739)],@[@(615),@(735)],@[@(561),@(726)],@[@(516),@(718)]],@"65BDD1");

// Sunlight: solid incoming rays; cool ray leaves bright ice; dark ground absorbs.
circle(885,361,24,orange);
for (int i=0; i<8; i++) {
    double t=i*M_PI/4;
    line(@[@[@(885+34*cos(t)),@(361+34*sin(t))],@[@(885+43*cos(t)),@(361+43*sin(t))]],orange,2);
}
arrow(@[@[@(837),@(376)],@[@(498),@(504)]],orange,3,11);
arrow(@[@[@(498),@(504)],@[@(594),@(366)]],ice,4,11);
arrow(@[@[@(872),@(411)],@[@(803),@(592)]],orange,4,11);
// Short heat ripples indicate absorbed surface energy, not smoke or greenhouse gas.
line(@[@[@(798),@(605)],@[@(789),@(612)],@[@(797),@(620)],@[@(788),@(628)]],orange,3);
line(@[@[@(817),@(609)],@[@(808),@(616)],@[@(816),@(624)],@[@(807),@(632)]],orange,3);
// Label blocks are kept out of both the sun and causal rays.
rect(48,477,222,58,navy);
text(@"BRIGHT SNOW & ICE",53,482,18,cream,YES);
text(@"Reflects more sunlight",53,508,17,ice,NO);
line(@[@[@(267),@(526)],@[@(350),@(552)],@[@(428),@(553)]],ice,1.5);
text(@"Reflected sunlight",589,341,15,ice,NO);
text(@"DARKER ROCK",737,660,18,cream,YES);
text(@"Absorbs more sunlight",737,686,17,orange,NO);

// Causal strip with an unbroken return path: one qualitative feedback pathway.
line(@[@[@(48),@(753)],@[@(976),@(753)]],@"405263",1);
// Three steps and an explicit return arrow.
circle(61,789,13,orange);
text(@"1",56,779,16,navy,YES);
text(@"WARMING",48,818,18,cream,YES);
text(@"More snow and ice melt",48,848,17,muted,NO);
circle(379,789,13,orange);
text(@"2",374,779,16,navy,YES);
text(@"DARKER SURFACES",366,818,18,cream,YES);
text(@"Less sunlight reflected",366,848,17,muted,NO);
circle(697,789,13,orange);
text(@"3",692,779,16,navy,YES);
text(@"MORE HEAT ABSORBED",684,818,18,cream,YES);
text(@"More energy for melting",684,848,17,muted,NO);
arrow(@[@[@(88),@(789)],@[@(336),@(789)]],orange,2.5,10);
arrow(@[@[@(406),@(789)],@[@(654),@(789)]],orange,2.5,10);
// Node 3 loops to node 1 below the strip; arrowhead explicitly points back up.
arrow(@[@[@(697),@(882)],@[@(697),@(916)],@[@(61),@(916)],@[@(61),@(882)]],orange,2.5,10);
rect(296,901,360,30,navy);
text(@"REINFORCING FEEDBACK",312,904,17,orange,YES);
line(@[@[@(48),@(947)],@[@(976),@(947)]],@"405263",1);
text(@"One feedback pathway · Not a same-day research claim",48,960,17,cream,NO);
text(@"Sources: NASA GISS · NASA NTRS 20230017287 · NSIDC",48,987,16,muted,NO);

 [NSGraphicsContext restoreGraphicsState];
 NSString*out=argc>1?[NSString stringWithUTF8String:argv[1]]:@"entry.png";
 NSData*d=[b representationUsingType:NSBitmapImageFileTypePNG properties:@{}];
 if(![d writeToFile:out atomically:YES]) return 1;
 printf("Wrote %s: %lu bytes\n",out.UTF8String,(unsigned long)d.length);
}return 0;}
