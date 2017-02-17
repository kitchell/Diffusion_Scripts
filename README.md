# Diffusion_Scripts
Scripts used to analyze the diffusion images for the Brain/Endocast cadaver study.

These scripts are written for use on IU's Karst supercomputing cluster.
It is assumed that all files are within the /N/dc2/scratch/kitchell/Cadaver_diffusion/ folder 
and that the data for each subject is in a folder /subj_num (replace num with the subject number). 

First download the t1, dwi AP, and dwi PA zipped files and place them in a folder called
subj_num (replace num with the subject number i.e. subj_10004) in the Downloads folder in Karst.

Then:
##1. from within the Cadaver_diffusion folder edit the initialize_subj script and change the subject number to the correct number for your subject
this will:
- create the subj folder 
- run make_directories, which will make all the other necessary folders
- copy the downloaded files to the correct folder and unzip them
- run dcm2nii on the files
- copy the nifti files to the correct folders and rename them
  
##2. run the fsl preprocessing steps:
1. cd to the subj_num/diffusion_directory/bin folder and edit the diffusion_clean script change the subj number to be the number of the current subject
2. cd back to /diffusion_directory and edit the run_batch_clean.pbs script to have the correct subject numbers
3. run the run_batch_clean.pbs: qsub run_batch_clean.pbs
  
##3. Align the T1 image to ACPC
1. This step asummes you have vistasoft (https://github.com/vistalab/vistasoft) and spm (http://www.fil.ion.ucl.ac.uk/spm/) installed and the paths added to matlab
2. cd into /subj_num/diffusion_directory/Anatomy
3. start matlab 
  1. on karst: module load matlab
  2.  matlab
4. run mrAnatAverageAcPcNifti: mrAnatAverageAcPcNifti(‘t1.nii.gz’, ‘t1_acpc.nii.gz’)
      1. choose the AC location
      2. choose the PC location
      3. choose the midsaggital slice
      4. click finish
5. run bet: bet t1_acpc.nii.gz t1_acpc_brain.nii.gz -m -f 0.40
  
##4. split the bvec and bval shells
1. cd into the main folder: Cadaver_diffusion
2. edit the shell_splitting_batch script to have the correct subjects (you can do multiple at once)
3.  run ./shell_splitting_batch
  
##5. run dtiinit
1. cd into the main folder: Cadaver_diffusion
2.  edit the dtiinit_batch script to have the correct subject number
3.  make sure matlab is loaded and run ./dtiinit_batch
4.  once done check the quality of the data using dtiFiberUI (from vistasoft, ran in matlab, http://web.stanford.edu/group/vista/cgi-bin/wiki/index.php/MrDiffusion#Software_Set-Up)

##6. run Freesurfer (https://surfer.nmr.mgh.harvard.edu/) this can also be run earlier
1. edit the run_freesurfer script to have the correct subj number and the correct output/error names
2. run the script using qsub: qsub run_freesurfer
3. this should run freesurfer and place the subject files in Karst/Applications/FS_subjects
  
