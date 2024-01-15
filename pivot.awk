################################################################################
#
# This script will take 3 columns of input and pivot. The implementation here
# assumes:
#
# Column 1 - Represents some independent value (like time) that is used to group
# Column 2 - Represents some value to pivot around
# Column 3 - Represents the actual y-axis value
#
################################################################################

BEGIN {
    sampleCount = 0;
    pivotCount = 0;
}

{
    if(!($1 in sampleIdx)) {
        sampleIdx[$1] = sampleCount;
        sampleData[sampleCount] = $1;
        sampleCount = sampleCount + 1;
    }
    if(!($2 in pivotIdx)) {
        pivotIdx[$2] = pivotCount;
        pivotData[pivotCount] = $2;
        pivotCount = pivotCount + 1;
    }
    rawData[sampleIdx[$1]][pivotIdx[$2]] = $3;
}

END {
    result="-"
    for (j = 0; j < pivotCount; j++) {
        result=result "\t" pivotData[j];
    }
    printf "%s\n", result;

    for (i = 0; i < sampleCount; i++) {
        printf "%d\t", sampleData[i];

        result=rawData[i][0];
        for (j = 1; j < pivotCount; j++) {
            result=result "\t" rawData[i][j];
        }
        printf "%s\n", result;
    }
}
