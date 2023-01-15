object J2PWinService: TJ2PWinService
  OnCreate = ServiceCreate
  DisplayName = 'Json2Puml Service'
  OnExecute = ServiceExecute
  OnStart = ServiceStart
  OnStop = ServiceStop
  Height = 150
  Width = 215
end
