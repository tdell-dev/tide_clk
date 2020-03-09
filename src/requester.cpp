#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <linux/fb.h>
#include <sys/mman.h>
#include <sys/ioctl.h>

char *frame_buf_ptr = 0;
struct fb_var_screeninfo orig_vinfo;
struct fb_var_screeninfo var_info;
struct fb_fix_screeninfo finfo;

void put_pixel( int x, int y, char c ) {
  unsigned int offset = y + x*finfo.line_length;
    *( (char*) frame_buf_ptr + offset ) =c;
  
};

void draw_bounding_regions(int x_resolution, int y_resolution, char color, int pixel_width) {
  //draw a horizontal line down the middle to separate the graph region
  for ( int x=0; x<x_resolution; x++ ) {
    for ( int depth=0; depth<pixel_width; depth++) {
      put_pixel( x, depth+y_resolution/2, color);
    }
  }

  //draw a vertical line halfway down to separate weather from stats
  for ( int y=y_resolution/2; y< y_resolution; y++ ) {
    put_pixel( x_resolution/2, y, color);
  }
  
};

// application entry point
int main(int argc, char* argv[])
{
  int fbfd = 0;
  long int screensize = 0;

  fbfd = open("/dev/fb1", O_RDWR);
  if (fbfd == -1) {
    printf("Error: cannot open framebuffer device.\n");
    return(1);
  }
  printf("The framebuffer device opened.\n");

  // Get fixed screen information
  if (ioctl(fbfd, FBIOGET_FSCREENINFO, &finfo)) {
    printf("Error reading fixed information.\n");
  }

  // Get variable screen information
  if (ioctl(fbfd, FBIOGET_VSCREENINFO, &var_info)) {
    printf("Error reading variable screen info.\n");
  }

  printf("Variable Display info:\nXResolution: %d,\nYResolution: %d,\nBits per Pixel: %d,\nPixel Clock: %d(ps)\n", 
         var_info.xres,
         var_info.yres, 
         var_info.bits_per_pixel,
         var_info.pixclock );

  printf("Fixed Display info:\nFrame Buffer Mem Len: %d,\nLine Length: %d\n", 
         finfo.smem_len,
         finfo.line_length);

  memcpy( &orig_vinfo, &var_info, sizeof(struct fb_var_screeninfo));

  //map framebuffer to user memory
  screensize = finfo.smem_len;

  frame_buf_ptr = (char*) mmap(0, screensize, PROT_READ | PROT_WRITE, MAP_SHARED, fbfd, 0);

  if ((int) frame_buf_ptr == -1 ) {
    printf("Failed to mmap.\n");
    return(1);
  }
 
  draw_bounding_regions( 480, 640, (char) 255, 1 );

  munmap(frame_buf_ptr, screensize);

//if (ioctl(fbfd, FBIOPUT_VSCREENINFO, &orig_vinfo)) {
//  printf("Error resetting variable information.\n");
//}

  // close file  
  close(fbfd);
  
  return 0;

}
