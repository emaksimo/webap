%%% verify the way the symmetric matrix is treated
%%% here we search for all UNIQUE combinations of matrix elements
%%% vector "a" can be the CNR observations at different locations 

clear a aa D1 D2 D
        a = 1:12 ; 
        D = nan([length(a) length(a)]);
        aa = toeplitz(a);
    
     for i=1:length(a) 
         D1(i+1:length(a),i) = aa(i+1:length(a),1);
         D2(i+1:length(a),i) = aa(1,i);
         
         D(i+1:length(a),i)  = abs(minus(aa(i+1:length(a),1), aa(1,i)));
         [D1(:,i),D2(:,i),D(:,i)]
%          keyboard
     end