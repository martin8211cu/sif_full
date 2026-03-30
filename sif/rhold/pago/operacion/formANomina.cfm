<!--- Manejo de la navegación --->
<cfset _mostrarLista = isDefined("Form._Filtrar")>
<cfif isDefined('Url.ERNid') and not isDefined('Form.ERNid')>
	<cfset Form.ERNid = Url.ERNid>
	<cfset _mostrarLista = true>
</cfif>
<cfif not isDefined('Form.ERNid')>
	<cflocation url="listaANomina.cfm">
</cfif>
<cfset navegacion = "ERNid=" & Form.ERNid>
<cfset filtro = "">
<!--- Consultas --->
<!--- Encabezado de Registro de Nómina --->
<cfquery name="rsERNomina" datasource="#Session.DSN#">
select 	convert(varchar,ERN.ERNid) as ERNid, 
		ERN.ERNcapturado, 
		convert(varchar,ERNfcarga,103) as ERNfcarga, 
		Tdescripcion, 
		convert(varchar,isnull(CB.CBcc,ERN.CBcc)) as CBcc, 
		CBdescripcion, Mnombre, Msimbolo, Miso4217,
		convert(varchar,ERNfdeposito,103) as ERNfdeposito, 
		convert(varchar,ERNfinicio,103) as ERNfinicio, 
		convert(varchar,ERNffin,103) as ERNffin, 
		convert(varchar,ERNfechapago,103) as ERNfechapago, 
		ERNdescripcion, 
		(select isnull (sum (DRNliquido), 0)
	FROM DRNomina c WHERE c.ERNid = ERN.ERNid) as Importe
	from ERNomina ERN, TiposNomina T, Monedas M, CuentasBancos CB
	where ERN.Ecodigo = T.Ecodigo and ERN.Tcodigo = T.Tcodigo
    	and CB.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		and ERN.Mcodigo = M.Mcodigo
		and ERN.CBcc *= CB.CBcc
		and ERN.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and ERN.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
		and ERNestado = 3
</cfquery>
<!--- Integridad: Protege integridad de datos en caso de pantalla cargada con cache. --->
<cfif rsERNomina.RecordCount lte 0>
	<cflocation url="listaANomina.cfm">
</cfif>
<!--- Histórico del Encabezado de Registro de Nómina --->
<cfquery name="rsHERNomina" datasource="#Session.DSN#">
select 	1
	from HERNomina
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ERNid#">
</cfquery>
<!--- Cuenta Cliente --->
<cfquery name="rsCuentasCliente" datasource="#Session.DSN#">
	select convert(varchar,CBcc) as CBcc, CBdescripcion
	from CuentasBancos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    	and CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
		and CBid not in (Select c.Bid from ECuentaBancaria d, Bancos e, CuentasBancos c
							where e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							and d.Bid = e.Bid and d.CBid = c.CBid and d.ECaplicado = 'N' and d.EChistorico = 'N')
                            and c.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
	order by CBcodigo, CBdescripcion
</cfquery>
<!--- Funciones de Javascript --->
<script language="JavaScript" type="text/javascript" src="../../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/javascript">
 	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	// funciones del form
	function mostrarLista() {
		var div_Lista = document.getElementById("div_Lista");
		var div_Mostrar = document.getElementById("div_Mostrar");
		var div_Ocultar = document.getElementById("div_Ocultar");
		div_Lista.style.display = '';
		div_Mostrar.style.display = 'none';
		div_Ocultar.style.display = '';
	}
	function ocultarLista() {
		var div_Lista = document.getElementById("div_Lista");
		var div_Mostrar = document.getElementById("div_Mostrar");
		var div_Ocultar = document.getElementById("div_Ocultar");
		div_Lista.style.display = 'none';
		div_Mostrar.style.display = '';
		div_Ocultar.style.display = 'none';
	}	
	function noValidar() {
		objForm.fecha.required = false;
		return true;
	}
</script>

