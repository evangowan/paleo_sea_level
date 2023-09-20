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

The format of these files, in a tab delimited text file is:

start of interval|end of interval|interval name (text format)

The ages are in years before present.

- **lr04_MIS.txt** MIS stages based on the definitions by LRO4 (Lisiecki and Raymo, 2005)
- **ics_periods.txt** International Commission on Stratigraphy defined geological periods
- **ics_series.txt** International Commission on Stratigraphy defined geological series
- **ics_stages.txt** International Commission on Stratigraphy defined geological stages

Sea Level
==============

This contains various estimate based on proxy or model estimates of sea level. I have put the data into the following tab delimited text file, with uncertainties if available. Most records do not have age uncertainties attached, as it is assumed the vertical uncertainty incorporates the uncertainty in age as well. I note if the records have age uncertainties, otherwise assume there are no uncertainties. 2-sigma uncertainties are used.

Age (yr BP)|Sea Level (m)|age error|sea level error

Note that these records are not necessarily measuring the same thing. Some foraminifera records will be a measure of "sea level equivalent", where the water volume is expressed as the total infered ice volume divided by the area of the modern ocean. The Red Sea record is a relative sea level record, pinned to the shallowest point of the Red Sea at the Hanish Sill.


| File Name | reference | description | age range |
| --- | --- | --- | --- |
| **Spratt_Lisiecki_2016_PCA1_long.txt** | Spratt and Liseiki (2016) | principle component analysis of five records | 0-798 kyr BP |
| **Spratt_Lisiecki_2016_PCA1_short.txt** | Spratt and Liseiki (2016) | principle component analysis of seven records | 0-430 kyr BP |
| **Grant_etal_2014_Red_Sea_composite_data.txt** | Grant et al (2014) | Red Sea d18O proxy record, data from three cores and multiple sources | 0-493 kyr BP |
| **Grant_etal_2014_Red_Sea_probabilistic.txt** | Grant et al (2014) | Red Sea d18O probabilistic assessment | 0-492 kyr BP |
| **Waelbroeck_etal_2002_d18O.txt** | Waelbroeck et al (2002) | transfer function of d18O benthic foraminifera from an Atlantic and a Pacific core |  0-430 kyr BP |
| **Shakum_etal_2015_planktic_d18O.txt** | Shakum et al (2015) | planktic formaminfera stack based sea level reconstruction |  0-798 kyr BP |
| **Bintanja_etal_2005_model.txt** | Bintanja et al (2005) | ice sheet model based sea level estimate with LR04 |  0-1069.9 kyr BP |
| **Elderfield_etal_2012_ODP1123_Pacific_benthic.txt** | Elderfield et al (2012) | transfer function of benthic d18O to sea level from core ODP 1123 Chatham Rise near New Zealand |  7-1575 kyr BP |
| **Rohling_etal_2014_Mediterranean.txt** | Rohling et al (2014) | Mediterranean d18O stack with sapropels removed (this is a GMT formatted file to separate those intervals) |  0-5330 kyr BP |
| **Rohling_etal_2022_Westerhold_process_original.txt** | Rohling et al (2022) | Process model based on Westerhold et al (2020) d18O synthesis -- original age model using median bootstrap sea level  |  0-40195 kyr BP |
| **Rohling_etal_2022_Westerhold_process_tuned.txt** | Rohling et al (2022) | Process model based on Westerhold et al (2020) d18O synthesis -- tuned age model using median bootstrap sea level  |  0-40195 kyr BP |
| **Rohling_etal_2022_Westerhold_process_alt.txt** | Rohling et al (2022) | Process model based on Westerhold et al (2020) d18O synthesis -- alternative tuned age model using Westerhold 2020 data >792 kyr BP using median bootstrap sea level  |  0-40195 kyr BP |
| **Rohling_etal_2022_LR04_process_original.txt** | Rohling et al (2022) | Process model based on LR04 d18O synthesis -- original age model using median bootstrap sea level  |  0-5300 kyr BP |
| **Rohling_etal_2022_LR04_process_tuned.txt** | Rohling et al (2022) | Process model based on LR04 d18O synthesis -- tuned age model using median bootstrap sea level  |  0-5300 kyr BP |
| **Rohling_etal_2022_LR04_process_alt.txt** | Rohling et al (2022) | Process model based on LR04 d18O synthesis -- alternative tuned age model using Westerhold 2020 data >792 kyr BP using median bootstrap sea level  |  0-5300 kyr BP | 
| **Rohling_etal_2022_sythesis_process_tuned.txt** | Rohling et al (2022) | Process model based on a systhesis of LR04 and Westerhold d18O syntheses -- tuned age model using median bootstrap sea level  |  0-5300 kyr BP |
| **Rohling_etal_2022_sythesis_process_alt.txt** | Rohling et al (2022) | Process model based on a systhesis of LR04 and Westerhold d18O syntheses -- alternative tuned age model using Westerhold 2020 data >792 kyr BP using median bootstrap sea level  |  0-5300 kyr BP |
| **Sosdian_Rosenthal_2009_North_Atlantic_benthic.txt** | Sosdian and Rosenthal (2009) | North Atlantic d18O record mostly from DSDP site 607, except for the late Pleistocene from piston core, Chain 82-24-23 | 10-3154 kyr BP |
| **Sosdian_Rosenthal_2009_North_Atlantic_benthic_3pt.txt** | Sosdian and Rosenthal (2009) | North Atlantic d18O record mostly from DSDP site 607, except for the late Pleistocene from piston core, Chain 82-24-23 - 3 point average | 10-3154 kyr BP |