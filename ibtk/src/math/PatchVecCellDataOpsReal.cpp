// Filename: PatchVecCellDataOpsReal.cpp
// Created on 09 Apr 2010 by Boyce Griffith
//
// Copyright (c) 2002-2013, Boyce Griffith
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

/////////////////////////////// INCLUDES /////////////////////////////////////

#include <ostream>
#include <string>

#include "Patch.h"
#include "PatchVecCellDataOpsReal.h"
#include "SAMRAI_config.h"
#include "ibtk/namespaces.h" // IWYU pragma: keep
#include "tbox/Utilities.h"

/////////////////////////////// NAMESPACE ////////////////////////////////////

namespace IBTK
{
/////////////////////////////// STATIC ///////////////////////////////////////

/////////////////////////////// PUBLIC ///////////////////////////////////////

template<class TYPE>
PatchVecCellDataOpsReal<TYPE>::PatchVecCellDataOpsReal()
{
    // intentionally blank
    return;
}// PatchVecCellDataOpsReal

template<class TYPE>
PatchVecCellDataOpsReal<TYPE>::~PatchVecCellDataOpsReal()
{
    // intentionally blank
    return;
}// ~PatchVecCellDataOpsReal

template<class TYPE>
void PatchVecCellDataOpsReal<TYPE>::swapData(
    Pointer<Patch<NDIM> > patch,
    const int data1_id,
    const int data2_id) const
{
    Pointer<VecCellData<TYPE> > d1 = patch->getPatchData(data1_id);
    Pointer<VecCellData<TYPE> > d2 = patch->getPatchData(data2_id);
#ifdef DEBUG_CHECK_ASSERTIONS
    TBOX_ASSERT(d1 && d2);
    TBOX_ASSERT(d1->getDepth() && d2->getDepth());
    TBOX_ASSERT(d1->getBox() == d2->getBox());
    TBOX_ASSERT(d1->getGhostBox() == d2->getGhostBox());
#endif
    patch->setPatchData(data1_id, d2);
    patch->setPatchData(data2_id, d1);
    return;
}// swapData

template<class TYPE>
void PatchVecCellDataOpsReal<TYPE>::printData(
    const Pointer<VecCellData<TYPE> >& data,
    const Box<NDIM>& box,
    std::ostream& s) const
{
#ifdef DEBUG_CHECK_ASSERTIONS
    TBOX_ASSERT(data);
#endif
    s <<"Data box = " <<box <<std::endl;
    data->print(box, s);
    s <<"\n";
    return;
}// printData

template<class TYPE>
void PatchVecCellDataOpsReal<TYPE>::copyData(
    Pointer<VecCellData<TYPE> >& dst,
    const Pointer<VecCellData<TYPE> >& src,
    const Box<NDIM>& box) const
{
#ifdef DEBUG_CHECK_ASSERTIONS
    TBOX_ASSERT(dst && src);
#endif
    dst->copyOnBox(*src, box);
    return;
}// copyData

template<class TYPE>
void PatchVecCellDataOpsReal<TYPE>::setToScalar(
    Pointer<VecCellData<TYPE> >& dst,
    const TYPE& alpha,
    const Box<NDIM>& box) const
{
#ifdef DEBUG_CHECK_ASSERTIONS
    TBOX_ASSERT(dst);
#endif
    dst->fillAll(alpha, box);
    return;
}// setToScalar

/////////////////////////////// NAMESPACE ////////////////////////////////////

} // namespace IBTK

/////////////////////////////// TEMPLATE INSTANTIATION ///////////////////////

#include "ibtk/VecCellData.h"  // IWYU pragma: keep

template class IBTK::PatchVecCellDataOpsReal<double>;
template class Pointer<IBTK::PatchVecCellDataOpsReal<double> >;

//////////////////////////////////////////////////////////////////////////////
