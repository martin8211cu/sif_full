<cffunction name="altaValoracionAgente" output="false" returntype="void" access="remote">
  <cfargument name="CTid" type="numeric" required="Yes"  displayname="Codigo_Cuenta">
  <cfargument name="rechazo" type="boolean" required="no" default="false"  displayname="Cuenta_Rechazada">  
  <cfargument name="Ecodigo" type="numeric" required="no" default="#session.Ecodigo#"  displayname="Codigo_Empresa">  
  <cfargument name="conexion" type="string" required="no" default="#session.dsn#"  displayname="Conexion">    
	
	<cfquery name="rsInconsist" datasource="#Arguments.conexion#">
		Select ai.AGid
			, Inombre
			, case Iseveridad
				when '0' then 'Advertencia'
				when '1' then 'Leve'
				when '2' then 'Grave'
				when '3' then 'Improcedente'
			end Iseveridad
		from ISBagenteIncidencia ai
			inner join ISBinconsistencias i
				on i.Iid=ai.Iid
					and i.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#" null="#Len(Arguments.Ecodigo) Is 0#">
					and i.Ipenalizada=1
		where ai.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">
	</cfquery>
	
	<!--- Inconsistencia penalizada. Se agrega valoracion negativa para el agente involucrado --->
	<cfif isdefined('rsInconsist') and rsInconsist.recordCount GT 0>
		<cfloop query="rsInconsist">
			<cfinvoke component="saci.comp.ISBagente" method="altaValoraciones" >
				<cfinvokeargument name="AGid" value="#rsInconsist.AGid#">			
				<cfinvokeargument name="tipo" value="-1">
				<cfinvokeargument name="observacion" value="Se le agreg una anotacin con la inconsistencia: '#rsInconsist.Inombre#' y con severidad: '#rsInconsist.Iseveridad#', la cual es penalizada">
			</cfinvoke>	
		</cfloop>
	<cfelse>
		<cfif not Arguments.rechazo>
			<cfquery name="rsAgentes" datasource="#Arguments.conexion#">
				Select distinct ag.AGid
				from ISBcuenta a
					inner join ISBproducto c
						on  a.CTid = c.CTid
					inner join ISBvendedor v
						on v.Vid=c.Vid
					inner join ISBagente ag
						on ag.AGid=v.AGid
				where a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">  
			</cfquery>
			<!--- No existen Inconsistencias. Se agrega valoracion positiva para el o los agentes involucrados --->
			<cfif isdefined('rsAgentes') and rsAgentes.recordCount GT 0>
				<cfloop query="rsAgentes">
					<cfinvoke component="saci.comp.ISBagente" method="altaValoraciones" >
						<cfinvokeargument name="AGid" value="#rsAgentes.AGid#">			
						<cfinvokeargument name="tipo" value="1">
						<cfinvokeargument name="observacion" value="Se aprob la cuenta: #Arguments.CTid# que no posea anotaciones penalizadas">
					</cfinvoke>	
				</cfloop>
			</cfif>			
		</cfif>
	</cfif>
	
	<cfif Arguments.rechazo>
		<cfquery name="rsAgentes" datasource="#Arguments.conexion#">
			Select distinct ag.AGid
			from ISBcuenta a
				inner join ISBproducto c
					on  a.CTid = c.CTid
				inner join ISBvendedor v
					on v.Vid=c.Vid
				inner join ISBagente ag
					on ag.AGid=v.AGid
			where a.CTid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CTid#" null="#Len(Arguments.CTid) Is 0#">  
		</cfquery>
		<!--- No existen Inconsistencias. Se agrega valoracion positiva para el o los agentes involucrados --->
		<cfif isdefined('rsAgentes') and rsAgentes.recordCount GT 0>
			<cfloop query="rsAgentes">
				<cfinvoke component="saci.comp.ISBagente" method="altaValoraciones" >
					<cfinvokeargument name="AGid" value="#rsAgentes.AGid#">			
					<cfinvokeargument name="tipo" value="-1">
					<cfinvokeargument name="observacion" value="Se rechaz la cuenta: #Arguments.CTid# en la cual el agente estaba envolucrado">
				</cfinvoke>	
			</cfloop>
		</cfif>		
	</cfif>
