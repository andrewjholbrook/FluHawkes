# This file generate the xml files to run BEAST analyses
# Xiang Ji
import argparse, os

def main(args):
	with open(args.input,'r') as infile:
		with open(args.output, 'w') as outfile:
			for s in infile:
				outfile.write(s.replace("data/trainFold", "data/trainFold" + args.k + ".txt").replace("locations_6.log", "locations_6" +  args.k + ".log").replace("parameters6","parameters6"+args.k))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--fold', required = True, dest = 'k', help = 'k value')
    parser.add_argument('--input', required = True, dest = 'input', help = 'file to edit')
    parser.add_argument('--output', required = True, dest = 'output', help = 'output file name')
    
    main(parser.parse_args())

# python ExampleEditorForAndrew.py --input test.xml --fold 2 --output test2.xml
