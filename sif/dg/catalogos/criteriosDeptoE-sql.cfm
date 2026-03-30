<cfset params = '?1=1' >
<cfif isdefined("form.pagenum_lista")>
	<cfset params = params & '&pagenum_lista=#form.pagenum_lista#' >
</cfif>
<cfif isdefined("form.filtro_DGCDcodigo")>
	<cfset params = params & '&filtro_DGCDcodigo=#form.filtro_DGCDcodigo#' >
</cfif>
<cfif isdefined("form.filtro_PCDvalor")>
	<cfset params = params & '&filtro_PCDvalor=#form.filtro_PCDvalor#' >
</cfif>

<cfif isdefined("form.ALTA")>
	<cfquery name="rsInsert" datasource="#session.DSN#">
		insert INTO DGCriteriosDeptoE(	PCEcatid,
										PCDcatid,
										DGCDid,
										Periodo,
										Mes,
										CEcodigo,
										BMUsucodigo, 
										BMfechaalta )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> )
	</cfquery>				

<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#" >
		delete from DGDCriterioDeptoE
		where DGCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#">
		  and PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
		  and PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
		  and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
		  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
	</cfquery>

	<cfquery datasource="#session.DSN#">
		delete from DGCriteriosDeptoE
		where DGCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#">
		  and PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
		  and PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
		  and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
		  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
	</cfquery>
	<cflocation url="criteriosDeptoE-lista.cfm#params#">

<cfelseif isdefined("form.CAMBIODET")>
	<!--- borra todos los  registros --->
	<cfquery datasource="#session.DSN#" >
		delete from DGDCriterioDeptoE
		where DGCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#">
		  and PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">
		  and PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
		  and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">
		  and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">
	</cfquery>
	<cfloop from="1" to="#form.registros#" index="i">
		<cfset nEmpresa = 'empresa_#i#' >
		<cfset nOficinas = form['oficinas_#i#'] >

		<cfloop from="1" to="#nOficinas#" index="j">
			<cfset nOcodigo = form['ocodigo_#i#_#j#'] >
			<cfset nValor   = form['valor_#i#_#j#'] >

			<cfif len(trim(nValor)) eq 0>
				<cfset nValor = 0 >
			<cfelse>
				<cfset mValor = replace(nValor, ',','','all')  >
			</cfif>
			
			<cfif len(trim(nOcodigo)) >
				<cfquery datasource="#session.DSN#">
					insert into DGDCriterioDeptoE( PCEcatid, 
												   PCDcatid, 
												   DGCDid, 
												   Periodo,
												   Mes,
												   Ecodigo,
												   Ocodigo,
												   Valor, 
												   BMfechaalta, 
												   BMUsucodigo )
					values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCEcatid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DGCDid#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Periodo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Mes#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form[nEmpresa]#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#nOcodigo#">,							
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#mValor#" scale="4">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
				</cfquery>
			</cfif>
		</cfloop>
	</cfloop>
</cfif>

<cfif isdefined("form.Nuevo")>
	<cflocation url="criteriosDeptoE.cfm#params#">
</cfif>

<cfset params = params & '&DGCDid=#form.DGCDid#&PCEcatid=#form.PCEcatid#&PCDcatid=#form.PCDcatid#&Periodo=#form.Periodo#&Mes=#form.Mes#' >
<cflocation url="criteriosDeptoE.cfm#params#">