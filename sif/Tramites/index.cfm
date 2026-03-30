<!--- este cflocation es para la demo de ronal --->
<cflocation url="tr2/index.cfm">
<!--- este cflocation es para la demo de ronal --->

<cfset Session.DSN="sdc">
<cfif isDefined("url.TPID")>
	<cfif isDefined("url.Avance")>
		<cfset Avance=url.Avance>
	<cfelse>
		<cfquery datasource="sdc" name="rstpid">
			select Avance from TramitePasaporte
			where TPID = <cfqueryparam cfsqltype="cf_sql_decimal" value="#url.TPID#">
			  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
			  and Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
		</cfquery>
		<cfif #rstpid.RecordCount# NEQ 1><cflocation url="trpass01.cfm"></cfif>
		<cfset Avance=rstpid.Avance>
	</cfif>
	<cfif #Avance# EQ '1'>
		<cflocation url="trpass-1.cfm?TPID=#url.TPID#">
	<cfelseif #Avance# EQ '2'>
		<cflocation url="trpass02.cfm?TPID=#url.TPID#">
	<cfelseif #Avance# EQ '3'>
		<cflocation url="trpass03.cfm?TPID=#url.TPID#">
	<cfelseif #Avance# EQ '4'>
		<cflocation url="trpass-4.cfm?TPID=#url.TPID#">
	<cfelseif #Avance# EQ '5'>
		<cflocation url="trpass05.cfm?TPID=#url.TPID#">
	<cfelseif #Avance# EQ '6'>
		<cflocation url="detalle.cfm?TPID=#url.TPID#">
	<cfelse>
		<cflocation url="trpass--#Avance#.cfm?TPID=#url.TPID#">
	</cfif></td>
<cfelse>

	<cfquery name="contar" datasource="sdc">
	select count(1) as cuantos
	from TramitePasaporte t
	where t.Usucodigo = <cfqueryparam cfsqltype="cf_sql_decimal" value="#session.Usucodigo#">
	  and t.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Ulocalizacion#">
	  and t.Avance != '6'
	</cfquery>
	<cfif #contar.cuantos# EQ 0>
		<cflocation url="trpass01.cfm">
	<cfelse>
		<cflocation url="pendientes.cfm">
	</cfif>
</cfif>