c
c     Routines to compute discrete gradients on patches.
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
c     Computes G = alpha grad U.
c
c     Uses centered differences to compute the cell centered total
c     gradient of a cell centered variable U.
c
c     This is a total gradient in the sense that each component of the
c     gradient is computed for each cell center.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocgrad3d(
     &     G,G_gcw,
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
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2
      integer G_gcw,U_gcw

      double precision alpha

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw)

      double precision dx(0:3-1)
c
c     Input/Output.
c
      double precision G(ilower0-G_gcw:iupper0+G_gcw,
     &          ilower1-G_gcw:iupper1+G_gcw,
     &          ilower2-G_gcw:iupper2+G_gcw,0:3-1)
c
c     Local variables.
c
      integer i0,i1,i2
      double precision    fac0,fac1,fac2
c
c     Compute the cell centered total gradient of U.
c
      fac0 = alpha/(2.d0*dx(0))
      fac1 = alpha/(2.d0*dx(1))
      fac2 = alpha/(2.d0*dx(2))

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               G(i0,i1,i2,0) = fac0*(U(i0+1,i1,i2)-U(i0-1,i1,i2))
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               G(i0,i1,i2,1) = fac1*(U(i0,i1+1,i2)-U(i0,i1-1,i2))
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               G(i0,i1,i2,2) = fac2*(U(i0,i1,i2+1)-U(i0,i1,i2-1))
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes G = alpha grad U + beta V.
c
c     Uses centered differences to compute the cell centered total
c     gradient of a cell centered variable U.
c
c     This is a total gradient in the sense that each component of the
c     gradient is computed for each cell center.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocgradadd3d(
     &     G,G_gcw,
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
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2
      integer G_gcw,U_gcw,V_gcw

      double precision alpha

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw)

      double precision beta

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw,
     &          ilower2-V_gcw:iupper2+V_gcw,0:3-1)

      double precision dx(0:3-1)
c
c     Input/Output.
c
      double precision G(ilower0-G_gcw:iupper0+G_gcw,
     &          ilower1-G_gcw:iupper1+G_gcw,
     &          ilower2-G_gcw:iupper2+G_gcw,0:3-1)
c
c     Local variables.
c
      integer i0,i1,i2
      double precision    fac0,fac1,fac2
c
c     Compute the cell centered total gradient of U.
c
      fac0 = alpha/(2.d0*dx(0))
      fac1 = alpha/(2.d0*dx(1))
      fac2 = alpha/(2.d0*dx(2))

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               G(i0,i1,i2,0) = fac0*(U(i0+1,i1,i2)-U(i0-1,i1,i2))
     &              + beta*V(i0,i1,i2,0)
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               G(i0,i1,i2,1) = fac1*(U(i0,i1+1,i2)-U(i0,i1-1,i2))
     &              + beta*V(i0,i1,i2,1)
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               G(i0,i1,i2,2) = fac2*(U(i0,i1,i2+1)-U(i0,i1,i2-1))
     &              + beta*V(i0,i1,i2,2)
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes g = alpha grad U.
c
c     Uses centered differences to compute the face centered partial
c     gradient of a cell centered variable U.
c
c     This is a partial gradient in the sense that only the normal
c     component of the gradient is computed on each face.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctofgrad3d(
     &     g0,g1,g2,g_gcw,
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
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2
      integer g_gcw,U_gcw

      double precision alpha

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw)

      double precision dx(0:3-1)