</cffunction>

<cfif isdefined("form.cue") and len(trim(form.cue))>
	<cfset form.CTid = form.cue>
</cfif>

<cfif IsDefined("form.btnAprobar") and form.btnAprobar EQ 1>	
	<!--- Aprobacion de la cuenta pero solo del contrato seleccionado --->
	<cfif isdefined('form.contra') and form.contra NEQ ''>
		<cfquery datasource="#Session.DSN#" name="rsProducto">
			select * 
			from  ISBproducto
			where Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.contra#"> 
		</cfquery>
		
		<cfif isdefined('rsProducto') and rsProducto.recordCount GT 0>
			<cfinvoke component="saci.comp.ISBproducto" method="Cambio" >
				<cfinvokeargument name="Contratoid" value="#rsProducto.Contratoid#">
				<cfinvokeargument name="CTid" value="#rsProducto.CTid#">
				<cfinvokeargument name="CTidFactura" value="#rsProducto.CTidFactura#">
				<cfinvokeargument name="PQcodigo" value="#rsProducto.PQcodigo#">
				<cfinvokeargument name="Vid" value="#rsProducto.Vid#">
				<cfinvokeargument name="CTcondicion" value="1">
				<cfinvokeargument name="CNsuscriptor" value="#rsProducto.CNsuscriptor#">
				<cfinvokeargument name="CNnumero" value="#rsProducto.CNnumero#">
				<cfinvokeargument name="CNapertura" value="#rsProducto.CNapertura#">
			</cfinvoke>
		</cfif>
	</cfif>
			
	<!--- 
		Analisis de las anotaciones del contrato, y si existieran algunas penalizadas,
		se le agregarian valoraciones negativas al agente por cada una dependiendo del codigo de la cuenta
	 --->	
	 <cfset altaValoracionAgente(form.CTid)>
	
	<cflocation url="aprobacion_lista.cfm?Activo=1">
<cfelseif IsDefined("form.btnRechazar") and form.btnRechazar EQ 1>	
	<!--- Rechazo de la cuenta pero solo del contrato seleccionado --->
	<cfif isdefined('form.contra') and form.contra NEQ ''>
		<cfquery datasource="#Session.DSN#" name="rsProducto">
			select * 
			from  ISBproducto
			where Contratoid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.contra#"> 
		</cfquery>
		
		<cfif isdefined('rsProducto') and rsProducto.recordCount GT 0>
			<cfinvoke component="saci.comp.ISBproducto" method="Cambio" >
				<cfinvokeargument name="Contratoid" value="#rsProducto.Contratoid#">
				<cfinvokeargument name="CTid" value="#rsProducto.CTid#">
				<cfinvokeargument name="CTidFactura" value="#rsProducto.CTidFactura#">
				<cfinvokeargument name="PQcodigo" value="#rsProducto.PQcodigo#">
				<cfinvokeargument name="Vid" value="#rsProducto.Vid#">
				<cfinvokeargument name="CTcondicion" value="X">
				<cfinvokeargument name="CNsuscriptor" value="#rsProducto.CNsuscriptor#">
				<cfinvokeargument name="CNnumero" value="#rsProducto.CNnumero#">
				<cfinvokeargument name="CNapertura" value="#rsProducto.CNapertura#">
			</cfinvoke>
		</cfif>
	</cfif>	

	<!--- Insercion de valoracion negativa para el agente por rechazo de contrato --->
	 <cfset altaValoracionAgente(form.CTid,'true')>
	
	<cflocation url="aprobacion_lista.cfm?Activo=2">
<cfelseif IsDefined("form.Guardar")>	
	<cfinclude template="cuenta-apply.cfm">
</cfif>

<cfinclude template="aprobacion-redirect.cfm">