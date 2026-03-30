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

<!--- Obtiene los datos de la tabla del query rsIndicadorNoPago, segun el dia --->
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="dtndia" type="numeric" required="true">
	<cfargument name="rsDatos" type="query" required="true">
	<cfquery dbtype="query" name="rs">
		select * from rsDatos where DTNdia = <cfqueryparam cfsqltype="cf_sql_integer" value="#dtndia#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<cfquery name="rsMonedas" datasource="#Session.DSN#">
	select a.Mcodigo, b.Mnombre
	from Empresas a, Monedas b
	where a.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and a.Ecodigo = b.Ecodigo
		and a.Mcodigo = b.Mcodigo
</cfquery>

<cfquery name="rsIndicadorNoPago" datasource="#session.DSN#">
	select Pvalor
	from RHParametros
	where Ecodigo=<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
		and Pcodigo=90
</cfquery>

<cfif modo neq 'ALTA'>
	<cfquery name="rsDiasNoPago" datasource="#session.DSN#">
		select DTNdia from DiasTiposNomina
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tcodigo#">
	</cfquery>
</cfif>

<cfif isdefined("Session.Ecodigo") AND isdefined("Form.Tcodigo") AND Len(Trim(Form.Tcodigo)) GT 0 >
	<cfquery name="rsForm" datasource="#Session.DSN#">
		SELECT rtrim(ltrim(Tcodigo)) as Tcodigo, Tdescripcion, Ttipopago, Mcodigo, ts_rversion,
		FactorDiasSalario, FactorDiasIMSS, IRcodigo,TipoNomina,CalculaCargas,AjusteMensual,Contabilizar,TRegimen
		FROM TiposNomina
		WHERE Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.Tcodigo#">
	</cfquery>
</cfif>

<cfquery name="rsCodigos" datasource="#session.dsn#">
	select Tcodigo from TiposNomina where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
</cfquery>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script src="/cfmx/rh/js/UtilesMonto.js"></script>
<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	function trim(dato) {
		dato = dato.replace(/^\s+|\s+$/g, '');
		return dato;
	}

	function deshabilitarValidacion(){
		if (document.form1.botonSel.value == 'Baja' || document.form1.botonSel.value == 'Nuevo' ){
			objForm.Tcodigo.required = false;
			objForm.Tdescripcion.required = false;
			objForm.Ttipopago.required = false;
			//objForm.FactorDiasSalario.required = false;
		}
	}
</script>

