IBAMR
=====

CMake-ified git mirror for IBAMR 

IBAMR
What Is IBAMR?
IBAMR is a distributed-memory parallel implementation of the immersed boundary (IB) method with support for Cartesian grid adaptive mesh refinement (AMR). Support for distributed-memory parallelism is via MPI, the Message Passing Interface. Support for spatial adaptivity is via SAMRAI, the Structured Adaptive Mesh Refinement Application Infrastructure, which is developed at the Center for Applied Scientific Computing at Lawrence Livermore National Laboratory.

This implementation of the IB method also makes extensive use of functionality provided by several high-quality third-party software libraries, including:

PETSc, the Portable, Extensible Toolkit for Scientific Computation,
hypre, a library of high performance preconditioners that features parallel multigrid methods for both structured and unstructured grid problems,
HDF5, a general purpose library and file format for storing scientific data,
Blitz++, a high-performance C++ array class library, and
Silo, a general purpose I/O library and file format for storing scientific data for visualization and post-processing.
IBAMR outputs visualization files that can be read by the VisIt Visualization Tool. Work is also underway to implement support for finite element mechanics models in IBAMR via the libMesh finite element library.

What Is the IB Method?
The immersed boundary (IB) method is a general-purpose numerical method for simulating fluid-structure interaction. The IB formulation of such problems uses an Eulerian description of the fluid and a Lagrangian description of the structure. Interaction equations that take the form of integral equations with delta function kernels couple the Eulerian and Lagrangian variables.

For general information about the IB method, see http://math.nyu.edu/faculty/peskin. For visualizations of simulations that use IBAMR, see http://cims.nyu.edu/~griffith.

Getting Started
Download and build the required third-party libraries
Download and build IBAMR
Source code documentation for IBAMR is available on-line. Source code documentation is also available for the IBTK support library. File format documentation is also available on-line.

There are some basic instructions on using or building IBAMR at NYU:

Using IBAMR on the CIMS Linux network
Building IBAMR on the CIMS Linux network
Building IBAMR on the NYU cardiac HPC cluster
Building IBAMR on the NYU bowery HPC cluster

There are also some basic instructions on building IBAMR on various platforms:

Building IBAMR on a system running Linux
Building IBAMR on a system running Mac OS X
There are also guidelines on how to contribute to the IBAMR project.

Support
Support for IBAMR is available from the IBAMR Developers (ibamr-dev) Google Group. There is also list of frequently asked questions.

Bugs and Other Issues
Please use the Google Code issue tracking system to report bugs, feature requests, or other issues with IBAMR. A list of issues is available.

Acknowledgments
IBAMR development is supported in part by an NSF Software Infrastructure for Sustained Innovation award (NSF OCI 1047734). Work to extend IBAMR to support finite element mechanics models is also supported in part the NSF (NSF DMS 1016554). We gratefully acknowledge this support.
