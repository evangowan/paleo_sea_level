#! /bin/bash

# it is assumed this script is run in the top scratch_datasets folder

# it takes the command line argument for the sector of interest
sl_sector=$1

# it creates a temporary folder if it does not exist

if [ -d "${sl_sector}" ]
then

mkdir -p ${sl_sector}/temp

python3 scripts/merge_ods.py ${sl_sector}

python3 scripts/merge_ods_extra.py ${sl_sector}

bash scripts/point_inside.sh ${sl_sector}

python3 scripts/move_to_database.py ${sl_sector}

else

echo "The folder ${sl_sector} does not exist"

fi
