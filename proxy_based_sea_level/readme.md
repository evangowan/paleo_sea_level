Proxy based sea level estimates
=============

Direct sea level indicators are exceedingly rare prior to about 20,000 years before present, with the exception of a few periods where sea level was higher than present (for example MIS 5e and 11 and the Pliocene). This is because sea level fluctuations due to the growth and retreat of ice sheets generally destroyed the indicators except in a few rare places where tectonic uplift rates are high enough to protect the deposits. 

As a result of this, plus the desire for having more continuous records of sea level, there have been a number of attempts to deduce sea level from ocean oxygen isotope proxy records. The oxygen isotope proxy records are measured based on the ratio of <sup>18</sup>O and <sup>16</sup>O. The lighter isotope of oxygen, <sup>16</sup>O, is preferentially taken out of the ocean when evaporated. As a result, when an ice sheet builds up, the amount of <sup>18</sup>O in the ocean increases. The oxygen isotope ratio in the ocean is generally measured from the fossils of tests (shells) of foraminifera extracted from sediment cores. Such records extend back to the K-Pg boundary (66 million years ago). The conversion of the ratio to "sea level" is not straightforward because the ratio of the isotopes in foraminifera is also dependent on the temperature and salinity of the water in which the foraminfera lived. In addition, it takes time for the ocean to become well mixed, so the oxygen isotope values in different ocean basins will reflect changes in ice volume at different times. The success in inferring sea level is dependent on correctly accounting for these factors by using other proxies (for instance, to correct for temperature) or through modelling.

For the past 5 million years, the standard nomenclature describing fluctuations in ocean oxygen proxies are known as Marine Isotope Stages (MIS). In this nomenclature, periods with relatively low values of <sup>18</sup>O/<sup>16</sup>O are odd numbered and represent warm periods with relatively smaller ice sheets, while high values of <sup>18</sup>O/<sup>16</sup>O represent cold periods with relatively large ice sheets. The standard for defining the MIS boundaries is the LR04 curve (Lisieki and Raymo, 2005), which used a stack of a number of benthic foraminifera proxy records from around the world using an orbitally tuned time scale.

One thing to be aware of is that not all of the proxy based sea level reconstructions represent the same thing. There are three ways of thinking about sea level:

- **Barystatic (or eustatic) sea level**: This is the global average sea level at any one point of time. As ice sheets grow, it takes less ice volume to cause sea level to drop, as the total area of the ocean shrinks. The change in the distribution of water mass also deforms the Earth, so the shape of the ocean basins and gravity change through time. This means that few places truly represent barystatic sea level and it usually must be calculated in a glacial isostatic adjustment model.
- **Ice volume sea level equivalent (SLE)**: This is the total volume of ice, above the floating point (when ice is grounded over places that are now the ocean), relative to present ice volume, divided by the modern ocean area.
- **Relative sea level**: This is the difference in elevation between some past sea level position relative to present sea level at a specific location. In areas far from the ice sheets, this will be relatively close to barystatic sea level.

When comparing different proxy records, it is important to understand that they may represent different sea level concepts. Most proxy reconstructions will represent something similar to ice volume sea level equivalent, but may have been scaled based on an assumed barystatic value at a specific time (such as the Last Glacial Maximum). This is an important distinction, because an SLE will always be less than barystatic sea level when ice volume was greater than present (and the opposite when it was less). Some reconstructions apply a nonlinear scaling is applied to account for the changes in ocean area, and the nonlinear relationship between the oxygen isotope ratio in the ice sheets as they grow (the ice sheet will become enriched in lighter <sup>16</sup>O as it gets larger due to lapse rate effects, for instance). In reality, such scaled records will not be exactly the same as barystatic sea level, but may be close enough for most applications.  Other records, like the Red Sea proxy record, represents relative sea level (in that case, the sea level at the Bab-el Mandeb strait). The relative sea level will diverge from the SLE, depending on glacial isostatic adjustment effects.

Data contained here
=============

I have included a number of records in order to make comparisons of various proxy records. The example scripts included here will extract this data and make plots in order to compare the records. Note that I do not claim this is a comprehensive database of proxy records, only a collection of records that I have personally looked at for the purposes of my own research.


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

This contains various estimate based on proxy or model estimates of sea level. I have put the data into the following tab delimited text file format, with uncertainties if available. Most records do not have age uncertainties attached, as it is assumed the vertical uncertainty incorporates the uncertainty in age as well. I note if the records have age uncertainties, otherwise assume there are no uncertainties. 2-sigma uncertainties are used in the files. If the record does not note whether the uncertainty is 1 or 2 sigma, I have assumed it was reported as 1 sigma.

Age (yr BP)|Sea Level (m)|age error (2-sigma)|sea level error (2-sigma)

<p></p>

