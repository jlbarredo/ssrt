function TC = getTC(files,mask)
%%  Extracts signal from a ROI 
vols = spm_vol(files);
mask = spm_vol(mask);
TC = length(vols);

outbrain = spm_read_vols(mask);


for n = 1:TC
    img = spm_read_vols(vols(n));
    TC(n) = mean(img(outbrain>0.9));
end
