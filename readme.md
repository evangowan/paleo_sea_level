Paleo-sea level plotting and report generator
=============

by:  
Evan James Gowan  
<evangowan@gmail.com>

Introduction
-------------

My research since around 2010 has focused on reconstructing ice sheets using glacial isostatic adjustment (GIA) methods. One of the primary observations of GIA is changes in sea level. During a glaciation, sea level in some areas can drop as low as -130 m below present sea level! Due to factors such as the deformation of the Earth due to shifting water/ice loads, gravitational field changes due to the redistribution of mass, and changes to the Earth's rotation, the magnitude of sea level change is spatially variable. Using this information, it is possible to infer the size of the ice sheets.

When I started doing GIA modelling, there was no publicly available repository of sea level data that could be easily used for analysis. As a result, it was necessary to create something. During my PHD in 2013/2014, I created a bunch of scripts to compare sea level data from western Canada with an ice sheet reconstruction I made. This was done in a very chaotic and disorganized way, which was fine for when I was looking at a small area. In 2018-2020, I started working on a global reconstruction, and the demands for me to "show my work" in a model-data comparison forced me to create a more organized structure. This led me to create scripts to create reports that contain these plots.

This was still done in a very tedious way. In 2022, I decided to rewrite the plotting scripts. This allowed me to move away from the clumsy Fortran files I created in my PHD. The updates significantly reduced the time it takes to add data, as I no longer had to manually set up the plot map, nor do I have to create separate folders for different time periods. 

Acknowledgements
-------------

This project was made possible through the wide efforts of the paleo sea level community, through the PALSEA group. Much of the data here was compiled by the HOLSEA project. Please see the following websites for details.

[PALSEA Website](https://palseagroup.weebly.com/ "PALSEA")

[HOLSEA website](https://www.holsea.org/ "HOLSEA")

E.J.G acknowledges the following funding sources that made all this possible:

- Japan Society for the Promotion of Science International Postdoctoral Fellowship (2021-2023)
- Helmholtz Exzellenznetzwerks "The Polar System and its Effects on the Ocean Floor (POSY)" (2018-2020)
- Helmholtz Climate Initiative REKLIM (Regional Climate Change), a joint research project at the Helmholtz Association of German research centres (HGF) (2016-2018)
- the PACES-II program at the Alfred Wegener Institute (2016-2021)
- Bundesministerium für Bildung und Forschung funded project, PalMod (2016-2021)
- Swedish Research Council FORMAS grant (grant 2013-1600) (2014-2015)
- Australian National University Postgraduate Research Scholarship. (2010-2014)

If you use this script setup, please acknowlege using the following references.

Gowan, E.J., Zhang, X., Khosravi, S., Rovere, A., Stocchi, P., Hughes, A.L., Gyllencreutz, R., Mangerud, J., Svendsen, J.I. and Lohmann, G., 2022. Reply to: Towards solving the missing ice problem and the importance of rigorous model data comparisons. Nature communications, 13(1), pp.1-5. https://doi.org/10.1038/s41467-022-33954-x

Gowan, E.J., Zhang, X., Khosravi, S., Rovere, A., Stocchi, P., Hughes, A.L.C., Gyllencreutz, R., Mangerud, J., Svendsen, J.-I., and Lohmann, G., 2021. A new global ice sheet reconstruction for the past 80000 years. Nature Communications, 12, 1199. https://doi.org/10.1038/s41467-021-21469-w

Gowan, E.J., Tregoning, P., Purcell, A., Montillet, J.P. and McClusky, S., 2016. A model of the western Laurentide Ice Sheet, using observations of glacial isostatic adjustment. Quaternary Science Reviews, 139, pp.1-16. https://doi.org/10.1016/j.quascirev.2016.03.003

Special thanks:

- Alisa V. Baranskaya for sending me the complete references for the Russian sea level database, including translations.
- Simon Engelhart for sending me the reservoir corrections for the eastern United States database.
- Annemiek Vink and Juliane Scheder for sending me the spreadsheets with North Sea data.

Version history
-------------

- **Version 1.3**: Added Antarctica data for the Holocene and MIS 3, improved the presentation of index points on the plots, added the ability to calibrate mixed dates and terrestrial reservoir corrections, and improved documentation. (July 4, 2022)
- **Version 1.2**: Updated the database with an update of the Baltic Sea dataset, and added sites from the North Sea. (March 15, 2022)
- **Version 1.1**: Added some new LGM sites (including alternate Bonaparte Gulf interpretations), and modified some of the LGM and MIS 3 sites that I original set to have marine limiting points (due to large uncertainties) to have the originally interpreted sea level index ranges. (November 5, 2021)
- **Version 1.0**: initial release (February 23, 2021)

Usage
-------------

In this project, there are a series of scripts and programs to plot published paleo-sea level data and calculated sea level, and create a report that shows the results. The scripts require the following:

- bash shell
- latex (specifically Xelatex, so non-Latin text can be implemented easier)
- Python 3, with pandas, numpy, pandas\_ods\_reader and odfpy packages installed
- [Generic Mapping Tools](https://www.generic-mapping-tools.org/ "GMT"), version 6.3 or later.
- Perl (used to parse the radiocarbon calibration javascript file from Oxcal)

I made these scripts in Ubuntu, and I do not guarantee it will work in other operating systems.

The bibtex database is maintained using JabRef.


An example of the workflow in the latex folder to create the report:

- place the calculated sea level in the "paleo\_sea\_level" folder (see instructions on the format in the readme file)
- edit the "create\_plots.sh" file with the ice sheet/earth model combinations that you want to plot (six models can be plotted)
- run create\_plots.sh
- run create\_report.sh


Radiocarbon calibration
------------------

To do radiocarbon calibration, I use Oxcal. Put the unzip file of the Oxcal distribution in the "calibrate/" folder (it should create an Oxcal directory). The scripts will know to look there. Although I have included the files with calibrated data, new versions of the calibration curves, and possibly new reservoir ages will require that the radiocarbon dates need to be re-calibrated.

[Oxcal website](https://c14.arch.ox.ac.uk/oxcal.html "Oxcal")

If you want to recalibrate everything, it should be as simple as running the "run\_all.sh" script. It will go through all the locations in the "regions" directory. If you want to calibrate a single location, you can use the "run\_one.sh" script. You can also just use the "calibrate.sh" script with the region and location as command line options.

The calibrated radiocarbon dates are recorded with 2-sigma uncertainties. In order to make the comparisons the same, the calibration script also takes other dates (which are recorded with 1-sigma uncertainties in the database) and converts them to use 2-sigma limits. All of the "calibrated.txt" dates have 2-sigma uncertainty ranges.

Coastlines and borders
------------------

The GIS folder contains global coastlines and borders from GSHHG, which is licensed under GNU Lesser General Public License version 3.

Wessel, P. and Smith, W.H., 1996. A global, self‐consistent, hierarchical, high‐resolution shoreline database. Journal of Geophysical Research: Solid Earth, 101(B4), pp.8741-8743. https://doi.org/10.1029/96JB00104


