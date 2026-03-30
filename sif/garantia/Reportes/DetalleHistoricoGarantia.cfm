<cfif isdefined("url.COEGVersion") and not isdefined("form.COEGVersion") and len(trim(url.COEGVersion))>
	<cfset form.COEGVersion = url.COEGVersion>
</cfif>
<cfif isdefined("url.COEGid") and not isdefined("form.COEGid") and len(trim(url.COEGid))>
	<cfset form.COEGid = url.COEGid>
</cfif>
<cf_templateheader title="Historico Garantía">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Garantías Anteriores'>
		
<cfset form.versionAnterior  = #form.COEGVersion# - 1>
<cfset form.versionSiguiente = #form.COEGVersion# + 1>
<cfset form.versionActual = #form.COEGVersion#>

<cfquery name="rsVersionActGar" datasource="#session.DSN#">
	select max(COEGVersion) as COEGVersion
	from COHEGarantia a
	where a.COEGid = #url.COEGid#
</cfquery>

<cfquery name="rsHistGar" datasource="#session.DSN#">
	select 
    	a.COEGid, 
		a.COEGNumeroControl,
        a.COEGReciboGarantia, 
        a.CMPid, 
        a.COEGTipoGarantia, 
        a.COEGEstado,
        a.COEGVersion, 
        a.SNid, 
        a.COEGTipoGarantia, 
        a.COEGPersonaEntrega, 
        a.COEGMontoTotal, 
        a.COEGFechaRecibe, 
        c.SNnombre, 
        b.CMPProceso, 
        d.Mnombre, 
        case a.COEGEstado 
        	when 1 then 'Vigente' 
            when 2 then 'Edición' 
            when 3 then 'En proceso de Ejecución' 
            when 4 then 'En Ejecución' 
            when 5 then 'Ejecutada' 
            when 6 then 'En proceso Liberación' 
            when 7 then 'Liberada' 
            when 8 then 'Devuelta' 
        end as Estado
	from COHEGarantia a
			left join CMProceso b
				on b.CMPid  = a.CMPid
			left join SNegocios c
				on c.SNid = a.SNid
			inner join Monedas d
				on d.Mcodigo = a.Mcodigo
	where a.COEGid = #form.COEGid#
	and COEGVersion= #form.COEGVersion# - 1
	and COEGVersionActiva = 2
</cfquery>

<table cellpadding="2" cellspacing="0" align="center" border="0" width="100%">
<tr> <td>
<cfoutput>
	<form name="form1" action="HistoricoGarantias.cfm" method="post">                
			<cf_navegacion name="COEGid" default="" 	navegacion="navegacion">
				 <table cellpadding="2" cellspacing="0" align="center" border="0" width="100%">
					  <tr>              	
							<td align="right" nowrap><strong>Proceso:</strong></td>
								<td nowrap>
									<input type="hidden" id="CMPProceso" name="CMPProceso" value="#rsHistGar.CMPProceso#" tabindex="1">
								#rsHistGar.CMPProceso# 
							</td>
							<td align="right">
								<strong>Garantía:</strong>&nbsp;
							</td>
							<td align="left">
									#rsHistGar.COEGReciboGarantia#
								<input name="COEGReciboGarantia" value="#rsHistGar.COEGReciboGarantia#" type="hidden" tabindex="1"/>							
							</td>
					  </tr>
					  <tr>
						<td align="right" nowrap><strong>Provedor:</strong></td>
						<td nowrap>
						<input type="hidden" id="SNnombre" name="SNnombre" value="#rsHistGar.SNnombre#" tabindex="1"> #rsHistGar.SNnombre# </td>
						<td colspan="1" align="right"> <strong>Total Garantía:</strong>&nbsp; </td>
							<td align="left">
								<input name="COEGMontoTotal" id="COEGMontoTotal" value="#numberformat(rsHistGar.COEGMontoTotal,',_.__')#" type="hidden" tabindex="1" disabled="disabled"/>                     #numberformat(rsHistGar.COEGMontoTotal,',_.__')#
							</td>
					  </tr>
					  <tr>
							<td align="right" nowrap><strong>Tipo Garantia:</strong></td>
						<td nowrap>
						<input type="hidden" id="COEGTipoGarantia" name="COEGTipoGarantia" value="#rsHistGar.COEGTipoGarantia#" tabindex="1"> <cfif #rsHistGar.COEGTipoGarantia# eq 1>Participación</cfif> <cfif #rsHistGar.COEGTipoGarantia# eq 2>Cumplimiento</cfif></td>			
							<td colspan="1" align="right"> <strong>Moneda:</strong>&nbsp; </td>
							<td align="left">
								 <input name="Mcodigo"  id="Mcodigo"  value="#rsHistGar.Mnombre#" type="hidden" tabindex="1"/> #rsHistGar.Mnombre# </td>
					  </tr>
						<tr>                    	
							<td nowrap align="right"> <strong>Estado:</strong>&nbsp; </td>
							<td nowrap> 
								 <input name="COEGEstado" id="COEGEstado" value="#rsHistGar.Estado#" type="hidden" /> #rsHistGar.Estado#<!--- 1: vigente, 2: Edicion, 3: En proceso de Ejecución, 4: En Ejecución, 5: Ejecutada, 6: En proceso Liberación, 7: Liberada,  8:Devuelta --->
						 </td>
						<td align="right" nowrap><strong>Versión:</strong>&nbsp;</td>
						<td nowrap>
						<input type="hidden" id="COEGVersion" name="COEGVersion" value="#rsHistGar.COEGVersion#" tabindex="1"> #rsHistGar.COEGVersion# </td>
					  </tr>                    
					  <tr>
							<td align="right" nowrap="nowrap"> <strong>Fecha Recepción:</strong>&nbsp; </td>
							<td align="left" colspan="3">
								 <input name="COEGFechaRecibe" id="COEGFechaRecibe" type="hidden" value="#rsHistGar.COEGFechaRecibe#" tabindex="1"/>#LSdateformat(rsHistGar.COEGFechaRecibe,'dd/mm/yyyy hh:mm:ss')# </td>
					  </tr> 	
					  <tr>
							<td align="right" nowrap="nowrap"> <strong>N&uacute;mero de Control:</strong>&nbsp; </td>
							<td align="left" colspan="3">
								 <input name="COEGNumeroControl" id="COEGNumeroControl" type="hidden" value="#rsHistGar.COEGNumeroControl#" tabindex="1"/>#rsHistGar.COEGNumeroControl# </td>
					  </tr> 	
						<tr>
							<td align="left" colspan="3">
								<cfif #rsHistGar.COEGVersion# GT 1>							 
									<input name="Anterior" type="button"
									onclick="javascript=window.location.href='DetalleHistoricoGarantia.cfm?COEGVersion=#form.versionAnterior#&COEGid=#form.COEGid#'" value="Anterior" tabindex="1" /> 
								</cfif>
							</td>
							<td align="right" colspan="3">
								<cfif #form.versionSiguiente# LTE #rsVersionActGar.COEGVersion# >	 
									<input name="Siguiente" type="button" 
									onclick="javascript=window.location.href='DetalleHistoricoGarantia.cfm?COEGVersion=#form.versionSiguiente#&COEGid=#form.COEGid#'" value="Siguiente" tabindex="1" />
								</cfif>
							</td>
					  </tr>                  
				</table>
			</form>    
