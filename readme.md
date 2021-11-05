Paleo-sea level plotting and report generator
=============

by:  
Evan James Gowan  
<evangowan@gmail.com>

Acknowledgements
-------------

This project was made possible through the wide efforts of the paleo sea level community, through the PALSEA group. Much of the data here was compiled by the HOLSEA project. Please see the following websites for details.

[PALSEA Website](https://palseagroup.weebly.com/ "PALSEA")

[HOLSEA website](https://www.holsea.org/ "HOLSEA")

E.J.G. is funded by Helmholtz Exzellenznetzwerks "The Polar System and its Effects on the Ocean Floor (POSY)" and Helmholtz Climate Initiative REKLIM (Regional Climate Change), a joint research project at the Helmholtz Association of German research centres (HGF). Funding is also supported by the PACES-II program at the Alfred Wegener Institute and the Bundesministerium für Bildung und Forschung funded project, PalMod. Earlier work was funded from an Australian National University Postgraduate Research Scholarship.

If you use this script setup, please acknowlege using the following references.

Gowan, E.J., Zhang, X., Khosravi, S., Rovere, A., Stocchi, P., Hughes, A.L.C., Gyllencreutz, R., Mangerud, J., Svendsen, J.-I., and Lohmann, G., 2021. A new global ice sheet reconstruction for the past 80000 years. Nature Communications, 12, 1199. https://doi.org/10.1038/s41467-021-21469-w

Gowan, E.J., Tregoning, P., Purcell, A., Montillet, J.P. and McClusky, S., 2016. A model of the western Laurentide Ice Sheet, using observations of glacial isostatic adjustment. Quaternary Science Reviews, 139, pp.1-16.

Special thanks:

- Alisa V. Baranskaya for sending me the complete references for the Russian sea level database, including translations.
- Simon Engelhart for sending me the reservoir corrections for the eastern United States database.

Version history
-------------

- **Version 1.1**: Added some new LGM sites (including alternate Bonaparte Gulf interpretations), and modified some of the LGM and MIS 3 sites that I original set to have marine limiting points (due to large uncertainties) to have the originally interpreted sea level index ranges. (November 5, 2021)
- **Version 1.0**: initial release (February 23, 2021)

Usage
-------------

In this project, there are a series of scripts and programs to plot published paleo-sea level data and calculated sea level, and create a report that shows the results. To run these scripts, it is assumed that you have compiled the Fortran programs in the "Fortran/" directory. The scripts require the following:

- bash shell
- latex (specifically Xelatex, so non-Latin text can be implemented easier)
- a fortran compiler (i.e. gfortran)
- [Generic Mapping Tools](https://www.generic-mapping-tools.org/ "GMT"), version 5 or 6.
- Perl (used to parse the radiocarbon calibration javascript file from Oxcal)

I made these scripts in Ubuntu, and I do not guarantee it will work in other operating systems.

The bibtex database is maintained using JabRef.

Radiocarbon calibration
------------------

To do radiocarbon calibration, I use Oxcal. Put the unzip file of the Oxcal distribution in the "calibrate/" folder (it should create an Oxcal directory). The scripts will know to look there. Although I have included the files with calibrated data, new versions of the calibration curves, and possibly new reservoir ages will require that the radiocarbon dates need to be re-calibrated.

[Oxcal website](https://c14.arch.ox.ac.uk/oxcal.html "Oxcal")

If you want to recalibrate everything, it should be as simple as running the "run_all.sh" script. It will go through all the locations in the "regions" directory. If you want to calibrate a single location, you can use the "run_one.sh" script. You can also just use the "calibrate.sh" script with the region and location as command line options.


