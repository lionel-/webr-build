#!/bin/bash
set -eu

# Build R for web with emscripten

pushd src/extra/blas
${EMFC} -c cmplxblas.f -o cmplxblas.o
${EMFC} -c blas.f -o blas.o
rm -f libRblas.a
emar -cr libRblas.a blas.o cmplxblas.o
popd

pushd src/extra/xdr
emcc ${CFLAGS} -I. -c xdr.c -o xdr.o
emcc ${CFLAGS} -I. -c xdr_float.c -o xdr_float.o
emcc ${CFLAGS} -I. -c xdr_mem.c -o xdr_mem.o
emcc ${CFLAGS} -I. -c xdr_stdio.c -o xdr_stdio.o
rm -f libxdr.a
emar -cr libxdr.a xdr.o xdr_float.o xdr_mem.o xdr_stdio.o
popd

pushd src/extra/tre
emcc ${CFLAGS} -I. -c regcomp.c -o regcomp.o
emcc ${CFLAGS} -I. -c regerror.c -o regerror.o
emcc ${CFLAGS} -I. -c regexec.c -o regexec.o
emcc ${CFLAGS} -I. -c tre-ast.c -o tre-ast.o
emcc ${CFLAGS} -I. -c tre-compile.c -o tre-compile.o
emcc ${CFLAGS} -I. -c tre-match-approx.c -o tre-match-approx.o
emcc ${CFLAGS} -I. -c tre-match-backtrack.c -o tre-match-backtrack.o
emcc ${CFLAGS} -I. -c tre-match-parallel.c -o tre-match-parallel.o
emcc ${CFLAGS} -I. -c tre-mem.c -o tre-mem.o
emcc ${CFLAGS} -I. -c tre-parse.c -o tre-parse.o
emcc ${CFLAGS} -I. -c tre-stack.c -o tre-stack.o
emcc ${CFLAGS} -I. -c xmalloc.c -o xmalloc.o
rm -f libtre.a
emar -cr libtre.a regcomp.o regerror.o regexec.o tre-ast.o tre-compile.o tre-match-approx.o tre-match-backtrack.o tre-match-parallel.o tre-mem.o tre-parse.o tre-stack.o xmalloc.o
popd

pushd src/appl
emcc ${CFLAGS} -I. -c integrate.c -o integrate.o
emcc ${CFLAGS} -I. -c interv.c -o interv.o
emcc ${CFLAGS} -I. -c maxcol.c -o maxcol.o
emcc ${CFLAGS} -I. -c optim.c -o optim.o
emcc ${CFLAGS} -I. -c pretty.c -o pretty.o
emcc ${CFLAGS} -I. -c uncmin.c -o uncmin.o
${EMFC} -c dchdc.f -o dchdc.o
${EMFC} -c dpbfa.f -o dpbfa.o
${EMFC} -c dpbsl.f -o dpbsl.o
${EMFC} -c dpoco.f -o dpoco.o
${EMFC} -c dpodi.f -o dpodi.o
${EMFC} -c dpofa.f -o dpofa.o
${EMFC} -c dposl.f -o dposl.o
${EMFC} -c dqrdc.f -o dqrdc.o
${EMFC} -c dqrdc2.f -o dqrdc2.o
${EMFC} -c dqrls.f -o dqrls.o
${EMFC} -c dqrsl.f -o dqrsl.o
${EMFC} -c dqrutl.f -o dqrutl.o
${EMFC} -c dsvdc.f -o dsvdc.o
${EMFC} -c dtrco.f -o dtrco.o
${EMFC} -c dtrsl.f -o dtrsl.o
rm -f libappl.a
emar -cr libappl.a integrate.o interv.o maxcol.o optim.o pretty.o uncmin.o dchdc.o dpbfa.o dpbsl.o dpoco.o dpodi.o dpofa.o dposl.o dqrdc.o dqrdc2.o dqrls.o dqrsl.o dqrutl.o dsvdc.o dtrco.o dtrsl.o
popd

