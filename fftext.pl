#!/usr/bin/perl
# korolev-ia [at] yandex.ru
# version 2.0 2017.02.17
##############################
# require ffmpeg and imagemagick
# list of ImageMagick fonts : convert -list font |grep ttf

#use Data::Dumper;
use Getopt::Long;

# --text "Hello World!" 
# --output title.mp4 
# --resolution 426x240 
# --framerate 25
# --durationinsecs 8 
# --fontpath /home/alberto/font.ttf 
# --fontsize 48


my $CONVERT='/usr/bin/convert';
my $FFPROBE='/usr/bin/ffprobe';
my $FFMPEG='/usr/bin/ffmpeg';

my $DEBUG=0; # set in 1 for debug
my $inc=3; # set this value in 4 for more smooth video, Set in 2 for rendering speed
my $fade_in_time=0.3 ; # how many time of durationinsecs fade_in continue ( eg if $durationinsecs=8 , then fade_in continue 4 sec )
my $fade_out_time=0.7 ; # how many time of durationinsecs fade_out continue ( eg if $durationinsecs=8 , then fade_out continue 4 sec )
my $zooms=0.0015; # zooming for every next frame


# defaults :
my $framerate=25 unless( $framerate );
my $resolution='426x240' unless( $resolution );
my $durationinsecs=8 unless( $durationinsecs );
my $fontsize=48 unless( $fontsize );

GetOptions (
        'text=s' => \$text,
        'output=s' => \$output,
        'resolution=s' => \$resolution,
        'framerate=i' => \$framerate,
        'durationinsecs=i' => \$durationinsecs,
        'fontpath=s' => \$fontpath,
        'fontsize=i' => \$fontsize,
        'show|s' => \$show,
        "help|h|?"  => \$help ) or show_help();


		
show_help() if($help);
show_help( "Please check 'text' option" ) unless( $text  );
show_help( "Please check 'output' option") unless( $output );
show_help( "Please check the 'resolution'" ) unless( $resolution=~/^\d+x\d+$/ );



my $dt=time;
my $tmp_dir="/tmp/im$dt";

$cmd="mkdir $tmp_dir";	
if( $DEBUG ) {
	print $cmd;
} else {
	system( $cmd );
}

my $count=$durationinsecs*$framerate;
my ( $width, $hight )=split ( /x/i, $resolution );

# temporary increase the all sizes
$fontsize*=$inc;
$width*=$inc;
$hight*=$inc;
$blur=$inc*2;

$text=~s/'/"/g;
$font=" -font $fontpath " if($fontpath) ; 

my $cmd="$CONVERT -background black -size ${width}x${hight} -fill white -pointsize $fontsize  $font -gravity center label:'$text' +channel -blur 3x$blur +repage $tmp_dir/out.jpg\n";
if( $DEBUG ) {
	print $cmd;
} else {
	system( $cmd );
}


	
foreach ( 0..$count ) {
	my $z=sprintf ( "%.4d", $_ );
	my $w=my_round( $width*( $zooms*$_ +1 ) ) ;
	my $h=my_round(($hight/$width)*$w);
	my $delta_x=0;
	my $delta_y=my_round(( $h-$hight )/2);
	my $cmd="$CONVERT $tmp_dir/out.jpg -resize ${w}x${h} +repage -gravity north -crop ${width}x${hight}+$delta_x+$delta_y +repage  $tmp_dir/out${z}.jpg\n";
	if( $DEBUG ) {
		print $cmd;
	} else {
		system( $cmd );
	}
}

my $d_in=$fade_in_time*$durationinsecs;
my $d_out=$fade_out_time*$durationinsecs;
my $start_fade_out=$durationinsecs-$d_out;
$cmd="$FFMPEG -loglevel warning  -y  -framerate $framerate -i $tmp_dir/out%04d.jpg -vf \"fade=t=in:st=0:d=$d_in,fade=t=out:st=$start_fade_out:d=$d_out, scale=$resolution\" -c:v libx264 -pix_fmt yuv420p -strict -2 $output\n";
if( $DEBUG ) {
	print $cmd;
} else {
	system( $cmd );
}

$cmd="rm -rf $tmp_dir";	
if( $DEBUG ) {
	print $cmd;
} else {
	system( $cmd );
}

exit(0);


sub my_round{
	my $i=shift;
	return int($i + 0.5);
}

					
sub show_help {
my $msg=shift;
print STDERR "
$msg

This script make the effect: fade_in - zooming - fade_out
Sample: $0 \\
 --text 'Hello World!' \\
 --output title.mp4 \\
 --resolution 426x240 \\
 --framerate 25 \\
 --durationinsecs 8 \\
 --fontpath /home/alberto/font.ttf \\
 --fontsize 48 

";
	exit (1);
}					