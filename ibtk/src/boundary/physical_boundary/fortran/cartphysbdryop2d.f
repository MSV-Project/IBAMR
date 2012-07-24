c
c     Routines to set physical boundary condition values.
c
c     Created on 21 May 2007 by Boyce Griffith
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
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     For cell centered values, we follow a similar approach as that
c     implemented in class SAMRAI::solv::CartesianRobinBcHelper.
c     Namely, with u_i denoting the interior cell, u_o denoting the
c     ghost cell, and u_b and u_n denoting the value and normal
c     derivative of u at the boundary,
c
c          u_b = (u_i + u_o)/2   and   u_n = (u_o - u_i)/h
c
c     Now, if
c
c          a*u_b + b*u_n = g
c
c     then
c
c          u_o = u_i*(-(a*h - 2*b)/(a*h + 2*b)) + g*(2*h/(a*h + 2*b))
c
c     For side centered values, we follow a similar approach.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Set cell centered boundary values using the supplied Robin
c     coefficients along the codimension 1 upper/lower x boundary.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ccrobinphysbdryop1x2d(
     &     U,U_gcw,
     &     acoef,bcoef,gcoef,
     &     location_index,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     blower1,bupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer U_gcw

      integer location_index

      integer ilower0,iupper0
      integer ilower1,iupper1

      integer blower1,bupper1

      double precision acoef(blower1:bupper1)
      double precision bcoef(blower1:bupper1)
      double precision gcoef(blower1:bupper1)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)
c
c     Local variables.
c
      integer i,i_g,i_i
      integer j
      integer sgn
      double precision    a,b,g,u_b,u_i
c
c     Set values along the upper/lower x side of the patch.
c
      if ( (location_index .eq. 0) .or.
     &     (location_index .eq. 1) ) then

         if (location_index .eq. 0) then
            sgn = -1
            i_g = ilower0-1     ! ghost    index
            i_i = ilower0       ! interior index
         else
            sgn = +1
            i_g = iupper0+1     ! ghost    index
            i_i = iupper0       ! interior index
         endif

         do j = blower1,bupper1
            a = acoef(j)
            b = bcoef(j)
            g = gcoef(j)

            u_i = U(i_i,j)
            u_b = (2.d0*b*u_i+g*dx(0))/(a*dx(0)+2.d0*b)

            do i = 0,U_gcw-1
               u_i = U(i_i-sgn*i,j)
               U(i_g+sgn*i,j) = 2.d0*u_b-u_i
            enddo
         enddo

      endif
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Set cell centered boundary values using the supplied Robin
c     coefficients along the codimension 1 upper/lower y boundary.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ccrobinphysbdryop1y2d(
     &     U,U_gcw,
     &     acoef,bcoef,gcoef,
     &     location_index,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     blower0,bupper0,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer U_gcw

      integer location_index

      integer ilower0,iupper0
      integer ilower1,iupper1

      integer blower0,bupper0

      double precision acoef(blower0:bupper0)
      double precision bcoef(blower0:bupper0)
      double precision gcoef(blower0:bupper0)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)
c
c     Local variables.
c
      integer i
      integer j,j_g,j_i
      integer sgn
      double precision    a,b,g,u_b,u_i
c
c     Set values along the upper/lower y side of the patch.
c
      if ( (location_index .eq. 2) .or.
     &     (location_index .eq. 3) ) then

         if (location_index .eq. 2) then
            sgn = -1
            j_g = ilower1-1     ! ghost    index
            j_i = ilower1       ! interior index
         else
            sgn = +1
            j_g = iupper1+1     ! ghost    index
            j_i = iupper1       ! interior index
         endif

         do i = blower0,bupper0
            a = acoef(i)
            b = bcoef(i)
            g = gcoef(i)

            u_i = U(i,j_i)
            u_b = (2.d0*b*u_i+g*dx(1))/(a*dx(1)+2.d0*b)

            do j = 0,U_gcw-1
               u_i = U(i,j_i-sgn*j)
               U(i,j_g+sgn*j) = 2.d0*u_b-u_i
            enddo
         enddo

      endif
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Set cell centered boundary values along the codimension 2 boundary
c     by extrapolating values from the codimension 1 boundary.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ccrobinphysbdryop22d(
     &     U,U_gcw,
     &     location_index,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     blower0,bupper0,
     &     blower1,bupper1)
