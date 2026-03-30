<cfif isdefined("url.COEGVersion") and not isdefined("form.COEGVersion") and len(trim(url.COEGVersion))>
	<cfset form.COEGVersion = url.COEGVersion>
</cfif>
<cfif isdefined("url.COEGid") and not isdefined("form.COEGid") and len(trim(url.COEGid))>
	<cfset form.COEGid = url.COEGid>
</cfif>
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Garantía Activa'>	
<cfquery name="rsVersionActGar" datasource="#session.DSN#">
	select max(COEGVersion) as COEGVersion
	from COHEGarantia a
	where a.COEGid = #url.COEGid#
	and COEGVersionActiva = 1
</cfquery>	

<cfquery name="rsHistGar" datasource="#session.DSN#">
	select 
    	a.COEGid, 
		a.COEGNumeroControl,
	    a.COEGReciboGarantia, 
        a.CMPid, 
        a.COEGTipoGarantia, 
        a.COEGEstado, 
        a.COEGDocDevOEjec,
        a.COEGFechaDevOEjec,
        a.COEGUsuCodigoDevOEjec, 
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
        end as Estado,
		cl.COLGObservacion,
		cl.COLGnumeroControl
	from COHEGarantia a
	        left  join COLiberaGarantia cl
			    on cl.COEGid = a.COEGid
			left join CMProceso b
				on b.CMPid  = a.CMPid
			left join SNegocios c
				on c.SNid = a.SNid
			inner join Monedas d
				on d.Mcodigo = a.Mcodigo
	where a.COEGid = #url.COEGid#
	and a.COEGVersion= #rsVersionActGar.COEGVersion#
	and a.COEGVersionActiva = 1
