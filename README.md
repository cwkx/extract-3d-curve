## Extracting 3D Parametric Curves from 2D Images of Helical Objects
Implementation of our paper "Extracting 3D Parametric Curves from 2D Images of Helical Objects"

- by **Chris G. Willcocks, Philip T. G. Jackson, Carl J. Nelson, and Boguslaw Obara**

## Overview
This repository provides a MATLAB implementation for extracting a 3D parametric curve from a 2D image of a helical object.

Our project is split into 4 parts, as discussed in the paper:
 1. Segmenting the helical object (Algorithm 1)
 2. Straightening the segmented object (Algorithm 2)
 3. Fitting a curve to a straight object (Algorithm 3)
 4. Undoing the coordinate transforms

For general usage:
 - Open MATLAB, right click project directory and add to path.
 - Open main.m
 - Change *'image'* url.
 - Adjust the parameters, as discussed in the paper.
 - Run
  - Alternatively, call the relevant parts of code accordingly.

## License
This code is licensed under the GNU General Public License Version 3.

- For alternative licenses, please contact *christopher.g.willcocks@durham.ac.uk*.
