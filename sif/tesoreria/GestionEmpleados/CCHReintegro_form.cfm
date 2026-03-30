<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Agregar" default="Agregar" returnvariable="BTN_Agregar" xmlfile ="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Regresar" default="Regresar" returnvariable="BTN_Regresar" xmlfile ="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Limpiar" default="Limpiar" returnvariable="BTN_Limpiar" xmlfile ="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Nuevo" default="Nuevo" returnvariable="BTN_Nuevo"  xmlfile="/sif/generales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Modificar" default="Modificar" returnvariable="BTN_Modificar"  xmlfile="/sif/generales.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Eliminar" default="Eliminar" returnvariable="BTN_Eliminar" xmlfile ="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Imprimir" default="Imprimir" returnvariable="BTN_Imprimir" xmlfile ="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_EnviarAprobar" default = "Enviar a Aprobar" returnvariable="BTN_EnviarAprobar" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Aprobar" default="Aprobar" returnvariable="BTN_Aprobar" xmlfile ="/sif/generales.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Rechazar" default="Rechazar" returnvariable="BTN_Rechazar" xmlfile ="/sif/generales.xml"/>

<form name="form1" action="CCHReintegro_sql.cfm" method="post" onSubmit="return Validar(this);"><!--- --->
	<input type="hidden" name="modo" id="modo"  value="#modo#" />
	<cfif isdefined ('url.CCHTid') and (not isdefined('form.CCHTid') or len(trim(form.CCHTid)) eq 0)>
		<cfset form.CCHTid=#url.CCHTid#>
	</cfif>

	<cfif isdefined ('url.CCHid') and (not isdefined('form.CCHid') or len(trim(form.CCHid)) eq 0)>
		<cfset form.CCHid=#url.CCHid#>
	</cfif>

	<cfif isdefined('form.CCHTid') and len(trim(form.CCHTid)) gt 0>
		<cfset modo='CAMBIO'>
	<cfelse>
		<cfset modo='ALTA'>
	</cfif>

	<cfif isdefined ('form.CCHid') and len(trim(form.CCHid)) gt 0>
		<cfquery name="rsCFid" datasource="#session.dsn#">
			select CFid from CCHica where CCHid= #form.CCHid# and Ecodigo=#session.Ecodigo#
		</cfquery>

		<cfquery name="rsSPaprobador" datasource="#session.dsn#">
			Select count(1) as cantidad
			from TESusuarioSP
			where CFid = #rsCFid.CFid#
				and Usucodigo  = #session.Usucodigo#
				and TESUSPaprobador = 1
		</cfquery>
	</cfif>

    <cfparam name="GvarPorResponsable" default="true">
    <cfparam name="rsCustodio.DEid" default="">

	<cfif GvarPorResponsable>
        <cfquery name="rsCustodio" datasource="#session.dsn#">
            select llave as DEid
              from UsuarioReferencia
             where Usucodigo= #session.Usucodigo#
               and Ecodigo	= #session.EcodigoSDC#
               and STabla	= 'DatosEmpleado'
        </cfquery>
        <cfif rsCustodio.DEid EQ "">
            <cfthrow message="El Usuario '#session.usulogin#' no está registrado como Empleado">
        </cfif>
    </cfif>


	<cfif modo eq 'CAMBIO'>
		<cfquery name="rsForm" datasource="#session.dsn#">
			select
				tp.CCHTid,
				tp.CCHid, ch.CCHtipo,
				tp.Ecodigo,
				tp.Mcodigo,
				tp.CCHTestado,
				tp.CCHTmonto,
				tp.CCHTtipo,
				tp.CCHcod,
				tp.CCHTmsj,
				tp.CCHTdescripcion,
				(select Miso4217 from Monedas where Mcodigo=tp.Mcodigo) as Moneda,
				tp.BMfecha
			from
				CCHTransaccionesProceso tp
					inner join CCHica ch
						on ch.CCHid = tp.CCHid
			where tp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and tp.CCHTid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCHTid#">
		</cfquery>

		<cfquery name="rsCCHI" datasource="#session.dsn#">
			select coalesce(CCHImontoasignado,0) as Asignado from CCHImportes where CCHid = #rsForm.CCHid#
		</cfquery>

		<cfif rsForm.CCHtipo EQ 1>
			<cfquery name="rsMovimientosCCH" datasource="#session.dsn#">
				select coalesce(sum(CCHTAmonto),0) as Movimientos from CCHTransaccionesAplicadas where CCHTtipo='GASTO' and CCHTAreintegro=#form.CCHTid#
			</cfquery>
			<cfset LvarMovimientos = -rsMovimientosCCH.Movimientos>
		<cfelseif rsForm.CCHtipo EQ 2>
			<cfquery datasource="#session.dsn#">
				update CCHespecialMovs
				   set CCHTid_reintegro = #form.CCHTid#
				 where CCHid = #rsForm.CCHid#
				   and CCHTid_reintegro IS NULL
				   and NOT (CCHEMtipo = 'E' and CCHTid_CCH is not null)
			</cfquery>

			<cfquery name="rsMovimientosCCH" datasource="#session.dsn#">
				select coalesce(sum(case when CCHEMtipo='E' then CCHEMmontoOri else -CCHEMmontoOri end),0) as Movimientos from CCHespecialMovs where CCHTid_reintegro = #form.CCHTid#
			</cfquery>

			<cfset LvarMovimientos = rsMovimientosCCH.Movimientos>
		<cfelse>
			<cfthrow message="Las Cajas externas no pueden Reintegrarse">
		</cfif>
	</cfif>

	<table width="100%" align="center">
	<cfoutput>
	<input type="hidden" name="CCHTid" <cfif modo eq 'CAMBIO'> value='#form.CCHTid#'</cfif>/>

	<!---<input type="hidden" name="CCHid"  value='#form.CCHid#'/>--->
		<tr>
			<td align="right">
				<strong><cf_translate key=LB_NumTransaccion>Num.Transacci&oacute;n</cf_translate>:</strong>
			</td>
			<td>
				<cfif modo eq 'ALTA'>
					-- <cf_translate key=LB_NuevaSolicitudTransaccion>Nueva Solicitud de Transacci&oacute;n</cf_translate> --
				<cfelse>
					<strong>#rsForm.CCHcod#</strong>
					<input type="hidden" name="CCHcod" value="#rsForm.CCHcod#" />
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong><cf_translate key=LB_TipoSolicitud>Tipo de Solicitud</cf_translate>:</strong>
			</td>
			<td>
				<strong><cf_translate key=LB_Reintegro>Reintegro</cf_translate></strong>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong><cf_translate key=LB_CajaChica>Caja</cf_translate>:</strong>
			</td>
			<td>
				<cfif modo eq 'ALTA'>
					<cf_conlisCajas Responsable=#rsCustodio.DEid#>
				<cfelseif isdefined ('url.Aprobar') and len(trim(url.Aprobar)) gt 0>
					<cf_conlisCajas value="#rsForm.CCHid#" lectu="yes">
				<cfelse>
					<cf_conlisCajas value="#rsForm.CCHid#" lectu="yes">
				</cfif>
			</td>
		</tr>

		<tr>
			<td align="right">
				<strong><cf_translate key=LB_Descripcion>Descripci&oacute;n</cf_translate>:</strong>
			</td>
			<td>
				<cfif modo eq 'ALTA'>
					<input type="text" name="descrip" maxlength="150" size="50">
				<cfelse>
					<input type="text" name="descrip" maxlength="150" size="50" value="#rsForm.CCHTdescripcion#" <cfif rsForm.CCHTestado NEQ 'EN PROCESO'>disabled="disabled" </cfif>>
				</cfif>
			</td>
		</tr>
	<cfif modo neq 'ALTA'>
		<tr>
			<td align="right">
				<strong><cf_translate key=LB_MontoAsignado>Monto Asignado</cf_translate>:</strong>
			</td>
			<td>
				<cf_inputNumber name="asignado" size="20" value="#rsCCHI.asignado#" enteros="13" decimales="2" maxlenght="15" readOnly="yes">
			</td>
		</tr>
	<cfif rsForm.CCHtipo EQ 1>
		<tr>
			<td align="right">
				<strong><cf_translate key=LB_MontoReintegro>Monto de Reintegro</cf_translate>:</strong>
			</td>
			<td>
				<cf_inputNumber name="montoReintegro" size="20" value="#rsMovimientosCCH.Movimientos#" enteros="13" decimales="2" maxlenght="15" readOnly="yes">
			</td>
		</tr>
	<cfelseif rsForm.CCHtipo EQ 2>
		<tr>
			<td align="right">
				<strong><cf_translate key=LB_MovimientoReintegrar>Movimientos a Reintegrar</cf_translate>:</strong>
			</td>
			<td>
				<cf_inputNumber name="montoMovimientos" size="20" value="#rsMovimientosCCH.Movimientos#" enteros="13" decimales="2" maxlenght="15" readOnly="yes">
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong><cf_translate key=LB_MontoReintegro>Monto de Reintegro</cf_translate>:</strong>
			</td>
			<td>
				<cfif LvarMovimientos GT 0>
					<cf_inputNumber name="montoReintegro" size="20" value="0" enteros="13" decimales="2" maxlenght="15" readOnly="yes"><cf_translate key=LB_MovimientosEntradaSalida>	Tiene más movimientos de entrada que de salida</cf_translate>
				<cfelseif abs(LvarMovimientos) LTE rsCCHI.asignado>
					<cf_inputNumber name="montoReintegro" size="20" value="#rsCCHI.asignado + LvarMovimientos#" enteros="13" decimales="2" maxlenght="15" readOnly="yes">
				<cfelse>
					<cf_inputNumber name="montoReintegro" size="20" value="#rsCCHI.asignado#" enteros="13" decimales="2" maxlenght="15" readOnly="yes">
				</cfif>
			</td>
		</tr>
	</cfif>
	</cfif>

		<cfif isdefined('url.Aprobar') and len(trim(url.Aprobar)) gt 0>
		<tr>
			<td align="right">
				<strong><cf_translate key=LB_MotivoRechazo>Motivo de Rechazo</cf_translate>:</strong>
			</td>
			<td>
				<input type="text" maxlength="150" size="75" name="motivo"  />
			</td>
		</tr>
		</cfif>
		<cfif modo eq 'CAMBIO' and rsForm.CCHTestado eq 'RECHAZADO'>
		<tr>
			<td align="right">
				<strong><cf_translate key=LB_Estado>Estado</cf_translate>:&nbsp;</strong>
			</td>
			<td>
				<font color="FF0000"><cf_translate key=LB_Rechazada>RECHAZADA</cf_translate></font>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong><cf_translate key=LB_MotivoRechazo>Motivo de Rechazo</cf_translate>:</strong>
			</td>
			<td>
				#rsForm.CCHTmsj#
			</td>
		</tr>
		</cfif>
		<tr>
			<cfif modo eq 'ALTA'>
				<td colspan="3" align="center">
                	<cfoutput>
					<input type="submit" name="Agregar" value="#BTN_Agregar#" onClick="javascript: habilitarValidacion(); "/><!---onClick="javascript: habilitarValidacion(); "--->
					<input type="submit" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript: inhabilitarValidacion(); "/>
					<input type="submit" name="Regresar" value="#BTN_Regresar#" onClick="javascript: inhabilitarValidacion(); "/>
                    </cfoutput>
				</td>
			<cfelseif modo eq 'CAMBIO' and rsForm.CCHTestado eq 'EN PROCESO'>
				<td colspan="4" align="center">
					<input type="submit" name="Nuevo" value="#BTN_Nuevo#" />
					<input type="submit" name="Modificar" value="#BTN_Modificar#" onClick="javascript: habilitarValidacion(); "/>
					<input type="submit" name="Eliminar" value="#BTN_Eliminar#" onClick="javascript: inhabilitarValidacion(); "/>
					<cfif LvarMovimientos LT 0>
						<cfif modo eq 'CAMBIO' and rsForm.CCHTestado eq 'EN PROCESO'>
						<cfoutput><input type="submit" name="Enviar" value="#BTN_EnviarAprobar#" onClick="javascript: habilitarValidacion(); "/></cfoutput></br>
						</cfif>
						<cfif isdefined('url.Apro') or (isdefined ('rsSPaprobador') and rsSPaprobador.cantidad gt 0) and rsForm.CCHTestado eq 'EN PROCESO'>
							<input type="submit" name="Aprobar" value="#BTN_Aprobar#" onClick="javascript: habilitarValidacion(); "/>
						</cfif>
					</cfif>
					<input type="submit" name="Regresar" value="#BTN_Regresar#" onClick="javascript: inhabilitarValidacion(); "/>
                     <input type="button" value="#BTN_Imprimir#" name="btnImprimir" onclick="fnImprimir();"/>
				</td>
			<cfelseif isdefined ('url.Aprobar') and len(trim(url.Aprobar)) gt 0>
				<td colspan="4" align="center">
					<cfif LvarMovimientos LT 0>
						<input type="submit" name="Aprobar" value="#BTN_Aprobar#" onClick="javascript: habilitarValidacion(); "/>
						<input type="submit" name="Rechazar" value="#BTN_Rechazar#" onClick="javascript: habilitarValidacion(); "/>
					</cfif>
					<input type="submit" name="Regresar1" value="#BTN_Regresar#" onClick="javascript: inhabilitarValidacion(); "/>
                     <input type="button" value="#BTN_Imprimir#" name="btnImprimir" onclick="fnImprimir();"/>
				</td>
			<cfelse>
				<td colspan="4" align="center">
					<input type="submit" name="Nuevo" value="#BTN_Nuevo#" onClick="javascript: inhabilitarValidacion(); "/>
					<input type="submit" name="Regresar" value="#BTN_Regresar#" onClick="javascript: inhabilitarValidacion(); "/>
                    <input type="button" value="#BTN_Imprimir#" name="btnImprimir" onclick="fnImprimir();"/>
				</td>
			</cfif>
		</tr>
	</cfoutput>
	</form>
	<cfif modo eq 'CAMBIO'>
		<tr>
			<td colspan="2">
				<cfif rsForm.CCHtipo EQ 1>
					<cfinclude template="CCHReintegro_detalles.cfm">
				<cfelseif rsForm.CCHtipo EQ 2>
					<cfinclude template="CCHReintegro_especial.cfm">
				</cfif>
			</td>
		</tr>
	</cfif>
	</table>


