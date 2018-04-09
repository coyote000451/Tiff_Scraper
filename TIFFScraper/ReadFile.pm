################################################################################
# This simple class just takes passed in directory path\file reads the file 
# contents an into # an array and returns the array
################################################################################
# Created 12/18/13
################################################################################
# Updates:
# 
################################################################################
# It is instantiated as:  
# #! c:\perl\bin\perl
# use warnings;
# use diagnostics;
# use ReadFile;
#
# $file = ReadFile->new("c:\\temp\\CheckMate.txt");
# @FileArray = $file->GetFile();
#
# for $files (@FileArray)
# {
#	print "$files\n";
# }
#
################################################################################

package ReadFile;

sub new

{

	my $class = shift; # shift @_
	my $getFile = {

		_file => shift,
	};
	
	bless $getFile, $class;
	return $getFile;
}
	
sub GetFile
{
	my $self = shift;
	my $File = $self->{_file};
	
	#print "\nFILE=         $File\n";
	
	if (! -e $File)
	{
		printf "File does not exist, did you forget the directory path?\n";
		exit;
	}
	
	open (FILE, $File) || die $!;
	@RFile = <FILE>;
	chomp (@RFile);
	return @RFile;
	closedir FILE;

}
1;