<cfquery name="rsRetusuario" datasource="#session.DSN#">
Select Usulogin
from Usuario
where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>
<cfoutput>
<table cellpadding="0" cellspacing="0" width="100%">
<tr>
	<td width="50%" align="left"><strong>Fecha:</strong> #dateformat(now(),"dd/mm/yyyy")#</td>
	<td width="50%" align="right"><strong>Usuario:</strong> #rsRetusuario.Usulogin#</td>
</tr>
<tr>
	<td width="50%" align="left"><strong>Hora:</strong> #dateformat(now(),"HH:mm:ss")#</td>
	<td width="50%" align="right">&nbsp;</td>
</tr>
</table>
</cfoutput>