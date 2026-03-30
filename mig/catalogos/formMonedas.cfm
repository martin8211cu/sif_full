<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 9-3-2006.
		Motivo: Se corrige la navegación del form de la pantalla por tabs para que tenga un orden lógico.
 --->
 <cfif isdefined("Form.Cambio")>
	<cfset form.modo="CAMBIO">
	<cfset modo="CAMBIO">
</cfif>
<cfif not isdefined("Form.modo")>
	<cfset form.modo="ALTA">
	<cfset modo="ALTA">
<cfelseif Form.modo EQ "CAMBIO">
	<cfset form.modo="CAMBIO">
	<cfset modo="CAMBIO">
<cfelse>
	<cfset form.modo="ALTA">
	<cfset modo="ALTA">
</cfif>


<cfif isDefined("Session.Ecodigo") and isDefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo)) NEQ 0 >
	<cfquery name="rsMIGMonedas" datasource="#Session.DSN#" >
		Select Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion
		from MIGMonedas
		where Ecodigo = #Session.Ecodigo#
			and Mcodigo = #Form.Mcodigo#
			order by Mnombre
	</cfquery>
</cfif>

<cfquery name="rsMIGMonedasPortal" datasource="asp" >
	Select Mcodigo, Mnombre, Msimbolo, Miso4217	
	from Moneda
	order by Mnombre
</cfquery>

<!---<SCRIPT SRC="../../sif/js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--//
// specify the path where the "/qforms/" subfolder is located
qFormAPI.setLibraryPath("../../js/qForms/");
// loads all default libraries
qFormAPI.include("*");
//qFormAPI.include("validation");
//qFormAPI.include("functions", null, "12");
//-->
</SCRIPT>--->

<script language="JavaScript1.2" type="text/javascript">
	function cargarDatos(dato) {
		<cfloop query="rsMIGMonedasPortal">
			if (dato == "<cfoutput>#rsMIGMonedasPortal.Mcodigo#</cfoutput>") {
				document.form1.Mnombre.value = "<cfoutput>#JSStringFormat(rsMIGMonedasPortal.Mnombre)#</cfoutput>";
				document.form1.Msimbolo.value = "<cfoutput>#JSStringFormat(rsMIGMonedasPortal.Msimbolo)#</cfoutput>";
				document.form1.Miso4217.value = "<cfoutput>#JSStringFormat(rsMIGMonedasPortal.Miso4217)#</cfoutput>";				
			}
		</cfloop>	
	}
</script>

<form method="post" name="form1" action="SQLMonedas.cfm" onSubmit="return validar(this);">
  
  <table align="center">
    <tr valign="baseline"> 
      <td nowrap align="right">Moneda:</td>
      <td>
	  <cfif modo NEQ "ALTA">
	  	<cfoutput>
		<cfset longitud = Len(Trim(rsMIGMonedas.Mnombre)) >
	  	<input name="Mnombre" tabindex="1" type="text" value="#htmlEditFormat(Trim(rsMIGMonedas.Mnombre))#" size="#longitud#" maxlength="80" readonly>
		<input name="Mcodigo" type="hidden" value="#htmlEditFormat(rsMIGMonedas.Mcodigo)#" tabindex="-1">
		</cfoutput>
	  <cfelse>
		  <select name="Mcodigos" onChange="javascript:cargarDatos(this.value);" tabindex="1">
  			  <cfoutput query="rsMIGMonedasPortal"> 
				<option value="#rsMIGMonedasPortal.Mcodigo#">#rsMIGMonedasPortal.Mnombre#</option>
			  </cfoutput>	  	  	  
		  </select>
		<input name="Mnombre" type="hidden" tabindex="-1" value="<cfoutput>#htmlEditFormat(rsMIGMonedasPortal.Mnombre)#</cfoutput>">
	  </cfif>
	  </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Símbolo:</td>
      <td><input name="Msimbolo" <cfif modo NEQ "ALTA">disabled="disabled"</cfif> type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#htmlEditFormat(rsMIGMonedas.Msimbolo)#</cfoutput><cfelse><cfoutput>#htmlEditFormat(rsMIGMonedasPortal.Msimbolo)#</cfoutput></cfif>" size="3" maxlength="3"></td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Sigla:</td>
      <td><input name="Miso4217" type="text" <cfif modo NEQ "ALTA">disabled="disabled"</cfif> tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#htmlEditFormat(rsMIGMonedas.Miso4217)#</cfoutput><cfelse><cfoutput>#htmlEditFormat(rsMIGMonedasPortal.Miso4217)#</cfoutput></cfif>" size="3" maxlength="3"></td>
    </tr>
    <tr> 
		<td colspan="2" align="center" nowrap><cf_botones modo="#modo#" exclude="Cambio"tabindex="1"></td>
	</tr>

	<tr>
		<td align="center" colspan="2">
			<table width="75%" align="center" class="ayuda">
				<tr><td><p>Las MIGMonedas definidas por este cat&aacute;logo las podr&aacute; utilizar su empresa al generar documentos, registros de pago etc.</p></td></tr>
			</table>
		</td>
	</tr>

  </table>
	<cfset ts = "">
	  <cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsMIGMonedas.ts_rversion#"/>
		</cfinvoke>
	</cfif>  
  <input type="hidden" name="ts_rversion" tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
</form>
<!---ValidacionesFormulario--->

<script type="text/javascript">
function validar(formulario)	{
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('Lista',document.form1) ){
		var error_input;
		var error_msg = '';
		Codigo = document.form1.Msimbolo.value; 
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,""); 
		if (Codigo.length==0){
			error_msg += "\n - El simbolo de la Moneda no puede quedar en blanco.";
			error_input = formulario.Msimbolo;
		}
		desp = document.form1.Miso4217.value; 
		desp = desp.replace(/(^\s*)|(\s*$)/g,""); 
		if (desp.length==0){
			error_msg += "\n - El MISO de la Moneda no puede quedar en blanco.";
			error_input = formulario.Miso4217;
		}
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>

<!---<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.Msimbolo.required = true;
	objForm.Msimbolo.description="Símbolo";		
	objForm.Miso4217.required= true;
	objForm.Miso4217.description="Sigla";			
</script>--->


