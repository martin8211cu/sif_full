<!---Proceso que permite aprobar las horas extra registradas desde el modulo de autogestión--->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso" Default="Usted no tiene grupos asociados. No puede acceder este proceso." returnvariable="MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Empleado" Default="Empleado"	 returnvariable="LB_Empleado"/>	 
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FDesde" Default="Fecha Desde"	 returnvariable="LB_FDesde"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate"  Key="LB_FHasta" Default="Fecha Hasta"	 returnvariable="LB_FHasta"/>	
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Jornada" Default="Jornada" returnvariable="LB_Jornada"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_HT" Default="HT"	 returnvariable="LB_HT"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_HL" Default="HL"	 returnvariable="LB_HL"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_HO" Default="HO"	 returnvariable="LB_HO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_HR" Default="HR"	 returnvariable="LB_HR"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_HN" Default="HN"	 returnvariable="LB_HN"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_HEA" Default="HEA" returnvariable="LB_HEA"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" Key="LB_HEB" Default="HEB"	 returnvariable="LB_HEB"/>
<cfinvoke component="sif.Componentes.Translate"  method="Translate" key="LB_MFERIADO" Default="MFERIADO" returnvariable="LB_MFERIADO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FERIADO" Default="FERIADO"	 returnvariable="LB_FERIADO"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PERMISO" Default="PERMISO"	 returnvariable="LB_PERMISO"/>
<cfinvoke key="BTN_Aplicar" default="Aplicar"	 returnvariable="BTN_Aplicar" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="BTN_Eliminar" default="Eliminar"	 returnvariable="BTN_Eliminar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ConfirmaAplicar" default="Esta seguro que desea aplicar las marcas?"	 returnvariable="MSG_ConfirmaAplicar" component="sif.Componentes.Translate" method="Translate"/>	
<cfinvoke key="LB_MarcasInconsistentes" default="Marcas Inconsistentes" returnvariable="LB_MarcasInconsistentes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_HayMarcasInconsistentesNoSePuedeAplicar" default="Hay marcas inconsistentes no se puede aplicar."	 returnvariable="MSG_HayMarcasInconsistentesNoSePuedeAplicar" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" default="Debe seleccionar al menos un registro para relizar esta acción" returnvariable="MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="MSG_ConfirmaEliminar" default="Esta seguro que desea eliminar las marcas?"	 returnvariable="MSG_ConfirmaEliminar" component="sif.Componentes.Translate" method="Translate"/>			
<cfinvoke key="LB_Todos" default="Todos"	 returnvariable="LB_Todos" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="BTN_Filtrar" default="Filtrar"	 returnvariable="BTN_Filtrar" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_LasMarcasQueAparecenEnColorRojoEstanInconsistentes" default="Las marcas que aparecen en color rojo est&aacute;n inconsistentes" returnvariable="LB_LasMarcasQueAparecenEnColorRojoEstanInconsistentes" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke key="LB_LasMarcasQueAparecenEnColorVerdeEstanDuplicadas" default="Las marcas que aparecen en color verde est&aacute;n Duplicadas" returnvariable="LB_LasMarcasQueAparecenEnColorVerdeEstanDuplicadas" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate"	Key="LB_AprobarHorasExtra" Default="Aprobar Horas Extra" returnvariable="LB_AprobarHorasExtra"/>

<cfif not isdefined("Form.visualizar") and not isdefined("url.visualizar")>
	<cfset Form.visualizar = 0><!--- 0 diario  1 semanal --->
</cfif>
<cfif isdefined("url.visualizar") and len(trim(url.visualizar)) and not isdefined("form.visualizar")>
	<cfset Form.visualizar = url.visualizar>
</cfif>

<cf_templateheader title="#LB_AprobarHorasExtra#">
		<cf_web_portlet_start skin="#Session.Preferences.Skin#" titulo="#LB_AprobarHorasExtra#">
		
<!---Valida que el empleado se encuentre dentro de los supervisores de horas extra (control de marcas>Definición de supervisores)--->
<cfquery name="rsGrupos" datasource="#session.DSN#">
	select  b.Gid, b.Gdescripcion
	from RHCMAutorizadoresGrupo a
		inner join RHCMGrupos b
			on a.Gid = b.Gid
			and a.Ecodigo = b.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.Usucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>

<cfif rsGrupos.recordcount eq 0>
	<cf_throw message="#MSG_Usted_no_tiene_grupos_asociados_No_puede_acceder_este_proceso#" errorcode="5110">