pushd src/nmath
emcc ${CFLAGS} -I. -c mlutils.c -o mlutils.o
emcc ${CFLAGS} -I. -c d1mach.c -o d1mach.o
emcc ${CFLAGS} -I. -c i1mach.c -o i1mach.o
emcc ${CFLAGS} -I. -c fmax2.c -o fmax2.o
emcc ${CFLAGS} -I. -c fmin2.c -o fmin2.o
emcc ${CFLAGS} -I. -c fprec.c -o fprec.o
emcc ${CFLAGS} -I. -c fround.c -o fround.o
emcc ${CFLAGS} -I. -c ftrunc.c -o ftrunc.o
emcc ${CFLAGS} -I. -c sign.c -o sign.o
emcc ${CFLAGS} -I. -c fsign.c -o fsign.o
emcc ${CFLAGS} -I. -c imax2.c -o imax2.o
emcc ${CFLAGS} -I. -c imin2.c -o imin2.o
emcc ${CFLAGS} -I. -c chebyshev.c -o chebyshev.o
emcc ${CFLAGS} -I. -c log1p.c -o log1p.o
emcc ${CFLAGS} -I. -c lgammacor.c -o lgammacor.o
emcc ${CFLAGS} -I. -c gammalims.c -o gammalims.o
emcc ${CFLAGS} -I. -c stirlerr.c -o stirlerr.o
emcc ${CFLAGS} -I. -c bd0.c -o bd0.o
emcc ${CFLAGS} -I. -c gamma.c -o gamma.o
emcc ${CFLAGS} -I. -c lgamma.c -o lgamma.o
emcc ${CFLAGS} -I. -c gamma_cody.c -o gamma_cody.o
emcc ${CFLAGS} -I. -c beta.c -o beta.o
emcc ${CFLAGS} -I. -c lbeta.c -o lbeta.o
emcc ${CFLAGS} -I. -c polygamma.c -o polygamma.o
emcc ${CFLAGS} -I. -c cospi.c -o cospi.o
emcc ${CFLAGS} -I. -c bessel_i.c -o bessel_i.o
emcc ${CFLAGS} -I. -c bessel_j.c -o bessel_j.o
emcc ${CFLAGS} -I. -c bessel_k.c -o bessel_k.o
emcc ${CFLAGS} -I. -c bessel_y.c -o bessel_y.o
emcc ${CFLAGS} -I. -c choose.c -o choose.o
emcc ${CFLAGS} -I. -c snorm.c -o snorm.o
emcc ${CFLAGS} -I. -c sexp.c -o sexp.o
emcc ${CFLAGS} -I. -c dgamma.c -o dgamma.o
emcc ${CFLAGS} -I. -c pgamma.c -o pgamma.o
emcc ${CFLAGS} -I. -c qgamma.c -o qgamma.o
emcc ${CFLAGS} -I. -c rgamma.c -o rgamma.o
emcc ${CFLAGS} -I. -c dbeta.c -o dbeta.o
emcc ${CFLAGS} -I. -c pbeta.c -o pbeta.o
emcc ${CFLAGS} -I. -c qbeta.c -o qbeta.o
emcc ${CFLAGS} -I. -c rbeta.c -o rbeta.o
emcc ${CFLAGS} -I. -c dunif.c -o dunif.o
emcc ${CFLAGS} -I. -c punif.c -o punif.o
emcc ${CFLAGS} -I. -c qunif.c -o qunif.o
emcc ${CFLAGS} -I. -c runif.c -o runif.o
emcc ${CFLAGS} -I. -c dnorm.c -o dnorm.o
emcc ${CFLAGS} -I. -c pnorm.c -o pnorm.o
emcc ${CFLAGS} -I. -c qnorm.c -o qnorm.o
emcc ${CFLAGS} -I. -c rnorm.c -o rnorm.o
emcc ${CFLAGS} -I. -c dlnorm.c -o dlnorm.o
emcc ${CFLAGS} -I. -c plnorm.c -o plnorm.o
emcc ${CFLAGS} -I. -c qlnorm.c -o qlnorm.o
emcc ${CFLAGS} -I. -c rlnorm.c -o rlnorm.o
emcc ${CFLAGS} -I. -c df.c -o df.o
emcc ${CFLAGS} -I. -c pf.c -o pf.o
emcc ${CFLAGS} -I. -c qf.c -o qf.o
emcc ${CFLAGS} -I. -c rf.c -o rf.o
emcc ${CFLAGS} -I. -c dnf.c -o dnf.o
emcc ${CFLAGS} -I. -c dt.c -o dt.o
emcc ${CFLAGS} -I. -c pt.c -o pt.o
emcc ${CFLAGS} -I. -c qt.c -o qt.o
emcc ${CFLAGS} -I. -c rt.c -o rt.o
emcc ${CFLAGS} -I. -c dnt.c -o dnt.o
emcc ${CFLAGS} -I. -c dchisq.c -o dchisq.o
emcc ${CFLAGS} -I. -c pchisq.c -o pchisq.o
emcc ${CFLAGS} -I. -c qchisq.c -o qchisq.o
emcc ${CFLAGS} -I. -c rchisq.c -o rchisq.o
emcc ${CFLAGS} -I. -c rnchisq.c -o rnchisq.o
emcc ${CFLAGS} -I. -c dbinom.c -o dbinom.o
emcc ${CFLAGS} -I. -c pbinom.c -o pbinom.o
emcc ${CFLAGS} -I. -c qbinom.c -o qbinom.o
emcc ${CFLAGS} -I. -c rbinom.c -o rbinom.o
emcc ${CFLAGS} -I. -c rmultinom.c -o rmultinom.o
emcc ${CFLAGS} -I. -c dcauchy.c -o dcauchy.o
emcc ${CFLAGS} -I. -c pcauchy.c -o pcauchy.o
emcc ${CFLAGS} -I. -c qcauchy.c -o qcauchy.o
emcc ${CFLAGS} -I. -c rcauchy.c -o rcauchy.o
emcc ${CFLAGS} -I. -c dexp.c -o dexp.o
emcc ${CFLAGS} -I. -c pexp.c -o pexp.o
emcc ${CFLAGS} -I. -c qexp.c -o qexp.o
emcc ${CFLAGS} -I. -c rexp.c -o rexp.o
emcc ${CFLAGS} -I. -c dgeom.c -o dgeom.o
emcc ${CFLAGS} -I. -c pgeom.c -o pgeom.o
emcc ${CFLAGS} -I. -c qgeom.c -o qgeom.o
emcc ${CFLAGS} -I. -c rgeom.c -o rgeom.o
emcc ${CFLAGS} -I. -c dhyper.c -o dhyper.o
emcc ${CFLAGS} -I. -c phyper.c -o phyper.o
emcc ${CFLAGS} -I. -c qhyper.c -o qhyper.o
emcc ${CFLAGS} -I. -c rhyper.c -o rhyper.o
emcc ${CFLAGS} -I. -c dnbinom.c -o dnbinom.o
emcc ${CFLAGS} -I. -c pnbinom.c -o pnbinom.o
emcc ${CFLAGS} -I. -c qnbinom.c -o qnbinom.o
emcc ${CFLAGS} -I. -c qnbinom_mu.c -o qnbinom_mu.o
emcc ${CFLAGS} -I. -c rnbinom.c -o rnbinom.o
emcc ${CFLAGS} -I. -c dpois.c -o dpois.o
emcc ${CFLAGS} -I. -c ppois.c -o ppois.o
emcc ${CFLAGS} -I. -c qpois.c -o qpois.o
emcc ${CFLAGS} -I. -c rpois.c -o rpois.o
emcc ${CFLAGS} -I. -c dweibull.c -o dweibull.o
emcc ${CFLAGS} -I. -c pweibull.c -o pweibull.o
emcc ${CFLAGS} -I. -c qweibull.c -o qweibull.o
emcc ${CFLAGS} -I. -c rweibull.c -o rweibull.o
emcc ${CFLAGS} -I. -c dlogis.c -o dlogis.o
emcc ${CFLAGS} -I. -c plogis.c -o plogis.o
emcc ${CFLAGS} -I. -c qlogis.c -o qlogis.o
emcc ${CFLAGS} -I. -c rlogis.c -o rlogis.o
emcc ${CFLAGS} -I. -c dnchisq.c -o dnchisq.o
emcc ${CFLAGS} -I. -c pnchisq.c -o pnchisq.o
emcc ${CFLAGS} -I. -c qnchisq.c -o qnchisq.o
emcc ${CFLAGS} -I. -c dnbeta.c -o dnbeta.o
emcc ${CFLAGS} -I. -c pnbeta.c -o pnbeta.o
emcc ${CFLAGS} -I. -c qnbeta.c -o qnbeta.o
emcc ${CFLAGS} -I. -c pnf.c -o pnf.o
emcc ${CFLAGS} -I. -c pnt.c -o pnt.o
emcc ${CFLAGS} -I. -c qnf.c -o qnf.o
emcc ${CFLAGS} -I. -c qnt.c -o qnt.o
emcc ${CFLAGS} -I. -c ptukey.c -o ptukey.o
emcc ${CFLAGS} -I. -c qtukey.c -o qtukey.o
emcc ${CFLAGS} -I. -c toms708.c -o toms708.o
emcc ${CFLAGS} -I. -c wilcox.c -o wilcox.o
emcc ${CFLAGS} -I. -c signrank.c -o signrank.o
rm -f libnmath.a
emar -cr libnmath.a mlutils.o d1mach.o i1mach.o fmax2.o fmin2.o fprec.o fround.o ftrunc.o sign.o fsign.o imax2.o imin2.o chebyshev.o log1p.o lgammacor.o gammalims.o stirlerr.o bd0.o gamma.o lgamma.o gamma_cody.o beta.o lbeta.o polygamma.o cospi.o bessel_i.o bessel_j.o bessel_k.o bessel_y.o choose.o snorm.o sexp.o dgamma.o pgamma.o qgamma.o rgamma.o dbeta.o pbeta.o qbeta.o rbeta.o dunif.o punif.o qunif.o runif.o dnorm.o pnorm.o qnorm.o rnorm.o dlnorm.o plnorm.o qlnorm.o rlnorm.o df.o pf.o qf.o rf.o dnf.o dt.o pt.o qt.o rt.o dnt.o dchisq.o pchisq.o qchisq.o rchisq.o rnchisq.o dbinom.o pbinom.o qbinom.o rbinom.o rmultinom.o dcauchy.o pcauchy.o qcauchy.o rcauchy.o dexp.o pexp.o qexp.o rexp.o dgeom.o pgeom.o qgeom.o rgeom.o dhyper.o phyper.o qhyper.o rhyper.o dnbinom.o pnbinom.o qnbinom.o qnbinom_mu.o rnbinom.o dpois.o ppois.o qpois.o rpois.o dweibull.o pweibull.o qweibull.o rweibull.o dlogis.o plogis.o qlogis.o rlogis.o dnchisq.o pnchisq.o qnchisq.o dnbeta.o pnbeta.o qnbeta.o pnf.o pnt.o qnf.o qnt.o ptukey.o qtukey.o toms708.o wilcox.o signrank.o
popd

