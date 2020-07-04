#!/usr/bin/env python

import pandas as pd
from argparse import ArgumentParser
from statsmodels.formula.api import ols
import math

# Function to compute effect sizes
# Based on method in Nakagawa, S. and I.C. Cuthill. (2007). Biol. Rev. 82. pp. 591-605.
def cohensd(t, df, n1, n2):
        d = ( t * (n1+n2) ) / (math.sqrt(n1*n2) * math.sqrt(df))
        se = math.sqrt( ((n1+n2-1)/(n1+n2-3)) * ( (4/(n1+n2)) * (1 + (d**2)/8) ))
        return {'d': d, 'se': se, 'lower_ci': d-1.96*se, 'upper_ci': d+1.96*se}

def main():
    print("Fitting models...")

    # Parse command line arguments
    description = "Data harmonization mini-pipeline for Brainhack School 2020, stage 3. Reads harmonzied data, fits models."
    parser = ArgumentParser(__file__, description)
    parser.add_argument("harmonized_data", action="store",
                        help = "Path to harmonized data .csv file. File must include columns noted in documentation.")
    parser.add_argument("unharmonized_data", action="store",
                        help = "Path to unharmonized data .csv file. File must include columns noted in documentation.")
    parser.add_argument("X",  action = "store", help = "Name of column for regressor of interest.")
    parser.add_argument("X_control_level", action = 'store', help = "Level of X to be considered control")
    parser.add_argument("covars", action = "store", help = "Comma-separated column names of covariates.")
    parser.add_argument("site", action = "store", help = "Column name for site variable (used for models on non-harmonized data).")
    parser.add_argument("output_file", action="store", help = "Name of file to to output the effect size measures.")
    cl_args = parser.parse_args()

    # Extract covariate columns from input arguments
    covars = cl_args.covars.split(',')

    X = cl_args.X
    site = cl_args.site
    output_file = cl_args.output_file
    X_control_level = cl_args.X_control_level

    print("... X: ", X)
    print("... covars: ", covars)
    print("... site: ", site)

    # Read harmonized data
    harmonized_features   = pd.read_csv(cl_args.harmonized_data, index_col=0)
    unharmonized_data = pd.read_csv(cl_args.unharmonized_data, index_col=0)

    # TODO: fix for loop hard-coded -5!!!
    features = harmonized_features.columns[:-5]

    # ----------- Model 1: Linear regression on harmonized data -----------
    models = pd.Series(dtype='object')
    model_es = []

    covar_string = ' + '.join(covars)

    for nucleus in features:        # Don't include last (covariate) columns
        formula_string = nucleus + ' ~ ' + X + ' + ' + covar_string
        models[nucleus] = ols(formula = formula_string, data = harmonized_features).fit()
        
        # Get effect size, being sure to drop rows with NA for age.
        n_control = sum(harmonized_features[X] == X_control_level)
        n_ASD = models[nucleus].nobs - n_control
        model_es.append(cohensd(t  = models[nucleus].tvalues[X+'[T.Control]'], 
                                df = models[nucleus].df_resid, 
                                n1 = n_control,
                                n2 = n_ASD))

    # Create lists to collect temporary output file names, and output this batch of effect sizes.
    combat_es = pd.DataFrame(model_es, index=features)
    combat_es_filename = "int_es_combat.csv"
    es_filenames = [combat_es_filename]
    es_names = ["Combat"]
    combat_es.to_csv(combat_es_filename)

    # ----------- Model 2: Linear regression on unharmonized data -----------
    models_unh = pd.Series(dtype='object')
    model_unh_es = []

    for nucleus in features:
        formula_string = nucleus + ' ~ ' + X + ' + ' + covar_string + ' + ' + site   # Unharmonized: Include site as covariate 
        models_unh[nucleus] = ols(formula = formula_string, data = unharmonized_data).fit()
                
        # Get effect size, being sure to drop rows with NA for age.
        n_control = sum(unharmonized_data[X] == X_control_level)
        n_ASD = models_unh[nucleus].nobs - n_control
        model_unh_es.append(cohensd(t  = models_unh[nucleus].tvalues['DX[T.Control]'], 
                                df = models_unh[nucleus].df_resid, 
                                n1 = n_control,
                                n2 = n_ASD))

    # Add filenames to list, and output effect size data.
    unh_es = pd.DataFrame(model_unh_es, index=features)
    unh_es_filename = "int_es_unh.csv"
    es_filenames.append(unh_es_filename)
    es_names.append("Unharmonized")
    unh_es.to_csv(unh_es_filename)

    # ----------- Model 3: Linear mixed models on unharmonized data -----------
    








    # Write out files containing output file names and type of data
    pd.DataFrame(es_filenames).to_csv("es_filenames.csv", index=False, header=False)
    pd.DataFrame(es_names).to_csv("es_names.csv", index=False, header=False)


    print('... Model fitting and effect size calculations complete')

if __name__ == '__main__':
    main()


# Potential todos:
# - Move the model generation code to a function.
# - Collect summaries of the model parameters and output. That would be helpful.
# - Add in some basic visualizations that the code could generate, beyond the forest plots.
