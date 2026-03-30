<cfif isdefined("form.id_inst") and len(trim(form.id_inst)) and isdefined("form.id_funcionario") and len(trim(form.id_funcionario))>
	<cfquery name="func" datasource="#session.tramites.dsn#">
		select rtrim(d.codigo_tipoident) || ' ' || b.identificacion_persona as identificacion, b.nombre || ' ' || b.apellido1 || ' ' || b.apellido2 as nombre_completo
		from TPFuncionario a
			inner join TPPersona b
				on b.id_persona = a.id_persona
			inner join TPInstitucion c
				on c.id_inst = a.id_inst
			inner join TPTipoIdent d
				on d.id_tipoident = b.id_tipoident
		where a.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
		and a.id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_funcionario#">
	</cfquery>
	<cfoutput>
		<table width="100%" cellpadding="5" cellspacing="0" bgcolor="##CCCCCC" border="0" style="border:1px solid black">
		  <tr>
			<td align="center" valign="middle">
				<font size="3" color="##003399">
				<strong>Funcionario:&nbsp;#trim(func.identificacion)# - #func.nombre_completo#</strong>
				</font>
			</td>
		  </tr>
		</table>
	</cfoutput>
</cfif>
