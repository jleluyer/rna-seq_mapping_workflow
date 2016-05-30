# RNA-seq using a reference genome

An integrated worklow based on genome-mapping and DE gene assessment to conduct RNA-seq data analyses in Colosse


**WARNING**

The software is provided "as is", without warranty of any kind, express or implied, including but not limited to the warranties of merchantability, fitness for a particular purpose and noninfringement. In no event shall the authors or copyright holders be liable for any claim, damages or other liability, whether in an action of contract, tort or otherwise, arising from, out of or in connection with the software or the use or other dealings in the software.


## Documentation

Note that **ALL** the scripts must be launched from the root folder **rna-seq_mapping_workflow/**
### 1. Clone git hub directory

```
git clone https://github.com/jleluyer/rna-seq_mapping_workflow
```

### 2. Prepare utilities

```
cd rna-seq_mapping_workflow

./00_scripts/00_import_trinity.sh
```
This script will create two directories **00_scripts/trinity_utils** and **00_scripts/trinotate_utils**

```
cd 00_scripts/trinity_utils/
make
make plugins
cd ../..
```
**still have to properly configurate trinity on Colosse**

### 3. Import data

```
cp /path/to/the/data/repository/*.gz 02_data
```

### 4. Trimming the data

* Import univec.fasta

```
wget 01_info_files/univec.fasta ftp://ftp.ncbi.nlm.nih.gov/pub/UniVec/UniVec
```
Add your specific adaptors if absent in the database.

* Trimming

Two scripts are provided for **Single-End** or **Paired-end** data, **00_scripts/01_trimmomatic_se.sh** and **00_scripts/01_trimmomatic_pe.sh**, respectively.

First you need to change the userID and userEmail for your proper info in **./00_scripts/colosse-jobs/01_trimmomatic_pe.sh**

Then launch:

```
./00_scripts/colosse-jobs/01_trimmomatic_pe.sh
```

You may also want to check the quality of your data prior to trimming using **00_scripts/utility_scripts/fastq.sh**. This will require to have **fastQC** installed in your **$PATH**.

### 5. Index reference genome with GMAP


```
msub /00_scripts/02_gmap_index.sh
```

### 6. Mapping

Before launching the mapping, make sure you changed the userID and userEmail information in the script **./00_scripts/colosse_jobs/03_gmap_mapping_jobs.sh**

Then launch:
```
./00_scripts/colosse_jobs/03_gmap_mapping_jobs.sh 
```
This script will create a job by individual.

### 7. Assess reads count

Before launching the mapping, make sure you changed the userID and userEmail information in the script **./00_scripts/04_htseq_count.sh**

```
msub /00_scripts/04_htseq_count.sh
```

### 8. Downstream analysis


## Notes

## Dependencies

### Softwares

[GSNAP](http://research-pub.gene.com/gmap/)

[HTseq](http://www-huber.embl.de/HTSeq/doc/overview.html)

[Bowtie](http://bowtie-bio.sourceforge.net/index.shtml)

**java 1.7** or higher

[R](https://www.r-project.org/)


## Citations


## Licence


