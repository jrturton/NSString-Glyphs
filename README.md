NSString-Glyphs
===============

Category on NSString to return a UIBezierPath of the string in a font of your choice, using Core Text. You need to also add the Core Text framework to your project. 

You can then create tasteful effects like this: 

![Lovely example](Glyph.png)

Using the category is very simple:

```objc
// Obtain a string with your desired character in it
NSString *test = @"4";
// Create the font you wish to use
UIFont *font = [UIFont systemFontOfSize:100];
// Get the path
UIBezierPath *glyphPath = [test bezierPathWithFont:font];
```

The path can then be used in any drawing code as you require:

```objc
[[UIColor whiteColor] set];
[glyphPath fill];
```
