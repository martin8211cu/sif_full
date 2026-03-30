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
		Select convert(varchar,Mcodigo) as Mcodigo, Mnombre, Msimbolo, Miso4217, timestamp
		from Monedas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Mcodigo#" >		  
			order by Mnombre
	</cfquery>
</cfif>

<cfquery name="rsMonedasPortal" datasource="sdc" >
	Select convert(varchar,Mcodigo) as Mcodigo, Mnombre, Msimbolo, Miso4217	
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
	  	<input type="text" name="Mnombre" value="#Trim(rsMonedas.Mnombre)#" size="#longitud#" readonly>					
		<input name="Mcodigo" type="hidden" value="#rsMonedas.Mcodigo#">
		</cfoutput>
	  <cfelse>
		  <select name="Mcodigos" onChange="javascript:cargarDatos(this.value);">
  			  <cfoutput query="rsMonedasPortal"> 
				<option value="#rsMonedasPortal.Mcodigo#">#rsMonedasPortal.Mnombre#</option>
			  </cfoutput>	  	  	  
		  </select>
		<input name="Mnombre" type="hidden" value="<cfoutput>#rsMonedasPortal.Mnombre#</cfoutput>">
	  </cfif>
	  </td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Símbolo:</td>
      <td><input type="text" name="Msimbolo" value="<cfif modo NEQ "ALTA"><cfoutput>#rsMonedas.Msimbolo#</cfoutput><cfelse><cfoutput>#rsMonedasPortal.Msimbolo#</cfoutput></cfif>" size="3"></td>
    </tr>
    <tr valign="baseline"> 
      <td nowrap align="right">Sigla:</td>
      <td><input type="text" name="Miso4217" value="<cfif modo NEQ "ALTA"><cfoutput>#rsMonedas.Miso4217#</cfoutput><cfelse><cfoutput>#rsMonedasPortal.Miso4217#</cfoutput></cfif>" size="3"></td>
    </tr>
    <tr valign="baseline"> 
      <td colspan="2" align="right" nowrap><cfinclude template="../../portlets/pBotones.cfm"></td>
    </tr>
  </table>
	<cfset ts = "">
	  <cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsMonedas.timestamp#"/>
		</cfinvoke>
	</cfif>  
  <input type="hidden" name="timestamp" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
</form>

<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.Msimbolo.required = true;
	objForm.Msimbolo.description="Símbolo";		
	objForm.Miso4217.required= true;
	objForm.Miso4217.description="Sigla";			
</script>