</cfoutput>
<cfoutput>           	
	<cfflush interval="16">
	<!--- Mantener los filtros al navegar --->
	<cf_navegacion name="CODGNumeroGarantia" 	  default="" 	navegacion="navegacion">
	<cf_navegacion name="Bdescripcion"   		  default="" 	navegacion="navegacion">
	<cf_navegacion name="CODGMonto" 			  default="" 	navegacion="navegacion">

	<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
	 returnvariable="pLista">
		<cfinvokeargument name="columnas" value=" COEGid,
        										  CODGid,
                                                  CODGFecha,
                                                  CODGMonto,
												  CODGMcodigo,
                                                  CODGTipoCambio,
												  CODGNumeroGarantia,
                                                  CODGNumDeposito, 
												  CODGFechaIni, 
                                                  CODGFechaFin, 
												  a.Bid,
                                                  a.COEGVersion,
                                                  b.Bdescripcion,
												  CBid,
                                                  a.COTRid,
                                                  c.COTRCodigo,
												  c.COTRDescripcion, 
                                                  d.Mnombre,
												  a.CODGObservacion"/>
		<cfinvokeargument name="tabla" 	  value=" COHDGarantia a
													inner join Bancos b
													on b.Bid = a.Bid
													inner join COTipoRendicion c
													on c.COTRid = a.COTRid
													inner join Monedas d
													on d.Mcodigo = a.CODGMcodigo"/>
		<cfinvokeargument name="filtro" 			value="COEGid = #form.COEGid# and COEGVersion = #form.COEGVersion# -1"/>
		<cfinvokeargument name="desplegar" 	value="CODGNumeroGarantia, COTRDescripcion, Bdescripcion, CODGMonto,Mnombre,CODGFechaIni, CODGFechaFin, CODGObservacion"/>
		<cfinvokeargument name="etiquetas" 	value="N° Garantía, Tipo Rendición, Banco, Monto, Moneda,Fecha Inicio, Fecha Fin, Observación"/>
		<cfinvokeargument name="formatos" 	value="S,S,S,U,S,D,D,S"/>
		<cfinvokeargument name="align" 		value="left,left,left,left,left,left,left,left"/>
		<cfinvokeargument name="usaAJAX" 	value="no"/>
		<cfinvokeargument name="conexion" 	value="#session.DSN#"/>
		<cfinvokeargument name="ajustar" 	value="S"/>
		<cfinvokeargument name="showLink" 			value="true"/>
		<cfinvokeargument name="debug" 				value="N"/>
		<cfinvokeargument name="Keys" 				value="CODGid,COEGid"/>
		<cfinvokeargument name="mostrar_filtro" 	value="False"/>
		<cfinvokeargument name="filtrar_automatico" value="False"/>
		<cfinvokeargument name="filtrar_por" 		value="CODGNumeroGarantia, COTRCodigo, Bdescripcion, ' ',CODGFechaIni, CODGFechaFin"/>
		<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
		<cfinvokeargument name="MaxRows" 			value="0"/>
		<cfinvokeargument name="TabIndex" 			value="1"/>
		<cfinvokeargument name="incluyeform" 		value="False"/>
		<cfinvokeargument name="formname" 			value="formDetalles"/>
		<!---<cfinvokeargument name="botones" 			value="#LvarBotones#"/>--->
	</cfinvoke>	            	
</cfoutput>
<cf_web_portlet_end>	

    	</td>
    </tr>
    <tr>
    	<td>
    		<cfinclude template="DetalleHistoricoGarantiaActivo.cfm">
    	</td>
    </tr>
</table>
<cf_templatefooter>