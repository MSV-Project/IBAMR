c
c     Routines to refine side-centered values.
c
c     Created on 08 Feb 2011 by Boyce Griffith
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
c
c  File:        $URL: file:///usr/casc/samrai/repository/SAMRAI/tags/v-2-4-4/source/patchdata/fortran/pdat_m4arrdim2d.i $
c  Package:     SAMRAI patchdata
c  Copyright:   (c) 1997-2008 Lawrence Livermore National Security, LLC
c  Revision:    $LastChangedRevision: 1917 $
c  Modified:    $LastChangedDate: 2008-01-25 13:28:01 -0800 (Fri, 25 Jan 2008) $
c  Description: m4 include file for dimensioning 2d arrays in FORTRAN routines.
c
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Perform specialized refine operation that employs constant
c     prolongation followed by linear interpolation.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine cart_side_specialized_constant_refine2d(
     &     u0_f,u1_f,u_f_gcw,
     &     flower0,fupper0,
     &     flower1,fupper1,
     &     u0_c,u1_c,u_c_gcw,
     &     clower0,cupper0,
     &     clower1,cupper1,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     fill_lower0,fill_upper0,
     &     fill_lower1,fill_upper1,
     &     ratio)
c
      implicit none
c
c     Input.
c
      integer u_f_gcw
      integer flower0,fupper0
      integer flower1,fupper1
      integer u_c_gcw
      integer clower0,cupper0
      integer clower1,cupper1
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer fill_lower0,fill_upper0
      integer fill_lower1,fill_upper1
      integer ratio(0:2-1)

      double precision u0_c(clower0-u_c_gcw:cupper0+1+u_c_gcw,
     &          clower1-u_c_gcw:cupper1+u_c_gcw)
      double precision u1_c(clower0-u_c_gcw:cupper0+u_c_gcw,
     &          clower1-u_c_gcw:cupper1+1+u_c_gcw)
c
c     Output.
c
      double precision u0_f(flower0-u_f_gcw:fupper0+1+u_f_gcw,
     &          flower1-u_f_gcw:fupper1+u_f_gcw)
      double precision u1_f(flower0-u_f_gcw:fupper0+u_f_gcw,
     &          flower1-u_f_gcw:fupper1+1+u_f_gcw)
c
c     Local variables.
c
      integer i0,i1
      integer i_c0,i_c1
      double precision w0,w1
c
c     Refine data.
c
      do i1=fill_lower1,fill_upper1
                  if (i1.lt.0) then
            i_c1=(i1+1)/ratio(1)-1
         else
            i_c1=i1/ratio(1)
         endif

         do i0=fill_lower0,fill_upper0+1
                     if (i0.lt.0) then
            i_c0=(i0+1)/ratio(0)-1
         else
            i_c0=i0/ratio(0)
         endif

            if ( i0 .ge. ilower0 .and. i0 .le. iupper0+1 .and.
     &           i1 .ge. ilower1 .and. i1 .le. iupper1   ) then
               w1 = dble(i0-ratio(0)*i_c0)/dble(ratio(0))
               w0 = 1.d0-w1
               u0_f(i0,i1) =
     &              w0*u0_c(i_c0  ,i_c1) +
     &              w1*u0_c(i_c0+1,i_c1)
            endif
         enddo
      enddo

      do i1=fill_lower1,fill_upper1+1
                  if (i1.lt.0) then
            i_c1=(i1+1)/ratio(1)-1
         else
            i_c1=i1/ratio(1)
         endif

         do i0=fill_lower0,fill_upper0
                     if (i0.lt.0) then
            i_c0=(i0+1)/ratio(0)-1
         else
            i_c0=i0/ratio(0)
         endif

            if ( i0 .ge. ilower0 .and. i0 .le. iupper0   .and.
     &           i1 .ge. ilower1 .and. i1 .le. iupper1+1 ) then
               w1 = dble(i1-ratio(1)*i_c1)/dble(ratio(1))
               w0 = 1.d0-w1
               u1_f(i0,i1) =
     &              w0*u1_c(i_c0,i_c1  ) +
     &              w1*u1_c(i_c0,i_c1+1)
            endif
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Perform specialized refine operation that employs linear
c     interpolation in the normal direction and MC-limited
c     piecewise-linear interpolation in the tangential direction.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine cart_side_specialized_linear_refine2d(
     &     u0_f,u1_f,u_f_gcw,
     &     flower0,fupper0,
     &     flower1,fupper1,
     &     u0_c,u1_c,u_c_gcw,
     &     clower0,cupper0,
     &     clower1,cupper1,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ratio)
c
      implicit none
c
c     External functions.
c
      double precision minmod3
c
c     Input.
c
      integer u_f_gcw
      integer flower0,fupper0
      integer flower1,fupper1
      integer u_c_gcw
      integer clower0,cupper0
      integer clower1,cupper1
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ratio(0:2-1)

      double precision u0_c(clower0-u_c_gcw:cupper0+1+u_c_gcw,
     &          clower1-u_c_gcw:cupper1+u_c_gcw)
      double precision u1_c(clower0-u_c_gcw:cupper0+u_c_gcw,
     &          clower1-u_c_gcw:cupper1+1+u_c_gcw)
c
c     Output.
c
      double precision u0_f(flower0-u_f_gcw:fupper0+1+u_f_gcw,
     &          flower1-u_f_gcw:fupper1+u_f_gcw)
      double precision u1_f(flower0-u_f_gcw:fupper0+u_f_gcw,
     &          flower1-u_f_gcw:fupper1+1+u_f_gcw)
c
c     Local variables.
c
      integer i0,i1
      integer i_c0,i_c1
      integer i_f0,i_f1
      double precision w0,w1
      double precision dx0,dx1
      double precision du0_dx1,du1_dx0
c
c     Refine data.
c
      dx0 = dble(ratio(0))      ! effective grid spacings on the coarse level
      dx1 = dble(ratio(1))

      do i1=ilower1,iupper1
         do i0=ilower0,iupper0+1
                     if (i0.lt.0) then
            i_c0=(i0+1)/ratio(0)-1
         else
            i_c0=i0/ratio(0)
         endif

                     if (i1.lt.0) then
            i_c1=(i1+1)/ratio(1)-1
         else
            i_c1=i1/ratio(1)
         endif


            i_f0 = i_c0*ratio(0)
            i_f1 = i_c1*ratio(1)

            w0 = 1.d0-dble(i0-i_f0)/dx0
            w1 = dble(i1-i_f1)+0.5d0-0.5d0*dx1

            du0_dx1 = minmod3(
     & 0.5d0*(u0_c(i_c0,i_c1+1)-u0_c(i_c0,i_c1-1)),
     & 2.d0*(u0_c(i_c0,i_c1)-u0_c(i_c0,i_c1-1)),
     & 2.d0*(u0_c(i_c0,i_c1+1)-u0_c(i_c0,i_c1)))/dx1
            u0_f(i0,i1) = w0*(u0_c(i_c0,i_c1)+w1*du0_dx1)

            w0 = 1.d0-w0

            du0_dx1 = minmod3(
     & 0.5d0*(u0_c(i_c0+1,i_c1+1)-u0_c(i_c0+1,i_c1-1)),
     & 2.d0*(u0_c(i_c0+1,i_c1)-u0_c(i_c0+1,i_c1-1)),
     & 2.d0*(u0_c(i_c0+1,i_c1+1)-u0_c(i_c0+1,i_c1)))/dx1
            u0_f(i0,i1) = u0_f(i0,i1)+w0*(u0_c(i_c0+1,i_c1)+w1*du0_dx1)
         enddo
      enddo

      do i1=ilower1,iupper1+1
         do i0=ilower0,iupper0
                     if (i0.lt.0) then
            i_c0=(i0+1)/ratio(0)-1
         else
            i_c0=i0/ratio(0)
         endif

                     if (i1.lt.0) then
            i_c1=(i1+1)/ratio(1)-1
         else
            i_c1=i1/ratio(1)
         endif


            i_f0 = i_c0*ratio(0)
            i_f1 = i_c1*ratio(1)

            w0 = dble(i0-i_f0)+0.5d0-0.5d0*dx0
            w1 = 1.d0-dble(i1-i_f1)/dx1

            du1_dx0 = minmod3(
     & 0.5d0*(u1_c(i_c0+1,i_c1)-u1_c(i_c0-1,i_c1)),
     & 2.d0*(u1_c(i_c0,i_c1)-u1_c(i_c0-1,i_c1)),
     & 2.d0*(u1_c(i_c0+1,i_c1)-u1_c(i_c0,i_c1)))/dx0
            u1_f(i0,i1) = w1*(u1_c(i_c0,i_c1)+w0*du1_dx0)

            w1 = 1.d0-w1

            du1_dx0 = minmod3(
     & 0.5d0*(u1_c(i_c0+1,i_c1+1)-u1_c(i_c0-1,i_c1+1)),
     & 2.d0*(u1_c(i_c0,i_c1+1)-u1_c(i_c0-1,i_c1+1)),
     & 2.d0*(u1_c(i_c0+1,i_c1+1)-u1_c(i_c0,i_c1+1)))/dx0
            u1_f(i0,i1) = u1_f(i0,i1)+w1*(u1_c(i_c0,i_c1+1)+w0*du1_dx0)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
