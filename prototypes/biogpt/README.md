# BioGPT Voila Dashboard

![BioGPT_Dashboard](https://user-images.githubusercontent.com/8834829/217871573-14aaa1c6-cad7-4056-8935-596b2013fa1c.gif)


## Prerequsites
- Use Python Data Science environment, starting with 0.1.7. It includes fastbpe, tensorboardx, sacremoses, fairseq
- Download the checkpoints

```bash
mkdir /opt/shared/data/biogpt
mkdir /opt/shared/data/biogpt/checkpoints
cd /opt/shared/data/biogpt/checkpoints

wget https://msramllasc.blob.core.windows.net/modelrelease/BioGPT/checkpoints/Pre-trained-BioGPT.tgz
wget https://msramllasc.blob.core.windows.net/modelrelease/BioGPT/checkpoints/Pre-trained-BioGPT-Large.tgz
wget https://msramllasc.blob.core.windows.net/modelrelease/BioGPT/checkpoints/QA-PubMedQA-BioGPT.tgz
wget https://msramllasc.blob.core.windows.net/modelrelease/BioGPT/checkpoints/QA-PubMedQA-BioGPT-Large.tgz
wget https://msramllasc.blob.core.windows.net/modelrelease/BioGPT/checkpoints/RE-BC5CDR-BioGPT.tgz
wget https://msramllasc.blob.core.windows.net/modelrelease/BioGPT/checkpoints/RE-DDI-BioGPT.tgz
wget https://msramllasc.blob.core.windows.net/modelrelease/BioGPT/checkpoints/RE-DTI-BioGPT.tgz
wget https://msramllasc.blob.core.windows.net/modelrelease/BioGPT/checkpoints/DC-HoC-BioGPT.tgz

tar -zxvf Pre-trained-BioGPT.tgz
tar -zxvf Pre-trained-BioGPT-Large.tgz
tar -zxvf QA-PubMedQA-BioGPT.tgz
tar -zxvf QA-PubMedQA-BioGPT-Large.tgz
tar -zxvf RE-BC5CDR-BioGPT.tgz
tar -zxvf RE-DDI-BioGPT.tgz
tar -zxvf RE-DTI-BioGPT.tgz
tar -zxvf DC-HoC-BioGPT.tgz

rm Pre-trained-BioGPT.tgz
rm Pre-trained-BioGPT-Large.tgz
rm QA-PubMedQA-BioGPT.tgz
rm QA-PubMedQA-BioGPT-Large.tgz
rm RE-BC5CDR-BioGPT.tgz
rm RE-DDI-BioGPT.tgz
rm RE-DTI-BioGPT.tgz
rm DC-HoC-BioGPT.tgz

# Rename for consistency
mv Pre-trained-BioGPT BioGPT
mv Pre-trained-BioGPT-Large BioGPT-Large
```

- Download the data
```bash
git clone https://github.com/microsoft/BioGPT.git
mv BioGPT/data /opt/shared/data/biogpt/data
```
