
<cfparam name="action" default="listavalores.cfm">
<cfparam name="modo" default="ALTA">
	
<cfif not isdefined("form.btnNuevo")>
<cftransaction>
	<cftry>

			<!---set nocount on--->

			<cfif isdefined("form.Alta")>
				<cfquery name="ABC_Puestos_insert" datasource="#Session.DSN#">
					insert into EDDatosVariables (EDUid, EDDcodigo, EDDdescripcion, BMUsucodigo, EDDtipopintado, BMfechaalta)
								 values ( <cfqueryparam value="#form.EDUnidades#"		cfsqltype="cf_sql_numeric">,
								 		  <cfqueryparam value="#ucase(trim(form.EDDcodigo))#"		cfsqltype="cf_sql_char">,
										  <cfqueryparam value="#form.EDDdescripcion#"	cfsqltype="cf_sql_varchar">,
										  <cfqueryparam value="#session.Usucodigo#"		cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#form.Tipo#" cfsqltype="cf_sql_numeric">,
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
						 table="EDDatosVariables"
						 redirect="listavalores.cfm"
						 timestamp="#form.ts_rversion#"
						 field1="EDDid" type1 = "numeric" value1="#form.EDDid#">

					update EDDatosVariables
					set EDDcodigo = <cfqueryparam value="#ucase(trim(form.EDDcodigo))#"		cfsqltype="cf_sql_char">,
					EDUid = <cfqueryparam value="#form.EDUnidades#"		cfsqltype="cf_sql_numeric">,
					EDDdescripcion = <cfqueryparam value="#form.EDDdescripcion#"    cfsqltype="cf_sql_varchar">,
					BMUsucodigo = <cfqueryparam value="#session.Usucodigo#"		cfsqltype="cf_sql_numeric">,
					BMfechaalta = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!---getdate()--->
					where EDDid =  <cfqueryparam value="#form.EDDid#" cfsqltype="cf_sql_numeric">
				</cfquery>				  
			  <cfset modo = 'CAMBIO'>
				  
			<cfelseif isdefined("form.Baja")>
	
				<cfquery name="ABC_Puestos_deleteA" datasource="#Session.DSN#">			
					delete EDListaValores
					where EDDid =  <cfqueryparam value="#form.EDDid#" cfsqltype="cf_sql_numeric">
				</cfquery>

				<cfquery name="ABC_Puestos_deleteB" datasource="#Session.DSN#">							
					delete EDDatosVariables
					where EDDid =  <cfqueryparam value="#form.EDDid#" cfsqltype="cf_sql_numeric">
				</cfquery>
		
			<cfelseif isdefined("form.btnDetalleUpd") and len(trim(EDLVid)) eq 0><!--- Alta Detalle--->
				
					<cfquery name="ABC_Puestos_updateAD1" datasource="#Session.DSN#">							
						 <cf_dbtimestamp
						 datasource="#Session.DSN#"
						 table="EDDatosVariables"
						 redirect="listavalores.cfm"
						 timestamp="#form.ts_rversion#"
						 field1="EDDid" type1 = "numeric" value1="#form.EDDid#">

					update EDDatosVariables
					set EDDdescripcion = <cfqueryparam value="#form.EDDdescripcion#" cfsqltype="cf_sql_varchar">,
					EDUid = <cfqueryparam value="#form.EDUnidades#"		cfsqltype="cf_sql_numeric">,
					BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					BMfechaalta = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"> <!---getdate()--->
					where EDDid =  <cfqueryparam value="#form.EDDid#" cfsqltype="cf_sql_numeric">
							
				</cfquery>

				<cfquery name="ABC_Puestos_updateAD2" datasource="#Session.DSN#">							
					insert into EDListaValores (EDDid,  EDLVcodigo, EDLVdescripcion, BMUsucodigo, BMfalta)
					values 	( <cfqueryparam value="#form.EDDid#" cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#ucase(trim(form.EDLVcodigo))#"	cfsqltype="cf_sql_char">,
							  <cfqueryparam value="#form.EDLVdescripcion#"	cfsqltype="cf_sql_varchar">,
							  <cfqueryparam value="#session.Usucodigo#"	cfsqltype="cf_sql_numeric">,
							  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!---getdate()--->
							)
				</cfquery>				
			  <cfset modo = 'CAMBIO'>
				
			<cfelseif isdefined("form.btnDetalleUpd") and len(trim(EDLVid)) gt 0><!--- Cambio Detalle--->
				<cfquery name="ABC_Puestos_updateCD1" datasource="#Session.DSN#">										
						<cf_dbtimestamp
						 datasource="#Session.DSN#"
						 table="EDDatosVariables"
						 redirect="listavalores.cfm"
						 timestamp="#form.ts_rversion#"
						 field1="EDDid" type1 = "numeric" value1="#form.EDDid#">

					update EDDatosVariables
					set EDDcodigo = <cfqueryparam value="#ucase(trim(form.EDDcodigo))#"		cfsqltype="cf_sql_char">,
					EDUid = <cfqueryparam value="#form.EDUnidades#"		cfsqltype="cf_sql_numeric">,				
					EDDdescripcion = <cfqueryparam value="#form.EDDdescripcion#"    cfsqltype="cf_sql_varchar">,
					BMUsucodigo = <cfqueryparam value="#session.Usucodigo#"		cfsqltype="cf_sql_numeric">,
					BMfechaalta = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!---getdate()--->
					where EDDid =  <cfqueryparam value="#form.EDDid#" cfsqltype="cf_sql_numeric">
				</cfquery>

				<cfquery name="rsCuenta2" datasource="#Session.DSN#">
				select EDDtipopintado, EDUid, EDDcodigo, EDDdescripcion, BMUsucodigo, BMfechaalta
				from EDDatosVariables
				where EDDid =  <cfqueryparam value="#form.EDDid#" cfsqltype="cf_sql_numeric">				
				</cfquery>
				
				<cfif rsCuenta2.RecordCount GT 0>
				<cfquery name="ABC_Puestos_updateCD2" datasource="#Session.DSN#">
					<!--- 	<cf_dbtimestamp
						 datasource="#session.dsn#"
						 table="EDListaValores"
						 redirect="listavalores.cfm"
						 timestamp="#form.ts_rversion#"
						 field1="EDDid" type1 = "numeric" value1="#form.EDDid#" > --->
						 
						 
					update EDListaValores
					set EDLVcodigo = <cfqueryparam value="#ucase(trim(form.EDLVcodigo))#"		cfsqltype="cf_sql_char">,				
					EDLVdescripcion = <cfqueryparam value="#form.EDLVdescripcion#"    cfsqltype="cf_sql_varchar">,
					BMUsucodigo = <cfqueryparam value="#session.Usucodigo#"		cfsqltype="cf_sql_numeric">,
					BMfalta = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!---getdate()--->
					where EDDid =  <cfqueryparam value="#form.EDDid#" cfsqltype="cf_sql_numeric">
					  and EDLVid =  <cfqueryparam value="#form.EDLVid#" cfsqltype="cf_sql_numeric"><!---#form.EDLVid#--->
				</cfquery>
			  <cfset modo = 'CAMBIO'>
				</cfif>			
				
			<cfelseif isdefined("form.borrarDetalle") and len(trim(borrarDetalle)) gt 0><!--- Baja Detalle--->
				<cfquery name="ABC_Puestos_deleteBD" datasource="#Session.DSN#">
					delete EDListaValores
					where EDDid =  <cfqueryparam value="#form.EDDid#" cfsqltype="cf_sql_numeric">
					  and EDLVid =  <cfqueryparam value="#form.EDLVid#" cfsqltype="cf_sql_numeric">
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
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'>
		<cfset LEDDid = "">
		<cfif isdefined("form.EDDid") and len(trim(form.EDDid)) gt 0>
			<cfset LEDDid = form.EDDid>
		<cfelseif isdefined("ABC_Puestos_insert.identity") and len(trim(ABC_Puestos_insert.identity)) gt 0>
			<cfset LEDDid = ABC_Puestos_insert.identity>
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
</HTML>