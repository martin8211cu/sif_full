<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 28 de junio del 2005
	Motivo:	corrección de error en la linea 155, la referencia a la consulta esta mal,
			bebia ser rsTipoTransacciones en lugar de rsForm
----------->
<cfif isdefined('url.filtro_CPTcodigo') and not isdefined('form.filtro_CPTcodigo')>
	<cfset form.filtro_CPTcodigo = url.filtro_CPTcodigo>
</cfif>
<cfif isdefined('url.filtro_CPTdescripcion') and not isdefined('form.filtro_CPTdescripcion')>
	<cfset form.filtro_CPTdescripcion = url.filtro_CPTdescripcion>
</cfif>
<cfif isdefined('url.filtro_CPTtipo') and not isdefined('form.filtro_CPTtipo')>
	<cfset form.filtro_CPTtipo = url.filtro_CPTtipo>
</cfif>
<cfif isdefined('url.hfiltro_CPTcodigo') and not isdefined('form.hfiltro_CPTcodigo')>
	<cfset form.hfiltro_CPTcodigo= url.hfiltro_CPTcodigo>
</cfif>
<cfif isdefined('url.hfiltro_CPTdescripcion') and not isdefined('form.hfiltro_CPTdescripcion')>
	<cfset form.hfiltro_CPTdescripcion= url.hfiltro_CPTdescripcion>
</cfif>
<cfif isdefined('url.hfiltro_CPTtipo') and not isdefined('form.hfiltro_CPTtipo')>
	<cfset form.hfiltro_CPTtipo= url.hfiltro_CPTtipo>
</cfif>

<cfset modo = 'ALTA' >
<cfif isdefined("form.CPTcodigo") and len(trim(form.CPTcodigo))>
	<cfset modo = 'CAMBIO' >
</cfif>

<cfquery name="rsTransaccionesBancarias" datasource="#Session.DSN#">
	select <cf_dbfunction name="to_char" args="a.BTid"> as BTid,
		a.BTdescripcion
			from BTransacciones a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				 and Exists (select 1
	  				   from Parametros b
					   where a.BTid = <cf_dbfunction name="to_number" args="b.Pvalor">
					   		and  b.Ecodigo = a.Ecodigo
					         and b.Pcodigo between 160 and 170)
</cfquery>

<cfif isDefined("Form.CPTcodigo") and len(trim(Form.CPTcodigo)) NEQ 0>
	<cfquery name="rsTipoTransacciones" datasource="#Session.DSN#">
		select CPTcodigo, CPTdescripcion, CPTtipo, CPTvencim, CPTpago, BTid, CPTcktr, CPTanticipo, CPTafectacostoventas,
				CPTnoflujoefe, FMT01COD, ts_rversion, CPTcodigoext, cuentac, CPTestimacion, CPTCodigoRef, CPTremision, CPTCompensacion
		from CPTransacciones
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPTcodigo#" >
		order by CPTcodigo asc
	</cfquery>
</cfif>

<cfquery name="rsFormatos" datasource="#Session.DSN#">
	select FMT01COD, FMT01DES
	from FMT001
	where FMT01TIP = 13
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	order by FMT01COD
</cfquery>

<cf_templatecss>
<script type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>

<body>
<script language="JavaScript" type="text/javascript">
	function showPagos(f) {
		var opcion = document.getElementById('CPTpago').value;
		var p = document.getElementById("bloquePagos");
		if (opcion == 1) {
			p.style.display = "";
		} else {
			p.style.display = "none";
		}
	}

	function showChkbox(f) {
		var p = document.getElementById("bloqueChk");
		if (f.CPTtipo.value == 'D') {
			p.style.display = "";
		} else {
			p.style.display = "none";
		}
	}

	function showref(f) {
		var p4 = document.getElementById("bloqueChk4");
		if (f.CPTestimacion.checked) {
			p4.style.display = "";
		} else {
			p4.style.display = "none";
		}
	}

	function Estimacion(f) {
		if (f.CPTestimacion.checked)
		  {
			f.CPTremision.checked = false;
		  }
		}

	function Remision(f) {
		if (f.CPTremision.checked)
		  {
			f.CPTestimacion.checked = false;
			showref(f);
		  }
		}

	function validar(form){
		if (form.botonSel.value != 'Baja' && form.botonSel.value != 'Nuevo'){
			var mensaje = 'Se presentaron los siguientes errores:\n';
			var error = false;

			if ( trim(form.CPTcodigo.value) == '' ){
				mensaje = mensaje + ' - El campo código de tipo transacción es requerido.\n'
				error = true;
			}

			if ( trim(form.CPTdescripcion.value) == '' ){
				mensaje = mensaje + ' - El campo descripción de tipo transacción es requerido.\n'
				error = true;
			}

			if ( trim(form.CPTvencim.value) == '' ){
				mensaje = mensaje + ' - El campo vencimiento en días es requerido.\n'
				error = true;
			}
			if (form.CPTestimacion.checked){
				if ( trim(form.CPTCodigoRef.value) == '' ){
					mensaje = mensaje + ' - El campo tipo de transacción referenciada es requerido.\n'
					error = true;
				}
			}
			if (error){
				alert(mensaje);
			}
			return !error;

		}
		else{
			return true;
		}
	}