pushd src/unix
emcc ${CFLAGS} -I. -c Rembedded.c -o Rembedded.o
emcc ${CFLAGS} -I. -c dynload.c -o dynload.o
emcc ${CFLAGS} -I. -c system.c -o system.o
emcc ${CFLAGS} -I. -c sys-unix.c -o sys-unix.o
emcc ${CFLAGS} -I. -c sys-std.c -o sys-std.o
emcc ${CFLAGS} -I. -c X11.c -o X11.o
rm -f libunix.a
emar -cr libunix.a Rembedded.o dynload.o system.o sys-unix.o sys-std.o X11.o
emcc ${CFLAGS} -I. -DR_HOME='"/"' ${LDFLAGS} -o Rscript ./Rscript.c
popd

pushd src/modules/lapack
${EMFC} -c dlamch.f -o dlamch.o
${EMFC} -c dlapack.f -o dlapack.o
${EMFC} -c cmplx.f -o cmplx.o
emcc ${CFLAGS} -I. -c Lapack.c -o Lapack.o
rm -f libRlapack.a
emar -cr libRlapack.a dlamch.o dlapack.o cmplx.o Lapack.o
emcc ${LDFLAGS} -o lapack.so dlamch.o dlapack.o cmplx.o Lapack.o \
     -lRblas -L${R_SOURCE}/src/extra/blas \
     ${FORTRAN_LDFLAGS}
