# UIImageDetectColorSystem  
Detect an input image is B/W or Grayscale, or color image  

### Basic concept (color space rgb only)  
**B/W image** is an image contain all pixel black or white.  
**Grayscale image** is an image contain all pixel has r==g==b (so that B/W actualy is a grayscale image).  
**Color image** is an image is not a grayscale image.  

### Calculate grayscale average
in one pixel r = g = b  
float average = (total r value) / totalpixels