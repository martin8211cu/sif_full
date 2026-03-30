
<cfif IsDefined("form.Cambio")>
	<cfquery datasource="#session.dsn#" name="rsSQL">
		select 
			OCTtipo,
			OCTtransporte,
			OCTestado, 		
			OCTnumCierre
		  from OCtransporte 
		 where OCTid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
		 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	</cfquery>
	<cfif form.OCTestado NEQ rsSQL.OCTestado and rsSQL.OCTnumCierre GT 0>
		<cf_errorCode	code = "50435"
						msg  = "No se permite cambiar el Estado del Transporte @errorDat_1@-@errorDat_2@ porque ya fue ejecutado el proceso de Cierre de Transporte"
						errorDat_1="#rsSQL.OCTtipo#"
						errorDat_2="#rsSQL.OCTtransporte#"
		>
	</cfif>
	<cfquery datasource="#session.dsn#">
		update OCtransporte
		   set OCTfechaPartida 	= <cfif isdefined("form.OCTfechaPartida") and Len(Trim(form.OCTfechaPartida))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OCTfechaPartida#"><cfelse>null</cfif>
			 , OCTfechaLlegada 		= <cfif isdefined("form.OCTfechaLlegada") and Len(Trim(form.OCTfechaLlegada))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OCTfechaLlegada#"><cfelse>null</cfif>
			 , OCTtransporte 		= <cfif isdefined("form.OCTtransporte") and Len(Trim(form.OCTtransporte))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OCTtransporte#"><cfelse>null</cfif>
			 , OCTvehiculo			= <cfif isdefined("form.OCTvehiculo") and Len(Trim(form.OCTvehiculo))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OCTvehiculo#"><cfelse>null</cfif>
			 , OCTruta 				= <cfif isdefined("form.OCTruta") and Len(Trim(form.OCTruta))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OCTruta#"><cfelse>null</cfif>
			 , OCTPnumeroBOLdefault = <cfif isdefined("form.OCTPnumeroBOLdefault") and Len(Trim(form.OCTPnumeroBOLdefault))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTPnumeroBOLdefault#"><cfelse>null</cfif>
			 , OCTPfechaBOLdefault  = <cfif isdefined("form.OCTPfechaBOLdefault") and Len(Trim(form.OCTPfechaBOLdefault))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OCTPfechaBOLdefault#"><cfelse>null</cfif>
			 , OCTestado 			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTestado#">
		 <cfif form.OCTestado EQ "C" and rsSQL.OCTestado EQ "T">
		 	 , OCTnumCierre			= -1
		 </cfif>
		where OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
		 and   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	</cfquery>
	<cflocation url="OCtransporte.cfm?OCTid=#URLEncodedFormat(form.OCTid)#">
<cfelseif IsDefined("form.Baja")>
	<cftransaction>
		<cfquery datasource="#session.dsn#">
			delete OCtransporteProducto
			 where OCTid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
			 and   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete OCproductoTransito
			 where OCTid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
			 and   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete OCtransporte
			where OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
		</cfquery>
	</cftransaction>
	<cflocation url="OCtransporte.cfm?btnNuevo=btnNuevo">
<cfelseif IsDefined("form.Alta")>	
	<cftransaction>
	<cfquery name="RSInsert" datasource="#session.DSN#">
		insert into OCtransporte (
			Ecodigo,
			OCTtipo,
			OCTtransporte,
			OCTvehiculo,
			OCTruta,
			OCTfechaPartida,
			OCTfechaLlegada,
			OCTestado,
			OCTPnumeroBOLdefault,
			OCTPfechaBOLdefault,
			BMUsucodigo)
		values (
			<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.OCTtipo#">,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.OCTtransporte#">,
			<cfif isdefined("form.OCTvehiculo") and Len(Trim(form.OCTvehiculo))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OCTvehiculo#"><cfelse>null</cfif>,
			<cfif isdefined("form.OCTruta") and Len(Trim(form.OCTruta))><cfqueryparam cfsqltype="cf_sql_char" value="#form.OCTruta#"><cfelse>null</cfif>,
			<cfif isdefined("form.OCTfechaPartida") and Len(Trim(form.OCTfechaPartida))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OCTfechaPartida#"><cfelse>null</cfif>,
			<cfif isdefined("form.OCTfechaLlegada") and Len(Trim(form.OCTfechaLlegada))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OCTfechaLlegada#"><cfelse>null</cfif>,
			'A',
			<cfif isdefined("form.OCTPnumeroBOLdefault") and Len(Trim(form.OCTPnumeroBOLdefault))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTPnumeroBOLdefault#"><cfelse>null</cfif>,
			<cfif isdefined("form.OCTPfechaBOLdefault") and Len(Trim(form.OCTPfechaBOLdefault))><cfqueryparam cfsqltype="cf_sql_date" value="#form.OCTPfechaBOLdefault#"><cfelse>null</cfif>,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">)
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="RSInsert">
		<cfset form.OCTid = RSInsert.identity >
	</cftransaction>
	<cflocation url="OCtransporte.cfm?OCTid=#URLEncodedFormat(form.OCTid)#">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="OCtransporte.cfm?btnNuevo=btnNuevo">
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cflocation url="OCtransporte.cfm">
</cfif>





