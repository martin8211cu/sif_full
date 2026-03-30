<cfparam name="modo" default="ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta") and len(trim(form.Alta))>
		<cfquery name="RSQuerys" datasource="#Session.DSN#">
			insert INTO OrigenCtaMayor (Ecodigo, Oorigen,Cmayor,BMUsucodigo)
			values(
				<cfqueryparam value="#Session.Ecodigo#" 	cfsqltype="cf_sql_integer">,
				<cfqueryparam value="#Form.Oorigen#" 		cfsqltype="cf_sql_char">,
				<cfqueryparam value="#Form.Cmayor#" 		cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#session.Usucodigo#" 	cfsqltype="cf_sql_numeric">
				)
		</cfquery>	
		<cfset modo="CAMBIO">
	<cfelseif isdefined("Form.Baja") and len(trim(form.Baja))>
		<cfquery name="RSQuerys" datasource="#Session.DSN#">
			delete from OrigenNivelProv
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and Oorigen = <cfqueryparam value="#Form.Oorigen#" cfsqltype="cf_sql_char">
			and Cmayor = <cfqueryparam value="#Form.Cmayor#" cfsqltype="cf_sql_char">
		</cfquery>	
		<cfquery name="RSQuerys" datasource="#Session.DSN#">
			delete from OrigenCtaMayor
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and Oorigen = <cfqueryparam value="#Form.Oorigen#" cfsqltype="cf_sql_char">
			and Cmayor = <cfqueryparam value="#Form.Cmayor#" cfsqltype="cf_sql_char">
		</cfquery>  
		<cfset modo="ALTA">
	<cfelseif isdefined("Form.Cambio") and len(trim(form.Cambio))>
		<cfquery name="rsNiveles" datasource="#Session.DSN#">
			select OPtabla 
			from OrigenNivelProv
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Oorigen   =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Oorigen#">
			and Cmayor     = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
			order by OPnivel
		</cfquery>
		<cfset Cant_Niveles = Form.Cant_Niveles>
		   <cfloop from="1" to ="#Cant_Niveles#" index="i">
			<cfset OPtablaNivel = Form['OPtablaMayor_#i#']><!--- T,tabla/C,constante/F Tabla/Constante/Fijo en OPconst_#i# --->

            <cfif ListGetAt(OPtablaNivel,1) IS 'T'>
                <cfset OPtablaNivel = ListGetAt(OPtablaNivel,2)>
                <cfset OPconstNivel = ''>
            <cfelseif ListGetAt(OPtablaNivel,1) IS 'C'>
                <cfset OPconstNivel = ListGetAt(OPtablaNivel,2)>
                <cfset OPtablaNivel = ''>
            <cfelse> <!--- 'F' --->
                <cfset OPconstNivel = Form['OPconst_#i#']>
                <cfset OPtablaNivel = ''>
            </cfif>

			<cfif rsNiveles.recordcount eq 0>
				<cfquery name="insNiveles" datasource="#Session.DSN#">
					insert into OrigenNivelProv (
					Ecodigo,
					Oorigen,
					Cmayor,
					OPnivel,
					OPtabla,
					OPconst,
					BMUsucodigo)
					values (
						<cfqueryparam value="#Session.Ecodigo#" 	cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#Form.Oorigen#" 		cfsqltype="cf_sql_char">,
						<cfqueryparam value="#Form.Cmayor#" 		cfsqltype="cf_sql_varchar">,
						<cfqueryparam value="#i#" 					cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#OPtablaNivel#" 		cfsqltype="cf_sql_varchar">	,
						<cfqueryparam value="#OPconstNivel#" 		cfsqltype="cf_sql_varchar">	,
						<cfqueryparam value="#session.Usucodigo#" 	cfsqltype="cf_sql_numeric">
					)				
				</cfquery>
			<cfelse>
				<cfquery name="insNiveles" datasource="#Session.DSN#">
					update OrigenNivelProv
					set OPtabla = <cfqueryparam value="#OPtablaNivel#"	cfsqltype="cf_sql_varchar">,
					    OPconst = <cfqueryparam value="#OPconstNivel#"	cfsqltype="cf_sql_varchar" null="#Len(OPconstNivel) is 0#">,
					    BMUsucodigo = <cfqueryparam value="#session.Usucodigo#" 			cfsqltype="cf_sql_numeric">
					where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and Oorigen    =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.Oorigen#">
					and Cmayor     = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Cmayor#">
					and OPnivel    = <cfqueryparam cfsqltype="cf_sql_integer" value="#i#">
				</cfquery>
			</cfif>	
        </cfloop>
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<form action="Ctas_origenes.cfm" method="post" name="sql">
<cfoutput>
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined("modo2")>
		<input name="modo2" type="hidden" value="#modo2#">
		</cfif>
	<input name="Oorigen" type="hidden" value="<cfif isdefined("Form.Oorigen")>#Form.Oorigen#</cfif>">
	<cfif modo neq 'ALTA'>
		<input name="Cmayor" type="hidden"  value="<cfif isdefined("Form.Cmayor")>#Form.Cmayor#</cfif>">
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

