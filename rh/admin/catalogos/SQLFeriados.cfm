<cfparam name="action" default="Feriados.cfm">
<cfparam name="modo" default="ALTA">

<cffunction name="modificar" access="public">
	<!--- RESULTADO --->
	<!---  Inserta el Encabezado de feriados --->
	<cfargument name="RHFid"          type="numeric"  required="true" default="">
	<cfargument name="ts_rversion"      type="string"  required="true" default="">
	<cfargument name="RHFdescripcion" type="string"   required="true" default="">
	<cfargument name="RHFfecha"       type="string"   required="true" default="">
	<cfargument name="RHFregional"    type="numeric" required="true" default="">

	<cf_dbtimestamp datasource="#session.dsn#"
				   table="RHFeriados"
				   redirect="formFeriados.cfm"
				   timestamp="#form.ts_rversion#"
				   field1="Ecodigo" 
				   type1="numeric" 
				   value1="#Session.Ecodigo#"
				   field2="RHFid" 
				   type2="numeric" 
				   value2="#form.RHFid#">

	<cfquery name="rsModificarEF" datasource="#session.DSN#">
		update RHFeriados
		set RHFdescripcion = <cfqueryparam value="#arguments.RHFdescripcion#"    cfsqltype="cf_sql_varchar">,
			RHFfecha       = <cfqueryparam value="#LSParseDateTime(arguments.RHFfecha)#"   cfsqltype="cf_sql_timestamp">,
			RHFregional    = <cfqueryparam cfsqltype="cf_sql_bit" value="#arguments.RHFregional#">,
			RHFpagooblig   = <cfif isdefined("form.RHFpagooblig")>1<cfelse>0</cfif> 
		where Ecodigo   = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and RHFid     =  <cfqueryparam value="#arguments.RHFid#" cfsqltype="cf_sql_numeric">
	</cfquery>
</cffunction>

<cffunction name="borrar_detalle" access="public">
	<!--- RESULTADO --->
	<!---  Borra uno ó todos los detalles de feriados --->
	<cfargument name="RHFid"   type="numeric"  required="true"  default="">
	<cfargument name="Ocodigo" type="numeric"  required="false" >

	<cfquery name="rsBorrarDE" datasource="#session.DSN#">
		delete from RHDFeriados
		where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
		  and RHFid   = <cfqueryparam value="#arguments.RHFid#" cfsqltype="cf_sql_numeric">
		  <cfif isdefined("arguments.Ocodigo") >	
		      and Ocodigo = <cfqueryparam value="#form.LOcodigo#" cfsqltype="cf_sql_integer">
		  </cfif>	
	</cfquery>
</cffunction>

<cfif not isdefined("form.Nuevo")>
	<cftransaction>
		<cfif isdefined("form.Alta")>
			<cfquery name="ABC_FeriadosInsert" datasource="#session.DSN#">
				<!--- inserta un encabezado y puede insertar una oficina, si regional esta activo --->
				insert into RHFeriados ( Ecodigo, RHFdescripcion, RHFfecha, RHFregional, RHFpagooblig)
				values ( <cfqueryparam value="#session.Ecodigo#"      cfsqltype="cf_sql_integer">,
						  <cfqueryparam value="#form.RHFdescripcion#"   cfsqltype="cf_sql_varchar">,
						  <cfqueryparam value="#LSParseDateTime(form.rhffecha)#"   cfsqltype="cf_sql_timestamp">,
						  <cfif isdefined("form.RHFregional") >1<cfelse>0</cfif>,
						  <cfif isdefined("form.RHFpagooblig")>1<cfelse>0</cfif> 
						)
				<cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="ABC_FeriadosInsert">
				<!--- 			
			<cfif isdefined("form.RHFregional") and len(trim(form.Ocodigo)) gt 0 >
				 /* insert RHDFeriados(RHFid, Ocodigo, Ecodigo) 
				values( @RHFid, 
						<cfqueryparam value="#form.Ocodigo#" cfsqltype="cf_sql_integer">
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> ) */
			</cfif>
			--->
			<cfset modo = 'ALTA' >
		<cfelseif isdefined("form.Cambio")>
			<!--- Modifica el encabezado de feriados. Si regional es 0 (no esta definido, borra todos los detalles del encabezado) --->
			<cfif isdefined("form.RHFregional") ><cfset regional = 1 ><cfelse><cfset regional = 0 ></cfif>	
				<cfoutput>
					#modificar(form.RHFid, form.ts_rversion, form.RHFdescripcion, RHFfecha, regional)#
				</cfoutput>
			<cfif not isdefined("form.RHFregional") >
				<cfoutput>
					#borrar_detalle(form.RHFid)#
				</cfoutput>
			</cfif> 
			<cfset modo = 'CAMBIO'>
		<cfelseif isdefined("form.btnAgregar")>
			<!--- Agrega un detalle, si el bit regional es cero, lo modifica a uno --->
			<cfset regional = 1 >
			<cfoutput>
				#modificar(form.RHFid, form.ts_rversion, form.RHFdescripcion, RHFfecha, regional)#
			</cfoutput>
			<cfquery name="ABC_FeriadosInsertD" datasource="#session.DSN#">
				insert into RHDFeriados(RHFid, Ocodigo, Ecodigo) 
				values( <cfqueryparam value="#form.RHFid#" cfsqltype="cf_sql_numeric">, 
						<cfqueryparam value="#form.Ocodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> )
			</cfquery>
		  <cfset modo = 'CAMBIO'>
	
		<cfelseif isdefined("form.btnBorrar.X") and len(trim(form.LOcodigo)) gt 0>
			<!--- Borra un detalle, si al encabezado no tiene mas detalles, pone el bit regional en cero --->
			<cfoutput>
				#borrar_detalle(form.RHFid, form.LOcodigo)#
			</cfoutput>
			if not exists ( <cfquery name="ABC_FeriadosUpdateIf" datasource="#session.DSN#">
								select 1 
								from RHDFeriados 
								where RHFid   = <cfqueryparam value="#form.RHFid#" cfsqltype="cf_sql_numeric">
								  and Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
							 </cfquery>
						  ) 
			begin
				<cfquery name="ABC_FeriadosUpdate" datasource="#session.DSN#">
					update RHFeriados
					set RHFregional = 0
					where Ecodigo   = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHFid     =  <cfqueryparam value="#form.RHFid#" cfsqltype="cf_sql_numeric">
				</cfquery>
			end		 
			<cfset modo = 'CAMBIO'>
		<cfelseif isdefined("form.Baja")>
			<!--- Borra el encabezado y sus detalles --->
			<cfoutput>
				#borrar_detalle(form.RHFid)#
			</cfoutput>
			<cfquery name="ABC_FeriadosDelete" datasource="#session.DSN#">
				delete from RHFeriados
				where Ecodigo= <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHFid =  <cfqueryparam value="#form.RHFid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfset modo = 'ALTA'>
		</cfif>
	</cftransaction>
</cfif>	

<cfoutput>
<form action="Feriados.cfm" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'><input name="RHFid" type="hidden" value="#form.RHFid#"></cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
	
	<!--- filtros de la lista ini --->
	<cfif isdefined("btnFiltrar")>
		<input type="hidden" name="btnFiltrar" value="Filtrar">
	</cfif>
	<cfif isdefined("form.fRHFfecha") and len( trim(form.fRHFfecha) ) gt 0>
		<input type="hidden" name="fRHFfecha" value="#form.fRHFfecha#">
	</cfif>	
	<!--- filtros de la lista fin --->
	
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>