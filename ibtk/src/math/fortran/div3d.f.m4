c
c     Routines to compute discrete divergences on patches.
c
c     Created on 12 Jun 2003 by Boyce Griffith
c
c     Copyright (c) 2002-2010, Boyce Griffith
c     All rights reserved.
c
c     Redistribution and use in source and binary forms, with or without
c     modification, are permitted provided that the following conditions
c     are met:
c
c        * Redistributions of source code must retain the above
c          copyright notice, this list of conditions and the following
c          disclaimer.
c
c        * Redistributions in binary form must reproduce the above
c          copyright notice, this list of conditions and the following
c          disclaimer in the documentation and/or other materials
c          provided with the distribution.
c
c        * Neither the name of New York University nor the names of its
c          contributors may be used to endorse or promote products
c          derived from this software without specific prior written
c          permission.
c
c     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
c     CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
c     INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
c     MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
c     DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
c     BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
c     EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
c     TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
c     DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON
c     ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
c     TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF
c     THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
c     SUCH DAMAGE.
c
define(NDIM,3)dnl
define(REAL,`double precision')dnl
define(INTEGER,`integer')dnl
include(SAMRAI_FORTDIR/pdat_m4arrdim3d.i)dnl
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes D = alpha div U.
c
c     Uses centered differences to compute the cell centered divergence
c     of a cell centered variable U.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocdiv3d(
     &     D,D_gcw,
     &     alpha,
     &     U,U_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2,
     &     dx)
c
      implicit none
c
c     Input.
c
      INTEGER ilower0,iupper0
      INTEGER ilower1,iupper1
      INTEGER ilower2,iupper2
      INTEGER D_gcw,U_gcw

      REAL alpha

      REAL U(CELL3d(ilower,iupper,U_gcw),0:NDIM-1)

      REAL dx(0:NDIM-1)
c
c     Input/Output.
c
      REAL D(CELL3d(ilower,iupper,D_gcw))
c
c     Local variables.
c
      INTEGER i0,i1,i2
      REAL    fac0,fac1,fac2
c
c     Compute the cell centered divergence of U.
c
      fac0 = alpha/(2.d0*dx(0))
      fac1 = alpha/(2.d0*dx(1))
      fac2 = alpha/(2.d0*dx(2))

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               D(i0,i1,i2) =
     &              fac0*(U(i0+1,i1,i2,0)-U(i0-1,i1,i2,0)) +
     &              fac1*(U(i0,i1+1,i2,1)-U(i0,i1-1,i2,1)) +
     &              fac2*(U(i0,i1,i2+1,2)-U(i0,i1,i2-1,2))
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes D = alpha div U + beta V.
c
c     Uses centered differences to compute the cell centered divergence
c     of a cell centered variable U.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocdivadd3d(
     &     D,D_gcw,
     &     alpha,
     &     U,U_gcw,
     &     beta,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2,
     &     dx)
c
      implicit none
c
c     Input.
c
      INTEGER ilower0,iupper0
      INTEGER ilower1,iupper1
      INTEGER ilower2,iupper2
      INTEGER D_gcw,U_gcw,V_gcw

      REAL alpha

      REAL U(CELL3d(ilower,iupper,U_gcw),0:NDIM-1)

      REAL beta

      REAL V(CELL3d(ilower,iupper,V_gcw))

      REAL dx(0:NDIM-1)
c
c     Input/Output.
c
      REAL D(CELL3d(ilower,iupper,D_gcw))
c
c     Local variables.
c
      INTEGER i0,i1,i2
      REAL    fac0,fac1,fac2
c
c     Compute the cell centered divergence of U.
c
      fac0 = alpha/(2.d0*dx(0))
      fac1 = alpha/(2.d0*dx(1))
      fac2 = alpha/(2.d0*dx(2))

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               D(i0,i1,i2) =
     &              fac0*(U(i0+1,i1,i2,0)-U(i0-1,i1,i2,0)) +
     &              fac1*(U(i0,i1+1,i2,1)-U(i0,i1-1,i2,1)) +
     &              fac2*(U(i0,i1,i2+1,2)-U(i0,i1,i2-1,2)) +
     &              beta*V(i0,i1,i2)
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes D = alpha div u.
c
c     Uses centered differences to compute the cell centered divergence
c     of a face centered variable u=(u0,u1,u2).
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ftocdiv3d(
     &     D,D_gcw,
     &     alpha,
     &     u0,u1,u2,u_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2,
     &     dx)
c
      implicit none
c
c     Input.
c
      INTEGER ilower0,iupper0
      INTEGER ilower1,iupper1
      INTEGER ilower2,iupper2
      INTEGER D_gcw,u_gcw

      REAL alpha

      REAL u0(FACE3d0(ilower,iupper,u_gcw))
      REAL u1(FACE3d1(ilower,iupper,u_gcw))
      REAL u2(FACE3d2(ilower,iupper,u_gcw))

      REAL dx(0:NDIM-1)
c
c     Input/Output.
c
      REAL D(CELL3d(ilower,iupper,D_gcw))
c
c     Local variables.
c
      INTEGER i0,i1,i2
      REAL    fac0,fac1,fac2
c
c     Compute the cell centered divergence of u.
c
      fac0 = alpha/dx(0)
      fac1 = alpha/dx(1)
      fac2 = alpha/dx(2)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               D(i0,i1,i2) =
     &              fac0*(u0(i0+1,i1,i2)-u0(i0,i1,i2)) +
     &              fac1*(u1(i1+1,i2,i0)-u1(i1,i2,i0)) +
     &              fac2*(u2(i2+1,i0,i1)-u2(i2,i0,i1))
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes D = alpha div u + beta V.
c
c     Uses centered differences to compute the cell centered divergence
c     of a face centered variable u=(u0,u1,u2).
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ftocdivadd3d(
     &     D,D_gcw,
     &     alpha,
     &     u0,u1,u2,u_gcw,
     &     beta,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2,
     &     dx)
c
      implicit none
c
c     Input.
c
      INTEGER ilower0,iupper0
      INTEGER ilower1,iupper1
      INTEGER ilower2,iupper2
      INTEGER D_gcw,u_gcw,V_gcw

      REAL alpha

      REAL u0(FACE3d0(ilower,iupper,u_gcw))
      REAL u1(FACE3d1(ilower,iupper,u_gcw))
      REAL u2(FACE3d2(ilower,iupper,u_gcw))

      REAL beta

      REAL V(CELL3d(ilower,iupper,V_gcw))

      REAL dx(0:NDIM-1)
c
c     Input/Output.
c
      REAL D(CELL3d(ilower,iupper,D_gcw))
c
c     Local variables.
c
      INTEGER i0,i1,i2
      REAL    fac0,fac1,fac2
c
c     Compute the cell centered divergence of u.
c
      fac0 = alpha/dx(0)
      fac1 = alpha/dx(1)
      fac2 = alpha/dx(2)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               D(i0,i1,i2) =
     &              fac0*(u0(i0+1,i1,i2)-u0(i0,i1,i2)) +
     &              fac1*(u1(i1+1,i2,i0)-u1(i1,i2,i0)) +
     &              fac2*(u2(i2+1,i0,i1)-u2(i2,i0,i1)) +
     &              beta*V(i0,i1,i2)
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes D = alpha div u.
c
c     Uses centered differences to compute the cell centered divergence
c     of a side centered variable u=(u0,u1,u2).
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine stocdiv3d(
     &     D,D_gcw,
     &     alpha,
     &     u0,u1,u2,u_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2,
     &     dx)
c
      implicit none
c
c     Input.
c
      INTEGER ilower0,iupper0
      INTEGER ilower1,iupper1
      INTEGER ilower2,iupper2
      INTEGER D_gcw,u_gcw

      REAL alpha

      REAL u0(SIDE3d0(ilower,iupper,u_gcw))
      REAL u1(SIDE3d1(ilower,iupper,u_gcw))
      REAL u2(SIDE3d2(ilower,iupper,u_gcw))

      REAL dx(0:NDIM-1)
c
c     Input/Output.
c
      REAL D(CELL3d(ilower,iupper,D_gcw))
c
c     Local variables.
c
      INTEGER i0,i1,i2
      REAL    fac0,fac1,fac2
c
c     Compute the cell centered divergence of u.
c
      fac0 = alpha/dx(0)
      fac1 = alpha/dx(1)
      fac2 = alpha/dx(2)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               D(i0,i1,i2) =
     &              fac0*(u0(i0+1,i1,i2)-u0(i0,i1,i2)) +
     &              fac1*(u1(i0,i1+1,i2)-u1(i0,i1,i2)) +
     &              fac2*(u2(i0,i1,i2+1)-u2(i0,i1,i2))
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes D = alpha div u + beta V.
c
c     Uses centered differences to compute the cell centered divergence
c     of a side centered variable u=(u0,u1,u2).
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine stocdivadd3d(
     &     D,D_gcw,
     &     alpha,
     &     u0,u1,u2,u_gcw,
     &     beta,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2,
     &     dx)
c
      implicit none
c
c     Input.
c
      INTEGER ilower0,iupper0
      INTEGER ilower1,iupper1
      INTEGER ilower2,iupper2
      INTEGER D_gcw,u_gcw,V_gcw

      REAL alpha

      REAL u0(SIDE3d0(ilower,iupper,u_gcw))
      REAL u1(SIDE3d1(ilower,iupper,u_gcw))
      REAL u2(SIDE3d2(ilower,iupper,u_gcw))

      REAL beta

      REAL V(CELL3d(ilower,iupper,V_gcw))

      REAL dx(0:NDIM-1)
c
c     Input/Output.
c
      REAL D(CELL3d(ilower,iupper,D_gcw))
c
c     Local variables.
c
      INTEGER i0,i1,i2
      REAL    fac0,fac1,fac2
c
c     Compute the cell centered divergence of u.
c
      fac0 = alpha/dx(0)
      fac1 = alpha/dx(1)
      fac2 = alpha/dx(2)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               D(i0,i1,i2) =
     &              fac0*(u0(i0+1,i1,i2)-u0(i0,i1,i2)) +
     &              fac1*(u1(i0,i1+1,i2)-u1(i0,i1,i2)) +
     &              fac2*(u2(i0,i1,i2+1)-u2(i0,i1,i2)) +
     &              beta*V(i0,i1,i2)
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
