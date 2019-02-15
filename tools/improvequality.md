improvequality.php is a tool helping in recreating video media of exercises  
it was designed for very old babelium versions and should support during migration to new 2016 version


Inko Perurena <inko@elurnet.net> in December 2015 wrote

To increase the quality of the videos that are already stored in the platform, first you will need the original source video files. The logic behind this is the following: Babelium is designed to pick up the files you upload from a temporary location, convert them to a format suitable for the platform, and remove the original file to save space.

The database does not store any reference to the original filename, because as I mentioned, the original file is removed. This implies that if you want to reencode files with a new quality you must somehow establish a relationship between what is stored in the DB and the original video files.

In order to do this, I could do a script that works like follows:
* Grab some key data of the exercise table and print it to an CSV file
* The CSV file is filled by hand with the filename that belongs to each exercise
* Using that CSV file as input we encode the videos again and replace the inferior quality files. 

I'm going to describe the process with an example for clarity's sake:
* I have 3 exercises in the platform, "Exercise A", "Exercise B" and "Exercise C"
* I run the script $> php improvequality.php getdata /tmp/exercise.csv (where getdata is the operation to perform and /tmp/exercise.csv is the name of the file where I want to print the data I grab from the database).
* If I inspect the file in Excel I will see something like this (see image1). I have to manually fill the filenames (of the original files) that belong to each exercise (see image2).
* Once I have done that, I save the completed CSV and use it as input for the script. $> php improvequality.php putdata /tmp/exercise.csv /tmp/originalvideos (putdata will launch the encoding and replacement, /tmp/exercise.csv is the path of the completed CSV file and /tmp/originalvideos is the directory that has all the original videos with the filenames I specified in the CSV).


Before starting you have to open the script file and change the BABELIUM_HOME constant to point to the upgraded Config.php, Datasource.php and VideoProcessor.php files.  



Inko Perurena <inko@elurnet.net> in Jule 2016 wrote

This script was designed to be launched before running the migration scripts. In other words, you have to run it immediately before this step in the upgrading process: https://github.com/babeliumproject/flex-standalone-site/wiki/Upgrading-existing-platform#apply-the-database-and-data-migrations

The requirements are
* A folder with the original video files which can be read and written by the PHP script (for example, /tmp/originalvideos). Don't use spaces in the filenames, use underscores (My file 1.mp4 => not OK, my_file_1.mp4 => OK).

Then follow these steps
* I have 3 exercises in the platform, "Exercise A", "Exercise B" and "Exercise C"
* I run the script $> php improvequality.php getdata /tmp/exercise.csv (where getdata is the operation to perform and /tmp/exercise.csv is the name of the file where I want to print the data I grab from the database).
* If I inspect the file in Excel I will see something like this:
  
| id   | title      | description                         | filename 
------ | ---------- | ----------------------------------- | ---------------------------------
| 2    | Exercise A | The description of exercise A.      |                
| 4    | Exercise B | The description of exercise B.      |                
| 6    | Exercise C | Another description for exercise.   |                

* Now I have to manually fill the filename column with the original video file that belongs to each exercise.

| id   | title      | description                         | filename                          
------ | ---------- | ----------------------------------- | ---------------------------------
| 2    | Exercise A | The description of exercise A.      | practising_sounds_b.avi           
| 4    | Exercise B | The description of exercise B.      | my_new_file.mp4                   
| 6    | Exercise C | Another description for exercise.   | experiments_with_dubbing.avi 

Don't forget the file extension (.avi, .mp4...). These files should be available in /tmp/originalvideos
* I save the completed CSV and use it as input for the script. $> php improvequality.php putdata /tmp/exercise.csv /tmp/originalvideos (putdata will launch the encoding and replacement, /tmp/exercise.csv is the path of the completed CSV file and /tmp/originalvideos is the directory that has all the original videos with the filenames I specified in the CSV).
