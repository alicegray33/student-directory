# student-directory

The student directory script allows you to manage a list of students enrolled at a school, categorize them by cohort and input test scores. The script was made as part of my Makers Academy Basic Programming module and was not intended for any real world use. 

## Installation

Open Terminal, change to the directory where you want the script installed, then type:
```
$ git clone https://github.com/alicegray33/student-directory
```

The script requires the CSV library for Ruby. If you don't already have it, you can type the following in Terminal:
```
$ gem install csv
```

## How to run

Open Terminal, change to the directory where it was installed, then type:
```
$ Ruby directory.rb
```

## Usage

First time use will ask you to set up some basic settings, such as asking you for the name of the school, the current cohort and where to save the list of students. Once setup you can add students, list all students and delete students.

## Future Updates

Currently test scores are added for all students as "0." Time permitting, I may add ways to update the test score, and calculate averages and various stats on the test scores. I also hope to add a basic search function of the students list.