<cfelseif rsGrupos.recordcount eq 1>
	<cfparam name="Form.Grupo" default="#rsGrupos.Gid#">
</cfif>
<!------>

<cfinclude template="/rh/Utiles/params.cfm">
<cfset Session.Params.ModoDespliegue = 1>
<cfset Session.cache_empresarial = 0>

<cfquery name="rsGrupos" datasource="#session.DSN#">
	select  b.Gid, b.Gdescripcion
	from RHCMGrupos b					
	where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfquery name="rsJornadas" datasource="#session.DSN#">
	select RHJid,RHJcodigo, RHJdescripcion
	from RHJornadas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfset navegacion = ''>
<cfset arrayEmpleado = ArrayNew(1)>
<cfset vnMaxrows = 50>
<cfparam name="form.Pagina" default="1">
		
<!---Variables de navegacion--->
<cfif isdefined("url.btnFiltrar")>
	<cfset form.btnFiltrar = url.btnFiltrar>
</cfif>

<cfif isdefined("form.btnFiltrar")>
	<cfset navegacion = navegacion & '&btnFiltrar=true'>
</cfif>

<cfif isdefined("url.visualizar") and len(trim(url.visualizar)) and not isdefined("form.visualizar")>
	<cfset form.visualizar = url.visualizar>	
</cfif>

<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "visualizar=" & Form.visualizar>			

<cfif isdefined("url.DEid") and len(trim(url.DEid)) and not isdefined("form.DEid")>
	<cfset form.DEid = url.DEid>	
</cfif>

<cfif isdefined("form.DEid") and len(trim(form.DEid))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "DEid=" & Form.DEid>			
</cfif>

<cfif isdefined("url.RHJid") and len(trim(url.RHJid)) and not isdefined("form.RHJid")>
	<cfset form.RHJid = url.RHJid>	
</cfif>

<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "RHJid=" & Form.RHJid>			
</cfif>

<cfif isdefined("url.Grupo") and len(trim(url.Grupo)) and not isdefined("form.Grupo")>
	<cfset form.Grupo = url.Grupo>				
</cfif>

<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "Grupo=" & Form.Grupo>
</cfif>

<cfif isdefined("url.ver") and len(trim(url.ver)) and not isdefined("form.ver")>
	<cfset form.ver = url.ver>	
</cfif>

<cfif isdefined("form.ver") and len(trim(form.ver))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "ver=" & Form.ver>
	<cfset vnMaxrows = form.ver>
</cfif>	
			
<cfif isdefined("url.fechaInicio") and len(trim(url.fechaInicio)) and not isdefined("form.fechaInicio")>
	<cfset form.fechaInicio = url.fechaInicio>	
</cfif>

<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fechaInicio=" & Form.fechaInicio>
	<cfset fechaInicio = form.fechaInicio>
</cfif>	
		
<cfif isdefined("url.fechaFinal") and len(trim(url.fechaFinal)) and not isdefined("form.fechaFinal")>
	<cfset form.fechaFinal = url.fechaFinal>	
</cfif>

<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)), DE("&"), DE("")) & "fechaFinal=" & Form.fechaFinal>
	<cfset fechaFinal = form.fechaFinal>			
</cfif>			
<!---Limpiar variable QueryString_lista por problemas de navegacion---->
<cfif ISDEFINED("CGI.QUERY_STRING")>
	<cfset QueryString_lista='&'&CGI.QUERY_STRING>
	<cfelse>
	<cfset QueryString_lista="">
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_lista,"btnFiltrar=","&")>

<cfif tempPos NEQ 0>
	<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_lista,"Grupo=","&")>

<cfif tempPos NEQ 0>
	<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_lista,"RHJid=","&")>

<cfif tempPos NEQ 0>
	<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_lista,"DEid=","&")>

<cfif tempPos NEQ 0>
	<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_lista,"ver=","&")>

<cfif tempPos NEQ 0>
	<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_lista,"fechaInicio=","&")>

<cfif tempPos NEQ 0>
	<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>

<cfset tempPos=ListContainsNoCase(QueryString_lista,"fechaFinal=","&")>

<cfif tempPos NEQ 0>
	<cfset QueryString_lista=ListDeleteAt(QueryString_lista,tempPos,"&")>
</cfif>
		


<form action="aprobar-sql.cfm" method="post" name="form1">
<input type="hidden" name="BOTON" value="">
<input  type="hidden" name="tab" value="1">

