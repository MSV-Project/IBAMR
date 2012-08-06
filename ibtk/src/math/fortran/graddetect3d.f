c
c     Routines for detecting steep gradients.
c
c     Created on 27 Nov 2003 by Boyce Griffith
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
c  File:        $URL: file:///usr/casc/samrai/repository/SAMRAI/tags/v-2-4-4/source/patchdata/fortran/pdat_m4arrdim3d.i $
c  Package:     SAMRAI patchdata
c  Copyright:   (c) 1997-2008 Lawrence Livermore National Security, LLC
c  Revision:    $LastChangedRevision: 1917 $
c  Modified:    $LastChangedDate: 2008-01-25 13:28:01 -0800 (Fri, 25 Jan 2008) $
c  Description: m4 include file for dimensioning 3d arrays in FORTRAN routines.
c
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Tag cells for refinement based on the gradients of u.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine graddetect3d(
     &     tags,tags_gcw,
     &     u,u_gcw,tol,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2
      integer tags_gcw,u_gcw

      double precision u(ilower0-u_gcw:iupper0+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw)
      double precision tol

      double precision dx(0:3-1)
c
c     Input/Output.
c
      integer tags(ilower0-tags_gcw:iupper0+tags_gcw,
     &          ilower1-tags_gcw:iupper1+tags_gcw,
     &          ilower2-tags_gcw:iupper2+tags_gcw)
c
c     Local variables
c
      integer i0,i1,i2
      LOGICAL tagcell
      double precision diag(0:3-1),diag012
      double precision presm1,presp1,facejump
c
c     Tag cells with large gradients in u.
c
      diag(0) = sqrt(dx(2)**2+dx(1)**2)
      diag(1) = sqrt(dx(0)**2+dx(2)**2)
      diag(2) = sqrt(dx(0)**2+dx(1)**2)
      diag012 = sqrt(dx(0)**2+dx(1)**2+dx(2)**2)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0

               tagcell = .false.

               presm1 = u(i0-1,i1,i2)
               presp1 = u(i0+1,i1,i2)
               facejump = abs(u(i0,i1,i2)-presm1)
               facejump = max(facejump,abs(u(i0,i1,i2)-presp1))

               tagcell = ((facejump).gt.(tol*dx(0)))

               if (.not.tagcell) then
                  presm1 = u(i0,i1-1,i2)
                  presp1 = u(i0,i1+1,i2)
                  facejump = abs(u(i0,i1,i2)-presm1)
                  facejump = max(facejump,abs(u(i0,i1,i2)-presp1))
                  tagcell = ((facejump).gt.(tol*dx(1)))
               endif

               if (.not.tagcell) then
                  presm1 = u(i0,i1,i2-1)
                  presp1 = u(i0,i1,i2+1)
                  facejump = abs(u(i0,i1,i2)-presm1)
                  facejump = max(facejump,abs(u(i0,i1,i2)-presp1))
                  tagcell = ((facejump).gt.(tol*dx(2)))
               endif

c     2Dimensional diagonals

               if (.not.tagcell) then
                  presm1 = u(i0,i1-1,i2-1)
                  presp1 = u(i0,i1+1,i2+1)
                  facejump = abs(u(i0,i1,i2)-presm1)
                  facejump = max(facejump,abs(u(i0,i1,i2)-presp1))
                  tagcell = ((facejump).gt.(tol*diag(0)))
               endif

               if (.not.tagcell) then
                  presm1 = u(i0,i1+1,i2-1)
                  presp1 = u(i0,i1-1,i2+1)
                  facejump = abs(u(i0,i1,i2)-presm1)
                  facejump = max(facejump,abs(u(i0,i1,i2)-presp1))
                  tagcell = ((facejump).gt.(tol*diag(0)))
               endif

               if (.not.tagcell) then
                  presm1 = u(i0-1,i1,i2-1)
                  presp1 = u(i0+1,i1,i2+1)
                  facejump = abs(u(i0,i1,i2)-presm1)
                  facejump = max(facejump,abs(u(i0,i1,i2)-presp1))
                  tagcell = ((facejump).gt.(tol*diag(1)))
               endif

               if (.not.tagcell) then
                  presm1 = u(i0-1,i1,i2+1)
                  presp1 = u(i0+1,i1,i2-1)
                  facejump = abs(u(i0,i1,i2)-presm1)
                  facejump = max(facejump,abs(u(i0,i1,i2)-presp1))
                  tagcell = ((facejump).gt.(tol*diag(1)))
               endif

               if (.not.tagcell) then
                  presm1 = u(i0-1,i1-1,i2)
                  presp1 = u(i0+1,i1+1,i2)
                  facejump = abs(u(i0,i1,i2)-presm1)
                  facejump = max(facejump,abs(u(i0,i1,i2)-presp1))
                  tagcell = ((facejump).gt.(tol*diag(2)))
               endif

               if (.not.tagcell) then
                  presm1 = u(i0-1,i1+1,i2)
                  presp1 = u(i0+1,i1-1,i2)
                  facejump = abs(u(i0,i1,i2)-presm1)
                  facejump = max(facejump,abs(u(i0,i1,i2)-presp1))
                  tagcell = ((facejump).gt.(tol*diag(2)))
               endif

c     3Dimensional diagonals

               if (.not.tagcell) then
                  presm1 = u(i0-1,i1-1,i2-1)
                  presp1 = u(i0+1,i1+1,i2+1)
                  facejump = abs(u(i0,i1,i2)-presm1)
                  facejump = max(facejump,abs(u(i0,i1,i2)-presp1))
                  tagcell = ((facejump).gt.(tol*diag012))
               endif

               if (.not.tagcell) then
                  presm1 = u(i0-1,i1-1,i2+1)
                  presp1 = u(i0+1,i1+1,i2-1)
                  facejump = abs(u(i0,i1,i2)-presm1)
                  facejump = max(facejump,abs(u(i0,i1,i2)-presp1))
                  tagcell = ((facejump).gt.(tol*diag012))
               endif

               if (.not.tagcell) then
                  presm1 = u(i0-1,i1+1,i2-1)
                  presp1 = u(i0+1,i1-1,i2+1)
                  facejump = abs(u(i0,i1,i2)-presm1)
                  facejump = max(facejump,abs(u(i0,i1,i2)-presp1))
                  tagcell = ((facejump).gt.(tol*diag012))
               endif

               if (.not.tagcell) then
                  presm1 = u(i0-1,i1+1,i2+1)
                  presp1 = u(i0+1,i1-1,i2-1)
                  facejump = abs(u(i0,i1,i2)-presm1)
                  facejump = max(facejump,abs(u(i0,i1,i2)-presp1))
                  tagcell = ((facejump).gt.(tol*diag012))
               endif
c
c     Tag cells.
c
               if ( tagcell ) then
                  tags(i0,i1,i2) = 1
               endif

            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc