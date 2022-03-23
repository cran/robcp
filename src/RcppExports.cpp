// Generated by using Rcpp::compileAttributes() -> do not edit by hand
// Generator token: 10BE3573-1514-4C36-9D1C-5A225CD40393

#include <Rcpp.h>

using namespace Rcpp;

#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif

// Qalpha
NumericVector Qalpha(NumericVector x, double alpha);
RcppExport SEXP _robcp_Qalpha(SEXP xSEXP, SEXP alphaSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type x(xSEXP);
    Rcpp::traits::input_parameter< double >::type alpha(alphaSEXP);
    rcpp_result_gen = Rcpp::wrap(Qalpha(x, alpha));
    return rcpp_result_gen;
END_RCPP
}
// weightedMedian
double weightedMedian(NumericVector x, IntegerVector w);
RcppExport SEXP _robcp_weightedMedian(SEXP xSEXP, SEXP wSEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type x(xSEXP);
    Rcpp::traits::input_parameter< IntegerVector >::type w(wSEXP);
    rcpp_result_gen = Rcpp::wrap(weightedMedian(x, w));
    return rcpp_result_gen;
END_RCPP
}
// kthPair
double kthPair(NumericVector X, NumericVector Y, int k, int k2);
RcppExport SEXP _robcp_kthPair(SEXP XSEXP, SEXP YSEXP, SEXP kSEXP, SEXP k2SEXP) {
BEGIN_RCPP
    Rcpp::RObject rcpp_result_gen;
    Rcpp::RNGScope rcpp_rngScope_gen;
    Rcpp::traits::input_parameter< NumericVector >::type X(XSEXP);
    Rcpp::traits::input_parameter< NumericVector >::type Y(YSEXP);
    Rcpp::traits::input_parameter< int >::type k(kSEXP);
    Rcpp::traits::input_parameter< int >::type k2(k2SEXP);
    rcpp_result_gen = Rcpp::wrap(kthPair(X, Y, k, k2));
    return rcpp_result_gen;
END_RCPP
}

RcppExport SEXP c_cumsum(SEXP);
RcppExport SEXP c_cumsum_ma(SEXP, SEXP, SEXP);
RcppExport SEXP cholesky(SEXP, SEXP, SEXP, SEXP, SEXP);
RcppExport SEXP CUSUM(SEXP);
RcppExport SEXP CUSUM_ma(SEXP, SEXP, SEXP, SEXP, SEXP);
RcppExport SEXP gen_matrix(SEXP, SEXP, SEXP);
RcppExport SEXP GMD(SEXP, SEXP);
RcppExport SEXP lrv(SEXP, SEXP, SEXP);
RcppExport SEXP lrv_matrix(SEXP, SEXP, SEXP, SEXP, SEXP);
RcppExport SEXP lrv_rho(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
RcppExport SEXP lrv_subs_nonoverlap(SEXP, SEXP, SEXP, SEXP);
RcppExport SEXP lrv_subs_overlap(SEXP, SEXP, SEXP);
RcppExport SEXP MD(SEXP, SEXP, SEXP);
RcppExport SEXP pKSdist(SEXP, SEXP);
RcppExport SEXP psi(SEXP, SEXP, SEXP, SEXP, SEXP, SEXP, SEXP);
RcppExport SEXP tau(SEXP, SEXP, SEXP);
RcppExport SEXP trafo_tau(SEXP, SEXP);
RcppExport SEXP wilcox(SEXP);

static const R_CallMethodDef CallEntries[] = {
    {"_robcp_Qalpha", (DL_FUNC) &_robcp_Qalpha, 2},
    {"_robcp_weightedMedian", (DL_FUNC) &_robcp_weightedMedian, 2},
    {"_robcp_kthPair", (DL_FUNC) &_robcp_kthPair, 4},
    {"c_cumsum",            (DL_FUNC) &c_cumsum,            1},
    {"c_cumsum_ma",         (DL_FUNC) &c_cumsum_ma,         3},
    {"cholesky",            (DL_FUNC) &cholesky,            5},
    {"CUSUM",               (DL_FUNC) &CUSUM,               1},
    {"CUSUM_ma",            (DL_FUNC) &CUSUM_ma,            5},
    {"gen_matrix",          (DL_FUNC) &gen_matrix,          3},
    {"GMD",                 (DL_FUNC) &GMD,                 2},
    {"lrv",                 (DL_FUNC) &lrv,                 3},
    {"lrv_matrix",          (DL_FUNC) &lrv_matrix,          5},
    {"lrv_rho",             (DL_FUNC) &lrv_rho,             6},
    {"lrv_subs_nonoverlap", (DL_FUNC) &lrv_subs_nonoverlap, 4},
    {"lrv_subs_overlap",    (DL_FUNC) &lrv_subs_overlap,    3},
    {"MD",                  (DL_FUNC) &MD,                  3},
    {"pKSdist",             (DL_FUNC) &pKSdist,             2},
    {"psi",                 (DL_FUNC) &psi,                 7},
    {"tau",                 (DL_FUNC) &tau,                 3},
    {"trafo_tau",           (DL_FUNC) &trafo_tau,           2},
    {"wilcox",              (DL_FUNC) &wilcox,              1},
    {NULL, NULL, 0}
};

RcppExport void R_init_robcp(DllInfo *dll) {
    R_registerRoutines(dll, NULL, CallEntries, NULL, NULL);
    R_useDynamicSymbols(dll, FALSE);
}
