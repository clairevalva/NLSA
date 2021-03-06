# NLSA

This project provides a MATLAB implementation of nonlinear Laplacian spectral analysis (NLSA) and related kernel algorithms for feature extraction and prediction of observables of dynamical systems. 

## Usage

1. Clone down the project repository:
```shell
git clone https://github.com/dg227/NLSA
```
2. Launch MATLAB, `cd` into the project's directory, and add `/nlsa` to the MATLAB search path. This can be done by executing the MATLAB command:
```matlab
addpath(genpath('nlsa'))
``` 

## Examples

- Rectification of variable-speed periodic oscillator using Koopman eigenfunctions: 
```shell
/examples/circle/demoKoopman.m
``` 
- Extraction of an approximately cyclical observable of the Lorenz 63 (L63) chaotic system using kernel integral operators with delays:
```shell
/examples/circle/demoNLSA.m
``` 
- Kernel analog forecasting of the L63 state vector components:
```shell
/examples/l63/demoKAF.m
``` 

## Implementation

NLSA implements a MATLAB class ``nlsaModel`` which encodes the attributes of the machine learning procedure to be carried out. This includes:
- Specification of training and test data.
- Delay-coordinate embedding.
- Pairwise distance functions.
- Density estimation for variable-bandwidth kernels.
- Symmetric and non-symmetric Markov kernels.
- Koopman operators.
- Projection and reconstruction of target data.   
- Nystrom out-of-sample extension.

Each of the elements above are implemented as MATLAB classes. See ``/nlsa/classes`` for further information and basic documentation.

Results from each stage of the computation are written on disk in a directory tree with (near-) unique names based on the nlsaModel parameters. 

## Known issues

-  In Windows environments, errors can occur due to long file/directory names. 

## Acknowledgment 

Research funded by the [National Science Foundation](https://nsf.gov) (grants DMS-1521775, 1842538, DMS-1854383) and [Office of Naval Research](https://onr.navy.mil) (grants N00014-14-1-0150, N00014-16-1-2649, N00014-19-1-2421).

<div align="center"><img src="pages/img/logoNSF.jpg" alt="NSF logo" height="70" hspace="10"><img src="pages/img/logoONR.png" alt="ONR logo" height="70" hspace="10"></div>
