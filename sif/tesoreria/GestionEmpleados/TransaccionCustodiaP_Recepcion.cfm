<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_NumComision" default = "N&uacute;m. Comisi&oacute;n" returnvariable="LB_NumComision" xmlfile = "TransaccionCustodiaP_Recepcion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" default = "Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile = "TransaccionCustodiaP_Recepcion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Empleado" default = "Empleado" returnvariable="LB_Empleado" xmlfile = "TransaccionCustodiaP_Recepcion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CentroFuncional" default = "Centro Funcional" returnvariable="LB_CentroFuncional" xmlfile = "TransaccionCustodiaP_Recepcion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_NoSeEncontraronRegistros" default = "No se encontraron Registros" returnvariable="MSG_NoSeEncontraronRegistros" xmlfile = "TransaccionCustodiaP_Recepcion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_RecibirEfectivo" default = "Recibir Efectivo" returnvariable="BTN_RecibirEfectivo" xmlfile = "TransaccionCustodiaP_Recepcion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Errores" default = "Se encontraron los siguientes errores" returnvariable="LB_Errores" xmlfile = "TransaccionCustodiaP_Recepcion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CampoDescripcion" default = "La Descripcion es obligatoria" 
returnvariable="LB_CampoDescripcion" xmlfile = "TransaccionCustodiaP_Recepcion.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_CampoMonto" default = "La Descripcion es obligatoria" 
returnvariable="LB_CampoMonto" xmlfile = "TransaccionCustodiaP_Recepcion.xml">
<cf_navegacion name="TESFechaRecep" 		session value="">

<cfquery name="rsCustodio" datasource="#session.dsn#">
	select llave as DEid
	  from UsuarioReferencia
	 where Usucodigo= #session.Usucodigo#
	   and Ecodigo	= #session.EcodigoSDC#
	   and STabla	= 'DatosEmpleado'
</cfquery>

<cfquery name="rsMonedaLocal" datasource="#session.dsn#">
	select Mcodigo
	  from Empresas
	 where Ecodigo	= #session.Ecodigo#
</cfquery>

<cfquery name="rsCajaEspecial" datasource="#session.dsn#">
	select ch.CCHid, ch.CCHcodigo, ch.CCHdescripcion, ch.Mcodigo, mo.Mnombre, mo.Miso4217,
		coalesce((
			select tc.TCventa
			from Htipocambio tc
			where tc.Ecodigo = #session.Ecodigo#
			  and tc.Mcodigo = ch.Mcodigo
			  and tc.Hfecha  <= <cf_dbfunction name="today" >
			  and tc.Hfechah > <cf_dbfunction name="today" >
		),1) as TipoCambio
	  from CCHica ch
		inner join Monedas mo on mo.Mcodigo = ch.Mcodigo
		where	ch.Ecodigo=#session.Ecodigo#
			--and ch.CCHresponsable=#rsCustodio.DEid#
 			and ch.CCHtipo = 2
</cfquery>

	<cfif rsCajaEspecial.RecordCount EQ 0>
		<table width="100%">
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr> 
			<td align="center">
				<strong>EL USUARIO NO TIENE CAJA ESPECIAL DE EFECTIVO ASIGNADA</strong>				
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center">
			<input type="button" value="Regresar" onclick="location.href='TransaccionCustodiaP.cfm'" />
		</td></tr>
		<tr><td>&nbsp;</td></tr>
		</table>
		<cfabort>
		</cfif>
<!---ABG - Lee el parametro de fecha--->
<cfquery name="rsParametro" datasource="#session.dsn#">
	select coalesce(Pvalor,0) as Pvalor
    from Parametros 
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
    and Pcodigo = 1220
</cfquery>
<cfset varPermiteFecha = 0>
<cfif isdefined("rsParametro") and trim(rsParametro.Pvalor) GT 0>
	<cfset varPermiteFecha = rsParametro.Pvalor>
</cfif>

