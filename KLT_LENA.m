clear
%set the block size q
q=2;                                                                       
lena = imread('lena.tif');
%original lena image is RGB image
lena_gray = rgb2gray(lena);                                                 
lena_gray = im2double(lena_gray);
[m,n] = size(lena_gray);       
%initialize the parameters
b = [];                                                                    
B = [];
X = [];
%divide the image into q*q blocks
for i = 1:m/q                                                               
    for j = 1:n/q
        t_l = (i-1)*q+1;
        t_r = (i-1)*q+q;
        b_l = (j-1)*q+1;
        b_r = (j-1)*q+q;
        block = lena_gray(t_l:t_r,b_l:b_r);
         %get the blocks and order them lexicographically to form vector
        bias = reshape(block,1,q^2);                                        
        B = [B;bias];
    end
end
%compute the covariance matrix C
C = cov(B);   
%get eigenvalues and eigenvectors
[V,D] = eig(C);                                                              
e = diag(D);
error=[];
%utilize K-L Transform
BB = mean(B);
for l = 1:m*n/q^2                                                          
    b = B(l,:);
    for i = 1:3
        x = zeros(q^2,1);
        c = C(:,i);
        p = V(:,i);
        x = x + (transpose(p)*transpose(b)).*p;
    end
    error = [error,norm(x-transpose(b),2)];
    X = [X,x];
end
k = 1;
F = transpose(X);
%Reformat the image
for i=1:m/q                                                                  
    for j=1:n/q
        y1=reshape(F(k,1:q^2),q,q);
        ii=(i-1)*q+1;
        jj=(j-1)*q+1;
        final(ii:ii+q-1,jj:jj+q-1)=y1;
        k=k+1;
    end
end
ave_error = mean(error);
imshow(final)