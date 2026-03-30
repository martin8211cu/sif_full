<!---<cf_dump var="#form#">
NUEVO Promotor--->
<cfif IsDefined("form.Nuevo")>
	<cflocation url="QPassPromotor.cfm?Nuevo">
</cfif>

<cfif isdefined("Form.Alta")>
    <cfquery name="rsCodigo" datasource="#session.dsn#">
        select 1 from QPPromotor
        where Ecodigo = #session.Ecodigo#
        and QPPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPPcodigo#">
    </cfquery>
	
	<cfif rsCodigo.recordcount eq 0>
		<cfquery name="insertPromotor" datasource="#session.dsn#">
			insert into QPPromotor 
			(
			  QPPnombre,
			  QPPcodigo,
			  QPPtelefono,
			  QPPdirreccion,
			  QPPestado,
			  Ocodigo,
			  Ecodigo,
			  BMFecha,
			  QPPPuntoSeguro,
			  BMUsucodigo		
			 )
			values(
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPPnombre#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPPcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPPtelefono#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPPdirreccion#">,
				<cfif isdefined("form.QPPestado") and len(trim(form.QPPestado))> '1' <cfelse> '0'</cfif>,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Oficina#">,	
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,	
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				<cfif isdefined("form.QPPPuntoSeguro") and len(trim(form.QPPPuntoSeguro))> 1 <cfelse> 2</cfif>,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			)
			<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
		</cfquery>
	<cf_dbidentity2 datasource="#Session.DSN#" name="insertPromotor" verificar_transaccion="false" returnvariable="QPPid">
	<cflocation url="QPassPromotor.cfm?QPPid=#QPPid#" addtoken="no">
	<cfelse>
		<cfthrow message="El c&oacute;digo a ingresar ya se encuentra registrado">
	</cfif>
	
<cfelseif isdefined("Form.Baja")>
    <cfquery name="rsAsignaTags" datasource="#session.dsn#">
		 select count(1) as cantidad from QPPromotor a
			inner join QPassTag b
				on a.QPPid = b.QPPid
			inner join QPEAsignaPromotor c
				on a.QPPid = c.QPPid
				and a.Ecodigo = c.Ecodigo
      		  where a.Ecodigo = #session.Ecodigo#
			  and b.QPTEstadoActivacion  not in (3,4)
			  and QPPestado = '1'
             and a.QPPid = #form.QPPid#
    </cfquery>

	<cfif rsAsignaTags.cantidad eq 0>
		<cfquery datasource="#session.DSN#">
			delete from QPPromotor
			where Ecodigo = #session.Ecodigo#
			  and QPPid = #form.QPPid#
		</cfquery>	
	<cfelse>
		<cfthrow message="No se puede eliminar porque tiene datos asociados">
	</cfif>
	<cflocation url="QPassPromotor.cfm" addtoken="no">	
<cfelseif isdefined("Form.Cambio")>
	<cfquery name="rsUpdate" datasource="#session.DSN#">
		update QPPromotor
		set QPPnombre 	   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPPnombre#">,
			QPPcodigo 	   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPPcodigo#">,
			QPPtelefono    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPPtelefono#">,
			QPPdirreccion  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPPdirreccion#">,
			QPPestado      = <cfif isdefined("form.QPPestado") and len(trim(form.QPPestado))> '1' <cfelse> '0' </cfif>,
			QPPPuntoSeguro = <cfif isdefined("form.QPPPuntoSeguro") and len(trim(form.QPPPuntoSeguro))> 1 <cfelse> 2 </cfif>,
			Ocodigo        = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Oficina#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and QPPid  =  #form.QPPid#
	</cfquery>
	<cflocation url="QPassPromotor.cfm?QPPid=#form.QPPid#&pagenum3=#form.Pagina3#">
</cfif>
<cfset form.Modo = "Cambio">
<cflocation url="QPassPromotor.cfm?QPPid=#form.QPPid#" addtoken="no">