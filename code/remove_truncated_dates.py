# This file generate the xml files to run BEAST analyses
# Xiang Ji
import argparse, os, re, numpy

def main():
    file_data = numpy.genfromtxt("FluHawkes/data/xml_order_to_remove.csv", usecols=(0), skip_header=0, dtype=None)
    print(file_data)
    x = file_data[:]
    file_data = numpy.genfromtxt("FluHawkes/data/xml_names_to_remove.csv", usecols=(0), skip_header=0, dtype=str)
    print(file_data)
    y = file_data[:]
    with open("FluHawkes/xml/fluCombi_geo_BMDS_Hawkes_dim2.xml","r") as infile:
        with open("FluHawkes/xml/fluCombi_geo_BMDS_Hawkes_Exper.xml","w") as outfile:
            k = 1
            for s in infile:
                if re.match("(.*)<taxon id=(.*)", s):
                    if k in x:        
                        outfile.write(s.replace("<taxon id=","<!-- <taxon id="))
                    else:
                        outfile.write(s)    
                elif(re.match("(.*)</taxon>(.*)", s)):
                    if k in x:        
                        outfile.write(s.replace("</taxon>","</taxon> -->"))
                    else:
                        outfile.write(s)
                    k = k + 1
                elif(re.match("(.*)<taxon idref=(.*)", s)):
                    result = re.search('<taxon idref=\"(.*)\"/>', s)
                    result = str(result.group(1));
                    if result in y:
                        outfile.write(s.replace("<taxon idref=","<!-- <taxon idref=").replace(">","> -->"))
                    else:
                        outfile.write(s)
                elif(re.match('(.*)=\"dateDecimal\">(.*)', s)):
                    result = re.search('=\"dateDecimal\">(.*)<', s)
                    result = str(result.group(1));
                    if '.' not in result:
                        result2 = result[:4] + '.' + result[4:]
                        outfile.write(s.replace(result,result2))
                    else:
                        outfile.write(s)
                else:
                    outfile.write(s)

if __name__ == '__main__':
    main()

# python get_locations_times.py
