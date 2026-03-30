<cfset nivel="1">

<cfif isdefined('form.LCidPadre') and form.LCidPadre NEQ ''>
	<cfquery datasource="#session.dsn#" name="rsNivel">
		Select (DPnivel + 1) as nivelInf, DPnivel as nivelAct
		from Localidad
		where LCid=
			<cfif isdefined('form.Alta')>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LCidPadre#">
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LCid#">
			</cfif>
	</cfquery>
	
	<cfif isdefined('rsNivel') and rsNivel.recordCount GT 0>
		<cfif isdefined('form.Alta')>
			<cfset nivel=rsNivel.nivelInf>
		<cfelse>
			<cfset nivel=rsNivel.nivelAct>
		</cfif>
	</cfif>
</cfif>

<cfif IsDefined("form.Cambio")>	
	<cfinvoke component="saci.comp.Localidad"
		method="Cambio" >
		<cfinvokeargument name="LCid" value="#form.LCid#">
		<cfinvokeargument name="Ppais" value="#form.Ppais#">
		<cfinvokeargument name="DPnivel" value="#nivel#">
		<cfinvokeargument name="LCcod" value="#form.LCcod#">
		<cfinvokeargument name="LCnombre" value="#form.LCnombre#">
		<cfif isdefined('form.LCidPadre') and form.LCidPadre NEQ ''>
			<cfinvokeargument name="LCidPadre" value="#form.LCidPadre#">
		</cfif>		
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>
<cfelseif IsDefined("form.Baja")>
	<cfquery datasource="#session.dsn#" name="rsDependencias">
		Select count(1) as cuenta
		from Localidad
		where LCidPadre =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LCid#">
	</cfquery>

	<cfif isdefined('rsDependencias') and rsDependencias.cuenta EQ 0>
		<cfinvoke component="saci.comp.Localidad"
			method="Baja">
			<cfinvokeargument name="LCid" value="#form.LCid#">
		</cfinvoke>
	<cfelse>
			<cfthrow message="Error, no se permite la eliminación de la localidad seleccionada, ya que esta se utiliza actualmente en la estructura división
								política o bien es referenciado en otro lugar del Sistema.">
	</cfif>
<cfelseif IsDefined("form.Alta")>	
	<cfinvoke component="saci.comp.Localidad"
		method="Alta" returnvariable="newID">
		<cfinvokeargument name="Ppais" value="#form.Ppais#">
		<cfinvokeargument name="DPnivel" value="#nivel#">
		<cfinvokeargument name="LCcod" value="#form.LCcod#">
		<cfinvokeargument name="LCnombre" value="#form.LCnombre#">
		<cfif isdefined('form.LCidPadre') and form.LCidPadre NEQ ''>
			<cfinvokeargument name="LCidPadre" value="#form.LCidPadre#">		
		</cfif>
	</cfinvoke>
	
	<cfif newID NEQ -1>
		<cfset form.LCid = newID>
		<cfset form.modoLoc = 'CAMBIO'>
	</cfif>
<cfelseif IsDefined("form.Regresar")>	
	<cfif isdefined('form.LCidPadre') and form.LCidPadre NEQ ''>
		<cfquery datasource="#session.dsn#" name="rsRegresa">
			select LCnombre	
				, LCidPadre
				, LCid
			from Localidad
			where LCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LCidPadre#">
		</cfquery>
		<cfif isdefined('rsRegresa') and rsRegresa.recordCount GT 0>
			<cfset form.LCid = rsRegresa.LCid>
			<cfset form.LCidPadre = rsRegresa.LCidPadre>		
			<cfset form.modoLoc = 'CAMBIO'>
		<cfelse>
			<cfset form.LCid = ''>
			<cfset form.LCidPadre = ''>		
		</cfif>
	<cfelse>
		<cfset form.LCid = ''>
	</cfif>
<cfelse>	<!--- Regresar a la Lista Inicial --->
	<cfset form.LCid = ''>
</cfif>

<cfinclude template="Localidad-redirect.cfm">


