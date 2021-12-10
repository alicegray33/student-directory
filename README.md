# student-directory

The student directory script allows you to manage a list of students enrolled at a school, categorize them by cohort and input test scores. The script was made as part of my Makers Academy Basic Programming module and was not intended for any real world use. 

## Installation

Open Terminal, change to the directory where you want the script installed, then type:
```
$ git clone https://github.com/alicegray33/student-directory
```

The script requires the CSV library for Ruby. If you don't already have it, you can install it through Bundler by typing the following in Terminal:
```
$ bundle
```

Or you can install csv yourself by typing:
```
$ gem install csv
```

## How to run

Open Terminal, change to the directory where it was installed, then type:
```
$ Ruby directory.rb
```

## Usage

First time use will ask you to set up some basic settings, such as asking you for the name of the school, the current cohort and where to save the list of students. Once setup you can add students, list all students and delete students. You can also search for students by name or ID number. Finally; you can input test scores and then get the average score by cohort, as well as the highest and lowest scores by cohort.
