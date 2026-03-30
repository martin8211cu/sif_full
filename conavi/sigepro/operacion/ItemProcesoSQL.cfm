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
      <cfif Form.IPCcantidad eq 0 or Form.IPCprecio eq 0 >
	     <cfthrow message="EL precio o la cantidad no pueden ser cero!">
	  </cfif>

		<cfquery name="rsAlta" datasource="#Session.DSN#">
			insert into COItemsProceso (CMPid, COItemId, DSlinea, COItemPCantidad, COItemPPrecio, COItemPFecha, Ecodigo, BMUsucodigo)
			values(
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IPCproceso#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsItemId.COItemId#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.IPClinea#">,
				<cfqueryparam cfsqltype="cf_sql_float" value="#Form.IPCcantidad#">,
				<cfqueryparam cfsqltype="cf_sql_money" value="#Form.IPCprecio#">,
				<cfqueryparam cfsqltype="cf_sql_date" value="#DateFormat(now(),"yyyy-mm-dd")#">,				
     			<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">							
			)			
		</cfquery>
		<cfset modo="ALTA">
	<cfelseif isdefined("btnBaja") or isdefined("Form.Baja")>	  
		<cfquery name="rsBaja" datasource="#Session.DSN#">
			delete from COItemsProceso
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and COItemPId = <cfqueryparam value="#form.ItemPId#" cfsqltype="cf_sql_numeric">
		</cfquery>
		<cfset modo="BAJA">
	<cfelseif isdefined("Form.Cambio")>
	    <cfquery name="rsItemId" datasource="#Session.DSN#">
		  Select COItemId from COItemsSigepro
		    where 
			COItemClave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.COItemClave#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		</cfquery>    
		<cfquery name="rsCambio" datasource="#Session.DSN#">
				update COItemsProceso set
					COItemId = <cfqueryparam value="#rsItemId.COItemId#" cfsqltype="cf_sql_numeric">,
					COItemPCantidad = <cfqueryparam value="#Form.IPCcantidad#" cfsqltype="cf_sql_float">,
					COItemPPrecio = <cfqueryparam value="#Form.IPCprecio#" cfsqltype="cf_sql_money">,
					COItemPFecha = <cfqueryparam value="#DateFormat(now(),"yyyy-mm-dd")#" cfsqltype="cf_sql_date">
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and COItemPId = <cfqueryparam value="#form.ItemPId#" cfsqltype="cf_sql_numeric">
			</cfquery>				
		<cfset modo="ALTA">
	</cfif>
</cfif>


<cfif isdefined("Form.IPCproceso") and len(trim(Form.IPCproceso)) gt 0>
	<cfset LvarProceso=	#Form.IPCproceso#>
<cfelseif isdefined("url.proceso") and len(trim(url.proceso)) gt 0>		
    <cfset LvarProceso= #url.proceso#> 
</cfif>
<cfif isdefined("Form.IPCsolicitud") and len(trim(Form.IPCsolicitud)) gt 0>
    <cfset LvarSolicitud = #Form.IPCsolicitud#>
<cfelseif isdefined("url.solicitud") and len(trim(url.solicitud)) gt 0>
    <cfset LvarSolicitud = #url.solicitud#>
</cfif>
<cfif isdefined("Form.IPClinea") and len(trim(Form.IPClinea)) gt 0>
   <cfset LvarLinea=  #Form.IPClinea#>
<cfelseif isdefined("url.linea") and len(trim(url.linea)) gt 0>
        <cfset LvarLinea = #url.linea#>
</cfif>
<!---<cfif isdefined("Form.IPClineaCot") and len(trim(Form.IPClineaCot)) gt 0>
   <cfset LvarLineaCot=  #Form.ICClineaCot#>
<cfelseif isdefined("url.lineaCot") and len(trim(url.lineaCot)) gt 0>
        <cfset LvarLineaCot = #url.lineaCot#>
</cfif>--->

<form action="ItemProceso.cfm?tipo=I&proceso=<cfoutput>#LvarProceso#</cfoutput>&solicitud=<cfoutput>#LvarSolicitud#</cfoutput>&linea=<cfoutput>#LvarLinea#</cfoutput><!---&lineaCot=<cfoutput>#LvarLineaCot#</cfoutput>--->" method="post" name="sql">
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
