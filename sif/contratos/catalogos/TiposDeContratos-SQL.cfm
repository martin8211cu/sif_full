<!--- <cf_dump var="#Form#"> --->

 <cfif isdefined("Form.botonSel") and (Form.botonSel eq "Alta" or Form.botonSel eq "Cambio")>
 	<cfif Form.CTTCcodigo eq "" or Form.CTTCdescripcion eq "" or Form.montoMaximo eq "" or Form.McodigoOri eq "" or Form.McodigoOri eq -1>
 		<cfthrow message="Debe definir todos los parametros para agregar el nuevo tipo de contrato, de lo contrario no podra realizarse esta accion.">
 	</cfif>
 	<cfif not (isdefined("Form.Articulo") or isdefined("Form.ActivoFijo") or isdefined("Form.Servicio") or isdefined("Form.Obra"))>
 		<cfthrow message="Elija por lo menos un tipo de compra permitida para el nuevo contrato.">
 	</cfif>
 </cfif>

<cfif isdefined("Form.botonSel") and Form.botonSel eq "filtrar">

	<cfset modo = 'ALTA' >

	<cfset filtro = '1=1'>

	<cfif isdefined("Form.CTTCcodigo") and Form.CTTCcodigo neq "">
		<cfset filtro = filtro & ' and CTTCcodigo = ' & "'#Form.CTTCcodigo#'">
	</cfif>

	<cfif isdefined("Form.CTTCdescripcion") and Form.CTTCdescripcion neq "">
		<cfset filtro = filtro & ' and CTTCdescripcion = ' & "'#Form.CTTCdescripcion#'">
	</cfif>

	<cfif isdefined("Form.McodigoOri") and Form.McodigoOri neq "" and Form.McodigoOri neq -1>
		<cfset filtro = filtro & ' and CTTCMcodigo = #Form.McodigoOri#'>
	</cfif>

	<cfif isdefined("Form.montoMaximo") and Form.montoMaximo neq "">
		<cfset filtro = filtro & ' and CTTCmontomax = #Form.montoMaximo#'>
	</cfif>

	<cfif isdefined("Form.articulo")>
		<cfset filtro = filtro & ' and CTTCarticulo = 1'>
	</cfif>

	<cfif isdefined("Form.activoFijo")>
		<cfset filtro = filtro & ' and CTTCactivofijo = 1'>
	</cfif>

	<cfif isdefined("Form.servicio")>
		<cfset filtro = filtro & ' and CTTCservicio = 1'>
	</cfif>

	<cfif isdefined("Form.obra")>
		<cfset filtro = filtro & ' and CTTCobra = 1'>
	</cfif>



	<cf_templateheader title="Tipos de Contratos">
	<cf_web_portlet_start titulo="Tipos de Contratos">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
	<table width="95%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top" width="50%">
				<cfinvoke component="sif.Componentes.pListas" method="pListaRH"	 returnvariable="pListaTran">
				<cfinvokeargument name="tabla" 		value="CTTipoContrato"/>
				<cfinvokeargument name="columnas" 	value="CTTCid,CTTCcodigo,CTTCdescripcion"/>
				<cfinvokeargument name="desplegar" 	value="CTTCcodigo,CTTCdescripcion"/>
				<cfinvokeargument name="etiquetas" 	value="Codigo, Descripcion"/>
				<cfinvokeargument name="formatos" 	value="S,S"/>
				<cfinvokeargument name="filtro" 	value="#filtro#"/>
				<cfinvokeargument name="align" 		value="left, left, left"/>
				<cfinvokeargument name="ajustar" 	value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="keys" 		value="CTTCid"/>
				<cfinvokeargument name="irA"	 	value="TiposDeContratos.cfm"/>
				<cfinvokeargument name="maxRows" 	value="#form.MaxRows#"/>
			</cfinvoke>
			</td>
			<td><cfinclude template="TiposDeContratos-form.cfm"></td>
		</tr>
	</table>
	<cf_web_portlet_end>
	<cf_templatefooter>


