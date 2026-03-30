<cfquery name="rsDatAl" datasource="#Session.DSN#">
	Select Apersona,(Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as nombreAl,Pid
	from Alumno
	where Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
</cfquery>

<cfif isdefined('rsDatAl') and rsDatAl.recordCount GT 0>
	<cfquery name="rsAsist" datasource="#Session.DSN#">
		Select  case CAStipo
			when 'A' then 'Ausencia'
			when 'T' then 'Llegada Tardia'
			when 'S' then 'Salida Temprano'
		  end CAStipo
		  , CASjustificacion
		  , convert(varchar,CASfecha,103) as CASfecha
		from CursoAlumnoAsistencia 
		where Apersona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatAl.Apersona#">
			and Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
		order by CASfecha
	</cfquery> 
</cfif>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
	  <tr>
	    <td width="2%">&nbsp;</td>
	    <td colspan="3"><strong><font size="2">Alumno:</font></strong><font size="2"> #rsDatAl.nombreAl# (#rsDatAl.Pid#)</td>
	  </tr>
	  <tr>
	    <td>&nbsp;</td>
	    <td colspan="2"><hr>
		</td>
		<td width="48%">&nbsp;</td>
	  </tr>
	  <cfif isdefined('rsAsist') and rsAsist.recordCount GT 0>
		  <tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td width="30%">&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>	  
		  <tr bgcolor="##DBDBDB">
			<td>&nbsp;</td>
			<td width="20%" align="center"><strong>Fecha</strong></td>
			<td align="center"><strong>Tipo</strong></td>
			<td align="center"><strong>Justificaci&oacute;n</strong></td>
		  </tr>
		  <cfloop query="rsAsist">
			  <tr class=<cfif CurrentRow MOD 2>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="style.backgroundColor='##E4E8F3';" onmouseout="style.backgroundColor='<cfif CurrentRow MOD 2>##FFFFFF<cfelse>##FAFAFA</cfif>';">
				<td>&nbsp;</td>
				<td align="center">#CASfecha#</td>
				<td nowrap>#CAStipo#</td>
				<td>#CASjustificacion#</td>
			  </tr>
		  </cfloop>
	  <cfelse>
		  <tr>
			<td>&nbsp;</td>
			<td colspan="3" align="center"><strong>El alumno no posee registros de asistencia para este curso</strong></td>			
		  </tr>	  	  
	  </cfif>
	  <tr>
	    <td>&nbsp;</td>
	    <td>&nbsp;</td>
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>	  	  	  
	</table>
</cfoutput>