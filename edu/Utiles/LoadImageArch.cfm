<cfif isdefined("url.codigo") and Len(Trim(url.codigo)) NEQ 0
  and isdefined("url.nombre") and Len(Trim(url.nombre)) NEQ 0
  and isdefined("url.tipocont") and Len(Trim(url.tipocont)) NEQ 0
  and isdefined("Session.Edu.Usucodigo") and Len(Trim(Session.Edu.Usucodigo)) NEQ 0>

	<cfheader name="Content-Disposition" value="filename=#url.nombre#">
	<cfcontent type="#url.tipocont#" file="#gettempdirectory()##Session.Edu.Usucodigo##url.codigo#.dat" deleteFile="yes">

</cfif>