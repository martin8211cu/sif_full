<cfset modo = 'ALTA' >
<cfif isdefined("form.Modo") and form.Modo NEQ 'ALTA'>
	<cfset modo = 'CAMBIO' >
</cfif>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Cgo" Default= "C&oacute;digo" XmlFile="TipoContrato.xml" returnvariable="LB_Cgo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Dscn" Default= "Descripci&oacute;n" XmlFile="TipoContrato.xml" returnvariable="LB_Dscn"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_MMax" Default= "Monto m&aacute;ximo" XmlFile="TipoContrato.xml" returnvariable="LB_MMax"/>


<cfif modo NEQ "ALTA">
	<cfquery name="rsTiposDeContratos" datasource="#Session.DSN#">
		select CTTCcodigo,CTTCdescripcion,FMT01COD
		from CTTipoContrato
		where CTTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTTCid#" >
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
</cfif>

<form action="TiposDeContratos-SQL.cfm" method="post" name="form1" onSubmit="javascript: document.form1.CTTCcodigo.disabled = false; return validar();" >
	<cfoutput>
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">
	<input name="CTTCid" type="hidden" tabindex="-1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(Form.CTTCid)#</cfoutput></cfif>">
	</cfoutput>
  <table width="100%" align="center">
<cfoutput>
    <tr>
      <td width="20%" align="right" valign="middle" nowrap><cfoutput>#LB_Cgo#</cfoutput>:&nbsp;</td>
      <td>
        <input  name="CTTCcodigo" type="text" tabindex="1" <cfif modo neq 'ALTA'>disabled</cfif> value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsTiposDeContratos.CTTCcodigo)#</cfoutput></cfif>" size="30" maxlength="50">
		<div align="right"></div>
      </td>
    </tr>
    <tr>
      <td align="right" valign="middle" nowrap><cfoutput>#LB_Dscn#</cfoutput>:&nbsp;</td>
      <td>
        <input name="CTTCdescripcion" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsTiposDeContratos.CTTCdescripcion)#</cfoutput></cfif>" size="40" maxlength="250">
		<div align="right"></div>
      </td>
    </tr>

    <tr>
		<td align="right" valign="middle" nowrap>
			<cf_translate key=LB_Moneda>Moneda</cf_translate>:&nbsp;
		</td>
		<td valign="top">
			<cfif  modo NEQ 'ALTA' and isdefined("Form.CTTCid") and Form.CTTCid neq "">
				<!--- Trae el tipo de moneda --->
				<cfquery name="rsForm" datasource="#session.DSN#">
					select CTTCMcodigo, CTTCmontomax, CTTCarticulo, CTTCservicio, CTTCactivofijo, CTTCobra,FMT01COD
					from CTTipoContrato
					where CTTCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTTCid#">
					and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<!--- Trae el nombre del tipo de moneda --->
				<cfquery name="rsMoneda" datasource="#session.DSN#">
					select Mcodigo, Mnombre
					from Monedas
					where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CTTCMcodigo#">
					and Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfset LvarMnombreSP = rsMoneda.Mnombre>
					<cf_sifmonedas form="form1" Mcodigo="McodigoOri" query="#rsMoneda#"
						FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"  tabindex="1">
			<cfelse>
				<cf_sifmonedas FechaSugTC="#LSDateFormat(Now(),'DD/MM/YYYY')#"
					form="form1" Mcodigo="McodigoOri" Todas="S" value="Todas">
			</cfif>
		</td>
	</tr>

	<tr>
		<td align="right" valign="middle" nowrap><cf_translate key=LB_TotalPagoSolicitado>#LB_MMax#</cf_translate>:&nbsp;</td>
		<td valign="top">
			<input type="text"
				name="montoMaximo"
				id="montoMaximo"
				onkeypress="return justNumbers(event);"
				value="<cfif modo NEQ 'ALTA'><cfoutput>#LSNumberFormat(rsForm.CTTCmontomax,',9.00')#</cfoutput><cfelse>0.00</cfif>"
				style="text-align:right; border:solid 1px ##CCCCCC;"
				tabindex="2"
				maxlength="20"
			>
		</td>
	</tr>
	<tr>
		<td align="right" valign="middle" nowrap><cf_translate key=LB_TotalPagoSolicitado>Formáto de Impresión</cf_translate>:&nbsp;</td>
		<td valign="top">
			<input type="text"
				name="formato"
				id="formato"
				value="<cfif modo NEQ 'ALTA'><cfoutput>#rsTiposDeContratos.FMT01COD#</cfoutput></cfif>"
				tabindex="3"
				size="10"
				maxlength="10"
			>
		</td>
	</tr>

	<tr>
		<td>
		</td>
		<td align="right" valign="middle" nowrap><p> &nbsp;</p>
		<fieldset>
			<legend>Tipo de compras permitidas por el contrato &nbsp;</legend>

			<table width="100%" align="center" border="0" >
				<tr>
					<input type="checkbox" name="Articulo" value="articulo"
						<cfif isdefined("rsForm.CTTCarticulo") and rsForm.CTTCarticulo eq 1>checked</cfif>
						> Articulo</input>&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="ActivoFijo" value="activoFijo"
						<cfif isdefined("rsForm.CTTCactivofijo") and rsForm.CTTCactivofijo eq 1>checked</cfif>
						> Activo Fijo</input>&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="Servicio" value="servicio"
						<cfif isdefined("rsForm.CTTCservicio") and rsForm.CTTCservicio eq 1>checked=true</cfif>
						> Servicio</input>&nbsp;&nbsp;&nbsp;
					<input type="checkbox" name="Obra" value="obra"
						<cfif isdefined("rsForm.CTTCobra") and rsForm.CTTCobra eq 1>checked</cfif>
						> Obra</input>

				</tr>
			</table>
	</fieldset>
	</td>
	</tr>


    <tr>
      <td colspan="2" nowrap>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" align="center" nowrap>
		<cfset tabindex = 2 >
		<cf_botones modo="#modo#" tabindex="1">
      </td>
    </tr>
