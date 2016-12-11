#!/usr/bin/env python

import sys

cur_word = None
cur_count = 0
w = None

for line in sys.stdin:
	line = line.strip()
	try: 
		w, count = line.split('\t', 1)
	except:
		print line


	try:
		count = int(count)
	except:
		continue

	if cur_word == w:
		cur_count += count
	else: 
		if cur_word:
			print '%s\t%s' % (cur_word, cur_count)
		cur_count = count
		cur_word = w

if cur_word == w:
	if cur_count >= 10000:
		print '%s\t%s' % (cur_word, cur_count)
