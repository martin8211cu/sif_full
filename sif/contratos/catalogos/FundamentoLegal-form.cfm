 <!--- <cf_dump var="#Form#"> --->

<!--- JMRV. 14/08/2014 --->

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cgo" Default= "C&oacute;digo" XmlFile="FundamentoLegal.xml" returnvariable="LB_Cgo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Dscn" Default= "Descripci&oacute;n" XmlFile="FundamentoLegal.xml" returnvariable="LB_Dscn"/>

<cfset modo = 'ALTA' >
<cfif isdefined("form.Modo") and form.Modo NEQ 'ALTA'>
	<cfset modo = 'CAMBIO' >
</cfif>

<cfif modo NEQ "ALTA">
	<cfquery name="rsFundamentoLegal" datasource="#Session.DSN#">
		select CTFLcodigo,CTFLdescripcion
		from CTFundamentoLegal
		where CTFLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTFLid#" >
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
</cfif>

<form action="FundamentoLegal-SQL.cfm" method="post" name="form1" onSubmit="javascript: document.form1.CTFLcodigo.disabled = false; return true;">
	<cfoutput>
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">
	<input name="CTFLid" type="hidden" tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(Form.CTFLid)#</cfoutput></cfif>">
	</cfoutput>
  <table width="100%" align="center">
    <tr>
      <td width="50%" align="right" valign="middle" nowrap><cfoutput>#LB_Cgo#:</cfoutput>&nbsp;</td>
      <td>
        <input  name="CTFLcodigo" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsFundamentoLegal.CTFLcodigo)#</cfoutput></cfif>" size="30" maxlength="50"
        <cfif modo neq 'ALTA'>disabled</cfif>>
		<div align="right"></div>
      </td>
    </tr>
    <tr>
      <td align="right" valign="middle" nowrap><cfoutput>#LB_Dscn#:</cfoutput>&nbsp;</td>
      <td>
        <input name="CTFLdescripcion" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsFundamentoLegal.CTFLdescripcion)#</cfoutput></cfif>" size="40" maxlength="250">
		<div align="right"></div>
      </td>
    </tr>

    <tr>
      <td colspan="2" nowrap>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" align="center" nowrap>
		<cfset tabindex = 2 >
		<cf_botones modo="#modo#" tabindex="1" include="filtrar">
      </td>
    </tr>
  </table>
<cfset ts = "">
<!---   <cfif modo NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsTipoTransacciones.ts_rversion#"/>
	</cfinvoke>
</cfif>   --->
  <!--- <input tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32"> --->
 </form>

<!---  Para evitar que se introduzcan letras en un campo de solo numeros
 <script language="JavaScript1.2" type="text/javascript">

 	    function justNumbers(e)
            {
            var keynum = window.event ? window.event.keyCode : e.which;
            if ((keynum == 8) || (keynum == 46))
            return true;

            return /\d/.test(String.fromCharCode(keynum));
            }
 </script>



 <script>

 function valida(){
var err = '';

	if(form1.CTFLcodigo.value == ''){
	err = "\n - El Codigo es requerido";

	}
	if(form1.CTFLdescripcion.value == ''){
	 err = err +  "\n - La Descripcion es requerida";
	}

	if(err != ''){
		alert("Se presentaron los siguientes errores: " + err);
		return false;
	}else{
	return true;
	}

}

</script> --->

<cf_qforms form="form1">
<cf_qformsRequiredField  name="CTFLcodigo" description="#LB_Cgo#">
<cf_qformsRequiredField name="CTFLdescripcion" description="#LB_Dscn#">
</cf_qforms>
