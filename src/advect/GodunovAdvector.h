// Filename: GodunovAdvector.h
// Created on 14 Feb 2004 by Boyce Griffith
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

#ifndef included_GodunovAdvector
#define included_GodunovAdvector

/////////////////////////////// INCLUDES /////////////////////////////////////

// SAMRAI INCLUDES
#include <CellData.h>
#include <FaceData.h>
#include <Patch.h>
#include <tbox/Database.h>
#include <tbox/Pointer.h>
#include <tbox/Serializable.h>

// C++ STDLIB INCLUDES
#include <ostream>
#include <string>

/////////////////////////////// CLASS DEFINITION /////////////////////////////

namespace IBAMR
{
/*!
 * \brief TODO: update. Class GodunovAdvector provides patch-based operations required to
 * implement a second-order Godunov method for the linear advection equation in
 * conservative and non-conservative forms.
 *
 * Class GodunovAdvector implements the predictors required to use an explicit
 * predictor-corrector method to solve the \em non-conservative advection
 * equation, \f[
 *
 *      \frac{dQ}{dt} + (\vec{u}^{\mbox{\scriptsize ADV}} \cdot \nabla)Q = F,
 *
 * \f] where \f$Q\f$ is a cell-centered quantity, \f$\vec{u}^{\mbox{\scriptsize
 * ADV}}\f$ is a specified face-centered advection velocity, and \f$F\f$ is an
 * optional source term.  These methods can also be used to solve the advection
 * equation in \em conservation form, \f[
 *
 *      \frac{dQ}{dt} + \nabla \cdot (\vec{u}^{\mbox{\scriptsize ADV}} Q) = F.
 *
 * \f]
 *
 * The class employs an upwind (Godunov) explicit predictor which can be used to
 * generate time and face centered values or fluxes.  These predicted values
 * can be used in a second-order accurate predictor-corrector method for solving
 * the advection equation, as well as related problems such as the
 * advection-diffusion equation and the equations of incompressible flow.
 *
 * Note that the predicted fluxes are computed using the \em non-conservative
 * form of the advection equation.  Consequently, when the advection velocity
 * \f$\vec{u}\f$ is not discretely divergence free, the appropriate
 * non-conservative form of the source term must be supplied to the predictor
 * in-order to obtain a formally consistent method.
 *
 * \see IBAMR::GodunovHypPatchOps
 */
class GodunovAdvector
    : public SAMRAI::tbox::Serializable
{
public:
    /*!
     * The constructor for GodunovAdvector sets default parameters for the
     * advection predictor.  The constructor also registers this object for
     * restart with the restart manager using the object name.
     *
     * After default values are set, this routine calls getFromRestart() if
     * execution from a restart file is specified.  Finally, getFromInput() is
     * called to read values from the given input database (potentially
     * overriding those found in the restart file).
     */
    GodunovAdvector(
        const std::string& object_name,
        SAMRAI::tbox::Pointer<SAMRAI::tbox::Database> input_db,
        bool register_for_restart=true);

    /*!
     * The destructor for GodunovAdvector unregisters the predictor object with
     * the restart manager when so registered.
     */
    virtual
    ~GodunovAdvector();

    /*!
     * Return the name of the patch operations object.
     */
    const std::string&
    getName() const;

    /*!
     * Return the number of ghost cells for cell-
     * centered data.
     */
    virtual SAMRAI::hier::IntVector<NDIM>
    getNumberOfCellGhosts() const = 0;

    /*!
     * Returns the number of ghost cells for flux
     * data (which are face-centered).
     */
    virtual SAMRAI::hier::IntVector<NDIM>
    getNumberOfFluxGhosts() const = 0;

    /*!
     * \brief Compute the maximum stable time increment for the patch.
     *
     * \return The maximum stable timestep.
     */
    double
    computeStableDtOnPatch(
        const SAMRAI::pdat::FaceData<NDIM,double>& u_ADV,
        const SAMRAI::hier::Patch<NDIM>& patch) const;

    /*!
     * \brief Compute the advective derivative \f$ \vec{N}^{n+\frac{1}{2}} =
     * \vec{u}^{\mbox{\scriptsize ADV},n+\frac{1}{2}} \cdot \nabla
     * q^{n+\frac{1}{2}} \f$ using the specified advection velocity and
     * predicted face-centered values.
     */
    void
    computeAdvectiveDerivative(
        SAMRAI::pdat::CellData<NDIM,double>& N,
        const SAMRAI::pdat::FaceData<NDIM,double>& u_ADV,
        const SAMRAI::pdat::FaceData<NDIM,double>& q_half,
        const SAMRAI::hier::Patch<NDIM>& patch) const;

    /*!
     * \brief Compute the time integral of the advective fluxes \f$ \vec{f} \f$
     * corresponding to a face-centered value \f$ q \f$ and a MAC advection
     * velocity \f$ \vec{u}^{\mbox{\scriptsize ADV}} \f$.
     *
     * In three spatial dimensions, the face-centered advective fluxes \f$
     * \vec{f} \f$ are defined by \f{eqnarray*}
     *
     *     f_{i+\frac{1}{2},j,k}^{n+\frac{1}{2}} &=& \Delta t \, u_{i+\frac{1}{2},j,k}^{\mbox{\scriptsize ADV},n+\frac{1}{2}} \, q_{i+\frac{1}{2},j,k}^{n+\frac{1}{2}} \\
     *     f_{i,j+\frac{1}{2},k}^{n+\frac{1}{2}} &=& \Delta t \, v_{i,j+\frac{1}{2},k}^{\mbox{\scriptsize ADV},n+\frac{1}{2}} \, q_{i,j+\frac{1}{2},k}^{n+\frac{1}{2}} \\
     *     f_{i,j,k+\frac{1}{2}}^{n+\frac{1}{2}} &=& \Delta t \, w_{i,j,k+\frac{1}{2}}^{\mbox{\scriptsize ADV},n+\frac{1}{2}} \, q_{i,j,k+\frac{1}{2}}^{n+\frac{1}{2}}
     *
     * \f} where \f$ \vec{u}^{\mbox{\scriptsize ADV}} = (u^{\mbox{\scriptsize
     * ADV}},v^{\mbox{\scriptsize ADV}},w^{\mbox{\scriptsize ADV}}) \f$ is the
     * MAC advection velocity.  Analogous formulae hold in other spatial
     * dimensions.
     */
    void
    computeFlux(
        SAMRAI::pdat::FaceData<NDIM,double>& flux,
        const SAMRAI::pdat::FaceData<NDIM,double>& u_ADV,
        const SAMRAI::pdat::FaceData<NDIM,double>& q_half,
        const SAMRAI::hier::Patch<NDIM>& patch,
        double dt) const;

    /*!
     * \brief Compute predicted time- and face-centered values from
     * cell-centered values using a second-order Godunov method (\em non-forced
     * version).
     *
     * The predictor assumes that \f$ Q \f$ satisfies an equation of the form
     * \f[
     *
     *      \frac{dQ}{dt} + (\vec{u}^{\mbox{\scriptsize ADV}} \cdot \nabla)Q = 0,
     *
     * \f] i.e., that \f$ Q \f$ satisfies the advection equation in \em
     * non-conservative form.
     *
     * Note that if the advection velocity is not discretely divergence free,
     * and if the predicted velocities are to be conservatively differenced
     * (i.e. used in a discretization of the conservative form of the equation),
     * a consistent method is obtained only when the proper source terms are
     * included
     *
     * \see predictValueWithSourceTerm
     */
    virtual void
    predictValue(
        SAMRAI::pdat::FaceData<NDIM,double>& q_half,
        const SAMRAI::pdat::FaceData<NDIM,double>& u_ADV,
        const SAMRAI::pdat::CellData<NDIM,double>& Q,
        const SAMRAI::hier::Patch<NDIM>& patch,
        double dt) const;

    /*!
     * \brief Compute predicted time- and face-centered values from
     * cell-centered values using a second-order Godunov method (\em forced
     * version).
     *
     * The predictor assumes that \f$ Q \f$ satisfies an equation of the form
     * \f[
     *
     *      \frac{dQ}{dt} + (\vec{u}^{\mbox{\scriptsize ADV}} \cdot \nabla)Q = F,
     *
     * \f] i.e., that \f$ Q \f$ satisfies the \em forced advection equation in
     * \em non-conservative form.
     *
     * Note that if the advection velocity is not discretely divergence free,
     * and if the predicted velocities are to be conservatively differenced
     * (i.e. used in a discretization of the conservative form of the equation),
     * a consistent method is obtained only when the proper source terms are
     * included
     *
     * \see predictValue
     */
    virtual void
    predictValueWithSourceTerm(
        SAMRAI::pdat::FaceData<NDIM,double>& q_half,
        const SAMRAI::pdat::FaceData<NDIM,double>& u_ADV,
        const SAMRAI::pdat::CellData<NDIM,double>& Q,
        const SAMRAI::pdat::CellData<NDIM,double>& F,
        const SAMRAI::hier::Patch<NDIM>& patch,
        double dt) const;

    /*!
     * \brief Compute predicted time- and face-centered MAC velocities from a
     * cell-centered velocity field using a second-order Godunov method (\em
     * non-forced version).
     *
     * The predictor assumes that \f$ \vec{V} \f$ satisfies an equation of the
     * form \f[
     *
     *      \frac{d\vec{V}}{dt} + (\vec{u}^{\mbox{\scriptsize ADV}} \cdot \nabla)\vec{V} = 0,
     *
     * \f] i.e., that \f$ \vec{V} \f$ satisfies the advection equation in \em
     * non-conservative form.
     *
     * Note that if the advection velocity is not discretely divergence free,
     * and if the predicted velocities are to be conservatively differenced
     * (i.e. used in a discretization of the conservative form of the equation),
     * a consistent method is obtained only when the proper source terms are
     * included
     *
     * \see predictNormalVelocityWithSourceTerm
     */
    virtual void
    predictNormalVelocity(
        SAMRAI::pdat::FaceData<NDIM,double>& v_half,
        const SAMRAI::pdat::FaceData<NDIM,double>& u_ADV,
        const SAMRAI::pdat::CellData<NDIM,double>& V,
        const SAMRAI::hier::Patch<NDIM>& patch,
        double dt) const;

    /*!
     * \brief Compute predicted time- and face-centered MAC velocities from a
     * cell-centered velocity using a second-order Godunov method (\em forced
     * version).
     *
     * The predictor assumes that \f$ \vec{V} \f$ satisfies an equation of the
     * form \f[
     *
     *      \frac{d\vec{V}}{dt} + (\vec{u}^{\mbox{\scriptsize ADV}} \cdot \nabla)\vec{V} = \vec{F},
     *
     * \f] i.e., that \f$ \vec{V} \f$ satisfies the \em forced advection
     * equation in \em non-conservative form.
     *
     * Note that if the advection velocity is not discretely divergence free,
     * and if the predicted velocities are to be conservatively differenced
     * (i.e. used in a discretization of the conservative form of the equation),
     * a consistent method is obtained only when the proper source terms are
     * included
     *
     * \see predictNormalVelocity
     */
    virtual void
    predictNormalVelocityWithSourceTerm(
        SAMRAI::pdat::FaceData<NDIM,double>& v_half,
        const SAMRAI::pdat::FaceData<NDIM,double>& u_ADV,
        const SAMRAI::pdat::CellData<NDIM,double>& V,
        const SAMRAI::pdat::CellData<NDIM,double>& F,
        const SAMRAI::hier::Patch<NDIM>& patch,
        double dt) const;

    /*!
     * \brief Write state of GodunovAdvector object to the given database for
     * restart.
     *
     * This routine is a concrete implementation of the function declared in the
     * SAMRAI::tbox::Serializable abstract base class.
     */
    void
    putToDatabase(
        SAMRAI::tbox::Pointer<SAMRAI::tbox::Database> db);

protected:
    /*
     * Protected pure virtual functions used to compute the predicted values/fluxes.
     */
    virtual void
    predict(
        SAMRAI::pdat::FaceData<NDIM,double>& q_half,
        const SAMRAI::pdat::FaceData<NDIM,double>& u_ADV,
        const SAMRAI::pdat::CellData<NDIM,double>& Q,
        const SAMRAI::hier::Patch<NDIM>& patch,
        double dt) const = 0;
    virtual void
    predictWithSourceTerm(
        SAMRAI::pdat::FaceData<NDIM,double>& q_half,
        const SAMRAI::pdat::FaceData<NDIM,double>& u_ADV,
        const SAMRAI::pdat::CellData<NDIM,double>& Q,
        const SAMRAI::pdat::CellData<NDIM,double>& F,
        const SAMRAI::hier::Patch<NDIM>& patch,
        double dt) const = 0;

    /*
     * These protected member functions read data from input and restart.  When
     * beginning a run from a restart file, all data members are read from the
     * restart file.  If the boolean flag is true when reading from input, some
     * restart values may be overridden by those in the input file.
     *
     * An assertion results if the database pointer is null.
     */
    virtual void
    getFromInput(
        SAMRAI::tbox::Pointer<SAMRAI::tbox::Database> db,
        bool is_from_restart);
    virtual void
    getFromRestart();

    /*
     * The object name is used as a handle to databases stored in restart files
     * and for error reporting purposes.  The boolean is used to control restart
     * file writing operations.
     */
    std::string d_object_name;
    bool d_registered_for_restart;


private:
    /*!
     * \brief Default constructor.
     *
     * \note This constructor is not implemented and should not be used.
     */
    GodunovAdvector();

    /*!
     * \brief Copy constructor.
     *
     * \note This constructor is not implemented and should not be used.
     *
     * \param from The value to copy to this object.
     */
    GodunovAdvector(
        const GodunovAdvector& from);

    /*!
     * \brief Assignment operator.
     *
     * \note This operator is not implemented and should not be used.
     *
     * \param that The value to assign to this object.
     *
     * \return A reference to this object.
     */
    GodunovAdvector&
    operator=(
        const GodunovAdvector& that);

};
}// namespace IBAMR

/////////////////////////////// INLINE ///////////////////////////////////////

//#include <ibamr/GodunovAdvector.I>

//////////////////////////////////////////////////////////////////////////////

#endif //#ifndef included_GodunovAdvector
