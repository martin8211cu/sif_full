<!--- Establecimiento del modo --->
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

<!---***Filtro para utilizar el catalogo en TCE o Bancos***--->
<cfset LvarABTtce = 0>
<cfset LvarIrAformSQLTipos = "../../mb/catalogos/SQLTiposTransaccion.cfm">
<cfif isdefined("LvarTCEFormTiposTransaccion")>
	<cfset LvarIrAformSQLTipos = "../../tce/catalogos/TCESQLTiposTransaccion.cfm">
	<cfset LvarABTtce = 1>
</cfif>

<cfif isdefined("Session.Ecodigo") AND isdefined("Form.BTid") AND Len(Trim(Form.BTid)) GT 0 >
	<cfquery name="rsTipoTransaccion" datasource="#Session.DSN#">
		select 	BTid, 
				Ecodigo, 
				BTcodigo, 
				BTdescripcion, 
				BTtipo, 
				BTtipoEst, 
				BTMetdoPago,
				ts_rversion
		from BTransacciones 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			and BTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.BTid#">
			and BTtce = <cfqueryparam cfsqltype="cf_sql_bit" value="#LvarABTtce#">
	</cfquery>
</cfif>
<cfquery datasource="#Session.DSN#" name="rsMetodoPago">
	SELECT
		Clave,
		Concepto,
		Ecodigo
	FROM CEMtdoPago
	ORDER BY Concepto ASC
</cfquery>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<!---Redireccion SQLTiposTransaccion.cfm o TCESQLTiposTransaccion.cfm--->
<form method="post" name="form1" action="<cfoutput>#LvarIrAformSQLTipos#</cfoutput>">
	<table align="center" width="100%" cellpadding="1" cellspacing="0">
		<tr> 
			<td nowrap align="right">Código de Transacción:&nbsp;</td>
			<td><input name="BTcodigo" tabindex="1" type="text" value="<cfif modo NEQ "ALTA"><cfoutput>#trim(rsTipoTransaccion.BTcodigo)#</cfoutput></cfif>" size="2" maxlength="2" onfocus="javascript:this.select();"></td>
		</tr>

		<tr> 
			<td nowrap align="right">Descripción:&nbsp;</td>
			<td><input type="text" tabindex="1" name="BTdescripcion" value="<cfif modo NEQ "ALTA"><cfoutput>#trim(rsTipoTransaccion.BTdescripcion)#</cfoutput></cfif>" size="50" maxlength="50" onfocus="javascript:this.select();"></td>
		</tr>

		<tr> 
			<td nowrap align="right">Tipo de Movimiento:&nbsp;</td>
			<td>
				<select name="BTtipo" tabindex="1">
					<option value="D" <cfif modo NEQ "ALTA" and rsTipoTransaccion.BTtipo EQ "D">selected</cfif>>D&eacute;bito</option>
					<option value="C" <cfif modo NEQ "ALTA" and rsTipoTransaccion.BTtipo EQ "C">selected</cfif>>Cr&eacute;dito</option>
				</select>
			</td>
		</tr>
		<tr> 
			<td nowrap align="right">Tipo de Estimación</td>
			<td>
				<select name="BTtipoEst" tabindex="1">
					<option value="N" <cfif modo NEQ "ALTA" and rsTipoTransaccion.BTtipoEst EQ "N">selected</cfif>>Ninguno</option>
					<option value="I" <cfif modo NEQ "ALTA" and rsTipoTransaccion.BTtipoEst EQ "I">selected</cfif>>Est. Inversi&oacute;n</option>
					<option value="C" <cfif modo NEQ "ALTA" and rsTipoTransaccion.BTtipoEst EQ "C">selected</cfif>>Est. Cr&eacute;dito</option>
				</select>
			</td>
		</tr>
		<tr> 
			<td nowrap align="right">M&eacute;todo de pago:&nbsp;</td>
				<td>	
				<select name="MtdoPago" id="MtdoPago">
					<option value="-1">-- Seleccione una opci&oacute;n--</option>
				<cfloop query="rsMetodoPago">
					<cfoutput>
						<option value="#rsMetodoPago.Clave#" <cfif MODO NEQ "ALTA" AND isDefined("rsTipoTransaccion.BTMetdoPago") AND rsTipoTransaccion.BTMetdoPago EQ rsMetodoPago.Clave>selected</cfif>>#rsMetodoPago.Concepto#</option>
					</cfoutput>
				</cfloop>
				<cfif rsMetodoPago.recordCount EQ 0>
					<option value="-1">(No existen Conceptos de pago configurados)</option>
				</cfif>
				</select>
			</td>
		</tr>
		<!--- *************************************************** --->
		<cfif modo NEQ 'ALTA'>
			<tr>
			  <td colspan="2" align="center" class="tituloListas">Complementos Contables</td>
			</tr>
			<tr><td colspan="2" align="center">
			<cf_sifcomplementofinanciero action='display'
					tabla="BTransacciones"
					form = "form1"
					llave="#Form.BTid#" tabindex='1' />		
			</td></tr>
		</cfif>	
		<!--- *************************************************** --->  

		<tr><td colspan="2">&nbsp;</td></tr>

		<tr> 
			<td colspan="2" align="center" nowrap>
					<input type="hidden" tabindex="-1" name="BTid" value="<cfif modo NEQ "ALTA"><cfoutput>#rsTipoTransaccion.BTid#</cfoutput></cfif>">
					<cfset ts = "">
					<cfif modo NEQ "ALTA">
						<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsTipoTransaccion.ts_rversion#" returnvariable="ts"></cfinvoke>
					</cfif>		  
					<input  tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">	  
					<cfset tabindex= 2 >
					<cfinclude template="../../portlets/pBotones.cfm">
			</td>
		</tr>
	</table>
</form>

<script language="JavaScript">
	function deshabilitarValidacion(){
		objForm.BTcodigo.required = false;
		objForm.BTdescripcion.required = false;
	}

	qFormAPI.errorColor = "#FFFFFF";
	objForm = new qForm("form1");

	objForm.BTcodigo.required = true;
	objForm.BTcodigo.description="Código";
	
	objForm.BTdescripcion.required = true;
	objForm.BTdescripcion.description="Descripción";

</script>