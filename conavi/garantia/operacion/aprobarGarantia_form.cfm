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
	e.COLGFechaAprobacion
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
	<cfset LvarTCventaE = BuscaTC(rsLiberaGarantia.Mcodigo, rsLiberaGarantia.COEGFechaRecibe,'V')> 
    
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
															Miso4217,
															CODGMcodigo,
															CODGObservacion,
															CODGTipoCambio,
															CODGNumeroGarantia,
															CODGNumDeposito, 
															a.Bid,
															b.Bdescripcion,
															CBid,
															a.COTRid,
                                                            a.CODGFechaFin,
                                                            ((a.CODGMonto * a.CODGTipoCambio) / #LvarTCventaE#) as MontoMonedaEncabezado,
															c.COTRCodigo #_CAT# ' - ' #_CAT# c.COTRDescripcion as rendicion"/>
		<cfinvokeargument name="filtro" 			value=" a.COEGid = #form.COEGid# and a.COEGVersion = #LvarVersion#"/>
		<cfinvokeargument name="desplegar" 			value="CODGNumeroGarantia, CODGObservacion, rendicion, Bdescripcion, CODGMonto, Miso4217, MontoMonedaEncabezado, CODGFechaFin"/>
		<cfinvokeargument name="etiquetas" 			value="Número de Garantía, Observación, Tipo Rendición, Banco, Monto, Moneda, Monto Moneda Encabezado, Vencimiento"/>
		<cfinvokeargument name="formatos" 			value="S,S,S,S,M,S,M,D"/>
		<cfinvokeargument name="align" 				value="left,left,left,left,right,left,right,right"/>
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
        <cfinvokeargument name="showlink" 			value="false"/>
	</cfinvoke>	
</td></tr></table>
<form action="aprobarGarantia_SQL.cfm" name="form1" method="post">
	<table border="0" width="100%">
	<tr>
		<cfif rsLiberaGarantia.COLGTipoMovimiento eq 1>
			<cfset valor="Liberaci&oacute;n">
		<cfelseif rsLiberaGarantia.COLGTipoMovimiento eq 2>
			<cfset valor="Ejecuci&oacute;n">
		</cfif>
		<td align="center">Fecha Inicio #valor#:</td>
	</tr>
	<tr>
		<td align="center"><cf_sifcalendario name="fecha" value="#LSDateFormat(rsLiberaGarantia.COLGFecha,'dd/mm/yyyy')#" tabindex="1" form="form1" readonly="true"></td>
	</tr>
	<cfif rsLiberaGarantia.COEGEstado eq 3 or rsLiberaGarantia.COEGEstado eq 4 or rsLiberaGarantia.COEGEstado eq 6 or rsLiberaGarantia.COEGEstado eq 7>
		<cfif rsLiberaGarantia.COEGEstado eq 4 or rsLiberaGarantia.COEGEstado eq 7>
			<cfset readonly = true>
		<cfelse>
			<cfset readonly = false>
		</cfif>
		<cfif len(trim(rsLiberaGarantia.COLGFechaAprobacion))>
			<cfset fecha = LSDateFormat(rsLiberaGarantia.COLGFechaAprobacion,'dd/mm/yyyy')>
		<cfelse>
			<cfset fecha = LSDateFormat(now(),'dd/mm/yyyy')>
		</cfif>
	<tr>
		<td align="center">Fecha Aprobación/Rechazo <cfif rsLiberaGarantia.COEGEstado eq 3>#valor#<cfelse> #valor#;</cfif>:</td>
	</tr>
	<tr>
		<td align="center"><cf_sifcalendario name="fechaAp" value="#LSDateFormat(fecha,'dd/mm/yyyy')#" tabindex="1" form="form1" readonly="#readonly#"></td>
	</tr>
	</cfif>
	<cfif rsLiberaGarantia.COEGEstado eq 4 or rsLiberaGarantia.COEGEstado eq 7>
	<tr>
		<td align="center">Fecha de <cfif rsLiberaGarantia.COEGEstado eq 4>#valor#<cfelse> Devoluci&oacute;n</cfif>:</td>
	</tr>
	<tr>
		<td align="center"><cf_sifcalendario name="fechaDE" value="#LSDateFormat(now(),'dd/mm/yyyy')#" tabindex="1" form="form1"></td>
	</tr>
	</cfif>
	<tr>
		<td align="center">Observaciones&nbsp;:</td>
	</tr>
	<tr>
		<td align="center"><textarea name="observaciones" id="observaciones" wrap="virtual" style="width:100%" readonly="readonly">#rsLiberaGarantia.COLGObservacion#</textarea></td>
	</tr>
	<tr>
		<td>	                    
			<input name="COEGid" id="COEGid" type="hidden" value="#form.COEGid#">
			<input name="COLGid" id="COLGid" type="hidden" value="#form.COLGid#">
			<input name="COEGVersion" id="COEGVersion" type="hidden" value="#form.COEGVersion#">
			<cfset sufijo="">
			<cfif isdefined('rsLiberaGarantia.COLGTipoMovimiento') and len(trim(#rsLiberaGarantia.COLGTipoMovimiento#))>
				<cfif rsLiberaGarantia.COLGTipoMovimiento eq 1 and rsLiberaGarantia.COLGEstado eq 2>
					<cfset sufijo="_L">
				<cfelseif rsLiberaGarantia.COLGTipoMovimiento eq 2 and rsLiberaGarantia.COLGEstado eq 2>
					<cfset sufijo="_E">
				<cfelseif rsLiberaGarantia.COLGTipoMovimiento eq 1 and rsLiberaGarantia.COLGEstado eq 3>
					<cfset sufijo="_D">	
				</cfif>
			</cfif>
			<cfif sufijo neq "_D">
				<cf_botones modo=#modo# sufijo="#sufijo#" exclude='BAJA,CAMBIO,NUEVO' include='Aprobar,Rechazar,Regresar'>
			<cfelseif sufijo eq "_D">
				<cf_botones modo=#modo# sufijo="#sufijo#" exclude='BAJA,CAMBIO,NUEVO' include='Aprobar,Regresar' includevalues="Devolver,Regresar">
			</cfif>
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
	
	function funcRegresar_E(){
		document.form1.action = 'listaAprobarEjecucionGarantia.cfm';
		document.form1.submit();
	}
	
	function funcAprobar_E(){
		if(confirm("Desea aprobar la ejecución de la garantía, desea continuar?"))
			return true;
		return false;
	}
	
	function funcRechazar_E(){
		if(confirm("Desea rechazar la ejecución de la garantía, desea continuar?"))
			return true;
		return false;
	}
	
	function funcRegresar_L(){
		document.form1.action = 'listaAprobarLiberacionGarantia.cfm';
		document.form1.submit();
	}
	
	function funcAprobar_L(){
		if(confirm("Desea aprobar la liberación de la garantía, desea continuar?"))
			return true;
		return false;
	}
	
	function funcRechazar_L(){
		if(confirm("Desea rechazar la liberación de la garantía, desea continuar?"))
			return true;
		return false;
	}
	
	function funcRegresar_D(){
		document.form1.action = 'listaDevolucionGarantia.cfm';
		document.form1.submit();
	}
	
	function funcAprobar_D(){
		if(confirm("Desea devolver la garantía, desea continuar?"))
			return true;
		return false;
	}
</script>
</cfoutput>

<cffunction name="BuscaTC" access="public" output="no" returntype="any">
	<cfargument name="Mcodigo" type="numeric" required="yes">
    <cfargument name="Fecha"   type="date" 	  required="yes">
    <cfargument name="TCxUsar" type="string"  required="yes" default="V" hint="V para venta y C para compra"> 
    
    <cfquery name="rsLocal" datasource="#session.dsn#">
        select Mcodigo 
        from Empresas 
        where Ecodigo = #session.Ecodigo#
    </cfquery>
    
    <cfif rsLocal.Mcodigo eq arguments.Mcodigo>
		<cfset LvarTC = 1.00>
	<cfelse>
    	<cfquery name="rsTC" datasource="#session.DSN#">
            select TCventa, TCcompra
            from Htipocambio
            where Mcodigo = #arguments.Mcodigo#
              and Hfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Fecha#">
              and Hfechah > <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.Fecha#">
        </cfquery>
    	<cfif rsTC.recordcount eq 0>
            <cfquery name="rsMiso" datasource="#session.dsn#">
                select Miso4217
                from Monedas 
                where Mcodigo = #arguments.Mcodigo#
            </cfquery>
            <cfthrow message="No se ha incluido un tipo de cambio para la moneda '#rsMiso.Miso4217#' en la fecha #arguments.Fecha#">
        </cfif>
        
        <cfif arguments.TCxUsar eq 'V'>
            <cfset LvarTC = rsTC.TCventa>
        <cfelse>
            <cfset LvarTC = rsTC.TCcompra>
        </cfif>
    </cfif>

	<cfreturn LvarTC>
</cffunction>