c
      implicit none
c
c     Input.
c
      integer U_gcw

      integer location_index

      integer ilower0,iupper0
      integer ilower1,iupper1

      integer blower0,bupper0
      integer blower1,bupper1
c
c     Input/Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)
c
c     Local variables.
c
      integer i,i_bdry,i_mirror
      integer j,j_bdry,j_mirror
      integer sgn_x,sgn_y
c
c     Set the codimension 2 boundary values via linear extrapolation.
c
      if     (location_index .eq. 0) then

         i_bdry = ilower0       ! lower x, lower y
         j_bdry = ilower1

         sgn_x = -1
         sgn_y = -1

      elseif (location_index .eq. 1) then

         i_bdry = iupper0       ! upper x, lower y
         j_bdry = ilower1

         sgn_x = +1
         sgn_y = -1

      elseif (location_index .eq. 2) then

         i_bdry = ilower0       ! lower x, upper y
         j_bdry = iupper1

         sgn_x = -1
         sgn_y = +1

      else

         i_bdry = iupper0       ! upper x, upper y
         j_bdry = iupper1

         sgn_x = +1
         sgn_y = +1

      endif

      do j = blower1,bupper1
         j_mirror = j_bdry+(j_bdry-j+sgn_y)
         do i = blower0,bupper0
            i_mirror = i_bdry+(i_bdry-i+sgn_x)
            U(i,j) = U(i_mirror,j_mirror)
     &           + (U(i,j_bdry)-U(i_mirror,j_bdry))
     &           + (U(i_bdry,j)-U(i_bdry,j_mirror))
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Set side centered boundary values using the supplied Robin
c     coefficients along the codimension 1 upper/lower x boundary.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine scrobinphysbdryop1x2d(
     &     u0,u_gcw,
     &     acoef,bcoef,gcoef,
     &     location_index,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     blower1,bupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer u_gcw

      integer location_index

      integer ilower0,iupper0
      integer ilower1,iupper1

      integer blower1,bupper1

      double precision acoef(blower1:bupper1)
      double precision bcoef(blower1:bupper1)
      double precision gcoef(blower1:bupper1)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision u0(ilower0-u_gcw:iupper0+1+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw)
c
c     Local variables.
c
      integer i,i_b,i_i
      integer j
      integer sgn
      double precision    a,b,g,u_b,u_i
c
c     Set values along the upper/lower x side of the patch.
c
      if ( (location_index .eq. 0) .or.
     &     (location_index .eq. 1) ) then

         if (location_index .eq. 0) then
            sgn = -1
            i_b = ilower0       ! boundary index
            i_i = ilower0+1     ! interior index
         else
            sgn = +1
            i_b = iupper0+1     ! boundary index
            i_i = iupper0       ! interior index
         endif

         do j = blower1,bupper1
            a = acoef(j)
            b = bcoef(j)
            g = gcoef(j)

            if (abs(b) .lt. 1.d-12) then
c     Dirichlet boundary conditions
               u_b = g/a
               u0(i_b,j) = u_b
               do i = 1,u_gcw
                  u_i = u0(i_b-sgn*i,j)
                  u0(i_b+sgn*i,j) = 2.d0*u_b-u_i
               enddo
            elseif (abs(a) .lt. 1.d-12) then
c     Neumann boundary conditions
               u_b = u0(i_b,j)
               do i = 1,u_gcw
                  u_i = u0(i_b-sgn*i,j)
                  u0(i_b+sgn*i,j) = (2.d0*g*dble(i)*dx(0)+u_i*b)/b ! quadratic extrapolation through u_i and u_b
!                 u0(i_b+sgn*i,j) = (     g*dble(i)*dx(0)+u_b*b)/b ! linear    extrapolation through u_b only
               enddo
            else
               print *,'error: invalid robin coefficients'
               call abort
            endif
         enddo

      endif
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Set side centered boundary values using the supplied Robin
c     coefficients along the codimension 1 upper/lower y boundary.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine scrobinphysbdryop1y2d(
     &     u1,u_gcw,
     &     acoef,bcoef,gcoef,
     &     location_index,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     blower0,bupper0,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer u_gcw

      integer location_index

      integer ilower0,iupper0
      integer ilower1,iupper1

      integer blower0,bupper0

      double precision acoef(blower0:bupper0)
      double precision bcoef(blower0:bupper0)
      double precision gcoef(blower0:bupper0)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision u1(ilower0-u_gcw:iupper0+u_gcw,
     &          ilower1-u_gcw:iupper1+1+u_gcw)
c
c     Local variables.
c
      integer i
      integer j,j_b,j_i
      integer sgn
      double precision    a,b,g,u_b,u_i
c
c     Set values along the upper/lower y side of the patch.
c
      if ( (location_index .eq. 2) .or.
     &     (location_index .eq. 3) ) then

         if (location_index .eq. 2) then
            sgn = -1
            j_b = ilower1       ! boundary index
            j_i = ilower1+1     ! interior index
         else
            sgn = +1
            j_b = iupper1+1     ! boundary index
            j_i = iupper1       ! interior index
         endif

         do i = blower0,bupper0
            a = acoef(i)
            b = bcoef(i)
            g = gcoef(i)

            if (abs(b) .lt. 1.d-12) then
c     Dirichlet boundary conditions
               u_b = g/a
               u1(i,j_b) = u_b
               do j = 1,u_gcw
                  u_i = u1(i,j_b-sgn*j)
                  u1(i,j_b+sgn*j) = 2.d0*u_b-u_i
               enddo
            elseif (abs(a) .lt. 1.d-12) then
c     Neumann boundary conditions
               u_b = u1(i,j_b)
               do j = 1,u_gcw
                  u_i = u1(i,j_b-sgn*j)
                  u1(i,j_b+sgn*j) = (2.d0*g*dble(j)*dx(1)+u_i*b)/b ! quadratic extrapolation through u_i and u_b
!                 u1(i,j_b+sgn*j) = (     g*dble(j)*dx(1)+u_b*b)/b ! linear    extrapolation through u_b only
               enddo
            else
               print *,'error: invalid robin coefficients'
               call abort
            endif
         enddo

      endif
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Set side centered boundary values along the codimension 2 boundary
c     by extrapolating values from the codimension 1 boundary.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine scrobinphysbdryop22d(
     &     u0,u1,u_gcw,
     &     location_index,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     blower0,bupper0,
     &     blower1,bupper1)
c
      implicit none
c
c     Input.
c
      integer u_gcw

      integer location_index

      integer ilower0,iupper0
      integer ilower1,iupper1

      integer blower0,bupper0
      integer blower1,bupper1
c
c     Input/Output.
c
      double precision u0(ilower0-u_gcw:iupper0+1+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw)
      double precision u1(ilower0-u_gcw:iupper0+u_gcw,
     &          ilower1-u_gcw:iupper1+1+u_gcw)
c
c     Local variables.
c
      integer i,i_bdry,i_shift
      integer j,j_bdry,j_shift
      double precision u_b,du
c
c     Initialize index variables to yield errors in most cases.
c
      i       = 2**15
      i_bdry  = 2**15
      i_shift = 2**15

      j       = 2**15
      j_bdry  = 2**15
      j_shift = 2**15
c
c     Set the codimension 2 boundary values via linear extrapolation.
c
      if     (location_index .eq. 0) then

         i_bdry = ilower0       ! lower x, lower y
         j_bdry = ilower1
         i_shift = +1
         j_shift = +1

      elseif (location_index .eq. 1) then

         i_bdry = iupper0       ! upper x, lower y
         j_bdry = ilower1
         i_shift = -1
         j_shift = +1

      elseif (location_index .eq. 2) then

         i_bdry = ilower0       ! lower x, upper y
         j_bdry = iupper1
         i_shift = +1
         j_shift = -1

      else

         i_bdry = iupper0       ! upper x, upper y
         j_bdry = iupper1
         i_shift = -1
         j_shift = -1

      endif

      do j = blower1,bupper1
         do i = blower0,bupper0+1
            u_b = u0(i,j_bdry)
            du = u0(i,j_bdry)-u0(i,j_bdry+j_shift)
            u0(i,j) = u_b + dble(abs(j-j_bdry))*du
         enddo
      enddo

      do j = blower1,bupper1+1
         do i = blower0,bupper0
            u_b = u1(i_bdry,j)
            du = u1(i_bdry,j)-u1(i_bdry+i_shift,j)
            u1(i,j) = u_b + dble(abs(i-i_bdry))*du
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
