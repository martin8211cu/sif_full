
<cfif isdefined('form.Fcorte') and Len(Trim(form.Fcorte)) eq 0>
	<cfset form.Fcorte = LSDateFormat(Now(), 'dd/mm/yyyy')>
</cfif>


<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<cfif not isdefined("form.btnConsultar")>
			<cflocation addtoken="no" url="Vacaciones.cfm">
		</cfif>
		<cfif  isdefined("form.formato") and form.formato eq "HTML">
			<cf_templatecss>
			<table width="100%" border="0" cellpadding="1" cellspacing="1" bgcolor="#DFDFDF">
			  <tr align="left"> 
				<td><a href="Vacaciones.cfm">Regresar</a></td>
			  </tr>
			</table>
		</cfif>	
		</td>	
	</tr>
</table>	

<cf_rhimprime datos="/rh/nomina/consultas/VacacionesRep-form.cfm" paramsuri="">
<cfinclude template="VacacionesRep-form.cfm">

