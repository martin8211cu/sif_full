<cftransaction>

	<cfquery name="data" datasource="#session.DSN#">
		select FAX01TIP as tipo
		from FAX001 a
		where a.FAX01NTR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAX01NTR#">
	</cfquery>

	<cfif data.tipo EQ 9 >
		<cfquery datasource="#session.DSN#">
			update FAX014
			set FAX14STS = '3',
				FAX14MAP = FAX14MON
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and FAX01NTR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAX01NTR#">
				and FAM01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAM01COD#">
			  <!---nd FAX14STS = '1'--->
		</cfquery>
	</cfif>

	<cfquery datasource="#session.DSN#">
		update FAX001
		set FAX01STA = 'A'			
			<cfif isdefined("form.FAX01OBS") and len(trim(form.FAX01OBS))>
				,FAX01OBS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.FAX01OBS)#">
			</cfif>
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and FAX01NTR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAX01NTR#">
		  	and FAM01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAM01COD#">
		  <!---and FAX01STA = 'T'---->
	</cfquery>
	<!---============= Insertar en la bitÃ¡cora de anulaciones de adelantos =================---->
	<cfquery datasource="#session.DSN#">
		insert into FABitacoraAnulacionAd (FAX01NTR, 
											FAM01COD, 
											Ecodigo, 
											Documento, 
											Ocodigo, 
											CDCcodigo, 
											Mcodigo, 
											Monto, 
											FABAnulacionFecha, 
											FABAnulacionMotivo, 
											FABAnulacionIP_Maquina, 
											BMUsucodigo, 
											BMfechaalta)
		select 	a.FAX01NTR, 
				a.FAM01COD,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> as Ecodigo,
				a.FAX01DOC as Documento,
				a.Ocodigo,
				a.CDCcodigo,
				a.Mcodigo,
				a.FAX01TOT as Monto,
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> as FABAnulacionFecha,
				a.FAX01OBS as FABAnulacionMotivo,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.sitio.ip#"> as FABAnulacionIP_Maquina,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> as BMUsucodigo,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> as BMfechaalta
		from FAX001 a				
		where 	Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and FAX01NTR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FAX01NTR#">
		  	and FAM01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAM01COD#"> 
	</cfquery>
</cftransaction>

<cfset vs_fparametros = ''><!----Variable con los filtros recibidos de la lista que van a ser devueltos---->
<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo))><!---Filtro de cliente--->
	<cfset vs_fparametros = '&CDCcodigo=' &  form.CDCcodigo>
</cfif>
<cflocation url="anulacion.cfm?FAM01COD=#form.FAM01COD#&#vs_fparametros#">
