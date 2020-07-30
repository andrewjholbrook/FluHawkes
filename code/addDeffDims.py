# This file generate the xml files to run BEAST analyses
# Xiang Ji
import argparse, os, re

# def main(args):
# 	with open(args.input,'r') as infile:
# 		with open(args.output, 'w') as outfile:
# 			for s in infile:
# 				if re.match("(.*)<attr name="Deff_2">(.*)", s):
# 					outfile.write(s.replace("</attr>", " 1 1 1 1</attr>"))
# 				

if __name__ == '__main__':
#     parser = argparse.ArgumentParser()
#     parser.add_argument('--input', required = True, dest = 'input', help = 'file to edit')
#     parser.add_argument('--output', required = True, dest = 'output', help = 'output file name')
#     
#     main(parser.parse_args())

# python ExampleEditorForAndrew.py --input test.xml --fold 2 --output test2.xml

	with open("FluHawkes/xml/fluCombi_geo_BMDS_Hawkes_dim2.xml",'r') as infile:
		with open("FluHawkes/xml/fluCombi_geo_BMDS_Hawkes_dim6.xml", 'w') as outfile:
			for s in infile:
				if re.match("(.*)<attr name=\"Deff_2\">(.*)", s):
					outfile.write(s.replace("</attr>", " 1 1 1 1</attr>"))
				else:
					outfile.write(s)
				