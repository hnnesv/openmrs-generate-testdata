#!/usr/bin/perl
use strict;
use warnings;
use DateTime;

# Configure us:
my $creator_id = 1;		#Super user
my $person_start_id = 55;	#The first person id to use
my $identifier_type = 3;	#ECID
my $location_id = 15;		#Unknown
my $encounter_start_id = 51;	#The first encounter id to use
my $encounter_type = 5;		#ANC
my $provider_id = 36;		#HIM User
my $form_id = 1;		#ANC Physical

#obs insert will have num_obs_per_encounter*$num_encounters_per_insert items per statement
my $num_encounters_per_insert = 1000;
####

if ($#ARGV<1) {
	print "Usage: ./openmrs-generate-testdata.pl NUM_PATIENTS NUM_ENCOUNTERS_PER_PATIENT\n";
	print "(even better): ./openmrs-generate-testdata.pl NUM_PATIENTS NUM_ENCOUNTERS_PER_PATIENT | mysql DB -uUSER -p\n";
	exit 1;
}

my $date_created = "'" . DateTime->now->ymd . "'";

#person
print "insert into person (person_id, gender, birthdate, creator, date_created, uuid) values \n";
for (my $id=$person_start_id; $id<$ARGV[0]+$person_start_id; $id++) {
	my $y = 1950 + int(rand(40));
	my $m = 1 + int(rand(12));
	my $d = 1 + int(rand(28));
	my $gender = "'F'";
	#$gender = "'M'" if int(rand(2));
	print "," if $id!=$person_start_id;
	print "($id, $gender, '$y-$m-$d', $creator_id, $date_created, uuid())\n";
}
print ";\n";

#person_name;
print "insert into person_name (preferred, person_id, given_name, family_name, creator, date_created, uuid) values \n";
for (my $id=$person_start_id; $id<$ARGV[0]+$person_start_id; $id++) {
	print "," if $id!=$person_start_id;
	print "(1, $id, 'Random', 'Patient', $creator_id, $date_created, uuid())\n";
}
print ";\n";

#patient
print "insert into patient (patient_id, creator, date_created) values \n";
for (my $id=$person_start_id; $id<$ARGV[0]+$person_start_id; $id++) {
	print "," if $id!=$person_start_id;
	print "($id, $creator_id, $date_created)\n";
}
print ";\n";

#patient_identifier
print "insert into patient_identifier (patient_id, identifier, identifier_type, preferred, location_id, creator, date_created, uuid) values \n";
for (my $id=$person_start_id; $id<$ARGV[0]+$person_start_id; $id++) {
	print "," if $id!=$person_start_id;
	print "($id, uuid(), $identifier_type, 1, $location_id, $creator_id, $date_created, uuid())\n";
}
print ";\n";

# Generate insert ANC Physical encounter statements

exit 0 if $ARGV[1]==0; #nothing more to do

#encounter
my $enc_id = $encounter_start_id;
my $threshold = 0;
my $insert_encounter = "insert into encounter (encounter_id, encounter_type, patient_id, provider_id, location_id, form_id, encounter_datetime, creator, date_created, uuid) values \n";
print $insert_encounter;

for (my $id=$person_start_id; $id<$ARGV[0]+$person_start_id; $id++) {
	for (my $i=0; $i<$ARGV[1]; $i++) {
		if ($threshold==$num_encounters_per_insert) {
			print ";\n$insert_encounter";
			$threshold = 0;
		}

		my $y = 2000 + int(rand(13));
		my $m = 1 + int(rand(12));
		my $d = 1 + int(rand(28));
		print "," if $threshold;
		print "($enc_id, $encounter_type, $id, $provider_id, $location_id, $form_id, '$y-$m-$d', $creator_id, $date_created, uuid())\n";
		$enc_id++;
		$threshold++;
	}
}
print ";\n";

#obs
$enc_id = $encounter_start_id;
$threshold = 0;
my $insert_obs = "insert into obs (person_id, concept_id, value_numeric, encounter_id, location_id, creator, date_created, uuid) values \n";
print $insert_obs;

for (my $id=$person_start_id; $id<$ARGV[0]+$person_start_id; $id++) {
	for (my $i=0; $i<$ARGV[1]; $i++) {
		if ($threshold==$num_encounters_per_insert) {
			print ";\n$insert_obs";
			$threshold = 0;
		}

		print "," if $threshold;

		#weight
		my $wgt = 50 + int(rand(30));
		print "($id, 5089, $wgt, $enc_id, $location_id, $creator_id, $date_created, uuid())\n";
		#temp
		print ",($id, 5088, 37, $enc_id, $location_id, $creator_id, $date_created, uuid())\n";
		#BP
		my $sys = 60 + int(rand(30));
		my $dys = 100 + int(rand(40));
		print ",($id, 5085, $sys, $enc_id, $location_id, $creator_id, $date_created, uuid())\n";
		print ",($id, 5086, $dys, $enc_id, $location_id, $creator_id, $date_created, uuid())\n";
		#number of weeks pregnant
		my $weeks = int(rand(42));
		print ",($id, 160215, $weeks, $enc_id, $location_id, $creator_id, $date_created, uuid())\n";
		#fundal height
		print ",($id, 1439, $weeks, $enc_id, $location_id, $creator_id, $date_created, uuid())\n";
		#fetal heart rate
		my $fhr = 50 + int(50);
		print ",($id, 160315, $fhr, $enc_id, $location_id, $creator_id, $date_created, uuid())\n";

		$enc_id++;
		$threshold++;
	}
}
print ";\n";


####
