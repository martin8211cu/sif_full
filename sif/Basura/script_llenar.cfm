<cfsetting requesttimeout="72000" >
<cfset session.DSN = 'minisif'>
<cfset session.Ecodigo = 1>

<cfquery name="nivel_h" datasource="#session.DSN#">
	select RHNid from RHNiveles where RHNhabcono = 'H' and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfquery name="nivel_c" datasource="#session.DSN#">
	select RHNid from RHNiveles where RHNhabcono = 'C' and Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>

<cfset hnivel = arraynew(1)>
<cfset i = 0 >
<cfloop query="nivel_h">
	<cfset i = i+1 >
	<cfset hnivel[i] = nivel_h.RHNid >
</cfloop>

<cfset cnivel = arraynew(1)>
<cfset i = 0 >
<cfloop query="nivel_c">
	<cfset i = i+1 >
	<cfset cnivel[i] = nivel_c.RHNid >
</cfloop>

<!---- ACTUALIZA LOS NIVELES DE HABILIDADES Y CONOCIMIENTOS POR PUESTO estaban desmadrados con datos viejos --->
<!---
	<cfquery name="habilidades" datasource="#session.DSN#">
		select RHHid 
		from RHHabilidadesPuesto 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

	<cfloop query="habilidades">
		<cfset habilidad = habilidades.RHHid >
		<cfset h = RandRange(1,ArrayLen(hnivel))>

		<cfquery name="update" datasource="#session.DSN#" >
			update RHHabilidadesPuesto
			set RHNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#hnivel[h]#" >
			where RHHid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#habilidad#">
		</cfquery>
	</cfloop>

	<cfquery name="conocimientos" datasource="#session.DSN#">
		select RHCid 
		from RHConocimientosPuesto 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	</cfquery>

	<cfloop query="conocimientos">
		<cfset conocimiento = conocimientos.RHCid >
		<cfset c = RandRange(1,ArrayLen(cnivel))>

		<cfquery name="update" datasource="#session.DSN#" >
			update RHConocimientosPuesto
			set RHNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cnivel[c]#" >
			where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#conocimiento#">
		</cfquery>
	</cfloop>
--->
<!--- --->


<!--- poner la relacion que es--->
<cfset relacion = 106 >

<cfquery name="data" datasource="#SESSION.dsn#">
	select a.DEid, RHECidevaluador, a.RHPcodigo
	from RHListaEvalCap a, RHEvaluadoresCap b
	where a.RHEECid=b.RHEECid
	and a.DEid=b.DEid
	and a.RHEECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#relacion#">
</cfquery>

<cfquery name="borrar" datasource="#session.DSN#">
	delete RHDEvaluacionCap where RHEECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#relacion#">
</cfquery>

<cfloop query="data">
	<cfset puesto = data.RHPcodigo >
	<cfset empleado = data.DEid >
	<cfset evaluador = data.RHECidevaluador >
	
	<cfquery name="habilidades" datasource="#session.DSN#">
		select RHHid 
		from RHHabilidadesPuesto 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and RHPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#puesto#">
	</cfquery>
	
	<cfloop query="habilidades" >
		<cfset habilidad = habilidades.RHHid >
		<cfset h = RandRange(1,ArrayLen(hnivel))>
		<cfset h2 = RandRange(1,ArrayLen(hnivel))>
		
		<cfquery name="insert" datasource="#session.DSN#">
			insert RHDEvaluacionCap(RHECidevaluador, RHEECid, DEid, RHHid, RHNidrequerido, RHNidreal)
			values (  <cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluador#" >,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#relacion#" >,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#empleado#" >,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#habilidad#" >,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#hnivel[h]#" >,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#hnivel[h2]#" >
				  )  
		</cfquery>

	</cfloop>
	
	<cfquery name="conocimientos" datasource="#session.DSN#">
		select RHCid 
		from RHConocimientosPuesto 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and RHPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#puesto#">
	</cfquery>

	<cfloop query="conocimientos" >
		<cfset conocimiento = conocimientos.RHCid >
		<cfset c = RandRange(1,ArrayLen(cnivel))>
		<cfset c2 = RandRange(1,ArrayLen(cnivel))>
		
		<cfquery name="insert" datasource="#session.DSN#">
			insert RHDEvaluacionCap(RHECidevaluador, RHEECid, DEid, RHCid, RHNidrequerido, RHNidreal)
			values (  <cfqueryparam cfsqltype="cf_sql_numeric" value="#evaluador#" >,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#relacion#" >,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#empleado#" >,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#conocimiento#" >,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#cnivel[c]#" >,
					  <cfqueryparam cfsqltype="cf_sql_numeric" value="#cnivel[c2]#" >
				  )  
		</cfquery>

	</cfloop>

	
</cfloop>
