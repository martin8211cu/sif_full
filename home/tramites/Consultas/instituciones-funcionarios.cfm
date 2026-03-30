<cfif isdefined("Form.id_inst") and Len(Trim(Form.id_inst))>

	<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>
	<cfset varQueryName = "rsFuncionarios">
	<cfset MaxRows = 10>
	
	<cfif isdefined("Url.filtro_funciones") and Len(Trim(Url.filtro_funciones))>
		<cfparam name="Form.filtro_funciones" default="#Url.filtro_funciones#">
	</cfif>
	<cfif isdefined("Url.filtro_servicios") and Len(Trim(Url.filtro_servicios))>
		<cfparam name="Form.filtro_servicios" default="#Url.filtro_servicios#">
	</cfif>
	<cfif isdefined("Url.filtro_identificacion") and Len(Trim(Url.filtro_identificacion))>
		<cfparam name="Form.filtro_identificacion" default="#Url.filtro_identificacion#">
	</cfif>
	<cfif isdefined("Url.filtro_nombre") and Len(Trim(Url.filtro_nombre))>
		<cfparam name="Form.filtro_nombre" default="#Url.filtro_nombre#">
	</cfif>
	
	<cfset navegacion = "">
	<cfif isdefined("Form.filtro_funciones") and Len(Trim(Form.filtro_funciones))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_funciones=" & Form.filtro_funciones>
	</cfif>
	<cfif isdefined("Form.filtro_servicios") and Len(Trim(Form.filtro_servicios))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_servicios=" & Form.filtro_servicios>
	</cfif>
	<cfif isdefined("Form.filtro_identificacion") and Len(Trim(Form.filtro_identificacion))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_identificacion=" & Form.filtro_identificacion>
	</cfif>
	<cfif isdefined("Form.filtro_nombre") and Len(Trim(Form.filtro_nombre))>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "filtro_nombre=" & Form.filtro_nombre>
	</cfif>
	
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		select a.id_inst, a.id_funcionario, a.es_admin, 
			   b.id_persona, b.id_tipoident, b.id_direccion, b.identificacion_persona, b.nombre || ' ' || b.apellido1 || ' ' || b.apellido2 as nombre_completo, 
			   b.nacimiento, b.sexo, b.casa, b.oficina, b.celular, b.fax, b.pagertel, b.pagernum, b.email1, b.email2, b.web, b.foto, 
			   b.firma, b.nacionalidad, b.extranjero,
			   d.id_grupo, d.codigo_grupo, d.nombre_grupo,
			   f.id_tiposerv, f.id_tiposervg, f.codigo_tiposerv, f.nombre_tiposerv, f.descripcion_tiposerv, f.tpo_agenda
		from TPFuncionario a
			inner join TPPersona b
				on b.id_persona = a.id_persona
				<cfif isdefined("Form.filtro_identificacion") and Len(Trim(Form.filtro_identificacion))>
					and upper(b.identificacion_persona) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Trim(Ucase(Form.filtro_identificacion))#%">
				</cfif>
				<cfif isdefined("Form.filtro_nombre") and Len(Trim(Form.filtro_nombre))>
					and upper(b.nombre || ' ' || b.apellido1 || ' ' || b.apellido2) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Trim(Ucase(Form.filtro_nombre))#%">
				</cfif>
			left outer join TPFuncionarioGrupo c
				on c.id_funcionario = a.id_funcionario
			left outer join TPGrupo d
				on d.id_grupo = c.id_grupo
			left outer join TPFuncionarioServicio e
				on e.id_funcionario = a.id_funcionario
			left outer join TPTipoServicio f
				on f.id_tiposerv = e.id_tiposerv
		where a.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
		<cfif isdefined("Form.filtro_funciones") and Len(Trim(Form.filtro_funciones))>
		and exists (
			select 1
			from TPFuncionarioGrupo x
			where x.id_grupo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.filtro_funciones#">
			and x.id_funcionario = a.id_funcionario
		)
		</cfif>
		<cfif isdefined("Form.filtro_servicios") and Len(Trim(Form.filtro_servicios))>
		and exists (
			select 1
			from TPFuncionarioServicio y
			where y.id_tiposerv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.filtro_servicios#">
			and y.id_funcionario = a.id_funcionario
		)
		</cfif>
		order by b.identificacion_persona
	</cfquery>
	
	<cfquery name="rsFuncionarios" dbtype="query">
		select distinct id_funcionario, id_inst, identificacion_persona, nombre_completo
		from rsDatos
		order by identificacion_persona
	</cfquery>

	<cfquery name="comboFunciones" datasource="#session.tramites.dsn#">
		select distinct d.id_grupo, d.codigo_grupo, d.nombre_grupo
		from TPFuncionario a
			inner join TPFuncionarioGrupo c
				on c.id_funcionario = a.id_funcionario
			inner join TPGrupo d
				on d.id_grupo = c.id_grupo
		where a.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
		order by d.codigo_grupo
	</cfquery>

	<cfquery name="comboServicios" datasource="#session.tramites.dsn#">
		select distinct f.id_tiposerv, f.codigo_tiposerv, f.nombre_tiposerv
		from TPFuncionario a
			inner join TPFuncionarioServicio e
				on e.id_funcionario = a.id_funcionario
			inner join TPTipoServicio f
				on f.id_tiposerv = e.id_tiposerv
		where a.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
		order by f.codigo_tiposerv
	</cfquery>

	<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
		<cfset PageNum_lista = Form.PageNum_lista>
	<cfelseif isdefined("Url.PageNum_lista") and Len(Trim(Url.PageNum_lista))>
		<cfset PageNum_lista = Url.PageNum_lista>
	<cfelse>
		<cfset PageNum_lista = 1>
	</cfif>
	
	<cfif MaxRows LT 1>
		<cfset MaxRows = Evaluate("#varQueryName#").RecordCount>
	</cfif>
	<cfif MaxRows LT 1>
		<cfset MaxRows_lista = 1>
	<cfelse>
		<cfset MaxRows_lista = MaxRows>
	</cfif>
	<cfset StartRow_lista=Min((PageNum_lista-1)*MaxRows_lista+1,Max(Evaluate("#varQueryName#").RecordCount,1))>		
	<cfset EndRow_lista=Min(StartRow_lista+MaxRows_lista-1,Evaluate("#varQueryName#").RecordCount)>
	<cfset TotalPages_lista = Ceiling(Evaluate("#varQueryName#").RecordCount/MaxRows_lista)>
	<cfif Len(Trim(CGI.QUERY_STRING)) GT 0>
		<cfset QueryString_lista='&'&CGI.QUERY_STRING>
	<cfelse>
		<cfset QueryString_lista="">
	</cfif>
	<cfset tempPos=ListContainsNoCase(QueryString_lista,"PageNum_lista=","&")>
	<cfif tempPos NEQ 0>
	  <cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
	</cfif>
	
	<cfif Len(Trim(navegacion)) NEQ 0>
		<cfset nav = ListToArray(navegacion, "&")>
		<cfloop index="nv" from="1" to="#ArrayLen(nav)#">
			<cfset tempkey = ListGetAt(nav[nv], 1, "=")>
			<cfset tempPos1 = ListContainsNoCase(QueryString_lista,"?" & tempkey & "=")>
			<cfset tempPos2 = ListContainsNoCase(QueryString_lista,"&" & tempkey & "=")>
			<!--- 
				Chequear substrings duplicados en el contenido de la llave
			--->
			<cfif tempPos1 EQ 0 and tempPos2 EQ 0>
			  <cfset QueryString_lista=QueryString_lista&"&"&nav[nv]>
			</cfif>
		</cfloop>
	</cfif>

	<script language="javascript" type="text/javascript">
		function consultar_funcionario(func, inst) {
			location.href = 'funcionarios.cfm?id_inst='+inst+'&id_funcionario='+func;
		}
	</script>

	<cfoutput>
		<form name="formFuncionarios" method="get" action="#CurrentPage#" style="margin: 0;">
			<input type="hidden" name="tab" value="#Form.tab#" />
			<input type="hidden" name="id_inst" value="#Form.id_inst#" />
			<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
			  <tr>
				<td width="45%" class="tituloIndicacion">
					<font size="2" color="black"><strong>Funcionario</strong></font>
				</td>
				<td width="25%" class="tituloIndicacion">
					<font size="2" color="black"><strong>Funciones</strong></font>
				</td>
				<td width="30%" colspan="2" class="tituloIndicacion">
					<font size="2" color="black"><strong>Servicios</strong></font>
				</td>
			  </tr>
			  <tr class="areaFiltro">
				<td style="padding-top: 5px; padding-bottom: 5px;">
					<input type="text" name="filtro_identificacion" size="10" value="<cfif isdefined("form.filtro_identificacion")>#form.filtro_identificacion#</cfif>">
					<input type="text" name="filtro_nombre" size="20" value="<cfif isdefined("form.filtro_nombre")>#form.filtro_nombre#</cfif>">
				</td>
				<td>
					<select name="filtro_funciones">
						<option value="">(Todos)</option>
					<cfloop query="comboFunciones">
						<cfif Len(Trim(comboFunciones.id_grupo))>
						<option value="#comboFunciones.id_grupo#" <cfif isdefined("Form.filtro_funciones") and form.filtro_funciones EQ comboFunciones.id_grupo> selected</cfif>>#comboFunciones.nombre_grupo#</option>
						</cfif>
					</cfloop>
					</select>
				</td>
				<td>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td>
							<select name="filtro_servicios">
								<option value="">(Todos)</option>
							<cfloop query="comboServicios">
								<cfif Len(Trim(comboServicios.id_tiposerv))>
								<option value="#comboServicios.id_tiposerv#" <cfif isdefined("Form.filtro_servicios") and form.filtro_servicios EQ comboServicios.id_tiposerv> selected</cfif>>#comboServicios.nombre_tiposerv#</option>
								</cfif>
							</cfloop>
							</select>
						</td>
						<td>
							<input type="submit" name="btnFiltrar" value="Filtrar" />
						</td>
					  </tr>
					</table>
				</td>
			  </tr>
			  <cfif rsFuncionarios.recordCount>
				  <cfloop query="rsFuncionarios" startrow="#StartRow_lista#" endrow="#StartRow_lista+MaxRows_lista-1#">
				  <cfif rsFuncionarios.currentRow MOD 2>
					<cfset estilo = "listaNon">
				  <cfelse>
					<cfset estilo = "listaPar">
				  </cfif>
				  <tr class="#estilo#" onclick="javascript: consultar_funcionario('#rsFuncionarios.id_funcionario#', '#rsFuncionarios.id_inst#');" onmouseover="javascript: this.style.cursor='pointer'; this.className='listaParSel';" onmouseout="javascript: this.className='#estilo#';">
					<td <cfif rsFuncionarios.currentRow NEQ StartRow_lista> style="border-top: 1px solid black;"</cfif> valign="top">
						<table align="center" width="100%" cellpadding="2" cellspacing="0">
						  <tr> 
							<td class="fileLabel" width="10%" align="right" nowrap>
								#rsFuncionarios.identificacion_persona#
							</td>
							<td nowrap>
								#rsFuncionarios.nombre_completo#
							</td>
						  </tr>
						</table>
					</td>
					<td <cfif rsFuncionarios.currentRow NEQ StartRow_lista> style="border-top: 1px solid black;"</cfif> valign="top">
						<cfquery name="rsFunciones" dbtype="query">
							select distinct codigo_grupo, nombre_grupo
							from rsDatos
							where id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFuncionarios.id_funcionario#">
							order by codigo_grupo
						</cfquery>
						<table width="100%" border="0" cellspacing="0" cellpadding="2">
						  <cfif rsFunciones.recordCount and Len(Trim(rsFunciones.codigo_grupo))>
							  <cfloop query="rsFunciones">
								  <tr>
									<td nowrap>
										#rsFunciones.nombre_grupo#
									</td>
								  </tr>
							  </cfloop>
						  <cfelse>
							  <tr>
								<td nowrap>
									&nbsp;
									<!--- <strong>El funcionario no tiene funciones asignadas</strong> --->
								</td>
							  </tr>
						  </cfif>
						</table>
					</td>
					<td <cfif rsFuncionarios.currentRow NEQ StartRow_lista> style="border-top: 1px solid black;"</cfif> valign="top">
						<cfquery name="rsServicios" dbtype="query">
							select distinct codigo_tiposerv, nombre_tiposerv
							from rsDatos
							where id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsFuncionarios.id_funcionario#">
							order by codigo_tiposerv
						</cfquery>
						<table width="100%" border="0" cellspacing="0" cellpadding="2">
						  <cfif rsServicios.recordCount and Len(Trim(rsServicios.codigo_tiposerv))>
							  <cfloop query="rsServicios">
								  <tr>
									<td colspan="2" nowrap>
										#rsServicios.nombre_tiposerv#
									</td>
								  </tr>
							  </cfloop>
						  <cfelse>
							  <tr>
								<td colspan="2" nowrap>
									&nbsp;
									<!--- <strong>El funcionario no tiene servicios asignados</strong> --->
								</td>
							  </tr>
						  </cfif>
						</table>
					</td>
				  </tr>
				  </cfloop>
				  <tr>
					<td colspan="3">&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="3" align="center">
						<cfif PageNum_lista GT 1>
						  <a href="#CurrentPage#?PageNum_lista=1#QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/First.gif" border="0"></a> 
						</cfif>
						<cfif PageNum_lista GT 1>
						  <a href="#CurrentPage#?PageNum_lista=#Max(DecrementValue(PageNum_lista),1)##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Previous.gif" border="0"></a> 
						</cfif>
						<cfif PageNum_lista LT TotalPages_lista>
						  <a href="#CurrentPage#?PageNum_lista=#Min(IncrementValue(PageNum_lista),TotalPages_lista)##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Next.gif" border="0"></a> 
						</cfif>
						<cfif PageNum_lista LT TotalPages_lista>
						  <a href="#CurrentPage#?PageNum_lista=#TotalPages_lista##QueryString_lista#" tabindex="-1"><img src="/cfmx/sif/imagenes/Last.gif" border="0"></a> 
						</cfif> 
					</td>
				  </tr>
			  <cfelse>
				  <tr>
					<td colspan="3">&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="3" align="center">
						<strong>No se encontraron funcionarios para esta instituci&oacute;n</strong>
					</td>
				  </tr>
			  </cfif>
			  <tr>
				<td colspan="3">&nbsp;</td>
			  </tr>
			</table>
		</form>
	</cfoutput>
	
</cfif>
