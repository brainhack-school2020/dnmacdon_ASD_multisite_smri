#!/usr/bin/env python

import pandas as pd
from argparse import ArgumentParser

def main():
    print("Masking...")

    # Parse command line arguments
    description = "Data harmonization mini-pipeline for Brainhack School 2020, first stage. Reads data, performs QC masking, outputs."
    parser = ArgumentParser(__file__, description)
    parser.add_argument("raw_data", action="store",
                        help = "Path to raw data .csv file. File must include columns noted in documentation.")
    parser.add_argument("qc_mask",  action = "store", help = "Column names of QC columns, used to mask feature columns.")
    parser.add_argument("qc_threshold", action = "store", 
                        help = "Maximum value for failed QC, features with this value and below for QC will be masked.")
    parser.add_argument("output_file", action="store", help = "Name of file to to output the masked values.")
    parser.add_argument("feature_file", action="store", help = "Name of file to which feature column names will be written.")
    cl_args = parser.parse_args()

    # Extract mask columns and threshold from input arguments
    qc_mask  = cl_args.qc_mask.split(',')
    qc_threshold = float(cl_args.qc_threshold)

    print("... masking based on", qc_mask)

    # Read raw data
    data = pd.read_csv(cl_args.raw_data, index_col=0)

    # Age is missing in some rows, but is needed for modelling. Drop those rows
    #  NOTE, TODO: Ideally we should be controlling this from the command line. ***
    complete_rows = data['Age'].notna()
    NA_rows = ~complete_rows
    data = data[complete_rows]
    print('... removing {} rows due to missing Age'.format(sum(NA_rows)))

    # Mask features that failed QC
    # Build up the data feature names from QC names. We do it this way to ensure that the mask columns are properly aligned
    # with the feature columns. If both were specified on the command line, the user could misalign them and the error would
    # be difficult to catch.
    # Make sure to specify this in the documentation!
    features = [QCc + '_vol' for QCc in qc_mask]
    QC_failed = data[qc_mask] <= 0.5
    data[features] = data[features].mask(QC_failed.values)

    # Write out data with failed structures masked
    data.to_csv(cl_args.output_file)

    # Write out feature names for later steps in the pipeline
    pd.DataFrame(features).to_csv(cl_args.feature_file, index=False, header=False, sep='\n')

    print('... Masking complete')

if __name__ == '__main__':
    main()