cp lapack.so "${WEBR_INSTALL}/lib/R/modules/"
popd

if [[ ! -z "${BUILD_INTERNET-}" ]]; then
	pushd src/modules/internet
	# Note: xhr.o has been linked into the main module, rather than via internet.so, so that asyncify works
	# emscripten-core/emscripten/issues/15594
	emcc ${CFLAGS} -I. -c internet.c -o internet.o
	emcc ${CFLAGS} -I. -c xhr.c -o xhr.o
	emcc ${LDFLAGS} -o internet.so internet.o
	cp internet.so ${WEBR_INSTALL}/lib/R/modules/
	popd
fi

pushd src/library/tools/src
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c text.c -o text.o
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c init.c -o init.o
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c Rmd5.c -o Rmd5.o
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c md5.c -o md5.o
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c signals.c -o signals.o
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c install.c -o install.o
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c getfmts.c -o getfmts.o
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c http.c -o http.o
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c gramLatex.c -o gramLatex.o
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c gramRd.c -o gramRd.o
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c pdscan.c -o pdscan.o
rm -f tools.a
emar -cr tools.a text.o init.o Rmd5.o md5.o signals.o install.o getfmts.o http.o gramLatex.o gramRd.o pdscan.o
emcc ${PKG_LDFLAGS} -o tools.so text.o init.o Rmd5.o md5.o signals.o install.o getfmts.o http.o gramLatex.o gramRd.o pdscan.o
cp tools.so ${WEBR_INSTALL}/lib/R/library/tools/libs/
popd

pushd src/library/grid/src
emcc ${PKG_CFLAGS} -c clippath.c -o clippath.o
emcc ${PKG_CFLAGS} -c gpar.c -o gpar.o
emcc ${PKG_CFLAGS} -c grid.c -o grid.o
emcc ${PKG_CFLAGS} -c just.c -o just.o
emcc ${PKG_CFLAGS} -c layout.c -o layout.o
emcc ${PKG_CFLAGS} -c mask.c -o mask.o
emcc ${PKG_CFLAGS} -c matrix.c -o matrix.o
emcc ${PKG_CFLAGS} -c register.c -o register.o
emcc ${PKG_CFLAGS} -c state.c -o state.o
emcc ${PKG_CFLAGS} -c unit.c -o unit.o
emcc ${PKG_CFLAGS} -c util.c -o util.o
emcc ${PKG_CFLAGS} -c viewport.c -o viewport.o
rm -f grid.a
emar -cr grid.a clippath.o gpar.o grid.o just.o layout.o mask.o matrix.o register.o state.o unit.o util.o viewport.o
emcc ${PKG_LDFLAGS} -o grid.so clippath.o gpar.o grid.o just.o layout.o mask.o matrix.o register.o state.o unit.o util.o viewport.o
cp grid.so ${WEBR_INSTALL}/lib/R/library/grid/libs/
popd

pushd src/library/splines/src
emcc ${PKG_CFLAGS} -c splines.c -o splines.o
rm -f splines.a
emar -cr splines.a splines.o
emcc ${PKG_LDFLAGS} -o splines.so splines.o
cp splines.so ${WEBR_INSTALL}/lib/R/library/splines/libs/
popd

