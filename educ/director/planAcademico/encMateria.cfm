<cfquery name="rsMateria" datasource="#session.DSN#">
	Select m.EScodigo
		, ESnombre
		, Fnombre
		, Mcodigo
		, Mnombre
		, Mcodificacion
	from Materia m
		, Escuela e
		, Facultad f
	where m.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
		and m.Ecodigo=e.Ecodigo
		and m.EScodigo=e.EScodigo
		and e.Fcodigo=f.Fcodigo
</cfquery>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">		
	  <tr>
		<td align="right"><strong>#session.parametros.Facultad#:</strong></td>
		<td>&nbsp;</td>
        <td>#rsMateria.Fnombre#</td>
	  </tr>	  
	  <tr>
		<td width="13%" align="right"><strong>#session.parametros.Escuela#:</strong></td>
		<td width="2%">&nbsp;</td>
        <td width="85%">#rsMateria.ESnombre#</td>
	  </tr>
	  <tr>
		<td align="right"><strong>Materia:</strong></td>
		<td>&nbsp;</td>
        <td>#rsMateria.Mnombre# (#rsMateria.Mcodificacion#)</td>
	  </tr>	    	 
	  <tr>
		<td colspan="3"><hr></td>
	  </tr>	 	  	  
	</table>
</cfoutput>