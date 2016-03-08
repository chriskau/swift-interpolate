# swift-interpolate

This module provides a variety of interpolation methods for blending between two values, replicating [d3-interpolate](https://github.com/d3/d3-interpolate). It is experimental and not recommended to be used in production environments.

To interpolate between 2 numbers:

```swift
var i = d3.interpolateNumber(10, 20);
i(0.0); // 10
i(0.2); // 12
i(0.5); // 15
i(1.0); // 20
```

The returned function `i` is called an *interpolator*. Given a starting value *a* and an ending value *b*, it takes a parameter *t* in the domain [0, 1] and returns the corresponding interpolated value between *a* and *b*. An interpolator typically returns a value equivalent to *a* at *t* = 0 and a value equivalent to *b* at *t* = 1.

You can also interpolate between 2 colours:

```swift
var c = interpolate(UIColor.whiteColor(), UIColor.orangeColor())
c(0.3) // rgb(1.0, 0.85, 0.7, 1.0)

```


## API Reference

<a name="interpolate" href="#interpolate">#</a> swift.<b>interpolate</b>(<i>a</i>, <i>b</i>)

Returns an interpolator between the two arbitrary values *a* and *b*. The interpolator implementation is based on the type of the end value *b*, using the following algorithm:

1. If *b* is a [UIColor](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UIColor_Class/), [interpolateRGB](#interpolateRGB) is used.
2. If *b* is a string, [interpolateString](#interpolateString) is used.
3. If *b* is an array, [interpolateArray](#interpolateArray) is used.
5. Otherwise, [interpolateNumber](#interpolateNumber) is used.

Based on the chosen interpolator, *a* is coerced to a suitable corresponding type. 

<a name="interpolateNumber" href="#interpolateNumber">#</a> <b>interpolateNumber</b>(<i>a</i>, <i>b</i>)

Returns an interpolator between the two numbers *a* and *b*. The returned interpolator is equivalent to:

```swift
function interpolate(t) {
  return a * (1 - t) + b * t;
}
```


<a name="interpolateArray" href="#interpolateArray">#</a> <b>interpolateArray</b>(<i>a</i>, <i>b</i>)

Returns an interpolator between the two arrays *a* and *b*. Internally, an array template is created that is the same length in *b*. For each element in *b*, if there exists a corresponding element in *a*, a generic interpolator is created for the two elements using [interpolate](#interpolate). If there is no such element, the static value from *b* is used in the template. Then, for the given parameter *t*, the template’s embedded interpolators are evaluated. The updated array template is then returned.

For example, if *a* is the array `[0, 1]` and *b* is the array `[1, 10, 100]`, then the result of the interpolator for *t* = 0.5 is the array `[0.5, 5.5, 100]`.

<a name="interpolateRGB" href="#interpolateRGB">#</a> <b>interpolateRGB</b>(<i>a</i>, <i>b</i>)

<img src="https://raw.githubusercontent.com/d3/d3-interpolate/master/img/rgb.png" width="100%" height="40" alt="rgb">

Returns an RGB color space interpolator between the two colors *a* and *b* . The return value of the interpolator is an UIColor instance.