<!---Redireccion SQLTiposTransaccion.cfm o TCESQLTiposTransaccion.cfm--->
<form method="post" name="form1" action="TransaccionCustodiaP_sql.cfm">
	<table align="center" width="100%" cellpadding="1" cellspacing="0">
		<tr> 
			<td colspan="2" align="center">
				<strong><cf_translate key = LB_RECEPCIONDEPOSITOSEFECTIVO xmlfile = "TransaccionCustodiaP_Recepcion.xml">RECEPCION DE DEPOSITOS EN EFECTIVO</cf_translate></strong>				
			</td>
		</tr>
		<tr> 
			<td nowrap align="right"><cf_translate key = LB_Fecha xmlfile = "TransaccionCustodiaP_Recepcion.xml">Fecha</cf_translate>;</td>
			<cfoutput>
			<td>
            <!---ABG Si el parametro esta activado da el objeto fecha, si no la etiqueta con la fecha de hoy--->
            	<cfif varPermiteFecha EQ 1>
                	<!---FECHA--->
                    <cf_sifcalendario form="form1" value="#form.TESFechaRecep#" name="TESFechaRecep" tabindex="1">
                <cfelse>
	            	<strong>#LSDateFormat(Now(),'dd/mm/yyyy')#</strong>
                </cfif>
            </td>
			</cfoutput>
		</tr>

		<tr>
			<td nowrap align="right"><cf_translate key = LB_CajaEfectivo xmlfile = "TransaccionCustodiaP_Recepcion.xml">Caja Efectivo</cf_translate>:&nbsp;</td>
			<td>
				<select name="cboCajaEfectivo" tabindex="1" onchange="javascript:cargarDatos(this);">
				<cfif rsCajaEspecial.RecordCount GT 0 >
					<cfloop query="rsCajaEspecial">
					<option value=<cfoutput>#rsCajaEspecial.CCHid#|#rsCajaEspecial.Mcodigo#|#rsCajaEspecial.Mnombre#|#NumberFormat(rsCajaEspecial.tipoCambio,",9.0000")#</cfoutput>>
								<cfoutput>#rsCajaEspecial.Miso4217# - #rsCajaEspecial.CCHcodigo# - #rsCajaEspecial.CCHdescripcion#</cfoutput>
					</option>
					</cfloop>
				<cfelse>
						<option value="" ><cf_translate key = LB_Ninguno xmlfile = "TransaccionCustodiaP_Recepcion.xml">Ninguno</cf_translate></option>>
				</cfif>
				</select>
			</td>
		</tr>

		<tr> 
			<td nowrap align="right"><cf_translate key = LB_Descripcion xmlfile = "TransaccionCustodiaP_Recepcion.xml">Descripcion</cf_translate>:&nbsp;</td>
			<td><input type="text" tabindex="1" name="Descripcion" id="Descripcion" maxlength="200" size="60" /></td>
		</tr>

		<tr> 
			<td nowrap align="right"><cf_translate key = LB_DepositadoPor xmlfile = "TransaccionCustodiaP_Recepcion.xml">Depositado por</cf_translate>:&nbsp;</td>
			<td><input type="text" tabindex="1" name="Depositante" id="Depositante" maxlength="200" size="60" /></td>
		</tr>

		<tr> 
			<td nowrap align="right"><cf_translate key = LB_Moneda xmlfile = "TransaccionCustodiaP_Recepcion.xml">Moneda</cf_translate>:&nbsp;</td>
			<td>
			<cfoutput>
				<input name="Mnombre" tabindex="-1" type="text" value="" size="15" maxlength="15" style="border:none;" readonly>
				<input name="Mcodigo" type="hidden" value="">
			</cfoutput>
			</td>
		</tr>

		<tr> 
			<td nowrap align="right"><cf_translate key = LB_TipoCambio xmlfile = "TransaccionCustodiaP_Recepcion.xml">Tipo cambio</cf_translate>:&nbsp;</td>
			<td>
				<cf_inputNumber name="tipoCambio" value="" enteros="5" decimales="6" tabindex="1" disabled="true">
			</td>
		</tr>

		<tr> 
			<td nowrap align="right"><cf_translate key = LB_Monto xmlfile = "TransaccionCustodiaP_Recepcion.xml">Monto</cf_translate>:&nbsp;</td>
			<td>
				<cf_inputNumber name="Monto" tabindex="1" value="0.00" enteros="10" decimales="2">
			</td>
		</tr>
	
		<tr> 
			<td nowrap align="right"><cf_translate key = LB_ConfirmarMonto xmlfile = "TransaccionCustodiaP_Recepcion.xml">Confirmar Monto</cf_translate>:&nbsp;</td>
			<td>
				<cf_inputNumber name="Monto2" tabindex="1" value="0.00" enteros="10" decimales="2" >
			</td>
		</tr>
		<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
        <tr> 
			<td nowrap align="right"><cf_translate key = LB_NumComision xmlfile = "TransaccionCustodiaP_Recepcion.xml">N&uacute;m. Comisi&oacute;n</cf_translate>:&nbsp;</td>
			<td>
				<cf_conlis 
						campos="GECnumero, GECdescripcion, CFdescripcion, nombreEmp"
						size="10,40,0,0"
						desplegables="S,S,N,N"
						modificables="S,N,N,N"
						title="#LB_NumComision#"
						tabla="GEcomision cc
                               inner join TESbeneficiario b
                               	on b.TESBid=cc.TESBid
                               inner join DatosEmpleado d
                               	on d.DEid=b.DEid
                               inner join CFuncional cf
                               	on cf.CFid = cc.CFid"
						columnas="cc.GECnumero, cc.GECdescripcion, cf.CFdescripcion, d.DEnombre #LvarCNCT# ' ' #LvarCNCT# d.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# d.DEapellido2 as nombreEmp"
						filtro="cc.Ecodigo = #Session.Ecodigo#
								and cc.GECestado = 2"
                        filtrar_por="cc.GECnumero,cc.GECdescripcion,d.DEnombre #LvarCNCT# ' ' #LvarCNCT# d.DEapellido1 #LvarCNCT# ' ' #LvarCNCT# d.DEapellido2, cf.CFdescripcion"
						desplegar="GECnumero,GECdescripcion, nombreEmp, CFdescripcion"
						etiquetas="#LB_NumComision#, #LB_Descripcion#, #LB_Empleado#, #LB_CentroFuncional#"
						formatos="I,S,S,S"
						width="700"
                        height="400"
                        align="left,left,left,left"
						asignar="GECnumero,GECdescripcion"
						asignarFormatos="S,S"
						form="form1"
						showEmptyListMsg="true"
						EmptyListMsg=" --- #MSG_NoSeEncontraronRegistros#--- "/> 
			</td>
		</tr>
        	
		<tr> 
			<td colspan="2" align="center" nowrap>
					<input type="submit" name="btnRecepcion" value="<cfoutput>#BTN_RecibirEfectivo#</cfoutput>" onclick="return sbOnSubmit()" />
			</td>
		</tr>
	</table>
