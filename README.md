# m_script contains the Matlab routine
# WLS Lidar CNR data treatment (statistical approach)
# method: inversion of a single scattering lidar equation
# result: extinction coefficient (alpha) and the overlap function F(R) for each PPI file
# author: Maksimovich Elena
# date: 29 september 2015
# additional documentation is available on ?????


# my_data.m is the file where you should define the parameters of your own data set
# here we give you an example of a data set, so that you can test the code

# we use :

# (1) wls_PPI_loop_1.m  
# for each directory and each PPI file (360 degree horizontal scan, azimuthal speed 1 deg/sec)
# find the closest in time RHI file
# apply my RHI (North-South) symmetry test
# at this step we filter the presumingly well-mixed boundary layer conditions (in the lowest 300m)
# evaluate statistics within given PPI : over each scanning distance (skewness, inter-quartile range ... )


# wls_sub_RHI_1.m % upload RHI data
# wls_sub_PPI_1.m % upload PPI data

# instrum_function.m
# calculate statistics of CNR for each PPI, each scanning distance
# skewness, kurtosis, average, inter-quartile range, maximum likly-hood estimator (peak of PDF), std, 3 normal distribution tests




# result.m
# compare statistics between different PPI
# chose those PPI with the most narrow distribution
# find the distances where exp(delta(CNR))) == max
# evaluate "alpha" within these distances
# deduce "alpha" from CNR, to abtain F(R) x K x beta for given PPI

# best_PPI.m
# evaluate CNR statistics at each scanning distance R  

# instrum_function.m
# instrum_function2.m
# instrum_function3.m
# multi-angle_method_Pabs_vs_cosTeta.m
# wls_sub_DBE_1.m
# wls_sub_DBE_E.m
