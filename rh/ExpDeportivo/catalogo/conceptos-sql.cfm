
<cfparam name="modo" default="ALTA">
	
<cfif not isdefined("form.btnNuevo")>
<cftransaction>
	<cftry>

			<!---set nocount on--->
			<cfif isdefined("form.Alta")>
				<cfquery name="ABC_Puestos_insert" datasource="#Session.DSN#">
					insert into EDConceptoExp (EDCEcod, EDCEdescripcion, EDCEte, BMUsucodigo, BMfalta)
								 values ( 
								 		  <cfqueryparam value="#ucase(trim(form.EDCEcod))#"	cfsqltype="cf_sql_char">,
										  <cfqueryparam value="#form.EDCEdescripcion#"	cfsqltype="cf_sql_varchar">,
										  <cfqueryparam value="#form.EDCEte#" cfsqltype="cf_sql_char">,
										  <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!---getdate()--->
										)
					<!---select id = @@identity--->
					<cf_dbidentity1 datasource="#Session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_Puestos_insert">
				
												
			<cfset modo = 'CAMBIO'>
				
			<cfelseif isdefined("form.Cambio")>
		
				<cfquery name="ABC_Puestos_update" datasource="#Session.DSN#">
						 <cf_dbtimestamp
						 datasource="#Session.DSN#"
						 table="EDConceptoExp"
						 redirect="conceptos.cfm"
						 timestamp="#form.ts_rversion#"
						 field1="EDCEid" type1 = "numeric" value1="#form.EDCEid#">

					update EDConceptoExp
					set EDCEcod = <cfqueryparam value="#ucase(trim(form.EDCEcod))#"		cfsqltype="cf_sql_char">,
					EDCEte = <cfqueryparam value="#form.EDCEte#"    cfsqltype="cf_sql_char">,
					EDCEdescripcion = <cfqueryparam value="#form.EDCEdescripcion#"    cfsqltype="cf_sql_varchar">,
					BMUsucodigo = <cfqueryparam value="#session.Usucodigo#"		cfsqltype="cf_sql_numeric">,
					BMfalta = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!---getdate()--->
					where EDCEid =  <cfqueryparam value="#form.EDCEid#" cfsqltype="cf_sql_numeric">
				</cfquery>				  
			  <cfset modo = 'CAMBIO'>
				  
			<cfelseif isdefined("form.Baja")>

			<cfquery name="ABC_Puestos_deleteA" datasource="#Session.DSN#">			
					delete EDDetConcepto
					where EDCEid =  <cfqueryparam value="#form.EDCEid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				
				<cfquery name="ABC_Puestos_deleteB" datasource="#Session.DSN#">							
					delete EDConceptoExp
					where EDCEid =  <cfqueryparam value="#form.EDCEid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				
			<cfset modo = 'ALTA'>
		
				
			<cfelseif isdefined("form.btnDetalleUpd") and len(trim(EDDCid)) eq 0><!--- Alta Detalle--->
					
					<cfquery name="ABC_Puestos_updateAD1" datasource="#Session.DSN#">							
						 <cf_dbtimestamp
						 datasource="#Session.DSN#"
						 table="EDConceptoExp"
						 redirect="conceptos.cfm"
						 timestamp="#form.ts_rversion#"
						 field1="EDCEid" type1 = "numeric" value1="#form.EDCEid#">

					update EDConceptoExp
					set EDCEdescripcion = <cfqueryparam value="#form.EDCEdescripcion#" cfsqltype="cf_sql_varchar">,
					EDCEcod = <cfqueryparam value="#form.EDCEcod#"    cfsqltype="cf_sql_varchar">,
					EDCEte = <cfqueryparam value="#form.EDCEte#"    cfsqltype="cf_sql_char">,
					BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					BMfalta = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"> <!---getdate()--->
					where EDCEid =  <cfqueryparam value="#form.EDCEid#" cfsqltype="cf_sql_numeric">
							
				</cfquery>

				<cfquery name="ABC_Puestos_updateAD2" datasource="#Session.DSN#">							
					insert into EDDetConcepto (EDUid, EDCEid,  EDDCcodigo, EDDCdetalle, BMUsucodigo, BMfalta)
					values 	( <cfqueryparam value="#form.EDUid#" cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#form.EDCEid#" cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#ucase(trim(form.EDDCcodigo))#" cfsqltype="cf_sql_varchar">,
							  <cfqueryparam value="#form.EDDCdetalle#"	cfsqltype="cf_sql_varchar">,
							  <cfqueryparam value="#session.Usucodigo#"	cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!---getdate()--->
							)
				</cfquery>				
			  <cfset modo = 'CAMBIO'>
			
			<cfelseif isdefined("form.btnDetalleUpd") and len(trim(EDDCid)) gt 0><!--- Cambio Detalle--->
				
				<cfquery name="ABC_Puestos_updateCD1" datasource="#Session.DSN#">										
						<cf_dbtimestamp
						 datasource="#Session.DSN#"
						 table="EDConceptoExp"
						 redirect="conceptos.cfm"
						 timestamp="#form.ts_rversion#"
						 field1="EDCEid" type1 = "numeric" value1="#form.EDCEid#">

					update EDConceptoExp
					set EDCEcod = <cfqueryparam value="#ucase(trim(form.EDCEcod))#"		cfsqltype="cf_sql_char">,
					EDCEte = <cfqueryparam value="#form.EDCEte#"    cfsqltype="cf_sql_char">,
					EDCEdescripcion = <cfqueryparam value="#form.EDCEdescripcion#"    cfsqltype="cf_sql_varchar">,
					BMUsucodigo = <cfqueryparam value="#session.Usucodigo#"		cfsqltype="cf_sql_numeric">,
					BMfalta = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!---getdate()--->
					where EDCEid =  <cfqueryparam value="#form.EDCEid#" cfsqltype="cf_sql_numeric">
				</cfquery>

				<cfif form.btnDetalleUpd EQ 'Agregar' >
				<cfquery name="InsertDetalle" datasource="#Session.DSN#">
					insert into EDDetConcepto (EDUid, EDDCdetalle, EDDCcodigo, EDCEid, BMUsucodigo, BMfalta)
					values 	( <cfqueryparam value="#form.EDUid#" cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#form.EDDCdetalle#"	cfsqltype="cf_sql_varchar">,
							  <cfqueryparam value="#ucase(trim(form.EDDCcodigo))#" cfsqltype="cf_sql_varchar">,	
							  <cfqueryparam value="#form.EDCEid#" cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#session.Usucodigo#"	cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!---getdate()--->
							  )
				</cfquery>
					 <cfset modo = 'CAMBIO'>
				<cfelseif form.btnDetalleUpd EQ 'Modificar'>
				<cfquery name="ABC_Puestos_updateCD2" datasource="#Session.DSN#">
					<!---<cf_dbtimestamp
						 datasource="#session.dsn#"
						 table="EDDetConcepto"
						 redirect="conceptos.cfm"
						 timestamp="#form.ts_rversion#"
						 field1="EDDCid" type1 = "numeric" value1="#form.EDDCid#" > 
						 --->
			 
					update EDDetConcepto
					set     
					EDDCcodigo = <cfqueryparam value="#ucase(trim(form.EDDCcodigo))#"	cfsqltype="cf_sql_varchar">,
					EDDCdetalle= <cfqueryparam value="#form.EDDCdetalle#" cfsqltype="cf_sql_varchar">,
					BMUsucodigo= <cfqueryparam value="#session.Usucodigo#"	cfsqltype="cf_sql_numeric">,
					BMfalta = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">,
					EDUid = <cfqueryparam value="#form.EDUid#" cfsqltype="cf_sql_numeric">
					where EDDCid = <cfqueryparam value="#form.EDDCid#" cfsqltype="cf_sql_numeric"> and
					EDCEid = <cfqueryparam value="#form.EDCEid#" cfsqltype="cf_sql_numeric">
				 
				</cfquery>
			  <cfset modo = 'CAMBIO'>
				</cfif>			
				
			<cfelseif isdefined("form.borrarDetalle") and len(trim(borrarDetalle)) gt 0><!--- Baja Detalle--->
				<cfquery name="ABC_Puestos_deleteBD" datasource="#Session.DSN#">
					delete EDDetConcepto
					where EDDCid = <cfqueryparam value="#form.EDDCid#" cfsqltype="cf_sql_numeric"> and
					EDCEid = <cfqueryparam value="#form.EDCEid#" cfsqltype="cf_sql_numeric">
				</cfquery>	  
			  <cfset modo = 'CAMBIO'>
			</cfif>

<!---		set nocount off --->
<!---		</cfquery>--->
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cftransaction>
</cfif>
 <cfoutput>
<form action="conceptos.cfm" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined('form.EDCEid')><input name="EDCEid" type="hidden" value="#form.EDCEid#"><cfelse><input name="EDCEid" type="hidden" value="#ABC_Puestos_insert.identity#"></cfif>
</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>