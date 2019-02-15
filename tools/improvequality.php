<?php

if(!defined('BABELIUM_HOME')) define('BABELIUM_HOME', '/var/www/babelium/');

require_once BABELIUM_HOME . 'services/utils/Config.php';
require_once BABELIUM_HOME . 'services/utils/Datasource.php';
require_once BABELIUM_HOME . 'services/utils/VideoProcessor.php';

try{
	$CFG = new Config();
	$DB = new Datasource($CFG->host, $CFG->db_name, $CFG->db_username, $CFG->db_password);
	$VP = new VideoProcessor();
	global $DB, $CFG, $VP;
	run_command($argv);
} catch (Exception $e) {
	echo ('Failed with ' . get_class($e) . ': ' . $e->getMessage()."\n");
}

function run_command($_argv) {
	if (!isset($_argv[1])) {
		throw new Exception('No command specified');
	}
	$cmd = $_argv[1];
	$opts = array_slice($_argv, 2);

	if (!in_array($cmd, array('getdata', 'putdata'))) {
		throw new Exception('Invalid Command');
	}

	if ($cmd === 'getdata') {
		if(isset($opts[0])){
			$path_parts=pathinfo($opts[0]);
			if (is_writable($path_parts['dirname']) && $path_parts['extension'] == 'csv'){
				get_csv_template($opts[0]);
				return;
			} else {
					throw new Exception("The provided output file is not valid or the directory is not writable");
			}
		} else {
			throw new Exception('Output file was not specified');
		}
	}

	if ($cmd === 'putdata') {
		if(count($opts) == 2){
				if(is_file($opts[0])){
						if(is_dir($opts[1]) && is_readable($opts[1])){
							reencode_video_files($opts[0],$opts[1]);
							return;
						} else {
							throw new Exception("The provided parameter is not a dir or is not readable");
						}
				} else {
					throw new Exception("The parameter is not a CSV file");
				}
		} else {
			throw new Exception("The command 'putdata' expects 2 parameters");
		}
	}
}

function get_csv_template($file){
	global $DB;

	$sql = "SELECT id, title, description FROM exercise WHERE status='Available'";
	$data = $DB->_multipleSelect($sql);
	if(!$data){
		throw new Exception('Did not find any exercise');
	} else {
		$fh = fopen($file, 'w') or die("Can't open file");
		$header = array('id','title','description','filename');

		fputcsv($fh, $header);

		foreach($data as $row){
			$assoc_row = (array) $row;
			$assoc_row['description'] = strip_tags($assoc_row['description']);
			$assoc_row['filename'] = '';
			$values = array_values($assoc_row);

			fputcsv($fh, $values);
		}

		fclose($fh);
	}
}

function reencode_video_files($csvfile,$videodir){
	global $CFG, $DB, $VP;

	$preset = 2;
	$dimension = Config::LEVEL_360P;
	$exercisedir = $CFG->red5Path.'/exercises/';

	$fh = fopen($csvfile, "r") or die("Can't open file");
	$row = 0;
	while(($data = fgetcsv($fh)) !== FALSE){
		if($row > 0){
			$num = count($data);
			$exerciseid = $data[0];
			$filename = $data[$num-1];
			if($exerciseid){
				if(!empty($filename)){
					$filepath = rtrim($videodir, '/').'/'.$filename;
					if(is_file($filepath) && is_readable($filepath)){
						$sql = "SELECT name FROM exercise WHERE id=%d AND status='Available'";
						$result = $DB->_singleSelect($sql,$exerciseid);
						if($result){
							$exercisecode = $result->name;
							//Backup the original file
							if(@rename($exercisedir.$exercisecode.'.flv',$exercisedir.$exercisecode.'.flv.old') !== FALSE){
								$input = $filepath;
								$output = $exercisedir.$exercisecode.'.flv';
								try{
									$VP->transcodeToFlv($input,$output,$preset,$dimension);
									$filehash = sha1_file($output);
									$sql = "UPDATE exercise SET filehash='%s' WHERE id=%d";
									$DB->_update($sql,$filehash,$exerciseid);
								} catch(Exception $e){
									//Restore the backup
									rename($exercisedir.$exercisecode.'.flv.old',$exercisedir.$exercisecode.'.flv');
									$message = $e->getMessage();
									printf("Error while encoding %s: %s. Skipping to next row\n",$input,$message);
								}
							} else {
								print("Previous file of the exercise was not found. Skipping to next row\n");
							}
						} else {
							throw new Exception("ExerciseID %d not found in database, skipping to next row",$exerciseid);
						}
					} else {
						printf("The file %s does not exist or cannot be read\n",$filepath);
					}
				} else {
					printf("The filename that belongs to ExerciseID %d is empty\n",$exerciseid);
				}
			} else {
				print("Row contains an invalid exercise ID and it gets skipped\n");
			}
		}
		$row++;
	}
	fclose($fh);
}
