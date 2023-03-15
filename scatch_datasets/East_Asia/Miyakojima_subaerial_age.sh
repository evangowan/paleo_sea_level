#! /bin/bash


curve_marine="Marine20"
marine="marine20.14c"

correction_amount="-256"
correction_error="40"

cal_line="Curve(\"${curve_marine}\",\"../bin/${marine}\");"

delta_r="Delta_R(\"correction\", ${correction_amount}, ${correction_error});"


cat << END_CAT > run.oxcal
 Plot()
 {
  sequence("E1")
  {



      boundary("base");
      phase("p1")
      {
        $cal_line
        ${delta_r}
        R_Date("NZA6207", 19800, 300);
        C_Date("TMW-04", -20180, 315);
      };

      boundary("middle1");
      {
        date("hiatus");
      };


      boundary("middle2");

      phase("p2")
      {
        $cal_line
        ${delta_r}
        R_Date("NZA6205", 13340, 200);
        C_Date("TMW-01", -14170, 270);

      };
      boundary("top");

  };

 };
END_CAT


../../../calibrate/OxCal/bin/OxCalLinux run.oxcal
	
perl ../../../calibrate/parse_javascript.pl run.js

./../../../Fortran/radiocarbon_statistics hiatus.posterior > age.txt
