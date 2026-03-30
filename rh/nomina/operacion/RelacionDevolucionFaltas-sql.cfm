<!---<cf_dump var = "#form#">--->
<cfif isdefined ('btnAgregar')>
    <!---Validacion para revisar que la falta se realizo en ese periodo--->
	<cfquery name="rsValidaFalta" datasource="#session.DSN#">
    	select DLlinea,a.RHTid
        from DLaboralesEmpleado a 
			inner join RHTipoAccion b on b.RHTid = a.RHTid 
			and a.Ecodigo = b.Ecodigo
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and DLfvigencia = '#LSDateFormat(form.fechaDesde,'yyyymmdd')#'
			and DLffin = '#LSDateFormat(form.fechaHasta,'yyyymmdd')#'
			and RHTcomportam = 13
			and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
    </cfquery>
    
    <cfif isdefined('rsValidaFalta') and rsValidaFalta.RecordCount EQ 0>
    	<cfinclude template="RelacionDevolucionFaltas-form.cfm">
    	<script type="text/javascript">
			alert("No existe una falta en ese rango de Fechas");
		</script>
    </cfif>
    <!---Validacion para revisar que la falta se realizo en ese periodo--->
    
    <!---Validar si ya se regreso la falta de acuerdo al rango de la fecha--->
    <cfquery name="rsValidaFaltaR" datasource="#session.DSN#">
    	select 1 validacion
		from RHDevolucionFaltas
		where RHDFfechadesde = '#LSDateFormat(form.fechaDesde,'yyyymmdd')#'
		and RHDFfechahasta = '#LSDateFormat(form.fechaHasta,'yyyymmdd')#'
		and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
    </cfquery>  
    
    <cfif isdefined('rsValidaFaltaR') and rsValidaFaltaR.validacion EQ 1>
    	<cfinclude template="RelacionDevolucionFaltas-form.cfm">
    	<script type="text/javascript">
			alert("Ya se captur\u00f3 la falta en ese rango de Fechas");
		</script>
    </cfif>
    
    <!---Validar si ya se regreso la falta de acuerdo al rango de la fecha--->
    
    <cfif rsValidaFalta.RecordCount GT 0 and rsValidaFaltaR.RecordCount EQ 0>
    	<cfquery datasource="#session.DSN#">
    		insert into RHDevolucionFaltas(DLlinea,DEid,RHTid,RHDFdescripcion,RHDFfechadesde,RHDFfechahasta,RHDFfechaaplica,RHDFcantdias)
       		values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsValidaFalta.DLlinea#">,
        	   <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
        	   <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsValidaFalta.RHTid#">,
               <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DFdescripcion#">,
               '#LSDateFormat(form.fechaDesde,'yyyymmdd')#',
               '#LSDateFormat(form.fechaHasta,'yyyymmdd')#',
               <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
               <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DFdias#">)   
    	</cfquery>
        <cflocation url="RelacionDevolucionFaltas-form.cfm?DEid=#form.DEid#" addtoken="yes"> 
    </cfif>
</cfif>

<cfif isdefined('btnEliminar')>
	<cfquery datasource = "#session.DSN#">
    	delete from RHDevolucionFaltas
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		and RHDFid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.RHDFid#">
    </cfquery>
    <cflocation url="RelacionDevolucionFaltas-form.cfm?DEid=#form.DEid#" addtoken="yes"> 
</cfif>