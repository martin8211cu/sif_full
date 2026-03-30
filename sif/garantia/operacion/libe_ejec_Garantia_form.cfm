<cfquery name="rsGarantia" datasource="#session.DSN#">
select 
	a.CMPid,
	b.COEGid,
	a.CMPProceso, 
	c.SNcodigo,
	c.SNnumero,
	c.SNnombre,
	b.COEGReciboGarantia,
	case b.COEGTipoGarantia
	when 1 then 'Participación'
	when 2 then 'Cumplimiento'
	end as TipoGarantia,
	d.Miso4217,
	b.Mcodigo,
	b.COEGMontoTotal,
	case b.COEGEstado
	when 1 then 'Vigente'
	when 2 then 'Edición'
	when 3 then 'En proceso de Ejecución'
	when 4 then 'En Ejecución'
	when 5 then 'Ejecutada'
	when 6 then 'En proceso Liberación'
	when 7 then 'Liberada'
	when 8 then 'Devuelta'
	end as Estado,
	a.CMPLinea,
	b.COEGFechaRecibe,
	b.COEGPersonaEntrega,
	b.COEGIdentificacion,
	b.COEGVersion,
	b.COEGTipoGarantia,
	b.COEGEstado,b.COEGPersonaEntrega,b.COEGIdentificacion, case when b.COEGContratoAsociado = 'N' then 'NO' else 'SI' end as COEGContratoAsociado
from COHEGarantia b
	left join CMProceso a
		on a.CMPid = b.CMPid
	left join SNegocios c
		on c.SNid = b.SNid
	inner join Monedas d
		on d.Mcodigo = b.Mcodigo
where b.COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGid#">
	and b.COEGVersion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGVersion#">
	<!--- and b.COEGUsuCodigo = #session.usucodigo# --->
</cfquery>
<cfif rsGarantia.recordcount >
	