<cf_qforms>
<script language="javascript" type="text/javascript">

	function inhabilitarValidacion() {
		objForm.CCHcodigo.required = false;
		objForm.descrip.required = false;

	}

	function habilitarValidacion() {
		objForm.CCHcodigo.required = true;
		objForm.descrip.required = true;

	}
	objForm.descrip.description = "Descripcion";
	objForm.CCHcodigo.description = "Caja Chica";



</script>

<script language="javascript" type="text/javascript">
	function Validar(){
	<!---alert (!btnSelected);
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Eliminar',document.form1) && !btnSelected('IrLista',document.Regresar) && !btnSelected('IrLista',document.Regresar1)){
		if (document.form1.montoAp.value!=''){
			if (document.form1.montoAp.value<=0){
			alert('El monto solicitado debe ser mayor de cero');
			return false;
		}
		}
		if (document.form1.montoA.value==''){
			alert ('-Debe de indicar un monto');
			return false;
		}
		document.form1.montoA.disabled=true;
		document.form1.descrip.disabled=false;
		return true;
	}
	}

	function Habilitar(){
		if (document.form1.CCHid.value==''){
		alert('No se puede escoger una transacción hasta que defina la caja chica');
		document.form1.CCHcodigo.focus();
		}
	}
	function funcCambiaValores(){
	 document.form1.montoA.value='';
	 document.form1.descrip.value=''--->
	}
</script>
<script language="javascript1.2" type="text/javascript">
        var popUpWin = 0;

        function popUpWindow(URLStr, left, top, width, height){
            if(popUpWin){
                if(!popUpWin.closed) popUpWin.close();
            }
            popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
        }
       	<cfif modo eq 'CAMBIO'>
        function fnImprimir()
        {
            params = "?CCHTid=" +<cfoutput>#form.CCHTid#</cfoutput>;
            popUpWindow("/cfmx/sif/tesoreria/GestionEmpleados/ReporteReintegro.cfm"+params,50,50,1100,800);
        }
		</cfif>

</script>
