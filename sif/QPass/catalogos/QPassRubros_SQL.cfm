<!---NUEVO Convenio--->
<cfset form.QPCmonto = "#replace(form.QPCmonto,",","","ALL")#0001">

<cfif IsDefined("form.Nuevo")>
	<cflocation url="QPassRubros.cfm?Nuevo">
</cfif>

<cfif isdefined("Form.Alta")>
    <cfquery name="rsCodigo" datasource="#session.dsn#">
        select 1 from QPCausa
        where Ecodigo = #session.Ecodigo#
        and QPCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPCcodigo#">
    </cfquery>
	
	<cfif rsCodigo.recordcount eq 0>
		<cfquery name="insertCausa" datasource="#session.dsn#">
			insert into QPCausa 
			(
				QPCcodigo,
				QPCdescripcion, 
				QPCmonto,       
				Ecodigo,         
				BMFecha,      
				BMUsucodigo,
				Mcodigo,
				QPCCuentaContable,
				QPCMontoVariable,
				QPCtipo
			 )
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPCcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPCdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_money"   value="#form.QPCmonto#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPCCuentaContable#">,
				<cfif isdefined("form.QPCMontoVariable")>1<cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPCtipo#">
			)
			<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
		</cfquery>
	<cf_dbidentity2 datasource="#Session.DSN#" name="insertCausa" verificar_transaccion="false" returnvariable="QPCid">
	<cflocation url="QPassRubros.cfm?QPCid=#QPCid#" addtoken="no">
	<cfelse>
		<cfthrow message="El c&oacute;digo a ingresar ya se encuentra registrado">
	</cfif>
	
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="rsVerificaRubro" datasource="#session.dsn#">
			select count(1) as cantidad
			from QPCausa a
				inner join QPCausaxConvenio b
					on a.QPCid  =  b.QPCid 
			where a.Ecodigo = #session.Ecodigo#
			and QPCcodigo = '#form.QPCcodigo#'
		</cfquery>
	
			<cfif rsVerificaRubro.cantidad gt 0>
				<cfthrow message="No se puede eliminar la causa, porque est&aacute; asociada a un convenio">
			<cfelse>
				<cfquery datasource="#session.DSN#">
					delete from QPCausa
					where Ecodigo = #session.Ecodigo#
					  and QPCid = #form.QPCid#
				</cfquery>	
			</cfif>
	<cflocation url="QPassRubros.cfm" addtoken="no">	
	
<cfelseif isdefined("form.Cambio")>
  <cfquery name="rsCodigo" datasource="#session.dsn#">
        select 1 from QPCausa
        where Ecodigo = #session.Ecodigo#
        and QPCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPCcodigo#">
    </cfquery>


	<cfquery datasource="#session.DSN#">
		update QPCausa
		set 
		<cfif rsCodigo.recordcount eq 0>
			QPCcodigo		=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPCcodigo#">,
		</cfif>
			QPCdescripcion	=  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPCdescripcion#">,
			QPCmonto 		=  <cfqueryparam cfsqltype="cf_sql_money" 	value="#form.QPCmonto#">,
			BMUsucodigo 	=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,  
			Mcodigo         =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
			BMFecha 		= #now()#,
			QPCCuentaContable =	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPCCuentaContable#">,
			QPCMontoVariable  = <cfif isdefined("form.QPCMontoVariable") and len(trim(form.QPCMontoVariable))>1<cfelse>0</cfif>,
			QPCtipo         =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.QPCtipo#">
		where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and QPCid = #form.QPCid#
	</cfquery>
	<cflocation url="QPassRubros.cfm?QPCid=#form.QPCid#" addtoken="no">
</cfif>

<cfset form.Modo = "Cambio">
<cflocation url="QPassRubros.cfm?QPCid=#form.QPCid#" addtoken="no">