<cfif not isdefined("session.menues.id_root")>
 	<table border="0" cellspacing="0" cellpadding="0" width="100%">
	  <tr>
		<td align="center">
			<input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='/cfmx/home/menu/modulo.cfm?s=<cfoutput>#session.menues.SScodigo#</cfoutput>&m=<cfoutput>#session.menues.SMcodigo#</cfoutput>';">
 		</td>
	  </tr>
	</table>
</cfif>