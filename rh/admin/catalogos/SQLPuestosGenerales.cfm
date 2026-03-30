<cfparam name="action" default="PuestosGenerales.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
<cftransaction>
	<cftry>
			<cfif isdefined("form.Alta")>
				<cfquery name="ABC_Puestos_insert" datasource="#session.DSN#">
					insert into RHECatalogosGenerales ( Ecodigo, RHECGcodigo, RHECGdescripcion,RHHFid,RHHSFid,RHECgrado, BMusuario, BMfecha)
								 values ( <cfqueryparam	cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
										  <cfqueryparam	cfsqltype="cf_sql_char" value="#ucase(trim(form.RHECGcodigo))#">,
										  <cfqueryparam	cfsqltype="cf_sql_varchar" value="#form.RHECGdescripcion#">,
										  <cfqueryparam	cfsqltype="cf_sql_numeric" value="#form.RHHFid#" null="#LEN(TRIM(form.RHHFid)) eq 0#">,
										  <cfqueryparam	cfsqltype="cf_sql_numeric" value="#form.RHHSFid#" null="#LEN(TRIM(form.RHHFid)) eq 0#">,
										  <cfqueryparam	cfsqltype="cf_sql_numeric" value="#form.RHECgrado#" null="#LEN(TRIM(form.RHECgrado)) eq 0#">,
										  <cfqueryparam	cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
										  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
										)
					 <cf_dbidentity1 datasource="#session.DSN#">
				</cfquery>		
				<cf_dbidentity2 datasource="#session.DSN#" name="ABC_Puestos_insert">
				
			<cfset modo = 'CAMBIO'>
				
			<cfelseif isdefined("form.Cambio")>
				<cf_dbtimestamp
				 datasource="#session.dsn#"
				 table="RHECatalogosGenerales"
				 redirect="PuestosGenerales.cfm"
				 timestamp="#form.ts_rversion#"
				 field1="RHECGid" type1 = "numeric" value1="#form.RHECGid#" 
				 field2="Ecodigo" type2="numeric" value2="#session.Ecodigo#">
				<cfquery name="ABC_Puestos_update" datasource="#session.DSN#">
					update RHECatalogosGenerales
					set RHECGcodigo  	 = <cfqueryparam cfsqltype="cf_sql_char" value="#ucase(trim(form.RHECGcodigo))#">,
						RHECGdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.RHECGdescripcion#">,
						BMusumod 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						RHHFid 		 	 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHFid#" null="#LEN(TRIM(form.RHHFid)) EQ 0#">,
						RHHSFid 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHHSFid#" null="#LEN(TRIM(form.RHHSFid)) EQ 0#">,
						RHECgrado 		 = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHECgrado#" null="#LEN(TRIM(form.RHECgrado)) EQ 0#">,
						BMfechamod 		 = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and RHECGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHECGid#">
				</cfquery>				  
			  <cfset modo = 'CAMBIO'>
				  
			<cfelseif isdefined("form.Baja")>
				<cfquery name="ABC_Puestos_deleteA" datasource="#session.DSN#">			
					delete from RHDCatalogosGenerales
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHECGid =  <cfqueryparam value="#form.RHECGid#" cfsqltype="cf_sql_numeric">
				</cfquery>

				<cfquery name="ABC_Puestos_deleteB" datasource="#session.DSN#">							
					delete from RHECatalogosGenerales
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHECGid =  <cfqueryparam value="#form.RHECGid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				
			<cfelseif isdefined("form.btnDetalleUpd") and len(trim(RHDCGid)) eq 0><!--- Alta Detalle--->
				<cf_dbtimestamp
					 datasource="#session.dsn#"
					 table="RHECatalogosGenerales"
					 redirect="PuestosGenerales.cfm"
					 timestamp="#form.ts_rversion#"
					 field1="RHECGid" type1 = "numeric" value1="#form.RHECGid#" 
					 field2="Ecodigo" type2="numeric" value2="#session.Ecodigo#">
				<cfquery name="ABC_Puestos_updateAD1" datasource="#session.DSN#">							
					update RHECatalogosGenerales
					set RHECGdescripcion = <cfqueryparam value="#form.RHECGdescripcion#" cfsqltype="cf_sql_varchar">,
					BMusumod = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					BMfechamod = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"> 
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHECGid =  <cfqueryparam value="#form.RHECGid#" cfsqltype="cf_sql_numeric">
				</cfquery>

				<cfquery name="ABC_Puestos_updateAD2" datasource="#session.DSN#">							
					insert into RHDCatalogosGenerales ( Ecodigo, RHECGid,  RHDCGcodigo, RHDCGdescripcion, BMusuario, BMfecha)
					values 	( <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
							  <cfqueryparam value="#form.RHECGid#" cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#ucase(trim(form.RHDCGcodigo))#"	cfsqltype="cf_sql_char">,
							  <cfqueryparam value="#form.RHDCGdescripcion#"	cfsqltype="cf_sql_varchar">,
							  <cfqueryparam value="#session.Usucodigo#"	cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
							)
				</cfquery>				
			  <cfset modo = 'CAMBIO'>
				
			<cfelseif isdefined("form.btnDetalleUpd") and len(trim(RHDCGid)) gt 0><!--- Cambio Detalle--->
				<cf_dbtimestamp
				 datasource="#session.dsn#"
				 table="RHECatalogosGenerales"
				 redirect="PuestosGenerales.cfm"
				 timestamp="#form.ts_rversion#"
				 field1="RHECGid" type1 = "numeric" value1="#form.RHECGid#" 
				 field2="Ecodigo" type2="numeric" value2="#session.Ecodigo#">
				<cfquery name="ABC_Puestos_updateCD1" datasource="#session.DSN#">										
					update RHECatalogosGenerales
					set RHECGcodigo = <cfqueryparam value="#ucase(trim(form.RHECGcodigo))#"		cfsqltype="cf_sql_char">,				
					RHECGdescripcion = <cfqueryparam value="#form.RHECGdescripcion#"    cfsqltype="cf_sql_varchar">,
					BMusumod = <cfqueryparam value="#session.Usucodigo#"		cfsqltype="cf_sql_numeric">,
					BMfechamod = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHECGid =  <cfqueryparam value="#form.RHECGid#" cfsqltype="cf_sql_numeric">
				</cfquery>

				<cfquery name="rsCuenta2" datasource="#Session.DSN#">
				select RHECGcodigo, RHECGdescripcion, BMusumod, BMfechamod
				from RHECatalogosGenerales
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  and RHECGid =  <cfqueryparam value="#form.RHECGid#" cfsqltype="cf_sql_numeric">				
				</cfquery>
				
				<cfif rsCuenta2.RecordCount GT 0>
				<cfquery name="ABC_Puestos_updateCD2" datasource="#session.DSN#">
