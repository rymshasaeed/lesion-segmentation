# Lesion-Segmentation
Breast cancer is a global health concern. Therefore, detecting signs of this disease at its earlier stages is of prime importance. Due to the low energy involved in the imaging process, using breast ultrasound images is one of the preferred methods for diagnosis.In that context, image segmentation in BUS images refers to extracting the regions corresponding to the lesion and separating it from normal tissue regions. The size and the mass of the lesion regions are associated with the severity of the disease and its progress stage.

# Workflow 
### 1. Pre-processing
Since the images came with different illumination and contrast levels, the algorithm initiates with image pre-processing. Based on image contrasts i.e., α, two processing schemes have been designed.
- If α value is too low or too high, γ-correction is applied followed by 2D median filtering to remove the speckle noise, and histogram equalization to enhance image contrast. Finally, the histogram equalized image is binarized via Otsu thresholding.
- If α value is within the specified range, contrast enhancement is applied followed by γ-correction. Afterwards, the global threshold is converted to a local threshold to match with the prior operations.
<p align="center">
  <img src="https://github.com/rimshasaeed/lesion-segmentation/blob/main/test%20results/figure1.jpg", alt="pre-processing" width="50%">
  <br>
  <i>Test-Image-9 (α within range)</i>
</p>

### 2. Region-growing segmentation
Once the images are pre-processed, region growing segmentation algorithm is applied. The algorithm works by eroding the image with a disk-shaped structuring element of radius 20. This returns a point cloud of the image from which the duplicate seed locations are removed via morphological shrinking. The locations being returned are used to get seeds from the original pre-processed image. Afterwards, a for-loop is initiated to get the connectivity information (i.e., the marker regions). Once all the connected regions are obtained, the false positives are discarded so that only the contiguous regions are left. Due to the inherent illumination, the image still has some unnecessary regions (or noise) which are also removed. The final segmented image shows a lesion region as well as some false positives which can be removed via post-processing.
<p align="center">
  <img src="https://github.com/rimshasaeed/lesion-segmentation/blob/main/test%20results/figure2.jpg", alt="segmentation" width="50%">
  <br>
  <i>Test-Image-9</i>
</p>

### 3. Post-processing
The post-processing step works to eliminate the false positives so that only the segmented lesion is retained. First, the white pixel areas (i.e., the lesion and noise) are calculated and morphological opening is applied to remove the noise. The radius of the disk structuring element used for this purpose comes from the calculation made earlier. Then a lesion mask is created, and the morphologically opened image is subtracted from it. The lesion region in the difference image is filled with pixels. Finally, the unwanted region is removed using morphological erosion operation. To cancel the effect of erosion from the segmented lesion, it is dilated with a disk structuring element of radius 4. This results the final segmented lesion.
<p align="center">
  <img src="https://github.com/rimshasaeed/lesion-segmentation/blob/main/test%20results/figure3.jpg", alt="post-processing" width="50%">
  <br>
  <i>Test-Image-9</i>
</p>

### 4. Evaluation based on Jaccard Index
To test the performance of the algorithm, the segmentation results are compared with the ground truth masks using Jaccard similarity index. The algorithm works efficiently for all the images except for Test-Image-15 since it has a diminutive benign tumour. Also, due to a series of morphological operations being performed during segmentation, some of the corner regions are lost and are not being segmented as seen by the magenta-green pixels.
<p align="center">
  <img src="https://github.com/rimshasaeed/lesion-segmentation/blob/main/test%20results/figure4.jpg", alt="similarity-score" width="70%">
  <br>
  <i>Test-Image-9</i>
</p>
