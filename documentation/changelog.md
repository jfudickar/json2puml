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