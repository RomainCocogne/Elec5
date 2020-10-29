#include <stdio.h>
#include <sys/mman.h>
#include <fcntl.h>	    /* mmap */
#include <linux/fb.h>	/* framebuffer */
#include <sys/stat.h>	/* stat	*/
#include <sys/time.h>	/* time*/
#include <unistd.h>
#include <sys/ioctl.h>	/* ioctl */

#define FRAME_BUFFER "/dev/fb0"
//#define VIDEO_WIDTH 352
//#define VIDEO_HEIGHT 288
#define VIDEO_WIDTH 1280
#define VIDEO_HEIGHT 720
//#define VIDEO_PATH "bus_352x288_150f.yuv"
#define VIDEO_PATH "GTAV_1280x720_482f.yuv"
//#define FRAME_NUMBER 150
#define FRAME_NUMBER 482

//#define FIXED_POINT
// Pointeur sur unsigned int pour une profondeur du framebuffer de 32-bit par pixel
unsigned int *fb_ptr;
unsigned int frame_buffer_line; 
int video_dev;

/*void blueRectangle() {
	int inc_Y=0, inc_UV=0, pos_fb=0, size = VIDEO_WIDTH *VIDEO_HEIGHT;
    float R, G, B, Transp; 

	for (inc_Y=0; inc_Y<VIDEO_WIDTH*VIDEO_HEIGHT; inc_Y++) {
		// Pour une profondeur du framebuffer de 32-bit par pixel
		R=0;            // Red
		G=0;            // Green
		B=255;          // Blue
		Transp = 255;   // Transparency 
		fb_ptr[pos_fb] = 
            (((unsigned int)(B)<<0)         &   0x000000FF | 
            ((unsigned int)(G)<<8)          &   0x0000FF00 | 
            ((unsigned int)(R)<<16)         &   0x00FF0000 | 
            ((unsigned int)(Transp)<<24)    &   0xFF000000);
		// Gestion nouvelle ligne
		if (inc_Y % VIDEO_WIDTH == VIDEO_WIDTH - 1) pos_fb += (frame_buffer_line - VIDEO_WIDTH + 1); 
		else pos_fb++;
	}
}*/


void YUVtoRGB(unsigned char *Y, unsigned char *U, unsigned char *V) {
    int inc_Y=0, inc_UV=0, pos_fb=0;
#ifndef FIXED_POINT        
    float Yval, Uval, Vval;
    float R,G,B, Transp;
#else
    int Yval, Uval, Vval;
    int R,G,B, Transp;
#endif
    unsigned int line_number = 0;
    Transp = 255;
    for (inc_Y=0; inc_Y<VIDEO_WIDTH*VIDEO_HEIGHT; ++inc_Y) {
#ifndef FIXED_POINT        
        Yval = (float)(*(Y+inc_Y));
        Uval = (float)(*(U+inc_UV));
        Vval = (float)(*(V+inc_UV));
        R = ((Yval - 16) + 1.13983 * (Vval - 128));
        G = ((Yval - 16) - 0.39465  * (Uval - 128) - 0.58060*(Vval - 128));
        B = ((Yval - 16) + 2.03211 * (Uval - 128));
#else
        Yval = (int)(*(Y+inc_Y));
        Uval = (int)(*(U+inc_UV));
        Vval = (int)(*(V+inc_UV));
        R = (((Yval - 16)<<14) + 18675 *(Vval - 128))>>14;
        G = (((Yval - 16)<<14) - 6466  *(Uval - 128) - 9513*(Vval - 128) )>>14;
        B = (((Yval - 16)<<14) + 33294 *(Uval - 128))>>14;
#endif
        R = ( (R>255)? 255: ((R<0)? 0: R));
        G = ( (G>255)? 255: ((G<0)? 0: G));
        B = ( (B>255)? 255: ((B<0)? 0: B));

        fb_ptr[pos_fb] = 
            ((((unsigned int)(B)<<0)         &   0x000000FF) | 
            (((unsigned int)(G)<<8)          &   0x0000FF00) | 
            (((unsigned int)(R)<<16)         &   0x00FF0000) | 
            (((unsigned int)(Transp)<<24)    &   0xFF000000));
        
		// Gestion nouvelle ligne
        if (inc_Y % VIDEO_WIDTH == VIDEO_WIDTH - 1) {
            if ((line_number & 1) == 0) {
                // Une ligne sur deux, on reset inc_UV au debut de la ligne
                inc_UV -= VIDEO_WIDTH/2;
            }
                // Toutes les deux lignes, on continue d'incrementer inc_uv
            ++inc_UV;
            pos_fb += (frame_buffer_line - VIDEO_WIDTH + 1); 
            ++line_number;
        }
		else {
            ++pos_fb;
            if ((inc_Y & 1) == 1) ++inc_UV; // Incrementer inc_UV une fois sur deux 
        }   
    }
}

