#						FFMPEG text zooming with fade_in and fade_out effect


##  What is it?
##  -----------
Script make text zooming with fade_in and fade_out effect.
See for example out.mp4 in this project.

##  The Latest Version

	version 2.0 2017.02.17
	
##  Whats new

	

##  Installation
You need installed ffmpeg ( http://ffmpeg.org/ ) and imagemagick  ( http://www.imagemagick.org/index.php ).

		
##  Running
Start the script:
```
$ ./fftext.pl 
This script make the effect: fade_in - zooming - fade_out
Sample: ./fftext.pl \
 --text 'Hello World!' \
 --output title.mp4 \
 --resolution 426x240 \
 --framerate 25 \
 --durationinsecs 8 \
 --fontpath /home/alberto/font.ttf \
 --fontsize 48

## Notes
 + For new line in text, use '\n'. For example "Hello\nWorld".
 + Several variables in script can help you setup effect:
	++ $inc - balance between quality ( smooth video ) and speed
	++ $DEBUG - set this value to 1 for 'command lines' listing  ( do not execute )
	++ $fade_in_time,$fade_out_time - how many time of durationinsecs fade will continue ( eg if $durationinsecs=8 and $fade_in_time=0.5 , then fade_in continue 4 sec )
	++ $zoons - zooming for every next frame


## Known bugs

 
  Licensing
  ---------
	GNU

  Contacts
  --------

     o korolev-ia [at] yandex.ru
     o http://www.unixpin.com

	 