function bvals_bvecs_split

%% Matlab script for splitting shells and generating data, bvec and bval files for each shell in multi-shell data. Script developed by Franco Pestilli (2014); adapted and used by Brad Caron (IU Graduate Student, 2016) for the microstructure in concussion-prone athletics study.


% seperate bvals/bvecs
% build paths
%subj = 'subj_9946 subj_9975 subj_10004 subj_10005 subj_10006 subj_10011 subj_10012 subj_15 subj_10015 subj_10016 subj_10019 subj_10024 subj_10034'; % subject; add all subjects for batch
%subj = 'subj_9946';
b_vals = {'1000','2500'}; % separate shells
stem = 'data'; % stem used for writing output files
projdir1 = '/N/dc2/scratch/kitchell/Cadaver_diffusion'; % path to data directory

% Split data into two separate files (BVALS = 1000 and 2500).

bvals = dlmread('data.bvals');
bvals = round(bvals./100)*100;
bvals(bvals==100) = 0;
dlmwrite('data.bvals',bvals)
dwi   = niftiRead('data.nii.gz');
dwi1000 = dwi;
dwi1000.fname = 'data_b1000.nii.gz';
dwi2500 = dwi;
dwi2500.fname = 'data_b2500.nii.gz';
index1000 = (bvals == 1000);
index2500 = (bvals == 2500);
index0    = (bvals == 0);

% Find all indices to each bvalue and B0

all_1000  = or(index1000,index0);
all_2500  = or(index2500,index0);
dwi1000.data = dwi.data(:,:,:,all_1000);
dwi1000.dim(4) = size(dwi1000.data,4);
niftiWrite(dwi1000);
bvals1000 = bvals(all_1000);
dlmwrite('data_b1000.bvals',bvals1000);
bvecs1000 = dlmread('data.bvecs');
bvecs1000 = bvecs1000(:,all_1000);
dlmwrite('data_b1000.bvecs',bvecs1000);
dwi2500.data = dwi.data(:,:,:,all_2500);
dwi2500.dim(4) = size(dwi2500.data,4);
niftiWrite(dwi2500);
bvals2500 = bvals(all_2500);
dlmwrite('data_b2500.bvals',bvals2500);
bvecs2500 = dlmread('data.bvecs');
bvecs2500 = bvecs2500(:,all_2500);
dlmwrite('data_b2500.bvecs',bvecs2500);

for ibv = 1:length(b_vals)
bvecs = fullfile(pwd, sprintf('data_b%s.bvecs',b_vals{ibv}));
bvals = fullfile(pwd, sprintf('data_b%s.bvals',b_vals{ibv}));
out   = fullfile(pwd, 'fibers', sprintf('data_b%s.b', b_vals{ibv}));
mrtrix_bfileFromBvecs(bvecs, bvals, out);
end
exit;
