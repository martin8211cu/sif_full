<CFPARAM NAME="Directory" DEFAULT="#GetTempDirectory()#">
<CFPARAM NAME="FileName" DEFAULT="#session.Ecodigo#_#session.Usucodigo#_#Session.Ulocalizacion#_#DateFormat(Now(),'yyyymmdd')#_#Replace(Replace(TimeFormat(Now(),'medium'),':','_','all'),' ','_','all')#">
<CFSET HTMLFileName = FileName>
<CFSET HTMLFilePath = Directory & HTMLFileName  & ".xls">
<br><h1>Directory</h1>
<cfdump var="#Directory#">
<br><h1>FileName</h1>
<cfdump var="#FileName#">
<br><h1>HTMLFilePath</h1>
<cfdump var="#HTMLFilePath#">