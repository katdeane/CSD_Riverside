## This repo contains Dynamic CSD Analysis for projects associated with Razak Lab at University of California Riverside

All folders with untracked files have a README.md file in order to populate in your local repository.

### For information on how to use these scripts, please contact me at katrinad@ucr.edu
If you use this code, please cite our [latest paper](https://www.sciencedirect.com/science/article/pii/S0969996125001792?via%3Dihub).

### Good Git/programming practices:
***
	1. Write good commit messages
		* Because we should be able to skim the list of changes and retrace steps
	2. Write good variable names (concise but specific)
		* Increases readability
	3. Make small commits when possible
		* Summarize the change in a sentence or phrase - Increases readability of tracking
		* If you feel the commit message is too long, instead split it to several commits
	4. Before you Push all of your code changes, Pull the online directory to sync locally 
		* This will massively simplify any merge conflicts that arise as you will be able to handle them locally
	5. Write good documentation explaining your functions
		* Input, output, folder paths, and if necessary the shape of data input
	6. UPDATE documentation in functions if you altered the function
        * Be mindful that functions are used in multiple pipelines, so if a large change is needed, craft a new function
    7. Keep functions as small as possible
        * A function should fulfill a specific purpose, which could be broken up into a series of smaller purposes/functions
        * Call everything from a pipeline script
	
***