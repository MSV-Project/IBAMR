c
c     Routines to compute discrete curls on patches.
c
c     Created on 01 Jul 2004 by Boyce Griffith
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
c     Computes W = curl U.
c
c     Uses centered differences to compute the cell centered curl of a
c     cell centered vector field U=(U0,U1,U2).
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ctoccurl3d(
     &     W,W_gcw,
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
      integer W_gcw,U_gcw

      double precision U(ilower0-U_gcw:iupper0+U_gcw,
     &          ilower1-U_gcw:iupper1+U_gcw,
     &          ilower2-U_gcw:iupper2+U_gcw,0:3-1)

      double precision dx(0:3-1)
c
c     Input/Output.
c
      double precision W(ilower0-W_gcw:iupper0+W_gcw,
     &          ilower1-W_gcw:iupper1+W_gcw,
     &          ilower2-W_gcw:iupper2+W_gcw,0:3-1)
c
c     Local variables.
c
      integer i0,i1,i2
      double precision    dU0_dx1,dU0_dx2,fac01,fac02
      double precision    dU1_dx0,dU1_dx2,fac10,fac12
      double precision    dU2_dx0,dU2_dx1,fac20,fac21
c
c     Compute the cell centered curl of U=(U0,U1,U2).
c
      fac12 = 0.5d0/dx(2)
      fac21 = 0.5d0/dx(1)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               dU1_dx2 = fac12*(
     &              U(i0  ,i1  ,i2+1,1)-U(i0  ,i1  ,i2-1,1) )
               dU2_dx1 = fac21*(
     &              U(i0  ,i1+1,i2  ,2)-U(i0  ,i1-1,i2  ,2) )
               W(i0,i1,i2,0) = dU2_dx1-dU1_dx2
            enddo
         enddo
      enddo

      fac02 = 0.5d0/dx(2)
      fac20 = 0.5d0/dx(0)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               dU0_dx2 = fac02*(
     &              U(i0  ,i1  ,i2+1,0)-U(i0  ,i1  ,i2-1,0) )
               dU2_dx0 = fac20*(
     &              U(i0+1,i1  ,i2  ,2)-U(i0-1,i1  ,i2  ,2) )
               W(i0,i1,i2,1) = dU0_dx2-dU2_dx0
            enddo
         enddo
      enddo

      fac01 = 0.5d0/dx(1)
      fac10 = 0.5d0/dx(0)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               dU0_dx1 = fac01*(
     &              U(i0  ,i1+1,i2  ,0)-U(i0  ,i1-1,i2  ,0) )
               dU1_dx0 = fac10*(
     &              U(i0+1,i1  ,i2  ,1)-U(i0-1,i1  ,i2  ,1) )
               W(i0,i1,i2,2) = dU1_dx0-dU0_dx1
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes W = curl u.
c
c     Uses centered differences to compute the cell centered curl of a
c     face centered vector field u=(u0,u1,u2).
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ftoccurl3d(
     &     W,W_gcw,
     &     u0,u1,u2,u_gcw,
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
      integer W_gcw,u_gcw

      double precision u0(ilower0-u_gcw:iupper0+1+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw)
      double precision u1(ilower1-u_gcw:iupper1+1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw,
     &          ilower0-u_gcw:iupper0+u_gcw)
      double precision u2(ilower2-u_gcw:iupper2+1+u_gcw,
     &          ilower0-u_gcw:iupper0+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw)

      double precision dx(0:3-1)
c
c     Input/Output.
c
      double precision W(ilower0-W_gcw:iupper0+W_gcw,
     &          ilower1-W_gcw:iupper1+W_gcw,
     &          ilower2-W_gcw:iupper2+W_gcw,0:3-1)
c
c     Local variables.
c
      integer i0,i1,i2
      double precision    du0_dx1,du0_dx2,fac01,fac02
      double precision    du1_dx0,du1_dx2,fac10,fac12
      double precision    du2_dx0,du2_dx1,fac20,fac21
c
c     Compute the cell centered curl of u=(u0,u1,u2).
c
      fac12 = 0.25d0/dx(2)
      fac21 = 0.25d0/dx(1)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               du1_dx2 = fac12*(
     &              +u1(i1  ,i2+1,i0  )+u1(i1+1,i2+1,i0  )
     &              -u1(i1  ,i2-1,i0  )-u1(i1+1,i2-1,i0  ) )
               du2_dx1 = fac21*(
     &              +u2(i2  ,i0  ,i1+1)+u2(i2+1,i0  ,i1+1)
     &              -u2(i2  ,i0  ,i1-1)-u2(i2+1,i0  ,i1-1) )
               W(i0,i1,i2,0) = du2_dx1-du1_dx2
            enddo
         enddo
      enddo

      fac02 = 0.25d0/dx(2)
      fac20 = 0.25d0/dx(0)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               du0_dx2 = fac02*(
     &              +u0(i0  ,i1  ,i2+1)+u0(i0+1,i1  ,i2+1)
     &              -u0(i0  ,i1  ,i2-1)-u0(i0+1,i1  ,i2-1) )
               du2_dx0 = fac20*(
     &              +u2(i2  ,i0+1,i1  )+u2(i2+1,i0+1,i1  )
     &              -u2(i2  ,i0-1,i1  )-u2(i2+1,i0-1,i1  ) )
               W(i0,i1,i2,1) = du0_dx2-du2_dx0
            enddo
         enddo
      enddo

      fac01 = 0.25d0/dx(1)
      fac10 = 0.25d0/dx(0)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               du0_dx1 = fac01*(
     &              +u0(i0  ,i1+1,i2  )+u0(i0+1,i1+1,i2  )
     &              -u0(i0  ,i1-1,i2  )-u0(i0+1,i1-1,i2  ) )
               du1_dx0 = fac10*(
     &              +u1(i1  ,i2  ,i0+1)+u1(i1+1,i2  ,i0+1)
     &              -u1(i1  ,i2  ,i0-1)-u1(i1+1,i2  ,i0-1) )
               W(i0,i1,i2,2) = du1_dx0-du0_dx1
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes w = curl u.
c
c     Uses centered differences to compute the face centered curl of a
c     face centered vector field u=(u0,u1,u2).
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine ftofcurl3d(
     &     w0,w1,w2,w_gcw,
     &     u0,u1,u2,u_gcw,
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
      integer w_gcw,u_gcw

      double precision u0(ilower0-u_gcw:iupper0+1+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw)
      double precision u1(ilower1-u_gcw:iupper1+1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw,
     &          ilower0-u_gcw:iupper0+u_gcw)
      double precision u2(ilower2-u_gcw:iupper2+1+u_gcw,
     &          ilower0-u_gcw:iupper0+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw)

      double precision dx(0:3-1)
c
c     Input/Output.
c
      double precision w0(ilower0-w_gcw:iupper0+1+w_gcw,
     &          ilower1-w_gcw:iupper1+w_gcw,
     &          ilower2-w_gcw:iupper2+w_gcw)
      double precision w1(ilower1-w_gcw:iupper1+1+w_gcw,
     &          ilower2-w_gcw:iupper2+w_gcw,
     &          ilower0-w_gcw:iupper0+w_gcw)
      double precision w2(ilower2-w_gcw:iupper2+1+w_gcw,
     &          ilower0-w_gcw:iupper0+w_gcw,
     &          ilower1-w_gcw:iupper1+w_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
      double precision    du0_dx1,du0_dx2,fac01,fac02
      double precision    du1_dx0,du1_dx2,fac10,fac12
      double precision    du2_dx0,du2_dx1,fac20,fac21
c
c     Compute the face centered curl of u=(u0,u1,u2).
c
      fac12 = 0.125d0/dx(2)
      fac21 = 0.125d0/dx(1)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0+1
               du2_dx1 = fac21*(
     &              u2(i2  ,i0-1,i1+1) - u2(i2  ,i0-1,i1-1) +
     &              u2(i2  ,i0  ,i1+1) - u2(i2  ,i0  ,i1-1) +
     &              u2(i2+1,i0-1,i1+1) - u2(i2+1,i0-1,i1-1) +
     &              u2(i2+1,i0  ,i1+1) - u2(i2+1,i0  ,i1-1) )
               du1_dx2 = fac12*(
     &              u1(i1  ,i2+1,i0-1) - u1(i1  ,i2-1,i0-1) +
     &              u1(i1  ,i2+1,i0  ) - u1(i1  ,i2-1,i0  ) +
     &              u1(i1+1,i2+1,i0-1) - u1(i1+1,i2-1,i0-1) +
     &              u1(i1+1,i2+1,i0  ) - u1(i1+1,i2-1,i0  ) )
               w0(i0,i1,i2) = du2_dx1-du1_dx2
            enddo
         enddo
      enddo

      fac02 = 0.125d0/dx(2)
      fac20 = 0.125d0/dx(0)

      do i0 = ilower0,iupper0
         do i2 = ilower2,iupper2
            do i1 = ilower1,iupper1+1
               du0_dx2 = fac02*(
     &              u0(i0  ,i1-1,i2+1) - u0(i0  ,i1-1,i2-1) +
     &              u0(i0+1,i1-1,i2+1) - u0(i0+1,i1-1,i2-1) +
     &              u0(i0  ,i1  ,i2+1) - u0(i0  ,i1  ,i2-1) +
     &              u0(i0+1,i1  ,i2+1) - u0(i0+1,i1  ,i2-1) )
               du2_dx0 = fac20*(
     &              u2(i2  ,i0+1,i1-1) - u2(i2  ,i0-1,i1-1) +
     &              u2(i2  ,i0+1,i1  ) - u2(i2  ,i0-1,i1  ) +
     &              u2(i2+1,i0+1,i1-1) - u2(i2+1,i0-1,i1-1) +
     &              u2(i2+1,i0+1,i1  ) - u2(i2+1,i0-1,i1  ) )
               w1(i1,i2,i0) = du0_dx2-du2_dx0
            enddo
         enddo
      enddo

      fac01 = 0.125d0/dx(1)
      fac10 = 0.125d0/dx(0)

      do i1 = ilower1,iupper1
         do i0 = ilower0,iupper0
            do i2 = ilower2,iupper2+1
               du1_dx0 = fac10*(
     &              u1(i1  ,i2-1,i0+1) - u1(i1  ,i2-1,i0-1) +
     &              u1(i1+1,i2-1,i0+1) - u1(i1+1,i2-1,i0-1) +
     &              u1(i1  ,i2  ,i0+1) - u1(i1  ,i2  ,i0-1) +
     &              u1(i1+1,i2  ,i0+1) - u1(i1+1,i2  ,i0-1) )
               du0_dx1 = fac01*(
     &              u0(i0  ,i1+1,i2-1) - u0(i0  ,i1-1,i2-1) +
     &              u0(i0+1,i1+1,i2-1) - u0(i0+1,i1-1,i2-1) +
     &              u0(i0  ,i1+1,i2  ) - u0(i0  ,i1-1,i2  ) +
     &              u0(i0+1,i1+1,i2  ) - u0(i0+1,i1-1,i2  ) )
               w2(i2,i0,i1) = du1_dx0-du0_dx1
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes W = curl u.
c
c     Uses centered differences to compute the cell centered curl of a
c     side centered vector field u=(u0,u1,u2).
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine stoccurl3d(
     &     W,W_gcw,
     &     u0,u1,u2,u_gcw,
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
      integer W_gcw,u_gcw

      double precision u0(ilower0-u_gcw:iupper0+1+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw)
      double precision u1(ilower0-u_gcw:iupper0+u_gcw,
     &          ilower1-u_gcw:iupper1+1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw)
      double precision u2(ilower0-u_gcw:iupper0+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw,
     &          ilower2-u_gcw:iupper2+1+u_gcw)

      double precision dx(0:3-1)
c
c     Input/Output.
c
      double precision W(ilower0-W_gcw:iupper0+W_gcw,
     &          ilower1-W_gcw:iupper1+W_gcw,
     &          ilower2-W_gcw:iupper2+W_gcw,0:3-1)
c
c     Local variables.
c
      integer i0,i1,i2
      double precision    du0_dx1,du0_dx2,fac01,fac02
      double precision    du1_dx0,du1_dx2,fac10,fac12
      double precision    du2_dx0,du2_dx1,fac20,fac21
c
c     Compute the cell centered curl of u=(u0,u1,u2).
c
      fac12 = 0.25d0/dx(2)
      fac21 = 0.25d0/dx(1)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               du1_dx2 = fac12*(
     &              +u1(i0  ,i1  ,i2+1)+u1(i0  ,i1+1,i2+1)
     &              -u1(i0  ,i1  ,i2-1)-u1(i0  ,i1+1,i2-1) )
               du2_dx1 = fac21*(
     &              +u2(i0  ,i1+1,i2  )+u2(i0  ,i1+1,i2+1)
     &              -u2(i0  ,i1-1,i2  )-u2(i0  ,i1-1,i2+1) )
               W(i0,i1,i2,0) = du2_dx1-du1_dx2
            enddo
         enddo
      enddo

      fac02 = 0.25d0/dx(2)
      fac20 = 0.25d0/dx(0)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               du0_dx2 = fac02*(
     &              +u0(i0  ,i1  ,i2+1)+u0(i0+1,i1  ,i2+1)
     &              -u0(i0  ,i1  ,i2-1)-u0(i0+1,i1  ,i2-1) )
               du2_dx0 = fac20*(
     &              +u2(i0+1,i1  ,i2  )+u2(i0+1,i1  ,i2+1)
     &              -u2(i0-1,i1  ,i2  )-u2(i0-1,i1  ,i2+1) )
               W(i0,i1,i2,1) = du0_dx2-du2_dx0
            enddo
         enddo
      enddo

      fac01 = 0.25d0/dx(1)
      fac10 = 0.25d0/dx(0)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               du0_dx1 = fac01*(
     &              +u0(i0  ,i1+1,i2  )+u0(i0+1,i1+1,i2  )
     &              -u0(i0  ,i1-1,i2  )-u0(i0+1,i1-1,i2  ) )
               du1_dx0 = fac10*(
     &              +u1(i0+1,i1  ,i2  )+u1(i0+1,i1+1,i2  )
     &              -u1(i0-1,i1  ,i2  )-u1(i0-1,i1+1,i2  ) )
               W(i0,i1,i2,2) = du1_dx0-du0_dx1
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Computes w = curl u.
c
c     Uses centered differences to compute the side centered curl of a
c     side centered vector field u=(u0,u1,u2).
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine stoscurl3d(
     &     w0,w1,w2,w_gcw,
     &     u0,u1,u2,u_gcw,
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
      integer w_gcw,u_gcw

      double precision u0(ilower0-u_gcw:iupper0+1+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw)
      double precision u1(ilower0-u_gcw:iupper0+u_gcw,
     &          ilower1-u_gcw:iupper1+1+u_gcw,
     &          ilower2-u_gcw:iupper2+u_gcw)
      double precision u2(ilower0-u_gcw:iupper0+u_gcw,
     &          ilower1-u_gcw:iupper1+u_gcw,
     &          ilower2-u_gcw:iupper2+1+u_gcw)

      double precision dx(0:3-1)
c
c     Input/Output.
c
      double precision w0(ilower0-w_gcw:iupper0+1+w_gcw,
     &          ilower1-w_gcw:iupper1+w_gcw,
     &          ilower2-w_gcw:iupper2+w_gcw)
      double precision w1(ilower0-w_gcw:iupper0+w_gcw,
     &          ilower1-w_gcw:iupper1+1+w_gcw,
     &          ilower2-w_gcw:iupper2+w_gcw)
      double precision w2(ilower0-w_gcw:iupper0+w_gcw,
     &          ilower1-w_gcw:iupper1+w_gcw,
     &          ilower2-w_gcw:iupper2+1+w_gcw)
c
c     Local variables.
c
      integer i0,i1,i2
      double precision    du0_dx1,du0_dx2,fac01,fac02
      double precision    du1_dx0,du1_dx2,fac10,fac12
      double precision    du2_dx0,du2_dx1,fac20,fac21
c
c     Compute the side centered curl of u=(u0,u1,u2).
c
      fac12 = 0.125d0/dx(2)
      fac21 = 0.125d0/dx(1)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0+1
               du2_dx1 = fac21*(
     &              u2(i0-1,i1+1,i2  ) - u2(i0-1,i1-1,i2  ) +
     &              u2(i0  ,i1+1,i2  ) - u2(i0  ,i1-1,i2  ) +
     &              u2(i0-1,i1+1,i2+1) - u2(i0-1,i1-1,i2+1) +
     &              u2(i0  ,i1+1,i2+1) - u2(i0  ,i1-1,i2+1) )
               du1_dx2 = fac12*(
     &              u1(i0-1,i1  ,i2+1) - u1(i0-1,i1  ,i2-1) +
     &              u1(i0  ,i1  ,i2+1) - u1(i0  ,i1  ,i2-1) +
     &              u1(i0-1,i1+1,i2+1) - u1(i0-1,i1+1,i2-1) +
     &              u1(i0  ,i1+1,i2+1) - u1(i0  ,i1+1,i2-1) )
               w0(i0,i1,i2) = du2_dx1-du1_dx2
            enddo
         enddo
      enddo

      fac02 = 0.125d0/dx(2)
      fac20 = 0.125d0/dx(0)

      do i2 = ilower2,iupper2
         do i1 = ilower1,iupper1+1
            do i0 = ilower0,iupper0
               du0_dx2 = fac02*(
     &              u0(i0  ,i1-1,i2+1) - u0(i0  ,i1-1,i2-1) +
     &              u0(i0+1,i1-1,i2+1) - u0(i0+1,i1-1,i2-1) +
     &              u0(i0  ,i1  ,i2+1) - u0(i0  ,i1  ,i2-1) +
     &              u0(i0+1,i1  ,i2+1) - u0(i0+1,i1  ,i2-1) )
               du2_dx0 = fac20*(
     &              u2(i0+1,i1-1,i2  ) - u2(i0-1,i1-1,i2  ) +
     &              u2(i0+1,i1  ,i2  ) - u2(i0-1,i1  ,i2  ) +
     &              u2(i0+1,i1-1,i2+1) - u2(i0-1,i1-1,i2+1) +
     &              u2(i0+1,i1  ,i2+1) - u2(i0-1,i1  ,i2+1) )
               w1(i0,i1,i2) = du0_dx2-du2_dx0
            enddo
         enddo
      enddo

      fac01 = 0.125d0/dx(1)
      fac10 = 0.125d0/dx(0)

      do i2 = ilower2,iupper2+1
         do i1 = ilower1,iupper1
            do i0 = ilower0,iupper0
               du1_dx0 = fac10*(
     &              u1(i0+1,i1  ,i2-1) - u1(i0-1,i1  ,i2-1) +
     &              u1(i0+1,i1+1,i2-1) - u1(i0-1,i1+1,i2-1) +
     &              u1(i0+1,i1  ,i2  ) - u1(i0-1,i1  ,i2  ) +
     &              u1(i0+1,i1+1,i2  ) - u1(i0-1,i1+1,i2  ) )
               du0_dx1 = fac01*(
     &              u0(i0  ,i1+1,i2-1) - u0(i0  ,i1-1,i2-1) +
     &              u0(i0+1,i1+1,i2-1) - u0(i0+1,i1-1,i2-1) +
     &              u0(i0  ,i1+1,i2  ) - u0(i0  ,i1-1,i2  ) +
     &              u0(i0+1,i1+1,i2  ) - u0(i0+1,i1-1,i2  ) )
               w2(i0,i1,i2) = du1_dx0-du0_dx1
            enddo
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