</cfquery>
<cfoutput>

	<form name="form1" action="" method="post">
    <cf_navegacion name="COEGid" default="" 	navegacion="navegacion">
    <table cellpadding="2" cellspacing="0" align="center" border="0" width="100%">
        <tr>              	
				<td align="right" nowrap><strong>Proceso:</strong>&nbsp;</td>
     			<td nowrap>
        			<input type="hidden" id="CMPProceso" name="CMPProceso" value="#rsHistGar.CMPProceso#" tabindex="1"> #rsHistGar.CMPProceso# </td>						
				<td align="right" nowrap> <strong>Garantía:</strong>&nbsp;</td>
            <td nowrap>                          	
              	<input name="COEGReciboGarantia" value="#rsHistGar.COEGReciboGarantia#" type="hidden" tabindex="1"/> #rsHistGar.COEGReciboGarantia#	</td>
         </tr>
          <tr>
           	<td align="right" nowrap><strong>Provedor:</strong></td>
     			<td nowrap>
        			<input type="hidden" id="SNnombre" name="SNnombre" value="#rsHistGar.SNnombre#" tabindex="1"> #rsHistGar.SNnombre# </td> 
           	<td align="right" nowrap> <strong>Total Garantía:</strong>&nbsp; </td>
             <td nowrap>
              	<input name="COEGMontoTotal" id="COEGMontoTotal" value="#numberformat(rsHistGar.COEGMontoTotal,',_.__')#" type="hidden" tabindex="1" disabled="disabled"/>                     #numberformat(rsHistGar.COEGMontoTotal,',_.__')#</td>
          </tr>
          <tr> 
				<td align="right" nowrap><strong>Tipo Garantia:</strong></td>
					<td nowrap>
					<input type="hidden" id="COEGTipoGarantia" name="COEGTipoGarantia" value="#rsHistGar.COEGTipoGarantia#" tabindex="1"> <cfif #rsHistGar.COEGTipoGarantia# eq 1>Participación</cfif> <cfif #rsHistGar.COEGTipoGarantia# eq 2>Cumplimiento</cfif></td>                       
				<td nowrap align="right"> <strong>Moneda:</strong>&nbsp; </td>
            <td align="left">
                <input name="Mcodigo"  id="Mcodigo"  value="#rsHistGar.Mnombre#" type="hidden" tabindex="1"/> #rsHistGar.Mnombre# </td> 
           </tr>
           <tr> 
					<td nowrap align="right"> <strong>Estado:</strong>&nbsp; </td>
                <td nowrap> 
                   <input name="COEGEstado" id="COEGEstado" value="#rsHistGar.Estado#" type="hidden" /> #rsHistGar.Estado#<!--- 1: vigente, 2: Edicion, 3: En proceso de Ejecución, 4: En Ejecución, 5: Ejecutada, 6: En proceso Liberación, 7: Liberada,  8:Devuelta --->
                 </td>
						<td align="right" nowrap><strong>Versión:&nbsp;</strong></td>
            		<td nowrap>
                		<input type="hidden" id="COEGVersion" name="COEGVersion" value="#rsHistGar.COEGVersion#" tabindex="1"> #rsHistGar.COEGVersion# </td>
             </tr>                    
              <tr>
                  <td align="right" nowrap="nowrap"> <strong>Fecha Recepción:</strong>&nbsp; </td>
                  <td align="left" colspan="1">
                     <input name="COEGFechaRecibe" id="COEGFechaRecibe" type="hidden" value="#rsHistGar.COEGFechaRecibe#" tabindex="1"/>#LSdateformat(rsHistGar.COEGFechaRecibe,'dd/mm/yyyy hh:mm:ss')# 
                  </td>
                  <td align="right">
							<cfset LvarDocLabel = ''>
							<cfif rsHistGar.COEGEstado eq 8>
								  <strong>Documento de Devolución:</strong>
							 <cfelseif rsHistGar.COEGEstado eq 5>
								  <strong>Documento de Ejecución:</strong>
							 </cfif>
							 &nbsp;
						</td>
                  <td>
                   	<cfif rsHistGar.COEGEstado eq 8 or rsHistGar.COEGEstado eq 5>
								#rsHistGar.COLGnumeroControl#, el día #DateFormat(rsHistGar.COEGFechaDevOEjec,'dd-mm-yyyy')#
                      </cfif>
                  </td>
					<tr>
					   <td colspan="2">                  
                     <strong>N&uacute;mero de Control:</strong>&nbsp; 
                        <input name="COEGNumeroControl" id="COEGNumeroControl" type="hidden" value="#rsHistGar.COEGNumeroControl#" tabindex="1"/>#rsHistGar.COEGNumeroControl# </td>
					   <td align="right"><cfif rsHistGar.COEGEstado eq 8><strong>Observación:</strong></cfif></td>
					   <td>
					   	<cfif rsHistGar.COEGEstado eq 8>
					       	 #rsHistGar.COLGObservacion#
							</cfif>	
					   </td>
					</tr>	
               </tr>
           </table>        
		</form>
</cfoutput>

<!---TABLA II--->

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
		<cfinvokeargument name="filtro" 			value="a.COEGid = #form.COEGid# and COEGVersion = #rsVersionActGar.COEGVersion#"/>
		<cfinvokeargument name="desplegar" 	value="CODGNumeroGarantia, COTRDescripcion, Bdescripcion, CODGMonto,Mnombre,CODGFechaIni, CODGFechaFin,CODGObservacion"/>
		<cfinvokeargument name="etiquetas" 	value="N° Garantía, Tipo Rendición, Banco, Monto, Moneda,Fecha Inicio, Fecha Fin, Observación"/>
		<cfinvokeargument name="formatos" 	value="S,S,S,U,S,D,D,S"/>
		<cfinvokeargument name="align" 		value="left,left,left,left,left,left,left,left"/>
		<cfinvokeargument name="usaAJAX" 			value="no"/>
		<cfinvokeargument name="conexion" 			value="#session.DSN#"/>
		<cfinvokeargument name="ajustar" 			value="S"/>
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
		<cfinvokeargument name="formname" 			value="formDetalleGarAct"/>
	</cfinvoke>	            					
</cfoutput>
<cf_web_portlet_end>