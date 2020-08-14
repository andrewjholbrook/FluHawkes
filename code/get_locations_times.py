# This file generate the xml files to run BEAST analyses
# Xiang Ji
import argparse, os, re

def main():
	with open("FluHawkes/xml/fluCombi_geo_BMDS_Hawkes_dim2.xml",'r') as infile:
		with open("FluHawkes/data/locations_times.txt", 'w') as outfile:
			for s in infile:
				if re.match("(.*)<taxon id=(.*)", s):
					result3 = re.search('<taxon id=\"(.*)\">', s)
					outfile.write(str(result3.group(1)) + " ")
				if re.match("(.*)<attr name=\"dateDecimal\">(.*)", s):
					result1 = re.search('<attr name=\"dateDecimal\">(.*)</attr', s)
					outfile.write(str(result1.group(1)) + " ")
				if re.match("(.*)<attr name=\"country\">(.*)", s):
					result2 = re.search('<attr name=\"country\">(.*)</attr', s)
					outfile.write(str(result2.group(1)) + " ")
				if re.match("(.*)<attr name=\"spLocation\">(.*)", s):
					result3 = re.search('<attr name=\"spLocation\">(.*)</attr', s)
					outfile.write(str(result3.group(1)) + "\n")

if __name__ == '__main__':
	main()

# python get_locations_times.py
