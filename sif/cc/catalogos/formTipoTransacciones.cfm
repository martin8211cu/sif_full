<cfset modo = 'ALTA' >
<cfif isdefined("form.CCTcodigo") and len(trim(form.CCTcodigo))>
	<cfset modo = 'CAMBIO' >
</cfif>

<cfquery name="rsTransaccionesBancarias" datasource="#Session.DSN#">
	select <cf_dbfunction name="to_char" args="BTid"> as BTid,
	BTdescripcion
	from BTransacciones a
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Exists (select 1
	  				   from Parametros b
					   where a.BTid = <cf_dbfunction name="to_number" args="b.Pvalor">
					   		and  b.Ecodigo = a.Ecodigo
					         and b.Pcodigo between 160 and 170)
</cfquery>

<cfif modo NEQ "ALTA">
	<cfquery name="rsTipoTransacciones" datasource="#Session.DSN#">
		select CCTcodigo, CCTdescripcion, CCTtipo, coalesce(CCTvencim, 0) as CCTvencim, CCTpago, BTid, CCTcktr, CCTafectacostoventas, CCTnoflujoefe, FMT01COD, ts_rversion, CCTcodigoext, cuentac,
			CCTtranneteo,CCTcolrpttranapl,CCTestimacion,CCTCodigoRef,ClaveSAT, CCTCompensacion
		from CCTransacciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigo#" >
		order by CCTcodigo asc
	</cfquery>
</cfif>

<cfquery name="rsFormatos" datasource="#Session.DSN#">
	select FMT01COD, FMT01DES from FMT001
	where FMT01TIP = 12
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by FMT01COD
</cfquery>

<!--- Consulta de etiquetas para pintar títulos en el reporte --->
<cfquery name="rsEtiquetas" datasource="#session.dsn#">
	select CCTcolrpttranapl, CCTcolrpttranapldesc
	from CCTrpttranapl
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">
</cfquery>

<cf_templatecss>

<script language="JavaScript" type="text/javascript">
	function showPagos(f) {
		var p = document.getElementById("bloquePagos");
		if (f.CCTpago.checked) {
			p.style.display = "";
		} else {
			p.style.display = "none";
		}
	}

	function showChkbox(f) {
		var p1 = document.getElementById("bloqueChk1");
		var p2 = document.getElementById("bloqueChk2");
		if (f.CCTtipo.value == 'C') {
			p1.style.display = "";
			p2.style.display = "";
		} else {
			p1.style.display = "none";
			p2.style.display = "none";
		}
	}

	function showref(f) {
		var p4 = document.getElementById("bloqueChk4");
		if (f.CCTestimacion.checked) {
			p4.style.display = "";
			objForm.CCTCodigoRef.required = true;
		} else {
			p4.style.display = "none";
			objForm.CCTCodigoRef.required = false;
		}
	}
</script>

