# **json2puml v2.2.5.98** - 12.08.2023
## All Editions 
### New Feature
- Additional command line and global configuration parameter "plantUmlRuntimeParameter" which allows to add additional plantuml parameters
  to the command line when generating the result files
### Changed Feature
- Improved error handling when plantuml fails to generate the output files

## Service Editions 
### Changed Feature
- The service returns now a HTTP300 when the result file was not generated

# **json2puml v2.2.5.97** - 10.08.2023
## All Editions 
### Changed Feature
- the mandatory flag is now ignored when the file has not been fetched because of a not valid executevalidation rule

## Service Editions 
### Changed Feature
- The error list are not correct generated

# **json2puml v2.2.5.96** - 09.08.2023
## All Editions 
### New Feature
- New property inputlist.input.mandatory
  This allows to define a file as mandatory. When this file can not be found/fetched the process stops with an error.
### Changed Feature
- The "$" character is now replaced in all file and path names with a "_" to be more linux compatible
- Changed default order of the inputlist.input properties when storing a input list file

## Service Editions 
### New Feature
- New operation get /errormessage to receive a list of all implemented error messages.

# **json2puml v2.2.5.95** - 08.08.2023
## All Editions 
### New Feature
- when the log outputformat is actovated additional an ".execute.log" file is generated, which contains the execution log informations  
  of the current execution
- when the curl command fails, but a result file has been created, the content of the file will be shown in the log. This gives additional
  options for debugging
### Changed Feature
- Log handling Improved

# **json2puml v2.2.5.94** - 07.08.2023
## All Editions 
### Changed Feature
- Changed handling of directory creation

# **json2puml v2.2.5.93** - 06.08.2023
## All Editions 
### Changed Feature
- Log handling Improved

## Service Editions 
### New Feature
- For failed service calls now a structured error message is returned, which contains the list of all errors which have lead to the server error
  Each error has a unique error code, an error message and an optional description

# **json2puml v2.2.5.90** - 05.08.2023
## All Editions 
### Changed Feature
- Log handling Improved

# **json2puml v2.2.4.88** - 04.08.2023
## All Editions 
### New Feature
- The displayName and descrition property of the inputlistfile and the definitionfile are now supporting the text replacement of environment variables
### Changed Feature
- Fixed plantuml generation for table fields when the content contains a \n for a fixed newline

## Service Editions 
### New Feature
- Additional information into the get /serviceinformation result set

# **json2puml v2.2.3.87** - 03.08.2023
## All Editions 
### Changed Feature
- Fixed protocol handling of boolean command line parameters
- Improved/fixed initialisation of the logger classes

## Service Editions 
### New Feature
- For calculating the Plantuml information shown in the get /serviceinformation now also the globalconfiguration.javaRuntimeParameter will be used

# **json2puml v2.2.2.86** - 03.08.2023
## Service Editions 
### New  Feature
- New api operation get /heartbeat which returns service version information
### Changed Feature
- Additional information into the get /serviceinformation result set

# **json2puml v2.2.1.85** - 02.08.2023
## Service Editions 
### Changed Feature
- Optimized protocol handling
- Additional information into the get /serviceinformation result set
- Improved handling of fetching data for the get /serviceinformation result set

# **json2puml v2.2.0.84** - 01.08.2023
## Service Editions 
### New Feature
- New command line parameter -serviceport added which allows to override the configured port used by the service application 
- The globalconfiguration.serviceport can now be defined via environment variable using the curl variable format in the config file
- New api operation get /serviceinformation which returns generic information’s about the service and how it is configured
- New globalconfiguration.additionalServiceInformation paramter. 
  This can be used to define the additionalServiceInformation informations in the get /serviceinformation result 

# **json2puml v2.1.8.83** - 22.07.2023
## All Editions 
### New Feature
- New command line parameter -nologfiles added which allows to hide the generation of log files

### Changed Feature
- Docker installation tar file build improved to easy the unpack using command line
- Installation uses now PlantUml v1.2023.10

# **json2puml v2.1.7.82** - 24.04.2023
## All Editions 
### Changed Feature
- Handled exception are now written to the logfile only in Debug Mode
- Fixed generation of uuid for OpenTelemetry Trace/Span 
- Installation uses now PlantUml v1.2023.6

# **json2puml v2.1.6.81** - 17.04.2023
## All Editions 
### New Feature
- New configuration parameter curlSpanIdHeader: When this parameter is used a request header is added to the curl command --header <curlSpanIdHeader>: "<GeneratedUUID>"

### Changed Feature
- Improved handling of opentelemetry trace id handling.
- Generated UUID's now only contain numbers and lowercase characters
- Installation uses now PlantUml v1.2023.5

# **json2puml v2.1.5.80** - 16.04.2023
## All Editions 
### New Feature
- Added a command line parameter /generatedefaultconfiguration
  This option generates default configuration files in the current folder of executable, when they are not already existing.
  This is used to fix the issue [Windows installation program should install a default configuration file if no configuration file is defined]( https://github.com/jfudickar/json2puml/issues/3)
- New configuration parameter curlUserAgentInformation:
Calling the curl command now the curl paramter --user-agent is used. Either with the value of the configuration or with a default value
- New configuration parameter curlTraceIdHeader: When this parameter is used a request header is added to the curl command --header <curlTraceIdHeader>: "<GeneratedUUID>"
- Setup program call the command line version with the parameter /generatedefaultconfiguration to generate the default configuration files.

# **json2puml v2.1.4.79** - 10.04.2023
## All Editions 
### Changed Feature
- Fixed defect [Configuration Parameter "javaRuntimeParameter" not working #1](https://github.com/jfudickar/json2puml/issues/1)
- Fixed defect [Commandlineparameter /outputformat is not correctly reflected in log messages #2](https://github.com/jfudickar/json2puml/issues/2)

# **json2puml v2.1.3.78** - 19.03.2023
## All Editions 
### Changed Feature
- Fixed exception when protocoling an exception which came up when exectuing the curl file evaluation
- Added the propertyName to the relationship from the group object to the to-object
- Additional log handler to protocol exceptions

# **json2puml v2.1.2.77** - 16.03.2023
## All Editions 
### Changed Feature
- Fixed handling of replacing curl variables with environment variables (which could lead to invalid target file names of the curl operations and invalid urls)
## Service Application
### Changed Feature
- HTTP header and body are no longer protocolled to reduce the risk of protocolling critical data (e.g. curl authentication parameter)

# **json2puml v2.1.1.76** - 13.03.2023
## All Editions 
### Changed Feature
- Log file handling and storage definitions improved
- Fixed drawing issues in the object relations tables
## UI Edition 
### Changed Feature
- Drawing problems with the objecttype colors in the legends fixed
- Log Memo is more often updated to show the progress 
### New Feature
- Taskbar Icon shows a progress bar when running the converter

# **json2puml v2.1.0.75** - 12.03.2023
This is the first official release published on GitHub