<table width="100%" cellpadding="3" cellspacing="0">
<cfoutput>
	<tr>
		<td>								
			<table width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td width="14%" align="right">&nbsp;</td>
					<td colspan="5">
						<input onclick="javascript: cambiomodo(this);" type="radio" id="visualizar" name="visualizar" value="0" <cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0 >checked</cfif> >
						<cf_translate key="LB_Diario">Diario</cf_translate>
						<input onclick="javascript: cambiomodo(this);" type="radio" id="visualizar" name="visualizar" value="1" <cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 1 >checked</cfif> >
						<cf_translate key="LB_Semanal">Semanal</cf_translate>
					</td>
				</tr>
				<tr>
					<td width="14%" align="right"><strong>#LB_Empleado#:&nbsp;</strong></td>
					<td colspan="3">
						<cfif isdefined("form.DEid") and len(trim(form.DEid))>
							<cfquery name="rsEmpleado" datasource="#session.DSN#">
								select 	DEid, 
										{fn concat({fn concat({fn concat({ fn concat(DEnombre, ' ') },DEapellido1)}, ' ')},DEapellido2) } NombreEmp,
										DEidentificacion,					
										NTIcodigo
								from DatosEmpleado
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
							</cfquery>
							<cf_rhempleado form="form1" size="60" query="#rsEmpleado#" tabindex="1">
						<cfelse>
							<cf_rhempleado form="form1" size="60"tabindex="1">												
						</cfif>
					</td>
					<td  nowrap="nowrap" width="6%" align="right"><strong><cf_translate key="LB_Ver">Ver</cf_translate>:&nbsp;</strong></td>										
					<td width="13%">
						<cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
							<input tabindex="4" type="text" name="ver" value="<cfif isdefined("form.ver") and len(trim(form.ver))>#form.ver#<cfelse>50</cfif>" size="7" >
						<cfelse>
							20
						</cfif>	
					</td>										
				</tr>
				<tr>
					<td width="14%" align="right" nowrap><strong><cf_translate key="LB_FechaInicial">Fecha inicial</cf_translate>:&nbsp;</strong></td>
					<td width="12%">
						<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio))>
							<cf_sifcalendario  tabindex="1" form="form1" name="fechaInicio" value="#form.fechaInicio#">
						<cfelse>
							<cf_sifcalendario  tabindex="1" form="form1" name="fechaInicio">
						</cfif>
					</td>
					<td width="13%" align="right"><strong><cf_translate key="LB_Grupo">Grupo</cf_translate>:&nbsp;</strong></td>
					<td width="42%">	
						<select name="Grupo" tabindex="1">
							<option value="">--- #LB_Todos# ---</option>
							<cfloop query="rsGrupos">
								<option value="#rsGrupos.Gid#" <cfif isdefined("form.Grupo") and len(trim(form.Grupo)) and form.Grupo EQ rsGrupos.Gid>selected</cfif>>#rsGrupos.Gdescripcion#</option>
							</cfloop>
						</select>
					</td>	
					<td colspan="2" align="center" rowspan="2">
						<input tabindex="5" type="submit" name="btnFiltrar" value="#BTN_Filtrar#" onclick="javascript: funcDeshabilitar(); document.form1.action = ''; ">
					</td>
				</tr>
				<tr>
					<td width="14%" align="right" nowrap><strong><cf_translate key="LB_FechaFinal">Fecha final</cf_translate>:&nbsp;</strong></td>										
					<td nowrap>
						<cfif isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
							<cf_sifcalendario  tabindex="1" form="form1" name="fechaFinal" value="#fechaFinal#">
						<cfelse>
							<cf_sifcalendario  tabindex="1" form="form1" name="fechaFinal">
						</cfif>
					</td>	
					<td align="right" width="13%">
						<cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
							<strong>#LB_Jornada#:</strong>
						<cfelse>
							&nbsp;	
						</cfif>
					</td>
					<td >											
						<cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
							<select name="RHJid" tabindex="1">
								<option value="">--- #LB_Todos# ---</option>
								<cfloop query="rsJornadas">
									<option value="#rsJornadas.RHJid#" <cfif isdefined("form.RHJid") and len(trim(form.RHJid)) and form.RHJid EQ rsJornadas.RHJid>selected</cfif>>#rsJornadas.RHJcodigo# - #rsJornadas.RHJdescripcion#</option>
								</cfloop>
							</select>
						<cfelse>
							&nbsp;	
						</cfif>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
				<table width="100%" cellpadding="2" cellspacing="0" border="0">
					<tr><td align="right" style="color: ##FF0000 ">#LB_LasMarcasQueAparecenEnColorRojoEstanInconsistentes#&nbsp;</td></tr>							
					<tr><td align="right" style="color: ##00CC00 ">#LB_LasMarcasQueAparecenEnColorVerdeEstanDuplicadas#&nbsp;</td></tr>	
				</table>
			</cfif>
		</td>
	</tr>
	<cfif isdefined("form.btnFiltrar")>
	<tr>
		<td>
			<cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
				<input type="checkbox" name="chkTodos" value="" onclick="javascript: funcChequeaTodos();" <cfif isdefined("form.Todos") and form.Todos EQ 1>checked</cfif>>
				<label><strong><cf_translate key="LB_SeleccionarTodos">Seleccionar Todos</cf_translate></strong></label>
			<cfelse>
				&nbsp;	
			</cfif>	
		</td>
	</tr>
	<tr>
		<td align="center">
			<table width="100%" cellpadding="0" cellspacing="0">
				<tr><td>
					<cfif isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
					<!---Query de busqueda--->	
					<cfquery name="rsLista" datasource="#session.DSN#">
						select {fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)} as Empleado, 
								a.CAMfdesde, a.CAMfhasta, a.CAMid,a.CAMpermiso,
								case when a.RHJid is not null then 
									c.RHJdescripcion
								else
									'#LB_Feriado#'
								end as Jornada,
								coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMtotminutos,1)">/60.00, 2),0) as HT,
								coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMociominutos,1)">/60.00, 2),0) as HO,
								coalesce(round(<cf_dbfunction name="to_float" args="coalesce(a.CAMtotminlab,1)">/60.00, 2),0) as HL,
								coalesce(a.CAMcanthorasreb,0) as HR,
								coalesce(a.CAMcanthorasjornada,0) as HN,
								coalesce(a.CAMcanthorasextA,0) as HEA,
								coalesce(a.CAMcanthorasextB,0) as HEB,
								coalesce(a.CAMmontoferiado,0) as MFeriado,
								case a.CAMpermiso
								when 1 then '<img src=/cfmx/rh/imagenes/checked.gif>'
								else '<img src=/cfmx/rh/imagenes/unchecked.gif>' end as permiso,
								case when (	select count(1) 
										from RHCMCalculoAcumMarcas x 
										where x.DEid = a.DEid
										  and <cf_dbfunction name="to_datechar" args="x.CAMfdesde"> = <cf_dbfunction name="to_datechar" args="a.CAMfdesde">
										  and x.CAMid <> a.CAMid
										  and x.CAMpermiso <> a.CAMpermiso
										  and x.CAMgeneradoporferiado = 0
										  and x.CAMgeneradoporferiado = a.CAMgeneradoporferiado) > 0 then CAMid
								else 0 end as inconsistencia,
								case when (	select count(1) 
								from RHCMCalculoAcumMarcas x 
								inner join RHControlMarcas z
									on x.DEid = z.DEid
									and <cf_dbfunction name="to_datechar" args="x.CAMfdesde"> = <cf_dbfunction name="to_datechar" args="z.fechahoramarca">
								where x.DEid = a.DEid
								  and <cf_dbfunction name="to_datechar" args="x.CAMfdesde"> = <cf_dbfunction name="to_datechar" args="a.CAMfdesde">
								  and x.CAMid <> a.CAMid
								  and x.CAMpermiso = a.CAMpermiso
								  and x.CAMgeneradoporferiado = a.CAMgeneradoporferiado) > 0 then CAMid
								else 0 end marcaIgual,
								case when (	select count(1) 
										from RHCMCalculoAcumMarcas x 
										where x.DEid = a.DEid
										  <!--- and <cf_dbfunction name="to_datechar" args="x.CAMfdesde"> = <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> --->
										  and x.CAMfdesde = a.CAMfdesde
										  and x.CAMid <> a.CAMid
										  and x.CAMpermiso <> a.CAMpermiso
										  and x.CAMgeneradoporferiado = 0
										  and x.CAMgeneradoporferiado = a.CAMgeneradoporferiado
										  ) > 0 then (select count(1) 
										from RHCMCalculoAcumMarcas x 
										where x.DEid = a.DEid
										  and <cf_dbfunction name="to_datechar" args="x.CAMfdesde"> = <cf_dbfunction name="to_datechar" args="a.CAMfdesde">
										  and x.CAMid <> a.CAMid
										  and x.CAMpermiso <> a.CAMpermiso
										  and x.CAMgeneradoporferiado = 0
										  and x.CAMgeneradoporferiado = a.CAMgeneradoporferiado
										  )
								else 0 end as inconsistencia2
						from RHCMCalculoAcumMarcas a
							inner join DatosEmpleado b
								on a.DEid = b.DEid
								and a.Ecodigo = b.Ecodigo
							left outer join RHJornadas c
								on a.RHJid = c.RHJid
								and a.Ecodigo = c.Ecodigo
							<cfif isdefined("form.Grupo") and len(trim(form.Grupo))>
								inner join RHCMEmpleadosGrupo d
									on a.DEid = d.DEid
									and a.Ecodigo = d.Ecodigo															
									and d.Gid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Grupo#">
							</cfif>
							
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and a.CAMestado = 'P'
							<cfif isdefined("form.RHJid") and len(trim(form.RHJid))>
								and a.RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHJid#">
							</cfif>
							<cfif isdefined("form.DEid") and len(trim(form.DEid))>
								and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
							</cfif>
							<cfif isdefined("form.fechaInicio") and len(trim(form.fechaInicio)) 
									and isdefined("form.fechaFinal") and len(trim(form.fechaFinal))>
								<cfif form.fechaInicio GT form.fechaFinal>
									and <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaFinal)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaInicio)#">
								<cfelseif form.fechaFinal GT form.fechaInicio>
									and <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaInicio)#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaFinal)#">
								<cfelse>
									and <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaInicio)#">
								</cfif>
							<cfelseif isdefined("form.fechaInicio") and len(trim(form.fechaInicio)) and (not isdefined("form.fechaFinal") or  len(trim(form.fechaFinal)) EQ 0)>
								and <cf_dbfunction name="to_datechar" args="a.CAMfdesde"> >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaInicio)#">
							<cfelseif isdefined("form.fechaFinal") and len(trim(form.fechaFinal)) and (not isdefined("form.fechaInicio") or  len(trim(form.fechaInicio)) EQ 0)>
								and <cf_dbfunction name="to_datechar" args="a.CAMfhasta"> <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fechaFinal)#">
							</cfif>	
						order by {fn concat({fn concat({fn concat({fn concat(b.DEapellido1 , ' ' )}, b.DEapellido2 )},  ' ' )}, b.DEnombre)}, a.CAMfdesde, a.CAMfhasta
					</cfquery>
					
						<cfinvoke 
							 component="rh.Componentes.pListas"
							 method="pListaQuery"
							  returnvariable="pListaEmpl">
								<cfinvokeargument name="query" value="#rsLista#"/>
								<cfinvokeargument name="desplegar" value="Empleado,CAMfdesde,CAMfhasta,Jornada,HT,HO,HL,HR,HN,HEA,HEB,MFeriado,permiso"/>
								<cfinvokeargument name="etiquetas" value="#LB_Empleado#,#LB_FDesde#,#LB_FHasta#,#LB_Jornada#,#LB_HT#,#LB_HO#,#LB_HL#,#LB_HR#,#LB_HN#,#LB_HEA#,#LB_HEB#,#LB_MFeriado#,#LB_Permiso#"/>
								<cfinvokeargument name="formatos" value="V,D,D,V,M,M,M,M,M,M,M,M,S"/>
								<cfinvokeargument name="align" value="left,left,left,left,center,center,center,center,center,center,center,left,center"/>
								<cfinvokeargument name="ajustar" value="N"/>
								<cfinvokeargument name="checkboxes" value="S"/>
								<cfinvokeargument name="irA" value="/rh/marcas/operacion/ProcesaMarcas-Cambio.cfm?Pagina=#form.Pagina#"/><!------>
								<cfinvokeargument name="keys" value="CAMid"/>
								<cfinvokeargument name="maxRows" value="#vnMaxrows#"/>
								<cfinvokeargument name="incluyeForm" value="false"/>
								<cfinvokeargument name="formName" value="form1"/>
								<cfinvokeargument name="navegacion" value="#navegacion#"/>
								<cfinvokeargument name="showEmptyListMsg" value="yes"/>
								<cfinvokeargument name="QueryString_lista" value="#QueryString_lista#"/>
								<cfinvokeargument name="funcion" value="funcNoSubmit"/>
								<cfinvokeargument name="fparams" value="CAMid,CAMpermiso"/>
								<cfinvokeargument name="lineaRoja" value="inconsistencia"/>
								<cfinvokeargument name="lineaVerde" value="marcaIgual"/>
						</cfinvoke>	

	<table width="100%" align="center">
		<tr><td>&nbsp;</td></tr>
		<tr>
		<td align="center">
				<table width="35%" cellpadding="0" cellspacing="0" align="center">
					<tr>
						<td>
							<input type="button"  name="btnAplicar" value="#BTN_Aplicar#" 
								onclick="javascript: funcAplicar();">
						</td>
						<td>
							<input type="button"  name="btnEliminar" value="#BTN_Eliminar#" 
								onclick="javascript: funcEliminar();">
						</td>
					</tr>
				</table>
		</td>
		</tr>
	</table>
	</cfif>
