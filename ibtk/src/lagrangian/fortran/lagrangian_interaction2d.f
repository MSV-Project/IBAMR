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
c     Interpolate u onto V at the positions specified by X using the
c     piecewise constant delta function.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_piecewise_constant_interp2d(
     &     dx,x_lower,x_upper,depth,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u,
     &     indices,Xshift,nindices,
     &     X,V)
c
      implicit none
c
c     Input.
c
      integer depth
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1
      integer nindices

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer d,l,s
c
c     Prevent compiler warning about unused variable x_upper.
c
      x_upper(0) = x_upper(0)
c
c     Use the piecewise constant delta function to interpolate u onto V.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic0 = NINT((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0)-0.5d0)+ifirst0
         ic1 = NINT((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1)-0.5d0)+ifirst1
c
c     Interpolate u onto V.
c
         do d = 0,depth-1
            V(d,s) = u(ic0,ic1,d)
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Spread V onto u at the positions specified by X using the
c     piecewise constant delta function.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_piecewise_constant_spread2d(
     &     dx,x_lower,x_upper,depth,
     &     indices,Xshift,nindices,
     &     X,V,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u)
c
      implicit none
c
c     Input.
c
      integer depth
      integer nindices
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer d,l,s
c
c     Prevent compiler warning about unused variable x_upper.
c
      x_upper(0) = x_upper(0)
c
c     Use the piecewise constant delta function to spread V onto u.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic0 = NINT((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0)-0.5d0)+ifirst0
         ic1 = NINT((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1)-0.5d0)+ifirst1
c
c     Spread V onto u.
c
         do d = 0,depth-1
            u(ic0,ic1,d) = u(ic0,ic1,d) + V(d,s)/(dx(0)*dx(1))
         enddo
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Interpolate u onto V at the positions specified by X using the
c     piecewise linear delta function.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_piecewise_linear_interp2d(
     &     dx,x_lower,x_upper,depth,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u,
     &     indices,Xshift,nindices,
     &     X,V)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_piecewise_linear_delta
c
c     Input.
c
      integer depth
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1
      integer nindices

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,l,s

      double precision X_cell(0:2-1),w0(0:1),w1(0:1)
c
c     Use the piecewise linear delta function to interpolate u onto V.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard interpolation stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            if ( X(d,s).lt.X_cell(d) ) then
               ic_lower(d) = ic_center(d)-1
               ic_upper(d) = ic_center(d)
            else
               ic_lower(d) = ic_center(d)
               ic_upper(d) = ic_center(d)+1
            endif
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard interpolation weights.
c
C     DEC$ LOOP COUNT(2)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_piecewise_linear_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(2)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_piecewise_linear_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Interpolate u onto V.
c
         do d = 0,depth-1
            V(d,s) = 0.d0
