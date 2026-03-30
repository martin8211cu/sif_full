<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Agregar" default = "Agregar" returnvariable="BTN_Agregar" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Limpiar" default = "Limpiar" returnvariable="BTN_Limpiar" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Regresar" default = "Regresar" returnvariable="BTN_Regresar" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Nuevo" default = "Nuevo" returnvariable="BTN_Nuevo" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Modificar" default = "Modificar" returnvariable="BTN_Modificar" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Eliminar" default = "Eliminar" returnvariable="BTN_Eliminar" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_EnviarAprobar" default = "Enviar a Aprobar" returnvariable="BTN_EnviarAprobar" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "BTN_Aprobar" default = "Aprobar" returnvariable="BTN_Aprobar" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Reintegro" default = "Reintegro" returnvariable="LB_Reintegro" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Aumento" default = "Aumento" returnvariable="LB_Aumento" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Disminucion" default = "Disminucion" returnvariable="LB_Disminucion" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Cierre" default = "Cierre" returnvariable="LB_Cierre" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_DebeDeEscogerUnTipoDeTransaccion" default = "Debe de escoger un tipo de transaccion" returnvariable="MSG_DebeDeEscogerUnTipoDeTransaccion" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_ElMontoSolicitadoDebeSerMayorDeCero" default = "El monto solicitado debe ser mayor de cero" returnvariable="MSG_ElMontoSolicitadoDebeSerMayorDeCero" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_DebeIndicarUnMonto" default = "Debe de indicar un monto" returnvariable="MSG_DebeIndicarUnMonto" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "MSG_NoSePuedeEscogerUnaTransaccionHastaQueDefinaLaCajaChica" 
default = "No se puede escoger una transacción hasta que defina la caja chica" returnvariable="MSG_NoSePuedeEscogerUnaTransaccionHastaQueDefinaLaCajaChica" 
xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Descripcion" default = "Descripcion" returnvariable="LB_Descripcion" 
xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Tipos" default = "Tipos" returnvariable="LB_Tipos" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key = "LB_Caja"  default = "Caja Chica" returnvariable="LB_Caja" xmlfile = "CCHtransac_form.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="BTN_Rechazar" default="Rechazar" returnvariable="BTN_Rechazar" xmlfile ="/sif/generales.xml"/>

<script language="javascript" type="text/javascript">
<!-- 
//Browser Support Code
function ajaxFunction1_ComboConcepto(){

	if (document.form1.CCHid.value=='') {
		alert('<cfoutput>#MSG_NoSePuedeEscogerUnaTransaccionHastaQueDefinaLaCajaChica#</cfoutput>');
		document.form1.Tipo[0].selected="true"
		return false;
	}

	var ajaxRequest1;  // The variable that makes Ajax possible!
	var vID_tipo ='';
	var vmodoD1 ='';
	vID_tipo = document.form1.Tipo.value;
	vmodoD1 = document.form1.CCHid.value;
	try{
		// Opera 8.0+, Firefox, Safari
		ajaxRequest1 = new XMLHttpRequest();
	} catch (e){
		// Internet Explorer Browsers
		try{
			ajaxRequest1 = new ActiveXObject("Msxml2.XMLHTTP");
		} catch (e) {
			try{
				ajaxRequest1 = new ActiveXObject("Microsoft.XMLHTTP");
			} catch (e){
				// Something went wrong
				alert("Your browser broke!");
				return false;
			}
		}
	}

	ajaxRequest1.open("GET", '/cfmx/sif/tesoreria/GestionEmpleados/MontoReintegro.cfm?tipo='+vID_tipo+'&CCHid='+vmodoD1, false);
	ajaxRequest1.send(null);
	document.getElementById("montoA").innerHTML = ajaxRequest1.responseText;
	objForm.montoA.value=document.getElementById("montoA")

}

//-->
</script>

<form name="form1" action="CCHtransac_sql.cfm" method="post" onSubmit="return Validar(this);"><!--- --->
<cfif isdefined ('url.Aprobar') and len(trim(url.Aprobar)) GT 0>
<input type="hidden" name="entrada" id="modo"  value="1" />
</cfif>
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
	
	<cfif modo eq 'CAMBIO'>
		<cfquery name="rsForm" datasource="#session.dsn#">
			select 
				tp.CCHTid,
				tp.Ecodigo,
				tp.Mcodigo,
				tp.CCHTestado,
				tp.CCHTmonto,
				tp.CCHTtipo,
				tp.CCHid, ch.CCHtipo as CCHtipo_caja, ch.CCHunidadReintegro,
				tp.CCHcod,
				tp.CCHTmsj,
				CCHTdescripcion,
				(select Miso4217 from Monedas where Mcodigo=tp.Mcodigo) as Moneda,
				tp.BMfecha
			from
				CCHTransaccionesProceso tp
					inner join CCHica ch on ch.CCHid=tp.CCHid
			where tp.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and tp.CCHTid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCHTid#">
		</cfquery>

		<cfset LvarMontoA = rsForm.CCHTmonto>
		<cfif rsForm.CCHtipo_caja EQ 2>
			<cfif rsForm.CCHunidadReintegro NEQ "" AND rsForm.CCHunidadReintegro GT 0.01>
				<cfif NOT listFind("0.00,0.01,0.05,0.10,0.20,0.25,0.50,1.00,2.00,5.00,10.00,20.00,25.00,50.00,100.00,200.00,500.00,1000.00", numberFormat(rsForm.CCHunidadReintegro,"0.00"))>
					<cfthrow message="La Unidad de redondeo es incorrecta">
				</cfif>
				<cfset LvarMontoA = ceiling(rsForm.CCHTmonto/rsForm.CCHunidadReintegro) * rsForm.CCHunidadReintegro>
			</cfif>
		</cfif>
	</cfif>

	<table width="100%" align="center">
	<cfoutput>
	<input type="hidden" name="CCHTid" <cfif modo eq 'CAMBIO'> value='#form.CCHTid#'</cfif>/>
	<!---<input type="hidden" name="CCHid"  value='#form.CCHid#'/>--->
		<tr>
			<td align="right">
				<strong><cf_translate key = LB_NumTransaccion xmlfile = "CCHtransac_form.xml"> Num.Transacci&oacute;n</cf_translate>:</strong>
			</td>
			<td>
				<cfif modo eq 'ALTA'>
					-- <cf_translate key = LB_NuevaSolicitudTransaccion xmlfile = "CCHtransac_form.xml">Nueva Solicitud de Transacci&oacute;n</cf_translate> --
				<cfelse>
					<strong>#rsForm.CCHcod#</strong>
					<input type="hidden" name="CCHcod" value="#rsForm.CCHcod#" />
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong><cf_translate key = LB_Caja xmlfile = "CCHtransac_form.xml">Caja</cf_translate>:</strong>
			</td>
			<td>
				<cfif modo eq 'ALTA'>
					<cf_conlisCajas>
				<cfelseif isdefined ('url.Aprobar') and len(trim(url.Aprobar)) gt 0>
					<cf_conlisCajas value="#rsForm.CCHid#" lectu="yes">
				<cfelse>
					<cf_conlisCajas value="#rsForm.CCHid#">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong><cf_translate key = LB_TipoTransaccion xmlfile = "CCHtransac_form.xml">Tipo Transacci&oacute;n</cf_translate>:</strong>
			</td>
			<td>
				<!---
					<select name="Tipo" onfocus="Habilitar()" onchange="ajaxFunction1_ComboConcepto();"  >  
					Se cambio la linea 172 por la 175 porque el mensaje de alerta en la validacion 
					Habilitar(); entraba en un loop infinito bloqueando la página, entonces se debía refrescar para poder
					utilizar la página.
				--->
				<select name="Tipo"  onchange=" ajaxFunction1_ComboConcepto();"  >   
					<option value="1" selected <cfif isdefined('url.Aprobar')>disabled="disabled"</cfif>> - <cf_translate key = LB_Tipos xmlfile = "CCHtransac_form.xml">Tipos</cf_translate> - </option>
					<cfif  isdefined('url.Aprobar')>
						<option value="REINTEGRO"  <cfif modo eq 'CAMBIO' and rsForm.CCHTtipo eq 'REINTEGRO'> selected="selected"</cfif> <cfif isdefined('url.Aprobar')>disabled="disabled"</cfif>>#LB_Reintegro#</option>
					</cfif>
					<option value="AUMENTO" <cfif modo eq 'CAMBIO' and rsForm.CCHTtipo eq 'AUMENTO'> selected="selected"</cfif> <cfif isdefined('url.Aprobar')>disabled="disabled"</cfif>>#LB_Aumento#</option>
					<option value="DISMINUCION" <cfif modo eq 'CAMBIO' and rsForm.CCHTtipo eq 'DISMINUCION'> selected="selected"</cfif> <cfif isdefined('url.Aprobar')>disabled="disabled"</cfif>>#LB_Disminucion#</option>
					<option value="CIERRE" <cfif modo eq 'CAMBIO' and rsForm.CCHTtipo eq 'CIERRE'> selected="selected"</cfif> <cfif isdefined('url.Aprobar')>disabled="disabled"</cfif>>#LB_Cierre#</option>					
				</select>
			
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong><cf_translate key = LB_Monto xmlfile = "CCHtransac_form.xml">Monto</cf_translate>:</strong>
			</td>
			<td>
			<span id="montoA">			
				<cfif modo eq 'ALTA'>
					<cf_inputNumber name="montoA" size="20" value="" enteros="13" decimales="2" maxlenght="15">
				<cfelseif modo eq 'CAMBIO' and isdefined('url.Aprobar') or isdefined ('url.Apro')  or (isdefined ('rsSPaprobador') and rsSPaprobador.cantidad gt 0) and rsForm.CCHTestado eq 'EN PROCESO'>
					<cf_inputNumber name="montoA" size="20" value="#rsForm.CCHTmonto#" enteros="13" decimales="2" maxlenght="15" readonly="true">
				<cfelse>
					<cf_inputNumber name="montoA" size="20" value="#rsForm.CCHTmonto#" enteros="13" decimales="2" maxlenght="15">				
				</cfif>
			</span>
			</td>
		</tr>
		<cfif modo eq 'CAMBIO'>
			<cfif isdefined('url.Apro') or (isdefined ('rsSPaprobador') and rsSPaprobador.cantidad gt 0) and rsForm.CCHTestado eq 'EN PROCESO'>
				<tr>			
					<td align="right">
						<strong><cf_translate key = LB_MontoAprobado xmlfile = "CCHtransac_form.xml">Monto Aprobado</cf_translate>:</strong>
					</td>
					<td>
						<cf_inputNumber name="montoAp" size="20" value="#LvarMontoA#" enteros="13" decimales="2" maxlenght="15">
					</td>
				</tr>
			</cfif>
			
			<cfif isdefined('url.Aprobar') and len(trim(url.Aprobar)) gt 0>
				<tr>			
					<td align="right">
						<strong><cf_translate key = LB_MontoAprobado xmlfile = "CCHtransac_form.xml">Monto Aprobado</cf_translate>:</strong>
					</td>
					<td>
						<cf_inputNumber name="montoAp" size="20" value="#LvarMontoA#" enteros="13" decimales="2" maxlenght="15">
					</td>
				</tr>
			</cfif>		
		</cfif>
		<tr>
			<td align="right">
				<strong><cf_translate key = LB_Descripcion xmlfile = "CCHtransac_form.xml">Descripci&oacute;n</cf_translate>:</strong>
			</td>
			<td>
				<cfif modo eq 'ALTA'>
					<input type="text" name="descrip" maxlength="150" size="50">
				<cfelse>
					<input type="text" name="descrip" maxlength="150" size="50" value="#rsForm.CCHTdescripcion#" <cfif rsForm.CCHTestado NEQ 'EN PROCESO'>disabled="disabled" </cfif>>
				</cfif>
			</td>
		</tr>
		<cfif isdefined('url.Aprobar') and len(trim(url.Aprobar)) gt 0>
		<tr>
			<td align="right">
				<strong><cf_translate key = LB_MotivoRechazo xmlfile = "CCHtransac_form.xml">Motivo de Rechazo</cf_translate>:</strong>
			</td>
			<td>
				<input type="text" maxlength="150" size="75" name="motivo"  />
			</td>
		</tr>
		</cfif>
		<cfif modo eq 'CAMBIO' and rsForm.CCHTestado eq 'RECHAZADO'>
		<tr>
			<td align="right">
				<strong><cf_translate key = LB_Estado xmlfile = "CCHtransac_form.xml">Estado</cf_translate>:&nbsp;</strong>
			</td>
			<td>	
				<font color="FF0000"><cf_translate key = LB_RECHAZADA xmlfile = "CCHtransac_form.xml">RECHAZADA</cf_translate></font>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong><cf_translate key = LB_MotivoRechazo xmlfile = "CCHtransac_form.xml">Motivo de Rechazo</cf_translate>:</strong>
			</td>
			<td>
				#rsForm.CCHTmsj#
			</td>
		</tr>
		</cfif>
		<tr>
			<cfif modo eq 'ALTA'>
				<td colspan="3" align="center">
					<input type="submit" name="Agregar" value="#BTN_Agregar#" onClick="javascript: habilitarValidacion(); "/><!---onClick="javascript: habilitarValidacion(); "--->
					<input type="submit" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript: inhabilitarValidacion(); "/>
					<input type="submit" name="Regresar" value="#BTN_Regresar#" onClick="javascript: inhabilitarValidacion(); "/>
				</td>
			<cfelseif modo eq 'CAMBIO' and rsForm.CCHTestado eq 'EN PROCESO'>
				<td colspan="4" align="center">
					<input type="submit" name="Nuevo" value="#BTN_Nuevo#" />
					<input type="submit" name="Modificar" value="#BTN_Modificar#" onClick="javascript: habilitarValidacion(); "/>
					<input type="submit" name="Eliminar" value="#BTN_Eliminar#" onClick="javascript: inhabilitarValidacion(); "/>
					<cfif modo eq 'CAMBIO' and rsForm.CCHTestado eq 'EN PROCESO'>
					<input type="submit" name="Enviar" value="#BTN_EnviarAprobar#" onClick="javascript: habilitarValidacion(); "/></br>
					</cfif>
					<cfif isdefined('url.Apro') or (isdefined ('rsSPaprobador') and rsSPaprobador.cantidad gt 0) and rsForm.CCHTestado eq 'EN PROCESO'>
						<input type="submit" name="Aprobar" value="#BTN_Aprobar#" onClick="javascript: habilitarValidacion(); "/>
					</cfif>
					<input type="submit" name="Regresar" value="#BTN_Regresar#" onClick="javascript: inhabilitarValidacion(); "/>
				</td>
			<cfelseif isdefined ('url.Aprobar') and len(trim(url.Aprobar)) gt 0>
				<td colspan="4" align="center">
					<input type="submit" name="Aprobar" value="#BTN_Aprobar#" onClick="javascript: habilitarValidacion(); "/>
					<input type="submit" name="Rechazar" value="#BTN_Rechazar#" onClick="javascript: habilitarValidacion(); "/>
					<input type="submit" name="Regresar1" value="#BTN_Regresar#" onClick="javascript: inhabilitarValidacion(); "/>
				</td>
			<cfelse>
				<td colspan="4" align="center">
					<input type="submit" name="Nuevo" value="#BTN_Nuevo#" onClick="javascript: inhabilitarValidacion(); "/>
					<input type="submit" name="Regresar" value="#BTN_Regresar#" onClick="javascript: inhabilitarValidacion(); "/>
				</td>
			</cfif>
		</tr>
	</cfoutput>
	</table>
</form>

<cf_qforms>
<script language="javascript" type="text/javascript">

	function inhabilitarValidacion() {
		objForm.Tipo.required = false;
		objForm.CCHcodigo.required = false;	
		<cfif modo eq 'CAMBIO'>		
			objForm.montoAp.required = false;	
		</cfif>
		objForm.descrip.required = false;	
		
	}

	function habilitarValidacion() {
		objForm.Tipo.required = true;	
		objForm.CCHcodigo.required = true;
		objForm.descrip.required = true;		
		<cfif modo eq 'CAMBIO'>	
			objForm.montoAp.required = true;	
		</cfif>
	}
	<cfoutput>
	objForm.Tipo.description = "#LB_Tipos#";	
	objForm.descrip.description = "#LB_Descripcion#";
	objForm.CCHcodigo.description = "#LB_Caja#";		
	<cfif modo eq 'CAMBIO'>	
		objForm.montoAp.description = "Monto Aprobado";	
	</cfif>
	</cfoutput>
	
</script>

<script language="javascript" type="text/javascript">
	function Validar()
	{
		if (objForm.Tipo.required == true)
		{
			if (document.form1.Tipo.value==1)
			{
				alert ('<cfoutput>#MSG_DebeDeEscogerUnTipoDeTransaccion#</cfoutput>');
				return false;
			}
			if (document.form1.montoAp.value!='')
			{
				if (document.form1.montoAp.value<=0)
				{
					alert('<cfoutput>#MSG_ElMontoSolicitadoDebeSerMayorDeCero#</cfoutput>');
					return false;
				}
			}
			if (document.form1.montoA.value=='')
			{
				alert ('<cfoutput>#MSG_DebeIndicarUnMonto#</cfoutput>');
				return false;
			}
			document.form1.montoA.readonly=true;
			document.form1.descrip.disabled=false;
			return true;
		}
	}
	
	function Habilitar(){
		if (document.form1.CCHid.value=='')
		{
			alert('<cfoutput>#MSG_NoSePuedeEscogerUnaTransaccionHastaQueDefinaLaCajaChica#</cfoutput>');
			document.form1.CCHcod.focus();
		}
	}
	/*
	function funcCambiaValores(){
	 document.form1.Tipo.value=1;
	 document.form1.montoA.value='';
	 document.form1.descrip.value=''
	}*/
</script>