</td>
</tr>
</table>
</td>
</tr>
</cfif>
</cfoutput>
</table>
</form>

		<cf_web_portlet_end>
<cf_templatefooter>

	<cf_qforms form="form1">
<script language="javascript">
function hayIncosistencias(){
	var form = document.form1;
	var result = false;
	
	if (form.chk!=null) {
		if (form.chk.length){
			for (var i=0; i<form.chk.length; i++){
				var x=i+1;
				var dato = 'form.INCONSISTENCIA_'+ x +'.value';
				if (Number(eval(dato))>0 && form.chk[i].checked)
					result = true;
			}
		}
		else{
			if (Number(eval('form.INCONSISTENCIA_1.value'))>0 && form.chk.checked)
				result = true;
		}
	}
	if (result) {
		result= true;
		alert('<cfoutput>#MSG_HayMarcasInconsistentesNoSePuedeAplicar#</cfoutput>');
	}else result = false;
	return result;
}
function funcAplicar(){
	if (hayMarcados()){
		 if (!hayIncosistencias()){
			if ( confirm('<cfoutput>#MSG_ConfirmaAplicar#</cfoutput>') ){
				document.form1.BOTON.value = 'Aplicar';
				document.form1.submit();
			}
		 }else{
			return false;
		 }
	 }
}
function hayMarcados(){
	var form = document.form1;
	var result = false;
	if (form.chk!=null) {
		if (form.chk.length){
			for (var i=0; i<form.chk.length; i++){
				if (form.chk[i].checked)
					result = true;
			}
		}
		else{
			if (form.chk.checked)
				result = true;
		}
	}
	if (!result) alert('<cfoutput>#MSG_DebeSeleccionarAlMenosUnRegistroParaRelizarEstaAccion#</cfoutput>');
	return result;
}

