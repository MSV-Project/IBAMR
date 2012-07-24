c
c     Routines to compute discrete Laplacians on patches.
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
c     Computes F = alpha div grad U.
c
c     Uses the five point stencil to compute the discrete Laplacian of a
c     variable U.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine laplace2d(
     &     F,F_gcw,
     &     alpha,
     &     U,U_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,U_gcw

      double precision alpha

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &       ilower1-U_gcw:iupper1+U_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &       ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1
      double precision    fac0,fac1
c
c     Compute the discrete Laplacian of U.
c
      fac0 = alpha/(dx(0)*dx(0))
      fac1 = alpha/(dx(1)*dx(1))

      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            F(i0,i1) =
     &           fac0*(U(i0-1,i1)+U(i0+1,i1)-2.d0*U(i0,i1)) +
     &           fac1*(U(i0,i1-1)+U(i0,i1+1)-2.d0*U(i0,i1))
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = alpha div grad U + beta V.
c
c     Uses the five point stencil to compute the discrete Laplacian of a
c     variable U.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine laplaceadd2d(
     &     F,F_gcw,
     &     alpha,
     &     U,U_gcw,
     &     beta,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,U_gcw,V_gcw

      double precision alpha

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &       ilower1-U_gcw:iupper1+U_gcw)

      double precision beta

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &       ilower1-V_gcw:iupper1+V_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &       ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1
      double precision    fac0,fac1
c
c     Compute the discrete Laplacian of U.
c
      fac0 = alpha/(dx(0)*dx(0))
      fac1 = alpha/(dx(1)*dx(1))

      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            F(i0,i1) =
     &           fac0*(U(i0-1,i1)+U(i0+1,i1)-2.d0*U(i0,i1)) +
     &           fac1*(U(i0,i1-1)+U(i0,i1+1)-2.d0*U(i0,i1)) +
     &           beta* V(i0,i1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = alpha div grad U + beta U.
c
c     Uses the five point stencil to compute the damped discrete
c     Laplacian of a variable U.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine dampedlaplace2d(
     &     F,F_gcw,
     &     alpha,beta,
     &     U,U_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,U_gcw

      double precision alpha,beta

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &       ilower1-U_gcw:iupper1+U_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &       ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1
      double precision    fac0,fac1
c
c     Compute the discrete Laplacian of U.
c
      fac0 = alpha/(dx(0)*dx(0))
      fac1 = alpha/(dx(1)*dx(1))

      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            F(i0,i1) =
     &           fac0*(U(i0-1,i1)+U(i0+1,i1)-2.d0*U(i0,i1)) +
     &           fac1*(U(i0,i1-1)+U(i0,i1+1)-2.d0*U(i0,i1)) +
     &           beta* U(i0,i1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = alpha div grad U + beta U + gamma V.
c
c     Uses the five point stencil to compute the damped discrete
c     Laplacian of a variable U.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine dampedlaplaceadd2d(
     &     F,F_gcw,
     &     alpha,beta,
     &     U,U_gcw,
     &     gamma,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,U_gcw,V_gcw

      double precision alpha,beta

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &       ilower1-U_gcw:iupper1+U_gcw)

      double precision gamma

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &       ilower1-V_gcw:iupper1+V_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &       ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1
      double precision    fac0,fac1
c
c     Compute the discrete Laplacian of U.
c
      fac0 = alpha/(dx(0)*dx(0))
      fac1 = alpha/(dx(1)*dx(1))

      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            F(i0,i1) =
     &           fac0*(U(i0-1,i1)+U(i0+1,i1)-2.d0*U(i0,i1)) +
     &           fac1*(U(i0,i1-1)+U(i0,i1+1)-2.d0*U(i0,i1)) +
     &           beta* U(i0,i1)                             +
     &           gamma*V(i0,i1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U.
c
c     Uses a five point stencil to compute the cell centered anisotropic
c     Laplacian of a cell centered variable U, where the grid aligned
c     anisotropic diffusion coefficient alpha is specified on cell
c     faces.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocanisoflaplace2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     U,U_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw)
      double precision alpha1(ilower1-alpha_gcw:iupper1+1+alpha_gcw,
     &          ilower0-alpha_gcw:iupper0+alpha_gcw)

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) = alpha0(i0+k,i1)*
     &              (U(i0+k,i1)-U(i0-1+k,i1))/dx(0)
               f1(k) = alpha1(i1+k,i0)*
     &              (U(i0,i1+k)-U(i0,i1-1+k))/dx(1)
            enddo

            F(i0,i1) =
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U + beta V.
c
c     Uses a five point stencil to compute the cell centered anisotropic
c     Laplacian of a cell centered variable U, where the grid aligned
c     anisotropic diffusion coefficient alpha is specified on cell
c     faces.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocanisoflaplaceadd2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     U,U_gcw,
     &     beta,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw,V_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw)
      double precision alpha1(ilower1-alpha_gcw:iupper1+1+alpha_gcw,
     &          ilower0-alpha_gcw:iupper0+alpha_gcw)

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision beta

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) = alpha0(i0+k,i1)*
     &              (U(i0+k,i1)-U(i0-1+k,i1))/dx(0)
               f1(k) = alpha1(i1+k,i0)*
     &              (U(i0,i1+k)-U(i0,i1-1+k))/dx(1)
            enddo

            F(i0,i1) = beta*V(i0,i1) +
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U + beta U.
c
c     Uses a five point stencil to compute the damped cell centered
c     anisotropic Laplacian of a cell centered variable U, where the
c     grid aligned anisotropic diffusion coefficient alpha is specified
c     on cell faces.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocanisofdampedlaplace2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     beta,
     &     U,U_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw)
      double precision alpha1(ilower1-alpha_gcw:iupper1+1+alpha_gcw,
     &          ilower0-alpha_gcw:iupper0+alpha_gcw)

      double precision beta

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) = alpha0(i0+k,i1)*
     &              (U(i0+k,i1)-U(i0-1+k,i1))/dx(0)
               f1(k) = alpha1(i1+k,i0)*
     &              (U(i0,i1+k)-U(i0,i1-1+k))/dx(1)
            enddo

            F(i0,i1) = beta*U(i0,i1) +
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U + beta U + gamma V.
c
c     Uses a five point stencil to compute the damped cell centered
c     anisotropic Laplacian of a cell centered variable U, where the
c     grid aligned anisotropic diffusion coefficient alpha is specified
c     on cell faces.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocanisofdampedlaplaceadd2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     beta,
     &     U,U_gcw,
     &     gamma,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw,V_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw)
      double precision alpha1(ilower1-alpha_gcw:iupper1+1+alpha_gcw,
     &          ilower0-alpha_gcw:iupper0+alpha_gcw)

      double precision beta

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision gamma

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) = alpha0(i0+k,i1)*
     &              (U(i0+k,i1)-U(i0-1+k,i1))/dx(0)
               f1(k) = alpha1(i1+k,i0)*
     &              (U(i0,i1+k)-U(i0,i1-1+k))/dx(1)
            enddo

            F(i0,i1) = beta*U(i0,i1) + gamma*V(i0,i1) +
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U.
c
c     Uses a five point stencil to compute the cell centered anisotropic
c     Laplacian of a cell centered variable U, where the grid aligned
c     anisotropic diffusion coefficient alpha is specified on cell
c     sides.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocanisoslaplace2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     U,U_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw)
      double precision alpha1(ilower0-alpha_gcw:iupper0+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+1+alpha_gcw)

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) = alpha0(i0+k,i1)*
     &              (U(i0+k,i1)-U(i0-1+k,i1))/dx(0)
               f1(k) = alpha1(i0,i1+k)*
     &              (U(i0,i1+k)-U(i0,i1-1+k))/dx(1)
            enddo

            F(i0,i1) =
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U + beta V.
c
c     Uses a five point stencil to compute the cell centered anisotropic
c     Laplacian of a cell centered variable U, where the grid aligned
c     anisotropic diffusion coefficient alpha is specified on cell
c     sides.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocanisoslaplaceadd2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     U,U_gcw,
     &     beta,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw,V_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw)
      double precision alpha1(ilower0-alpha_gcw:iupper0+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+1+alpha_gcw)

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision beta

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) = alpha0(i0+k,i1)*
     &              (U(i0+k,i1)-U(i0-1+k,i1))/dx(0)
               f1(k) = alpha1(i0,i1+k)*
     &              (U(i0,i1+k)-U(i0,i1-1+k))/dx(1)
            enddo

            F(i0,i1) = beta*V(i0,i1) +
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U + beta U.
c
c     Uses a five point stencil to compute the damped cell centered
c     anisotropic Laplacian of a cell centered variable U, where the
c     grid aligned anisotropic diffusion coefficient alpha is specified
c     on cell sides.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocanisosdampedlaplace2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     beta,
     &     U,U_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw)
      double precision alpha1(ilower0-alpha_gcw:iupper0+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+1+alpha_gcw)

      double precision beta

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) = alpha0(i0+k,i1)*
     &              (U(i0+k,i1)-U(i0-1+k,i1))/dx(0)
               f1(k) = alpha1(i0,i1+k)*
     &              (U(i0,i1+k)-U(i0,i1-1+k))/dx(1)
            enddo

            F(i0,i1) = beta*U(i0,i1) +
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U + beta U + gamma V.
c
c     Uses a five point stencil to compute the damped cell centered
c     anisotropic Laplacian of a cell centered variable U, where the
c     grid aligned anisotropic diffusion coefficient alpha is specified
c     on cell sides.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocanisosdampedlaplaceadd2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     beta,
     &     U,U_gcw,
     &     gamma,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw,V_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw)
      double precision alpha1(ilower0-alpha_gcw:iupper0+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+1+alpha_gcw)

      double precision beta

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision gamma

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) = alpha0(i0+k,i1)*
     &              (U(i0+k,i1)-U(i0-1+k,i1))/dx(0)
               f1(k) = alpha1(i0,i1+k)*
     &              (U(i0,i1+k)-U(i0,i1-1+k))/dx(1)
            enddo

            F(i0,i1) = beta*U(i0,i1) + gamma*V(i0,i1) +
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U.
c
c     Uses a nine point stencil to compute the cell centered anisotropic
c     Laplacian of a cell centered variable U, where the general
c     (non-grid aligned) anisotropic diffusion coefficient alpha is
c     specified on cell faces.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocgenanisoflaplace2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     U,U_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw,0:2-1)
      double precision alpha1(ilower1-alpha_gcw:iupper1+1+alpha_gcw,
     &          ilower0-alpha_gcw:iupper0+alpha_gcw,0:2-1)

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) =
     &              alpha0(i0+k,i1,0)*
     &              ( U(i0+k,i1)-U(i0-1+k,i1) )      /dx(0) +
     &
     &              alpha0(i0+k,i1,1)*0.125d0*
     &              ( U(i0  +k,i1+1)-U(i0  +k,i1-1)
     &              + U(i0-1+k,i1+1)-U(i0-1+k,i1-1) )/dx(1)

               f1(k) =
     &              alpha1(i1+k,i0,0)*0.125d0*
     &              ( U(i0+1,i1  +k)-U(i0-1,i1  +k)
     &              + U(i0+1,i1-1+k)-U(i0-1,i1-1+k) )/dx(0) +
     &
     &              alpha1(i1+k,i0,1)*
     &              ( U(i0,i1+k)-U(i0,i1-1+k) )      /dx(1)
            enddo

            F(i0,i1) =
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U + beta V.
c
c     Uses a nine point stencil to compute the cell centered anisotropic
c     Laplacian of a cell centered variable U, where the general
c     (non-grid aligned) anisotropic diffusion coefficient alpha is
c     specified on cell faces.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocgenanisoflaplaceadd2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     U,U_gcw,
     &     beta,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw,V_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw,0:2-1)
      double precision alpha1(ilower1-alpha_gcw:iupper1+1+alpha_gcw,
     &          ilower0-alpha_gcw:iupper0+alpha_gcw,0:2-1)

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision beta

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) =
     &              alpha0(i0+k,i1,0)*
     &              ( U(i0+k,i1)-U(i0-1+k,i1) )      /dx(0) +
     &
     &              alpha0(i0+k,i1,1)*0.125d0*
     &              ( U(i0  +k,i1+1)-U(i0  +k,i1-1)
     &              + U(i0-1+k,i1+1)-U(i0-1+k,i1-1) )/dx(1)

               f1(k) =
     &              alpha1(i1+k,i0,0)*0.125d0*
     &              ( U(i0+1,i1  +k)-U(i0-1,i1  +k)
     &              + U(i0+1,i1-1+k)-U(i0-1,i1-1+k) )/dx(0) +
     &
     &              alpha1(i1+k,i0,1)*
     &              ( U(i0,i1+k)-U(i0,i1-1+k) )      /dx(1)
            enddo

            F(i0,i1) = beta*V(i0,i1) +
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U + beta U.
c
c     Uses a nine point stencil to compute the damped cell centered
c     anisotropic Laplacian of a cell centered variable U, where the
c     general (non-grid aligned) anisotropic diffusion coefficient alpha
c     is specified on cell faces.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocgenanisofdampedlaplace2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     beta,
     &     U,U_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw,0:2-1)
      double precision alpha1(ilower1-alpha_gcw:iupper1+1+alpha_gcw,
     &          ilower0-alpha_gcw:iupper0+alpha_gcw,0:2-1)

      double precision beta

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) =
     &              alpha0(i0+k,i1,0)*
     &              ( U(i0+k,i1)-U(i0-1+k,i1) )      /dx(0) +
     &
     &              alpha0(i0+k,i1,1)*0.125d0*
     &              ( U(i0  +k,i1+1)-U(i0  +k,i1-1)
     &              + U(i0-1+k,i1+1)-U(i0-1+k,i1-1) )/dx(1)

               f1(k) =
     &              alpha1(i1+k,i0,0)*0.125d0*
     &              ( U(i0+1,i1  +k)-U(i0-1,i1  +k)
     &              + U(i0+1,i1-1+k)-U(i0-1,i1-1+k) )/dx(0) +
     &
     &              alpha1(i1+k,i0,1)*
     &              ( U(i0,i1+k)-U(i0,i1-1+k) )      /dx(1)
            enddo

            F(i0,i1) = beta*U(i0,i1) +
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U + beta U + gamma V.
c
c     Uses a nine point stencil to compute the damped cell centered
c     anisotropic Laplacian of a cell centered variable U, where the
c     general (non-grid aligned) anisotropic diffusion coefficient alpha
c     is specified on cell faces.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocgenanisofdampedlaplaceadd2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     beta,
     &     U,U_gcw,
     &     gamma,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw,V_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw,0:2-1)
      double precision alpha1(ilower1-alpha_gcw:iupper1+1+alpha_gcw,
     &          ilower0-alpha_gcw:iupper0+alpha_gcw,0:2-1)

      double precision beta

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision gamma

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) =
     &              alpha0(i0+k,i1,0)*
     &              ( U(i0+k,i1)-U(i0-1+k,i1) )      /dx(0) +
     &
     &              alpha0(i0+k,i1,1)*0.125d0*
     &              ( U(i0  +k,i1+1)-U(i0  +k,i1-1)
     &              + U(i0-1+k,i1+1)-U(i0-1+k,i1-1) )/dx(1)

               f1(k) =
     &              alpha1(i1+k,i0,0)*0.125d0*
     &              ( U(i0+1,i1  +k)-U(i0-1,i1  +k)
     &              + U(i0+1,i1-1+k)-U(i0-1,i1-1+k) )/dx(0) +
     &
     &              alpha1(i1+k,i0,1)*
     &              ( U(i0,i1+k)-U(i0,i1-1+k) )      /dx(1)
            enddo

            F(i0,i1) =  beta*U(i0,i1) + gamma*V(i0,i1) +
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U.
c
c     Uses a nine point stencil to compute the cell centered anisotropic
c     Laplacian of a cell centered variable U, where the general
c     (non-grid aligned) anisotropic diffusion coefficient alpha is
c     specified on cell sides.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocgenanisoslaplace2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     U,U_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw,0:2-1)
      double precision alpha1(ilower0-alpha_gcw:iupper0+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+1+alpha_gcw,0:2-1)

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) =
     &              alpha0(i0+k,i1,0)*
     &              ( U(i0+k,i1)-U(i0-1+k,i1) )      /dx(0) +
     &
     &              alpha0(i0+k,i1,1)*0.125d0*
     &              ( U(i0  +k,i1+1)-U(i0  +k,i1-1)
     &              + U(i0-1+k,i1+1)-U(i0-1+k,i1-1) )/dx(1)

               f1(k) =
     &              alpha1(i0,i1+k,0)*0.125d0*
     &              ( U(i0+1,i1  +k)-U(i0-1,i1  +k)
     &              + U(i0+1,i1-1+k)-U(i0-1,i1-1+k) )/dx(0) +
     &
     &              alpha1(i0,i1+k,1)*
     &              ( U(i0,i1+k)-U(i0,i1-1+k) )      /dx(1)
            enddo

            F(i0,i1) =
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U + beta V.
c
c     Uses a nine point stencil to compute the cell centered anisotropic
c     Laplacian of a cell centered variable U, where the general
c     (non-grid aligned) anisotropic diffusion coefficient alpha is
c     specified on cell sides.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocgenanisoslaplaceadd2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     U,U_gcw,
     &     beta,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw,V_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw,0:2-1)
      double precision alpha1(ilower0-alpha_gcw:iupper0+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+1+alpha_gcw,0:2-1)

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision beta

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) =
     &              alpha0(i0+k,i1,0)*
     &              ( U(i0+k,i1)-U(i0-1+k,i1) )      /dx(0) +
     &
     &              alpha0(i0+k,i1,1)*0.125d0*
     &              ( U(i0  +k,i1+1)-U(i0  +k,i1-1)
     &              + U(i0-1+k,i1+1)-U(i0-1+k,i1-1) )/dx(1)

               f1(k) =
     &              alpha1(i0,i1+k,0)*0.125d0*
     &              ( U(i0+1,i1  +k)-U(i0-1,i1  +k)
     &              + U(i0+1,i1-1+k)-U(i0-1,i1-1+k) )/dx(0) +
     &
     &              alpha1(i0,i1+k,1)*
     &              ( U(i0,i1+k)-U(i0,i1-1+k) )      /dx(1)
            enddo

            F(i0,i1) = beta*V(i0,i1) +
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U + beta U.
c
c     Uses a nine point stencil to compute the damped cell centered
c     anisotropic Laplacian of a cell centered variable U, where the
c     general (non-grid aligned) anisotropic diffusion coefficient alpha
c     is specified on cell sides.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocgenanisosdampedlaplace2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     beta,
     &     U,U_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw,0:2-1)
      double precision alpha1(ilower0-alpha_gcw:iupper0+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+1+alpha_gcw,0:2-1)

      double precision beta

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) =
     &              alpha0(i0+k,i1,0)*
     &              ( U(i0+k,i1)-U(i0-1+k,i1) )      /dx(0) +
     &
     &              alpha0(i0+k,i1,1)*0.125d0*
     &              ( U(i0  +k,i1+1)-U(i0  +k,i1-1)
     &              + U(i0-1+k,i1+1)-U(i0-1+k,i1-1) )/dx(1)

               f1(k) =
     &              alpha1(i0,i1+k,0)*0.125d0*
     &              ( U(i0+1,i1  +k)-U(i0-1,i1  +k)
     &              + U(i0+1,i1-1+k)-U(i0-1,i1-1+k) )/dx(0) +
     &
     &              alpha1(i0,i1+k,1)*
     &              ( U(i0,i1+k)-U(i0,i1-1+k) )      /dx(1)
            enddo

            F(i0,i1) = beta*U(i0,i1) +
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes F = div alpha grad U + beta U + gamma V.
c
c     Uses a nine point stencil to compute the damped cell centered
c     anisotropic Laplacian of a cell centered variable U, where the
c     general (non-grid aligned) anisotropic diffusion coefficient alpha
c     is specified on cell sides.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctocgenanisosdampedlaplaceadd2d(
     &     F,F_gcw,
     &     alpha0,alpha1,alpha_gcw,
     &     beta,
     &     U,U_gcw,
     &     gamma,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     dx)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer F_gcw,alpha_gcw,U_gcw,V_gcw

      double precision alpha0(ilower0-alpha_gcw:iupper0+1+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+alpha_gcw,0:2-1)
      double precision alpha1(ilower0-alpha_gcw:iupper0+alpha_gcw,
     &          ilower1-alpha_gcw:iupper1+1+alpha_gcw,0:2-1)

      double precision beta

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw)

      double precision gamma

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw)

      double precision dx(0:2-1)