</script>

<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
<form action="SQLTipoTransacciones.cfm" method="post" name="form1" onSubmit="return validar(this);" onReset="this.CPTtipo.selectedIndex=0;showChkbox(this);this.CPTpago.checked=false;showPagos(this);">
	<cfoutput>
		<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">
		<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">
		<input name="filtro_CPTcodigo" type="hidden" tabindex="-1" value="<cfif isdefined('form.filtro_CPTcodigo')>#form.filtro_CPTcodigo#</cfif>">
		<input name="filtro_CPTdescripcion" tabindex="-1" type="hidden" value="<cfif isdefined('form.filtro_CPTdescripcion')>#form.filtro_CPTdescripcion#</cfif>">
		<input name="filtro_CPTtipo" tabindex="-1" type="hidden" value="<cfif isdefined('form.filtro_CPTtipo')>#form.filtro_CPTtipo#</cfif>">
	</cfoutput>

  <table width="100%" align="center" cellpadding="1" cellspacing="0" border="0">
     <tr>
      <td width="50%" align="right" valign="middle" nowrap> C&oacute;digo:&nbsp;</td>
      <td width="50%">
        <input  name="CPTcodigo" type="text" tabindex="1" <cfif modo NEQ 'ALTA'>readonly</cfif>  value="<cfif modo NEQ 'ALTA'><cfoutput>#rsTipoTransacciones.CPTcodigo#</cfoutput></cfif>" size="5" maxlength="2" onFocus="this.select();" alt="El campo Código del Tipo de Transacción">
        <div align="right"></div>
      </td>
    </tr>
    <tr>
      <td align="right" valign="middle" nowrap>Descripci&oacute;n:&nbsp;</td>
      <td>
        <input name="CPTdescripcion" type="text" tabindex="1" value="<cfif #modo# NEQ "ALTA"><cfoutput>#rsTipoTransacciones.CPTdescripcion#</cfoutput></cfif>" size="50" maxlength="80" onFocus="this.select();" alt="El campo Descripción del Tipo de Transacción">
      </td>
    </tr>
	<tr>
	  	<td align="right" valign="middle" nowrap>C&oacute;digo Externo </td>
		<td nowrap>
			<input name="CPTcodigoext" tabindex="1" type="text" size="30"  maxlength="25" value="<cfif modo NEQ "ALTA"><cfoutput>#Trim(rsTipoTransacciones.CPTcodigoext)#</cfoutput></cfif>" >
		</td>
	</tr>
    <tr>
      <td align="right" valign="middle" nowrap>Vencimiento en D&iacute;as:&nbsp;</td>
      <td nowrap>
		<input type="text" tabindex="1" name="CPTvencim" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsTipoTransacciones.CPTvencim#</cfoutput><cfelse>0.00</cfif>"  size="8" maxlength="8" style="text-align: right;" onBlur="javascript:fm(this,0); "  onfocus="javascript:this.value=qf(this); this.select();"  onkeyup="javascript:if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" alt="El campo Vencimiento en Días" >
	  </td>
    </tr>

    <tr>
      <td align="right" valign="middle" nowrap>Tipo:&nbsp;</td>
      <td>
        <select name="CPTtipo" onChange="javascript: showChkbox(this.form);" tabindex="1" >
          <option value="D" <cfif (isDefined("rsTipoTransacciones.CPTtipo") AND "D" EQ rsTipoTransacciones.CPTtipo)>selected</cfif>>Débito</option>
          <option value="C" <cfif (isDefined("rsTipoTransacciones.CPTtipo") AND "C" EQ rsTipoTransacciones.CPTtipo)>selected</cfif>>Crédito</option>
        </select>
      </td>
    </tr>

    <tr>
      <td nowrap align="right">Formato de Impresi&oacute;n:&nbsp;</td>
      <td nowrap>
	  	<select name="FMT01COD" tabindex="1">
		<option value="">-- seleccionar formato--</option>
		<cfloop query="rsFormatos">
			<option value="#rsFormatos.FMT01COD#" <cfif modo neq "ALTA" and Trim(rsTipoTransacciones.FMT01COD) eq Trim(FMT01COD)>selected</cfif> >#rsFormatos.FMT01DES#</option>
		</cfloop>
		</select>
      </td>
    </tr>

	<tr>
	  <td nowrap align="right">Complemento:&nbsp;</td>
		<td nowrap>
			<input type="text" tabindex="1" name="cuentac" size="12" maxlength="100" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsTipoTransacciones.cuentac#</cfoutput></cfif>" alt="Complemento">
		</td>
	</tr>


    <tr>
      <td colspan="2" align="right" valign="middle" nowrap>
        <table width="100%" border="0" >
          <tr>
            <td width="50%" align="right">No Genera flujo de efectivo:&nbsp;</td>
            <td>
              <input name="CPTnoflujoefe" type="checkbox" id="CPTnoflujoefe" tabindex="1" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CPTnoflujoefe EQ 1>checked</cfif>>
            </td>
          </tr>
        </table>
      </td>
    </tr>

    <tr>
      <td colspan="2" align="right" valign="middle" nowrap>
        <table width="100%" border="0" >
          <tr>
            <td width="50%" align="right">Afecta solo Costo de Ventas:&nbsp;</td>
            <td>
              <input name="CPTafectacostoventas" type="checkbox" id="CPTafectacostoventas" tabindex="1" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CPTafectacostoventas EQ 1>checked</cfif>>
            </td>
          </tr>
        </table>
      </td>
    </tr>

    <tr id="bloqueChk3">
      <td colspan="2" align="right" valign="middle" nowrap>
        <table width="100%" border="0">
          <tr>
            <td width="50%" align="right">Estimación:&nbsp;</td>
            <td>
              <input name="CPTestimacion"  onclick="javascript: showref(this.form); Estimacion(this.form);" type="checkbox" id="CPTestimacion" tabindex="1"  <cfif modo NEQ "ALTA" and rsTipoTransacciones.CPTestimacion EQ 1>checked</cfif>>
            </td>
          </tr>
        </table>
      </td>
    </tr>

    <tr id="bloqueChk3a">
      <td colspan="2" align="right" valign="middle" nowrap>
        <table width="100%" border="0">
          <tr>
            <td width="50%" align="right">Remisión:&nbsp;</td>
            <td>
              <input name="CPTremision" onClick="javascript: Remision(this.form);" type="checkbox" id="CPTremision" tabindex="1"  <cfif modo NEQ "ALTA" and rsTipoTransacciones.CPTremision EQ 1>checked</cfif>>
            </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr>
      <td colspan="2" align="right" valign="middle" nowrap>
        <table width="100%" border="0">
          <tr>
            <td width="50%" align="right">Compensaci&oacute;n Docs CxC:&nbsp;</td>
            <td>
              <input name="CPTCompensacion" type="checkbox" id="CPTCompensacion" tabindex="1"  <cfif modo NEQ "ALTA" and rsTipoTransacciones.CPTCompensacion EQ 1>checked</cfif>>
            </td>
          </tr>
        </table>
      </td>
    </tr>
	<!---SML 06/04/2015 Inicio. Modificacion para saber que tipo de transaccion es : CxP, Pago, Anticipo para la Aplicacion de Documentos de Pagos o Anticipos--->
    <tr>
      <td colspan="2" align="right" valign="middle" nowrap>
        <table width="100%" border="0" id="bloqueChk">
          <tr>
            <td width="50%" align="right">Transacci&oacute;n:&nbsp;</td>  <!---de Pago--->
            <td>
           	  <select id="CPTpago" name="CPTpago" onChange="javascript: showPagos(this.form);" >
              	<option value="0" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CPTpago EQ 0 and rsTipoTransacciones.CPTanticipo EQ 0>selected</cfif>>Nota de Cr&eacute;dito</option>
                <option value="1" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CPTpago EQ 1 and rsTipoTransacciones.CPTanticipo EQ 0>selected</cfif>>Pago</option>
                <option value="2" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CPTpago EQ 0 and rsTipoTransacciones.CPTanticipo EQ 1>selected</cfif>>Anticipo</option>
              </select>
              <!---<input name="CPTpago" type="checkbox" id="CPTpago" tabindex="1" onClick="javascript: showPagos(this.form);" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CPTpago EQ 1>checked</cfif>>--->
            </td>
          </tr>
        </table>
      </td>
    </tr>
	<!---SML 06/04/2015 Final. Modificacion para saber que tipo de transaccion es : CxP, Pago, Anticipo para la Aplicacion de Documentos de Pagos o Anticipos--->
	<tr id="bloqueChk4">
		<td align="right">
			Tipo de transacci&oacute;n referenciada
		</td>
		<td>
			<cfset ArrayTrREF=ArrayNew(1)>
			<cfif isdefined("rsTipoTransacciones.CPTCodigoRef") and len(trim(rsTipoTransacciones.CPTCodigoRef))>
				<cfquery name="rsTrREF" datasource="#session.dsn#">
				  select CPTcodigo as CPTCodigoRef,CPTdescripcion as CPTdescripcionRef
				  from CPTransacciones
				  where Ecodigo = #Session.Ecodigo#
				  and CPTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTipoTransacciones.CPTCodigoRef#" >
				</cfquery>

				<cfset ArrayAppend(ArrayTrREF,rsTrREF.CPTCodigoRef)>
				<cfset ArrayAppend(ArrayTrREF,rsTrREF.CPTdescripcionRef)>
			</cfif>
			<cfif modo EQ "ALTA">
				<cf_conlis
				Campos="CPTCodigoRef,CPTdescripcionRef"
				Desplegables="S,S"
				Modificables="S,N"
				Size="2,43"
				tabindex="1"
				ValuesArray="#ArrayTrREF#"
				Title="Lista de tipos de transacciones referenciadas"
				Tabla="CPTransacciones "
				Columnas="CPTcodigo as CPTCodigoRef,CPTdescripcion as CPTdescripcionRef"
				Filtro=" Ecodigo = #Session.Ecodigo# and  CPTtipo != $CPTtipo,char$"
				Desplegar="CPTCodigoRef,CPTdescripcionRef"
				Etiquetas="C&oacute;digo,Descripci&oacute;n"
				filtrar_por="CPTcodigo,CPTdescripcion"
				Formatos="S,S"
				Align="left,left"
				form="form1"
				Asignar="CPTCodigoRef,CPTdescripcionRef"
				Asignarformatos="S,S"/>
			<cfelse>
				<cf_conlis
				Campos="CPTCodigoRef,CPTdescripcionRef"
				Desplegables="S,S"
				Modificables="S,N"
				Size="2,43"
				tabindex="1"
				ValuesArray="#ArrayTrREF#"
				Title="Lista de tipos de transacciones referenciadas"
				Tabla="CPTransacciones "
				Columnas="CPTcodigo as CPTCodigoRef,CPTdescripcion as CPTdescripcionRef"
				Filtro=" Ecodigo = #Session.Ecodigo# and CPTcodigo != $CPTcodigo,char$   and  CPTtipo != $CPTtipo,char$"
				Desplegar="CPTCodigoRef,CPTdescripcionRef"
				Etiquetas="C&oacute;digo,Descripci&oacute;n"
				filtrar_por="CPTcodigo,CPTdescripcion"
				Formatos="S,S"
				Align="left,left"
				form="form1"
				Asignar="CPTCodigoRef,CPTdescripcionRef"
				Asignarformatos="S,S"/>
			</cfif>

		</td>
    </tr>

    <tr>
      <td colspan="2">
        <table id="bloquePagos" width="100%" border="0" align="center" style="display: none">
          <tr>
            <td width="50%" align="right">Transacci&oacute;n Bancaria:&nbsp;</td>
            <td>
              <select name="BTid" id="BTid" tabindex="1">
                <cfoutput query="rsTransaccionesBancarias">
                  <option value="#BTid#" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CPTpago EQ 1 and rsTipoTransacciones.BTid EQ rsTransaccionesBancarias.BTid>selected</cfif>>#BTdescripcion#</option>
                </cfoutput>
              </select>
            </td>
          </tr>
          <tr>
            <td align="right">Tipo de Pago:&nbsp;</td>
            <td>
              <select name="CPTcktr" id="CPTcktr" tabindex="1">
                <option value="C" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CPTcktr EQ "C">selected</cfif>>Cheque</option>
                <option value="T" <cfif modo NEQ "ALTA" and rsTipoTransacciones.CPTcktr EQ "T">selected</cfif>>Transferencia</option>
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
		<cf_sifcomplementofinanciero action='display'
				tabla="CPTransacciones"
				form = "form1"
				llave="#form.CPTcodigo#" />
		</td></tr>
	</cfif>
	<!--- *************************************************** --->
    <tr>
      <td colspan="2" nowrap>&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2" align="center" nowrap>
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
  <input type="hidden" name="ts_rversion" value="<cfif #modo# NEQ "ALTA"><cfoutput>#ts#</cfoutput></cfif>" size="32">
 </form>
<script language="JavaScript" type="text/javascript">
	showChkbox(document.form1);
	showPagos(document.form1);
	showref(document.form1);
</script>