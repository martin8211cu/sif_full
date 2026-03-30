<cfif isdefined("form.ALTA")>
	<!--- darse cuenta si existe el encabezado para modificarlo o insertarlo --->
	<cfquery name="data" datasource="#session.DSN#">
		select 1
		from RHComisionMonge
		where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	</cfquery>
	<cfif data.RecordCount eq 0>
		<cfquery datasource="#session.DSN#" >
			insert into RHComisionMonge(DEid, CPid, RHCMmontobase,BMUsucodigo)
			values (  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">,
				   	    <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.RHCMmontobase,',','','ALL')#">,
					    <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
		</cfquery>	
	<cfelse>
		<cfquery datasource="#session.DSN#">
			update RHComisionMonge
			set RHCMmontobase = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.RHCMmontobase,',','','ALL')#">
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
		</cfquery>
	</cfif>
	
	<cfquery datasource="#session.DSN#">
		insert into RHComisionMongeD(DEid, CPid, CIid, CIcodigo, RHCMmontocomision, Usucodigo, fechaalta )
		values (  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">,
					 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">,
				     <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">,
				     <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CIcodigo#">,
				     <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.RHCMmontocomision,',','','ALL')#">,
				     <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
			         <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				)
	</cfquery>
	
	<!--- insertar detalle --->
<cfelseif isdefined("form.CAMBIO")>
	<cfquery datasource="#session.DSN#">
		update RHComisionMonge
		set RHCMmontobase = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.RHCMmontobase,',','','ALL')#">
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
	</cfquery>
	
	<cfquery datasource="#session.DSN#">
		update RHComisionMongeD
		set CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CIid#">, 
		    CIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CIcodigo#">, 
			RHCMmontocomision = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.RHCMmontocomision,',','','ALL')#">
		where RHCDid = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCDid#"> 
	</cfquery>
<cfelseif isdefined("form.BAJA")>
	<cfquery datasource="#session.DSN#">
		delete RHComisionMongeD
		where RHCDid = 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCDid#"> 
	</cfquery>
	
	<cfquery name="data" datasource="#session.DSN#">
		select 1 
		from RHComisionMongeD
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
		  and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
	</cfquery>

	<!--- borrar encabezado solo si no hay mas detalles asociados--->
	<cfif data.RecordCount eq 0>
		<cfquery datasource="#session.DSN#">
			delete RHComisionMonge
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			  and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
		</cfquery>
	</cfif>
</cfif>

<cfoutput>

<form method="post" action="ResultadoCalculo-comisiones.cfm">
	<input type="hidden" name="CPid" value="#form.CPid#">
	<!---<input type="hidden" name="Pagina" value="#form.pagina#">--->
</form>
<html><head></head><body><script type="text/javascript" language="javascript1.2">document.forms[0].submit();</script></body></html>


<!---
<cflocation url="ResultadoCalculo-comisiones.cfm?CPid=#form.CPid#&Pagina=#form.Pagina#">
--->
</cfoutput>
