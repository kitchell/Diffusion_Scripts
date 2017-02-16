# Diffusion_Scripts
Scripts used to analyze the diffusion images for the Brain/Endocast cadaver study.

These scripts are written for use on IU's Karst supercomputing cluster.
It is assumed that all files are within the /N/dc2/scratch/kitchell/Cadaver_diffusion/ folder 
and that the data for each subject is in a folder /subj_num (replace num with the subject number). 

First download the t1, dwi ap, and dwi pa zipped files and place them in a folder called
subj_num in the Downloads folder in Karst.

Then:
1. from within the Cadaver_diffusion folder edit the initialize_subj script and 
  change the subject number to the correct number for your subject
  a. this will create the subj folder 
  b. run make_directories, which will make all the other necessary folders
  c. copy the downloaded files to the correct folder and unzip them
  d. run dcm2nii on the files
  e. copy the nifti files to the correct folders and rename them
2. run the fsl preprocessing steps:
  a. cd to the subj_num/diffusion_directory/bin folder and edit the diffusion_clean script
  change the subj number to be the number of the current subject
  b. cd back to /diffusion_directory and edit the run_batch_clean.pbs script
  to have the correct subject numbers
  c. run the run_batch_clean.pbs: qsub run_batch_clean.pbs
3. Align the T1 image to ACPC
  a. this step asummes you have vistasoft (https://github.com/vistalab/vistasoft) and spm (http://www.fil.ion.ucl.ac.uk/spm/) installed
  and the paths added to matlab
  b. cd into /subj_num/diffusion_directory/Anatomy
  c. start matlab 
    i. on karst: module load matlab
    ii. matlab
  d. run mrAnatAverageAcPcNifti:
     mrAnatAverageAcPcNifti(‘t1.nii.gz’, ‘t1_acpc.nii.gz’)
     i. choose the AC location
     ii. choose the PC location
     iii. choose the midsaggital slice
     iv. click finish
  e. run bet: bet t1_acpc.nii.gz t1_acpc_brain.nii.gz -m -f 0.40
4. spli the bvec shells
  a. cd into the main folder: Cadaver_diffusion
  b. edit the shell_splitting_batch script to have the correct subjects (you can do multiple at once)
  c. run ./shell_splitting_batch
5. run dtiinit
  a. cd into the main folder: Cadaver_diffusion
  b. edit the dti_init_batch script to have the correct subject number
  c. make sure matlab is loaded and run ./dti_init_batch
  d. once done check the quality of the data using dtiFiberUI (from vistasoft, ran in matlab, http://web.stanford.edu/group/vista/cgi-bin/wiki/index.php/MrDiffusion#Software_Set-Up)
6. 
  
