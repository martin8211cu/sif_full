<cfif IsDefined("form.BORRARLINEA") and len(trim(form.BORRARLINEA)) and form.BORRARLINEA eq 'S'>
	<cfquery datasource="#session.dsn#">
		delete OCtransporteProducto
		 where Aid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Aid#">
		 and   OCTid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
		 and   OCid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
		 and   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	</cfquery>
	
	<cflocation url="OCtransporte.cfm?OCTid=#URLEncodedFormat(form.OCTid)#">
<cfelseif IsDefined("form.Alta")>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select OCTestado
		  from OCtransporte
		 where OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
		   and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
	</cfquery>		
	<cfif rsSQL.OCTestado EQ "T">
		<cf_errorCode	code = "50433" msg = "El transporte fue definido para DDtipo = 'T=tránsito'">
	</cfif>
	
	<cftransaction>
		<cfquery datasource="#session.dsn#" >
			insert into OCproductoTransito (
				Ecodigo,
				OCTid,
				Aid,
				OCPTentradasCantidad,
				OCPTentradasCostoTotal,
				OCPTsalidasCantidad,
				OCPTsalidasCostoTotal,
				BMUsucodigo
			)
			select 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">,
				b.Aid,
				0.00,
				0.00,
				0.00,
				0.00,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			from OCordenComercial a 
			inner join OCordenProducto b 
				on a.OCid = b.OCid 
				and a.Ecodigo = b.Ecodigo 
			where  a.OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
				and a.Ecodigo =	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and not exists (
					select 1 
					from OCproductoTransito
					where OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
					and OCproductoTransito.Aid = b.Aid
				)
		</cfquery>	
	
		<cfquery datasource="#session.dsn#">
			insert into OCtransporteProducto (
				OCTid,
				OCid,
				Aid,
				Ecodigo,
				OCPTestado,
				OCtipoOD,
				OCTPnumeroBOL,
				OCTPfechaBOL,
				OCTPcontrato,
				OCTPfechaAllocation,
				OCTPfechaPropiedad,
				OCTPcantidadTeorica,
				OCTPprecioUniTeorico,
				OCTPprecioTotTeorico,
				OCTPcantidadReal,
				OCTPprecioReal,
				BMUsucodigo)
			select 
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">,
				a.OCid,
				
				b.Aid, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				'N',
				a.OCtipoOD,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OCTPnumeroBOL#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#form.OCTPfechaBOL#">,
				a.OCcontrato,
				a.OCfechaAllocationDefault,
				a.OCfechaPropiedadDefault,
				OCPcantidad as OCTPcantidadTeorica,
				OCPprecioUnitario as OCTPprecioUniTeorico,				
				OCPprecioTotal as OCTPprecioTotTeorico,
				0,
				0,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> 
			from OCordenComercial a
			inner join OCordenProducto  b
				 on a.OCid = b.OCid
				and a.Ecodigo = b.Ecodigo	
			inner join 	OCproductoTransito c
				 on c.OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
				and c.Aid = b.Aid
				and a.Ecodigo = b.Ecodigo	
			where  a.OCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCid#">
				and a.Ecodigo =	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				
				and not exists (
					select 1 
					from OCtransporteProducto
					where OCTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.OCTid#">
					and OCtransporteProducto.Aid = b.Aid
					and OCtransporteProducto.OCid = a.OCid
				)				
		</cfquery>
	</cftransaction>
	<cflocation url="OCtransporte.cfm?OCTid=#URLEncodedFormat(form.OCTid)#">
<cfelseif IsDefined("form.Nuevo")>
	<cflocation url="OCtransporte.cfm?OCTid=#URLEncodedFormat(form.OCTid)#">
<cfelse>
	<!--- Tratar como form.nuevo --->
	<cflocation url="OCtransporte.cfm?OCTid=#URLEncodedFormat(form.OCTid)#">
</cfif>





