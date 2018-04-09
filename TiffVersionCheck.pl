#! c:\perl\bin
use warnings;
use diagnostics;

####################################################################################################################
# Take NOTE! This is how we tell the compiler where to find the custom modules, by loading the reserved @INC array #
####################################################################################################################

	BEGIN 
	{
  		push @INC, "c:\\temp";
  		push @INC, "c:\\PerlScripts\\Modules";
		push @INC, "C:\\Temp\\PERLSDKv4";
	}

use CopyTar;
use ReadDir;
use ReadFile;
use SpanishCheck;
use medcoCheck1;
use MedcoDBVerChk;

########################################################################################################################
# Get the arguments
########################################################################################################################

	$Version = $ARGV[0];

	if (! $Version)
	{
		print "[Usage:  Version, 205, 206, 207 ... ]\n";
		exit;
	}

	
########################################################################################################################
# Variable Declaration
########################################################################################################################
	
$SRC_DIR	= "\\\\gmfileshare01\\Multum-Production\\ProductionReleases\\Medco";
#$DIR_PATH 	= "\\\\Ipmulqa2k12r2-2\\c\\Temp\\TIFFv$Version\\TIFF-sheet";
$DIR_PATH 	= "\\\\Ipmulqabuild4.northamerica.cerner.net\\c\\Temp\\TIFFv$Version\\TIFF-sheet";
$TEST_MAIN	= "c:\\Temp";
$FILE_NAME	= "TIFFTextv$Version";
$DIR_TEST 	= "$TEST_MAIN\\$FILE_NAME";
$OUTPUT		= "OUTPUT_v$Version.txt";

########################################################################################################################

########################################################################################################################
# Check for $SRC_DIR existence
########################################################################################################################

	if (! -d $SRC_DIR)
	{
		print "Directory Path:  $SRC_DIR cannot be found\n";
		exit;
	}
	

########################################################################################################################
# Check the $OUTPUT file
########################################################################################################################

	if (-f $OUTPUT)
	{
		print "$OUTPUT exists, do you want to rename?\n";
		my $response5 = <STDIN>;
		if (($response5 =~ m/Y/) || ($response5 =~ m/y/) || ($response5 =~ m/Yes/) || ($response5=~ m/yES/) || ($response5 =~ m/yes/))
		{
			print "What name do you want to use: ";	
			my $newfilename = <STDIN>;
			print "$DIR_TEST\n";
			print "$TEST_MAIN\n";
			print "$FILE_NAME\n";
			system ("rename $OUTPUT $newfilename");	
		}
	}

########################################################################################################################
# Check the $DIR_TEST
########################################################################################################################
	
	if (-d $DIR_TEST)
	{
		print "$DIR_TEST exists, do you want to rename?\n";
		my $response2 = <STDIN>;
		if (($response2 =~ m/Y/) || ($response2 =~ m/y/) || ($response2 =~ m/Yes/) || ($response2 =~ m/yES/) || ($response2 =~ m/yes/))
		{
			print "What name do you want to use: ";	
			my $newname = <STDIN>;
			print "$DIR_TEST\n";
			print "$TEST_MAIN\n";
			print "$FILE_NAME\n";
			system ("rename $DIR_TEST $newname");	
		}
	
	}

	if (! -d $DIR_TEST)
	{
		print "Directory Path:  $DIR_TEST cannot be found\n";
		print "Do you want to create $DIR_TEST?\n";
		my $response1 = <STDIN>;
		if (($response1 =~ m/Y/) || ($response1 =~ m/y/) || ($response1 =~ m/Yes/) || ($response1 =~ m/yES/) || ($response1 =~ m/yes/))
		{
			system ("mkdir $DIR_TEST");
			print ("\n");
			print ("$DIR_TEST created");	
		}
		else
		{
			print "Goodbye\n";
			exit;
		}
		
	}	


