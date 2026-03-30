<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo NEQ "ALTA">
	<cfquery name="rsTipoVentaPerdida" datasource="#Session.DSN#">
		Select Ecodigo, VPid ,VPnombre, ts_rversion
		from TipoVentaPerdida
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and VPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.VPid#">	
	</cfquery>
</cfif>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<script language="JavaScript" type="text/JavaScript">
	function validar(){
 		var numero = new Number(document.form1.VPnombre.value);
		if (numero == 0){
			alert('La Descripcion es requerida!');
			document.form1.VPnombre.focus();
			return false
		}
	}
</script>
<form action="VentaPerdida_SQL.cfm" method="post" name="form1" onSubmit="javascript: return validar(); ">
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td align="right" nowrap>Descripción:&nbsp;</td>
    <td nowrap><input name="VPnombre" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#JSStringFormat(rsTipoVentaPerdida.VPnombre)#</cfoutput></cfif>" size="30" maxlength="30"></td>
  </tr>
  <tr>
  	<td nowrap colspan="2">
		<cfif modo NEQ "ALTA">
			<cfset ts = "">	
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsTipoVentaPerdida.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<cfif modo NEQ "ALTA">
			<cfoutput>
				<input type="hidden" name="VPid" value="#rsTipoVentaPerdida.VPid#">
				<input type="hidden" name="ts_rversion" value="#ts#">
			</cfoutput>
		</cfif>
	</td>
  </tr>
</table>
<table width="100%" border="0" cellspacing="0" cellpadding="0">
 	<tr>
		<td>&nbsp;</td>
	</tr>
  <tr>
  	<td nowrap align="center">
		<cf_botones modo="#modo#" Regresar="/cfmx/sif/fa/MenuFA.cfm">
	</td>
  </tr>
</table>
</form>

<!-- Texto para las validaciones -->
<script language="JavaScript1.1">
	document.form1.VPnombre.alt = "El campo descripción"
</script>