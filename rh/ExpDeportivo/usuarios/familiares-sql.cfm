
<cfparam name="modo" default="ALTA">
<cfif not isdefined("form.borrarDetalle")>
<cfquery name="rsExisteEmpleado" datasource="#Session.DSN#"> 
		select 1
		from EDParentesco
		where EDPfamiliar = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> and
		DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fDEid#">
	
		</cfquery>
			
		<cfif rsExisteEmpleado.recordCount GT 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_ElFamiliarYaExiste"
				Default="El EFamiliar ya existe"
				returnvariable="MSG_ElFamiliarYaExiste"/>
			<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?errType=0&errMsg=#MSG_ElFamiliarYaExiste#." addtoken="no">
			<cfabort> 
		</cfif>
</cfif>	
<cfif not isdefined("form.btnNuevo")>
<cftransaction>
	<cftry>

			<!---set nocount on--->
			<cfif isdefined("form.Alta")>
				<cfquery name="ABC_Puestos_insert" datasource="#Session.DSN#">
					insert into EDParentesco (DEid, EDPparentesco, EDPfamiliar, BMUsucodigo, BMfalta)
								 values ( 
								 		  <cfqueryparam value="#form.fDEid#"	cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#form.EDPparentesco#"	cfsqltype="cf_sql_varchar">,
										  <cfqueryparam value="#form.DEid#" cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!---getdate()--->
										)
					
					<!---select id = @@identity--->
					<cf_dbidentity1 datasource="#Session.DSN#">
				</cfquery>	
				<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_Puestos_insert">	
				<cfset Parentesco = form.EDPparentesco>
				<cfif form.EDPparentesco eq 5>
				 <cfset Parentesco = 7>
				<cfelseif form.EDPparentesco eq 6>
				<cfset Parentesco = 8>
				<cfelseif form.EDPparentesco eq 7>
				<cfset Parentesco = 5>
				<cfelseif form.EDPparentesco eq 8>
				<cfset Parentesco = 6>
				</cfif>
				
				<cfquery name="insert_familiar" datasource="#Session.DSN#">
					insert into EDParentesco (DEid, EDPparentesco, EDPfamiliar, BMUsucodigo, BMfalta)
								 values ( 
								 		  <cfqueryparam value="#form.DEid#" cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#Parentesco#"	cfsqltype="cf_sql_varchar">,
										  <cfqueryparam value="#form.fDEid#"	cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!---getdate()--->
										)
				</cfquery>	
													
			<cfset modo = 'CAMBIO'>
		
			<cfelseif isdefined("form.Cambio")>
		
				<cfquery name="ABC_Puestos_update" datasource="#Session.DSN#">
						 <cf_dbtimestamp
						 datasource="#Session.DSN#"
						 table="EDParentesco"
						 redirect="familiares.cfm"
						 timestamp="#form.ts_rversion#"
						 field1="EDPaid" type1 = "numeric" value1="#form.EDPaid#">

					update EDParentesco
					set EDPfamiliar = <cfqueryparam value="#form.EDPfamiliar#"		cfsqltype="cf_sql_numeric">,
					EDPparentesco = <cfqueryparam value="#form.EDPparentesco#"    cfsqltype="cf_sql_varchar">
					where EDPaid =  <cfqueryparam value="#form.EDPaid#" cfsqltype="cf_sql_numeric">
				</cfquery>			
				
				<cfquery name="ABC_Puestos_update2" datasource="#Session.DSN#">
					update EDParentesco
					set DEid = <cfqueryparam value="#form.EDPfamiliar#"		cfsqltype="cf_sql_numeric">,
					EDPparentesco = <cfqueryparam value="#form.EDPparentesco#"    cfsqltype="cf_sql_varchar">
					where EDPfamiliar =  <cfqueryparam value="#form.fDEid#" cfsqltype="cf_sql_numeric"> and
					DEid = <cfqueryparam value="#form.EDPfamiliar#" cfsqltype="cf_sql_numeric">
				</cfquery>		  
			  <cfset modo = 'CAMBIO'>
				  		
				
			<cfelseif isdefined("form.borrarDetalle") and len(trim(borrarDetalle)) gt 0><!--- Baja Detalle--->
				<cfquery name="ABC_Puestos_deleteBA" datasource="#Session.DSN#">
					delete EDParentesco
					where EDPaid = <cfqueryparam value="#form.EDPaid#" cfsqltype="cf_sql_numeric"> 
				</cfquery>	  
				<cfquery name="ABC_Puestos_deleteBB" datasource="#Session.DSN#">
					delete EDParentesco
					where DEid = <cfqueryparam value="#form.fDEid#" cfsqltype="cf_sql_numeric">
					and EDPaid = <cfqueryparam value="#form.EDPaid#" cfsqltype="cf_sql_numeric">
				</cfquery>

				<cfquery name="ABC_Puestos_deleteBC" datasource="#Session.DSN#">
					delete EDParentesco
					where DEid = <cfqueryparam value="#form.EDPfamiliar#" cfsqltype="cf_sql_numeric">
					and EDPfamiliar = <cfqueryparam value="#form.fDEid#" cfsqltype="cf_sql_numeric">
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
<form action="familiares.cfm" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined('form.fDEid')><input name="DEid" type="hidden" value="#form.fDEid#"><cfelse><input name="DEid" type="hidden" value="#form.fDEid#"></cfif>
</form>
</cfoutput>
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
