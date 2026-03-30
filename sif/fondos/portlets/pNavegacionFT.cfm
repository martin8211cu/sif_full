<cfoutput>

<cfif not isdefined("regresar") >
	<cfset regresar = "/cfmx/sif/fondos/MenuFondos.cfm">
</cfif>

<table width="100%" border="0" cellpadding="4" cellspacing="0" bgcolor="##DFDFDF">
  <tr align="left"> 
	<td><a href="/cfmx/sif/indexSif.cfm">SIF</a></td>
	<td>|</td>
	<td nowrap><a href="/cfmx/sif/fondos/MenuFondos.cfm">
	#Request.Translate('ModuloFT','Fondos de Trabajo','/sif/Utiles/Generales.xml')#
	</a></td>
	<td>|</td>
	<td width="100%"><a href="#regresar#">
		#Request.Translate('Regresar','Regresar','/sif/Utiles/Generales.xml')#	
	</a></td>
  </tr>
</table>
</cfoutput>
