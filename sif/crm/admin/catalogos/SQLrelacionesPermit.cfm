<cfparam name="action" default="relacionesPermit.cfm">
<cfparam name="modo" default="ALTA">
<cfif not isdefined("form.btnNuevo")>
	<cftry>
	    <!---AGREGAR--->
		<cfif isdefined("form.Alta")>
			<cfquery datasource="#session.DSN#">
				insert CRMRelacionesPermitidas 
				(CRMTRid, CRMTEid1, CRMTEid2, CEcodigo, Ecodigo, CRMRPdescripcion1, CRMRPdescripcion2)
				values (
					<cfqueryparam value="#form.CRMTRid#" 		   cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#form.CRMTEid1#" 		   cfsqltype="cf_sql_numeric">,					
					<cfqueryparam value="#form.CRMTEid2#" 		   cfsqltype="cf_sql_numeric">,
					<cfqueryparam value="#session.CEcodigo#" 	   cfsqltype="cf_sql_numeric">, 
					<cfqueryparam value="#session.Ecodigo#" 	   cfsqltype="cf_sql_integer">, 
					<cfqueryparam value="#form.CRMRPdescripcion1#" cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#form.CRMRPdescripcion2#" cfsqltype="cf_sql_varchar">
				)
			   </cfquery>
		<!---MODIFICAR--->
		<cfelseif isdefined("form.Cambio")>	
			<cfquery datasource="#session.DSN#">
				update CRMRelacionesPermitidas
					set CRMRPdescripcion1 = <cfqueryparam value="#form.CRMRPdescripcion1#" cfsqltype="cf_sql_varchar">,
						CRMRPdescripcion2 = <cfqueryparam value="#form.CRMRPdescripcion2#" cfsqltype="cf_sql_varchar">
				where CRMTRid =  	<cfqueryparam value="#form.CRMTRid#" 		cfsqltype="cf_sql_numeric">
					and CRMTEid1 =  <cfqueryparam value="#form.CRMTEid1#" 		cfsqltype="cf_sql_numeric">
					and CRMTEid2 =  <cfqueryparam value="#form.CRMTEid2#" 		cfsqltype="cf_sql_numeric">					
					and CEcodigo=	<cfqueryparam value="#session.CEcodigo#" 	cfsqltype="cf_sql_numeric">
					and Ecodigo=	<cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">					
					and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
			  </cfquery>
			  <cfset modo = 'CAMBIO'>
		<!---ELIMINAR--->
		<cfelseif isdefined("form.Baja")>
			<cfquery datasource="#session.DSN#">
				delete from CRMRelacionesPermitidas
				where CRMTRid =  	<cfqueryparam value="#form.CRMTRid#" 		cfsqltype="cf_sql_numeric">
					and CRMTEid1 =  <cfqueryparam value="#form.CRMTEid1#" 		cfsqltype="cf_sql_numeric">
					and CRMTEid2 =  <cfqueryparam value="#form.CRMTEid2#" 		cfsqltype="cf_sql_numeric">									
					and CEcodigo=	<cfqueryparam value="#session.CEcodigo#" 	cfsqltype="cf_sql_numeric">
					and Ecodigo=	<cfqueryparam value="#session.Ecodigo#" 	cfsqltype="cf_sql_integer">
			</cfquery>
		</cfif>		
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'>
		<input name="CRMTRid" type="hidden" value="#form.CRMTRid#">
		<input name="CRMTEid1" type="hidden" value="#form.CRMTEid1#">		
		<input name="CRMTEid2" type="hidden" value="#form.CRMTEid2#">		
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>