<cfelse>
	<cfset params = "">
	<cfif not isdefined("Form.Nuevo")>
		<!--- Dar de alta un nuevo Registro --->
		<cfif isdefined("Form.Alta")>
			<cfquery name="rsExiste" datasource="#session.DSN#">
				select top 1 CTTCcodigo from CTTipoContrato
				where Ecodigo = #Session.Ecodigo#
				  and CTTCcodigo = <cfqueryparam value="#Form.CTTCcodigo#" cfsqltype="cf_sql_varchar">
			</cfquery>

			<cfif rsExiste.RecordCount eq 0>
				<cfquery name="rsInsert" datasource="#Session.DSN#">
					insert into CTTipoContrato (CTTCcodigo, CTTCdescripcion, Ecodigo, CTTCmontomax, CTTCMcodigo,
												CTTCarticulo, CTTCservicio, CTTCactivofijo, CTTCobra, BMUsucodigo, Usucodigo,
												FMT01COD)
					values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CTTCcodigo)#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CTTCdescripcion)#">,
							 #session.Ecodigo#,
							 <cfqueryparam cfsqltype="cf_sql_money" value="#Form.montoMaximo#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.McodigoOri#">,
							 <cfif isdefined("Form.Articulo")>
							 	1
							 <cfelse>
							 	0
							 </cfif>,
							 <cfif isdefined("Form.ActivoFijo")>
							 	1
							 <cfelse>
							 	0
							 </cfif>,
							 <cfif isdefined("Form.Servicio")>
							 	1
							 <cfelse>
							 	0
							 </cfif>,
							 <cfif isdefined("Form.Obra")>
							 	1
							 <cfelse>
							 	0
							 </cfif>,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.formato#" null="#not len(trim(form.formato))#">
							)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
				<cfset Form.CTTCid = rsInsert.identity>
				<cfset modo = 'ALTA' >
				<cfquery name="rsPagina" datasource="#session.DSN#">
				 	select CTTCcodigo
					from CTTipoContrato
					where Ecodigo =  #session.Ecodigo#
					order by CTTCcodigo
				</cfquery>
				<cfset row = 1>
				<cfif rsPagina.RecordCount LT 500>
					<cfloop query="rsPagina">
						<cfif rsPagina.CTTCcodigo EQ form.CTTCcodigo>
							<cfset row = rsPagina.currentrow>
							<cfbreak>
						</cfif>
					</cfloop>
				</cfif>
				<cfset form.pagina = Ceiling(row / form.MaxRows)>
				<cfset params=params&"&CTTCcodigo="&form.CTTCcodigo>
			<cfelse>
				<cfthrow message="Ya existe un registro con este codigo, la accion no puede ser realizada.">
			</cfif>
		<!--- Eliminar un Registro --->
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="rsVerificaCTContrato" datasource="#Session.DSN#">
				select CTCnumContrato
				from CTContrato
				where CTTCid =  <cfqueryparam value="#Form.CTTCid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfif rsVerificaCTContrato.RecordCount eq 0>
				<cfquery name="rsDelete" datasource="#Session.DSN#">
					delete from CTTipoContrato
					where Ecodigo = #Session.Ecodigo#
					  and CTTCid  = <cfqueryparam value="#Form.CTTCid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfset modo = 'ALTA' >
				<cfquery name="rsPagina" datasource="#session.DSN#">
					 	select CTTCcodigo
						from CTTipoContrato
						where Ecodigo =  #session.Ecodigo#
						order by CTTCcodigo
				</cfquery>
				<cfset pag = Ceiling(rsPagina.RecordCount / form.MaxRows)>
				<cfif form.Pagina GT pag>
					<cfset form.Pagina = pag>
				</cfif>
			<cfelse>
				<cfthrow message="El registro no puede ser eliminado, ya que existe un contrato asociado a este.">
			</cfif><!--- rsVerificaCTContrato.RecordCount eq 0 --->
		<!--- Modificar un Registro --->
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="Transacciones" datasource="#Session.DSN#">
				update CTTipoContrato set
					  CTTCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.CTTCcodigo)#">,
					  CTTCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.CTTCdescripcion)#">,
					  CTTCMcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.McodigoOri#">,
					  CTTCmontomax = <cfqueryparam cfsqltype="cf_sql_money" value="#LSParseNumber(Form.montomaximo)#">,
					  <cfif isdefined("Form.Articulo")>
					 	CTTCarticulo = 1
					 <cfelse>
					 	CTTCarticulo = 0
					 </cfif>,
					 <cfif isdefined("Form.ActivoFijo")>
					 	CTTCactivofijo = 1
					 <cfelse>
					 	CTTCactivofijo = 0
					 </cfif>,
					 <cfif isdefined("Form.Servicio")>
					 	CTTCservicio = 1
					 <cfelse>
					 	CTTCservicio = 0
					 </cfif>,
					 <cfif isdefined("Form.Obra")>
					 	CTTCobra = 1,
					 <cfelse>
					 	CTTCobra = 0,
					 </cfif>
					 FMT01COD=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.formato#" null="# not len(trim(form.formato))#">
				where Ecodigo = #Session.Ecodigo#
				  and CTTCid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Form.CTTCid#">
			</cfquery>
			<cfset modo = 'ALTA' >
				<cfquery name="rsPagina" datasource="#session.DSN#">
				 	select CTTCcodigo
					from CTTipoContrato
					where Ecodigo =  #session.Ecodigo#
					order by CTTCcodigo
				</cfquery>
				<cfset row = 1>
				<cfif rsPagina.RecordCount LT 500>
					<cfloop query="rsPagina">
						<cfif rsPagina.CTTCcodigo EQ form.CTTCcodigo>
							<cfset row = rsPagina.currentrow>
							<cfbreak>
						</cfif>
					</cfloop>
				</cfif>
				<cfset form.pagina = Ceiling(row / form.MaxRows)>
				<cfset params=params&"&CTTCcodigo="&form.CTTCcodigo>
		</cfif>
	<cfelse>
		<cfset modo = 'ALTA' >
	</cfif>

	<cfoutput>
	<form action="TiposDeContratos.cfm" method="post" name="sql">
	    <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="CTTCid" type="hidden" tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(Form.CTTCid)#</cfoutput></cfif>">
	</form>
	</cfoutput>
	<HTML>
	<head>
	</head>
	<body>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
	</HTML>

</cfif>