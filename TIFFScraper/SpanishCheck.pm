################################################################################
# This simple class just takes passed in file name, and looks to see if the name
# starts with a "0" implying English or "1" implying Spanish
################################################################################
# Created 4/15/14
################################################################################
# Updates:
# 
################################################################################
# It is instantiated as:  
# #! c:\perl\bin\perl
# use warnings;
# use diagnostics;
# use ReadDir;
#
# $DIR_PATH = "c:\\temp";
#
# $TOP_DIR = ReadDir->new($DIR_PATH);
# @DirArray = $TOP_DIR->Directory();
#
# for $file (@DirArray) 
# {
# 	print "$file\n";
# }
################################################################################

package SpanishCheck;

sub new
{

	my $class = shift; # shift @_
	my $getFile = {
		_file => shift,
	};
	
	bless $getFile, $class;
	return $getFile;
}
	
sub Check
{
	my $self = shift;
	my $File = $self->{_file};
	#printf "$File\n";

	#if (! $File)
	#{
	#	printf "No file passed in $File\n";
	#	exit;
	#}
	
	#if ($File =~ m/^\d{0}/)
	if ($File =~ m/^0/)
	{
		#printf "$File:  ENGLISH\n";
		$STATUS = "ENGLISH";
		return($STATUS);
	}

	#if ($File =~ m/^\d{1}/)
	if ($File =~ m/^1/)
	{
		#printf "$File:  SPANISH\n";
		$STATUS = "SPANISH";
		return($STATUS);
	}
	

}
1;