pushd src/library/methods/src
emcc ${PKG_CFLAGS} -c do_substitute_direct.c -o do_substitute_direct.o
emcc ${PKG_CFLAGS} -c init.c -o init.o
emcc ${PKG_CFLAGS} -c methods_list_dispatch.c -o methods_list_dispatch.o
emcc ${PKG_CFLAGS} -c slot.c -o slot.o
emcc ${PKG_CFLAGS} -c class_support.c -o class_support.o
emcc ${PKG_CFLAGS} -c tests.c -o tests.o
emcc ${PKG_CFLAGS} -c utils.c -o utils.o
rm -f methods.a
emar -cr methods.a do_substitute_direct.o init.o methods_list_dispatch.o slot.o class_support.o tests.o utils.o
emcc ${PKG_LDFLAGS} -o methods.so do_substitute_direct.o init.o methods_list_dispatch.o slot.o class_support.o tests.o utils.o
cp methods.so ${WEBR_INSTALL}/lib/R/library/methods/libs/
popd

pushd src/library/utils/src
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c init.c -o init.o
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c io.c -o io.o
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c size.c -o size.o
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c sock.c -o sock.o
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c stubs.c -o stubs.o
emcc ${PKG_CFLAGS} -I"${R_SOURCE}/src/main" -c utils.c -o utils.o
rm -f utils.a
emar -cr utils.a init.o io.o size.o sock.o stubs.o utils.o
emcc ${PKG_LDFLAGS} -o utils.so "${WEBR_INSTALL}/lib/liblzma.a" init.o io.o size.o sock.o stubs.o utils.o
cp utils.so ${WEBR_INSTALL}/lib/R/library/utils/libs/
popd

pushd src/library/grDevices/src
emcc -s USE_BZIP2=1 -s USE_ZLIB=1 ${PKG_CFLAGS} -std=gnu11 -c axis_scales.c -o axis_scales.o
emcc ${PKG_CFLAGS} -std=gnu11 -c chull.c -o chull.o
emcc ${PKG_CFLAGS} -std=gnu11 -c devices.c -o devices.o
emcc ${PKG_CFLAGS} -std=gnu11 -c init.c -o init.o
emcc ${PKG_CFLAGS} -std=gnu11 -c stubs.c -o stubs.o
emcc ${PKG_CFLAGS} -std=gnu11 -c colors.c -o colors.o
emcc ${PKG_CFLAGS} -std=gnu11 -c clippath.c -o clippath.o
emcc ${PKG_CFLAGS} -std=gnu11 -c patterns.c -o patterns.o
emcc ${PKG_CFLAGS} -std=gnu11 -c mask.c -o mask.o
emcc ${PKG_CFLAGS} -std=gnu11 -c devCairo.c -o devCairo.o
emcc ${PKG_CFLAGS} -std=gnu11 -c devPicTeX.c -o devPicTeX.o
emcc ${PKG_CFLAGS} -std=gnu11 -c devPS.c -o devPS.o
emcc ${PKG_CFLAGS} -std=gnu11 -c devQuartz.c -o devQuartz.o
# Note: devCanvas.o has been linked into the main module, rather than via grDevices.so. At the time of writing EM_ASM does not work in a SIDE_MODULE.
emcc ${PKG_CFLAGS} -std=gnu11 -g -Oz -c devCanvas.c -o devCanvas.o
rm -f grDevices.a
emar -cr grDevices.a axis_scales.o chull.o devices.o init.o stubs.o colors.o clippath.o patterns.o mask.o devCairo.o devPicTeX.o devPS.o devQuartz.o
emcc ${PKG_LDFLAGS} -o grDevices.so axis_scales.o chull.o devices.o init.o stubs.o colors.o clippath.o patterns.o mask.o devCairo.o devPicTeX.o devPS.o devQuartz.o
cp grDevices.so ${WEBR_INSTALL}/lib/R/library/grDevices/libs/
popd

pushd src/library/graphics/src
emcc ${PKG_CFLAGS} -I../../../../src/main -c init.c -o init.o
emcc ${PKG_CFLAGS} -I../../../../src/main -c base.c -o base.o
emcc ${PKG_CFLAGS} -I../../../../src/main -c graphics.c -o graphics.o
emcc ${PKG_CFLAGS} -I../../../../src/main -c par.c -o par.o
emcc ${PKG_CFLAGS} -I../../../../src/main -c plot.c -o plot.o
emcc ${PKG_CFLAGS} -I../../../../src/main -c plot3d.c -o plot3d.o
emcc ${PKG_CFLAGS} -I../../../../src/main -c stem.c -o stem.o
rm -f graphics.a
emar -cr graphics.a init.o base.o graphics.o par.o plot.o plot3d.o stem.o
emcc ${PKG_LDFLAGS} -o graphics.so init.o base.o graphics.o par.o plot.o plot3d.o stem.o
cp graphics.so ${WEBR_INSTALL}/lib/R/library/graphics/libs/
popd

pushd src/main
${EMFC} -c xxxpr.f -o xxxpr.o
popd

