# bash FluMDS/kfold_dim2.sh
# bash FluMDS/kFold_dim3.sh
# bash FluMDS/kFold_dim4.sh
# bash FluMDS/kFold_dim5.sh
# bash FluMDS/kFold_dim6.sh
# bash FluMDS/kFold_dim7.sh
# bash FluMDS/kFold_dim8.sh

for d in {3..8}; do
	for k in {1..1}; do
	 	echo $k >> kFold.log

 		python code/editxml_dim$d.py --input xml/cv$d.xml --fold $k --output xml/cv$d$k.xml
 
 		#java -jar -Djava.library.path=/usr/lib/jvm -Dmds.library.path=/home/aholbrook/MassiveMDS/build -Dmds.required.flags=48 -Dmds.resource=1 -Dhph.library.path=/home/aholbrook/hawkes/build -Dhph.required.flags=16 -Dhph.resource=1 /home/aholbrook/beast-mcmc/build/dist/beast.jar  -seed 666 -overwrite /home/aholbrook/FluHawkes/xml/fluCombi_geo_BMDS_Hawkes_dim$d$k.xml
		java -jar -Djava.library.path=/usr/lib/jvm -Dmds.library.path=/Users/homefolder/MassiveMDS/build -Dmds.required.flags=48 -Dmds.resource=3 -Dhph.library.path=/Users/homefolder/hawkes/build -Dhph.required.flags=16 -Dhph.resource=3 /Users/homefolder/beast-mcmc/build/dist/beast.jar  -seed 666 -overwrite /Users/homefolder/FluHawkes/xml/cv$d$k.xml

		Rscript --vanilla code/holdOutLogLik.R $d $k;
	done
done
