Each folder contains:

- a .mat file with the addresses which is the order that the images within the dataset should be read to align with the scores. addresses<NameDataset>.mat
- a .mat file with the human scores associated to the images. hScores<NameDataset>.mat
- a .mat file with the predicted scores associated to the images. mScores<NameDataset>.mat
- a folder named Images with the images of the dataset.
- In the folder Images there is another folder with the GroundTruth images in a folder called GroundTruth

There are MOS available for the Ground Truth images of SRIJ dataset, but they are available in the folder HumanStudy

The files mScores<NameDataset>.mat contains the predicted scores given by the metrics implemented for this study in a variable called 'prediction'.

Here we point out whose prediction is according to the position in the variable prediction. If the metric requires training, the dataset used for training is indicated in parentheses


mScoresSRIJ

1 - Qodu
2 - Q1odu
3 - Q2odu
4 - NIQE
5 - IL-NIQE
6 - Qoda (MY)
7 - Q1oda (MY)
8 - Q2oda (MY)
9 - MY (MY)
10 - PI (MY)
11 - MS-SSIM
12 - FSIM
13 - SSIM
14 - VIF
15 - IFC
16 - STD


mScoresMY

1 - Qodu
2 - Q1odu
3 - Q2odu
4 - NIQE
5 - IL-NIQE
6 - Qoda (MY)
7 - Q1oda (MY)
8 - Q2oda (MY)
9 - MY (MY)
10 - PI (MY)
11 - MS-SSIM
12 - FSIM
13 - SSIM
14 - VIF
15 - IFC
16 - STD


mScoresQADS

1 - Qodu
2 - Q1odu
3 - Q2odu
4 - NIQE
5 - IL-NIQE
6 - Qoda (MY)
7 - Q1oda (MY)
8 - Q2oda (MY)
9 - Qoda (SRIJ)
10 - Q1oda (SRIJ)
11 - Q2oda (SRIJ)
12 - MY (MY)
13 - MY (SRIJ)
14 - PI (MY)
15 - PI (SRIJ)
16 - MS-SSIM
17 - FSIM
18 - SSIM
19 - VIF
20 - IFC
21 - STD
