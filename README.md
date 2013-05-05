IBAMR - CMake-ified git mirror
=

What Is IBAMR?
-
IBAMR is a distributed-memory parallel implementation of the immersed boundary (IB) method with support for Cartesian grid adaptive mesh refinement (AMR). Support for distributed-memory parallelism is via MPI, the Message Passing Interface. Support for spatial adaptivity is via [SAMRAI](https://computation.llnl.gov/casc/SAMRAI), the Structured Adaptive Mesh Refinement Application Infrastructure, which is developed at the [Center for Applied Scientific Computing](https://computation.llnl.gov/casc) at [Lawrence Livermore National Laboratory](https://www.llnl.gov/).

This implementation of the IB method also makes extensive use of functionality provided by several high-quality third-party software libraries, including:

 -  [PETSc](http://www.mcs.anl.gov/petsc), the Portable, Extensible Toolkit for Scientific Computation,
 -  [hypre](https://computation.llnl.gov/casc/hypre/software.html), a library of high performance preconditioners that features parallel multigrid methods for both structured and unstructured grid problems,
 -  [HDF5](http://www.hdfgroup.org/HDF5), a general purpose library and file format for storing scientific data,
 -  [Blitz++](http://sourceforge.net/projects/blitz), a high-performance C++ array class library, and
 -  [Silo](https://wci.llnl.gov/codes/silo), a general purpose I/O library and file format for storing scientific data for visualization and post-processing.

IBAMR outputs visualization files that can be read by the [VisIt Visualization Tool](https://wci.llnl.gov/codes/visit). Work is also underway to implement support for finite element mechanics models in IBAMR via the [libMesh](http://libmesh.sourceforge.net/) finite element library.

What Is the IB Method?
-
The immersed boundary (IB) method is a general-purpose numerical method for simulating fluid-structure interaction. The IB formulation of such problems uses an Eulerian description of the fluid and a Lagrangian description of the structure. Interaction equations that take the form of integral equations with delta function kernels couple the Eulerian and Lagrangian variables.

For general information about the IB method, see [http://math.nyu.edu/faculty/peskin](http://math.nyu.edu/faculty/peskin). For visualizations of simulations that use IBAMR, see [http://cims.nyu.edu/~griffith](http://cims.nyu.edu/~griffith).

Getting Started
-
1. [Download and build the required third-party libraries](https://code.google.com/p/ibamr/wiki/Building_Third_Party_Libraries)
2. [Download and build IBAMR] (https://code.google.com/p/ibamr/wiki/Building_IBAMR)
Source code documentation for IBAMR is available on-line. Source code documentation is also available for the IBTK support library. File format documentation is also available on-line.

Guidelines on how to [contribute to the IBAMR](https://code.google.com/p/ibamr/wiki/IBAMR_Development) project.

Support
-
Support for IBAMR is available from the [IBAMR Developers](http://groups.google.com/group/ibamr-dev) (ibamr-dev) Google Group. There is also list of frequently asked questions.

Bugs and Other Issues
-
Please use the Google Code issue tracking system to report bugs, feature requests, or other issues with IBAMR. A list of issues is available.

Acknowledgments
-
IBAMR development is supported in part by an NSF Software Infrastructure for Sustained Innovation award (NSF OCI 1047734). Work to extend IBAMR to support finite element mechanics models is also supported in part the NSF (NSF DMS 1016554). We gratefully acknowledge this support.