C     DEC$ LOOP COUNT(2)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(2)
               do ic0 = ic_lower(0),ic_upper(0)
                  V(d,s) = V(d,s)
     &                 +w0(ic0-ic_lower(0))
     &                 *w1(ic1-ic_lower(1))
     &                 *u(ic0,ic1,d)
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
c     Spread V onto u at the positions specified by X using the
c     piecewise linear delta function using standard (double) precision
c     accumulation on the Cartesian grid.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_piecewise_linear_spread2d(
     &     dx,x_lower,x_upper,depth,
     &     indices,Xshift,nindices,
     &     X,V,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_piecewise_linear_delta
c
c     Input.
c
      integer depth
      integer nindices
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,l,s

      double precision X_cell(0:2-1),w0(0:1),w1(0:1)
c
c     Use the piecewise linear delta function to spread V onto u.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard spreading stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            if ( X(d,s).lt.X_cell(d) ) then
               ic_lower(d) = ic_center(d)-1
               ic_upper(d) = ic_center(d)
            else
               ic_lower(d) = ic_center(d)
               ic_upper(d) = ic_center(d)+1
            endif
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard spreading weights.
c
C     DEC$ LOOP COUNT(2)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_piecewise_linear_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(2)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_piecewise_linear_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Spread V onto u.
c
         do d = 0,depth-1
C     DEC$ LOOP COUNT(2)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(2)
               do ic0 = ic_lower(0),ic_upper(0)
                  u(ic0,ic1,d) = u(ic0,ic1,d)+(
     &                 w0(ic0-ic_lower(0))*
     &                 w1(ic1-ic_lower(1))*
     &                 V(d,s)/(dx(0)*dx(1)))
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
c     Interpolate u onto V at the positions specified by X using the
c     broadened (4-point) piecewise linear delta function.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_wide_piecewise_linear_interp2d(
     &     dx,x_lower,x_upper,depth,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u,
     &     indices,Xshift,nindices,
     &     X,V)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_wide_piecewise_linear_delta
c
c     Input.
c
      integer depth
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1
      integer nindices

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,l,s

      double precision X_cell(0:2-1),w0(0:3),w1(0:3)
c
c     Use the broadened (4-point) piecewise linear delta function to
c     interpolate u onto V.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard interpolation stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            if ( X(d,s).lt.X_cell(d) ) then
               ic_lower(d) = ic_center(d)-2
               ic_upper(d) = ic_center(d)+1
            else
               ic_lower(d) = ic_center(d)-1
               ic_upper(d) = ic_center(d)+2
            endif
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard interpolation weights.
c
C     DEC$ LOOP COUNT(4)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_wide_piecewise_linear_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(4)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_wide_piecewise_linear_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Interpolate u onto V.
c
         do d = 0,depth-1
            V(d,s) = 0.d0
C     DEC$ LOOP COUNT(4)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(4)
               do ic0 = ic_lower(0),ic_upper(0)
                  V(d,s) = V(d,s)
     &                 +w0(ic0-ic_lower(0))
     &                 *w1(ic1-ic_lower(1))
     &                 *u(ic0,ic1,d)
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
c     Spread V onto u at the positions specified by X using the
c     broadened (4-point) piecewise linear delta function using standard
c     (double) precision accumulation on the Cartesian grid.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_wide_piecewise_linear_spread2d(
     &     dx,x_lower,x_upper,depth,
     &     indices,Xshift,nindices,
     &     X,V,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_wide_piecewise_linear_delta
c
c     Input.
c
      integer depth
      integer nindices
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,l,s

      double precision X_cell(0:2-1),w0(0:3),w1(0:3)
c
c     Use the broadened (4-point) piecewise linear delta function to
c     spread V onto u.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard spreading stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            if ( X(d,s).lt.X_cell(d) ) then
               ic_lower(d) = ic_center(d)-2
               ic_upper(d) = ic_center(d)+1
            else
               ic_lower(d) = ic_center(d)-1
               ic_upper(d) = ic_center(d)+2
            endif
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard spreading weights.
c
C     DEC$ LOOP COUNT(4)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_wide_piecewise_linear_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(4)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_wide_piecewise_linear_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Spread V onto u.
c
         do d = 0,depth-1
C     DEC$ LOOP COUNT(4)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(4)
               do ic0 = ic_lower(0),ic_upper(0)
                  u(ic0,ic1,d) = u(ic0,ic1,d)+(
     &                 w0(ic0-ic_lower(0))*
     &                 w1(ic1-ic_lower(1))*
     &                 V(d,s)/(dx(0)*dx(1)))
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
c     Interpolate u onto V at the positions specified by X using the
c     piecewise cubic delta function.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_piecewise_cubic_interp2d(
     &     dx,x_lower,x_upper,depth,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u,
     &     indices,Xshift,nindices,
     &     X,V)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_piecewise_cubic_delta
c
c     Input.
c
      integer depth
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1
      integer nindices

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,l,s

      double precision X_cell(0:2-1),w0(0:3),w1(0:3)
c
c     Use the piecewise cubic delta function to interpolate u onto V.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard interpolation stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            if ( X(d,s).lt.X_cell(d) ) then
               ic_lower(d) = ic_center(d)-2
               ic_upper(d) = ic_center(d)+1
            else
               ic_lower(d) = ic_center(d)-1
               ic_upper(d) = ic_center(d)+2
            endif
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard interpolation weights.
c
C     DEC$ LOOP COUNT(4)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_piecewise_cubic_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(4)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_piecewise_cubic_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Interpolate u onto V.
c
         do d = 0,depth-1
            V(d,s) = 0.d0
C     DEC$ LOOP COUNT(4)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(4)
               do ic0 = ic_lower(0),ic_upper(0)
                  V(d,s) = V(d,s)
     &                 +w0(ic0-ic_lower(0))
     &                 *w1(ic1-ic_lower(1))
     &                 *u(ic0,ic1,d)
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
c     Spread V onto u at the positions specified by X using the
c     piecewise cubic delta function using standard (double) precision
c     accumulation on the Cartesian grid.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_piecewise_cubic_spread2d(
     &     dx,x_lower,x_upper,depth,
     &     indices,Xshift,nindices,
     &     X,V,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_piecewise_cubic_delta
c
c     Input.
c
      integer depth
      integer nindices
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,l,s

      double precision X_cell(0:2-1),w0(0:3),w1(0:3)
c
c     Use the piecewise cubic delta function to spread V onto u.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard spreading stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            if ( X(d,s).lt.X_cell(d) ) then
               ic_lower(d) = ic_center(d)-2
               ic_upper(d) = ic_center(d)+1
            else
               ic_lower(d) = ic_center(d)-1
               ic_upper(d) = ic_center(d)+2
            endif
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard spreading weights.
c
C     DEC$ LOOP COUNT(4)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_piecewise_cubic_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(4)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_piecewise_cubic_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Spread V onto u.
c
         do d = 0,depth-1
C     DEC$ LOOP COUNT(4)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(4)
               do ic0 = ic_lower(0),ic_upper(0)
                  u(ic0,ic1,d) = u(ic0,ic1,d)+(
     &                 w0(ic0-ic_lower(0))*
     &                 w1(ic1-ic_lower(1))*
     &                 V(d,s)/(dx(0)*dx(1)))
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
c     Interpolate u onto V at the positions specified by X using the
c     broadened (8-point) piecewise cubic delta function.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_wide_piecewise_cubic_interp2d(
     &     dx,x_lower,x_upper,depth,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u,
     &     indices,Xshift,nindices,
     &     X,V)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_wide_piecewise_cubic_delta
c
c     Input.
c
      integer depth
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1
      integer nindices

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,l,s

      double precision X_cell(0:2-1),w0(0:7),w1(0:7)
c
c     Use the broadened (8-point) piecewise cubic delta function to
c     interpolate u onto V.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard interpolation stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            if ( X(d,s).lt.X_cell(d) ) then
               ic_lower(d) = ic_center(d)-4
               ic_upper(d) = ic_center(d)+3
            else
               ic_lower(d) = ic_center(d)-3
               ic_upper(d) = ic_center(d)+4
            endif
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard interpolation weights.
c
C     DEC$ LOOP COUNT(8)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_wide_piecewise_cubic_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(8)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_wide_piecewise_cubic_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Interpolate u onto V.
c
         do d = 0,depth-1
            V(d,s) = 0.d0
C     DEC$ LOOP COUNT(8)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(8)
               do ic0 = ic_lower(0),ic_upper(0)
                  V(d,s) = V(d,s)
     &                 +w0(ic0-ic_lower(0))
     &                 *w1(ic1-ic_lower(1))
     &                 *u(ic0,ic1,d)
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
c     Spread V onto u at the positions specified by X using the
c     broadened (8-point) piecewise cubic delta function using standard
c     (double) precision accumulation on the Cartesian grid.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_wide_piecewise_cubic_spread2d(
     &     dx,x_lower,x_upper,depth,
     &     indices,Xshift,nindices,
     &     X,V,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_wide_piecewise_cubic_delta
c
c     Input.
c
      integer depth
      integer nindices
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,l,s

      double precision X_cell(0:2-1),w0(0:7),w1(0:7)
c
c     Use the piecewise cubic delta function to spread V onto u.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard spreading stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            if ( X(d,s).lt.X_cell(d) ) then
               ic_lower(d) = ic_center(d)-4
               ic_upper(d) = ic_center(d)+3
            else
               ic_lower(d) = ic_center(d)-3
               ic_upper(d) = ic_center(d)+4
            endif
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard spreading weights.
c
C     DEC$ LOOP COUNT(8)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_wide_piecewise_cubic_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(8)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_wide_piecewise_cubic_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Spread V onto u.
c
         do d = 0,depth-1
C     DEC$ LOOP COUNT(8)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(8)
               do ic0 = ic_lower(0),ic_upper(0)
                  u(ic0,ic1,d) = u(ic0,ic1,d)+(
     &                 w0(ic0-ic_lower(0))*
     &                 w1(ic1-ic_lower(1))*
     &                 V(d,s)/(dx(0)*dx(1)))
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
c     Interpolate u onto V at the positions specified by X using the IB
c     3-point delta function.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_ib_3_interp2d(
     &     dx,x_lower,x_upper,depth,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u,
     &     indices,Xshift,nindices,
     &     X,V)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_ib_3_delta
c
c     Input.
c
      integer depth
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1
      integer nindices

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,l,s

      double precision X_cell(0:2-1),w0(0:2),w1(0:2)
c
c     Use the IB 3-point delta function to interpolate u onto V.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard interpolation stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            ic_lower(d) = ic_center(d)-1
            ic_upper(d) = ic_center(d)+1
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard interpolation weights.
c
C     DEC$ LOOP COUNT(3)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_ib_3_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(3)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_ib_3_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Interpolate u onto V.
c
         do d = 0,depth-1
            V(d,s) = 0.d0
C     DEC$ LOOP COUNT(3)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(3)
               do ic0 = ic_lower(0),ic_upper(0)
                  V(d,s) = V(d,s)
     &                 +w0(ic0-ic_lower(0))
     &                 *w1(ic1-ic_lower(1))
     &                 *u(ic0,ic1,d)
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
c     Spread V onto u at the positions specified by X using the IB
c     3-point delta function using standard (double) precision
c     accumulation on the Cartesian grid.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_ib_3_spread2d(
     &     dx,x_lower,x_upper,depth,
     &     indices,Xshift,nindices,
     &     X,V,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_ib_3_delta
c
c     Input.
c
      integer depth
      integer nindices
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,l,s

      double precision X_cell(0:2-1),w0(0:2),w1(0:2)
c
c     Use the IB 3-point delta function to spread V onto u.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard spreading stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            ic_lower(d) = ic_center(d)-1
            ic_upper(d) = ic_center(d)+1
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard spreading weights.
c
C     DEC$ LOOP COUNT(3)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_ib_3_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(3)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_ib_3_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Spread V onto u.
c
         do d = 0,depth-1
C     DEC$ LOOP COUNT(3)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(3)
               do ic0 = ic_lower(0),ic_upper(0)
                  u(ic0,ic1,d) = u(ic0,ic1,d)+(
     &                 w0(ic0-ic_lower(0))*
     &                 w1(ic1-ic_lower(1))*
     &                 V(d,s)/(dx(0)*dx(1)))
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
c     Interpolate u onto V at the positions specified by X using the
c     broadened (6-point) version of the IB 3-point delta function.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_wide_ib_3_interp2d(
     &     dx,x_lower,x_upper,depth,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u,
     &     indices,Xshift,nindices,
     &     X,V)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_wide_ib_3_delta
c
c     Input.
c
      integer depth
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1
      integer nindices

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,l,s

      double precision X_cell(0:2-1),w0(0:5),w1(0:5)
c
c     Use the broadened (6-point) version of the IB 3-point delta
c     function to interpolate u onto V.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard interpolation stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            if ( X(d,s).lt.X_cell(d) ) then
               ic_lower(d) = ic_center(d)-3
               ic_upper(d) = ic_center(d)+2
            else
               ic_lower(d) = ic_center(d)-2
               ic_upper(d) = ic_center(d)+3
            endif
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard interpolation weights.
c
C     DEC$ LOOP COUNT(6)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_wide_ib_3_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(6)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_wide_ib_3_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Interpolate u onto V.
c
         do d = 0,depth-1
            V(d,s) = 0.d0
C     DEC$ LOOP COUNT(6)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(6)
               do ic0 = ic_lower(0),ic_upper(0)
                  V(d,s) = V(d,s)
     &                 +w0(ic0-ic_lower(0))
     &                 *w1(ic1-ic_lower(1))
     &                 *u(ic0,ic1,d)
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
c     Spread V onto u at the positions specified by X using the
c     broadened (6-point) version of the IB 3-point delta function using
c     standard (double) precision accumulation on the Cartesian grid.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_wide_ib_3_spread2d(
     &     dx,x_lower,x_upper,depth,
     &     indices,Xshift,nindices,
     &     X,V,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_wide_ib_3_delta
c
c     Input.
c
      integer depth
      integer nindices
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,l,s

      double precision X_cell(0:2-1),w0(0:5),w1(0:5)
c
c     Use the broadened (6-point) version of the IB 3-point delta
c     function to spread V onto u.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard spreading stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            if ( X(d,s).lt.X_cell(d) ) then
               ic_lower(d) = ic_center(d)-3
               ic_upper(d) = ic_center(d)+2
            else
               ic_lower(d) = ic_center(d)-2
               ic_upper(d) = ic_center(d)+3
            endif
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard spreading weights.
c
C     DEC$ LOOP COUNT(6)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_wide_ib_3_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(6)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_wide_ib_3_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Spread V onto u.
c
         do d = 0,depth-1
C     DEC$ LOOP COUNT(6)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(6)
               do ic0 = ic_lower(0),ic_upper(0)
                  u(ic0,ic1,d) = u(ic0,ic1,d)+(
     &                 w0(ic0-ic_lower(0))*
     &                 w1(ic1-ic_lower(1))*
     &                 V(d,s)/(dx(0)*dx(1)))
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
c     Interpolate u onto V at the positions specified by X using the IB
c     4-point delta function.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_ib_4_interp2d(
     &     dx,x_lower,x_upper,depth,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     patch_touches_lower_physical_bdry,
     &     patch_touches_upper_physical_bdry,
     &     nugc0,nugc1,
     &     u,
     &     indices,Xshift,nindices,
     &     X,V)
c
      implicit none
c
c     Input.
c
      integer depth
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1
      integer nindices

      integer patch_touches_lower_physical_bdry(0:2-1)
      integer patch_touches_upper_physical_bdry(0:2-1)

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer i0,i1,ic0,ic1
      integer ig_lower(0:2-1),ig_upper(0:2-1)
      integer ic_lower(0:2-1),ic_upper(0:2-1)
      integer istart0,istop0,istart1,istop1
      integer d,k,l,s

      double precision X_o_dx,q0,q1,r0,r1
      double precision w0(0:3),w1(0:3),f(0:3)
      double precision w(0:3,0:3),wy

      LOGICAL account_for_phys_bdry
      LOGICAL touches_lower_bdry(0:2-1)
      LOGICAL touches_upper_bdry(0:2-1)
c
c     Compute the extents of the ghost box.
c
      ig_lower(0) = ifirst0-nugc0
      ig_lower(1) = ifirst1-nugc1
      ig_upper(0) = ilast0 +nugc0
      ig_upper(1) = ilast1 +nugc1
c
c     Determine if we need to account for physical boundaries.
c
      account_for_phys_bdry = .false.
      do d = 0,2-1
         account_for_phys_bdry = account_for_phys_bdry    .or.
     &        (patch_touches_lower_physical_bdry(d).eq.1) .or.
     &        (patch_touches_upper_physical_bdry(d).eq.1)
      enddo
c
c     Use the IB 4-point delta function to interpolate u onto V, but use
c     a modified delta function near physical boundaries.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the standard interpolation stencil corresponding to the
c     position of X(s) within the cell and compute the standard
c     interpolation weights.
c
         X_o_dx = (X(0,s)+Xshift(0,l)-x_lower(0))/dx(0)
         ic_lower(0) = NINT(X_o_dx)+ifirst0-2
         ic_upper(0) = ic_lower(0) + 3
         r0 = X_o_dx - ((ic_lower(0)+1-ifirst0)+0.5d0)
         q0 = sqrt(1.d0+4.d0*r0*(1.d0-r0))
         w0(0) = 0.125d0*(3.d0-2.d0*r0-q0)
         w0(1) = 0.125d0*(3.d0-2.d0*r0+q0)
         w0(2) = 0.125d0*(1.d0+2.d0*r0+q0)
         w0(3) = 0.125d0*(1.d0+2.d0*r0-q0)

         X_o_dx = (X(1,s)+Xshift(1,l)-x_lower(1))/dx(1)
         ic_lower(1) = NINT(X_o_dx)+ifirst1-2
         ic_upper(1) = ic_lower(1) + 3
         r1 = X_o_dx - ((ic_lower(1)+1-ifirst1)+0.5d0)
         q1 = sqrt(1.d0+4.d0*r1*(1.d0-r1))

         w1(0) = 0.125d0*(3.d0-2.d0*r1-q1)
         w1(1) = 0.125d0*(3.d0-2.d0*r1+q1)
         w1(2) = 0.125d0*(1.d0+2.d0*r1+q1)
         w1(3) = 0.125d0*(1.d0+2.d0*r1-q1)
c
c     When necessary, modify the interpolation stencil and weights near
c     physical boundaries.
c
         if ( account_for_phys_bdry ) then
            do d = 0,2-1
               touches_lower_bdry(d) =
     &              (patch_touches_lower_physical_bdry(d).eq.1) .and.
     &              (X(d,s) - x_lower(d) .lt. 1.5d0*dx(d))
               touches_upper_bdry(d) =
     &              (patch_touches_upper_physical_bdry(d).eq.1) .and.
     &              (x_upper(d) - X(d,s) .lt. 1.5d0*dx(d))
            enddo

            if (touches_lower_bdry(0)) then
               call lagrangian_one_sided_ib_4_delta(
     &              w0,(X(0,s)-x_lower(0))/dx(0))
               ic_lower(0) = ifirst0
               ic_upper(0) = ifirst0+3
            elseif (touches_upper_bdry(0)) then
               call lagrangian_one_sided_ib_4_delta(
     &              f,(x_upper(0)-X(0,s))/dx(0))
               ic_lower(0) = ilast0-3
               ic_upper(0) = ilast0
               do k = 0,3
                  w0(3-k) = f(k)
               enddo
            endif

            if (touches_lower_bdry(1)) then
               call lagrangian_one_sided_ib_4_delta(
     &              w1,(X(1,s)-x_lower(1))/dx(1))
               ic_lower(1) = ifirst1
               ic_upper(1) = ifirst1+3
            elseif (touches_upper_bdry(1)) then
               call lagrangian_one_sided_ib_4_delta(
     &              f,(x_upper(1)-X(1,s))/dx(1))
               ic_lower(1) = ilast1-3
               ic_upper(1) = ilast1
               do k = 0,3
                  w1(3-k) = f(k)
               enddo
            endif
         endif
c
c     Compute the tensor product of the interpolation weights.
c
         do i1 = 0,3
            wy = w1(i1)
            do i0 = 0,3
               w(i0,i1) = w0(i0)*wy
            enddo
         enddo
c
c     Interpolate u onto V.
c
         if ( ic_lower(0).lt.ig_lower(0) .or.
     &        ic_lower(1).lt.ig_lower(1) .or.
     &        ic_upper(0).gt.ig_upper(0) .or.
     &        ic_upper(1).gt.ig_upper(1) ) then
            istart0 =   max(ig_lower(0)-ic_lower(0),0)
            istop0  = 3-max(ic_upper(0)-ig_upper(0),0)
            istart1 =   max(ig_lower(1)-ic_lower(1),0)
            istop1  = 3-max(ic_upper(1)-ig_upper(1),0)
            do d = 0,depth-1
               V(d,s) = 0.d0
               do i1 = istart1,istop1
                  ic1 = ic_lower(1)+i1
                  do i0 = istart0,istop0
                     ic0 = ic_lower(0)+i0
                     V(d,s) = V(d,s) + w(i0,i1)*u(ic0,ic1,d)
                  enddo
               enddo
            enddo
         else
            do d = 0,depth-1
               V(d,s) = 0.d0
               do i1 = 0,3
                  ic1 = ic_lower(1)+i1
                  do i0 = 0,3
                     ic0 = ic_lower(0)+i0
                     V(d,s) = V(d,s) + w(i0,i1)*u(ic0,ic1,d)
                  enddo
               enddo
            enddo
         endif
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Spread V onto u at the positions specified by X using the IB
c     4-point delta function using standard (double) precision
c     accumulation on the Cartesian grid.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_ib_4_spread2d(
     &     dx,x_lower,x_upper,depth,
     &     indices,Xshift,nindices,
     &     X,V,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     patch_touches_lower_physical_bdry,
     &     patch_touches_upper_physical_bdry,
     &     nugc0,nugc1,
     &     u)
c
      implicit none
c
c     Input.
c
      integer depth
      integer nindices
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1

      integer indices(0:nindices-1)

      integer patch_touches_lower_physical_bdry(0:2-1)
      integer patch_touches_upper_physical_bdry(0:2-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer i0,i1,ic0,ic1
      integer ig_lower(0:2-1),ig_upper(0:2-1)
      integer ic_lower(0:2-1),ic_upper(0:2-1)
      integer istart0,istop0,istart1,istop1
      integer d,k,l,s

      double precision X_o_dx,q0,q1,r0,r1
      double precision w0(0:3),w1(0:3),f(0:3)
      double precision w(0:3,0:3),wy

      LOGICAL account_for_phys_bdry
      LOGICAL touches_lower_bdry(0:2-1)
      LOGICAL touches_upper_bdry(0:2-1)
c
c     Compute the extents of the ghost box.
c
      ig_lower(0) = ifirst0-nugc0
      ig_lower(1) = ifirst1-nugc1
      ig_upper(0) = ilast0 +nugc0
      ig_upper(1) = ilast1 +nugc1
c
c     Determine if we need to account for physical boundaries.
c
      account_for_phys_bdry = .false.
      do d = 0,2-1
         account_for_phys_bdry = account_for_phys_bdry    .or.
     &        (patch_touches_lower_physical_bdry(d).eq.1) .or.
     &        (patch_touches_upper_physical_bdry(d).eq.1)
      enddo
c
c     Use the IB 4-point delta function to spread V onto u, but use
c     a modified delta function near physical boundaries.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the standard interpolation stencil corresponding to the
c     position of X(s) within the cell and compute the standard
c     interpolation weights.
c
         X_o_dx = (X(0,s)+Xshift(0,l)-x_lower(0))/dx(0)
         ic_lower(0) = NINT(X_o_dx)+ifirst0-2
         ic_upper(0) = ic_lower(0) + 3
         r0 = X_o_dx - ((ic_lower(0)+1-ifirst0)+0.5d0)
         q0 = sqrt(1.d0+4.d0*r0*(1.d0-r0))
         w0(0) = 0.125d0*(3.d0-2.d0*r0-q0)
         w0(1) = 0.125d0*(3.d0-2.d0*r0+q0)
         w0(2) = 0.125d0*(1.d0+2.d0*r0+q0)
         w0(3) = 0.125d0*(1.d0+2.d0*r0-q0)

         X_o_dx = (X(1,s)+Xshift(1,l)-x_lower(1))/dx(1)
         ic_lower(1) = NINT(X_o_dx)+ifirst1-2
         ic_upper(1) = ic_lower(1) + 3
         r1 = X_o_dx - ((ic_lower(1)+1-ifirst1)+0.5d0)
         q1 = sqrt(1.d0+4.d0*r1*(1.d0-r1))
         w1(0) = 0.125d0*(3.d0-2.d0*r1-q1)
         w1(1) = 0.125d0*(3.d0-2.d0*r1+q1)
         w1(2) = 0.125d0*(1.d0+2.d0*r1+q1)
         w1(3) = 0.125d0*(1.d0+2.d0*r1-q1)
c
c     When necessary, modify the interpolation stencil and weights near
c     physical boundaries.
c
         if ( account_for_phys_bdry ) then
            do d = 0,2-1
               touches_lower_bdry(d) =
     &              (patch_touches_lower_physical_bdry(d).eq.1) .and.
     &              (X(d,s) - x_lower(d) .lt. 1.5d0*dx(d))
               touches_upper_bdry(d) =
     &              (patch_touches_upper_physical_bdry(d).eq.1) .and.
     &              (x_upper(d) - X(d,s) .lt. 1.5d0*dx(d))
            enddo

            if (touches_lower_bdry(0)) then
               call lagrangian_one_sided_ib_4_delta(
     &              w0,(X(0,s)-x_lower(0))/dx(0))
               ic_lower(0) = ifirst0
               ic_upper(0) = ifirst0+3
            elseif (touches_upper_bdry(0)) then
               call lagrangian_one_sided_ib_4_delta(
     &              f,(x_upper(0)-X(0,s))/dx(0))
               ic_lower(0) = ilast0-3
               ic_upper(0) = ilast0
               do k = 0,3
                  w0(3-k) = f(k)
               enddo
            endif

            if (touches_lower_bdry(1)) then
               call lagrangian_one_sided_ib_4_delta(
     &              w1,(X(1,s)-x_lower(1))/dx(1))
               ic_lower(1) = ifirst1
               ic_upper(1) = ifirst1+3
            elseif (touches_upper_bdry(1)) then
               call lagrangian_one_sided_ib_4_delta(
     &              f,(x_upper(1)-X(1,s))/dx(1))
               ic_lower(1) = ilast1-3
               ic_upper(1) = ilast1
               do k = 0,3
                  w1(3-k) = f(k)
               enddo
            endif
         endif
c
c     Compute the tensor product of the scaled interpolation weights.
c
         do i1 = 0,3
            wy = w1(i1)/(dx(0)*dx(1))
            do i0 = 0,3
               w(i0,i1) = w0(i0)*wy
            enddo
         enddo
c
c     Spread V onto u.
c
         if ( ic_lower(0).lt.ig_lower(0) .or.
     &        ic_lower(1).lt.ig_lower(1) .or.
     &        ic_upper(0).gt.ig_upper(0) .or.
     &        ic_upper(1).gt.ig_upper(1) ) then
            istart0 =   max(ig_lower(0)-ic_lower(0),0)
            istop0  = 3-max(ic_upper(0)-ig_upper(0),0)
            istart1 =   max(ig_lower(1)-ic_lower(1),0)
            istop1  = 3-max(ic_upper(1)-ig_upper(1),0)
            do d = 0,depth-1
               do i1 = istart1,istop1
                  ic1 = ic_lower(1)+i1
                  do i0 = istart0,istop0
                     ic0 = ic_lower(0)+i0
                     u(ic0,ic1,d) = u(ic0,ic1,d) + w(i0,i1)*V(d,s)
                  enddo
               enddo
            enddo
         else
            do d = 0,depth-1
               do i1 = 0,3
                  ic1 = ic_lower(1)+i1
                  do i0 = 0,3
                     ic0 = ic_lower(0)+i0
                     u(ic0,ic1,d) = u(ic0,ic1,d) + w(i0,i1)*V(d,s)
                  enddo
               enddo
            enddo
         endif
      enddo
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Spread V onto u at the positions specified by X using the IB
c     4-point delta function using extended (double-double) precision
c     accumulation on the Cartesian grid.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_ib_4_spread_xp2d(
     &     dx,x_lower,x_upper,depth,
     &     indices,Xshift,nindices,
     &     X,V,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     patch_touches_lower_physical_bdry,
     &     patch_touches_upper_physical_bdry,
     &     nugc0,nugc1,
     &     u)
c
      use ddmodule
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_ib_4_delta
c
c     Input.
c
      integer depth
      integer nindices
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1

      integer indices(0:nindices-1)

      integer patch_touches_lower_physical_bdry(0:2-1)
      integer patch_touches_upper_physical_bdry(0:2-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,k,l,s

      double precision X_cell(0:2-1),f(0:3),w0(0:3),w1(0:3)

      LOGICAL touches_lower_bdry(0:2-1)
      LOGICAL touches_upper_bdry(0:2-1)

      TYPE (DD_REAL), ALLOCATABLE :: u_work(:,:,:)
      integer*4 old_cw
c
c     Allocate temporary workspace and copy u to u_work.
c
      ALLOCATE( u_work(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1) )
      call f_fpu_fix_start(old_cw)
      do d = 0,depth-1
         do ic1 = ifirst1-nugc1,ilast1+nugc1
            do ic0 = ifirst0-nugc0,ilast0+nugc0
               u_work(ic0,ic1,d) = u(ic0,ic1,d)
            enddo
         enddo
      enddo
      call f_fpu_fix_end(old_cw)
c
c     Use the IB 4-point delta function to spread V onto u.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the standard interpolation stencil corresponding to the
c     position of X(s) within the cell.
c
         ic_lower(0) =
     &        NINT((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))+ifirst0-2
         ic_upper(0) = ic_lower(0) + 3

         ic_lower(1) =
     &        NINT((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))+ifirst1-2
         ic_upper(1) = ic_lower(1) + 3
c
c     Intersect the interpolation stencil with the ghost box.
c
         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard spreading weights.
c
C     DEC$ LOOP COUNT(4)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_ib_4_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(4)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_ib_4_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Determine whether special spreading weights are needed to handle
c     physical boundary conditions.
c
         do d = 0,2-1

            touches_lower_bdry(d) = .false.
            if ( (patch_touches_lower_physical_bdry(d).eq.1) .and.
     &           (X(d,s) - x_lower(d) .lt. 1.5d0*dx(d)) ) then
               touches_lower_bdry(d) = .true.
            endif

            touches_upper_bdry(d) = .false.
            if ( (patch_touches_upper_physical_bdry(d).eq.1) .and.
     &           (x_upper(d) - X(d,s) .lt. 1.5d0*dx(d)) ) then
               touches_upper_bdry(d) = .true.
            endif

         enddo
c
c     Modify the spreading stencil and weights near physical boundaries.
c
         if (touches_lower_bdry(0)) then
            call lagrangian_one_sided_ib_4_delta(
     &           w0,(X(0,s)-x_lower(0))/dx(0))
            ic_lower(0) = ifirst0
            ic_upper(0) = ifirst0+3
         elseif (touches_upper_bdry(0)) then
            call lagrangian_one_sided_ib_4_delta(
     &           f,(x_upper(0)-X(0,s))/dx(0))
            ic_lower(0) = ilast0-3
            ic_upper(0) = ilast0
            do k = 0,3
               w0(3-k) = f(k)
            enddo
         endif

         if (touches_lower_bdry(1)) then
            call lagrangian_one_sided_ib_4_delta(
     &           w1,(X(1,s)-x_lower(1))/dx(1))
            ic_lower(1) = ifirst1
            ic_upper(1) = ifirst1+3
         elseif (touches_upper_bdry(1)) then
            call lagrangian_one_sided_ib_4_delta(
     &           f,(x_upper(1)-X(1,s))/dx(1))
            ic_lower(1) = ilast1-3
            ic_upper(1) = ilast1
            do k = 0,3
               w1(3-k) = f(k)
            enddo
         endif
c
c     Spread V onto u.
c
         call f_fpu_fix_start(old_cw)
         do d = 0,depth-1
C     DEC$ LOOP COUNT(4)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(4)
               do ic0 = ic_lower(0),ic_upper(0)
                  u_work(ic0,ic1,d) = u_work(ic0,ic1,d)+(
     &                 w0(ic0-ic_lower(0))*
     &                 w1(ic1-ic_lower(1))*
     &                 V(d,s)/(dx(0)*dx(1)))
               enddo
            enddo
         enddo
         call f_fpu_fix_end(old_cw)
      enddo
c
c     Copy u_work to u and deallocate temporary workspace.
c
      call f_fpu_fix_start(old_cw)
      do d = 0,depth-1
         do ic1 = ifirst1-nugc1,ilast1+nugc1
            do ic0 = ifirst0-nugc0,ilast0+nugc0
               u(ic0,ic1,d) = u_work(ic0,ic1,d)
            enddo
         enddo
      enddo
      call f_fpu_fix_end(old_cw)
      DEALLOCATE( u_work )
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
c     Interpolate u onto V at the positions specified by X using the
c     broadened (8-point) version of the IB 4-point delta function.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_wide_ib_4_interp2d(
     &     dx,x_lower,x_upper,depth,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u,
     &     indices,Xshift,nindices,
     &     X,V)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_wide_ib_4_delta
c
c     Input.
c
      integer depth
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1
      integer nindices

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,l,s

      double precision X_cell(0:2-1),w0(0:7),w1(0:7)
c
c     Use the broadened (8-point) version of the IB 4-point delta
c     function to interpolate u onto V.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard interpolation stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            if ( X(d,s).lt.X_cell(d) ) then
               ic_lower(d) = ic_center(d)-4
               ic_upper(d) = ic_center(d)+3
            else
               ic_lower(d) = ic_center(d)-3
               ic_upper(d) = ic_center(d)+4
            endif
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard interpolation weights.
c
C     DEC$ LOOP COUNT(8)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_wide_ib_4_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(8)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_wide_ib_4_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Interpolate u onto V.
c
         do d = 0,depth-1
            V(d,s) = 0.d0
C     DEC$ LOOP COUNT(8)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(8)
               do ic0 = ic_lower(0),ic_upper(0)
                  V(d,s) = V(d,s)
     &                 +w0(ic0-ic_lower(0))
     &                 *w1(ic1-ic_lower(1))
     &                 *u(ic0,ic1,d)
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
c     Spread V onto u at the positions specified by X using the
c     broadened (8-point) version of the IB 4-point delta function using
c     standard (double) precision accumulation on the Cartesian grid.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_wide_ib_4_spread2d(
     &     dx,x_lower,x_upper,depth,
     &     indices,Xshift,nindices,
     &     X,V,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     nugc0,nugc1,
     &     u)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_wide_ib_4_delta
c
c     Input.
c
      integer depth
      integer nindices
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,l,s

      double precision X_cell(0:2-1),w0(0:7),w1(0:7)
c
c     Use the broadened (8-point) version of the IB 4-point delta
c     function to spread V onto u.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard spreading stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            if ( X(d,s).lt.X_cell(d) ) then
               ic_lower(d) = ic_center(d)-4
               ic_upper(d) = ic_center(d)+3
            else
               ic_lower(d) = ic_center(d)-3
               ic_upper(d) = ic_center(d)+4
            endif
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard spreading weights.
c
C     DEC$ LOOP COUNT(8)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_wide_ib_4_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(8)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_wide_ib_4_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Spread V onto u.
c
         do d = 0,depth-1
C     DEC$ LOOP COUNT(8)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(8)
               do ic0 = ic_lower(0),ic_upper(0)
                  u(ic0,ic1,d) = u(ic0,ic1,d)+(
     &                 w0(ic0-ic_lower(0))*
     &                 w1(ic1-ic_lower(1))*
     &                 V(d,s)/(dx(0)*dx(1)))
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
c     Interpolate u onto V at the positions specified by X using the IB
c     6-point delta function.
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_ib_6_interp2d(
     &     dx,x_lower,x_upper,depth,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     patch_touches_lower_physical_bdry,
     &     patch_touches_upper_physical_bdry,
     &     nugc0,nugc1,
     &     u,
     &     indices,Xshift,nindices,
     &     X,V)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_ib_6_delta
c
c     Input.
c
      integer depth
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1
      integer nindices

      integer patch_touches_lower_physical_bdry(0:2-1)
      integer patch_touches_upper_physical_bdry(0:2-1)

      integer indices(0:nindices-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,k,l,s

      double precision X_cell(0:2-1),f(0:5),w0(0:5),w1(0:5)

      LOGICAL touches_lower_bdry(0:2-1)
      LOGICAL touches_upper_bdry(0:2-1)
c
c     Use the IB 6-point delta function to interpolate u onto V.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard interpolation stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            if ( X(d,s).lt.X_cell(d) ) then
               ic_lower(d) = ic_center(d)-3
               ic_upper(d) = ic_center(d)+2
            else
               ic_lower(d) = ic_center(d)-2
               ic_upper(d) = ic_center(d)+3
            endif
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard interpolation weights.
c
C     DEC$ LOOP COUNT(6)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_ib_6_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(6)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_ib_6_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Determine whether special interpolation weights are needed to
c     handle physical boundary conditions.
c
         do d = 0,2-1
            if ( (patch_touches_lower_physical_bdry(d).eq.1).and.
     &           (X(d,s) - x_lower(d) .lt. 2.5d0*dx(d)) ) then
               touches_lower_bdry(d) = .true.
            else
               touches_lower_bdry(d) = .false.
            endif
            if ( (patch_touches_upper_physical_bdry(d).eq.1).and.
     &           (x_upper(d) - X(d,s) .lt. 2.5d0*dx(d)) ) then
               touches_upper_bdry(d) = .true.
            else
               touches_upper_bdry(d) = .false.
            endif
         enddo
c
c     Modify the interpolation stencil and weights near physical
c     boundaries.
c
         if (touches_lower_bdry(0)) then
            call lagrangian_one_sided_ib_6_delta(
     &           w0,(X(0,s)-x_lower(0))/dx(0))
            ic_lower(0) = ifirst0
            ic_upper(0) = ifirst0+5
         elseif (touches_upper_bdry(0)) then
            call lagrangian_one_sided_ib_6_delta(
     &           f,(x_upper(0)-X(0,s))/dx(0))
            do k = 0,5
               w0(5-k) = f(k)
            enddo
            ic_lower(0) = ilast0-5
            ic_upper(0) = ilast0
         endif

         if (touches_lower_bdry(1)) then
            call lagrangian_one_sided_ib_6_delta(
     &           w1,(X(1,s)-x_lower(1))/dx(1))
            ic_lower(1) = ifirst1
            ic_upper(1) = ifirst1+5
         elseif (touches_upper_bdry(1)) then
            call lagrangian_one_sided_ib_6_delta(
     &           f,(x_upper(1)-X(1,s))/dx(1))
            do k = 0,5
               w1(5-k) = f(k)
            enddo
            ic_lower(1) = ilast1-5
            ic_upper(1) = ilast1
         endif
c
c     Interpolate u onto V.
c
         do d = 0,depth-1
            V(d,s) = 0.d0
C     DEC$ LOOP COUNT(6)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(6)
C     DEC$ NOVECTOR
               do ic0 = ic_lower(0),ic_upper(0)
                  V(d,s) = V(d,s)
     &                 +w0(ic0-ic_lower(0))
     &                 *w1(ic1-ic_lower(1))
     &                 *u(ic0,ic1,d)
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
c     Spread V onto u at the positions specified by X using the IB
c     6-point delta function using standard (double) precision
c     accumulation on the Cartesian grid..
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_ib_6_spread2d(
     &     dx,x_lower,x_upper,depth,
     &     indices,Xshift,nindices,
     &     X,V,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     patch_touches_lower_physical_bdry,
     &     patch_touches_upper_physical_bdry,
     &     nugc0,nugc1,
     &     u)
c
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_ib_6_delta
c
c     Input.
c
      integer depth
      integer nindices
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1

      integer indices(0:nindices-1)

      integer patch_touches_lower_physical_bdry(0:2-1)
      integer patch_touches_upper_physical_bdry(0:2-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,k,l,s

      double precision X_cell(0:2-1),f(0:5),w0(0:5),w1(0:5)

      LOGICAL touches_lower_bdry(0:2-1)
      LOGICAL touches_upper_bdry(0:2-1)
c
c     Use the IB 6-point delta function to spread V onto u.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard spreading stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            if ( X(d,s).lt.X_cell(d) ) then
               ic_lower(d) = ic_center(d)-3
               ic_upper(d) = ic_center(d)+2
            else
               ic_lower(d) = ic_center(d)-2
               ic_upper(d) = ic_center(d)+3
            endif
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard spreading weights.
c
C     DEC$ LOOP COUNT(6)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_ib_6_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(6)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_ib_6_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Determine whether special spreading weights are needed to handle
c     physical boundary conditions.
c
         do d = 0,2-1
            if ( (patch_touches_lower_physical_bdry(d).eq.1).and.
     &           (X(d,s) - x_lower(d) .lt. 2.5d0*dx(d)) ) then
               touches_lower_bdry(d) = .true.
            else
               touches_lower_bdry(d) = .false.
            endif
            if ( (patch_touches_upper_physical_bdry(d).eq.1).and.
     &           (x_upper(d) - X(d,s) .lt. 2.5d0*dx(d)) ) then
               touches_upper_bdry(d) = .true.
            else
               touches_upper_bdry(d) = .false.
            endif
         enddo
c
c     Modify the spreading stencil and weights near physical boundaries.
c
         if (touches_lower_bdry(0)) then
            call lagrangian_one_sided_ib_6_delta(
     &           w0,(X(0,s)-x_lower(0))/dx(0))
            ic_lower(0) = ifirst0
            ic_upper(0) = ifirst0+5
         elseif (touches_upper_bdry(0)) then
            call lagrangian_one_sided_ib_6_delta(
     &           f,(x_upper(0)-X(0,s))/dx(0))
            do k = 0,5
               w0(5-k) = f(k)
            enddo
            ic_lower(0) = ilast0-5
            ic_upper(0) = ilast0
         endif

         if (touches_lower_bdry(1)) then
            call lagrangian_one_sided_ib_6_delta(
     &           w1,(X(1,s)-x_lower(1))/dx(1))
            ic_lower(1) = ifirst1
            ic_upper(1) = ifirst1+5
         elseif (touches_upper_bdry(1)) then
            call lagrangian_one_sided_ib_6_delta(
     &           f,(x_upper(1)-X(1,s))/dx(1))
            do k = 0,5
               w1(5-k) = f(k)
            enddo
            ic_lower(1) = ilast1-5
            ic_upper(1) = ilast1
         endif
c
c     Spread V onto u.
c
         do d = 0,depth-1
C     DEC$ LOOP COUNT(6)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(6)
C     DEC$ NOVECTOR
               do ic0 = ic_lower(0),ic_upper(0)
                  u(ic0,ic1,d) = u(ic0,ic1,d)+(
     &                 w0(ic0-ic_lower(0))*
     &                 w1(ic1-ic_lower(1))*
     &                 V(d,s)/(dx(0)*dx(1)))
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
c     Spread V onto u at the positions specified by X using the IB
c     6-point delta function using extended (double-double) precision
c     accumulation on the Cartesian grid..
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc
c
      subroutine lagrangian_ib_6_spread_xp2d(
     &     dx,x_lower,x_upper,depth,
     &     indices,Xshift,nindices,
     &     X,V,
     &     ifirst0,ilast0,ifirst1,ilast1,
     &     patch_touches_lower_physical_bdry,
     &     patch_touches_upper_physical_bdry,
     &     nugc0,nugc1,
     &     u)
c
      use ddmodule
      implicit none
c
c     Functions.
c
      EXTERNAL lagrangian_floor
      integer lagrangian_floor
      double precision lagrangian_ib_6_delta
c
c     Input.
c
      integer depth
      integer nindices
      integer ifirst0,ilast0,ifirst1,ilast1
      integer nugc0,nugc1

      integer indices(0:nindices-1)

      integer patch_touches_lower_physical_bdry(0:2-1)
      integer patch_touches_upper_physical_bdry(0:2-1)

      double precision Xshift(0:2-1,0:nindices-1)

      double precision dx(0:2-1),x_lower(0:2-1),x_upper(0:2-1)
      double precision u(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1)
      double precision X(0:2-1,0:*)
c
c     Input/Output.
c
      double precision V(0:depth-1,0:*)
c
c     Local variables.
c
      integer ic0,ic1
      integer ic_center(0:2-1),ic_lower(0:2-1),ic_upper(0:2-1)
      integer d,k,l,s

      double precision X_cell(0:2-1),f(0:5),w0(0:5),w1(0:5)

      LOGICAL touches_lower_bdry(0:2-1)
      LOGICAL touches_upper_bdry(0:2-1)

      TYPE (DD_REAL), ALLOCATABLE :: u_work(:,:,:)
      integer*4 old_cw
c
c     Allocate temporary workspace and copy u to u_work.
c
      ALLOCATE( u_work(ifirst0-nugc0:ilast0+nugc0,
     &          ifirst1-nugc1:ilast1+nugc1,0:depth-1) )
      call f_fpu_fix_start(old_cw)
      do d = 0,depth-1
         do ic1 = ifirst1-nugc1,ilast1+nugc1
            do ic0 = ifirst0-nugc0,ilast0+nugc0
               u_work(ic0,ic1,d) = u(ic0,ic1,d)
            enddo
         enddo
      enddo
      call f_fpu_fix_end(old_cw)
c
c     Use the IB 6-point delta function to spread V onto u.
c
      do l = 0,nindices-1
         s = indices(l)
c
c     Determine the Cartesian cell in which X(s) is located.
c
         ic_center(0) =
     &        lagrangian_floor((X(0,s)+Xshift(0,l)-x_lower(0))/dx(0))
     &        + ifirst0
         ic_center(1) =
     &        lagrangian_floor((X(1,s)+Xshift(1,l)-x_lower(1))/dx(1))
     &        + ifirst1

         X_cell(0) = x_lower(0)+(dble(ic_center(0)-ifirst0)+0.5d0)*dx(0)
         X_cell(1) = x_lower(1)+(dble(ic_center(1)-ifirst1)+0.5d0)*dx(1)
c
c     Determine the standard spreading stencil corresponding to the
c     position of X(s) within the cell.
c
         do d = 0,2-1
            if ( X(d,s).lt.X_cell(d) ) then
               ic_lower(d) = ic_center(d)-3
               ic_upper(d) = ic_center(d)+2
            else
               ic_lower(d) = ic_center(d)-2
               ic_upper(d) = ic_center(d)+3
            endif
         enddo

         ic_lower(0) = max(ic_lower(0),ifirst0-nugc0)
         ic_upper(0) = min(ic_upper(0),ilast0 +nugc0)

         ic_lower(1) = max(ic_lower(1),ifirst1-nugc1)
         ic_upper(1) = min(ic_upper(1),ilast1 +nugc1)
c
c     Compute the standard spreading weights.
c
C     DEC$ LOOP COUNT(6)
         do ic0 = ic_lower(0),ic_upper(0)
            X_cell(0) = x_lower(0)+(dble(ic0-ifirst0)+0.5d0)*dx(0)
            w0(ic0-ic_lower(0)) =
     &           lagrangian_ib_6_delta(
     &           (X(0,s)+Xshift(0,l)-X_cell(0))/dx(0))
         enddo
C     DEC$ LOOP COUNT(6)
         do ic1 = ic_lower(1),ic_upper(1)
            X_cell(1) = x_lower(1)+(dble(ic1-ifirst1)+0.5d0)*dx(1)
            w1(ic1-ic_lower(1)) =
     &           lagrangian_ib_6_delta(
     &           (X(1,s)+Xshift(1,l)-X_cell(1))/dx(1))
         enddo
c
c     Determine whether special spreading weights are needed to handle
c     physical boundary conditions.
c
         do d = 0,2-1
            if ( (patch_touches_lower_physical_bdry(d).eq.1).and.
     &           (X(d,s) - x_lower(d) .lt. 2.5d0*dx(d)) ) then
               touches_lower_bdry(d) = .true.
            else
               touches_lower_bdry(d) = .false.
            endif
            if ( (patch_touches_upper_physical_bdry(d).eq.1).and.
     &           (x_upper(d) - X(d,s) .lt. 2.5d0*dx(d)) ) then
               touches_upper_bdry(d) = .true.
            else
               touches_upper_bdry(d) = .false.
            endif
         enddo
c
c     Modify the spreading stencil and weights near physical boundaries.
c
         if (touches_lower_bdry(0)) then
            call lagrangian_one_sided_ib_6_delta(
     &           w0,(X(0,s)-x_lower(0))/dx(0))
            ic_lower(0) = ifirst0
            ic_upper(0) = ifirst0+5
         elseif (touches_upper_bdry(0)) then
            call lagrangian_one_sided_ib_6_delta(
     &           f,(x_upper(0)-X(0,s))/dx(0))
            do k = 0,5
               w0(5-k) = f(k)
            enddo
            ic_lower(0) = ilast0-5
            ic_upper(0) = ilast0
         endif

         if (touches_lower_bdry(1)) then
            call lagrangian_one_sided_ib_6_delta(
     &           w1,(X(1,s)-x_lower(1))/dx(1))
            ic_lower(1) = ifirst1
            ic_upper(1) = ifirst1+5
         elseif (touches_upper_bdry(1)) then
            call lagrangian_one_sided_ib_6_delta(
     &           f,(x_upper(1)-X(1,s))/dx(1))
            do k = 0,5
               w1(5-k) = f(k)
            enddo
            ic_lower(1) = ilast1-5
            ic_upper(1) = ilast1
         endif
c
c     Spread V onto u.
c
         call f_fpu_fix_start(old_cw)
         do d = 0,depth-1
C     DEC$ LOOP COUNT(6)
            do ic1 = ic_lower(1),ic_upper(1)
C     DEC$ LOOP COUNT(6)
C     DEC$ NOVECTOR
               do ic0 = ic_lower(0),ic_upper(0)
                  u_work(ic0,ic1,d) = u_work(ic0,ic1,d)+(
     &                 w0(ic0-ic_lower(0))*
     &                 w1(ic1-ic_lower(1))*
     &                 V(d,s)/(dx(0)*dx(1)))
               enddo
            enddo
         enddo
         call f_fpu_fix_end(old_cw)
      enddo
c
c     Copy u_work to u and deallocate temporary workspace.
c
      call f_fpu_fix_start(old_cw)
      do d = 0,depth-1
         do ic1 = ifirst1-nugc1,ilast1+nugc1
            do ic0 = ifirst0-nugc0,ilast0+nugc0
               u(ic0,ic1,d) = u_work(ic0,ic1,d)
            enddo
         enddo
      enddo
      call f_fpu_fix_end(old_cw)
      DEALLOCATE( u_work )
c
      return
      end
c
ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc