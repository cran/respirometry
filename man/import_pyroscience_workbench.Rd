% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/import_pyroscience_workbench.R
\encoding{UTF-8}
\name{import_pyroscience_workbench}
\alias{import_pyroscience_workbench}
\title{Import data from Pyroscience Workbench}
\usage{
import_pyroscience_workbench(
  folder,
  o2_unit = "percent_a.s.",
  sal = NULL,
  keep_metadata = FALSE,
  split_channels = FALSE,
  merge_close_measurements = "min"
)
}
\arguments{
\item{folder}{a character string. The filepath to the parent folder (directory) which contains ChannelData.}

\item{o2_unit}{a character string. The unit of O2 measurement to be output in the data frame. Options are described in \code{\link{conv_o2}}.}

\item{sal}{numeric. If \code{o2_unit} is a concentration rather than partial pressure, the salinity of the chamber in which measurements were made must be entered here.}

\item{keep_metadata}{logical. Should metadata from the file be returned as extra columns in the returned data frame? Default is \code{FALSE}.}

\item{split_channels}{logical. Should a list of data frames be returned with a separate data frame for each channel? Default is \code{FALSE}.}

\item{merge_close_measurements}{used only when \code{split_channels = FALSE} (the default). The frequency during which measurements are taken can be set uniquely for each channel in the Pyroscience Workbench software. When this happens, measurements may, at times, be nearly synchronized. When measurements are close together in time (even if not exactly at the same moment), it may be desirable to merge them together in the same row of the output dataframe and consider them to be the same timepoint. This parameter allows you to control whether that happens, and if so, how close is "close enough". Options are:
\describe{
\item{\code{0}: }{Do not merge close measurements no matter how close in time (even if 1 msec apart).}
\item{"min" (default): }{Merge measurements as close as the most frequently sampled channel (e.g. if channel 1 sampled every 5 seconds, channel 2 every 2 seconds, and channel 3 every 10 seconds, then any measurements within 2 seconds of each other will be merged on the same row in the output dataframe.)}
\item{"max": }{Merge measurements as close as the least frequently sampled channel (e.g. if channel 1 sampled every 5 seconds, channel 2 every 2 seconds, and channel 3 every 10 seconds, then any measurements within 10 seconds of each other will be merged on the same row in the output dataframe. Warning: this will duplicate more frequent channels. Do not let your downstream statistics be altered by artificially raising the number of observations.)}
\item{custom-set numeric value: }{A numeric value specifying how many seconds apart is "close enough" to merge measurements to the same timepoint. This may result in duplications of the same observations across multiple rows or not merging multiple observations as expected. Examine the output carefully.}
}}
}
\value{
A data frame (or list of data frames) is returned.
\describe{
\item{TIME}{Date and time, POSIXct format. If \code{split_channels = FALSE} (default), then the timestamp is the average of all the measurements that were merged. For details, see \code{merge_close_measurements}.}
\item{DURATION}{Duration of measurement trial (minutes).}
\item{CH_X_O2}{Oxygen measurement in desired unit as determined by \code{o2_unit}.}
\item{CH_X_TEMP}{Temperature recorded or defined at beginning of measurement trial.}
\item{CH_X_SAL}{Salinity (psu). Only displayed if \code{sal != NULL}.}
\item{CH_X_STATUS}{Warning or error messages from Pyroscience Workbench file.}
\item{...}{Channel columns (CH_...) are repeated for each channel.}
}
If \code{keep_metadata = TRUE}, then the following columns are appended to the returned data frame:
\describe{
\item{CH_X_PHASE}{Phase recorded. Phase is inversely related to O2.}
\item{CH_X_INTENSITY}{Intensity is an indicator of the quality of the signal.}
\item{CH_X_AMB_LIGHT}{Ambient light on the sensor. Expressed in mV.}
\item{CH_X_T_STATUS}{Warning or error messages from Pyroscience Workbench file's temperature measurement.}
\item{CH_X_ATM_PRES}{Atmospheric pressure (mbar).}
\item{CH_X_P_STATUS}{Warning or error messages from Pyroscience Workbench file's atmospheric pressure measurement.}
}

If \code{split_channels = TRUE}, then "\code{CH_X_}" is removed from the column names and multiple data frames are returned in a named list.
}
\description{
Imports the raw channel data from Pyroscience Workbench output files. This allows "live" analyses while the trial is still running. This does not utilize the ".pyr" file, nor the text file that is created once the trial is finished. This utilizes the raw channel data found within the "ChannelData" folder that the software makes when the trial starts.
}
\note{
Oxygen conversions are estimates based on the \code{\link[marelac]{marelac}} package.
}
\examples{
\dontrun{
folder <- system.file('extdata/pyro_wb/', package = 'respirometry')
import_pyroscience_workbench(folder = folder, o2_unit = 'umol_per_l', sal = c(0, 35))

# I want each channel as a separate data frame.
data_list <- import_pyroscience_workbench(folder = folder, split_channels = TRUE)
data_list$CH_2 # here's the channel 2 data frame.
}

}
\seealso{
\code{\link{import_presens}}, \code{\link{import_witrox}}, \code{\link{conv_o2}}
}
\author{
Matthew A. Birk, \email{matthewabirk@gmail.com}
}
