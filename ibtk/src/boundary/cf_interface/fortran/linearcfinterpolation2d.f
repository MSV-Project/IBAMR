c
c     Routines to set CF boundary values via linear interpolation.
c
c     Created on 16 Sep 2011 by Boyce Griffith
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
c     Compute a cell-centered linear interpolation at coarse-fine
c     interfaces.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine cclinearnormalinterpolation2d(
     &     U,U_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     location_index,ratio,
     &     blower,bupper)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer U_gcw

      integer location_index,ratio

      integer blower(0:2-1), bupper(0:2-1)
c
c     Input/Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)
c
c     Local variables.
c
      integer i,ibeg,iend,i_p,i_q
      integer j,jbeg,jend,j_p,j_q
      double precision R
c
c     Set the values along the appropriate side.
c
      ibeg = max(blower(0),ilower0)
      iend = min(bupper(0),iupper0)

      jbeg = max(blower(1),ilower1)
      jend = min(bupper(1),iupper1)

      R = dble(ratio)

      if ( (location_index .eq. 0) .or.
     &     (location_index .eq. 1) ) then
c
c     Set the values along the upper/lower x side of the patch.
c
         if (location_index .eq. 0) then
            do j = jbeg,jend,ratio
               do j_p = j,j+ratio-1
                  j_q = j+(ratio-1+j-j_p)
                  U(ilower0-1,j_p) = (
     &                 2.d0*U(ilower0-1,j_p)
     &                 +  R*U(ilower0  ,j_p)
     &                 -    U(ilower0  ,j_q))/(R+1.d0)
               enddo
            enddo
         else
            do j = jbeg,jend,ratio
               do j_p = j,j+ratio-1
                  j_q = j+(ratio-1+j-j_p)
                  U(iupper0+1,j_p) = (
     &                 2.d0*U(iupper0+1,j_p)
     &                 +  R*U(iupper0  ,j_p)
     &                 -    U(iupper0  ,j_q))/(R+1.d0)
               enddo
            enddo
         endif

      elseif ( (location_index .eq. 2) .or.
     &         (location_index .eq. 3) ) then
c
c     Set the values along the upper/lower y side of the patch.
c
         if (location_index .eq. 2) then
            do i = ibeg,iend,ratio
               do i_p = i,i+ratio-1
                  i_q = i+(ratio-1+i-i_p)
                  U(i_p,ilower1-1) = (
     &                 2.d0*U(i_p,ilower1-1)
     &                 +  R*U(i_p,ilower1  )
     &                 -    U(i_q,ilower1  ))/(R+1.d0)
               enddo
            enddo
         else
            do i = ibeg,iend,ratio
               do i_p = i,i+ratio-1
                  i_q = i+(ratio-1+i-i_p)
                  U(i_p,iupper1+1) = (
     &                 2.d0*U(i_p,iupper1+1)
     &                 +  R*U(i_p,iupper1  )
     &                 -    U(i_q,iupper1  ))/(R+1.d0)
               enddo
            enddo
         endif

      endif
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
