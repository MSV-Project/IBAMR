c
c     Routines to interpolate cell data to and from face/side data on a
c     patch.
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
c     Compute the face centered normal vector field (u0,u1,u2) from the
c     cell centered vector field V using simple averaging.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctofinterp2nd3d(
     &     u0,u1,u2,u_gcw,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2)
c
      implicit none
c
c     Input.
c
      integer u_gcw,V_gcw

      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw,
     &          ilower2-V_gcw:iupper2+V_gcw,0:3-1)
c
c     Output.
c
      double precision u0(ilower0-u_gcw:iupper0+1+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw)
      double precision u1(ilower1-u_gcw:iupper1+1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw,
     &          ilower0-u_gcw:iupper0+u_gcw)
      double precision u2(ilower2-u_gcw:iupper2+1+u_gcw,
     &          ilower0-u_gcw:iupper0+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
c
c     Compute the face centered vector field (u0,u1,u2) from the cell
c     centered vector field V.
c
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0+1
               u0(i0,i1,i2) = 0.5d0*(V(i0-1,i1,i2,0)+V(i0,i1,i2,0))
            enddo
         enddo
      enddo
      do i0 = ilower0,iupper0
         do i2 = ilower2,iupper2
            do i1 = ilower1,iupper1+1
               u1(i1,i2,i0) = 0.5d0*(V(i0,i1-1,i2,1)+V(i0,i1,i2,1))
            enddo
         enddo
      enddo
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do i2 = ilower2,iupper2+1
               u2(i2,i0,i1) = 0.5d0*(V(i0,i1,i2-1,2)+V(i0,i1,i2,2))
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Compute the face centered normal vector field (u0,u1,u2) from the
c     cell centered scalar field V using simple averaging.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctofcwiseinterp2nd3d(
     &     u0,u1,u2,u_gcw,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2)
c
      implicit none
c
c     Input.
c
      integer u_gcw,V_gcw

      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw,
     &          ilower2-V_gcw:iupper2+V_gcw)
c
c     Output.
c
      double precision u0(ilower0-u_gcw:iupper0+1+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw)
      double precision u1(ilower1-u_gcw:iupper1+1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw,
     &          ilower0-u_gcw:iupper0+u_gcw)
      double precision u2(ilower2-u_gcw:iupper2+1+u_gcw,
     &          ilower0-u_gcw:iupper0+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
c
c     Compute the face centered vector field (u0,u1,u2) from the cell
c     centered scalar field V.
c
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0+1
               u0(i0,i1,i2) = 0.5d0*(V(i0-1,i1,i2)+V(i0,i1,i2))
            enddo
         enddo
      enddo
      do i0 = ilower0,iupper0
         do i2 = ilower2,iupper2
            do i1 = ilower1,iupper1+1
               u1(i1,i2,i0) = 0.5d0*(V(i0,i1-1,i2)+V(i0,i1,i2))
            enddo
         enddo
      enddo
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do i2 = ilower2,iupper2+1
               u2(i2,i0,i1) = 0.5d0*(V(i0,i1,i2-1)+V(i0,i1,i2))
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Compute the side centered normal vector field (u0,u1,u2) from the
c     cell centered vector field V using simple averaging.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctosinterp2nd3d(
     &     u0,u1,u2,u_gcw,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2)
c
      implicit none
c
c     Input.
c
      integer u_gcw,V_gcw

      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw,
     &          ilower2-V_gcw:iupper2+V_gcw,0:3-1)
c
c     Output.
c
      double precision u0(ilower0-u_gcw:iupper0+1+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw)
      double precision u1(ilower0-u_gcw:iupper0+u_gcw,
     &          ilower1-u_gcw:iupper1+1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw)
      double precision u2(ilower0-u_gcw:iupper0+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw,
     &          ilower2-u_gcw:iupper2+1+u_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
c
c     Compute the side centered vector field (u0,u1,u2) from the cell
c     centered vector field V.
c
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0+1
               u0(i0,i1,i2) = 0.5d0*(V(i0-1,i1,i2,0)+V(i0,i1,i2,0))
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1+1
            do i0 = ilower0,iupper0
               u1(i0,i1,i2) = 0.5d0*(V(i0,i1-1,i2,1)+V(i0,i1,i2,1))
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2+1
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               u2(i0,i1,i2) = 0.5d0*(V(i0,i1,i2-1,2)+V(i0,i1,i2,2))
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Compute the side centered normal vector field (u0,u1,u2) from the
c     cell centered scalar field V using simple averaging.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctoscwiseinterp2nd3d(
     &     u0,u1,u2,u_gcw,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2)
c
      implicit none
c
c     Input.
c
      integer u_gcw,V_gcw

      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw,
     &          ilower2-V_gcw:iupper2+V_gcw)