</cfif>
<cfset LvarConsecutivo = rsGarantia.COEGReciboGarantia>
<cfset LvarVersion = rsGarantia.COEGVersion>
<cfoutput>
<table cellpadding="0" cellspacing="0" align="center" border="0" width="100%">
	<tr>
		<td colspan="1" align="right">
			<strong>Proceso:&nbsp;</strong>
		</td>
		<td align="left">
			<cfset valuesArray = ArrayNew(1)>
			 <cfif modo NEQ 'Alta'>
				<cfset ArrayAppend(valuesArray, rsGarantia.CMPid)>
				<cfset ArrayAppend(valuesArray, rsGarantia.CMPProceso)>
				<cfset ArrayAppend(valuesArray, rsGarantia.CMPLinea)>
			</cfif>
			<cf_conlis
				Campos="CMPid, CMPProceso, CMPLinea"
				Desplegables="N,S,S"
				Modificables="N,S,S"
				Size="0,20,10"
				tabindex="1"
				valuesarray="#valuesArray#" 
				Title="Lista Procesos"
				Tabla=" CMProceso a
						inner join Monedas b
						  on b.Mcodigo = a.Mcodigo "
				Columnas="  a.CMPid,
							a.CMPProceso, 
							b.Miso4217,
							a.CMPMontoProceso,
							a.CMPMontoProceso as CMPMontoProcesoVisual,
							a.CMPLinea,
							b.Mcodigo "
				Filtro=" a.Ecodigo = #session.Ecodigo# "
				Desplegar="CMPProceso, CMPLinea, Miso4217, CMPMontoProceso"
				Etiquetas="Proceso, Línea, Moneda, Total Proceso"
				filtrar_por="CMPProceso, CMPLinea, Miso4217, CMPMontoProceso"
				Formatos="S,S,S,M"
				Align="left,left,left,right"
				form="form1"
				Asignar="CMPid, CMPProceso, CMPLinea, Miso4217, CMPMontoProceso, CMPMontoProcesoVisual, Mcodigo"
				Asignarformatos="S,S,S,S,M,M,S"
				readonly="true"
				width="800"
			/>
		</td>
		<td colspan="1" align="right"> <strong>Estado:</strong>&nbsp; </td>
		<td align="left"> 
			<!--- El estado en alta o cambio siempre va se en edición --->
			Edición
			<input name="COEGEstado" id="COEGEstado" value="2" type="hidden" /> <!--- 1: vigente, 2: Edicion, 3: En proceso de Ejecución, 4: En Ejecución, 5: Ejecutada, 6: En proceso Liberación, 7: Liberada,  8:Devuelta --->
		</td>
	</tr>
	<tr>
		<td colspan="1" align="right"> <strong>Asociado a una Contratación:&nbsp;</strong> </td>
						<td><input type="hidden" name="COEGContratoAsociado" id="COEGContratoAsociado" tabindex="1" value="<cfif #rsGarantia.COEGContratoAsociado# EQ 'S'>SI<cfelse>NO</cfif>" readonly="true">
						#rsGarantia.COEGContratoAsociado#</td>
		<td colspan="1" align="right">
			<strong>Total Garant&iacute;a:</strong>&nbsp;
		</td>
		<td align="left">
			<input name="COEGMontoTotal" id="COEGMontoTotal" value="<cfif modo NEQ 'Alta'>#numberformat(rsGarantia.COEGMontoTotal,',_.__')#</cfif>" type="text" tabindex="1"  readonly="true"/>
		</td>
	</tr>
	<tr>
		<td colspan="1" align="right">
			<strong>Proveedor:&nbsp;</strong>
		</td>
		<td align="left" colspan="3">
			<cf_sifsociosnegocios2 tabindex="1" SNtiposocio='P' SNid='SNid' idquery='#rsGarantia.SNcodigo#' modificable="false">
		</td>
	</tr>
	<tr>
		<td align="right">
			<strong>Garantía:</strong>&nbsp;
		</td>
		<td align="left">
			#LvarConsecutivo#
			<input name="COEGReciboGarantia" value="#LvarConsecutivo#" type="hidden" tabindex="1"/>
		</td>
		<td align="right">
			<strong>Tipo Garantía:</strong>&nbsp;
		</td>
		<td align="left">
			<cfset tipoGarantia="">
			<cfif rsGarantia.COEGTipoGarantia eq 1>
				<cfset tipoGarantia="Participación">
			<cfelseif rsGarantia.COEGTipoGarantia eq 2>
				<cfset tipoGarantia="Cumplimiento">
			</cfif>
			<input name="COEGTipoGarantia" tabindex="1" id="COEGTipoGarantia" value="tipoGarantia" readonly="true">
		</td>
	</tr>
	<tr>
		<td align="right">
			<strong>Versión:</strong>&nbsp;
		</td>
		<td colspan="1">
			#LvarVersion#
			<input name="COEGVersion" id="COEGVersion" value="#LvarVersion#" type="hidden" />
		</td>
		<td colspan="1" align="right">
			<strong>Moneda:</strong>&nbsp;
		</td>
		<td align="left">
			<input name="Miso4217" id="Miso4217" value="<cfif modo NEQ 'Alta'>#rsGarantia.Miso4217#</cfif>" type="text" tabindex="1" readonly="true"/>
		</td>
	</tr>
	<tr>
		<td align="right">
			<strong>Fecha Recepción:</strong>&nbsp;
		</td>
		<td align="left" colspan="3">
			#LSdateformat(rsGarantia.COEGFechaRecibe,'dd/mm/yyyy hh:mm:ss ')#
			<input name="COEGFechaRecibe" id="COEGFechaRecibe" type="hidden" value="#rsGarantia.COEGFechaRecibe#" tabindex="1"/>	
		</td>
	</tr>
	<tr>
		<td align="right">
			<strong>Persona que entrega:</strong>&nbsp;
		</td>
		<td>
			<input name="COEGPersonaEntrega" id="COEGPersonaEntrega" type="text" style="width:70%" maxlength="254" value="#rsGarantia.COEGPersonaEntrega#" tabindex="1" readonly="true"/>
		</td>
		<td align="right">
			<strong>Identificación:</strong>&nbsp;
		</td>
		<td align="left">
			<input name="COEGIdentificacion" id="COEGIdentificacion" type="text" width="22" maxlength="21" value="#rsGarantia.COEGIdentificacion#" tabindex="1"  readonly="true"/>
		</td>
	</tr>
</table>

<!--- ****************************************************************************** Detalle ***************************************************************************** --->
<table border="0" width="100%"><tr>
	<td align="center">Detalles</td>
