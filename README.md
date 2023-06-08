# Kaya Server Usage and SLURM Scheduling Tutorial for Lister Lab

This repository contains a tutorial on server usage and SLURM scheduling. The tutorial provides an introduction to server management and demonstrates how to use SLURM for job scheduling.

## Table of Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Usage](#usage)
- [Examples](#examples)
- [Contributing](#contributing)
- [License](#license)

## Introduction

In this tutorial, you will learn the basics of server management and SLURM job scheduling. The tutorial is designed for beginners and covers the following topics:

- What is a server?
- Why use SLURM for job scheduling?
- How to set up and configure a server.
- How to submit and manage jobs using SLURM.
- Best practices and tips for efficient server usage.

## Prerequisites

Before starting with the tutorial, make sure you have the following prerequisites installed:

- Access to UWA's Kaya server. Email David Grey at UWA for access. 
  * Importantly, you'll need to have a description of your project and who else will have access to the data.
- VPN access to UWA, including setup of MS Authenticator in case you work outside of the `UNIFI` network.
- Test that you could successfully login to `Kaya` by opening the terminal and ssh into Kaya


```bash
ssh <username>@kaya.hpc.uwa.edu.au
```





## Installation

There are lot couple of programs already pre-installed on `Kaya`. They are called `modules` and you can access the available modules by typeing:

```bash
module avail
```

![Available Modules on Kaya](assets/images/modules_kaya.png)


You can work out what modules you have loaded with the command

```bash
module list
```

__IMPORTANTLY__, you'll need to load the `gcc` compiler for a lot of the programs. Consider adding this line of code to your `~/.bashrc` file.

You can load a module with the command

```bash
module load gcc/9.4.0
```

To load samtools for example, type either
```bash
module load samtools/1.13(default)
```
or
```bash
module load samtools
```

Try running `module list` to check if `samtools` have been successfully loaded.


If you must, you can also unload the modules (in case they clash with conda installs for example) with the command

```bash
module unload samtools
```

### Conda installations

It's recommended and important to install your `conda environment` with the prefix to point to the `group` data. There is more space on the `/group` volume and you can easily share the conda installation with your team members, so they don't have to re-install everything themselves.

An example of how to create a new conda environment would be:

```bash
conda create -p /group/<your_project_name>/conda_environments/bioinfo -c conda-forge mamba
```
Mamba is really useful for quicker installations in conda by replacing `conda` with `mamba`. For example, after mamba is installed, you can install `unicycler` with `mamba` by typing

```bash
mamba install -c bioconda unicycler
```



## Usage

Explain how to use your tutorial and provide step-by-step instructions. You can include code snippets or command-line examples to illustrate the process.

## Examples

Provide some examples or use cases to demonstrate the concepts explained in the tutorial. You can include sample code or scripts along with explanations.

## Contributing

Contributions to this tutorial are welcome! If you find any issues or have suggestions for improvement, please open an issue or submit a pull request.

## License

This project is licensed under the [License Name] - add a link to the license file if applicable.
