<!--- Me premite cagar el centro funcional de acuerdo al DEid y a la fecha para ubicarlo en la tabla de LineaTiempo. 
	--->
<script language="javascript" type="text/javascript" src="../../js/utilesMonto.js"></script>

<cfif #url.DEid# neq 'undefined'>


<!---Query que busca el centro funcional--->

<cfif isdefined('url.Fecha') and len(trim(url.Fecha))>
	<cfquery name="rsCFid" datasource="#session.DSN#">
		select 
		coalesce( b.CFidconta, b.CFid)as CFid,
		a.Ecodigo   

		from LineaTiempo a
		
		inner join RHPlazas b
		on a.RHPid=b.RHPid
		
		where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#url.Fecha#"> between LTdesde and LThasta
		and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">	 
	</cfquery>
	
	<cfquery name="rsEcodigoHoy" datasource="#session.DSN#">
		select 
		a.Ecodigo   

		from LineaTiempo a
		
		where <cf_dbfunction name="now"> between LTdesde and LThasta
		and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">	 
	</cfquery>
	
	<cfif  len(trim(#rsCFid.CFid#)) eq 0 or #rsCFid.Ecodigo# neq #rsEcodigoHoy.Ecodigo#>
		<cfquery name="rsCFid" datasource="#session.DSN#">
		select 
		coalesce( b.CFidconta, b.CFid)as CFid

		from LineaTiempo a
		
		inner join RHPlazas b
		on a.RHPid=b.RHPid
		
		where <cf_dbfunction name="now"> between LTdesde and LThasta
		and a.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEid#">
	</cfquery>
	</cfif>
	
	<cfif len(trim(#rsCFid.CFid#)) gt 0>
		<cfquery name="rsCFdes" datasource="#session.DSN#">
			select 
			CFcodigo,
			CFdescripcion
			
			from CFuncional 
			
			where CFid=#rsCFid.CFid# 
			and  Ecodigo = #session.Ecodigo#
		</cfquery>
	</cfif>	
	
</cfif>

<cfif len(trim(#rsCFid.CFid#)) gt 0>
	<cfset CFcodigo=#rsCFdes.CFcodigo#>
	<cfset CFdescripcion=#rsCFdes.CFdescripcion#>
	<cfoutput>
	<script language="javascript1.2" type="text/javascript">
	
		 window.parent.document.form1.CFcodigo.value ='#CFcodigo#';
		 window.parent.document.form1.CFdescripcion.value='#CFdescripcion#';
	</script>
	</cfoutput>
</cfif>	
</cfif>	

