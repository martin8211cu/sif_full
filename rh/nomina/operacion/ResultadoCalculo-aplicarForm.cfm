<!---================ TRADUCCION ==================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Aplicar"
	Default="Aplicar"
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Aplicar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta_seguro_que_desea_Aplicar_esta_Relacion_de_Calculo_de_Nomina"
	Default="¿Está seguro que desea Aplicar esta Relación de Cálculo de Nómina?"
	returnvariable="LB_Esta_seguro_que_desea_Aplicar_esta_Relacion_de_Calculo_de_Nomina"/>

<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Cuenta_Cliente"
				Default="Cuenta Cliente"
				returnvariable="vCuentaCliente"/>

<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Tipo_de_Cambio"
				Default="Tipo de Cambio"
				xmlfile="/rh/generales.xml"
				returnvariable="TipoCambio"/>

<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_El_siguiente_campo_debe_ser_mayor_que_cero"
				Default="El siguiente campo debe ser mayor que cero"
				returnvariable="vErrores"/>


<form action="ResultadoCalculo-aplicarSql.cfm" method="post" name="form1" onSubmit="javascript: return funcFinish();">
	<table width="95%" border="0" cellspacing="0" cellpadding="2" align="center">
		<tr>
			<td nowrap class="fileLabel" colspan="2">
				<cf_translate key="LB_Seleccione_la_Cuenta_Cliente_a_debitar_para_el_pago_de_la_nomina">Seleccione la Cuenta Cliente a Debitar para el pago de la Nómina</cf_translate>!
			</td>
		</tr>
		<tr><td nowrap colspan="2">&nbsp;</td></tr>
		<!--- Cuenta Cliente --->
		<tr>
			<td nowrap class="fileLabel" align="right" width="20%">
				<cf_translate key="LB_Cuenta_Cliente">Cuenta Cliente</cf_translate>:&nbsp;
			</td>
			<td nowrap width="80%">
				<cf_sifCuentaCliente tabindex="1" vMcodigo="#rsRelacionCalculo.Mcodigo#">
			</td>
		</tr>

		<tr>
			<td nowrap class="fileLabel" align="right" width="20%">
				<cf_translate key="LB_Moneda">Moneda</cf_translate>:&nbsp;
			</td>
			<td nowrap width="80%">
				<cfquery name="rsMoneda" datasource="#session.DSN#">
					select Mnombre, Miso4217
					from Monedas
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRelacionCalculo.Mcodigo#">
				</cfquery>
				<cfoutput>#rsMoneda.Miso4217# - #rsMoneda.Mnombre#</cfoutput>
			</td>
		</tr>

		<tr>
			<td nowrap class="fileLabel" align="right" width="20%">
				<cfoutput>#TipoCambio#</cfoutput>:&nbsp;
			</td>
			<td nowrap width="80%">
				<cfquery name="rsMonedaEmpresa" datasource="#session.DSN#">
					select Mcodigo
					from Empresas
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfset valor = 0 >
				<cfif rsMonedaEmpresa.Mcodigo eq rsRelacionCalculo.Mcodigo>
					<cfset valor = 1 >
				</cfif>
				<cf_monto name="tipo_cambio" decimales="2" size="15" value="#valor#">
				<cfif rsMonedaEmpresa.Mcodigo eq rsRelacionCalculo.Mcodigo>
					<script type="text/javascript" language="javascript1.2">
						document.form1.tipo_cambio.disabled = true;
					</script>
				</cfif>
			</td>
		</tr>

		<tr><td nowrap colspan="2">&nbsp;</td></tr>
		<tr><td nowrap colspan="2" align="center">
			<cf_botones values="#BTN_Aplicar#">
		</td></tr>
		<tr><td nowrap colspan="2">&nbsp;</td></tr>
	</table>
	<input type="hidden" name="RCNid" value="<cfoutput>#Form.RCNid#</cfoutput>">
	<input type="hidden" name="nAplica" value="0">
</form>
<cf_qforms>
<script language="JavaScript" type="text/javascript">
	function funcFinish() {
		if (parseFloat(document.form1.tipo_cambio.value) <= 0){
			alert("<cfoutput>#vErrores#</cfoutput>: <cfoutput>#TipoCambio#</cfoutput>")
			return false;
		}

		<cfoutput>
		if (confirm('#LB_Esta_seguro_que_desea_Aplicar_esta_Relacion_de_Calculo_de_Nomina#')){
			document.form1.btnAplicar.disabled = true;
			var _nAplica = parseFloat(document.form1.nAplica.value);
			_nAplica  = _nAplica + 1;
			document.form1.nAplica.value = _nAplica;
			document.form1.tipo_cambio.disabled = false;
			return true;

		}
		</cfoutput>
		return false;
	}
	objForm.CBdescripcion.required = true;
	objForm.CBdescripcion.description = '<cfoutput>#vCuentaCliente#</cfoutput>';
	objForm.tipo_cambio.required = true;
	objForm.tipo_cambio.description = '<cfoutput>#TipoCambio#</cfoutput>';
</script>
