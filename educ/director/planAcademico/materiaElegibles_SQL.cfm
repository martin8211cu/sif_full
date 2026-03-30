<cfset modo = "CAMBIO">

	<cftry>
		<cfif isdefined("Form.btnAgregarEleg") and form.btnAgregarEleg EQ 1>
			<cfquery name="A_MatElegibles" datasource="#Session.DSN#">
				set nocount on
					insert MateriaElegible (Mcodigo, McodigoElegible)
					values (
						<cfqueryparam value="#form.Mcodigo#" cfsqltype="cf_sql_numeric">
						, <cfqueryparam value="#form.McodigoElegible#" cfsqltype="cf_sql_numeric">
					)
				set nocount off
			</cfquery>
		<cfelseif isdefined("Form.btnBorrarEleg") and form.btnBorrarEleg EQ 1>
			<cfquery name="B_MatElegibles" datasource="#Session.DSN#">
				set nocount on			
					delete MateriaElegible
					where Mcodigo = <cfqueryparam value="#Form.Mcodigo#"   cfsqltype="cf_sql_numeric">
						and McodigoElegible = <cfqueryparam value="#Form.IdElegBorrar#"   cfsqltype="cf_sql_numeric">						
				set nocount off	
			</cfquery>
		<cfelseif isdefined("Form.btnAsignarEC")>
			<cfquery name="C_Materia" datasource="#Session.DSN#">
				set nocount on			
					update Materia set
					<cfif isdefined('form.McodigoElectivaComun') and form.McodigoElectivaComun NEQ ''>
						McodigoElectivaComun=<cfqueryparam value="#form.McodigoElectivaComun#" cfsqltype="cf_sql_numeric">
					<cfelse>
						McodigoElectivaComun=null					
					</cfif>					
					where Ecodigo   = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_numeric">
					  and Mcodigo  = <cfqueryparam value="#Form.Mcodigo#" cfsqltype="cf_sql_numeric">
					  and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
				set nocount off	
			</cfquery>										
		</cfif>
	<cfcatch type="any">
		<cfinclude template="/educ/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>

<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
	<cfset fAction = "CarrerasPlanes.cfm">
	<cfset modo = "MPcambio">
<cfelse>
	<cfset fAction = "materia.cfm">	
</cfif>

<form action="<cfoutput>#fAction#</cfoutput>" method="post" name="sql">
	<cfoutput>
		<!--- Parametros del mantenimiento de Materia Plan --->
		<cfif isdefined('form.PEScodigo') and form.PEScodigo NEQ ''>
			<input name="PEScodigo" type="hidden" value="#form.PEScodigo#">
		</cfif>
		<cfif isdefined('form.PVEsecuencia') and form.PVEsecuencia NEQ ''>
			<input name="PVEsecuencia" type="hidden" value="#form.PVEsecuencia#">
		</cfif>
		<cfif isdefined('form.CILcodigo') and form.CILcodigo NEQ ''>
			<input name="CILcodigo" type="hidden" value="#form.CILcodigo#">
		</cfif>
		<cfif isdefined('form.PBLsecuencia') and form.PBLsecuencia NEQ ''>
			<input name="PBLsecuencia" type="hidden" value="#form.PBLsecuencia#">
		</cfif>
		<input name="nivel" type="hidden" value="2">  
		 <!--- ********************************* --->
	
		<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
		<input name="Mcodigo" type="hidden" value="<cfif isdefined("Form.Mcodigo") and modo NEQ 'ALTA'>#Form.Mcodigo#</cfif>">
		<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">	
		<input name="T" type="hidden" value="<cfif isdefined("form.Mtipo") and form.Mtipo NEQ ''>#form.Mtipo#<cfelse>M</cfif>">		
	</cfoutput>	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>