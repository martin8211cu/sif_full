<cfquery name="rsDatAl" datasource="#Session.DSN#">
	Select Apersona,(Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as nombreAl,Pid
	from Alumno
	where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
</cfquery>

<cfif isdefined('rsDatAl') and rsDatAl.recordCount GT 0>
	<cfquery name="rsObser" datasource="#Session.DSN#">
		Select case CAOtipo
			when 'R' then 'Reforzamiento'
			when 'L' then 'Llamada de Atención'
			when 'A' then 'Advertencia'
		  end CAOtipo
		  , convert(varchar,CAOfecha,103) as CAOfecha
		  , CAOobservacion
		from CursoAlumnoObservaciones 
		where Apersona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatAl.Apersona#">
			and Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
		order by CAOfecha	
	</cfquery> 
</cfif>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="2%">&nbsp;</td>
	    <td colspan="4"><strong><font size="2">Alumno:</font></strong><font size="2"> #rsDatAl.nombreAl# (#rsDatAl.Pid#)</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
	    <td colspan="3"><hr>
		</td>
		<td width="44%">&nbsp;</td>
	  </tr>
	  <cfif isdefined('rsObser') and rsObser.recordCount GT 0>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td colspan="2">&nbsp;</td>
		  </tr>	  
		  <tr bgcolor="##DBDBDB">
			<td>&nbsp;</td>
			<td width="18%" align="center"><strong>Fecha</strong></td>
			<td width="18%" align="center"><strong>Tipo</strong></td>
			<td colspan="2" align="center"><strong>Observaci&oacute;n</strong></td>
		  </tr>
		  <cfloop query="rsObser">
			  <tr class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
				<td>&nbsp;</td>
				<td align="center">#CAOfecha#</td>
				<td align="center">#CAOtipo#</td>
				<td colspan="2">#CAOobservacion#</td>
			  </tr>
		  </cfloop>
	  <cfelse>
		  <tr>
			<td>&nbsp;</td>
			<td colspan="4" align="center"><strong>El alumno no posee registros de observaciones para este curso</strong></td>			
		  </tr>	  	  
	  </cfif>
	  <tr>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>
		<td width="36%">&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>	  	  	  
	</table>
</cfoutput>