<cfif not isdefined("form.modo")>
	<cfset modo="ALTA">
</cfif>

<!--- Consultas --->
<cfquery name="rsMonedas" datasource="#session.DSN#">
	select
		A.Mcodigo,
		A.Mnombre,
		A.Msimbolo
	from Monedas A
	where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> 
	  and A.Mcodigo not in
	  	(select Mcodigo 
		  from RHMonedas 
		  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">)
</cfquery>

<script src="/cfmx/sif/js/qForms/qforms.js"></script> 
<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
	function validar(f){
		f.obj.Mcodigo.disabled = false;
		return true;
	}
	
	function deshabilitarValidacion() {
		objForm.Mcodigo.required = false;
	}
</script>

<form name="form1" method="post" action="SQLRH_monedas.cfm">
<cfoutput>
	<table width="100%" border="0" cellspacing="1" cellpadding="1">	
		<tr>
			<td colspan="3" class="tituloAlterno"><div align="center"><cfif modo eq 'ALTA'><strong><cf_translate key="LB_NuevaMoneda">Nueva Moneda</cf_translate></cfif></div></td>
		</tr>	  
		<tr>
			<td width="45%" align="right"><cf_translate key="LB_Moneda">Moneda</cf_translate>:</td>
			<cfif modo eq 'ALTA'>
				<td colspan="2">
					<select name="Mcodigo" tabindex="1">
						<cfloop query="rsMonedas">
							<option value="#rsMonedas.Mcodigo#">#rsMonedas.Mnombre#</option>
						</cfloop>
					</select>
					<input type="hidden" name="modo" value="ALTA">		
				</td>
			<cfelse>
				<input type="hidden" name="Eliminable" value="<cfif isdefined("rsForm.Eliminable")>#rsForm.Eliminable#</cfif>">
				<input type="hidden" name="MSLocal" value="<cfif isdefined("rsForm.MCLocal")>#rsForm.MCLocal#</cfif>">				
			</cfif>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td width="6%">&nbsp;</td>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Agregar"
			Default="Agregar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Agregar"/>

			
			<td width="49%"><input type="submit" name="alta" value="<cfoutput>#BTN_Agregar#</cfoutput>"></td>
		</tr>	  
	</table>
</cfoutput>
</form>

<script language="JavaScript1.2" type="text/javascript">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Moneda"
	Default="Moneda"
	returnvariable="LB_Moneda"/>	
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	objForm.Mcodigo.required = true;
	objForm.Mcodigo.description="<cfoutput>#LB_Moneda#</cfoutput>";
</script>