c
c     Input/Output.
c
      double precision g0(ilower0-g_gcw:iupper0+1+g_gcw,
     &          ilower1-g_gcw:iupper1+g_gcw,
     &          ilower2-g_gcw:iupper2+g_gcw)
      double precision g1(ilower1-g_gcw:iupper1+1+g_gcw,
     &          ilower2-g_gcw:iupper2+g_gcw,
     &          ilower0-g_gcw:iupper0+g_gcw)
      double precision g2(ilower2-g_gcw:iupper2+1+g_gcw,
     &          ilower0-g_gcw:iupper0+g_gcw,
     &          ilower1-g_gcw:iupper1+g_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
      double precision    fac0,fac1,fac2
c
c     Compute the face centered partial gradient of U.
c
      fac0 = alpha/dx(0)
      fac1 = alpha/dx(1)
      fac2 = alpha/dx(2)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0+1
               g0(i0,i1,i2) = fac0*(U(i0,i1,i2)-U(i0-1,i1,i2))
            enddo
         enddo
      enddo
      do i0 = ilower0,iupper0
         do i2 = ilower2,iupper2
            do i1 = ilower1,iupper1+1
               g1(i1,i2,i0) = fac1*(U(i0,i1,i2)-U(i0,i1-1,i2))
            enddo
         enddo
      enddo
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do i2 = ilower2,iupper2+1
               g2(i2,i0,i1) = fac2*(U(i0,i1,i2)-U(i0,i1,i2-1))
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes g = alpha grad U + beta v.
c
c     Uses centered differences to compute the face centered partial
c     gradient of a cell centered variable U.
c
c     This is a partial gradient in the sense that only the normal
c     component of the gradient is computed on each face.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctofgradadd3d(
     &     g0,g1,g2,g_gcw,
     &     alpha,
     &     U,U_gcw,
     &     beta,
     &     v0,v1,v2,v_gcw,
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
      integer g_gcw,U_gcw,v_gcw

      double precision alpha

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw)

      double precision beta

      double precision v0(ilower0-v_gcw:iupper0+1+v_gcw,
     &          ilower1-v_gcw:iupper1+v_gcw,
     &          ilower2-v_gcw:iupper2+v_gcw)
      double precision v1(ilower1-v_gcw:iupper1+1+v_gcw,
     &          ilower2-v_gcw:iupper2+v_gcw,
     &          ilower0-v_gcw:iupper0+v_gcw)
      double precision v2(ilower2-v_gcw:iupper2+1+v_gcw,
     &          ilower0-v_gcw:iupper0+v_gcw,
     &          ilower1-v_gcw:iupper1+v_gcw)

      double precision dx(0:3-1)
c
c     Input/Output.
c
      double precision g0(ilower0-g_gcw:iupper0+1+g_gcw,
     &          ilower1-g_gcw:iupper1+g_gcw,
     &          ilower2-g_gcw:iupper2+g_gcw)
      double precision g1(ilower1-g_gcw:iupper1+1+g_gcw,
     &          ilower2-g_gcw:iupper2+g_gcw,
     &          ilower0-g_gcw:iupper0+g_gcw)
      double precision g2(ilower2-g_gcw:iupper2+1+g_gcw,
     &          ilower0-g_gcw:iupper0+g_gcw,
     &          ilower1-g_gcw:iupper1+g_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
      double precision    fac0,fac1,fac2
c
c     Compute the face centered partial gradient of U.
c
      fac0 = alpha/dx(0)
      fac1 = alpha/dx(1)
      fac2 = alpha/dx(2)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0+1
               g0(i0,i1,i2) = fac0*(U(i0,i1,i2)-U(i0-1,i1,i2))
     &              + beta*v0(i0,i1,i2)
            enddo
         enddo
      enddo
      do i0 = ilower0,iupper0
         do i2 = ilower2,iupper2
            do i1 = ilower1,iupper1+1
               g1(i1,i2,i0) = fac1*(U(i0,i1,i2)-U(i0,i1-1,i2))
     &              + beta*v1(i1,i2,i0)
            enddo
         enddo
      enddo
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do i2 = ilower2,iupper2+1
               g2(i2,i0,i1) = fac2*(U(i0,i1,i2)-U(i0,i1,i2-1))
     &              + beta*v2(i2,i0,i1)
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes g = alpha grad U.
c
c     Uses centered differences to compute the side centered partial
c     gradient of a cell centered variable U.
c
c     This is a partial gradient in the sense that only the normal
c     component of the gradient is computed on each side.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctosgrad3d(
     &     g0,g1,g2,g_gcw,
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
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2
      integer g_gcw,U_gcw

      double precision alpha

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw)

      double precision dx(0:3-1)
c
c     Input/Output.
c
      double precision g0(ilower0-g_gcw:iupper0+1+g_gcw,
     &          ilower1-g_gcw:iupper1+g_gcw,
     &          ilower2-g_gcw:iupper2+g_gcw)
      double precision g1(ilower0-g_gcw:iupper0+g_gcw,
     &          ilower1-g_gcw:iupper1+1+g_gcw,
     &          ilower2-g_gcw:iupper2+g_gcw)
      double precision g2(ilower0-g_gcw:iupper0+g_gcw,
     &          ilower1-g_gcw:iupper1+g_gcw,
     &          ilower2-g_gcw:iupper2+1+g_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
      double precision    fac0,fac1,fac2
c
c     Compute the side centered partial gradient of U.
c
      fac0 = alpha/dx(0)
      fac1 = alpha/dx(1)
      fac2 = alpha/dx(2)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0+1
               g0(i0,i1,i2) = fac0*(U(i0,i1,i2)-U(i0-1,i1,i2))
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1+1
            do i0 = ilower0,iupper0
               g1(i0,i1,i2) = fac1*(U(i0,i1,i2)-U(i0,i1-1,i2))
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2+1
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               g2(i0,i1,i2) = fac2*(U(i0,i1,i2)-U(i0,i1,i2-1))
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes g = alpha grad U + beta v.
c
c     Uses centered differences to compute the side centered partial
c     gradient of a cell centered variable U.
c
c     This is a partial gradient in the sense that only the normal
c     component of the gradient is computed on each side.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctosgradadd3d(
     &     g0,g1,g2,g_gcw,
     &     alpha,
     &     U,U_gcw,
     &     beta,
     &     v0,v1,v2,v_gcw,
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
      integer g_gcw,U_gcw,v_gcw

      double precision alpha

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw)

      double precision beta

      double precision v0(ilower0-v_gcw:iupper0+1+v_gcw,
     &          ilower1-v_gcw:iupper1+v_gcw,
     &          ilower2-v_gcw:iupper2+v_gcw)
      double precision v1(ilower0-v_gcw:iupper0+v_gcw,
     &          ilower1-v_gcw:iupper1+1+v_gcw,
     &          ilower2-v_gcw:iupper2+v_gcw)
      double precision v2(ilower0-v_gcw:iupper0+v_gcw,
     &          ilower1-v_gcw:iupper1+v_gcw,
     &          ilower2-v_gcw:iupper2+1+v_gcw)

      double precision dx(0:3-1)
c
c     Input/Output.
c
      double precision g0(ilower0-g_gcw:iupper0+1+g_gcw,
     &          ilower1-g_gcw:iupper1+g_gcw,
     &          ilower2-g_gcw:iupper2+g_gcw)
      double precision g1(ilower0-g_gcw:iupper0+g_gcw,
     &          ilower1-g_gcw:iupper1+1+g_gcw,
     &          ilower2-g_gcw:iupper2+g_gcw)
      double precision g2(ilower0-g_gcw:iupper0+g_gcw,
     &          ilower1-g_gcw:iupper1+g_gcw,
     &          ilower2-g_gcw:iupper2+1+g_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
      double precision    fac0,fac1,fac2
c
c     Compute the side centered partial gradient of U.
c
      fac0 = alpha/dx(0)
      fac1 = alpha/dx(1)
      fac2 = alpha/dx(2)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0+1
               g0(i0,i1,i2) = fac0*(U(i0,i1,i2)-U(i0-1,i1,i2))
     &              + beta*v0(i0,i1,i2)
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1+1
            do i0 = ilower0,iupper0
               g1(i0,i1,i2) = fac1*(U(i0,i1,i2)-U(i0,i1-1,i2))
     &              + beta*v1(i0,i1,i2)
            enddo
         enddo
      enddo
      do i2 = ilower2,iupper2+1
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               g2(i0,i1,i2) = fac2*(U(i0,i1,i2)-U(i0,i1,i2-1))
     &              + beta*v2(i0,i1,i2)
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
