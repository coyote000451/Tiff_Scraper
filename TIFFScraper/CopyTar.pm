use warnings;
use diagnostics;

package CopyTar;

sub new
{
	my $class = shift;
	my $copyFile = {
		_source => shift,
		_node   => shift,
		};
	bless $copyFile, $class;
	return $copyFile;

}

sub copyFiles
{
	my $self = shift;
	my $Source = $self->{_source};
	my $Node = $self->{_node};

	print "Source directory is:  $Source\n";
	print "Node destination is:  $Node\n";

	# Very important allows quotes into xcopy command
	my $SourceCopy = "\"$Source\"";	
	#my $copyInstall="xcopy"." "."/y"." "."$SourceCopy"." ".$Node; #works

	#2/20/18:  xcopy quit working across domains, so subsituted in copy
	my $copyInstall="xcopy"." "."/y"." "."$SourceCopy"." ".$Node; #works
	printf "CopyTar.pm:: INSTALL:  $copyInstall\n";

	#system("$copyInstall") or die "$!";
	system("$copyInstall");
}

sub copyFilesRec
{
	my $self = shift;
	my $Source = $self->{_source};
	my $Node = $self->{_node};

	print "Source directory is:  $Source\n";
	print "Node destination is:  $Node\n";

	# Very important allows quotes into xcopy command
	my $SourceCopy = "\"$Source\"";
	my $NodeCopy   = "\"$Node\"";
	my $copyInstall="xcopy"." "."/y/I/E"." "."$SourceCopy"." "."$NodeCopy";
	printf "CopyTar.pm:: INSTALL:  $copyInstall\n";

	#system("$copyInstall") or die "$!";
	system("$copyInstall");
}
1;