</tr>
<tr><td>
	<cf_dbfunction name="OP_CONCAT" returnvariable="_CAT">                        
	<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
	 returnvariable="pLista">
	   <cfinvokeargument name="tabla" 				value=" COHDGarantia a
															inner join Bancos b
															on b.Bid = a.Bid
															inner join COTipoRendicion c
															on c.COTRid = a.COTRid 
															inner join Monedas m
																on m.Mcodigo = a.CODGMcodigo"/>
		<cfinvokeargument name="columnas" 			value=" COEGid,
															CODGid ,
															CODGFecha,
															m.Msimbolo,
															CODGMonto,
															CODGMcodigo,
															CODGTipoCambio,
															CODGNumeroGarantia,
															CODGNumDeposito,
															CODGObservacion, 
															a.Bid,
															b.Bdescripcion,
															CBid,
															a.COTRid,
															c.COTRCodigo #_CAT# ' - ' #_CAT# c.COTRDescripcion as rendicion "/>
		<cfinvokeargument name="filtro" 			value=" a.COEGid = #form.COEGid# and a.COEGVersion = #LvarVersion#"/>
		<cfinvokeargument name="desplegar" 			value="CODGNumeroGarantia, CODGNumDeposito, rendicion, Bdescripcion, CODGMonto, Msimbolo"/>
		<cfinvokeargument name="etiquetas" 			value="Número de Garantía, Observación, Tipo Rendición, Banco, Monto,"/>
		<cfinvokeargument name="formatos" 			value="S,S,S,S,M,S"/>
		<cfinvokeargument name="align" 				value="left,left,left,left,right,left"/>
		<cfinvokeargument name="usaAJAX" 			value="no"/>
		<cfinvokeargument name="conexion" 			value="#session.DSN#"/>
		<cfinvokeargument name="ajustar" 			value="S"/>
		<cfinvokeargument name="showLink" 			value="true"/>
		<cfinvokeargument name="debug" 				value="N"/>
		<cfinvokeargument name="Keys" 				value="CODGid,COEGid"/>
		<cfinvokeargument name="mostrar_filtro" 	value="false"/>
		<cfinvokeargument name="filtrar_automatico" value="false"/> 
		<cfinvokeargument name="filtrar_por" 		value="CODGNumeroGarantia, COTRCodigo, Bdescripcion, CODGMonto"/>
		<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
		<cfinvokeargument name="MaxRows" 			value="0"/>
		<cfinvokeargument name="TabIndex" 			value="1"/>
		<cfinvokeargument name="incluyeform" 		value="false"/>
		<cfinvokeargument name="formname" 			value="form2"/>
	</cfinvoke>	
</td></tr></table>
<form action="libe_ejec_Garantia_SQL.cfm" name="form1" method="post">
	<table border="0" width="100%">
	<tr>
		<td align="center">Observaciones</td>
	</tr>
	<tr>
		<td align="center"><textarea name="observaciones" id="observaciones" wrap="virtual" style="width:100%; co"></textarea></td>
	</tr>
	<tr>
		<td>	                    
			<input name="COEGid" id="COEGid" type="hidden" value="#form.COEGid#">
			<input name="COEGVersion" id="COEGVersion" value="#LvarVersion#" type="hidden" />
			<input name="tipoMovimiento" id="tipoMovimiento" type="hidden" value="#form.tipoMovimiento#">
			<cfset incluir="">
			<cfif isdefined('form.tipoMovimiento') and len(trim(#form.tipoMovimiento#))>
				<cfif form.tipoMovimiento eq 1>
					<cfset incluir="Liberar,">
				<cfelseif form.tipoMovimiento eq 2>
					<cfset incluir="Ejecutar,">
				</cfif>
			</cfif>
			<cf_botones modo=#modo# exclude='BAJA,CAMBIO,NUEVO' include='#incluir#Regresar'>
		</td>
	</tr></table>
</form>
    <cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms>
<script language="javascript1.2" type="text/javascript">

	objForm.tipoMovimiento.description = "#JSStringFormat('Tipo de Moviemiento')#";
	objForm.tipoMovimiento.required = true;
	
	objForm.observaciones.description = "#JSStringFormat('Observaciones')#";
	objForm.observaciones.required = true;
	
	objForm.COEGid.description = "#JSStringFormat('Código de Garantía')#";
	objForm.COEGid.required = true;
	
	function funcRegresar(){
		document.form1.action = 'listaLiberacionGarantia.cfm';
		document.form1.submit();
	}
	
	function funcDevolver(){
		if(confirm("Desea devolver la garantía, desea continuar?"))
			return true;
		return false;
	}
	
	function funcLiberar(){
		if(confirm("Desea liberar la garantía, desea continuar?"))
			return true;
		return false;
	}

	
	function funcEjecutar(){
		if(confirm("Desea ejecutar la garantía, desea continuar?"))
			return true;
		return false;
	}

</script>
</cfoutput>