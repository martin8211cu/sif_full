<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init(true)>

<cfif isdefined("url.Aid") and url.Aid NEQ "" and isdefined("url.Mcodigo") and url.Mcodigo NEQ "">
	<cfquery name="dataContrato" datasource="#session.DSN#">
		Select #LvarOBJ_PrecioU("DCpreciou")#, DCtc, Mcodigo
		from EContratosCM ec
			inner join DContratosCM dc
				on ec.ECid=dc.ECid
					and ec.Ecodigo=dc.Ecodigo
		where ec.Ecodigo= #session.Ecodigo# 
			and Aid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Aid#">
			and <cf_dbfunction name="now"> between ECfechaini and ECfechafin
	</cfquery>

	<cfset PrecioUni = 0>
	<cfif dataContrato.recordCount gt 0>
		<cfset PrecioUni = LvarOBJ_PrecioU.enCF(dataContrato.DCpreciou)>
	
		<cfif dataContrato.Mcodigo NEQ url.Mcodigo>
			<cfquery name="dataTC" datasource="#session.DSN#">
				Select es.Mcodigo, ESidsolicitud
				from ESolicitudCompraCM es
					inner join Empresas e
						on es.Ecodigo=e.Ecodigo
							and es.Mcodigo=e.Mcodigo
				where es.Ecodigo= #session.Ecodigo# 
					and ESidsolicitud= <cfqueryparam cfsqltype="cf_sql_integer" value="#url.sol#">
			</cfquery>		
		
			<cfif isdefined('dataTC') and dataTC.recordCount GT 0>
				<cfset PrecioUni = LvarOBJ_PrecioU.enCF(PrecioUni * dataContrato.DCtc)>
			<cfelse>
				<script language="JavaScript">
					alert('Error, no existe la definición de esa moneda en el contrato vigente para ese bien o servicio.');
					<cfset PrecioUni = 0>					
				</script>
			</cfif>
		</cfif>			
	<cfelse>
		<cfset PrecioUni = 0>
	</cfif>

	<script language="JavaScript">
		<cfif dataContrato.recordCount gt 0>
			window.parent.document.form1.bandera.value="1";
			window.parent.document.form1.DSmontoest.value="<cfoutput>#LvarOBJ_PrecioU.enCF(PrecioUni)#</cfoutput>";
			window.parent.document.form1.DStotallinest.value="<cfoutput>#(PrecioUni * url.DScant)#</cfoutput>";			
		<cfelse>
			window.parent.document.form1.bandera.value="0";
			window.parent.document.form1.DSmontoest.value="0.00";
			window.parent.document.form1.DStotallinest.value="0.00";	
		</cfif>
	</script>				
</cfif>
