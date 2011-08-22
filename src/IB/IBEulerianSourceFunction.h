// Filename: IBEulerianSourceFunction.h
// Created on 18 Jun 2005 by Boyce Griffith
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

#ifndef included_IBEulerianSourceFunction
#define included_IBEulerianSourceFunction

/////////////////////////////// INCLUDES /////////////////////////////////////

// IBTK INCLUDES
#include <ibtk/CartGridFunction.h>

// SAMRAI INCLUDES
#include <Patch.h>
#include <Variable.h>
#include <tbox/Pointer.h>

/////////////////////////////// CLASS DEFINITION /////////////////////////////

namespace IBAMR
{
/*!
 * \brief Class IBEulerianSourceFunction is used to communicate the Eulerian fluid
 * source-sink distribution computed by class IBHierarchyIntegrator to the
 * incompressible Navier-Stokes solver.
 */
class IBEulerianSourceFunction
    : public IBTK::CartGridFunction
{
public:
    /*!
     * \brief Constructor.
     */
    IBEulerianSourceFunction(
        const std::string& object_name,
        int Q_current_idx,
        int Q_new_idx,
        int Q_half_idx);

    /*!
     * \brief Destructor.
     */
    ~IBEulerianSourceFunction();

    /*!
     * \brief Set the current and new times for the present timestep.
     */
    void
    setTimeInterval(
        double current_time,
        double new_time);

    /*!
     * \name Methods to set the data.
     */
    //\{

    /*!
     * \note This concrete IBTK::CartGridFunction is time-dependent.
     */
    bool
    isTimeDependent() const;

    /*!
     * Set the data on the patch interior.
     */
    void
    setDataOnPatch(
        int data_idx,
        SAMRAI::tbox::Pointer<SAMRAI::hier::Variable<NDIM> > var,
        SAMRAI::tbox::Pointer<SAMRAI::hier::Patch<NDIM> > patch,
        double data_time,
        bool initial_time=false,
        SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> > level=SAMRAI::tbox::Pointer<SAMRAI::hier::PatchLevel<NDIM> >(NULL));

    //\}

private:
    /*!
     * \brief Default constructor.
     *
     * \note This constructor is not implemented and should not be used.
     */
    IBEulerianSourceFunction();

    /*!
     * \brief Copy constructor.
     *
     * \note This constructor is not implemented and should not be used.
     *
     * \param from The value to copy to this object.
     */
    IBEulerianSourceFunction(
        const IBEulerianSourceFunction& from);

    /*!
     * \brief Assignment operator.
     *
     * \note This operator is not implemented and should not be used.
     *
     * \param that The value to assign to this object.
     *
     * \return A reference to this object.
     */
    IBEulerianSourceFunction&
    operator=(
        const IBEulerianSourceFunction& that);

    /*!
     * The current and new time for the present timestep.
     */
    double d_current_time, d_new_time;

    /*!
     * Patch data descriptor indices for the current, new, and half-time
     * source/sink data.
     */
    const int d_Q_current_idx, d_Q_new_idx, d_Q_half_idx;
};
}// namespace IBAMR

/////////////////////////////// INLINE ///////////////////////////////////////

//#include <ibamr/IBEulerianSourceFunction.I>

//////////////////////////////////////////////////////////////////////////////

#endif //#ifndef included_IBEulerianSourceFunction