<form method="post" name="form1" action="SQLTiposNomina.cfm" onSubmit="return valida();">
<table align="center" border="0">
	<tr valign="baseline">
		<td width="161" align="right" nowrap><cfoutput>#LB_CODIGO#:</cfoutput></td>
		<td width="53">

			<input type="text" name="Tcodigo" <cfif modo NEQ 'ALTA'>disabled</cfif> value="<cfif modo NEQ 'ALTA'><cfoutput>#trim(rsForm.Tcodigo)#</cfoutput></cfif>" size="5" maxlength="5" onFocus="this.select();">
		</td>
      	<td width="205" nowrap colspan="1">
			&nbsp;&nbsp;
			<cfoutput>#LB_TipoDePago#:</cfoutput>
        	<select name="Ttipopago">
          		<option value="0" <cfif modo NEQ 'ALTA' and rsForm.Ttipopago EQ 0>selected</cfif>><cf_translate  key="CMB_Semanal">Semanal</cf_translate></option>
          		<option value="1" <cfif modo NEQ 'ALTA' and rsForm.Ttipopago EQ 1>selected</cfif>><cf_translate  key="CMB_Bisemanal">Bisemanal</cf_translate></option>
          		<option value="2" <cfif modo NEQ 'ALTA' and rsForm.Ttipopago EQ 2>selected</cfif>><cf_translate  key="CMB_Quincenal">Quincenal</cf_translate></option>
          		<option value="3" <cfif modo NEQ 'ALTA' and rsForm.Ttipopago EQ 3>selected</cfif>><cf_translate  key="CMB_Mensual">Mensual</cf_translate></option>
        	</select>

			<cfset ts = "">
        	<cfif modo NEQ "ALTA">
          		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rsForm.ts_rversion#" returnvariable="ts">
          		</cfinvoke>
        	</cfif>
        	<input type="hidden" name="Pagina" value="<cfif isdefined("Pagenum_lista") and Pagenum_lista NEQ ""><cfoutput>#Pagenum_lista#</cfoutput><cfelseif isdefined("Form.PageNum")><cfoutput>#PageNum#</cfoutput></cfif>">
        	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>">
		</td>
		<!--- Oparrales cambios para integrar informacion en XML Boletas de Pago --->
		<cfoutput>
		<td nowrap>#LB_TipoNomina#:&nbsp;</td>
		<td>
			<select name="TtipoNomina">
				<option value="O" <cfif modo NEQ 'ALTA' and trim(rsForm.TipoNomina) is 'O'>selected</cfif>>#CMB_NominaOrdinaria#</option>
				<option value="E" <cfif modo NEQ 'ALTA' and trim(rsForm.TipoNomina) eq "E">selected</cfif>>#CMB_NominaExtraordinaria#</option>
			</select>
		</td>
		</cfoutput>
	</tr>

	<tr valign="baseline">
		<td nowrap align="right"><cfoutput>#LB_DESCRIPCION#:</cfoutput></td>
		<td colspan="4">
			<input type="text" name="Tdescripcion" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Tdescripcion#</cfoutput></cfif>" size="60" maxlength="60" onFocus="this.select();"  >
		</td>
	</tr>

	<tr valign="baseline">
		<td align="right"><cf_translate  XmlFile="/rh/generales.xml" key="LB_Moneda">Moneda</cf_translate>:</td>
		<td >
			<select name="Mcodigo" <cfif modo neq "ALTA">disabled</cfif>>
				<cfoutput query="rsMonedas">
					<option value="#rsMonedas.Mcodigo#">#rsMonedas.Mnombre#</option>
				</cfoutput>
			</select>
		</td>
		<td nowrap colspan="3">
			&nbsp;&nbsp;
			<cf_translate key="LB_FactordeDiasParaSalarioDiario">Factor de d&iacute;as para salario diario</cf_translate>:
			<input name="FactorDiasSalario" type="text" style="text-align: right;"
				onfocus="javascript:this.value=qf(this); this.select();"
				onBlur="javascript: if (this.value != '') fm(this,4);"
				onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
				value="<cfif modo NEQ 'ALTA'><cfoutput>#trim(rsForm.FactorDiasSalario)#</cfoutput></cfif>"
				size="8" maxlength="8" >
		</td>
	</tr>
    <!---ljimenez se agrega la opcion de Factor dias Calculo IMSSS (mexico)--->
    <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2025" default="" returnvariable="vUsaSBC"/>
    <cfif #vUsaSBC# >
        <tr valign="baseline">
            <!--- OPARRALES 2018-08-06 Check para excluir el calculo de las cargas en las Relaciones de Calculo --->
			<td align="right">
				<input type="checkbox" name="CalculaCargas" id="CalculaCargas"<cfif modo NEQ 'ALTA' and IsDefined('rsForm') and rsForm.CalculaCargas eq 1>checked</cfif>>
			</td>
			<td>
				&nbsp;<cf_translate key="LB_CalculaCargas">Calcula Cargas</cf_translate>
			</td>
            <td colspan="3" align="left">
                &nbsp;&nbsp;
                <cf_translate key="LB_FactordeDiasParaIMSS">Factor de d&iacute;as para C&aacute;lculo IMSS</cf_translate>:
                <input name="FactorDiasIMSS" type="text" style="text-align: right;"
                    onfocus="javascript:this.value=qf(this); this.select();"
                    onBlur="javascript: if (this.value != '') fm(this,4);"
                    onkeyup="javascript:if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
                    value="<cfif modo NEQ 'ALTA'><cfoutput>#trim(rsForm.FactorDiasIMSS)#</cfoutput></cfif>"
                    size="8" maxlength="8" >
            </td>
        </tr>
    </cfif>

	<tr>
		<td align="right">
			<input type="checkbox" name="AjusteMensual" id="AjusteMensual"<cfif modo NEQ 'ALTA' and IsDefined('rsForm') and rsForm.AjusteMensual eq 1>checked</cfif>>
		</td>
		<td colspan="3" align="left">
			&nbsp;
			<cf_translate key="LB_RealizaAjusteMensual">Realiza Ajuste Mensual</cf_translate>
		</td>
	</tr>
	<tr>
		<td align="right">
			<input type="checkbox" name="Contabilizar" id="Contabilizar"<cfif modo NEQ 'ALTA' and IsDefined('rsForm') and rsForm.Contabilizar eq 1>checked</cfif>>
		</td>
		<td colspan="3" align="left">
			&nbsp;
			<cf_translate key="LB_Contabilizar">Contabilizar</cf_translate>
		</td>
	</tr>
	<tr valign="baseline">
		<td width="161" align="right" nowrap><cf_translate key="LB_Regimen">R&eacute;gimen:</cf_translate></td>
		<td>
			<select name="TRegimen">
				<option value="02" <cfif modo NEQ 'ALTA' and trim(rsForm.TRegimen) is '02'>selected</cfif>>Sueldos</option>
				<option value="03" <cfif modo NEQ 'ALTA' and trim(rsForm.TRegimen) is '03'>selected</cfif>>Jubilados</option>
				<option value="04" <cfif modo NEQ 'ALTA' and trim(rsForm.TRegimen) is '04'>selected</cfif>>Pensionados</option>
				<option value="09" <cfif modo NEQ 'ALTA' and trim(rsForm.TRegimen) is '09'>selected</cfif>>Asimilados Honorarios</option>
			</select>
		</td>
	</tr>

    <!---ljimenez se agrega la opcion de tabla de renta segun el tipo de nomina--->
    <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" ecodigo="#session.Ecodigo#" pvalor="2035" default="" returnvariable="vTablaNomina"/>
	<cfif #vTablaNomina# >
        <tr>
			<td align="right" nowrap><cf_translate key="LB_TablaDeImpuestoDeRenta">Tabla de Impuesto de Renta</cf_translate>:&nbsp;</td>
            <td colspan="4">
                <!--- trae la descripcion del impuesto de renta --->
                <cfset values = ''>
                <cfif isdefined('rsForm') and rsForm.RecordCount GT 0 >
                    <cfif len(trim(rsForm.IRcodigo)) GT 0 >
                        <cfquery name="rsTraeIRenta" datasource="#session.DSN#">
                            select IRcodigo, rtrim(ltrim(IRdescripcion)) as IRdescripcion
                            from ImpuestoRenta
                            where IRcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#Trim(rsForm.IRcodigo)#">
                        </cfquery>
                        <cfset values = '#rsTraeIRenta.IRcodigo#,#rsTraeIRenta.IRdescripcion#'>
                    </cfif>
                </cfif>
                <cfinvoke component="sif.Componentes.Translate"
                    method="Translate"
                    key="LB_ListadeTablasdeRenta"
                    default="Lista de Tablas de Renta"
                    returnvariable="LB_ListadeTablasdeRenta"/>
                <cfinvoke component="sif.Componentes.Translate"
                    method="Translate"
                    key="LB_Codigo"
                    default="C&oacute;digo"
                    returnvariable="LB_Codigo"/>
                <cfinvoke component="sif.Componentes.Translate"
                    method="Translate"
                    key="LB_Descripcion"
                    default="Descripci&oacute;n"
                    returnvariable="LB_Descripcion"/>

                <cf_conlis title="#LB_ListadeTablasdeRenta#"
                    campos = "IRcodigo,IRdescripcion"
                    desplegables = "S,S"
                    size = "10,50"
                    values="#values#"
                    tabla="ImpuestoRenta"
                    columnas="IRcodigo,IRdescripcion"
                    filtro=""
                    desplegar="IRcodigo,IRdescripcion"
                    etiquetas="#LB_Codigo#,#LB_Descripcion#"
                    formatos="S,S"
                    align="left,left"
                    conexion="#session.DSN#"
                    form = "form1"
                    tabindex="1">			</td>
            <td></td>
        </tr>
    </cfif>

	<cfif rsIndicadorNoPago.RecordCount gt 0 and rsIndicadorNoPago.Pvalor eq 'S'>
		<tr>
			<td align="right" valign="top"><cf_translate key="LB_DiasDeNoPago">D&iacute;as de No Pago</cf_translate>:</td>
			<td colspan="4" align="center">

				<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center">
					<tr>
						<cfif modo eq 'CAMBIO'><cfset valor = ObtenerDato(2, rsDiasNoPago)></cfif>
						<td width="1%" nowrap><input type="checkbox" name="DTNdia_2" value="2" <cfif modo neq 'ALTA' and valor.RecordCount gt 0 >checked</cfif>></td>
						<td nowrap><cf_translate   key="CHK_LUNES">Lunes</cf_translate></td>
					</tr>
					<tr>
						<cfif modo eq 'CAMBIO'><cfset valor = ObtenerDato(3, rsDiasNoPago)></cfif>
						<td width="1%" nowrap><input type="checkbox" name="DTNdia_3" value="3" <cfif modo neq 'ALTA' and valor.RecordCount gt 0 >checked</cfif> ></td>
						<td nowrap><cf_translate   key="CHK_MARTES">Martes</cf_translate></td>
					</tr>
					<tr>
						<cfif modo eq 'CAMBIO'><cfset valor = ObtenerDato(4, rsDiasNoPago)></cfif>
						<td width="1%" nowrap><input type="checkbox" name="DTNdia_4" value="4" <cfif modo neq 'ALTA' and valor.RecordCount gt 0 >checked</cfif> ></td>
						<td nowrap><cf_translate   key="CHK_MIERCOLES">Mi&eacute;rcoles</cf_translate></td>
					</tr>
					<tr>
						<cfif modo eq 'CAMBIO'><cfset valor = ObtenerDato(5, rsDiasNoPago)></cfif>
						<td width="1%"  nowrap><input type="checkbox" name="DTNdia_5" value="5" <cfif modo neq 'ALTA' and valor.RecordCount gt 0 >checked</cfif> ></td>
						<td nowrap><cf_translate   key="CHK_JUEVES">Jueves</cf_translate></td>
					</tr>
					<tr>
						<cfif modo eq 'CAMBIO'><cfset valor = ObtenerDato(6, rsDiasNoPago)></cfif>
						<td width="1%"  nowrap><input type="checkbox" name="DTNdia_6" value="6" <cfif modo neq 'ALTA' and valor.RecordCount gt 0 >checked</cfif> ></td>
						<td nowrap><cf_translate   key="CHK_VIERNES">Viernes</cf_translate></td>
					</tr>
					<tr>
						<cfif modo eq 'CAMBIO'><cfset valor = ObtenerDato(7, rsDiasNoPago)></cfif>
						<td width="1%"  nowrap><input type="checkbox" name="DTNdia_7" value="7" <cfif modo neq 'ALTA' and valor.RecordCount gt 0 >checked</cfif> ></td>
						<td nowrap><cf_translate   key="CHK_SABADO">S&aacute;bado</cf_translate></td>
					</tr>
					<tr>
						<cfif modo eq 'CAMBIO'><cfset valor = ObtenerDato(1, rsDiasNoPago)></cfif>
						<td width="1%" nowrap><input type="checkbox" name="DTNdia_1" value="1" <cfif modo neq 'ALTA' and valor.RecordCount gt 0 >checked</cfif> ></td>
						<td nowrap><cf_translate   key="CHK_DOMINGO">Domingo</cf_translate></td>
					</tr>
				</table>

			</td>
		</tr>
	</cfif>

	<tr valign="baseline">
		<td colspan="5" align="right" nowrap>
			<div align="center"><cfinclude template="/rh/portlets/pBotones.cfm">
				<cf_sifayuda
					name="imAyuda"
					imagen="3"
					tip="true"
					url="/rh/Utiles/sifayudahelp.cfm">
			</div>
			<div align="center">
				<cfif modo NEQ 'ALTA'>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_CalendarioDePagos"
						Default="Calendario de Pagos"
						returnvariable="BTN_CalendarioDePagos"/>
					<input name="btnCalendPagos" type="button" class="btnNormal" onClick="javascript: LigaCalendPagos(this);" value="<cfoutput>#BTN_CalendarioDePagos#</cfoutput>">

					<cfinvoke component="sif.Componentes.Translate"
					method="Translate"
					key="BTN_Permisos"
					default="Permisos"
					returnvariable="BTN_Permisos"/>
					<input type="button" name="TipoNomina" class="btnNormal" value="<cfoutput>#BTN_Permisos#</cfoutput>" onclick="javascript: goTipo(this.form);">

				</cfif>
			</div>
		</td>
	</tr>
  </table>

	<!--- filtros de la lista --->
	<cfoutput>
	<cfif isdefined("form.f_codigo") and len(trim(form.f_codigo)) >
		<input type="hidden" name="f_codigo" value="#form.f_codigo#" />
	</cfif>
	<cfif isdefined("form.f_descripcion") and len(trim(form.f_descripcion))>
		<input type="hidden" name="f_descripcion" value="#form.f_descripcion#" />
	</cfif>
	<cfif isdefined("form.f_tipopago") and len(trim(form.f_tipopago))>
		<input type="hidden" name="f_tipopago" value="#form.f_tipopago#" />
	</cfif>
	<cfif isdefined("form.pageNum_lista") and len(trim(form.pageNum_lista))>
		<input type="hidden" name="pageNum_lista" value="#form.pageNum_lista#" />
	</cfif>
	</cfoutput>