c
c     Input/Output.
c
      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &          ilower1-F_gcw:iupper1+F_gcw)
c
c     Local variables.
c
      integer i0,i1,k
      double precision    f0(0:1),f1(0:1)
c
c     Compute the cell centered anisotropic Laplacian of U.
c
      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do k = 0,1
               f0(k) =
     &              alpha0(i0+k,i1,0)*
     &              ( U(i0+k,i1)-U(i0-1+k,i1) )      /dx(0) +
     &
     &              alpha0(i0+k,i1,1)*0.125d0*
     &              ( U(i0  +k,i1+1)-U(i0  +k,i1-1)
     &              + U(i0-1+k,i1+1)-U(i0-1+k,i1-1) )/dx(1)

               f1(k) =
     &              alpha1(i0,i1+k,0)*0.125d0*
     &              ( U(i0+1,i1  +k)-U(i0-1,i1  +k)
     &              + U(i0+1,i1-1+k)-U(i0-1,i1-1+k) )/dx(0) +
     &
     &              alpha1(i0,i1+k,1)*
     &              ( U(i0,i1+k)-U(i0,i1-1+k) )      /dx(1)
            enddo

            F(i0,i1) = beta*U(i0,i1) + gamma*V(i0,i1) +
     &           (f0(1)-f0(0))/dx(0) +
     &           (f1(1)-f1(0))/dx(1)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
