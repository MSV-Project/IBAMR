c
c     Routines to refine values via divergence- and curl-preserving
c     interpolation.
c
c     Created on 09 Nov 2008 by Boyce Griffith
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
c     Apply the divergence- and gradient-preserving correction to values
c     refined from the next coarser level of the patch hierarchy.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine div_preserving_correction2d(
     &     u0,u1,u_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     correction_box_ilower0,correction_box_iupper0,
     &     correction_box_ilower1,correction_box_iupper1,
     &     ratio,dx_fine)
c
      implicit none
c
c     Input.
c
      integer u_gcw
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer correction_box_ilower0,correction_box_iupper0
      integer correction_box_ilower1,correction_box_iupper1
      integer ratio(0:2-1)
      double precision    dx_fine(0:2-1)
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
      integer d,i0,i1,i,j
      double precision u(-1:1,-1:1),u_xx
      double precision v(-1:1,-1:1),v_yy
      double precision dx,dy
c
c     Apply the divergence- and curl-preserving corrections.
c
      do d = 0,2-1
         if ( .not.(ratio(d).eq.2) ) then
            print *,'error: invalid refinement ratio'
            call abort
         endif
      enddo

      dx = dx_fine(0)           ! NOTE: These values are not used in the
      dy = dx_fine(1)           ! 2D code, but are in the 3D routine.

      do i1=correction_box_ilower1,correction_box_iupper1,ratio(1)
         do i0=correction_box_ilower0,correction_box_iupper0,ratio(0)
            u(-1,-1) = u0(i0  ,i1  )
            u( 1,-1) = u0(i0+2,i1  )
            u(-1, 1) = u0(i0  ,i1+1)
            u( 1, 1) = u0(i0+2,i1+1)

            v(-1,-1) = u1(i0  ,i1  )
            v( 1,-1) = u1(i0+1,i1  )
            v(-1, 1) = u1(i0  ,i1+2)
            v( 1, 1) = u1(i0+1,i1+2)

            u_xx = 0.25d0*(v(-1,-1)-v(-1, 1)-v( 1,-1)+v(1,1))
            v_yy = 0.25d0*(u(-1,-1)-u( 1,-1)-u(-1, 1)+u(1,1))

            do j = -1,1,2
               u(0,j) = 0.5d0*(u(1,j)+u(-1,j))+u_xx
            enddo

            u0(i0+1,i1  ) = u(0,-1)
            u0(i0+1,i1+1) = u(0, 1)

            do i = -1,1,2
               v(i,0) = 0.5d0*(v(i,1)+v(i,-1))+v_yy
            enddo

            u1(i0  ,i1+1) = v(-1,0)
            u1(i0+1,i1+1) = v( 1,0)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