</form>

<script language="JavaScript">
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_ElCodigoQueIntentaInsertarYaExiste"
		Default="El código que intenta insertar ya existe"
		returnvariable="MSG_ElCodigoQueIntentaInsertarYaExiste"/>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_ElCodigoDeTipoDeNomina"
		Default="Código de Tipo de Nómina"
		returnvariable="MSG_ElCodigoDeTipoDeNomina"/>

	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_DigiteLaDescripcion"
		Default="Descripción"
		XmlFile="/rh/generales.xml"
		returnvariable="MSG_DigiteLaDescripcion"/>

	function valida(){
		document.form1.Tcodigo.disabled = false;
		document.form1.Mcodigo.disabled = false;
		return true;
	}

	function LigaCalendPagos(obj){
		location.href='calendarioPagos.cfm?Tcodigo=' + obj.form.Tcodigo.value;
	}

	function __CodeExists(){
		<cfoutput query="rsCodigos">
			var valor = "#Trim(rsCodigos.Tcodigo)#".toUpperCase( );
			if ( valor == trim(this.value.toUpperCase( ))
			<cfif modo neq "ALTA">
				&& "#Trim(rsForm.Tcodigo)#".toUpperCase( ) != trim(this.value.toUpperCase( ))
			</cfif>
			) {
				this.error = "#MSG_ElCodigoQueIntentaInsertarYaExiste#";
			}
		</cfoutput>
	}
	_addValidator("isCodeExists", __CodeExists);

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	objForm.Tcodigo.required = true;
	objForm.Tcodigo.validateCodeExists();
	objForm.Tcodigo.validate = true;
	objForm.Tcodigo.description="<cfoutput>#MSG_ElCodigoDeTipoDeNomina#</cfoutput>";
	objForm.Tdescripcion.required = true;
	objForm.Tdescripcion.description="<cfoutput>#MSG_DigiteLaDescripcion#</cfoutput>";
	objForm.Ttipopago.required=true;
	//objForm.FactorDiasSalario.required = true;
	//objForm.FactorDiasSalario.description="<cfoutput>Factor de días para salario diario</cfoutput>";


	function goTipo(f) {
		location.href =  "TiposNominaUsuario.cfm<cfif isdefined("rsForm.Tcodigo")>?Tcodigo=<cfoutput>#trim(rsForm.Tcodigo)#</cfoutput></cfif>&especial=N";
	}
</script>