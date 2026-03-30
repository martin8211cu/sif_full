<cfset LvarFiltroPorUsuario = true>
<cfset Session.Tesoreria.solicitudesCFM = GetFileFromPath(GetCurrentTemplatePath())>

<cfinclude template="solicitudesManualCF.cfm">			
