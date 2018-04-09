#!c:\perl\bin -w
use diagnostics;
use DBI;
use Win32::OLE;
# 
# 4/30/14
#

package MedcoDBVerChk;

sub new
{
	my $class = shift; # shift @_
	my $getId = {
		_MedCoId 	=> shift,
		_FuncId  	=> shift,
		_Version 	=> shift,
	};
	
	bless $getId, $class;
	return $getId;
}

sub MedCoId
{
	my $self 		= shift;
	my $MedId 		= $self->{_MedCoId};
	my $FuncId 		= $self->{_FuncId};
	my $Version 		= $self->{_Version};
	$medcode_id 		= $MedId;
	$function_id 		= $FuncId;
	$vers			= $Version."."."00000";

	#print "RECEIVING MEDCOID:  $medcode_id\n";
	#print "RECEIVING FUNCTION_ID:  $function_id\n";
	#print "RECEIVING VERSION:  $vers\n";
	#sleep(1);

#
# SQL Server
 my $DSN = 'driver={SQL Server};Server=ResearchDB; database=Global_Distribute;TrustedConnection=Yes'; 
 my $dbh = DBI->connect("dbi:ODBC:$DSN") or die "$DBI::errstr\n";
#

# Setting up access
#$dbh = DBI->connect('dbi:ODBC:driver=microsoft access driver (*.mdb);dbq=\\\\ada\\1-qa\\AccessDBQA\\Medco\\Medco2001\\Medco2001.mdb',Admin,'');
#

$dbh->{'LongTruncOk'} = 1;
$dbh->{'LongReadLen'} = 65535;
	

		$table = "leaf_medco_cur";
		#$table = "medco_leaflet";
		#$sth = $dbh->prepare("SELECT medcode_id, MAX(leafletversion) AS leafletversion_max FROM $table WHERE medcode_id = $MedId and function_id = $function_id GROUP BY medcode_id");
		#$sth = $dbh->prepare("SELECT distinct leafletversion FROM $table WHERE medcode_id = $MedId and function_id = $function_id and dp_version = 213.00000");		
		$sth = $dbh->prepare("SELECT distinct leafletversion FROM $table WHERE medcode_id = $MedId and function_id = $function_id and dp_version = $vers");
		$sth->execute;
		$LeafletVer = $sth->fetchrow_array();
		$sth->finish;
#print "Returned LEAFLETVERSION:  $LeafletVer\n";
		return($LeafletVer);

}
1;


