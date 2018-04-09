################################################################################
# This simple class just takes passed in directory path, loads the contents into
# an array and returns the array
################################################################################
# Created 12/12/13
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

package ReadDir;

sub new
{

	my $class = shift; # shift @_
	my $getDir = {
		_directory => shift,
	};
	
	bless $getDir, $class;
	return $getDir;
}
	
sub Directory
{
	my $self = shift;
	my $Directory = $self->{_directory};
	
printf "ReadDir::Directory=$Directory\n";

	if (! -d $Directory)
	{
		printf "ReadDir:: Not a directory\n";
		exit;
	}
	
	opendir (DIR, $Directory) || die $!;
	@RDir = readdir DIR;
	shift @RDir; #remove "."
	shift @RDir; #remove ".."
	return @RDir;
	closedir DIR;

}
1;