<!--- *****************************************************************************REVISAR PORQUE DA ERROR AL USAR CON 3 FIELDS****** --->			
<!---						<cf_dbtimestamp
						 datasource="#session.dsn#"
						 table="RHECatalogosGenerales"
						 redirect="PuestosGenerales.cfm"
						 timestamp="#form.ts_rversion#"
						 field1="RHECGid" type1 = "numeric" value1="#form.RHECGid#" 
						 field2="Ecodigo" type2="numeric" value2="#session.Ecodigo#"
 						 field3="RHDCGid" type3="numeric" value3="#form.RHDCGid#">--->
						 
					update RHDCatalogosGenerales
					set RHDCGcodigo = <cfqueryparam value="#ucase(trim(form.RHDCGcodigo))#"		cfsqltype="cf_sql_char">,				
					RHDCGdescripcion = <cfqueryparam value="#form.RHDCGdescripcion#"    cfsqltype="cf_sql_varchar">,
					BMusumod = <cfqueryparam value="#session.Usucodigo#"		cfsqltype="cf_sql_numeric">,
					BMfechamod = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHECGid =  <cfqueryparam value="#form.RHECGid#" cfsqltype="cf_sql_numeric">
					  and RHDCGid =  <cfqueryparam value="#form.RHDCGid#" cfsqltype="cf_sql_numeric"><!---#form.RHDCGid#--->
				</cfquery>
			  <cfset modo = 'CAMBIO'>
				</cfif>			
				
			<cfelseif isdefined("form.borrarDetalle") and len(trim(borrarDetalle)) gt 0><!--- Baja Detalle--->
				<cfquery name="ABC_Puestos_deleteBD" datasource="#session.DSN#">
					delete from RHDCatalogosGenerales
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					  and RHECGid =  <cfqueryparam value="#form.RHECGid#" cfsqltype="cf_sql_numeric">
					  and RHDCGid =  <cfqueryparam value="#form.RHDCGid#" cfsqltype="cf_sql_numeric">
				</cfquery>	  
			  <cfset modo = 'CAMBIO'>
			</cfif>

	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cftransaction>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'>
		<cfset LRHECGid = "">
		<cfif isdefined("form.RHECGid") and len(trim(form.RHECGid)) gt 0>
			<cfset LRHECGid = form.RHECGid>
		<cfelseif isdefined("ABC_Puestos_insert.identity") and len(trim(ABC_Puestos_insert.identity)) gt 0>
			<cfset LRHECGid = ABC_Puestos_insert.identity>
		</cfif>
		<input name="RHECGid" type="hidden" value="#LRHECGid#">
	
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
