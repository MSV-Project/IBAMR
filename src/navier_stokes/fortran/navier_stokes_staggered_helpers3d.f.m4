define(NDIM,3)dnl
define(REAL,`double precision')dnl
define(INTEGER,`integer')dnl
include(SAMRAI_FORTDIR/pdat_m4arrdim3d.i)dnl
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Interpolate the components of a staggered velocity field onto the
c     faces of the zones centered about the x-component of the velocity.
c
c     NOTES:
c
c     U0, U1, and U2 are standard side-centered staggered grid
c     velocities for the patch
c     [(ifirst0,ilast0),(ifirst1,ilast1),(ifirst2,ilast2)].
c
c     V00, V01, and V02 are face-centered staggered grid velocities
c     defined at the faces of the control volumes centered about the x
c     components of the side-centered velocity, i.e., face-centered
c     staggered grid velocities for the patch
c     [(ifirst0,ilast0+1),(ifirst1,ilast1),(ifirst2,ilast2)].
c
c     V10, V11, and V12 are face-centered staggered grid velocities
c     defined at the faces of the control volumes centered about the y
c     components of the side-centered velocity, i.e., face-centered
c     staggered grid velocities for the patch
c     [(ifirst0,ilast0),(ifirst1,ilast1+1),(ifirst2,ilast2)].
c
c     V20, V21, and V22 are face-centered staggered grid velocities
c     defined at the faces of the control volumes centered about the z
c     components of the side-centered velocity, i.e., face-centered
c     staggered grid velocities for the patch
c     [(ifirst0,ilast0),(ifirst1,ilast1),(ifirst2,ilast2+1)].
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine navier_stokes_interp_comps3d(
     &     patch_ifirst0,patch_ilast0,
     &     patch_ifirst1,patch_ilast1,
     &     patch_ifirst2,patch_ilast2,
     &     n_U_gc0,n_U_gc1,n_U_gc2,
     &     U0,U1,U2,
     &     side0_ifirst0,side0_ilast0,
     &     side0_ifirst1,side0_ilast1,
     &     side0_ifirst2,side0_ilast2,
     &     n_V0_gc0,n_V0_gc1,n_V0_gc2,
     &     V00,V01,V02,
     &     side1_ifirst0,side1_ilast0,
     &     side1_ifirst1,side1_ilast1,
     &     side1_ifirst2,side1_ilast2,
     &     n_V1_gc0,n_V1_gc1,n_V1_gc2,
     &     V10,V11,V12,
     &     side2_ifirst0,side2_ilast0,
     &     side2_ifirst1,side2_ilast1,
     &     side2_ifirst2,side2_ilast2,
     &     n_V2_gc0,n_V2_gc1,n_V2_gc2,
     &     V20,V21,V22)
c
      implicit none
c
c     Input.
c
      INTEGER patch_ifirst0,patch_ilast0
      INTEGER patch_ifirst1,patch_ilast1
      INTEGER patch_ifirst2,patch_ilast2

      INTEGER n_U_gc0,n_U_gc1,n_U_gc2

      INTEGER side0_ifirst0,side0_ilast0
      INTEGER side0_ifirst1,side0_ilast1
      INTEGER side0_ifirst2,side0_ilast2

      INTEGER n_V0_gc0,n_V0_gc1,n_V0_gc2

      INTEGER side1_ifirst0,side1_ilast0
      INTEGER side1_ifirst1,side1_ilast1
      INTEGER side1_ifirst2,side1_ilast2

      INTEGER n_V1_gc0,n_V1_gc1,n_V1_gc2

      INTEGER side2_ifirst0,side2_ilast0
      INTEGER side2_ifirst1,side2_ilast1
      INTEGER side2_ifirst2,side2_ilast2

      INTEGER n_V2_gc0,n_V2_gc1,n_V2_gc2

      REAL U0(
     &     SIDE3d0VECG(patch_ifirst,patch_ilast,n_U_gc)
     &     )
      REAL U1(
     &     SIDE3d1VECG(patch_ifirst,patch_ilast,n_U_gc)
     &     )
      REAL U2(
     &     SIDE3d2VECG(patch_ifirst,patch_ilast,n_U_gc)
     &     )
c
c     Input/Output.
c
      REAL V00(
     &     FACE3d0VECG(side0_ifirst,side0_ilast,n_V0_gc)
     &     )
      REAL V01(
     &     FACE3d1VECG(side0_ifirst,side0_ilast,n_V0_gc)
     &     )
      REAL V02(
     &     FACE3d2VECG(side0_ifirst,side0_ilast,n_V0_gc)
     &     )
      REAL V10(
     &     FACE3d0VECG(side1_ifirst,side1_ilast,n_V1_gc)
     &     )
      REAL V11(
     &     FACE3d1VECG(side1_ifirst,side1_ilast,n_V1_gc)
     &     )
      REAL V12(
     &     FACE3d2VECG(side1_ifirst,side1_ilast,n_V1_gc)
     &     )
      REAL V20(
     &     FACE3d0VECG(side2_ifirst,side2_ilast,n_V2_gc)
     &     )
      REAL V21(
     &     FACE3d1VECG(side2_ifirst,side2_ilast,n_V2_gc)
     &     )
      REAL V22(
     &     FACE3d2VECG(side2_ifirst,side2_ilast,n_V2_gc)
     &     )
c
c     Local variables.
c
      INTEGER i0,i1,i2
      INTEGER gc0,gc1,gc2
c
c     Interpolate the components of the velocity at each zone face.
c
      gc0 = min(n_U_gc0-1,n_V0_gc0)
      gc1 = min(n_U_gc1  ,n_V0_gc1)
      gc2 = min(n_U_gc2  ,n_V0_gc2)

      do       i2 = side0_ifirst2-gc2,side0_ilast2+gc2
         do    i1 = side0_ifirst1-gc1,side0_ilast1+gc1
            do i0 = side0_ifirst0-gc0,side0_ilast0+gc0
               V00(i0,i1,i2) = 0.5d0*(U0(i0-1,i1,i2)+U0(i0,i1,i2))
               V01(i1,i2,i0) = 0.5d0*(U1(i0-1,i1,i2)+U1(i0,i1,i2))
               V02(i2,i0,i1) = 0.5d0*(U2(i0-1,i1,i2)+U2(i0,i1,i2))
            enddo
         enddo
      enddo

      gc0 = min(n_U_gc0  ,n_V1_gc0)
      gc1 = min(n_U_gc1-1,n_V1_gc1)
      gc2 = min(n_U_gc2  ,n_V1_gc2)

      do       i0 = side1_ifirst0-gc0,side1_ilast0+gc0
         do    i2 = side1_ifirst2-gc2,side1_ilast2+gc2
            do i1 = side1_ifirst1-gc1,side1_ilast1+gc1
               V10(i0,i1,i2) = 0.5d0*(U0(i0,i1-1,i2)+U0(i0,i1,i2))
               V11(i1,i2,i0) = 0.5d0*(U1(i0,i1-1,i2)+U1(i0,i1,i2))
               V12(i2,i0,i1) = 0.5d0*(U2(i0,i1-1,i2)+U2(i0,i1,i2))
            enddo
         enddo
      enddo

      gc0 = min(n_U_gc0  ,n_V2_gc0)
      gc1 = min(n_U_gc1  ,n_V2_gc1)
      gc2 = min(n_U_gc2-1,n_V2_gc2)

      do       i1 = side2_ifirst1-gc1,side2_ilast1+gc1
         do    i0 = side2_ifirst0-gc0,side2_ilast0+gc0
            do i2 = side2_ifirst2-gc2,side2_ilast2+gc2
               V20(i0,i1,i2) = 0.5d0*(U0(i0,i1,i2-1)+U0(i0,i1,i2))
               V21(i1,i2,i0) = 0.5d0*(U1(i0,i1,i2-1)+U1(i0,i1,i2))
               V22(i2,i0,i1) = 0.5d0*(U2(i0,i1,i2-1)+U2(i0,i1,i2))
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Reset the face-centered advection velocity about the control
c     volumes for each component of the velocity.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine navier_stokes_reset_adv_velocity3d(
     &     side0_ifirst0,side0_ilast0,
     &     side0_ifirst1,side0_ilast1,
     &     side0_ifirst2,side0_ilast2,
     &     n_U_adv0_gc0,n_U_adv0_gc1,n_U_adv0_gc2,
     &     U_adv00,U_adv01,U_adv02,
     &     n_U_half0_gc0,n_U_half0_gc1,n_U_half0_gc2,
     &     U_half00,U_half01,U_half02,
     &     side1_ifirst0,side1_ilast0,
     &     side1_ifirst1,side1_ilast1,
     &     side1_ifirst2,side1_ilast2,
     &     n_U_adv1_gc0,n_U_adv1_gc1,n_U_adv1_gc2,
     &     U_adv10,U_adv11,U_adv12,
     &     n_U_half1_gc0,n_U_half1_gc1,n_U_half1_gc2,
     &     U_half10,U_half11,U_half12,
     &     side2_ifirst0,side2_ilast0,
     &     side2_ifirst1,side2_ilast1,
     &     side2_ifirst2,side2_ilast2,
     &     n_U_adv2_gc0,n_U_adv2_gc1,n_U_adv2_gc2,
     &     U_adv20,U_adv21,U_adv22,
     &     n_U_half2_gc0,n_U_half2_gc1,n_U_half2_gc2,
     &     U_half20,U_half21,U_half22)
c
      implicit none
c
c     Input.
c
      INTEGER side0_ifirst0,side0_ilast0
      INTEGER side0_ifirst1,side0_ilast1
      INTEGER side0_ifirst2,side0_ilast2

      INTEGER n_U_adv0_gc0,n_U_adv0_gc1,n_U_adv0_gc2
      INTEGER n_U_half0_gc0,n_U_half0_gc1,n_U_half0_gc2

      INTEGER side1_ifirst0,side1_ilast0
      INTEGER side1_ifirst1,side1_ilast1
      INTEGER side1_ifirst2,side1_ilast2

      INTEGER n_U_adv1_gc0,n_U_adv1_gc1,n_U_adv1_gc2
      INTEGER n_U_half1_gc0,n_U_half1_gc1,n_U_half1_gc2

      INTEGER side2_ifirst0,side2_ilast0
      INTEGER side2_ifirst1,side2_ilast1
      INTEGER side2_ifirst2,side2_ilast2

      INTEGER n_U_adv2_gc0,n_U_adv2_gc1,n_U_adv2_gc2
      INTEGER n_U_half2_gc0,n_U_half2_gc1,n_U_half2_gc2

      REAL U_half00(
     &     FACE3d0VECG(side0_ifirst,side0_ilast,n_U_half0_gc)
     &     )
      REAL U_half01(
     &     FACE3d1VECG(side0_ifirst,side0_ilast,n_U_half0_gc)
     &     )
      REAL U_half02(
     &     FACE3d2VECG(side0_ifirst,side0_ilast,n_U_half0_gc)
     &     )
      REAL U_half10(
     &     FACE3d0VECG(side1_ifirst,side1_ilast,n_U_half1_gc)
     &     )
      REAL U_half11(
     &     FACE3d1VECG(side1_ifirst,side1_ilast,n_U_half1_gc)
     &     )
      REAL U_half12(
     &     FACE3d2VECG(side1_ifirst,side1_ilast,n_U_half1_gc)
     &     )
      REAL U_half20(
     &     FACE3d0VECG(side2_ifirst,side2_ilast,n_U_half2_gc)
     &     )
      REAL U_half21(
     &     FACE3d1VECG(side2_ifirst,side2_ilast,n_U_half2_gc)
     &     )
      REAL U_half22(
     &     FACE3d2VECG(side2_ifirst,side2_ilast,n_U_half2_gc)
     &     )
c
c     Input/Output.
c
      REAL U_adv00(
     &     FACE3d0VECG(side0_ifirst,side0_ilast,n_U_adv0_gc)
     &     )
      REAL U_adv01(
     &     FACE3d1VECG(side0_ifirst,side0_ilast,n_U_adv0_gc)
     &     )
      REAL U_adv02(
     &     FACE3d2VECG(side0_ifirst,side0_ilast,n_U_adv0_gc)
     &     )
      REAL U_adv10(
     &     FACE3d0VECG(side1_ifirst,side1_ilast,n_U_adv1_gc)
     &     )
      REAL U_adv11(
     &     FACE3d1VECG(side1_ifirst,side1_ilast,n_U_adv1_gc)
     &     )
      REAL U_adv12(
     &     FACE3d2VECG(side1_ifirst,side1_ilast,n_U_adv1_gc)
     &     )
      REAL U_adv20(
     &     FACE3d0VECG(side2_ifirst,side2_ilast,n_U_adv2_gc)
     &     )
      REAL U_adv21(
     &     FACE3d1VECG(side2_ifirst,side2_ilast,n_U_adv2_gc)
     &     )
      REAL U_adv22(
     &     FACE3d2VECG(side2_ifirst,side2_ilast,n_U_adv2_gc)
     &     )
c
c     Local variables.
c
      INTEGER i0,i1,i2
      INTEGER gc0,gc1,gc2
c
c     Reset the advection velocity.
c
      gc0 = min(n_U_adv0_gc0,n_U_adv1_gc0,n_U_adv2_gc0,
     &     n_U_half0_gc0,n_U_half1_gc0,n_U_half2_gc0)
      gc1 = min(n_U_adv0_gc1,n_U_adv1_gc1,n_U_adv2_gc1,
     &     n_U_half0_gc1,n_U_half1_gc1,n_U_half2_gc1)
      gc2 = min(n_U_adv0_gc2,n_U_adv1_gc2,n_U_adv2_gc2,
     &     n_U_half0_gc2,n_U_half1_gc2,n_U_half2_gc2)

      do       i2 = side0_ifirst2-gc2,side0_ilast2+gc2
         do    i1 = side0_ifirst1-gc1,side0_ilast1+gc1
            do i0 = side0_ifirst0-gc0,side0_ilast0+gc0
               U_adv00(i0,i1,i2) = U_half00(i0,i1,i2)
               U_adv01(i1,i2,i0) = U_half10(i0,i1,i2)
               U_adv02(i2,i0,i1) = U_half20(i0,i1,i2)
            enddo
         enddo
      enddo

      do       i2 = side1_ifirst2-gc2,side1_ilast2+gc2
         do    i1 = side1_ifirst1-gc1,side1_ilast1+gc1
            do i0 = side1_ifirst0-gc0,side1_ilast0+gc0
               U_adv10(i0,i1,i2) = U_half01(i1,i2,i0)
               U_adv11(i1,i2,i0) = U_half11(i1,i2,i0)
               U_adv12(i2,i0,i1) = U_half21(i1,i2,i0)
            enddo
         enddo
      enddo

      do       i2 = side2_ifirst2-gc2,side2_ilast2+gc2
         do    i1 = side2_ifirst1-gc1,side2_ilast1+gc1
            do i0 = side2_ifirst0-gc0,side2_ilast0+gc0
               U_adv20(i0,i1,i2) = U_half02(i2,i0,i1)
               U_adv21(i1,i2,i0) = U_half12(i2,i0,i1)
               U_adv22(i2,i0,i1) = U_half22(i2,i0,i1)
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
