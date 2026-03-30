<cfthrow message="YA NO SE DEBE USAR">
<!---<!--- CONSULTA DE PROYECCION REGISTRADA --->
<cfif isdefined('form.EIRid') and LEN(TRIM(form.EIRid))>

	<!--- BUSCA LAS DIFERENTES VERSIONES DE LA PROYECCION --->
	<cfquery name="rsNversion" datasource="#session.DSN#">
		select coalesce(a.Nversion,0) as Nversion, Estado
		from RHLiquidacionRenta a
		where a.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIRid#">
		  and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and a.Tipo = 'P' <!--- PROYECCION --->
		 <!--- and a.Estado <> 30--->
	</cfquery>
	
	<cfif rsNversion.RecordCount GT 0>	   
		<cfquery name="rsVersion" dbtype="query">
			select max(Nversion) as Nversion
			from rsNversion
		</cfquery>
		<cfset form.Nversion = rsVersion.Nversion + 1>  
		<cfset form.ActualVersion = 1 >
					
		
		<cfquery name="rsDatos" datasource="#session.DSN#"  >
            select  a.EIRid, a.DEid ,RHCRPTid ,coalesce(sum(MontoHistorico),0) as MontoHistorico,coalesce(sum(MontoEmpleado),0) as MontoEmpleado,coalesce(sum(MontoAutorizado),0) as MontoAutorizado,
            coalesce(sum(b.RentaRetenida),0) as RentaRetenida 
            ,coalesce(a.RentaRetenida,0) as RentaRetenidaLiqu
            
            from RHLiquidacionRenta a 
                 inner join RHDLiquidacionRenta b 
                on b.EIRid = a.EIRid 
                and b.DEid = a.DEid 
                
                where a.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIRid#">
                  and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
                  and a.Tipo = 'P' <!--- PROYECCION --->
                  and a.Nversion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ActualVersion#">
                  
                  group by b.RHCRPTid,  a.EIRid, a.DEid ,a.RentaRetenida		
		</cfquery>		

	<cfelse>
		<cfquery name="rsNversion" datasource="#session.DSN#">
			select a.Nversion as Nversion
			from RHLiquidacionRenta a
			where a.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIRid#">
			  and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		</cfquery>
		
		<cfif rsNversion.recordCount GT 0>
			<cfquery name="rsMaxNversion" datasource="#session.DSN#">
			select max(a.Nversion) as Nversion
			from RHLiquidacionRenta a
			where a.EIRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EIRid#">
			  and a.DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			</cfquery>		
			<cfset form.Nversion = rsMaxNversion.Nversion + 1>			
			<cfset form.ActualVersion = 1 >
		<cfelse>			
			<cfset form.Nversion = 1>
		</cfif>
		
	</cfif>
</cfif>
<!---<!--- FUNCIONES  PARA LA INSERCCION DEL DETALLE--->
<cffunction name="ObtieneIGSS" acess="private" returntype="numeric">
	<cfargument name="DEid" 		type="numeric" required="yes">
	<cfargument name="Periodo" 		type="numeric" required="yes">
	<cfargument name="Mes" 			type="numeric" required="yes">
    <cfargument name="SalarioBruto" type="boolean" required="no" default="false">

	<cfquery name="rsIGSS" datasource="#session.DSN#">
		select coalesce(sum(a.CCvaloremp),0 ) as monto	
		from HCargasCalculo a
		inner join DCargas b
			on b.DClinea = a.DClinea
		inner join ECargas c
			on c.ECid = b.ECid
			and c.ECauto = 1
		inner join CalendarioPagos ca
			on ca.CPid = a.RCNid 	
		where a.DEid 	   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		  	and ca.CPperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Periodo#">
		  	and ca.CPmes     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mes#">
          <cfif Arguments.SalarioBruto>
          	and ca.CPtipo    = 0 <!---Nomina Normal--->
          </cfif>
	</cfquery>
	
	<cfreturn rsIGSS.monto>
</cffunction>
--->--->