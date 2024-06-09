# **json2puml v2.2.16.112** - 07.06.2024
## All Editions
### Changed Feature
- Sorting of object attributes fixed. Now also when sort is active the id and name column (if configured and found) wiil be shown first, then all other sorted attributes.

## Service Edition
### New Feature
- The operations /json2pumlRequestPng + /json2pumlRequestSvg + /json2pumlRequestZip now have an optional query parameter includeFileName
  When this parameter is used the result is a json file with the name of the file and a base63 encoded binary content of the file.
  This can be used to store the files with the internal generated names.

### Changed Feature
- YAML file further improved with more correct datatypes and descriptions

# **json2puml v2.2.15.111** - 05.06.2024
## All Editions
### New Feature
- Fileentry Mandatory parameter checks for number or resulted records #29

### Changed Feature
- Improved json formatting of object based arrays
- Fixed exception when the characteristic has to be generated with a longer list of leading columns, then the list of actual columns

## UI Editions
### New Feature
- Show the name of all files in the ui (#25)
- Additional columns in the curlfile list : NoOfRecords + FileSizeKB #34

## Service Edition
### Changed Feature
- Swagger file updated
  - Add all possible formats to the outputformats description #33
  - Change datamodel for get /json2pumlRequestSvg+Png to reflect that some options are not required #32
  - Additional descriptions
- service get /definitionfile : change options handling #31
  - add the default option (the option which is not overwritten)
  - put the defined default option as top of the resulted list  

# **json2puml v2.2.14.110** - 01.06.2024
## All Editions
### New Feature
- Added option "sortRows" to the CharacteristicProperty which allows to sort the characteristic output rows (#30)

### Changed Feature
- Include PlantUml v1.2024.5
- Fixed wrong json output formatting with arrays (#24)

## UI Editions
### New Feature
- Show the name of all files in the ui (#25)

### Changed Feature
- Show an error message in UI Interface when a command line parameter filename is invalid (#28)
- Taskbar Handling changed, the status is going to error when an stopping error occurred (#27)
- The curl file list is filled with all handled files, also when an error occurred (#26)

# **json2puml v2.2.13.109** - 07.02.2024
## All Editions
### New Feature
- When a curl command fails but a response has been saved the content of the file is logged as "debug".
  To see this the debug parameter must be defined

## UI Editions
### Changed Feature
- The button "Reload and convert files" is working agian (#22)
- The execute menu has been restablished
- Restructured the show menu
- changing the "debug" flag in the ui now has an influence on the generated log outputs


# **json2puml v2.2.12.108** - 23.01.2024
## All Editions
### New Feature
- InputList.fileDescription.curlParameter : New property mandatoryGroup added (#19)
  This gives more flexibility in defining mandatory input parameters
- InputList.curlMappingParameter added (#13)
  This allows to define additional curl parameter mappings and can be used to combine parameters in one parameter having prefix and suffix (e.g. used for url filter parameters based on input parameters)
- The InputList.fileDescription.curlParameter will now be used to validate the defined input curlparameters. An error will be raised and the conversion aborted when the parameters are not matching. (#18)
- All initialy defined curl parameters will be listed at the beginning of the execution log (#21)
- Improved / updated samples to show the use of the new CurlMappingParameter
- New Unittests added

## UI Editions
### New Feature
- Improved progress when executing the scripts (#20)
  - Progressbars added for curl and convert 
  - The execution log will be automatically updated 
- New "Curl Files" result page
  - This page shows all executed curl commands and the corresponding results as a comprensed list
- New button "Generate Servicelist Results" to fill the "get /inputlistfile" and "get /definitionfile" pages  

# **json2puml v2.2.11.107** - 01.01.2024
## All Editions
### Changed Feature
- Inputlist.description.curlparameter.name handling improved
  - Not the names will automatically converted into the ${<name>} format
  - This fixes the wrong check if the parameter is defined at runtime which could lead to duplicate curlparameters
- All property name filters which are supporting wildcards are supporting now to exclude a property from a previous found by supporting a remove with a leading "-". 
  E.g.
  "product*"
  "-productOffering"
  This will allow product and productCharacteristic but not productOffering.
- Internal performance optimization (by caching) when searching in the definition configurations
- Performance optimization by doing one plantuml call to convert all files of the same output format 
- Installation uses now PlantUml v1.2023.13

# **json2puml v2.2.10.106** - 05.09.2023
## All Editions
### Changed Feature
- Inputlistfile.curlFileNameSuffix handling improved (#12)
  - Curl Variables with "." are now supported
  - if the first character is not ".", "-" or "_" a "." will be added

## Service Editions
### Changed Feature
- Updated to latest DelphiMVCFramework

## UI Edition
### Changed Feature
- Updated to SVGIconImageList v4.1

# **json2puml v2.2.9.105** - 31.08.2023
## All Editions
### Changed Feature
- Fixes duplicated records in configuration lists when reassigning values to the list 
- Inputlistfile.summaryfile handling improved
  - Known file extentions will be removed
  - Invalid characters are removed
  - Curl Variables with "." are now supported

## UI Edition
### Changed Feature
- Updated to SVGIconImageList v4

# **json2puml v2.2.8.104** - 29.08.2023
## All Editions 
### New Feature
- The legend is enhanced with the number of json records of every input file
- A new property "curlParameter" is added to the Globalconfigruation. This allows to define global curl parameters.

# **json2puml v2.2.7.103** - 21.08.2023
## Service Edition 
### Changed Feature
- Hide Get /api/heartbeat messages in the log files

# **json2puml v2.2.6.102** - 17.08.2023
## All Editions 
### Changed Feature
- Fixed behaviour after memory leak fix

## Service Edition 
### Changed Feature
- No additional log files are created in a log folder of the binary


# **json2puml v2.2.5.101** - 16.08.2023
## All Editions 
### Changed Feature
- Fixed behaviour after memory leak fix

# **json2puml v2.2.5.100** - 15.08.2023
## All Editions 
### Changed Feature
- Slightly enhanced exception logging

# **json2puml v2.2.5.99** - 14.08.2023
## All Editions 
### Changed Feature
- Various memory leaks fixed

# **json2puml v2.2.5.98** - 12.08.2023
## All Editions 
### New Feature
- Additional command line and global configuration parameter "plantUmlRuntimeParameter" which allows to add additional plantuml parameters
  to the command line when generating the result files
### Changed Feature
- Improved error handling when plantuml fails to generate the output files

## Service Edition 
### Changed Feature
- The service returns now a HTTP500 when the result file was not generated

# **json2puml v2.2.5.97** - 10.08.2023
## All Editions 
### Changed Feature
- the mandatory flag is now ignored when the file has not been fetched because of a not valid executevalidation rule

## Service Edition 
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

## Service Edition 
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

## Service Edition 
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

## Service Edition 
### New Feature
- Additional information into the get /serviceinformation result set

# **json2puml v2.2.3.87** - 03.08.2023
## All Editions 
### Changed Feature
- Fixed protocol handling of boolean command line parameters
- Improved/fixed initialisation of the logger classes

## Service Edition 
### New Feature
- For calculating the Plantuml information shown in the get /serviceinformation now also the globalconfiguration.javaRuntimeParameter will be used

# **json2puml v2.2.2.86** - 03.08.2023
## Service Edition 
### New  Feature
- New api operation get /heartbeat which returns service version information
### Changed Feature
- Additional information into the get /serviceinformation result set

# **json2puml v2.2.1.85** - 02.08.2023
## Service Edition 
### Changed Feature
- Optimized protocol handling
- Additional information into the get /serviceinformation result set
- Improved handling of fetching data for the get /serviceinformation result set

# **json2puml v2.2.0.84** - 01.08.2023
## Service Edition 
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