<cfquery name="rsCursoEnc" datasource="#session.DSN#">
	Select 
			'Grupo ' + right('0'+convert(varchar,Csecuencia),2) as Cnombre
			, Ccodigo
			, m.EScodigo
			, ESnombre + ' (' + rtrim(EScodificacion) + ')' as ESnombre
			, Fnombre + ' (' + rtrim(Fcodificacion) + ')' as Fnombre
			, c.Mcodigo
			, Mnombre
			, Mcodificacion
			, (case c.Cestado when 0 then 'Inactivo' when 1 then 'Activo' when 2 then 'Cerrado' else 'Estado Desconocido' end) as Estado

		from Curso c
			, Materia m
			, Escuela e
			, Facultad f
		where m.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and Ccodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ccodigo#">
			and c.Ecodigo=m.Ecodigo
			and c.Mcodigo=m.Mcodigo
			and m.Ecodigo=e.Ecodigo
			and m.EScodigo=e.EScodigo
			and e.Fcodigo=f.Fcodigo
</cfquery>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
<!--- 	  <tr>
		<td colspan="3"><hr></td>
	  </tr> --->		
	  <tr>
		<td align="right"><strong>#session.parametros.Facultad#:</strong></td>
		<td>&nbsp;</td>
        <td>#rsCursoEnc.Fnombre#</td>
	  </tr>	  
	  <tr>
		<td width="13%" align="right"><strong>#session.parametros.Escuela#:</strong></td>
		<td width="2%">&nbsp;</td>
        <td width="85%">#rsCursoEnc.ESnombre#</td>
	  </tr>
	  <tr>
		<td align="right"><strong>Materia:</strong></td>
		<td>&nbsp;</td>
        <td>#rsCursoEnc.Mnombre# (#rsCursoEnc.Mcodificacion#)</td>
	  </tr>
	  <tr>
		<td align="right"><strong>Curso:</strong></td>
		<td>&nbsp;</td>
        <td>
			#rsCursoEnc.Cnombre#
		</td>
	  </tr>	  	    	 
	  <tr>
		<td align="right"><strong>Estado:</strong></td>
		<td>&nbsp;</td>
        <td>
			#rsCursoEnc.Estado#
		</td>
	  </tr>	  	    	 
	  <tr>
		<td colspan="3"><hr></td>
	  </tr>	 	  	  
	</table>
</cfoutput>