pushd src/library/stats/src
emcc ${PKG_CFLAGS} -c init.c -o init.o
emcc ${PKG_CFLAGS} -c kmeans.c -o kmeans.o
emcc ${PKG_CFLAGS} -c ansari.c -o ansari.o
emcc ${PKG_CFLAGS} -c bandwidths.c -o bandwidths.o
emcc ${PKG_CFLAGS} -c chisqsim.c -o chisqsim.o
emcc ${PKG_CFLAGS} -c d2x2xk.c -o d2x2xk.o
emcc ${PKG_CFLAGS} -c fexact.c -o fexact.o
emcc ${PKG_CFLAGS} -c kendall.c -o kendall.o
emcc ${PKG_CFLAGS} -c ks.c -o ks.o
emcc ${PKG_CFLAGS} -c line.c -o line.o
emcc ${PKG_CFLAGS} -c smooth.c -o smooth.o
emcc ${PKG_CFLAGS} -c prho.c -o prho.o
emcc ${PKG_CFLAGS} -c swilk.c -o swilk.o
emcc ${PKG_CFLAGS} -c ksmooth.c -o ksmooth.o
emcc ${PKG_CFLAGS} -c loessc.c -o loessc.o
emcc ${PKG_CFLAGS} -c monoSpl.c -o monoSpl.o
emcc ${PKG_CFLAGS} -c isoreg.c -o isoreg.o
emcc ${PKG_CFLAGS} -c Srunmed.c -o Srunmed.o
emcc ${PKG_CFLAGS} -c dblcen.c -o dblcen.o
emcc ${PKG_CFLAGS} -c distance.c -o distance.o
emcc ${PKG_CFLAGS} -c hclust-utils.c -o hclust-utils.o
emcc ${PKG_CFLAGS} -c nls.c -o nls.o
emcc ${PKG_CFLAGS} -c rWishart.c -o rWishart.o
emcc ${PKG_CFLAGS} -c HoltWinters.c -o HoltWinters.o
emcc ${PKG_CFLAGS} -c PPsum.c -o PPsum.o
emcc ${PKG_CFLAGS} -c arima.c -o arima.o
emcc ${PKG_CFLAGS} -c burg.c -o burg.o
emcc ${PKG_CFLAGS} -c filter.c -o filter.o
emcc ${PKG_CFLAGS} -c mAR.c -o mAR.o
emcc ${PKG_CFLAGS} -c pacf.c -o pacf.o
emcc ${PKG_CFLAGS} -c starma.c -o starma.o
emcc ${PKG_CFLAGS} -c port.c -o port.o
emcc ${PKG_CFLAGS} -c family.c -o family.o
emcc ${PKG_CFLAGS} -c sbart.c -o sbart.o
emcc ${PKG_CFLAGS} -c approx.c -o approx.o
emcc ${PKG_CFLAGS} -c loglin.c -o loglin.o
emcc ${PKG_CFLAGS} -c lowess.c -o lowess.o
emcc ${PKG_CFLAGS} -c massdist.c -o massdist.o
emcc ${PKG_CFLAGS} -c splines.c -o splines.o
emcc ${PKG_CFLAGS} -c lm.c -o lm.o
emcc ${PKG_CFLAGS} -c complete_cases.c -o complete_cases.o
emcc ${PKG_CFLAGS} -c cov.c -o cov.o
emcc ${PKG_CFLAGS} -c deriv.c -o deriv.o
emcc ${PKG_CFLAGS} -c fft.c -o fft.o
emcc ${PKG_CFLAGS} -c fourier.c -o fourier.o
emcc ${PKG_CFLAGS} -c model.c -o model.o
emcc ${PKG_CFLAGS} -c optim.c -o optim.o
emcc ${PKG_CFLAGS} -c optimize.c -o optimize.o
emcc ${PKG_CFLAGS} -c integrate.c -o integrate.o
emcc ${PKG_CFLAGS} -c random.c -o random.o
emcc ${PKG_CFLAGS} -c distn.c -o distn.o
emcc ${PKG_CFLAGS} -c zeroin.c -o zeroin.o
emcc ${PKG_CFLAGS} -c rcont.c -o rcont.o
emcc ${PKG_CFLAGS} -c influence.c -o influence.o
${EMFC} -c bsplvd.f -o bsplvd.o
${EMFC} -c bvalue.f -o bvalue.o
${EMFC} -c bvalus.f -o bvalus.o
${EMFC} -c loessf.f -o loessf.o
${EMFC} -c ppr.f -o ppr.o
${EMFC} -c qsbart.f -o qsbart.o
${EMFC} -c sgram.f -o sgram.o
${EMFC} -c sinerp.f -o sinerp.o
${EMFC} -c sslvrg.f -o sslvrg.o
${EMFC} -c stxwx.f -o stxwx.o
${EMFC} -c hclust.f -o hclust.o
${EMFC} -c kmns.f -o kmns.o
${EMFC} -c eureka.f -o eureka.o
${EMFC} -c stl.f -o stl.o
${EMFC} -c portsrc.f -o portsrc.o
${EMFC} -c lminfl.f -o lminfl.o
rm -f stats.a
emar -cr stats.a init.o kmeans.o ansari.o bandwidths.o chisqsim.o d2x2xk.o fexact.o kendall.o ks.o line.o smooth.o prho.o swilk.o ksmooth.o loessc.o monoSpl.o isoreg.o Srunmed.o dblcen.o distance.o hclust-utils.o nls.o rWishart.o HoltWinters.o PPsum.o arima.o burg.o filter.o mAR.o pacf.o starma.o port.o family.o sbart.o approx.o loglin.o lowess.o massdist.o splines.o lm.o complete_cases.o cov.o deriv.o fft.o fourier.o model.o optim.o optimize.o integrate.o random.o distn.o zeroin.o rcont.o influence.o bsplvd.o bvalue.o bvalus.o loessf.o ppr.o qsbart.o sgram.o sinerp.o sslvrg.o stxwx.o hclust.o kmns.o eureka.o stl.o portsrc.o lminfl.o
emcc ${PKG_LDFLAGS} -o stats.so  init.o kmeans.o ansari.o bandwidths.o chisqsim.o d2x2xk.o fexact.o kendall.o ks.o line.o smooth.o prho.o swilk.o ksmooth.o loessc.o monoSpl.o isoreg.o Srunmed.o dblcen.o distance.o hclust-utils.o nls.o rWishart.o HoltWinters.o PPsum.o arima.o burg.o filter.o mAR.o pacf.o starma.o port.o family.o sbart.o approx.o loglin.o lowess.o massdist.o splines.o lm.o complete_cases.o cov.o deriv.o fft.o fourier.o model.o optim.o optimize.o integrate.o random.o distn.o zeroin.o rcont.o influence.o bsplvd.o bvalue.o bvalus.o loessf.o ppr.o qsbart.o sgram.o sinerp.o sslvrg.o stxwx.o hclust.o kmns.o eureka.o stl.o portsrc.o lminfl.o ../../../main/xxxpr.o \
     -lRlapack -L../../../modules/lapack \
     -lRblas -L${R_SOURCE}/src/extra/blas \
     ${FORTRAN_LDFLAGS}