</cfoutput>
  </table>
<cfset ts = "">
<!---   <cfif modo NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsTipoTransacciones.ts_rversion#"/>
	</cfinvoke>
</cfif>   --->
  <!--- <input tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32"> --->
 </form>

<!---  Para evitar que se introduzcan letras en un campo de solo numeros --->
 <script language="JavaScript1.2" type="text/javascript">

 	    function justNumbers(e)
            {
            var keynum = window.event ? window.event.keyCode : e.which;
            if ((keynum == 8) || (keynum == 46))
            return true;

            return /\d/.test(String.fromCharCode(keynum));
            }

        function validar()
        {
			var message = "";
           if (document.form1.botonSel.value != "")
			{
				if (document.form1.botonSel.value != "Alta" && document.form1.botonSel.value !="Cambio")
				{
					return true;
				}
			}

			if (document.form1.CTTCcodigo.value == "")
			{
				message = message +" - El campo Código es requerido. \n";

			}
			if (document.form1.CTTCdescripcion.value == "")
			{
				message = message +" - El campo Descripción es requerido. \n";

			}
			if (document.form1.montoMaximo.value == "")
			{
				message = message +" - El campo Monto Máximo es requerido. \n";

			}
			if (document.form1.McodigoOri.value == -1)
			{
				message = message +" - Seleccione una Moneda. \n";

			}

			if (document.form1.Articulo.checked || document.form1.ActivoFijo.checked  || document.form1.Servicio.checked || document.form1.Obra.checked)
			{

			}else{
				message = message +" - Seleccion al menos un Tipo de Compra. \n";
			}

			if (message.length)
			{
				alert("Se presentaron los siguientes errores:\n" + message);
				return false;
			}

			return true;
        }
 </script>