<table width="75%" border="0" cellspacing="3" cellpadding="0" align="center" style="margin-left: 10px; margin-right: 10px;">
  <tr> 
		<td nowrap colspan="4">&nbsp;</td>
	</tr>
	<tr> 
		<td nowrap colspan="4" align="center" bgcolor="#E2E2E2" class="subTitulo">ENCABEZADO DEL REGISTRO DE LA NOMINA</td>
	</tr>
	<cfoutput>
	<form action="SQLANomina.cfm" method="post" name="form">
	<tr>
		<td nowrap colspan="1" class="fileLabel">N&uacute;mero:</td>		
		<td nowrap>&nbsp;#rsERNomina.ERNid#</td>
		<td nowrap colspan="1" class="fileLabel">Descripci&oacute;n:</td>		
		<td nowrap>&nbsp;#rsERNomina.ERNdescripcion#</td>
	</tr>
	<tr> 
		<td nowrap class="fileLabel">Tipo N&oacute;mina:</td>
		<td nowrap>&nbsp;#rsERNomina.Tdescripcion#</td>
		<td nowrap class="fileLabel">Cuenta Cliente:</td>
		<td nowrap>&nbsp;(#rsERNomina.CBcc#) #rsERNomina.CBdescripcion#</td>
	</tr>
	<tr> 
		<td nowrap class="fileLabel">Fecha Creaci&oacute;n:</td>
		<td nowrap>&nbsp;#LSDateFormat(rsERNomina.ERNfcarga,"dd/mmm/yyyy")#</td>
		<td nowrap class="fileLabel">Fecha Dep&oacute;sito:</td>
		<td nowrap>&nbsp;#LSDateFormat(rsERNomina.ERNfdeposito,"dd/mmm/yyyy")#</td>
	</tr>
	<tr>
		<td nowrap class="fileLabel">Fecha Inicio Pago:</td>
		<td nowrap>&nbsp;#LSDateFormat(rsERNomina.ERNfinicio,"dd/mmm/yyyy")#</td>
		<td nowrap class="fileLabel">Fecha Final Pago:</td> 
		<td nowrap>&nbsp;#LSDateFormat(rsERNomina.ERNffin,"dd/mmm/yyyy")#</td>
						 
	</tr>
	<tr>
		<td nowrap class="fileLabel">Importe Total:</td>
		<td nowrap>&nbsp;#rsERNomina.Msimbolo# #LsCurrencyFormat(rsERNomina.Importe,"none")# (#rsERNomina.Miso4217#)</td>
		<td nowrap class="fileLabel">Moneda:</td>
		<td nowrap>&nbsp;#rsERNomina.Mnombre#</td>
	</tr>

	<tr>
		<td nowrap valign="top" class="fileLabel">Fecha de Pago:</td>
		<td nowrap valign="top"><cf_sifcalendario form="form" name="fecha" value="#rsERNomina.ERNfechapago#" valign="top"></td>
		<td nowrap valign="top" class="fileLabel">Hora de Pago:</td>
		<td nowrap valign="top">
			<select name="hhp" id="hhp">
				<option value="00" selected>12
				<option value="01">1
				<option value="02">2
				<option value="03">3
				<option value="04">4
				<option value="05">5
				<option value="06">6
				<option value="07">7
				<option value="08">8
				<option value="09">9
				<option value="10">10
				<option value="11">11
			</select><select name="mmp" id="mmp">
				<option value="00" selected>00
				<option value="15">15
				<option value="30">30
				<option value="45">45
			</select><select name="ampmp" id="ampmp">
				<option value="am" selected>am
				<option value="pm">pm
			</select>
		</td>
	</tr>
	<tr>
		<td nowrap colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td nowrap colspan="4" align="center">
				<input name="ERNid" type="hidden" value="#Form.ERNid#">
				<input name="autorizar" type="submit" id="autorizar" value="Autorizar" onClick="javascript: confirm('¿Confirma que desea Autorizar la Nómina para Pagarla?');">
				<input name="anular" type="submit" id="anular" value="Anular" onClick="javascript: return confirm('¿Confirma que desea anular la Nómina?') && noValidar();">
				<cfif rsHERNomina.RecordCount eq 0>
					<input name="revisar" type="submit" id="revisar" value="Enviar a revisi&oacute;n" onClick="javascript: return confirm('¿Confirma que desea pasar a Revisión?') && noValidar();">
				</cfif>
		</td>
	</tr>
	<tr>
		<td nowrap colspan="4">&nbsp;</td>
	</tr>
	</form>
	</cfoutput>
	<tr> 
		<td nowrap align="center" bgcolor="#E2E2E2" class="subTitulo" colspan="4">
			<div id="div_Mostrar" style="display:;">
				<a href="javascript: mostrarLista();">
					Mostrar Detalle&nbsp;&nbsp;&nbsp;
					<img src="../../imagenes/abajo.gif" border="0" alt="Mostrar Lista del detalle del Registro de la Nómina">
					&nbsp;&nbsp;&nbsp;
					LISTA DEL DETALLE DEL REGISTRO DE LA NOMINA
					&nbsp;&nbsp;&nbsp;
					<img src="../../imagenes/abajo.gif" border="0" alt="Mostrar Lista del detalle del Registro de la Nómina">
					&nbsp;&nbsp;&nbsp;Mostrar Detalle
				</a>
			</div>
			<div id="div_Ocultar" style="display:none;">
				<a href="javascript: ocultarLista();">
					Ocultar Detalle&nbsp;&nbsp;&nbsp;
					<img src="../../imagenes/arriba.gif" border="0" alt="Ocultar Lista del detalle del Registro de la Nómina">
					&nbsp;&nbsp;&nbsp;
					LISTA DEL DETALLE DEL REGISTRO DE LA NOMINA
					&nbsp;&nbsp;&nbsp;
					<img src="../../imagenes/arriba.gif" border="0" alt="Ocultar Lista del detalle del Registro de la Nómina">
					&nbsp;&nbsp;&nbsp;Ocultar Detalle
				</a>
			</div>
		</td>
	</tr>
	<tr> 
		<td nowrap colspan="4">
			<div id="div_Lista" style="display:none;">
			<cfinclude template="filtroDNomina.cfm">
			<cfinclude template="listaDNomina.cfm">
			</div>
			<cfif _mostrarLista>
				<script language="JavaScript" type="text/javascript">
					mostrarLista();
				</script>
			</cfif>
		</td>
	</tr>
	<tr> 
		<td nowrap colspan="4">&nbsp;</td>
	</tr>
	<tr> 
		<td nowrap colspan="4">			
			<table width="100%" border="0" align="center" cellpadding="2" cellspacing="2" class="ayuda">
				<tr> 
					<td width="7%" nowrap><img src="../../../imagenes/Check01_T.gif" width="24" height="24"></td>
					<td width="93%" nowrap class="fileLabel">&nbsp;Si autoriza, indique la fecha y hora en que se ordenar&aacute; el pago.</strong></td>
				</tr>
			</table>
		</td>
	</tr>
	<tr> 
		<td nowrap colspan="4">&nbsp;</td>
	</tr>
</table>
<script language="JavaScript" type="text/javascript">
	//Validaciones del Encabezado Registro de Nomina
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form");
	//Funciones adicionales de validación
	/*Es cargado en el filtro de la lista por lo que si se carga aquí da un mensaje informando que ya fue cargado 
	pero esto aparenta ser un error y no se ve bien
	function _Field_isFecha(){
		fechaBlur(this.obj);
		if (this.obj.value.length!=10)
			this.error = "El campo " + this.description + " debe contener una fecha válida.";
	}
	_addValidator("isFecha", _Field_isFecha);*/
	//Validaciones del Encabezado
	objForm.fecha.required = true;
	objForm.fecha.description = "Fecha de Pago";
	objForm.fecha.validateFecha();
	//objForm.fecha.validate = true;
</script>