########################################################################################################################
# Check to make sure the leaflets haven't already been copied over
# Test for $DIR_PATH
########################################################################################################################



	if (! -d $DIR_PATH)
	{
		print "Directory Path:  $DIR_PATH does not exist\n";
	
		my $TOP_DIR = ReadDir->new($SRC_DIR);

		my @DirArray = $TOP_DIR->Directory();
		
		for my $check (@DirArray)
		{
			if ($check =~ m/$Version/)
			{
				$FileName = $check;
				print "FILENAME:  $FileName\n";
			}
		}

		print "$Version will need to be copied, do you wish to continue? Y/N \n";
		$response = <STDIN>;

		if (($response =~ m/N/) || ($response =~ m/n/) || ($response =~ m/No/) || ($response =~ m/nO/) || ($response =~ m/no/))
		{
			print "Goodbye\n";
			exit;
		}

		my $TOP_DIR1 = ReadDir->new("$SRC_DIR\\$FileName");

#print("$SRC_DIR\\$FileName\n");
#exit;
		my @DirArray1 = $TOP_DIR1->Directory();	
		@DirArray1 = sort @DirArray1;
		my $FileName1	= $DirArray1[$#DirArray1];
		print "FileName1:  $FileName1\n";
#exit;

##  1/21/16 uncommenting to account for change of directory name
#####################################################################
		my $TOP_DIR2 = ReadDir->new("$SRC_DIR\\$FileName\\$FileName1");
		my @DirArray2 = $TOP_DIR2->Directory();	
		@DirArray2 = sort @DirArray2;
		#my $FileName2	= $DirArray2[$#DirArray2];


		for my $result (@DirArray2)
		{
		#	
		$test = $SRC_DIR."\\".$FileName."\\".$FileName1."\\"."$result"; #add the file to the full path and then test it
		print "RESULT is :  $test\n";
#

			if (-d $test)
			{
				#$FileName2	= $DirArray2[$#DirArray2];
				$FileName2 = $result;
				print "FILENAME2:  $FileName2";
			}
		}
#
		$TIF = $SRC_DIR."\\".$FileName."\\".$FileName1."\\"."$FileName2";
		print "Tiff dir:  $TIF\n";

#######################################################################

##  1/21/16 commenting out this line and taking advantage of the above line.
		#$TIF = $SRC_DIR."\\".$FileName."\\".$FileName1."\\"."TIFF-SHEET";

#######################################################################

		my $copyTIF = CopyTar->new($TIF, "$DIR_PATH");
		$copyTIF->copyFiles();

	}


#goto JUMP;

########################################################################################################################
# Location of Text TIFF files                                                                                          #
########################################################################################################################

	$z = medcoCheck1->new($DIR_PATH);
	@zArray = $z->MedDir();

	for $r (@zArray)
		{
			print "$r\n";

			@TmpArray = split('\|', $r);

			for $h (@TmpArray)
			{
				push (@DirArray, $h);
			}
			
		}

 for $file (@DirArray) 
 {

# Add *.tif extenstion back in as method strips it off

	$file = "$file"."\.tif";
	
	$passfile = $file;
	$passfile =~ s/.tif//g;

	$Language = SpanishCheck->new($passfile); # Method to determine if this is a English or spanish leaflet
	$Status = $Language->Check();
	#printf "STATUS:  $Status\n";

	if ($Status =~ m/ENGLISH/)
	{
		printf "STATUS:  $Status\n";
		system("c:\\FreeOCR\\tesseract.exe $DIR_PATH\\$file $DIR_TEST\\$file")
	}

	if ($Status =~ m/SPANISH/)
	{
		printf "STATUS:  $Status\n";
		print "$file\n";
		system("c:\\FreeOCR\\tesseract.exe $DIR_PATH\\$file $DIR_TEST\\$file -l spa")
	}

	#system("c:\\FreeOCR\\tesseract.exe $DIR_PATH\\$file $DIR_TEST\\$file")
 }

#JUMP:

$DIR_TEXT = ReadDir->new($DIR_TEST);
@TextArray = $DIR_TEXT->Directory();
$counter = 0;
$foundSingle = "0";
$foundTwo = "0";
$ctr = 0;
$check = 0;

for $text (@TextArray)
{
	$counter = $counter + 1;			
																							
	$gfile = ReadFile->new("$DIR_TEST\\$text");
	@rfile = $gfile->GetFile();
																							
	$text =~ s/.tif.txt//g;
		
		for $stext (@rfile)
		{
#print "$stext\n";
			if ($stext =~ m/Versi|Versron|Revisado|Cerner|Vers\|on/i)																	
			{				
				$ctr = $ctr + 1;
#print "STEXT: $stext\n";
#print "CTR:  $ctr\n";
				@words = split (/ +/, $stext);

					foreach $sstext (@words)
					{																																	
						#print "SSTEXT:  $sstext\n";	
		
							if (($sstext =~ m/\d{2}\.\d{2}/) || ($sstext =~ m/\d{1}\.\d{2}/) || ($sstext =~ m/\d{1}\.\d{1}/) || ($sstext =~ m/\d{2}\.\d{1}/))																						
							{
								$temp = $text."|".$sstext;
								push (@AArray, $temp);	
								#print "$sstext MATCH\n";
								
							}

					} # @words array					
					#print "TEMP:  $temp\n";
					for $vtext (@words)
					{
						$check = $check + 1;						
						
						$vtext =~ s/Versién:/Version/;
						
						if ($vtext =~ m/Versron|Version|Vers\|on/)	

						{
							$index = $check;
							#print "INDEX:  $index\n";
							$first = $words[$index];
							$second = $words[$index+1];
							
							if ($first && $second)
								{
									$sum = $first.".".$second;
									#print "SUM: $sum\n";										
									$temp1 = $text."|".$sum;
										if (($sum =~ m/\d{2}\.\d{2}/) || ($sum =~ m/\d{1}\.\d{2}/) || ($sum =~ m/\d{1}\.\d{1}/) || ($sum =~ m/\d{2}\.\d{1}/))
											{
												if ($temp1 !~ m/Revisado|Revised|Revrsado/)
												
													{
														push (@AArray, $temp1);
													}
											}
								}
						}
				
					}
					$check = 0;					
			}						
		}
}

$count = 0;
$set = 0;
$count1 = 0;
$count2 = 0;
for $ssstext (@AArray)
{
		$count = $count + 1;
		
		if ($set eq "0")
		{
			$one = $ssstext;
			$oneone = $one;
			$oneone =~ s/\d+\|//;
			$oneone =~ s/\.$//;
			#$one = s/(?<=\d{1}.\d{2})//; # ()?<=...) look behind regex
			$set = "1";
			$savone = $oneone;
			next;
		}
		
		if ($set eq "1")
		{
			$two = $ssstext;
			$twotwo = $two;
			$twotwo =~ s/\d+\|//;
			$twotwo =~ s/\.$//;
			#$two = s/\|\d+.//;
			$set = "0";
			$savtwo = $twotwo;
		}
		

		if ($savtwo =~ m/$savone/)
		{
			$count1 = $count1 + 1;
			print "$one|$two|$savone|$savtwo|MATCH\n";

			push(@dbVerChk, $one);
print "ONE: $one\n";
		}
		else {$count2 = $count2 + 1; print "$one|$two|$savone|$savtwo|NOMATCH\n"}

}
print "COUNT:  $count\n";
print "Files:  $counter\n";
print "Version Count: $ctr\n";
print "Counter1 Match: $count1\n";
print "Counter2 Match: $count2\n";


##########################################################################################################################
# Describe the output file                                                                                               #
##########################################################################################################################
#open FILE, ">>", "OUTPUT1_15Jul15v213.txt" or die $!;
open FILE, ">>", "$OUTPUT" or die $!;

for $dfiles (@dbVerChk) # $dfiles contains medco id and version
{
	
	print FILE "$dfiles||"; #print $one
		
			$Strip = "TRUE";
		
			@DArray = split('\|', $dfiles);

			for $h (@DArray)
			{

				if ($Strip eq "TRUE")
					{
					
						if ($h =~ m/^0/)  #English
						{
							$FUNCTION_ID = 18;

							$h =~ s/^\d//; #strip first numeric
							$h =~ s/\d$//; #strip last numeric
							$h =~ s/\d$//; #strip last numeric

							$savh	= $h; #need this
							$y = MedcoDBVerChk->new($h,$FUNCTION_ID,$Version);
							$w = $y->MedCoId();

#print "VER back from method:  $w\n";

							if (!$w)
							{
								$FUNCTION_ID = 36;
								$y = MedcoDBVerChk->new($h,$FUNCTION_ID,$Version);
								$w = $y->MedCoId();
							}
						
						}
						elsif ($h =~ m/^1/) #Spanish
						{
							$FUNCTION_ID = 24;

							$h =~ s/^\d//; #strip first numeric
							$h =~ s/\d$//; #strip last numeric
							$h =~ s/\d$//; #strip last numeric

							$savh	= $h; #need this
							$y = MedcoDBVerChk->new($h,$FUNCTION_ID,$Version);
							$w = $y->MedCoId();

							if (!$w)
							{

								$FUNCTION_ID = 42;
								#$y = MedcoDBVerChk->new($h,$FUNCTION_ID);
								$y = MedcoDBVerChk->new($h,$FUNCTION_ID,$Version);
								$w = $y->MedCoId();

								# Its possible $w still returns NULL
							}
						}
						
					$Strip = "FALSE";
chomp($h);
#print "MEDCOID|$h|";

#print "VERsion back from method:  $w\n";



					#Run DBI query here using the medco version
					} # Strip clause

						# Turned on 6/19/15 for debug
						#print "DEBUG:  MedcoId|$savh|FunctionId|$FUNCTION_ID|DBVer|$w|LeafVer|$h|";

					if ($w =~ m/$h/) #$h in this case is the version

						{
						print "MedcoId|$savh|FunctionId|$FUNCTION_ID|DBVer|$w|LeafVer|$h|MATCH\n";
						print FILE "MedcoId|$savh|FunctionId|$FUNCTION_ID|DBVer|$w|LeafVer|$h|MATCH\n";
						#print "MATCH\n";
						}

					#else {print "MEDCOID|$savh|\n"}
					
					#Check returned result with next value in the array which is the version

				#push (@DDArray, $h);
			}			

}

close(FILE);


