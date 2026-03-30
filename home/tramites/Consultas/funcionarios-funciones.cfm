<cfif isdefined("Form.id_inst") and Len(Trim(Form.id_inst)) and isdefined("Form.id_funcionario") and Len(Trim(Form.id_funcionario))>
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		select a.id_inst, a.id_funcionario, a.es_admin, 
			   b.id_persona, b.id_tipoident, b.id_direccion, b.identificacion_persona, b.nombre || ' ' || b.apellido1 || ' ' || b.apellido2 as nombre_completo, 
			   b.nacimiento, b.sexo, b.casa, b.oficina, b.celular, b.fax, b.pagertel, b.pagernum, b.email1, b.email2, b.web, b.foto, 
			   b.firma, b.nacionalidad, b.extranjero,
			   d.codigo_grupo, d.nombre_grupo,
			   f.id_tiposervg, f.codigo_tiposerv, f.nombre_tiposerv, f.descripcion_tiposerv, f.tpo_agenda
		from TPFuncionario a
			inner join TPPersona b
				on b.id_persona = a.id_persona
			left outer join TPFuncionarioGrupo c
				on c.id_funcionario = a.id_funcionario
			left outer join TPGrupo d
				on d.id_grupo = c.id_grupo
			left outer join TPFuncionarioServicio e
				on e.id_funcionario = a.id_funcionario
			left outer join TPTipoServicio f
				on f.id_tiposerv = e.id_tiposerv
		where a.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
		and a.id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_funcionario#">
	</cfquery>
	
	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="50%" valign="top">
				<cfquery name="rsFunciones" dbtype="query">
					select distinct codigo_grupo, nombre_grupo
					from rsDatos
					where id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_funcionario#">
					order by codigo_grupo
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td colspan="2" class="tituloIndicacion">
						<font size="2" color="black"><strong>Funciones</strong></font>
					</td>
				  </tr>
				  <cfif rsFunciones.recordCount and Len(Trim(rsFunciones.codigo_grupo))>
					  <cfloop query="rsFunciones">
						  <tr>
							<td nowrap>
								#HtmlEditFormat(rsFunciones.nombre_grupo)#
							</td>
						  </tr>
					  </cfloop>
				  <cfelse>
					  <tr>
						<td>
							<strong>El funcionario no tiene funciones asignadas</strong>
						</td>
					  </tr>
				  </cfif>
				</table>
			</td>
			<td valign="top">
				<cfquery name="rsServicios" dbtype="query">
					select distinct codigo_tiposerv, nombre_tiposerv
					from rsDatos
					where id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_funcionario#">
					order by codigo_tiposerv
				</cfquery>
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td colspan="2" class="tituloIndicacion">
						<font size="2" color="black"><strong>Servicios</strong></font>
					</td>
				  </tr>
				  <cfif rsServicios.recordCount and Len(Trim(rsServicios.codigo_tiposerv))>
					  <cfloop query="rsServicios">
						  <tr>
							<td nowrap>
								#HtmlEditFormat(rsServicios.nombre_tiposerv)#
							</td>
						  </tr>
					  </cfloop>
				  <cfelse>
					  <tr>
						<td>
							<strong>El funcionario no tiene servicios asignados</strong>
						</td>
					  </tr>
				  </cfif>
				</table>
			</td>
		  </tr>
		  <tr>
		  	<td colspan="2">&nbsp;</td>
		  </tr>
		</table>
	</cfoutput>
	
</cfif>