<form action="SQLTipoTransacciones.cfm" method="post" name="form1" onSubmit="javascript: document.form1.CCTcodigo.disabled = false; return true;" >
	<cfoutput>
	<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">
	<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">
	</cfoutput>
  <table width="100%" align="center">
    <tr>
      <td width="50%" align="right" valign="middle" nowrap> C&oacute;digo:&nbsp;</td>
      <td>
        <input  name="CCTcodigo" type="text" tabindex="1" <cfif modo neq 'ALTA'>disabled</cfif> value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsTipoTransacciones.CCTcodigo)#</cfoutput></cfif>" size="5" maxlength="2" alt="El campo Código del Tipo de Transacción">
        <div align="right"></div>
      </td>
    </tr>
    <tr>
      <td align="right" valign="middle" nowrap>Descripci&oacute;n:&nbsp;</td>
      <td>
        <input name="CCTdescripcion" type="text" tabindex="1" value="<cfif modo NEQ "ALTA"><cfoutput>#HTMLEditFormat(rsTipoTransacciones.CCTdescripcion)#</cfoutput></cfif>" size="50" maxlength="80"  alt="El campo Descripción del Tipo de Transacción">
      </td>
    </tr>
	<tr>
	  	<td align="right" valign="middle" nowrap>C&oacute;digo Externo:&nbsp;</td>
		<td nowrap>
			<input tabindex="1" name="CCTcodigoext" type="text" size="30"  maxlength="25" value="<cfif modo NEQ "ALTA"><cfoutput>#Trim(rsTipoTransacciones.CCTcodigoext)#</cfoutput></cfif>" >
		</td>
	</tr>
    <tr>
      <td align="right" valign="middle" nowrap>Vencimiento en D&iacute;as:&nbsp;</td>
      <td nowrap>
        <!---<input name="CCTvencim" type="text" tabindex="1" style="text-align:right" value="<cfif modo NEQ "ALTA"><cfoutput>#rsTipoTransacciones.CCTvencim#</cfoutput></cfif>" size="10"  alt="El campo Descripción del Vencimiento en Días"> --->
		<cfset valor = '' >
		<cfif modo neq 'ALTA'>
			<cfset valor = rsTipoTransacciones.CCTvencim >
		</cfif>

		<cf_monto name="CCTvencim" tabindex="1" size="10" decimales="0" negativos="true" value="cdcdfdfd"  >
		&nbsp;
		<input type="checkbox" name="chkContado" tabindex="1" id="chkContado"
			value="<cfif modo NEQ "ALTA" and rsTipoTransacciones.CCTvencim EQ -1>S<cfelse>N</cfif>"
			onclick="javascript:if (this.checked) {this.value='S';form1.CCTvencim.value='';form1.CCTvencim.disabled=true;} else {this.value='N';form1.CCTvencim.disabled=false;form1.CCTvencim.value='<cfif modo NEQ "ALTA"><cfoutput>#rsTipoTransacciones.CCTvencim#</cfoutput></cfif>';}">
			<cfif modo NEQ "ALTA">
				<script language="JavaScript1.2">
					var vencimiento = '<cfoutput>#rsTipoTransacciones.CCTvencim#</cfoutput>';

					if (vencimiento == -1) {
						form1.chkContado.value='S';
						form1.chkContado.checked=true;
						form1.CCTvencim.value='';
						form1.CCTvencim.disabled=true;
					}
					else {
						form1.chkContado.value='N';
						form1.CCTvencim.disabled=false;
						form1.chkContado.checked=false;
						form1.CCTvencim.value=<cfif modo NEQ "ALTA"><cfoutput>'#rsTipoTransacciones.CCTvencim#'</cfoutput></cfif>;
					}

				</script>
			</cfif>
      	<label for="chkContado" style="font-style:normal; font-variant:normal; font-weight:normal">Transacción de Contado</label>
	  </td>
    </tr>
    <tr>
      <td align="right" valign="middle" nowrap>Tipo:&nbsp;</td>
      <td>
        <select name="CCTtipo" onChange="javascript: showChkbox(this.form);" tabindex="1" >
          <option value="D" <cfif (isDefined("rsTipoTransacciones.CCTtipo") AND "D" EQ rsTipoTransacciones.CCTtipo)>selected</cfif>>Débito</option>
          <option value="C" <cfif (isDefined("rsTipoTransacciones.CCTtipo") AND "C" EQ rsTipoTransacciones.CCTtipo)>selected</cfif>>Crédito</option>
        </select>
      </td>
    </tr>

    <tr>
      <td nowrap align="right">Formato de Impresi&oacute;n:&nbsp;</td>
      <td nowrap>
	  	<select name="FMT01COD" tabindex="1" >
		<option value="">-- seleccionar formato--</option>
		<cfoutput>
		<cfloop query="rsFormatos">
			<option value="#rsFormatos.FMT01COD#" <cfif modo neq "ALTA" and Trim(rsTipoTransacciones.FMT01COD) eq Trim(rsFormatos.FMT01COD)>selected</cfif> >#rsFormatos.FMT01DES#</option>
		</cfloop>
		</cfoutput>
		</select>
      </td>
    </tr>
	<tr>
	  <td nowrap align="right">Etiqueta Reporte:&nbsp;</td>
		<td nowrap>
        <select name="CCTcolrpttranapl" tabindex="1" >
			<cfif rsEtiquetas.RecordCount EQ 0>
				<option value="0">No se han definido etiquetas</option>
			</cfif>
			<cfoutput>
				<cfloop query="rsEtiquetas">
					<option value="#rsEtiquetas.CCTcolrpttranapl#" <cfif (isDefined("rsTipoTransacciones.CCTcolrpttranapl") and rsTipoTransacciones.CCTcolrpttranapl EQ rsEtiquetas.CCTcolrpttranapl)>selected</cfif>>#rsEtiquetas.CCTcolrpttranapldesc#</option>
				</cfloop>
			</cfoutput>
        </select>

		</td>
	</tr>
	<tr>
	  <td nowrap align="right">Complemento:&nbsp;</td>
		<td nowrap>
			<input type="text" tabindex="1"  name="cuentac" size="12" maxlength="100" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsTipoTransacciones.cuentac#</cfoutput></cfif>" alt="Complemento">
		</td>
	</tr>
	<tr>
		<td nowrap align="right">Tipo de Comprobante: &nbsp;</td>
		<td>
			<cfquery name="rsTipoComp" datasource="#session.dsn#">
				select CSATcodigo, CSATdescripcion from CSATTipoCompr
				where CSATcodigo <> 'N'
			</cfquery>
			<!--- no mostrar tipos de documento de nomina --->
			<select name="CSATcodigo" id="CSATcodigo">
				<option value=""> -- Seleccione --</option>
				<cfoutput query="rsTipoComp">
					<option value="#CSATcodigo#" <cfif modo NEQ 'ALTA' AND CSATcodigo eq rsTipoTransacciones.ClaveSAT>selected</cfif>>#CSATdescripcion#</option>
				</cfoutput>
			</select>
		</td>
	</tr>
    <tr>
		<td width="50%" align="right">
			<input name="CCTnoflujoefe" tabindex="1" type="checkbox"
			  	id="CCTnoflujoefe" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CCTnoflujoefe EQ 1>checked</cfif>></td>
        <td align="left"><label for="CCTnoflujoefe" style="font-style:normal; font-variant:normal; font-weight:normal">No Genera flujo de efectivo</label>
    </tr>

    <tr>
		<td width="50%" align="right">
			<input name="CCTafectacostoventas" type="checkbox" id="CCTafectacostoventas"
				tabindex="1" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CCTafectacostoventas EQ 1>checked</cfif>>
		</td>
        <td>
			<label for="CCTafectacostoventas" style="font-style:normal; font-variant:normal; font-weight:normal">Afecta solo Costo de Ventas</label>
		</td>
    </tr>

    <tr id="bloqueChk1">
		<td width="50%" align="right">
		  <input name="CCTpago" type="checkbox" id="CCTpago" tabindex="1"
		  	onClick="javascript: showPagos(this.form);" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CCTpago EQ 1>checked</cfif>>
		</td>
		<td>
			<label for="CCTpago" style="font-style:normal; font-variant:normal; font-weight:normal"> Transacci&oacute;n de Pago</label>
		</td>
    </tr>

	<tr id="bloqueChk2">
		<td align="right">
		  <input name="CCTtranneteo" type="checkbox" id="CCTtranneteo" tabindex="1"  <cfif modo NEQ "ALTA" and rsTipoTransacciones.CCTtranneteo EQ 1>checked</cfif>>
		</td>
		<td>
			<label for="CCTtranneteo"  style="font-style:normal; font-variant:normal; font-weight:normal">Transacci&oacute;n Neteo</label>
		</td>
    </tr>
	<!--- CCTCompensacion --->
	<tr id="bloqueChk5">
		<td align="right">
		  <input name="CCTCompensacion" type="checkbox" id="CCTCompensacion" tabindex="1"  <cfif modo NEQ "ALTA" and rsTipoTransacciones.CCTCompensacion EQ 1>checked</cfif>>
		</td>
		<td>
			<label for="CCTCompensacion"  style="font-style:normal; font-variant:normal; font-weight:normal">Compensaci&oacute;n Documentos</label>
		</td>
    </tr>
	<tr id="bloqueChk3">
		<td align="right">
		  <input name="CCTestimacion"  onclick="javascript: showref(this.form);" type="checkbox" id="CCTestimacion" tabindex="1"  <cfif modo NEQ "ALTA" and rsTipoTransacciones.CCTestimacion EQ 1>checked</cfif>>
		</td>
		<td>
			<label for="CCTestimacion"  style="font-style:normal; font-variant:normal; font-weight:normal">Estimación</label>
		</td>
    </tr>
	<tr id="bloqueChk4">
		<td align="right">
			<label for="CCTestimacion"  style="font-style:normal; font-variant:normal; font-weight:normal">Tipo de transacci&oacute;n referenciada</label>
		</td>
		<td>
			<cfset ArrayTrREF=ArrayNew(1)>
			<cfif isdefined("rsTipoTransacciones.CCTCodigoRef") and len(trim(rsTipoTransacciones.CCTCodigoRef))>
				<cfquery name="rsTrREF" datasource="#session.dsn#">
				  select CCTcodigo as CCTCodigoRef,CCTdescripcion as CCTdescripcionRef
				  from CCTransacciones
				  where Ecodigo = #Session.Ecodigo#
				  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTipoTransacciones.CCTCodigoRef#" >
				</cfquery>

				<cfset ArrayAppend(ArrayTrREF,rsTrREF.CCTCodigoRef)>
				<cfset ArrayAppend(ArrayTrREF,rsTrREF.CCTdescripcionRef)>
			</cfif>
			<cfif modo EQ "ALTA">
				<cf_conlis
				Campos="CCTCodigoRef,CCTdescripcionRef"
				Desplegables="S,S"
				Modificables="S,N"
				Size="2,43"
				tabindex="1"
				ValuesArray="#ArrayTrREF#"
				Title="Lista de tipos de transacciones referenciadas"
				Tabla="CCTransacciones "
				Columnas="CCTcodigo as CCTCodigoRef,CCTdescripcion as CCTdescripcionRef"
				Filtro=" Ecodigo = #Session.Ecodigo# and  CCTtipo != $CCTtipo,char$"
				Desplegar="CCTCodigoRef,CCTdescripcionRef"
				Etiquetas="C&oacute;digo,Descripci&oacute;n"
				filtrar_por="CCTcodigo,CCTdescripcion"
				Formatos="S,S"
				Align="left,left"
				form="form1"
				Asignar="CCTCodigoRef,CCTdescripcionRef"
				Asignarformatos="S,S"/>
			<cfelse>
				<cf_conlis
				Campos="CCTCodigoRef,CCTdescripcionRef"
				Desplegables="S,S"
				Modificables="S,N"
				Size="2,43"
				tabindex="1"
				ValuesArray="#ArrayTrREF#"
				Title="Lista de tipos de transacciones referenciadas"
				Tabla="CCTransacciones "
				Columnas="CCTcodigo as CCTCodigoRef,CCTdescripcion as CCTdescripcionRef"
				Filtro=" Ecodigo = #Session.Ecodigo# and CCTcodigo != $CCTcodigo,char$ and  CCTtipo != $CCTtipo,char$"
				Desplegar="CCTCodigoRef,CCTdescripcionRef"
				Etiquetas="C&oacute;digo,Descripci&oacute;n"
				filtrar_por="CCTcodigo,CCTdescripcion"
				Formatos="S,S"
				Align="left,left"
				form="form1"
				Asignar="CCTCodigoRef,CCTdescripcionRef"
				Asignarformatos="S,S"/>
			</cfif>

		</td>
    </tr>
    <tr>
      <td colspan="2">
        <table id="bloquePagos" width="100%" border="0" align="center" style="display: none">
          <tr>
            <td width="50%" align="right">Transacci&oacute;n Bancaria:</td>
            <td>
              <select name="BTid" id="BTid" tabindex="1">
                <cfoutput query="rsTransaccionesBancarias">
                  <option value="#BTid#" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CCTpago EQ 1 and rsTipoTransacciones.BTid EQ rsTransaccionesBancarias.BTid>selected</cfif>>#BTdescripcion#</option>
                </cfoutput>
              </select>
            </td>
          </tr>
          <tr>
            <td align="right">Tipo de Pago:</td>
            <td>
              <select name="CCTcktr" id="CCTcktr" tabindex="1">
                <option value="C" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CCTcktr EQ "C">selected</cfif>>Cheque</option>
                <option value="E" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CCTcktr EQ "E">selected</cfif>>Efectivo</option>
                <option value="T" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CCTcktr EQ "T">selected</cfif>>Transferencia</option>
                <option value="P" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CCTcktr EQ "P">selected</cfif>>Tarjeta</option>
              </select>
            </td>
          </tr>
        </table>
      </td>
    </tr>
	<!--- *************************************************** --->
	<cfif modo NEQ 'ALTA'>
		<tr>
		  <td colspan="2" align="center" class="tituloListas">Complementos Contables</td>
		</tr>
		<tr><td colspan="2" align="center">
		<cf_sifcomplementofinanciero action='display' tabindex="1"
				tabla="CCTransacciones"
				form = "form1"
				llave="#form.CCTcodigo#" />
		</td></tr>
	</cfif>
	<!--- *************************************************** --->
    <tr>
      <td colspan="2" nowrap>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" align="center" nowrap>
		<!--- <cfset tabindex = 2 >
        <cfinclude template="../../portlets/pBotones.cfm"> --->
		<cf_botones modo="#modo#" tabindex="1">
      </td>
    </tr>
  </table>