unsigned char * openVideoFile(char * videoPath) 
{
  video_dev = open(videoPath,O_RDWR); // Ouverture du fichier video

  struct stat infoVideoFile; // infos sur le fichier video (on veut y recuperer la taille en octet pour mmap)
  
  stat(videoPath,&infoVideoFile);
  printf("Size of YUV File : %d\n", (int)infoVideoFile.st_size);
  return (unsigned char *)mmap(NULL, infoVideoFile.st_size,PROT_READ, MAP_SHARED, video_dev, 0);

}

void readVideo(char * videoPath, int videoWidth, int videoHeight, int frameNumber) {

  // Ouverture du frame buffer
  int fb_dev;
  fb_dev = open (FRAME_BUFFER, O_RDWR);

  int frame_num; 
  //unsigned char colorDepth;
  unsigned char *videoPtr; 
  unsigned char *current_frame; 
  unsigned char *Y; 
  unsigned char *U; 
  unsigned char *V; 

  struct timeval start, end; 
  double tdiff; 
  
  struct fb_fix_screeninfo fb_fix_infos; // infos sur le frame buffer (fixe pour une resolution donnee)
  struct fb_var_screeninfo fb_var_infos; // autres infos sur le frame buffer
  
  ioctl (fb_dev, FBIOGET_FSCREENINFO, &fb_fix_infos);
  ioctl (fb_dev, FBIOGET_VSCREENINFO, &fb_var_infos);
  
  
  // Projection sur la memoire du fichier representant le frame buffer
  fb_ptr = (unsigned int *)mmap(NULL, fb_fix_infos.smem_len , PROT_READ |PROT_WRITE, MAP_SHARED, fb_dev, 0); 
  printf("pointer frame buffer cast mmap %p\n", fb_ptr);
  printf("Frame buffer total length: %d\n", fb_fix_infos.smem_len);
  printf("Frame buffer line length: %d\n", fb_fix_infos.line_length);

  // Definition de la profondeur des couleurs du fb en octet
  //colorDepth = fb_var_infos.bits_per_pixel / 8 ;
  printf("Frame buffer XRES: %d\n", fb_var_infos.xres);
  printf("Frame buffer YRES: %d\n", fb_var_infos.yres);
  printf("Bits per pixel: %d\n", fb_var_infos.bits_per_pixel);
  printf("Bits per pixel (red): %d\n", (unsigned int)fb_var_infos.red.length);
  printf("Bits per pixel (green): %d\n", (unsigned int)fb_var_infos.green.length);
  printf("Bits per pixel (blue): %d\n", (unsigned int)fb_var_infos.blue.length);
  printf("Bits per pixel (transp): %d\n", (unsigned int)fb_var_infos.transp.length);
  frame_buffer_line = fb_var_infos.xres; 
    
  // Ouverture et projection sur la memoire du fichier yuv contenant la video
  videoPtr = openVideoFile(videoPath); 

  // Ecriture sur le framebuffer, image par image
  // et mesure du temps d'execution
  gettimeofday(&start, NULL); 

  for (frame_num = 0; frame_num < frameNumber; frame_num++) {
    current_frame = videoPtr + frame_num*(VIDEO_HEIGHT*VIDEO_WIDTH*6/4); 
    Y = current_frame + 0; 				
    U = current_frame + VIDEO_HEIGHT*VIDEO_WIDTH; 	// 4:2:0
    V = current_frame + (VIDEO_HEIGHT*VIDEO_WIDTH*5/4); // 4:2:0
    YUVtoRGB(Y, U, V); 
 
    // Pour debug
    //blueRectangle(); 
    //usleep(10000);
  }

  gettimeofday(&end, NULL); 
  tdiff = (double)(1000*(end.tv_sec-start.tv_sec))+((end.tv_usec-start.tv_usec)/1000); 
  printf("YUV_TO_RGB PROCESSING TIME: %f ms\n", tdiff); 

  munmap(fb_ptr, fb_fix_infos.smem_len); 
  close(video_dev); 
}

int main() {
 
  readVideo (VIDEO_PATH,VIDEO_WIDTH, VIDEO_HEIGHT, FRAME_NUMBER);
  
}