// Filename: IBPostProcessStrategy.h
// Created on 24 Sep 2008 by Boyce Griffith
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

#ifndef included_IBPostProcessStrategy
#define included_IBPostProcessStrategy

/////////////////////////////// INCLUDES /////////////////////////////////////

// IBTK INCLUDES
#include <ibtk/LData.h>
#include <ibtk/LDataManager.h>

// SAMRAI INCLUDES
#include <PatchHierarchy.h>
#include <tbox/DescribedClass.h>
#include <tbox/Pointer.h>

// C++ STDLIB INCLUDES
#include <vector>

/////////////////////////////// CLASS DEFINITION /////////////////////////////

namespace IBAMR
{
/*!
 * \brief Class IBPostProcessStrategy provides a generic interface for specifying
 * post-processing code for use in an IB computation.
 */
class IBPostProcessStrategy
    : public SAMRAI::tbox::DescribedClass
{
public:
    /*!
     * \brief Default constructor.
     */
    IBPostProcessStrategy();

    /*!
     * \brief Virtual destructor.
     */
    virtual
    ~IBPostProcessStrategy();

    /*!
     * \brief Setup the data needed to post-process the data on the specified
     * level of the patch hierarchy.
     *
     * \note A default empty implementation is provided.
     */
    virtual void
    initializeLevelData(
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchHierarchy<NDIM> > hierarchy,
        int level_number,
        double init_data_time,
        bool initial_time,
        IBTK::LDataManager* l_data_manager);

    /*!
     * \brief Post-process data on the patch hierarchy.
     */
    virtual void
    postProcessData(
        int u_idx,
        int p_idx,
        int f_idx,
        const std::vector<SAMRAI::tbox::Pointer<IBTK::LData> >& F_data,
        const std::vector<SAMRAI::tbox::Pointer<IBTK::LData> >& X_data,
        const std::vector<SAMRAI::tbox::Pointer<IBTK::LData> >& U_data,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchHierarchy<NDIM> > hierarchy,
        int coarsest_level_number,
        int finest_level_number,
        double data_time,
        IBTK::LDataManager* l_data_manager) = 0;

private:
    /*!
     * \brief Copy constructor.
     *
     * \note This constructor is not implemented and should not be used.
     *
     * \param from The value to copy to this object.
     */
    IBPostProcessStrategy(
        const IBPostProcessStrategy& from);

    /*!
     * \brief Assignment operator.
     *
     * \note This operator is not implemented and should not be used.
     *
     * \param that The value to assign to this object.
     *
     * \return A reference to this object.
     */
    IBPostProcessStrategy&
    operator=(
        const IBPostProcessStrategy& that);
};
}// namespace IBAMR

/////////////////////////////// INLINE ///////////////////////////////////////

//#include <ibamr/IBPostProcessStrategy.I>

//////////////////////////////////////////////////////////////////////////////

#endif //#ifndef included_IBPostProcessStrategy
