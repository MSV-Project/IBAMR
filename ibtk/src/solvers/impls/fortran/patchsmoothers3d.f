c
c     Patch smoothers for use in multigrid preconditioners.
c
c     Created on 25 Aug 2010 by Boyce Griffith
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
c     Gauss-Seidel sweeps for F = alpha div grad U + beta U.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine gssmooth3d(
     &     U,U_gcw,
     &     alpha,beta,
     &     F,F_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2,
     &     dx,
     &     sweeps)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2
      integer U_gcw,F_gcw
      integer sweeps

      double precision alpha,beta

      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &       ilower1-F_gcw:iupper1+F_gcw,
     &       ilower2-F_gcw:iupper2+F_gcw)

      double precision dx(0:3-1)
c
c     Input/Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &       ilower1-U_gcw:iupper1+U_gcw,
     &       ilower2-U_gcw:iupper2+U_gcw)
c
c     Local variables.
c
      integer i0,i1,i2,l
      double precision    fac0,fac1,fac2,fac
c
c     Perform one or more Gauss-Seidel sweeps.
c
      fac0 = alpha/(dx(0)*dx(0))
      fac1 = alpha/(dx(1)*dx(1))
      fac2 = alpha/(dx(2)*dx(2))
      fac = 0.5d0/(fac0+fac1+fac2-0.5d0*beta)

      do l = 1,sweeps
         do i2 = ilower2,iupper2
            do i1 = ilower1,iupper1
               do i0 = ilower0,iupper0
                  U(i0,i1,i2) = fac*(
     &                 fac0*(U(i0-1,i1,i2)+U(i0+1,i1,i2)) +
     &                 fac1*(U(i0,i1-1,i2)+U(i0,i1+1,i2)) +
     &                 fac2*(U(i0,i1,i2-1)+U(i0,i1,i2+1)) -
     &                 F(i0,i1,i2))
               enddo
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Red-black Gauss-Seidel sweeps for F = alpha div grad U + beta U.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine rbgssmooth3d(
     &     U,U_gcw,
     &     alpha,beta,
     &     F,F_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2,
     &     dx,
     &     sweeps)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2
      integer U_gcw,F_gcw
      integer sweeps

      double precision alpha,beta

      double precision F(ilower0-F_gcw:iupper0+F_gcw,
     &       ilower1-F_gcw:iupper1+F_gcw,
     &       ilower2-F_gcw:iupper2+F_gcw)

      double precision dx(0:3-1)
c
c     Input/Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &       ilower1-U_gcw:iupper1+U_gcw,
     &       ilower2-U_gcw:iupper2+U_gcw)
c
c     Local variables.
c
      integer i0,i1,i2,l,m
      double precision    fac0,fac1,fac2,fac
c
c     Perform one or more red-black Gauss-Seidel sweeps.
c
      fac0 = alpha/(dx(0)*dx(0))
      fac1 = alpha/(dx(1)*dx(1))
      fac2 = alpha/(dx(2)*dx(2))
      fac = 0.5d0/(fac0+fac1+fac2-0.5d0*beta)

      do l = 1,sweeps
         do m = 0,1
            do i2 = ilower2,iupper2
               do i1 = ilower1,iupper1
                  do i0 = ilower0,iupper0
                     if ( mod(i0+i1+i2,2) .eq. m ) then
                        U(i0,i1,i2) = fac*(
     &                       fac0*(U(i0-1,i1,i2)+U(i0+1,i1,i2)) +
     &                       fac1*(U(i0,i1-1,i2)+U(i0,i1+1,i2)) +
     &                       fac2*(U(i0,i1,i2-1)+U(i0,i1,i2+1)) -
     &                       F(i0,i1,i2))
                     endif
                  enddo
               enddo
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
