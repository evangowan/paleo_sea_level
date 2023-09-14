Proxy based sea level estimates
=============

Direct sea level indicators are exceedingly rare prior to about 20,000 years before present, with the exception of a few periods where sea level was higher than present (for example MIS 5e and 11 and the Pliocene). This is because sea level fluctuations due to the growth and retreat of ice sheets generally destroyed the indicators except in a few rare places where tectonic uplift rates exceed about 1.8 m/kyr. 

As a result of this, plus the desire for having more continuous records of sea level, there have been a number of attempts to deduce sea level from ocean oxygen isotope proxy records. The oxygen isotopes are generally measured based on the ratio of <sup>18</sup>O and <sup>16</sup>O. The lighter isotope of oxygen, <sup>16</sup>O, is preferentially taken out of the ocean when evaporated. As a result, when an ice sheet builds up, the amount of <sup>18</sup>O in the ocean increases. The oxygen isotope ratio in the ocean is generally measured from the fossils of tests (shells) of foraminifera extracted from sediment cores. Such records extend back to the K-Pg boundary (66 million years ago). The conversion of the ratio to "sea level" is not straight forward because the ratio of the isotopes in foraminifera is also dependent on the temperature and salinity of the water in which the foraminfera lived. The success in infering sea level is dependent on correctly accounting for these factors using other proxies.

For the past 5 million years, the standard nomenclature describing fluctuations in ocean oxygen proxies are known as Marine Isotope Stages (MIS). In this nomenclature, periods with realtively low values of <sup>18</sup>O/<sup>16</sup>O are odd numbered and represent warm periods with relatively smaller ice sheets, while high values of <sup>18</sup>O/<sup>16</sup>O represent cold periods with realtively large ice sheets. The standard for defining the MIS boundaries is the LR04 curve (Lisieki and Raymo, 2005), which used a stack of a number of benthic foraminifera proxy records from around the world using an orbitally tuned time scale.

One thing to be aware of is that not all of the proxy based sea level reconstructions represent the same thing. There are three ways of thinking about sea level:

- **Barystatic (or eustatic) sea level**: This is the global average sea level at any one point of time. As ice sheets grow, it takes less ice volume to cause sea level to drop, as the total are of the ocean shrinks.
- **Ice volume sea level equivalent (SLE)**: This is the total volume of ice, above the floating point (when ice is grounded over places that are now the ocean), relative to present ice volume, divided by the modern ocean area.
- **Relative sea level**: This is the difference in elevation between some past sea level position relative to present sea level. In areas far from the ice sheets, this will be relatively close to barystatic sea level.

When comparing different proxy records, it is important to understand that they may represent different sea level concepts. Most proxy records will represent something similar to ice volume sea level equivalent, but have been scaled based on an assumed value at a specific time (such as the Last Glacial Maximum). This is an important distinction, because an SLE will always be less than barystatic sea level when ice volume was greater than present (and the opposite when it was less).  Other records, like the Red Sea proxy record, represents relative sea level (in that case, the sea level at the Bab-el Mandeb strait). The relative sea level will diverge from the SLE, depending on glacial isostatic adjustment effects.

Data contained here
=============

I have included a number of records in order to make comparisons of various proxy records. The scripts included here will extract this data and make plots in order to compare the records.


Age boundaries
==============

Marine isotope stages are the standard way to delimit the age of Quaternary and Pliocene events. However, for flexibility, I have also included other potential age scales.

The format of these files, in a space delimited text file is:

start of interval|end of interval|interval name (text format)

The ages are in years before present.

- **lr04_MIS.txt** MIS stages based on the definitions by LRO4 (Lisiecki and Raymo, 2005)
- **ics_periods.txt** International Commission on Stratigraphy defined geological periods
- **ics_series.txt** International Commission on Stratigraphy defined geological series
- **ics_stages.txt** International Commission on Stratigraphy defined geological stages
