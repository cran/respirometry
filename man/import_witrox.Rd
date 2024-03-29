% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import_witrox.R
\encoding{UTF-8}
\name{import_witrox}
\alias{import_witrox}
\title{Import data from a Loligo Systems Witrox O2 transmitter}
\usage{
import_witrox(
  file,
  o2_unit = "percent_a.s.",
  date = "\%m/\%d/\%Y \%I:\%M:\%S \%p",
  overwrite_sal = NULL,
  drop_channels = TRUE,
  split_channels = FALSE
)
}
\arguments{
\item{file}{a character string. The filepath for the file to be read.}

\item{o2_unit}{a character string. The unit of O2 measurement to be output in the data frame. Options are described in \code{\link{conv_o2}}.}

\item{date}{a character string. The date format to be passed to \code{\link{strptime}}.}

\item{overwrite_sal}{Default \code{NULL}. To overwrite the salinity value(s) from calibration, enter a single numeric value for all channels or a numeric vector with values for each channel. Salinity of water sample (psu).}

\item{drop_channels}{logical. Should channels without any O2 data be dropped? Default is \code{TRUE}.}

\item{split_channels}{logical. Should a list of data frames be returned with a separate data frame for each channel? Default is \code{FALSE}.}
}
\value{
A data frame (or list of data frames) is returned.
\describe{
\item{TIME}{Date and time, POSIXlt format.}
\item{DURATION}{Duration of measurement trial (minutes).}
\item{ATM_PRES}{Atmospheric pressure (mbar).}
\item{CH_X_PHASE}{Phase recorded. Phase is inversely related to O2.}
\item{CH_X_TEMP}{Temperature recorded or defined at beginning of measurement trial.}
\item{CH_X_SAL}{Salinity (psu).}
\item{CH_X_O2}{Oxygen measurement in desired unit as determined by \code{o2_unit}.}
\item{...}{Channel columns (CH_...) are repeated for each channel.}
}
If \code{split_channels = TRUE}, then "\code{CH_X_}" is removed from the column names and multiple data frames are returned in a list.
}
\description{
Imports the standard txt file output from Loligo Systems Witrox fiber optic O2 transmitters and converts the data into one or more data frames.
}
\details{
The following Loligo Systems fiber optic O2 transmitters are supported:
\itemize{
\item{Witrox 4}{}
}
If you would like support for the Witrox 1, email me a data file from this device.
}
\examples{
\dontrun{
file <- system.file('extdata', 'witrox_file.txt', package = 'respirometry')
import_witrox(file, o2_unit = 'umol_per_l')

# Oops. I forgot to change the salinity value when I calibrated
# the instrument. Override the values in the file for 35 psu.
import_witrox(file, o2_unit = 'umol_per_kg', overwrite_sal = 35)

# I want each channel as a separate data frame.
data_list <- import_witrox(file, split_channels = TRUE)
data_list$CH_3 # here's the channel 3 data frame.
}

}
\seealso{
\code{\link{import_pyroscience_workbench}}, \code{\link{import_firesting}}, \code{\link{import_presens}}, \code{\link{conv_o2}}
}
\author{
Matthew A. Birk, \email{matthewabirk@gmail.com}
}
