%%% mother scripts are : 'result_instr_func_allbestPPI.m' and 'result_P.m'
%%% statistics were calculated with : instrum_function.m
%%% see Aa_my_WLS100_inversion_procedure.m to understand the order of the
%%% procedure in matlab 

list = dir(['/media/Transcend/Elena_ULCO/my_matlab_data/CNR_stats*']);  
bn = 2000; % arbitrary length of each ij directory

CFA = NaN([length(rep)-2 max(bn) sdi]); CTA = CFA; SKA = CFA; RANA = CFA; RANGA = CFA; LIKA = CFA; KTA = CFA; JBA = CFA; KRA = CFA;
%%% spatial resolution was changed for ij = 21 and afterwards

for ij = 3 : length(rep) % file counter, where each file corresponds to some directory containing many PPI files
        clear CF CT SK RAN RANG LIK KT JB S U V KR peak_alpha a1 a2       
        a1 = exist(['/media/Transcend/Elena_ULCO/my_matlab_data/CNR_stats_std_range_maxliklihood_ktest_allPPI_' num2str(ij-2) '.mat']) == 2;
        a2 = exist(['/media/Transcend/Elena_ULCO/my_matlab_data/CNR_stats_std_range_maxliklihood_ktest_allPPI_0' num2str(ij-2) '.mat']) == 2;
        
        if a1 == 0 & a2 == 0
                continue
        elseif a1 == 1
                load(['/media/Transcend/Elena_ULCO/my_matlab_data/CNR_stats_std_range_maxliklihood_ktest_allPPI_' num2str(ij-2) '.mat']);  
        elseif a2 == 1
                load(['/media/Transcend/Elena_ULCO/my_matlab_data/CNR_stats_std_range_maxliklihood_ktest_allPPI_0' num2str(ij-2) '.mat']);      
        end
        RANGA(ij,1:size(CF,1),1:size(CF,2)) = RANG ; % interquartile range
        SKA(ij,1:size(CF,1),1:size(CF,2)) = SK ; % skewness  if the distribution is inclinated 
end

RANGA(find(RANGA == 0 )) = NaN; % range can't be zero!
SKA(find(RANGA == 0 )) = NaN;

for d = 1 : sdi % at each scanning distance R
        S(1,d) = nanmean(reshape(SKA(:,:,d),[size(RANA,1)*size(RANA,2) 1])); % typical skewness 
        S(2,d) = S(1,d) + nanstd(reshape(SKA(:,:,d),[size(RANA,1)*size(RANA,2) 1])); % typical skewness 
        S(3,d) = S(1,d) - nanstd(reshape(SKA(:,:,d),[size(RANA,1)*size(RANA,2) 1])); % typical skewness 
        V(1,d) = nanmean(reshape(RANGA(:,:,d),[size(RANA,1)*size(RANA,2) 1])); % typical inter-quartile range
end