c
c     Output.
c
      double precision u0(ilower0-u_gcw:iupper0+1+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw)
      double precision u1(ilower0-u_gcw:iupper0+u_gcw,
     &          ilower1-u_gcw:iupper1+1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw)
      double precision u2(ilower0-u_gcw:iupper0+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw,
     &          ilower2-u_gcw:iupper2+1+u_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
c
c     Compute the side centered vector field (u0,u1,u2) from the cell
c     centered scalar field V.
c
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0+1
               u0(i0,i1,i2) = 0.5d0*(V(i0-1,i1,i2)+V(i0,i1,i2))
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1+1
            do i0 = ilower0,iupper0
               u1(i0,i1,i2) = 0.5d0*(V(i0,i1-1,i2)+V(i0,i1,i2))
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2+1
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               u2(i0,i1,i2) = 0.5d0*(V(i0,i1,i2-1)+V(i0,i1,i2))
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Compute the cell centered vector field U from the face centered
c     normal vector field (v0,v1,v2) using simple averaging.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ftocinterp2nd3d(
     &     U,U_gcw,
     &     v0,v1,v2,v_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2)
c
      implicit none
c
c     Input.
c
      integer U_gcw,v_gcw

      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2

      double precision v0(ilower0-v_gcw:iupper0+1+v_gcw,
     &          ilower1-v_gcw:iupper1+v_gcw,
     &          ilower2-v_gcw:iupper2+v_gcw)
      double precision v1(ilower1-v_gcw:iupper1+1+v_gcw,
     &          ilower2-v_gcw:iupper2+v_gcw,
     &          ilower0-v_gcw:iupper0+v_gcw)
      double precision v2(ilower2-v_gcw:iupper2+1+v_gcw,
     &          ilower0-v_gcw:iupper0+v_gcw,
     &          ilower1-v_gcw:iupper1+v_gcw)
c
c     Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw,0:3-1)
c
c     Local variables.
c
      integer i0,i1,i2
c
c     Compute the cell centered vector field U from the face centered
c     vector field (v0,v1,v2).
c
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               U(i0,i1,i2,0) = 0.5d0*(v0(i0,i1,i2)+v0(i0+1,i1,i2))
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               U(i0,i1,i2,1) = 0.5d0*(v1(i1,i2,i0)+v1(i1+1,i2,i0))
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               U(i0,i1,i2,2) = 0.5d0*(v2(i2,i0,i1)+v2(i2+1,i0,i1))
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Compute the cell centered vector field U from the side centered
c     normal vector field (v0,v1,v2) using simple averaging.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine stocinterp2nd3d(
     &     U,U_gcw,
     &     v0,v1,v2,v_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2)
c
      implicit none
c
c     Input.
c
      integer U_gcw,v_gcw

      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2

      double precision v0(ilower0-v_gcw:iupper0+1+v_gcw,
     &          ilower1-v_gcw:iupper1+v_gcw,
     &          ilower2-v_gcw:iupper2+v_gcw)
      double precision v1(ilower0-v_gcw:iupper0+v_gcw,
     &          ilower1-v_gcw:iupper1+1+v_gcw,
     &          ilower2-v_gcw:iupper2+v_gcw)
      double precision v2(ilower0-v_gcw:iupper0+v_gcw,
     &          ilower1-v_gcw:iupper1+v_gcw,
     &          ilower2-v_gcw:iupper2+1+v_gcw)
c
c     Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw,0:3-1)
c
c     Local variables.
c
      integer i0,i1,i2
c
c     Compute the cell centered vector field U from the side centered
c     vector field (v0,v1,v2).
c
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               U(i0,i1,i2,0) = 0.5d0*(v0(i0,i1,i2)+v0(i0+1,i1,i2))
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               U(i0,i1,i2,1) = 0.5d0*(v1(i0,i1,i2)+v1(i0,i1+1,i2))
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               U(i0,i1,i2,2) = 0.5d0*(v2(i0,i1,i2)+v2(i0,i1,i2+1))
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Compute the cell centered vector field U from the side centered
c     normal vector field (v0,v1,v2) using simple averaging.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine stocinterp2ndspecial3d(
     &     direction,
     &     U,U_gcw,
     &     alpha,
     &     v0,v1,v2,v_gcw,
     &     beta,
     &     W,W_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2)
c
      implicit none
c
c     Input.
c
      integer direction

      integer U_gcw,v_gcw,W_gcw

      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2

      double precision alpha

      double precision v0(ilower0-v_gcw:iupper0+1+v_gcw,
     &          ilower1-v_gcw:iupper1+v_gcw,
     &          ilower2-v_gcw:iupper2+v_gcw)
      double precision v1(ilower0-v_gcw:iupper0+v_gcw,
     &          ilower1-v_gcw:iupper1+1+v_gcw,
     &          ilower2-v_gcw:iupper2+v_gcw)
      double precision v2(ilower0-v_gcw:iupper0+v_gcw,
     &          ilower1-v_gcw:iupper1+v_gcw,
     &          ilower2-v_gcw:iupper2+1+v_gcw)

      double precision beta

      double precision W(ilower0-W_gcw:iupper0+W_gcw,
     &          ilower1-W_gcw:iupper1+W_gcw,
     &          ilower2-W_gcw:iupper2+W_gcw)
c
c     Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
c
c     Compute the cell centered vector field U from the side centered
c     vector field (v0,v1,v2).
c
      if ( direction.eq.0 ) then
         do i2 = ilower2,iupper2
            do i1 = ilower1,iupper1
               do i0 = ilower0,iupper0
                  U(i0,i1,i2)=0.5d0*alpha*(v0(i0,i1,i2)+v0(i0+1,i1,i2))
     &                 + beta*W(i0,i1,i2)
               enddo
            enddo
         enddo
      elseif ( direction.eq.1 ) then
         do i2 = ilower2,iupper2
            do i1 = ilower1,iupper1
               do i0 = ilower0,iupper0
                  U(i0,i1,i2)=0.5d0*alpha*(v1(i0,i1,i2)+v1(i0,i1+1,i2))
     &                 + beta*W(i0,i1,i2)
               enddo
            enddo
         enddo
      else
         do i2 = ilower2,iupper2
            do i1 = ilower1,iupper1
               do i0 = ilower0,iupper0
                  U(i0,i1,i2)=0.5d0*alpha*(v2(i0,i1,i2)+v2(i0,i1,i2+1))
     &                 + beta*W(i0,i1,i2)
               enddo
            enddo
         enddo
      endif
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