</form>
<script language="JavaScript">
	window.setTimeout('document.form1.Descripcion.value = "";document.form1.Monto.value = "";document.form1.Monto2.value = "";',1);
	cargarDatos(document.form1.cboCajaEfectivo);

	function sbOnSubmit()
	{
		var LvarMSG = "";
		if (document.form1.Descripcion.value == "")
		{
			LvarMSG += "\n- <cfoutput>#LB_CampoDescripcion#</cfoutput>";
		}

		if (document.form1.tipoCambio.value == "" || document.form1.tipoCambio.value == "0.00" || document.form1.tipoCambio.value == 0)
		{
			LvarMSG += "\n- El Tipo de Cambio es obligatorio";
		}

		if (document.form1.Monto.value == "" || document.form1.Monto.value == "0.00" || document.form1.Monto.value == 0)
		{
			LvarMSG += "\n- <cfoutput>#LB_CampoMonto#</cfoutput>";
		}

		if (document.form1.Monto.value != document.form1.Monto2.value)
		{
			LvarMSG += "\n- El Monto a confirmar no es igual al original";
		}

		if (LvarMSG != "")
		{
			alert("<cfoutput>#LB_Errores#</cfoutput>: " + LvarMSG);
			return false;
		}
	}

	function cargarDatos(a)
	{
		LvarValores = a.value.split('|');
		document.form1.Mcodigo.value = LvarValores[1];
		document.form1.Mnombre.value = LvarValores[2];
		document.form1.tipoCambio.value = LvarValores[3];
		if ( LvarValores[1] == <cfoutput>'#rsMonedaLocal.Mcodigo#'</cfoutput>)
		{
			document.form1.tipoCambio.disabled = true;
			document.form1.tipoCambio.value = "1.0000";
		}
		else
		{
			document.form1.tipoCambio.disabled = false;
		}
	}
</script>
