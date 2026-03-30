<cfparam name="modo" default="ALTA">
<cfparam name="Form.OPtablaMayor" default="T,None"><!--- T/C Tabla/Constante --->
<cfif ListGetAt(form.OPtablaMayor,1) IS 'T'>
	<cfset Form.OPtablaMayor = ListGetAt(form.OPtablaMayor,2)>
	<cfset Form.OPconst = ''>
<cfelse>
	<cfset Form.OPconst = ListGetAt(form.OPtablaMayor,2)>
	<cfset Form.OPtablaMayor = ''>
</cfif>
<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfquery name="RSQuerys" datasource="#Session.DSN#">
				insert INTO OrigenDocumentos (Ecodigo, Oorigen,OPtablaMayor,OPconst,ODactivo,BMUsucodigo)
				values(
					<cfqueryparam value="#Session.Ecodigo#" 	cfsqltype="cf_sql_integer">,
					<cfqueryparam value="#Form.Oorigen#" 		cfsqltype="cf_sql_char">,
					<cfqueryparam value="#Form.OPtablaMayor#" 	cfsqltype="cf_sql_varchar">,
					<cfqueryparam value="#Form.OPconst#"    	cfsqltype="cf_sql_varchar">,
					<cfif  isdefined("Form.ODactivo")>
						1,
					<cfelse>
						0,
					</cfif>
					<cfqueryparam value="#session.Usucodigo#" 	cfsqltype="cf_sql_numeric">
					)
			</cfquery>	
			<cfset modo="CAMBIO">
		<cfelseif isdefined("Form.Baja")>
			<cfquery name="RSQuerys" datasource="#Session.DSN#">
				delete from OrigenNivelProv
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Oorigen = <cfqueryparam value="#Form.Oorigen#" cfsqltype="cf_sql_char">
			</cfquery>	
			<cfquery name="RSQuerys" datasource="#Session.DSN#">
				delete from OrigenCtaMayor
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Oorigen = <cfqueryparam value="#Form.Oorigen#" cfsqltype="cf_sql_char">
			</cfquery> 					
			<cfquery name="RSQuerys" datasource="#Session.DSN#">
				delete from OrigenDocumentos
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and Oorigen = <cfqueryparam value="#Form.Oorigen#" cfsqltype="cf_sql_char">
			</cfquery>	
		  <cfset modo="ALTA">
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="RSQuerys" datasource="#Session.DSN#">
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="OrigenDocumentos" 
					redirect="lista_origenes.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo,integer,#session.Ecodigo#"
					field2="Oorigen,char,#form.Oorigen#">
					
					update OrigenDocumentos set
					OPtablaMayor = <cfqueryparam value="#Form.OPtablaMayor#" 	cfsqltype="cf_sql_varchar">,
					ODactivo =  <cfif  isdefined("Form.ODactivo")> 1<cfelse> 0 </cfif>,
                    OPconst = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.OPconst#" null="#Len(Form.OPconst) is 0#">
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
					and Oorigen = <cfqueryparam value="#Form.Oorigen#" cfsqltype="cf_sql_char">
				</cfquery> 
			  <cfset modo="CAMBIO">
		</cfif>
</cfif>

<form action="lista_origenes.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo neq 'ALTA'>
		<input name="Oorigen" type="hidden" value="<cfif isdefined("Form.Oorigen")>#Form.Oorigen#</cfif>">
	</cfif>
</cfoutput>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

