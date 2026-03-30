 <!---  <cf_dump var="#Form#"> --->
 
 <!--- JMRV. 14/08/2014 --->
 
 <cfif isdefined("Form.botonSel") and (Form.botonSel eq "Alta" or Form.botonSel eq "Cambio")>
 	<cfif Form.CTFLcodigo eq "" or Form.CTFLdescripcion eq "">
 		<cfthrow message="Debe definir todos los parametros, de lo contrario no podra realizarse esta accion.">
 	</cfif>
 </cfif>

<cfif isdefined("Form.botonSel") and Form.botonSel eq "filtrar">
	
	<cfset modo = 'ALTA' >
	
	<cfset filtro = '1=1'>
	
	<cfif isdefined("Form.CTFLcodigo") and Form.CTFLcodigo neq "">
		<cfset filtro = filtro & ' and CTFLcodigo = ' & "'#Form.CTFLcodigo#'">
	</cfif>
	
	<cfif isdefined("Form.CTFLdescripcion") and Form.CTFLdescripcion neq "">
		<cfset filtro = filtro & ' and CTFLdescripcion = ' & "'#Form.CTFLdescripcion#'">
	</cfif>
	
			
	<cf_templateheader title="Fundamento Legal">
	<cf_web_portlet_start titulo="Fundamento Legal">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
	<table width="95%" border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td valign="top" width="50%">
				<cfinvoke component="sif.Componentes.pListas" method="pListaRH"	 returnvariable="pListaTran">
				<cfinvokeargument name="tabla" 		value="CTFundamentoLegal"/>
				<cfinvokeargument name="columnas" 	value="CTFLid,CTFLcodigo,CTFLdescripcion"/>
				<cfinvokeargument name="desplegar" 	value="CTFLcodigo,CTFLdescripcion"/>
				<cfinvokeargument name="etiquetas" 	value="Codigo, Descripcion"/>
				<cfinvokeargument name="formatos" 	value="S,S"/>
				<cfinvokeargument name="filtro" 	value="#filtro#"/>
				<cfinvokeargument name="align" 		value="left, left, left"/>
				<cfinvokeargument name="ajustar" 	value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>
				<cfinvokeargument name="keys" 		value="CTFLid"/>
				<cfinvokeargument name="irA"	 	value="FundamentoLegal.cfm"/>
				<cfinvokeargument name="maxRows" 	value="#form.MaxRows#"/>
			</cfinvoke>
			</td>
			<td><cfinclude template="FundamentoLegal-form.cfm"></td>
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
				select top 1 CTFLcodigo from CTFundamentoLegal  
				where Ecodigo = #Session.Ecodigo#
				  and CTFLcodigo = <cfqueryparam value="#Form.CTFLcodigo#" cfsqltype="cf_sql_varchar">
			</cfquery>
			
			<cfif rsExiste.RecordCount eq 0>
				<cfquery name="rsInsert" datasource="#Session.DSN#">
					insert into CTFundamentoLegal (CTFLcodigo, CTFLdescripcion, Ecodigo, BMUsucodigo, Usucodigo)
					values ( <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CTFLcodigo)#">,
							 <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Form.CTFLdescripcion)#">, 
							 #session.Ecodigo#, 
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
							)
					<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
				<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert">
				<cfset Form.CTFLid = rsInsert.identity>
				<cfset modo = 'ALTA' >
				<cfquery name="rsPagina" datasource="#session.DSN#">
				 	select CTFLcodigo
					from CTFundamentoLegal 
					where Ecodigo =  #session.Ecodigo#
					order by CTFLcodigo 
				</cfquery>
				<cfset row = 1>
				<cfif rsPagina.RecordCount LT 500>
					<cfloop query="rsPagina">
						<cfif rsPagina.CTFLcodigo EQ form.CTFLcodigo>
							<cfset row = rsPagina.currentrow>
							<cfbreak>
						</cfif>
					</cfloop>
				</cfif>
				<cfset form.pagina = Ceiling(row / form.MaxRows)>
				<cfset params=params&"&CTFLcodigo="&form.CTFLcodigo>
			<cfelse>
				<cfthrow message="Ya existe un documento con este codigo, la accion no puede ser realizada.">	
			</cfif>
		<!--- Eliminar un Registro --->
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="rsVerificaCTContrato" datasource="#Session.DSN#">
				select CTCnumContrato
				from CTContrato
				where CTFLid =  <cfqueryparam value="#Form.CTFLid#" cfsqltype="cf_sql_numeric">
				and  Ecodigo =  #session.Ecodigo#
			</cfquery>
			<cfif rsVerificaCTContrato.RecordCount eq 0>
				<cfquery name="rsDelete" datasource="#Session.DSN#">
					delete from CTFundamentoLegal
					where Ecodigo = #Session.Ecodigo#
					and CTFLid  = <cfqueryparam value="#Form.CTFLid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfset modo = 'ALTA' >			
				<cfquery name="rsPagina" datasource="#session.DSN#">
					 	select CTFLcodigo
						from CTFundamentoLegal
						where Ecodigo =  #session.Ecodigo#
						order by CTFLcodigo 
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
			<!---<cfquery name="rsVerificaSiExiste" datasource="#Session.DSN#">
				select * from CTFundamentoLegal 
				where Ecodigo = #Session.Ecodigo#
				and CTFLcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.CTFLcodigo)#">
			<cfif isdefined("Form.CTFLid") and Form.CTFLid neq "">
				and CTFLid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTFLid#">
			</cfif>
			</cfquery>
			<cfif rsVerificaSiExiste.recordCount gt 0>
				<cfthrow message="No se puede cambiar el documento con ese codigo porque el codigo ya existe, la accion no se pudo realizar.">
			</cfif>--->
			<cfquery name="Transacciones" datasource="#Session.DSN#">
				update CTFundamentoLegal set 
					  CTFLdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.CTFLdescripcion)#">,
				<cfif isdefined("session.Usucodigo") and session.Usucodigo neq "">
					  BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				<cfelse>
					  BMUsucodigo = null
				</cfif>
				where Ecodigo = #Session.Ecodigo#
				and CTFLid = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#Form.CTFLid#">
			</cfquery>
			<cfset modo = 'ALTA' >
				<cfquery name="rsPagina" datasource="#session.DSN#">
				 	select CTFLcodigo
					from CTFundamentoLegal 
					where Ecodigo =  #session.Ecodigo#
					order by CTFLcodigo 
				</cfquery>
				<cfset row = 1>
				<cfif rsPagina.RecordCount LT 500>
					<cfloop query="rsPagina">
						<cfif rsPagina.CTFLcodigo EQ form.CTFLcodigo>
							<cfset row = rsPagina.currentrow>
							<cfbreak>
						</cfif>
					</cfloop>
				</cfif>
				<cfset form.pagina = Ceiling(row / form.MaxRows)>
				<cfset params=params&"&CTFLcodigo="&form.CTFLcodigo>	
		</cfif>
	<cfelse>
		<cfset modo = 'ALTA' >
	</cfif>
	
	<cfoutput>
	<form action="FundamentoLegal.cfm" method="post" name="sql">
	    <input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="CTFLid" type="hidden" tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(Form.CTFLid)#</cfoutput></cfif>">
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