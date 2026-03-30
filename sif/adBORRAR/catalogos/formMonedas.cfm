<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 9-3-2006.
		Motivo: Se corrige la navegación del form de la pantalla por tabs para que tenga un orden lógico.
 --->
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

<cfif isDefined("Session.Ecodigo") and isDefined("Form.Mcodigo") and Len(Trim(Form.Mcodigo)) NEQ 0 >
	<cfquery name="rsMonedas" datasource="#Session.DSN#" >
		Select Mcodigo, Mnombre, Msimbolo, Miso4217, ts_rversion
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#" >		  
			order by Mnombre
	</cfquery>
</cfif>

<cfquery name="rsMonedasPortal" datasource="asp" >
	Select Mcodigo, Mnombre, Msimbolo, Miso4217	
	from Moneda
	order by Mnombre
</cfquery>

<SCRIPT SRC="../../js/qForms/qforms.js"></SCRIPT>
<SCRIPT LANGUAGE="JavaScript">
<!--//
// specify the path where the "/qforms/" subfolder is located
qFormAPI.setLibraryPath("../../js/qForms/");
// loads all default libraries
qFormAPI.include("*");
//qFormAPI.include("validation");
//qFormAPI.include("functions", null, "12");
//-->
</SCRIPT>

<script language="JavaScript1.2" type="text/javascript">
	function cargarDatos(dato) {
		<cfloop query="rsMonedasPortal">
			if (dato == "<cfoutput>#rsMonedasPortal.Mcodigo#</cfoutput>") {
				document.form1.Mnombre.value = "<cfoutput>#JSStringFormat(rsMonedasPortal.Mnombre)#</cfoutput>";
				document.form1.Msimbolo.value = "<cfoutput>#JSStringFormat(rsMonedasPortal.Msimbolo)#</cfoutput>";
				document.form1.Miso4217.value = "<cfoutput>#JSStringFormat(rsMonedasPortal.Miso4217)#</cfoutput>";				
			}
		</cfloop>	
	}
</script>

<form method="post" name="form1" action="SQLMonedas.cfm">
  
  <table align="center">
    <tr valign="baseline"> 
      <td nowrap align="right">Moneda:</td>
      <td>
	  <cfif modo NEQ "ALTA">
	  	<cfoutput>
		<cfset longitud = Len(Trim(rsMonedas.Mnombre)) >
	  	<input name="Mnombre" tabindex="1" type="text" value="#Trim(rsMonedas.Mnombre)#" size="#longitud#" maxlength="80" readonly>
		<input name="Mcodigo" type="hidden" value="#rsMonedas.Mcodigo#" tabindex="-1">
		</cfoutput>
	  <cfelse>
		  <select name="Mcodigos" onChange="javascript:cargarDatos(this.value);" tabindex="1">
  			  <cfoutput query="rsMonedasPortal"> 
				<option value="#rsMonedasPortal.Mcodigo#">#rsMonedasPortal.Mnombre#</option>
			  </cfoutput>	  	  	  
		  </select>
		<input name="Mnombre" type="hidden" tabindex="-1" value="<cfoutput>#rsMonedasPortal.Mnombre#</cfoutput>">
	  </cfif>
	  </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Símbolo:</td>
      <td><input name="Msimbolo" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsMonedas.Msimbolo#</cfoutput><cfelse><cfoutput>#rsMonedasPortal.Msimbolo#</cfoutput></cfif>" size="3" maxlength="3"></td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Sigla:</td>
      <td><input name="Miso4217" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#rsMonedas.Miso4217#</cfoutput><cfelse><cfoutput>#rsMonedasPortal.Miso4217#</cfoutput></cfif>" size="3" maxlength="3"></td>
    </tr>
    <tr valign="baseline"> 
      <td colspan="2" align="center" nowrap><cfset tabindex = 2><cfinclude template="../../portlets/pBotones.cfm"></td>
    </tr>

	<tr>
		<td align="center" colspan="2">
			<table width="75%" align="center" class="ayuda">
				<tr><td><p>Las monedas definidas por este cat&aacute;logo las podr&aacute; utilizar su empresa al generar documentos, registros de pago etc.</p></td></tr>
			</table>
		</td>
	</tr>

  </table>
	<cfset ts = "">
	  <cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsMonedas.ts_rversion#"/>
		</cfinvoke>
	</cfif>  
  <input type="hidden" name="ts_rversion" tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
</form>

<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.Msimbolo.required = true;
	objForm.Msimbolo.description="Símbolo";		
	objForm.Miso4217.required= true;
	objForm.Miso4217.description="Sigla";			
</script>


