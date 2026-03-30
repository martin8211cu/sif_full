<!---NUEVO Lote--->
<cfif IsDefined("form.Nuevo")>
	<cflocation url="QPassLote.cfm?Nuevo">
</cfif>

<cfif isdefined("Form.Alta")>
	<cfquery name="insertLote" datasource="#session.dsn#">
		insert into QPassLote (QPLcodigo ,QPLdescripcion, QPLfechaProduccion , QPLfechaFinVigencia , BMfecha , BMUsucodigo,Ecodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_char" 	 value="#form.QPLcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPLdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.QPLfechaProduccion)#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.QPLfechaFinVigencia)#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">	
				)
		<cf_dbidentity1 datasource="#Session.DSN#" verificar_transaccion="false">
	</cfquery>
	<cf_dbidentity2 datasource="#Session.DSN#" name="insertLote" verificar_transaccion="false" returnvariable="QPidLote">
	<cflocation url="QPassLote.cfm?QPidLote=#QPidLote#" addtoken="no">
<cfelseif isdefined("Form.Baja") or isdefined ("btnEliminar")>
	<cfif isdefined("form.chk") and len(trim(form.chk)) GT 0>
		<cfquery name="rsDelete" datasource="#session.DSN#">
			delete from QPassLote
			where Ecodigo = #session.Ecodigo#
			  and QPidLote in  (#form.chk#)
		</cfquery>	
		<cfelseif isdefined("form.QPidLote") and len(trim(form.QPidLote)) GT 0>
			<cfquery name="rsDelete" datasource="#session.DSN#">
				delete from QPassLote
				where Ecodigo = #session.Ecodigo#
					and QPidLote  = #form.QPidLote#
			</cfquery>	
		</cfif>
	<cflocation url="QPassLote.cfm" addtoken="no">	
<cfelseif isdefined("Form.Cambio")>
	<cfquery name="rsUpdate" datasource="#session.DSN#">
		update 	QPassLote
		set QPLdescripcion 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.QPLdescripcion#">,
			QPLfechaProduccion 	= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.QPLfechaProduccion)#">,
			QPLfechaFinVigencia = <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.QPLfechaFinVigencia)#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and QPidLote  = #form.QPidLote#
	</cfquery>
	
	<cfquery name="rsUpdateTag" datasource="#session.DSN#">
		update 	QPassTag
		set QPTFechaProduccion 	= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.QPLfechaProduccion)#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and QPidLote  = #form.QPidLote#
	</cfquery>
	
	<cflocation url="QPassLote.cfm?QPidLote=#form.QPidLote#&pagenum3=#form.Pagina3#">
</cfif>
<cfset form.Modo = "Cambio">
<cflocation url="QPassLote.cfm?QPidLote=#form.QPidLote#" addtoken="no">


