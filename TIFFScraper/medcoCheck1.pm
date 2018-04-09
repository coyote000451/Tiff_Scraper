#! c:\perl\bin
use warnings;
use diagnostics;
use ReadDir;
#use localtime;
use DateTime;
use Tkx;

package medcoCheck1;


sub new 
{

	my $class = shift; # shift @_
	my $getDir = {
		_directory => shift,
	};
	
	bless $getDir, $class;
	return $getDir;
}

sub MedDir
{
	my $self = shift;
	my $MedDir = $self->{_directory};
	
#
# This checks for 2 pages of leaflets
#

#
# Counter setup
#
	$count = 0;
	$test  = 0;
	$LOG   = 0;
	$index = 0;


 $DIR_PATH = $MedDir;
 $TOP_DIR = ReadDir->new($DIR_PATH);
 @DirArray = $TOP_DIR->Directory();

################TEMP##################

for $g (@DirArray)
	{



		if (($g !~ m/Thumbs.db/i) || ($_ !~ /^\s*$/))
		{
		#	print "$g\n";
		#open LEAF, ">>", "leaf.txt" or die $!;
		#print LEAF "$g\n";
		#close (LEAF);
			push (@IndexArray, $g);
		$index = $index + 1;

		}


	}




#print "INDEX:  $index\n";
#exit;

#######################################

@DirArray = @IndexArray;

# Special test, to make sure we have more than 1 element in the array

 $n = @DirArray;

 #$n = $n - 1;

 print "N = $n\n";

	if ($n eq "1")
	{
		print "Only 1 TIFF file, Good Bye! \n";
		exit;
	}

# Special test, to make sure we have even number of elements in the array

	if ($n % 2 == 1)
	{
		print "$n: odd number of Tiff files\n";
		open LOG, ">>", "log.txt" or die $!;
		$dt = DateTime->now;
		print LOG "$dt CHECK:  $n: odd number of Tiff files\n";
		close (LOG);
#exit;
	}


 for $file (@DirArray) 
 {

	$file =~ s/.tif//g;

	    if ($test eq "0")
		{
			$one = $file;
			$test = 1;
		}
	   else
		{
			$two = $file;
			$test = 0;
		}

	if ($test eq "0")
	{	
	 	$check = $one + 1; #this takes the leaflet tiff and adds "1" to search for page two.
#print " Test:  $test, Page1:  $one, Check:  $check, Page2: $two\n";

		if (($check =~ m/$two/) || ($two =~ m/$check/))

		{
			$x = $one."|".$two;
			push (@Xarray, $x);
		}

		else
		{
			open LOG, ">>", "log.txt" or die $!;
			print "CHECK:  $one does not have a match\n";

			$dt = DateTime->now;
			print LOG "$dt CHECK:  $one does not have a match\n";
			$test = 1;
			$one = $two;
			# set a flag to popup a window and write to a log
			$LOG = 1;
			close (LOG);
		}
	}
	$count = $count+1;


 }

print "COUNT:  $count\n";

	if ($LOG eq "1")
	{
		printf "Check the Log file\n";
		$LOG = 0;

		use Tkx;

    		Tkx::button(".b",   -text => "Check the log file, log.txt", -command => sub { Tkx::destroy("."); },    );
    		Tkx::pack(".b");

    		Tkx::MainLoop();
    		exit;
	}

return @Xarray;

} # End of package
1;