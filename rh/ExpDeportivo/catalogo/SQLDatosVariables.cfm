<!--- <cf_dump var="#form#"> --->

<cfparam name="action" default="DatosVariables.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.Alta")>
			<cfquery name="EDDcupInsert" datasource="#session.DSN#">
				insert into EDDatosVariables ( EDDcodigo, EDDdescripcion, EDUid, BMfechaalta, BMUsucodigo, EDDtipopintado )
				values ( <cfqueryparam value="#form.EDDcodigo#"       cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#form.EDDdescripcion#"  cfsqltype="cf_sql_varchar">,
						 <cfqueryparam value="#form.EDUnidades#"  		  cfsqltype="cf_sql_numeric">,
						 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,			
						 <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Tipo#">)
						 
			 <cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#session.DSN#" name="EDDcupInsert">
			<cfset modo = 'CAMBIO'>
		<cfelseif isdefined("form.Cambio")>
			<cfquery name="EDUcupUpdate" datasource="#session.DSN#">
				update EDDatosVariables
				set 
				EDDcodigo		 = <cfqueryparam value="#form.EDDcodigo#"       cfsqltype="cf_sql_char">,
				EDDtipopintado = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.Tipo#">,
				EDDdescripcion	 = <cfqueryparam value="#form.EDDdescripcion#"  cfsqltype="cf_sql_varchar">,
				EDUid 			 =  <cfqueryparam value="#form.EDUnidades#"  		  cfsqltype="cf_sql_numeric">
								
				where EDDid      =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDDid#">
			</cfquery>  
			<cfset modo = 'CAMBIO'>
			
		<cfelseif isdefined("form.Baja")>
			<cfquery name="EDUcupDelete" datasource="#session.DSN#">
				delete EDDatosVariables
				where EDDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDDid#">
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
		<cfset LEDDid = "">
		<cfif isdefined("form.EDDid") and len(trim(form.EDDid)) gt 0>
			<cfset LEDDid = form.EDDid>
		<cfelseif isdefined("EDDcupInsert.identity") and len(trim(EDDcupInsert.identity)) gt 0>
			<cfset LEDDid = EDDcupInsert.identity>
		</cfif>
		<input name="EDDid" type="hidden" value="#LEDDid#">
	
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
</HTML>﻿