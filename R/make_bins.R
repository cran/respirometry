#' @title Make time binning thresholds for MO2 calculations
#' 
#' @description The width of time bins seems to be an under-appreciated consideration when calculating metabolic rates if PO2 or time are interesting covariates. The wider the bins, the higher the precision of your calculated MO2 value (more observations to average over), but at a loss of resolution of an interesting covariate. The narrower the bins, the higher the resolution of the PO2 or time covariate, but at a cost of lower precision. For Pcrit trials, I have found good success using bins of 1/10th the trial duration at the highest PO2s (where good precision is important) and 1/100th the trial duration at the lowest PO2s (where good resolution is important). Thus, these are the defaults, but can be changed as desired.
#' 
#' @param o2 numeric vector of O2 observations.
#' @param duration numeric vector of the timepoints for each observation (minutes).
#' @param good_data logical vector of whether O2 observations are "good" measurements and should be included in analysis. Default is that all observations are \code{TRUE}.
#' @param min_o2_width The duration of the bins at the lowest O2 value, expressed as a proportion of the total "good" trial duration. Default is 1/100th of the total "good" trial duration.
#' @param max_o2_width The duration of the bins at the highest O2 value, expressed as a proportion of the total "good" trial duration. Default is 1/10th of the total "good" trial duration.
#' @param n_thresholds Default is 10.
#'
#' @return A data.frame with \code{n_thresholds} rows and two columns is returned. Each row describes the threshold and the duration of observations that will be binned together at or above the corresponding O2 value.
#' \describe{
#' \item{o2}{The various O2 thresholds at which bin widths change.}
#' \item{width}{The bin width applied to values greater than the corresponding row's O2 value but less than the next greater O2 value.}
#' }
#' 
#' @author Matthew A. Birk, \email{matthewabirk@@gmail.com}
#' @seealso \code{\link{calc_MO2}}
#' 
#' @examples
#' # get O2 data
#' file <- system.file('extdata', 'witrox_file.txt', package = 'respirometry')
#' o2_data <- na.omit(import_witrox(file, split_channels = TRUE)$CH_4)
#' 
#' # Total trial duration is 21.783 minutes
#' 
#' make_bins(o2 = o2_data$O2, duration = o2_data$DURATION) # creates the default 10 bins. At the
#' # highest O2 levels, bin widths are 21.783/10 = 2.1783 mins and at the lowest O2 levels, bin
#' # widths are 21.783/100 = 0.21783 mins.
#' 
#' bins <- make_bins(o2 = o2_data$O2, duration = o2_data$DURATION, min_o2_width = 1/20,
#' max_o2_width = 1/3, n_thresholds = 5) # creates 5 bins. At the highest O2 levels, bin widths are
#' # 21.783/3 = 7.261 mins and at the lowest O2 levels, bin widths are 21.783/20 = 1.089 mins.
#' 
#' (mo2 <- calc_MO2(duration = o2_data$DURATION, o2 = o2_data$O2,
#' bin_width = bins, vol = 10, temp = o2_data$TEMP, sal = o2_data$SAL))
#'
#' @encoding UTF-8
#' @export

make_bins = function(o2, duration, good_data = TRUE, min_o2_width = 1/100, max_o2_width = 1/10, n_thresholds = 10){
	if(methods::hasArg(good_data)){
		o2 = o2[good_data]
		duration = duration[good_data]
	}
	df = data.frame(o2 = birk::range_seq(o2, length.out = n_thresholds), width = seq(diff(range(duration, na.rm = TRUE)) * min_o2_width, diff(range(duration, na.rm = TRUE)) * max_o2_width, length.out = n_thresholds))
	df = df[nrow(df):1, ]
	row.names(df) = NULL
	return(df)
}
