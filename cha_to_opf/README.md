## Task 2

### cha2opf.rb


This script populates the .opf based on the .cha file: for each line that starts with '\*', write the utterance, the mor analysis if there is one, and the timestamps

### Usage
Select a video and its corresponding .cha file, modify line 8 of task2_1.rb to set the right path to the .cha file
Once the video uploaded in Datavyu, go to Script/Run script and select cha2opf.rb


_**NOTE FROM NASEEM**: Sometimes, there will be an error when running the first task. This error has to do with the fact that CLAN wraps lines. If you encounter this problem, follow the steps below.
1) uncomment line 16 in task2_1.rb
2) re-run task2_1.rb on the same file, and make note of which line has the problem
3) open the .cha file in ATOM
4) search for the line that had the problem, and delete the extra space so that all of the data exists on one line
5) SAVE the .cha file in Atom, and rerun the task2_1.rb in datavyu
6) if the same error happens, go back to step 4 until an error doesn't occur
7) recomment line 16 in task2_1.rb
8) proceed to task2_2.rb_

### get_nouns.rb

Retrieves the nouns in the mor analysis and creates a new column with all nouns and their information.

### Usage

From Datavyu, go to Script/Run script and select get_nouns.rb
