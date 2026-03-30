<cfif isdefined("url.RCNid") and not isdefined("form.RCNid")>	
	<cfset form.RCNid = url.RCNid >
</cfif>

<cfif isdefined("url.DEid") and not isdefined("form.DEid")>	
	<cfset form.DEid = url.DEid >
</cfif>

<cfif isdefined("url.Tcodigo") and not isdefined("form.Tcodigo")>	
	<cfset form.Tcodigo = url.Tcodigo >
</cfif>

<!--- Consultas --->
<!--- Monedas --->
<cfquery name="rsMoneda" datasource="#Session.DSN#">
	select Miso4217, Msimbolo 
	from Monedas a, RCalculoNomina b, TiposNomina c 
	where b.Tcodigo = c.Tcodigo and a.Mcodigo = c.Mcodigo and b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
</cfquery>
<cfquery name="rsSE" datasource="#Session.DSN#">
	select SEcalculado
	from SalarioEmpleado 
	where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RCNid#">
	and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>

<!--- JavaScript --->
<script language="JavaScript1.2" type="text/javascript">
	var popUpWin=0;

	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+',top='+top+',screenX='+left+',screenY='+top);
	}
</script>

<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<cf_templatecss>
<cf_templatecss>

<style type="text/css">
.tituloAlterno2 {
	font-weight: bolder;
	text-align: center;
	vertical-align: middle;

	padding: 2px;
	background-color: #DFDFDF;
}

</style>

<cf_sifHTML2Word>
<table width="97%" >
<tr bgcolor="#EEEEEE" style="padding: 3px;"><td align="center"><font size="3"><b>
	Reporte de Pagos en Proceso
</b></font></td></tr>
</table>

<cfinclude template="/rh/portlets/pEmpleado.cfm">
<table width="97%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;" align="center">
  <tr>
	<td nowrap colspan="10" align="center" class="<cfoutput> #Session.Preferences.Skin#_thcenter</cfoutput>"><font size="2">Informaci&oacute;n Resumida</font></td>
  </tr>
  <tr><td colspan="10"><cfinclude template="frame-PSalarioEmpleado.cfm"><!--- Información Resumida ---></td></tr>
</table>
<form action="<cfoutput>#Url.Regresar#</cfoutput>" method="post" name="form1">
  <table width="97%" border="0" cellspacing="0" cellpadding="0" class="sectionTitle" style="padding-left: 5px; padding-right: 5px;" align="center">
    <tr> 
      <td nowrap colspan="10" align="center" class="<cfoutput> #Session.Preferences.Skin#_thcenter</cfoutput>"><font size="2">Informaci&oacute;n Detallada</font></td>
    </tr>
    <cfinclude template="frame-PPagosEmpleado.cfm"></td>
    <!--- Salarios --->

    <tr valign="top"> 
      <td nowrap colspan="10">&nbsp;</td>
    </tr>
    <cfinclude template="frame-PIncidenciasCalculo.cfm"></td>
    <!--- Incidencias --->

    <tr valign="top"> 
      <td nowrap colspan="10">&nbsp;</td>
    </tr>
    <cfinclude template="frame-PCargasCalculo.cfm"></td>
    <!--- Cargas --->

    <tr valign="top"> 
      <td nowrap colspan="10">&nbsp;</td>
    </tr>
    <cfinclude template="frame-PDeduccionesCalculo.cfm"></td>
	
    <tr valign="top"> 
      <td nowrap colspan="10">&nbsp;</td>
    </tr>

    <cfoutput> 

	  <cfif not isdefined("url.Archivo")>
		  <tr valign="top"> 
			<td nowrap colspan="10" align="center">
			  
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="Regresar"
				Default="Regresar"
				XmlFile="/sif/rh/generales.xml"
				returnvariable="Regresar"/>			  
			  <input type="button" name="Regresar" value="#Regresar#" onClick="javascript: regresar();"> 
			</td>
		  </tr>
	  </cfif> 

      <tr valign="top"> 
        <td nowrap colspan="10" align="center">
			<input name="Tcodigo" type="hidden" value="#Url.Tcodigo#">
			<input name="fecha" type="hidden" value="#Url.fecha#">
			<input name="butFiltrar" type="hidden" value="Filtrar">
			<input name="RCNid" type="hidden" value="#Url.RCNid#">
        </td>
      </tr>
	  <tr><td>&nbsp;</td></tr>
	  
    </cfoutput> 
  </table>
</form>
</cf_sifHTML2Word>