function funcEliminar(){
				if (hayMarcados()){
					if ( confirm('<cfoutput>#MSG_ConfirmaEliminar#</cfoutput>') ){
						document.form1.BOTON.value = 'Eliminar';
						document.form1.submit();
					}
				 }
			}
function funcNoSubmit(CAMid,Permiso){
		if (Permiso == 1){
			return false;
		}else{
			location.href = "ProcesaMarcas-Cambio.cfm?Band=1&CAMid="+CAMid+ "&sid="+Math.random();
		}
	}
function cambiomodo(obj){
			document.form1.action="aprobar-lista.cfm";
			document.form1.submit();
		}

function funcDeshabilitar(){
	<cfif isdefined("form.btnFiltrar") and isdefined("rsLista") and rsLista.RecordCount NEQ 0 and isdefined("form.visualizar") and len(trim(form.visualizar)) and form.visualizar eq 0>
		objForm.chk.required = false;			
	</cfif>
}

function funcChequeaTodos(){		
	if (document.form1.chkTodos.checked){			
		if (document.form1.chk && document.form1.chk.type) {						
			if (!document.form1.chk.disabled){
				document.form1.chk.checked = true
			}
		}
		else{
			if (document.form1.chk){
				for (var i=0; i<document.form1.chk.length; i++) {
					if (!document.form1.chk[i].disabled){
						document.form1.chk[i].checked = true	
					}				
				}
			}
		}
	}	
	else{
		<cfset url.Todos = 0>
		if (document.form1.chk && document.form1.chk.type) {
			document.form1.chk.checked = false
		}
		else{
			if (document.form1.chk){
				for (var i=0; i<document.form1.chk.length; i++) {
					document.form1.chk[i].checked = false					
				}
			}
		}
	}
}
			
</script>