<cfset modo = 'ALTA'>
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>

	<cfif isdefined("Form.COItemClave")>  <!---Obtengo el Id del Item para insertarlo---->
        <cfquery name="rsItemId" datasource="#Session.DSN#">
		  Select COItemId from COItemsSigepro
		    where 
			COItemClave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.COItemClave#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>  
	</cfif>	 
	   
      	<cfquery name="rsAlta" datasource="#Session.DSN#">
			insert into COItemsCotizacion (CMPid, COItemId, DClinea, DSlinea, COItemCCantidad, COItemCPrecio, COItemCFecha, Ecodigo, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ICCproceso#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsItemId.COItemId#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ICClineaCot#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ICClinea#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#Form.ICCantidad#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Form.ICCprecio#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(now(),"yyyy-mm-dd")#">,				
     			<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">							
			)			
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("btnBaja") or isdefined("Form.Baja")>	  
		<cfquery name="rsBaja" datasource="#Session.DSN#">
			delete from COItemsCotizacion
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and COItemCId = <cfqueryparam value="#form.ItemCId#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset modo="BAJA">
	<cfelseif isdefined("Form.Cambio")>
	    <cfquery name="rsItemId" datasource="#Session.DSN#">
		  Select COItemId from COItemsSigepro
		    where 
			COItemClave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.COItemClave#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>  
		<!---<cf_dump var="#form#">--->
		<cfquery name="rsCambio" datasource="#Session.DSN#">
				update COItemsCotizacion set
					COItemId = <cfqueryparam value="#rsItemId.COItemId#" cfsqltype="cf_sql_numeric">,
					COItemCCantidad = <cfqueryparam value="#Form.ICCantidad#" cfsqltype="cf_sql_float">,
					COItemCPrecio = <cfqueryparam value="#Form.ICCprecio#" cfsqltype="cf_sql_money">,
					COItemCFecha = <cfqueryparam value="#DateFormat(now(),"yyyy-mm-dd")#" cfsqltype="cf_sql_date">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and COItemCId = <cfqueryparam value="#form.ItemCId#" cfsqltype="cf_sql_numeric">
			</cfquery>				
		<cfset modo="ALTA">
	</cfif>
</cfif>


<cfif isdefined("Form.ICCproceso") and len(trim(Form.ICCproceso)) gt 0>
	<cfset LvarProceso=	#Form.ICCproceso#>
<cfelseif isdefined("url.proceso") and len(trim(url.proceso)) gt 0>		
    <cfset LvarProceso= #url.proceso#> 
</cfif>
<cfif isdefined("Form.ICCsolicitud") and len(trim(Form.ICCsolicitud)) gt 0>
    <cfset LvarSolicitud = #Form.ICCsolicitud#>
<cfelseif isdefined("url.solicitud") and len(trim(url.solicitud)) gt 0>
    <cfset LvarSolicitud = #url.solicitud#>
</cfif>
<cfif isdefined("Form.ICClinea") and len(trim(Form.ICClinea)) gt 0>
   <cfset LvarLinea=  #Form.ICClinea#>
<cfelseif isdefined("url.linea") and len(trim(url.linea)) gt 0>
        <cfset LvarLinea = #url.linea#>
</cfif>

<cfif isdefined("Form.ICClineaCot") and len(trim(Form.ICClineaCot)) gt 0>
   <cfset LvarLineaCot=  #Form.ICClineaCot#>
<cfelseif isdefined("url.lineaCot") and len(trim(url.lineaCot)) gt 0>
        <cfset LvarLineaCot = #url.lineaCot#>
</cfif>



<form action="CotizacionItems.cfm?proceso=<cfoutput>#LvarProceso#</cfoutput>&solicitud=<cfoutput>#LvarSolicitud#</cfoutput>&lineaSolic=<cfoutput>#LvarLinea#</cfoutput>&lineaCot=<cfoutput>#LvarLineaCot#</cfoutput>" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="proceso" type="hidden" value="#LvarProceso#">
	<input name="solicitud" type="hidden" value="#LvarSolicitud#">
	<input name="linea" type="hidden" value="#LvarLinea#">
	<input name="tipo" type="hidden" value="I">	

</cfoutput>		
</form>

<html>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</html>