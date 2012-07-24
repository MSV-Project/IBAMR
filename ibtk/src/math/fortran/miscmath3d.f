c
c     Routines to compute misc math operations on patches.
c
c     Created on 05 Jan 2004 by Boyce Griffith
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
c     Computes U = alpha V.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine multiply13d(
     &     U,U_gcw,
     &     alpha,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2
      integer U_gcw,V_gcw

      double precision alpha

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw,
     &          ilower2-V_gcw:iupper2+V_gcw)
c
c     Input/Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
c
c     Compute the linear sum.
c
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               U(i0,i1,i2) = alpha*V(i0,i1,i2)
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes U = alpha V + beta W.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine multiplyadd13d(
     &     U,U_gcw,
     &     alpha,
     &     V,V_gcw,
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
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2
      integer U_gcw,V_gcw,W_gcw

      double precision alpha,beta

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw,
     &          ilower2-V_gcw:iupper2+V_gcw)
      double precision W(ilower0-W_gcw:iupper0+W_gcw,
     &          ilower1-W_gcw:iupper1+W_gcw,
     &          ilower2-W_gcw:iupper2+W_gcw)
c
c     Input/Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
c
c     Compute the linear sum.
c
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               U(i0,i1,i2) = alpha*V(i0,i1,i2) + beta*W(i0,i1,i2)
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes U = A V.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine multiply23d(
     &     U,U_gcw,
     &     A,A_gcw,
     &     V,V_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2
      integer U_gcw,A_gcw,V_gcw

      double precision A(ilower0-A_gcw:iupper0+A_gcw,
     &          ilower1-A_gcw:iupper1+A_gcw,
     &          ilower2-A_gcw:iupper2+A_gcw)
      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw,
     &          ilower2-V_gcw:iupper2+V_gcw)
c
c     Input/Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
c
c     Compute the linear sum.
c
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               U(i0,i1,i2) = A(i0,i1,i2)*V(i0,i1,i2)
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes U = A V + beta W.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine multiplyadd23d(
     &     U,U_gcw,
     &     A,A_gcw,
     &     V,V_gcw,
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
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2
      integer U_gcw,A_gcw,V_gcw,W_gcw

      double precision beta

      double precision A(ilower0-A_gcw:iupper0+A_gcw,
     &          ilower1-A_gcw:iupper1+A_gcw,
     &          ilower2-A_gcw:iupper2+A_gcw)
      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw,
     &          ilower2-V_gcw:iupper2+V_gcw)
      double precision W(ilower0-W_gcw:iupper0+W_gcw,
     &          ilower1-W_gcw:iupper1+W_gcw,
     &          ilower2-W_gcw:iupper2+W_gcw)
c
c     Input/Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
c
c     Compute the linear sum.
c
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               U(i0,i1,i2) = A(i0,i1,i2)*V(i0,i1,i2) + beta*W(i0,i1,i2)
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes U = A V + B W.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine multiplyadd33d(
     &     U,U_gcw,
     &     A,A_gcw,
     &     V,V_gcw,
     &     B,B_gcw,
     &     W,W_gcw,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2
      integer U_gcw,A_gcw,V_gcw,B_gcw,W_gcw

      double precision A(ilower0-A_gcw:iupper0+A_gcw,
     &          ilower1-A_gcw:iupper1+A_gcw,
     &          ilower2-A_gcw:iupper2+A_gcw)
      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw,
     &          ilower2-V_gcw:iupper2+V_gcw)
      double precision B(ilower0-B_gcw:iupper0+B_gcw,
     &          ilower1-B_gcw:iupper1+B_gcw,
     &          ilower2-B_gcw:iupper2+B_gcw)
      double precision W(ilower0-W_gcw:iupper0+W_gcw,
     &          ilower1-W_gcw:iupper1+W_gcw,
     &          ilower2-W_gcw:iupper2+W_gcw)
c
c     Input/Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
c
c     Compute the linear sum.
c
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               U(i0,i1,i2) = A(i0,i1,i2)*V(i0,i1,i2)
     &              + B(i0,i1,i2)*W(i0,i1,i2)
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes U = |V|_1.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine pwl1norm3d(
     &     U,U_gcw,
     &     V,V_gcw,V_depth,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2
      integer U_gcw,V_gcw,V_depth

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw,
     &          ilower2-V_gcw:iupper2+V_gcw,0:V_depth-1)
c
c     Input/Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw)
c
c     Local variables.
c
      double precision n
      integer i0,i1,i2,d
c
c     Compute the pointwise norm.
c
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               n = 0.d0

               do d = 0,V_depth-1
                  n = n + dabs(V(i0,i1,i2,d))
               enddo

               U(i0,i1,i2) = n
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes U = |V|_2.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine pwl2norm3d(
     &     U,U_gcw,
     &     V,V_gcw,V_depth,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2
      integer U_gcw,V_gcw,V_depth

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw,
     &          ilower2-V_gcw:iupper2+V_gcw,0:V_depth-1)
c
c     Input/Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw)
c
c     Local variables.
c
      double precision n
      integer i0,i1,i2,d
c
c     Compute the pointwise norm.
c
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               n = 0.d0

               do d = 0,V_depth-1
                  n = n + V(i0,i1,i2,d)*V(i0,i1,i2,d)
               enddo

               U(i0,i1,i2) = dsqrt(n)
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes U = |V|_oo.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine pwmaxnorm3d(
     &     U,U_gcw,
     &     V,V_gcw,V_depth,
     &     ilower0,iupper0,
     &     ilower1,iupper1,
     &     ilower2,iupper2)
c
      implicit none
c
c     Input.
c
      integer ilower0,iupper0
      integer ilower1,iupper1
      integer ilower2,iupper2
      integer U_gcw,V_gcw,V_depth

      double precision V(ilower0-V_gcw:iupper0+V_gcw,
     &          ilower1-V_gcw:iupper1+V_gcw,
     &          ilower2-V_gcw:iupper2+V_gcw,0:V_depth-1)
c
c     Input/Output.
c
      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw)
c
c     Local variables.
c
      double precision n
      integer i0,i1,i2,d
c
c     Compute the pointwise norm.
c
      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               n = 0.d0

               do d = 0,V_depth-1
                  n = dmax1(n,dabs(V(i0,i1,i2,d)))
               enddo

               U(i0,i1,i2) = n
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
