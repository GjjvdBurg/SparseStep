SparseStep R Package
====================

Paper: [SparseStep: Approximating the Counting Norm for Sparse 
Regularization](https://arxiv.org/abs/1701.06967) by G.J.J. van den Burg, 
P.J.F. Groenen, and A. Alfons (*Arxiv preprint arXiv:1701.06967 [stat.ME]*, 
2017).

GitHub: 
[https://github.com/GjjvdBurg/SparseStep](https://github.com/GjjvdBurg/SparseStep).

Introduction
------------

This R package implements the SparseStep method for solving the regression 
problem with a sparsity constraint on the parameters. The package is 
extensively documented through the builtin R documentation. See:

    ?'sparsestep-package'
    ?sparsestep
    ?path.sparsestep

for more information.

Installation
------------

This package can be installed through CRAN:

    install.packages('sparsestep')

Reference
---------

If you use SparseStep in any of your projects, please cite the paper using the 
information available through the R command:

    citation('sparsestep')

or use the following BibTeX code:

    @article{van2017sparsestep,
      title = {{SparseStep}: Approximating the Counting Norm for Sparse Regularization},
      author = {Gerrit J.J. {van den Burg} and Patrick J.F. Groenen and Andreas Alfons},
      journal = {arXiv preprint arXiv:1701.06967},
      archiveprefix = {arXiv},
      year = {2017},
      eprint = {1701.06967},
      url = {https://arxiv.org/abs/1701.06967},
      primaryclass = {stat.ME},
      keywords = {Statistics - Methodology, 62J05, 62J07},
    }

License
-------

    Copyright 2016, G.J.J. van den Burg.

    SparseStep is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    SparseStep is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with SparseStep. If not, see <http://www.gnu.org/licenses/>.

    For more information please contact:

    G.J.J. van den Burg
    email: gertjanvandenburg@gmail.com

