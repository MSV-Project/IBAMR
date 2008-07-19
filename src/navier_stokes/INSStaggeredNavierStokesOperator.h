#ifndef included_INSStaggeredNavierStokesOperator
#define included_INSStaggeredNavierStokesOperator

// Filename: INSStaggeredNavierStokesOperator.h
// Last modified: <17.Jul.2008 15:23:27 griffith@box230.cims.nyu.edu>
// Created on 08 May 2008 by Boyce Griffith (griffith@box230.cims.nyu.edu)

/////////////////////////////// INCLUDES /////////////////////////////////////

// IBAMR INCLUDES
#include <ibamr/INSStaggeredConvectiveOperator.h>
#include <ibamr/INSStaggeredStokesOperator.h>

// IBTK INCLUDES
#include <ibtk/GeneralOperator.h>
#include <ibtk/HierarchyGhostCellInterpolation.h>
#include <ibtk/HierarchyMathOps.h>

/////////////////////////////// CLASS DEFINITION /////////////////////////////

namespace IBAMR
{
/*!
 * \brief Class INSStaggeredNavierStokesOperator is a concrete
 * IBTK::GeneralOperator which implements a fully coupled staggered grid (MAC)
 * discretization of the incompressible Navier-Stokes equations.
 *
 * This operator is intended to be used with an iterative (Newton-Krylov)
 * nonlinear solver.
 *
 * \see INSStaggeredHierarchyIntegrator
 */
class INSStaggeredNavierStokesOperator
    : public IBTK::GeneralOperator
{
public:
    /*!
     * \brief Class constructor.
     */
    INSStaggeredNavierStokesOperator(
        const double rho,
        const double mu,
        const double lambda,
        SAMRAI::tbox::Pointer<INSStaggeredStokesOperator> stokes_op,
        SAMRAI::tbox::Pointer<INSStaggeredConvectiveOperator> convective_op,
        SAMRAI::tbox::Pointer<SAMRAI::math::HierarchySideDataOpsReal<NDIM,double> > hier_sc_data_ops);

    /*!
     * \brief Virtual destructor.
     */
    virtual
    ~INSStaggeredNavierStokesOperator();

    /*!
     * \brief Set the patch data index corresponding to the current velocity.
     */
    void
    setVelocityCurrentPatchDataIndex(
        const int U_current_idx);

    /*!
     * \name General operator functionality.
     */
    //\{

    /*!
     * \brief Compute \f$y=F[x]\f$.
     *
     * Before calling apply(), the form of the vectors \a x and \a y should be
     * set properly by the user on all patch interiors on the specified range of
     * levels in the patch hierarchy.  The user is responsible for all data
     * management for the quantities associated with the vectors.  In
     * particular, patch data in these vectors must be allocated prior to
     * calling this method.
     *
     * \param x input vector
     * \param y output vector, i.e., \f$y=F[x]\f$
     *
     * <b>Conditions on Parameters:</b>
     * - vectors \a x and \a y must have same hierarchy
     * - vectors \a x and \a y must have same structure, depth, etc.
     *
     * In general, the vectors \a x and \a y \em cannot be the same.
     *
     * \see initializeOperatorState
     */
    virtual void
    apply(
        SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& x,
        SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& y);

    /*!
     * \brief Compute hierarchy dependent data required for computing y=F[x] and
     * z=F[x]+y.
     *
     * The vector arguments for apply(), applyAdjoint(), etc, need not match
     * those for initializeOperatorState().  However, there must be a certain
     * degree of similarity, including
     * - hierarchy configuration (hierarchy pointer and level range)
     * - number, type and alignment of vector component data
     * - ghost cell widths of data in the input and output vectors
     *
     * \note It is generally necessary to reinitialize the operator state when
     * the hierarchy configuration changes.
     *
     * It is safe to call initializeOperatorState() when the state is already
     * initialized.  In this case, the operator state is first deallocated and
     * then reinitialized.
     *
     * Conditions on arguments:
     * - input and output vectors must have same hierarchy
     * - input and output vectors must have same structure, depth, etc.
     *
     * Call deallocateOperatorState() to remove any data allocated by this
     * method.
     *
     * \see deallocateOperatorState
     *
     * \param in input vector
     * \param out output vector
     */
    virtual void
    initializeOperatorState(
        const SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& in,
        const SAMRAI::solv::SAMRAIVectorReal<NDIM,double>& out);

    /*!
     * \brief Remove all hierarchy dependent data allocated by
     * initializeOperatorState().
     *
     * \note It is safe to call deallocateOperatorState() when the operator
     * state is already deallocated.
     *
     * \see initializeOperatorState
     */
    virtual void
    deallocateOperatorState();

    //\}

    /*!
     * \name Logging functions.
     */
    //\{

    /*!
     * \brief Enable or disable logging.
     *
     * \param enabled logging state: true=on, false=off
     */
    virtual void
    enableLogging(
        bool enabled=true);

    /*!
     * \brief Print out internal class data for debugging.
     */
    virtual void
    printClassData(
        std::ostream& os) const;

    //\}

private:
    /*!
     * \brief Default constructor.
     *
     * \note This constructor is not implemented and should not be used.
     */
    INSStaggeredNavierStokesOperator();

    /*!
     * \brief Copy constructor.
     *
     * \note This constructor is not implemented and should not be used.
     *
     * \param from The value to copy to this object.
     */
    INSStaggeredNavierStokesOperator(
        const INSStaggeredNavierStokesOperator& from);

    /*!
     * \brief Assignment operator.
     *
     * \note This operator is not implemented and should not be used.
     *
     * \param that The value to assign to this object.
     *
     * \return A reference to this object.
     */
    INSStaggeredNavierStokesOperator&
    operator=(
        const INSStaggeredNavierStokesOperator& that);

    // Whether the operator is initialized.
    bool d_is_initialized;

    // The current velocity.
    int d_U_current_idx;

    // Problem coefficients.
    const double d_rho;
    const double d_mu;
    const double d_lambda;

    // The linear part of the problem.
    SAMRAI::tbox::Pointer<INSStaggeredStokesOperator> d_stokes_op;

    // The nonlinear part of the problem.
    SAMRAI::tbox::Pointer<INSStaggeredConvectiveOperator> d_convective_op;

    // Math objects.
    SAMRAI::tbox::Pointer<SAMRAI::math::HierarchySideDataOpsReal<NDIM,double> > d_hier_sc_data_ops;

    // Scratch data.
    SAMRAI::tbox::Pointer<SAMRAI::solv::SAMRAIVectorReal<NDIM,double> > d_x_scratch, d_y_scratch;
};
}// namespace IBAMR

/////////////////////////////// INLINE ///////////////////////////////////////

//#include <ibamr/INSStaggeredNavierStokesOperator.I>

//////////////////////////////////////////////////////////////////////////////

#endif //#ifndef included_INSStaggeredNavierStokesOperator