<cfset ts = "">
  <cfif modo NEQ "ALTA">
    <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsTipoTransacciones.ts_rversion#"/>
	</cfinvoke>
</cfif>
  <input tabindex="-1" type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
 </form>


<!--- <cf_qforms>
	<cf_qformsRequiredField name="CCTcodigo" description="Código">
	<cf_qformsRequiredField name="CCTdescripcion" description="Descripción">
</cf_qforms> --->
<cf_qforms>
<script language="JavaScript" type="text/javascript">
	objForm.CCTcodigo.required = true;
	objForm.CCTcodigo.description = 'Código';

	objForm.CCTdescripcion.required = true;
	objForm.CCTdescripcion.description = 'Descripción';

	objForm.CCTdescripcion.required = true;
	objForm.CCTCodigoRef.description = 'Tipo de transacción referenciada';


	function eshabilitarValidacion(){
		objForm.CCTcodigo.required = false;
		objForm.CCTdescripcion.required = false;
		objForm.CCTdescripcion.required = false;
	}

	showChkbox(document.form1);
	showPagos(document.form1);
	showref(document.form1);
	<cfif modo NEQ 'ALTA'>
		document.form1.CCTdescripcion.focus();
	<cfelse>
		document.form1.CCTcodigo.focus();
	</cfif>
</script>