S1 ReadMe - Dictionary Patterns to PList

Goal - Load dictionary patterns from csv to a PList.

Status - V1 Complete.  Plist dictionaries have been generated.

Next
-----
Configuration information (folder, source and target files) is stored in a plist in /tmp
Write that info to the current users Library folder.  
Requires folder creation (SPSW/DictPatternToPList) prior to writing plist file.

Current App
-------------
Inputs - 
	Working Dir
	Dictionary Pattern CSV
	PList Output: 

Processing -
On Go button press, 
	save input fields to a plist (ln85)
		Done by putting fields in a Mutable array
		Array has method writeToFile (ln68)

	get lines from input file
		read to NSData object 

Output
	PList file
		DictionaryPatterns_SORTED.csv -> 31195 entries
		DictionaryPatterns -> 31195 entries
		NOTE: File size shows as 1.3MB and 1.2MB respectively


