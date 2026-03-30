<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
<cfoutput>#pNavegacion#</cfoutput>
<cf_web_portlet_start border="true" titulo="Ejecución Garantías" skin="#Session.Preferences.Skin#">
	<cfquery name="rsLiberaGarantia" datasource="#session.DSN#">
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
			b.COEGEstado,
			e.COLGObservacion,
			e.COLGFecha,
			e.COLGTipoMovimiento,
			e.COLGEstado,
			case when b.COEGContratoAsociado = 'N' then 'NO' else 'SI' end as COEGContratoAsociado,
			case b.COEGEstado when 4 then e.COLGFechaAprobacion when 8 then e.COLGFechaRechazo end as fecha
		from COLiberaGarantia e
			inner join COHEGarantia b
				left join CMProceso a
				on b.CMPid = a.CMPid
			on b.COEGid = e.COEGid and b.COEGVersion = e.COEGVersion
			inner join SNegocios c
				on c.SNid = b.SNid
			inner join Monedas d
				on d.Mcodigo = b.Mcodigo
		where e.COLGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COLGid#">
</cfquery>
<cfif rsLiberaGarantia.recordcount >
	
</cfif>
<cfset LvarConsecutivo = rsLiberaGarantia.COEGReciboGarantia>
<cfset LvarVersion = rsLiberaGarantia.COEGVersion>
<cfoutput>
<table cellpadding="0" cellspacing="0" align="center" border="0" width="100%">
	<tr>
		<td colspan="1" align="right">
			<strong>Proceso:&nbsp;</strong>
		</td>
		<td align="left">
			<cfset valuesArray = ArrayNew(1)>
			 <cfif modo NEQ 'Alta'>
				<cfset ArrayAppend(valuesArray, rsLiberaGarantia.CMPid)>
				<cfset ArrayAppend(valuesArray, rsLiberaGarantia.CMPProceso)>
				<cfset ArrayAppend(valuesArray, rsLiberaGarantia.CMPLinea)>
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
		<td colspan="1" align="right"> <strong>Asociado a una Contratación:&nbsp;</strong> </td>
						<td><input type="hidden" name="COEGContratoAsociado" id="COEGContratoAsociado" tabindex="1" value="<cfif #rsLiberaGarantia.COEGContratoAsociado# EQ 'S'>SI<cfelse>NO</cfif>" readonly="true">
						#rsLiberaGarantia.COEGContratoAsociado#</td>						
		
	</tr>
	<tr>
		<td colspan="1" align="right">
			<strong>Moneda:</strong>&nbsp;
		</td>
		<td align="left">
			<input name="Miso4217" id="Miso4217" value="<cfif modo NEQ 'Alta'>#rsLiberaGarantia.Miso4217#</cfif>" type="text" tabindex="1" readonly="true"/>
		</td>
		<td colspan="1" align="right">
			<strong>Total Garant&iacute;a:</strong>&nbsp;
		</td>
		<td align="left">
			<input name="COEGMontoTotal" id="COEGMontoTotal" value="<cfif modo NEQ 'Alta'>#numberformat(rsLiberaGarantia.COEGMontoTotal,',_.__')#</cfif>" type="text" tabindex="1"  readonly="true"/>
		</td>
	</tr>
	<tr>
		<td colspan="1" align="right">
			<strong>Proveedor:&nbsp;</strong>
		</td>
		<td align="left" colspan="3">
			<cf_sifsociosnegocios2 tabindex="1" SNtiposocio='P' SNid='SNid' idquery='#rsLiberaGarantia.SNcodigo#' modificable="false">
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
			<cfif rsLiberaGarantia.COEGTipoGarantia eq 1>
				<cfset tipoGarantia="Participación">
			<cfelseif rsLiberaGarantia.COEGTipoGarantia eq 2>
				<cfset tipoGarantia="Cumplimiento">
			</cfif>
			<input name="COEGTipoGarantia" tabindex="1" id="COEGTipoGarantia" value="tipoGarantia" readonly="true">
		</td>
	</tr>
	<tr>
		<td align="right">
			<strong>Versión:</strong>&nbsp;
		</td>
		<td colspan="3">
			#LvarVersion#
			<input name="COEGVersion" id="COEGVersion" value="#LvarVersion#" type="hidden" />
		</td>
	</tr>
	<tr>
		<td align="right">
			<strong>Fecha Recepción:</strong>&nbsp;
		</td>
		<td align="left" colspan="1">
			#LSdateformat(rsLiberaGarantia.COEGFechaRecibe,'dd/mm/yyyy hh:mm:ss ')#
			<input name="COEGFechaRecibe" id="COEGFechaRecibe" type="hidden" value="#rsLiberaGarantia.COEGFechaRecibe#" tabindex="1"/>	
		</td>
		<td colspan="1" align="right"> <strong>Estado:</strong>&nbsp; </td>
		<td align="left"> 
			<!--- El estado en alta o cambio siempre va se en edición --->
			Edición
			<input name="COEGEstado" id="COEGEstado" value="2" type="hidden" /> <!--- 1: vigente, 2: Edicion, 3: En proceso de Ejecución, 4: En Ejecución, 5: Ejecutada, 6: En proceso Liberación, 7: Liberada,  8:Devuelta --->
		</td>
	</tr>
	<tr>
		<td align="right">
			<strong>Persona que entrega:</strong>&nbsp;
		</td>
		<td>
			<input name="COEGPersonaEntrega" id="COEGPersonaEntrega" type="text" style="width:70%" maxlength="254" value="#rsLiberaGarantia.COEGPersonaEntrega#" tabindex="1" readonly="true"/>
		</td>
		<td align="right">
			<strong>Identificación:</strong>&nbsp;
		</td>
		<td align="left">
			<input name="COEGIdentificacion" id="COEGIdentificacion" type="text" width="22" maxlength="21" value="#rsLiberaGarantia.COEGIdentificacion#" tabindex="1"  readonly="true"/>
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
															CODGMonto,
															Msimbolo,
															CODGMcodigo,
															CODGObservacion,
															CODGTipoCambio,
															CODGNumeroGarantia,
															CODGNumDeposito, 
															a.Bid,
															b.Bdescripcion,
															CBid,
															a.COTRid,
															c.COTRCodigo #_CAT# ' - ' #_CAT# c.COTRDescripcion as rendicion"/>
		<cfinvokeargument name="filtro" 			value=" a.COEGid = #form.COEGid# and a.COEGVersion = #LvarVersion#"/>
		<cfinvokeargument name="desplegar" 			value="CODGNumeroGarantia, CODGObservacion, rendicion, Bdescripcion, CODGMonto, Msimbolo"/>
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
<form action="aprobarGarantia_SQL.cfm" name="form1" method="post">
	<table border="0" width="100%">
	<tr>
		<cfif isdefined('rsLiberaGarantia.COLGTipoMovimiento') and len(trim(#rsLiberaGarantia.COLGTipoMovimiento#))>
			<cfif rsLiberaGarantia.COLGTipoMovimiento eq 1>
				<cfset valor="Liberaci&oacute;n">
			<cfelseif rsLiberaGarantia.COLGTipoMovimiento eq 2>
				<cfset valor="Ejecuci&oacute;n">
			</cfif>
		</cfif>
		<td align="center">Fecha Inicio #valor#&nbsp;:</td>
	</tr>
	<tr>
		<td align="center"><cf_sifcalendario name="fecha" value="#LSDateFormat(rsLiberaGarantia.COLGFecha,'dd/mm/yyyy')#" tabindex="1" form="form1" readonly="true"></td>
	</tr>
	<tr>
		<td align="center">Fecha Aprobación/Rechazo <cfif rsLiberaGarantia.COEGEstado eq 3>#valor#<cfelse> #valor#;</cfif>:</td>
	</tr>
	<tr>
		<td align="center"><cf_sifcalendario name="fechaAp" value="#LSDateFormat(rsLiberaGarantia.fecha,'dd/mm/yyyy')#" tabindex="1" form="form1" readonly="true"></td>
	</tr>
	<tr>
		<td align="center">Fecha de <cfif rsLiberaGarantia.COEGEstado eq 4>#valor#<cfelse> Devoluci&oacute;n</cfif>:</td>
	</tr>
	<tr>
		<td align="center"><cf_sifcalendario name="fechaDE" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1" form="form1"></td>
	</tr>
	<tr>
		<td align="center">Observaciones&nbsp;:</td>
	</tr>
	<tr>
		<td align="center"><textarea name="observaciones" id="observaciones" wrap="virtual" style="width:100%" readonly="readonly">#rsLiberaGarantia.COLGObservacion#</textarea></td>
	</tr>
	<tr>
		<td align="center">
			Documento:&nbsp;<input name="documento" id="documento" type="text" maxlength="254" size="100"><strong>&nbsp;* Obligatorio</strong>
		</td>
	</tr>
	<tr>
		<td>	                    
			<input name="COEGid" id="COEGid" type="hidden" value="#form.COEGid#">
			<input name="COLGid" id="COLGid" type="hidden" value="#form.COLGid#">
			<cf_botones modo=#modo# exclude='BAJA,CAMBIO,NUEVO' include='Finalizar,Regresar' includevalues="Finalizar Ejecución,Regresar">
		</td>
	</tr></table>
</form>
    <cf_web_portlet_end>
<cf_templatefooter>
<cf_qforms>
<script language="javascript1.2" type="text/javascript">

	objForm.documento.description = "#JSStringFormat('Documento')#";
	objForm.documento.required = true;
	
	function funcRegresar(){
		objForm.documento.required = false;
		document.form1.action = 'listaGarantiasEjecutadas.cfm';
		document.form1.submit();
	}
	
	function funcFinalizar(){
		if(confirm("Desea Finalizar la ejecución de la garantía, desea continuar?"))
			return true;
		return false;
	}
</script>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>