<cfset modo = 'ALTA'>

<cfif isdefined("form.CMTOcodigo") and len(trim(form.CMTOcodigo)) >
	<cfset modo = 'CAMBIO'>
</cfif>

<cfquery name="rsFormatoCompra" datasource="#session.DSN#">
	select rtrim(FMT01COD) as FMT01COD, FMT01DES, FMT01TIP 
	from FMT001 
	where (Ecodigo is null or Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	  and FMT01TIP = 10 
	order by FMT01DES
</cfquery>

<cfif modo neq 'ALTA'>
	<cfquery name="data" datasource="#session.DSN#">
		select CMTOcodigo, CMTOdescripcion, rtrim(FMT01COD) as FMT01COD, CMTgeneratracking, CMTOimportacion, 
			   CMTOte, CMTOtransportista, CMTOtipotrans, CMTOincoterm, CMTOlugarent, ts_rversion,Mcodigo,CMTOMontoMin,CMTOMontoMax, 
               CMTOModFechaEntrega, CMTOModDescripcion, CMTOModFechaRequerida,CMTOModImpuesto,
			   CMTOModDescripcionE,CMTOModCodigoEnc,CMTOModGeneral
		from CMTipoOrden
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		  and CMTOcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CMTOcodigo#">
	</cfquery>
</cfif>

<script language="JavaScript1.2" src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>
<form style="margin:0;" name="form1" action="TiposOrdenCompra-sql.cfm" method="post">
	<table align="center" width="100%" cellpadding="2" cellspacing="0" border="0">
		<tr>
			<td width="1%" align="right" nowrap><strong>C&oacute;digo:</strong></td>
			<td nowrap>
				<input type="text" name="CMTOcodigo" size="5" maxlength="5" value="<cfif modo neq 'ALTA'>#data.CMTOcodigo#</cfif>" onfocus="this.select();">			
			</td>
		</tr>
		
		<tr>
			<td align="right" nowrap><strong>Descripci&oacute;n:</strong></td>
			<td nowrap>
				<input type="text" name="CMTOdescripcion" maxlength="80" value="<cfif modo neq 'ALTA'>#data.CMTOdescripcion#</cfif>" onfocus="this.select();" style="width: 100%">
			</td>
		</tr>
		
		<tr>
			<td  align="right" nowrap><strong>Formato Impresi&oacute;n:</strong></td>
			<td nowrap>
				<select name="FMT01COD">
					<option value=""></option>
					<cfloop query="rsFormatoCompra">
						<option value="#rsFormatoCompra.FMT01COD#" <cfif modo neq 'ALTA' and  data.FMT01COD eq rsFormatoCompra.FMT01COD >selected</cfif> >#rsFormatoCompra.FMT01DES#</option>
					</cfloop>
				</select>
			</td>
		</tr>
		<tr><!----------Moneda------------->		 
			<td nowrap align="right">
				<strong>Moneda:</strong>			
			</td>
			<td nowrap>
				<cfif  modo NEQ 'ALTA' and data.Mcodigo neq '' >
					<cfquery name="rsMoneda" datasource="#session.DSN#">
						select Mcodigo, Mnombre
						from Monedas
						where Mcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#data.Mcodigo#">
						and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					</cfquery>
					<cfset LvarMnombreSP = rsMoneda.Mnombre>					
					<cf_sifmonedas  FechaSugTC="#LSDateformat(Now(),'DD/MM/YYYY')#" form="form1" Mcodigo="McodigoOri" query="#rsMoneda#" tabindex="1" valueTC="#data.Mcodigo#">
				<cfelse>
					<cf_sifmonedas  FechaSugTC="#LSDateformat(Now(),'DD/MM/YYYY')#" form="form1" Mcodigo="McodigoOri"  tabindex="1">
				</cfif>   
			</td>			
		</tr>
		<tr><!-----------Monto Minimo-------------->
			<td nowrap align="right"><strong>Monto Mínimo: </strong></td>
			<td nowrap>
				<!---<input type="text" name="CMTOMontoMin" size="20" maxlength="20" value="<cfif modo neq 'ALTA'><cfoutput>#LSNumberFormat(data.CMTOMontoMin,',9.00')#</cfoutput><cfelse>0.00</cfif>">--->
			<cfif modo neq 'ALTA'>
			     <cfset LvarValue= data.CMTOMontoMin>
			<cfelse>
				 <cfset LvarValue= 0.00>
			</cfif>
			    <cf_inputNumber name="CMTOMontoMin"  value="#LvarValue#" enteros="10" decimales="2" negativos="false" comas="yes">
			
			</td>
		</tr>
		<tr><!-----------Monto Maximo-------------->
			<td nowrap align="right"><strong>Monto Máximo: </strong></td>
			<td nowrap>
				<!---<input type="text" name="CMTOMontoMax" size="20" maxlength="20" value="<cfif modo neq 'ALTA'><cfoutput>#LSNumberFormat(data.CMTOMontoMax,',9.00')#</cfoutput><cfelse>0.00</cfif>">--->
			<cfif modo neq 'ALTA'>
			     <cfset LvarValue2= data.CMTOMontoMax>
			<cfelse>
				 <cfset LvarValue2= 0.00>
			</cfif>
			    <cf_inputNumber name="CMTOMontoMax"  value="#LvarValue2#" enteros="10" decimales="2" negativos="false" comas="yes">
			
			</td>
		</tr>
		<tr>
			<td  align="right" nowrap>&nbsp;</td>
			<td nowrap>
				<table width="100%" cellpadding="0" cellspacing="0">
					<tr>
						<td width="1%"><input type="checkbox" name="CMTgeneratracking" <cfif modo neq 'ALTA' and data.CMTgeneratracking eq 1> checked</cfif>></td>
						<td valign="middle">Genera Tracking de Embarque</td>
					</tr>
					<tr>
                      <td><input name="CMTOimportacion" type="checkbox" id="CMTOimportacion" <cfif modo neq 'ALTA' and data.CMTOimportacion eq 1> checked</cfif>></td>
                      <td valign="middle">Tipo de Orden para Importaci&oacute;n </td>
				  </tr>
				</table>
			</td>
		</tr>
		<tr>
		  <td colspan="2" align="right" nowrap>
			<fieldset><legend><strong>Campos Requeridos</strong></legend>
		  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
            <tr valign="middle">
              <td width="1%"><input name="CMTOte" type="checkbox" id="CMTOte" value="1" <cfif modo neq 'ALTA' and data.CMTOte eq 1> checked</cfif>></td>
              <td>Tiempo de Entrega </td>
              <td width="1%"><input name="CMTOincoterm" type="checkbox" id="CMTOincoterm" value="1" <cfif modo neq 'ALTA' and data.CMTOincoterm eq 1> checked</cfif>></td>
              <td>Incoterm</td>
            </tr>
            <tr valign="middle">
              <td><input name="CMTOtransportista" type="checkbox" id="CMTOtransportista" value="1" <cfif modo neq 'ALTA' and data.CMTOtransportista eq 1> checked</cfif>></td>
              <td>Transportista</td>
              <td><input name="CMTOlugarent" type="checkbox" id="CMTOlugarent" value="1" <cfif modo neq 'ALTA' and data.CMTOlugarent eq 1> checked</cfif>></td>
              <td>Lugar de Entrega </td>
            </tr>
            <tr valign="middle">
              <td><input name="CMTOtipotrans" type="checkbox" id="CMTOtipotrans" value="1" <cfif modo neq 'ALTA' and data.CMTOtipotrans eq 1> checked</cfif>></td>
              <td>Tipo de Transporte </td>
              <td>&nbsp;</td>
              <td>&nbsp;</td>
            </tr>
          </table>
		  </fieldset>
		  </td>
	  </tr>
	   <tr>
		  <td colspan="2" align="right" nowrap>
			<fieldset><legend><strong>Campos Modificables Encabezado</strong></legend>
		  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
			 <tr valign="middle">
				<td width="1%"><input name="CMTOcodigoEnc" type="checkbox" id="CMTOcodigoEnc" value="1" <cfif modo neq 'ALTA' and data.CMTOModCodigoEnc eq 1> checked</cfif>></td>
				<td>Tipo de Orden de Compra</td>
				<td width="1%"><input name="CMTOModDescripcionEnc" type="checkbox" id="CMTOModDescripcionEnc" value="1" <cfif modo neq 'ALTA' and data.CMTOModDescripcionE eq 1> checked</cfif>></td>
				<td>Descripci&oacute;n</td>
            </tr>
          </table>
		  </fieldset>
		  </td>
	  </tr>
      <tr>
		  <td colspan="2" align="right" nowrap>
			<fieldset><legend><strong>Campos Modificables Detalle</strong></legend>
		  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  	<tr valign="middle">
              <td width="1%"><input name="CMTOModGeneral" type="checkbox" id="CMTOModGeneral" value="1" <cfif modo neq 'ALTA' and data.CMTOModGeneral eq 1> checked</cfif>></td>
              <td>General </td>
              <td width="1%"></td>
              <td></td>
            </tr>
            <tr valign="middle">
              <td width="1%"><input name="CMTOModGeneral" type="checkbox" id="CMTOModGeneral" value="1" <cfif modo neq 'ALTA' and data.CMTOModGeneral eq 1> checked</cfif>></td>
              <td>General </td>
              <td width="1%"></td>
              <td></td>
            </tr>
            <tr valign="middle">
              <td width="1%"><input name="CMTOModFechaEntrega" type="checkbox" id="CMTOModFechaEntrega" value="1" <cfif modo neq 'ALTA' and data.CMTOModFechaEntrega eq 1> checked</cfif>></td>
              <td>Fecha de Entrega </td>
              <td width="1%"><input name="CMTOModDescripcion" type="checkbox" id="CMTOModDescripcion" value="1" <cfif modo neq 'ALTA' and data.CMTOModDescripcion eq 1> checked</cfif>></td>
              <td>Descripci&oacute;n</td>
            </tr>
             <tr valign="middle">
              <td width="1%"><input name="CMTOModFechaRequerida" type="checkbox" id="CMTOModFechaRequerida" value="1" <cfif modo neq 'ALTA' and data.CMTOModFechaRequerida eq 1> checked</cfif>></td>
              <td>Fecha de Requerida </td>
              <td width="1%"><input name="CMTOModImpuesto" type="checkbox" id="CMTOModImpuesto" value="1" <cfif modo neq 'ALTA' and data.CMTOModImpuesto eq 1> checked</cfif>></td>
              <td>Impuesto</td>
            </tr>
          </table>
		  </fieldset>
		  </td>
	  </tr>

		<cfif modo EQ 'CAMBIO'>
			<input type="hidden" name="xCMTOcodigo" value="#data.CMTOcodigo#" >
		</cfif>
		
		<tr>
			<td align="center" colspan="2">
				<cfinclude template="../../portlets/pBotones.cfm">
			</td>
		</tr>

		<tr><td colspan="2">&nbsp;</td></tr>

		<cfif modo neq "ALTA">
      		<cfset ts = "">
      		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#data.ts_rversion#" returnvariable="ts">
      		</cfinvoke>
      		<input type="hidden" name="ts_rversion" value="#ts#">
    	</cfif>

	</table>
</form>
</cfoutput>

<script language="JavaScript1.2" type="text/javascript">	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.CMTOcodigo.required = true;
	objForm.CMTOcodigo.description="Código";

	objForm.CMTOdescripcion.required = true;
	objForm.CMTOdescripcion.description="Descripción";

	function deshabilitarValidacion(){
		objForm.CMTOcodigo.required = false;
		objForm.CMTOdescripcion.required = false;
	}

</script>