cp stats.so ${WEBR_INSTALL}/lib/R/library/stats/libs/
popd

MAIN_CFLAGS="${CFLAGS} -I../../src/extra -I../../src/nmath -I."

pushd src/main
emcc ${MAIN_CFLAGS} -s USE_BZIP2=1 -s USE_ZLIB=1 ${PKG_CFLAGS} -c Rmain.c -o Rmain.o
emcc ${MAIN_CFLAGS} -c CommandLineArgs.c -o CommandLineArgs.o
emcc ${MAIN_CFLAGS} -c Rdynload.c -o Rdynload.o
emcc ${MAIN_CFLAGS} -c Renviron.c -o Renviron.o
emcc ${MAIN_CFLAGS} -c RNG.c -o RNG.o
emcc ${MAIN_CFLAGS} -c agrep.c -o agrep.o
emcc ${MAIN_CFLAGS} -c altclasses.c -o altclasses.o
emcc ${MAIN_CFLAGS} -c altrep.c -o altrep.o
emcc ${MAIN_CFLAGS} -c apply.c -o apply.o
emcc ${MAIN_CFLAGS} -c arithmetic.c -o arithmetic.o
emcc ${MAIN_CFLAGS} -c array.c -o array.o
emcc ${MAIN_CFLAGS} -c attrib.c -o attrib.o
emcc ${MAIN_CFLAGS} -c bind.c -o bind.o
emcc ${MAIN_CFLAGS} -c builtin.c -o builtin.o
emcc ${MAIN_CFLAGS} -c character.c -o character.o
emcc ${MAIN_CFLAGS} -c coerce.c -o coerce.o
emcc ${MAIN_CFLAGS} -c colors.c -o colors.o
emcc ${MAIN_CFLAGS} -c complex.c -o complex.o
emcc ${MAIN_CFLAGS} -c connections.c -o connections.o
emcc ${MAIN_CFLAGS} -c context.c -o context.o
emcc ${MAIN_CFLAGS} -c cum.c -o cum.o
emcc ${MAIN_CFLAGS} -c dcf.c -o dcf.o
emcc ${MAIN_CFLAGS} -c datetime.c -o datetime.o
emcc ${MAIN_CFLAGS} -c debug.c -o debug.o
emcc ${MAIN_CFLAGS} -c deparse.c -o deparse.o
emcc ${MAIN_CFLAGS} -c devices.c -o devices.o
emcc ${MAIN_CFLAGS} -c dotcode.c -o dotcode.o
emcc ${MAIN_CFLAGS} -c dounzip.c -o dounzip.o
emcc ${MAIN_CFLAGS} -c dstruct.c -o dstruct.o
emcc ${MAIN_CFLAGS} -c duplicate.c -o duplicate.o
emcc ${MAIN_CFLAGS} -c edit.c -o edit.o
emcc ${MAIN_CFLAGS} -c engine.c -o engine.o
emcc ${MAIN_CFLAGS} -c envir.c -o envir.o
emcc ${MAIN_CFLAGS} -c errors.c -o errors.o
emcc ${MAIN_CFLAGS} -c eval.c -o eval.o
emcc ${MAIN_CFLAGS} -c format.c -o format.o
emcc ${MAIN_CFLAGS} -c gevents.c -o gevents.o
emcc ${MAIN_CFLAGS} -Wno-empty-body -c gram.c -o gram.o
emcc ${MAIN_CFLAGS} -c gram-ex.c -o gram-ex.o
emcc ${MAIN_CFLAGS} -c graphics.c -o graphics.o
emcc ${MAIN_CFLAGS} -c grep.c -o grep.o
emcc ${MAIN_CFLAGS} -c identical.c -o identical.o
emcc ${MAIN_CFLAGS} -c inlined.c -o inlined.o
emcc ${MAIN_CFLAGS} -c inspect.c -o inspect.o
emcc ${MAIN_CFLAGS} -c internet.c -o internet.o
emcc ${MAIN_CFLAGS} -c iosupport.c -o iosupport.o
emcc ${MAIN_CFLAGS} -c lapack.c -o lapack.o
emcc ${MAIN_CFLAGS} -c list.c -o list.o
emcc ${MAIN_CFLAGS} -c localecharset.c -o localecharset.o
emcc ${MAIN_CFLAGS} -c logic.c -o logic.o
emcc ${MAIN_CFLAGS} -c main.c -o main.o
emcc ${MAIN_CFLAGS} -c mapply.c -o mapply.o
emcc ${MAIN_CFLAGS} -c match.c -o match.o
emcc ${MAIN_CFLAGS} -c memory.c -o memory.o
emcc ${MAIN_CFLAGS} -c names.c -o names.o
emcc ${MAIN_CFLAGS} -c objects.c -o objects.o
emcc ${MAIN_CFLAGS} -c options.c -o options.o
emcc ${MAIN_CFLAGS} -c paste.c -o paste.o
emcc ${MAIN_CFLAGS} -c patterns.c -o patterns.o
emcc ${MAIN_CFLAGS} -c platform.c -o platform.o
emcc ${MAIN_CFLAGS} -c plot.c -o plot.o
emcc ${MAIN_CFLAGS} -c plot3d.c -o plot3d.o
emcc ${MAIN_CFLAGS} -c plotmath.c -o plotmath.o
emcc ${MAIN_CFLAGS} -c print.c -o print.o
emcc ${MAIN_CFLAGS} -c printarray.c -o printarray.o
emcc ${MAIN_CFLAGS} -c printvector.c -o printvector.o
emcc ${MAIN_CFLAGS} -c printutils.c -o printutils.o
emcc ${MAIN_CFLAGS} -c qsort.c -o qsort.o
emcc ${MAIN_CFLAGS} -c radixsort.c -o radixsort.o
emcc ${MAIN_CFLAGS} -c random.c -o random.o
emcc ${MAIN_CFLAGS} -c raw.c -o raw.o
emcc ${MAIN_CFLAGS} -c registration.c -o registration.o
emcc ${MAIN_CFLAGS} -c relop.c -o relop.o
emcc ${MAIN_CFLAGS} -c rlocale.c -o rlocale.o
emcc ${MAIN_CFLAGS} -I../../src/extra/xdr -I. -c saveload.c -o saveload.o
emcc ${MAIN_CFLAGS} -c scan.c -o scan.o
emcc ${MAIN_CFLAGS} -c seq.c -o seq.o
emcc ${MAIN_CFLAGS} -I../../src/extra/xdr -I. -c serialize.c -o serialize.o
emcc ${MAIN_CFLAGS} -c sort.c -o sort.o
emcc ${MAIN_CFLAGS} -c source.c -o source.o
emcc ${MAIN_CFLAGS} -c split.c -o split.o
emcc ${MAIN_CFLAGS} -c sprintf.c -o sprintf.o
emcc ${MAIN_CFLAGS} -c startup.c -o startup.o
emcc ${MAIN_CFLAGS} -c subassign.c -o subassign.o
emcc ${MAIN_CFLAGS} -c subscript.c -o subscript.o
emcc ${MAIN_CFLAGS} -c subset.c -o subset.o
emcc ${MAIN_CFLAGS} -c summary.c -o summary.o
emcc ${MAIN_CFLAGS} -c sysutils.c -o sysutils.o
emcc ${MAIN_CFLAGS} -c times.c -o times.o
emcc ${MAIN_CFLAGS} -c unique.c -o unique.o
emcc ${MAIN_CFLAGS} -c util.c -o util.o
emcc ${MAIN_CFLAGS} -DR_ARCH='""' -c version.c -o version.o
emcc ${MAIN_CFLAGS} -c g_alab_her.c -o g_alab_her.o
emcc ${MAIN_CFLAGS} -c g_cntrlify.c -o g_cntrlify.o
emcc ${MAIN_CFLAGS} -c g_fontdb.c -o g_fontdb.o
emcc ${MAIN_CFLAGS} -c g_her_glyph.c -o g_her_glyph.o
popd
