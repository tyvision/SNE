#!/usr/bin/env python
import sys
import urllib
import string

lang="en"

ex_topics=["Media", "Special", "Talk", "User", "User_talk", "Project", "Project_talk", "File", "File_talk", "MediaWiki", 
"MediaWiki_talk", "Template", "Template_talk", "Help", "Help_talk", "Category", "Category_talk", "Portal", "Wikipedia",
"Wikipedia_talk", "404_error/", "Main_Page", "Hypertext_Transfer_Protocol", "Search"] 
ex_formats=[".jpg", ".gif", ".png", ".JPG", ".PNG", ".GIF", ".txt", ".ico"]


# 
# type of the input string:
# <project name> <page title> <number of accesses> <total data returned in bytes>

def eng(let):
	alph = string.ascii_letters + string.digits
	for i in alph:
		if let == i:
			return True
	return False


def exclusion(dat):

	if len(dat) < 3:
		return False
	
	#if dat[1].isupper() == False and dat[1].islower() == False or dat[1].isdigit() == False:
		#if dat[2].isupper() == False and dat[2].islower() == False or dat[2].isdigit() == False:
	#	return False

	if dat[0].isupper() == False:
		#print "---------------------- NOT IN UPPER CASE ------------------"	#debug print
		return False		# false if dat[0] not in upper case
	
	if eng(dat[1]) == False:
		return False
	
	for fmt in ex_formats:
		if dat[-4:] == fmt:
			#print "---------------------- FORMAT INTRUSION ------------------"	#debug print
			return False
	
	for top in ex_topics:
		if dat == top:
			#print "---------------------- TOPIC INTRUSION ------------------"   #debug print
			return False

	return True


def filter(str1):
	name = str1.split(':')
	
	# check if there's only 1 part 
	if len(name) == 1:
		if exclusion(name[0]) == False:
			return False

	elif len(name) > 1:
		if exclusion(name[0]) == False or exclusion(name[1]) == False:
			return False


# main function
for line in sys.stdin:
	line = line.strip()
	fields = line.split()
	
	if fields[0] == lang:
		continue	
	

	#print fields[1].split(':')
	fields[1] = urllib.unquote(fields[1])
	
	#print fields

	if filter(fields[1]) == False:
		continue
	
	
	
	# for i in (fields[1].split(':'))[(1 if len(fields[1].split(':')) else 0)::]:
	# 	if i == "": 
	# 		continue
	# 	arcticle += i
	#print arcticle + '\t' + fields[2]
	print fields[1] + '\t' + fields[2]
	
	#print "---------------------- Okay!!!! ----------------------"		#debug print
	#print ""
	#print ""

		



# # filter function
# # performs various conditions
# def filter(str1):
# 	index = 0


# 	for i in str1:
# 		if len(i) == 0:
# 	 		return False

# 	if len(str1) == 1:
# 		if str1[index][0].isupper() == False:			# return if first letter is not in upper case
# 			return False
# 	elif len(str1) >= 2:
# 		index=1
# 		for t in ex_topics:
# 			if str1[0] == t:
# 				#print "---------------------- TOPIC INTRUSION ------------------"	#debug print
# 				return False

# 	for f in ex_formats: 
# 	 	if str1[index][-4:] == f:
# 	 		#print "---------------------- FORMAT INTRUSION ------------------"   #debug print
# 	 		return False
	 	
# 	 	if str1[index][0].isupper() == False:			# return if first letter is not in upper case
# 			return False
# 	return True