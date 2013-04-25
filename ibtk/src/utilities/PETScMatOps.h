// Filename: PETScMatOps.h
// Created on 27 Sep 2010 by Boyce Griffith
//
// Copyright (c) 2002-2010, Boyce Griffith
// All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//    * Redistributions of source code must retain the above copyright notice,
//      this list of conditions and the following disclaimer.
//
//    * Redistributions in binary form must reproduce the above copyright
//      notice, this list of conditions and the following disclaimer in the
//      documentation and/or other materials provided with the distribution.
//
//    * Neither the name of New York University nor the names of its
//      contributors may be used to endorse or promote products derived from
//      this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

#ifndef included_PETScMatOps
#define included_PETScMatOps

/////////////////////////////// INCLUDES /////////////////////////////////////

// PETSc INCLUDES
#include <petscmat.h>

/////////////////////////////// CLASS DEFINITION /////////////////////////////

namespace IBTK
{
/*!
 * \brief Class PETScMatOps provides utility functions for <A
 * HREF="http://www-unix.mcs.anl.gov/petsc">PETSc</A> Mat objects.
 */
class PETScMatOps
{
public:

    /*!
     * \brief Optimized version of the PETSc function MatAXPY.
     */
    static PetscErrorCode
    MatAXPY(
        Mat Y,
        PetscScalar a,
        Mat X);

protected:

private:
    /*!
     * \brief Default constructor.
     *
     * \note This constructor is not implemented and should not be used.
     */
    PETScMatOps();

    /*!
     * \brief Copy constructor.
     *
     * \note This constructor is not implemented and should not be used.
     *
     * \param from The value to copy to this object.
     */
    PETScMatOps(
        const PETScMatOps& from);

    /*!
     * \brief Assignment operator.
     *
     * \note This operator is not implemented and should not be used.
     *
     * \param that The value to assign to this object.
     *
     * \return A reference to this object.
     */
    PETScMatOps&
    operator=(
        const PETScMatOps& that);

    /*!
     * \brief Optimized version of the PETSc function MatAXPY for pairs of
     * MPIAIJ matrices.
     */
    static PetscErrorCode
    MatAXPY_MPIAIJ(
        Mat Y,
        PetscScalar a,
        Mat X);

    /*!
     * \brief Optimized version of the PETSc function MatAXPY for pairs of
     * SeqAIJ matrices.
     */
    static PetscErrorCode
    MatAXPY_SeqAIJ(
        Mat Y,
        PetscScalar a,
        Mat X);
};
}// namespace IBTK

/////////////////////////////// INLINE ///////////////////////////////////////

//#include "PETScMatOps.I"

//////////////////////////////////////////////////////////////////////////////

#endif //#ifndef included_PETScMatOps