| File Name | reference | description | age range |
| --- | --- | --- | --- |
| **Spratt_Lisiecki_2016_PCA1_long.txt** | Spratt and Lisiecki (2016) | principle component analysis of seven records | 0-798 kyr BP |
| **Spratt_Lisiecki_2016_PCA1_short.txt** | Spratt and Lisiecki (2016) | principle component analysis of five records | 0-430 kyr BP |
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
| **Rohling_etal_2022_synthesis_process_tuned.txt** | Rohling et al (2022) | Process model based on a systhesis of LR04 and Westerhold d18O syntheses -- tuned age model using median bootstrap sea level  |  0-5300 kyr BP |
| **Rohling_etal_2022_synthesis_process_alt.txt** | Rohling et al (2022) | Process model based on a systhesis of LR04 and Westerhold d18O syntheses -- alternative tuned age model using Westerhold 2020 data >792 kyr BP using median bootstrap sea level  |  0-5300 kyr BP |
| **Sosdian_Rosenthal_2009_North_Atlantic_benthic.txt** | Sosdian and Rosenthal (2009) | North Atlantic d18O record mostly from DSDP site 607, except for the late Pleistocene from piston core, Chain 82-24-23 | 10-3154 kyr BP |
| **Sosdian_Rosenthal_2009_North_Atlantic_benthic_3pt.txt** | Sosdian and Rosenthal (2009) | North Atlantic d18O record mostly from DSDP site 607, except for the late Pleistocene from piston core, Chain 82-24-23 - 3 point average | 10-3154 kyr BP |
| **Miller_etal_2020_Pacific_benthic_d180.txt** | Miller et al (2020) | Pacific benthic d18O splice corrected for temperature using Mg/Ca | 0-66611 kyr BP |
| **Miller_etal_2020_Pacific_benthic_d180_smooth.txt** | Miller et al (2020) | Pacific benthic d18O splice corrected for temperature using Mg/Ca, 2 Ma smoothing | 980-64820 kyr BP |
| **Bates_et_al_2014_benthic_d18O_composite.txt** | Bates et al (2014) | Benthic d18O composite of east equitorial Pacific cores from Shackleton et al 1990 | 0-6137 kyr BP |
| **Bates_et_al_2014_benthic_d18O_94-607.txt** | Bates et al (2014) | Benthic d18O from  DSDP site 94-607 | 0-3262 kyr BP |
| **Bates_et_al_2014_benthic_d18O_108-659.txt** | Bates et al (2014) | Benthic d18O from ODP site 108-659  | 2-4951 kyr BP |
| **Bates_et_al_2014_benthic_d18O_121-758.txt** | Bates et al (2014) | Benthic d18O from ODP site 121-758 | 0-3575 kyr BP |
| **Bates_et_al_2014_benthic_d18O_138-849.txt** | Bates et al (2014) | Benthic d18O from ODP site 138-849 | 4-4978 kyr BP |
| **Bates_et_al_2014_benthic_d18O_162-980.txt** | Bates et al (2014) | Benthic d18O from ODP composite site 162-980/981 | 1-3912 kyr BP |
| **Bates_et_al_2014_benthic_d18O_177-1090.txt** | Bates et al (2014) | Benthic d18O from ODP site 177-1090 | 3-2720 kyr BP |
| **Bates_et_al_2014_benthic_d18O_181-1123.txt** | Bates et al (2014) | Benthic d18O from ODP site 181-1123 | 7-1546 kyr BP |
| **Bates_et_al_2014_benthic_d18O_184-1143.txt** | Bates et al (2014) | Benthic d18O from ODP site 184-1143 | 0-5021 kyr BP |
| **Bates_et_al_2014_benthic_d18O_184-1148.txt** | Bates et al (2014) | Benthic d18O from ODP site 184-1148 | 0-23103 kyr BP |

18O
==============

This contains time series of δ<sup>18</sup>O records. As with the sea level records, I have have included 2-sigma uncertainty ranges. If an age uncertainty is given, I have noted it in the table below, otherwise there are no age uncertainties in the files. The file format is tab delimited as below:

Age (yr BP)|δ<sup>18</sup>O (‰)|age error (2-sigma)|δ<sup>18</sup>O error (2-sigma)

<p></p>

| File Name | reference | description | age range |
| --- | --- | --- | --- |
| **lr04.txt** | Lisiecki and Raymo (2004) | Stack of 57 benthic foraminifera δ<sup>18</sup>O records, with an orbitally tuned age model | 0-5300 kyr BP |
| **Westerhold_etal_2020_d18O_VPDB_CorrAdjusted.txt** | Westerhold et al (2020) | Cenozoic splice of benthic foraminifera δ<sup>18</sup>O records using a +0.45 ‰ to correct for the difference between Pacific and Atlantic basins. Note there are no uncertainties. | 0-67100 kyr BP |
| **Westerhold_etal_2020_d18O_smoothLoess10.txt** | Westerhold et al (2020) | Cenozoic splice of benthic foraminifera δ<sup>18</sup>O records using 10 point LOESS smoothing. Note there are no uncertainties. | 0-67100 kyr BP |

CO2
==============

This contains time series of CO<sub>2</sub> records. As with the sea level records, I have have included 2-sigma uncertainty ranges. If an age uncertainty is given, I have noted it in the table below, otherwise there are no age uncertainties in the files. The file format is tab delimited as below:

Age (yr BP)|CO<sub>2</sub> (PPM)|age error (2-sigma)|CO<sub>2</sub> error (2-sigma)

<p></p>

| File Name | reference | description | age range |
| --- | --- | --- | --- |
| **Bereiter_etal_2015_Antarctica_Composite.txt** | Bereiter et al (2015) | Composite CO<sub>2</sub> measured from Antarctica ice cores | 0-805 kyr BP |


insolation
==============

This folder contains some insolation curves generated by the methods by Laskar et al (2004). These were taken from the website: [https://vo.imcce.fr/insola/earth/online/earth/online/index.php](https://vo.imcce.fr/insola/earth/online/earth/online/index.php). The file format is as below:

Age (yr BP)|Insolation (W/m<sup>2</sup>)|

| File Name | reference | description | age range |
| --- | --- | --- | --- |
| **65N_June_21.txt** | Laskar et al (2004) | Insolation, mean daily insolation / mean longitude, latitude on the Earth - 65N, true/mean longitude - 90 (June 21) | 0-5000 kyr BP |
