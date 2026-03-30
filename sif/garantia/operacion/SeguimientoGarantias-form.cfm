<cf_dbfunction name="OP_CONCAT" returnvariable="_Cat">


<cfif isdefined("url.CMPid") and not isdefined("form.CMPid") and len(trim(url.CMPid))>
	<cfset form.CMPid = url.CMPid>
</cfif>
<cfif isdefined("url.COEGid") and not isdefined("form.COEGid") and len(trim(url.COEGid))>
	<cfset form.COEGid = url.COEGid>
</cfif>
<cfset fecha= DateFormat(Now(),'dd/mm/yyyy')>
<cfparam name="form.MaxRows" default="10">
<cfif not isdefined("form.vieneform")>
	<cfset vieneform = "0">
</cfif>

<cfif vieneform eq '0'>
    <cfquery name="rsCMPProceso" datasource="#session.DSN#">
    	select
        	a.CMPid,
            a.CMPProceso,
            a.CMPLinea,
            b.Mcodigo, 
            CMPMontoProceso,
            b.COEGid,
            b.COEGPersonaEntrega,
            b.COEGReciboGarantia,
            c.SNid,
            b.SNid,
            c.SNnombre, 
            case when b.COEGTipoGarantia = 1 
            	then 
                	'Participación' 
                else 
                	'Cumplimiento' 
                end as COEGTipoGarantia,
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
            b.COEGFechaRecibe, 
            b.COEGMontoTotal, 
            d.CODGMonto, 
            d.CODGFecha, 
            d.CODGFechaFin, 
            e.COTRDescripcion, 
            f.Bdescripcion, 
            d.CODGNumDeposito, 
            g.Mnombre   
        from COHEGarantia b
			left join CMProceso a
				on a.CMPid  = b.CMPid
			inner join SNegocios c
				on c.SNid = b.SNid
			inner join COHDGarantia d
				on d.COEGid = b.COEGid
			inner join COTipoRendicion e
				on 	e.COTRid = d.COTRid
			inner join Bancos f
				on f.Bid = d.Bid
			inner join Monedas g
				on g.Mcodigo = b.Mcodigo  			
        where b.Ecodigo = #session.Ecodigo#	
		and b.COEGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COEGid#">		
		and b.COEGVersionActiva= 1
    </cfquery>
</cfif>

<cfif vieneform eq '1'>
    <cfquery name="rsCMPProceso" datasource="#session.DSN#">
    	select 
        	a.COSGid, 
            a.COEGid, 
            a.COSGObservacion, 
            a.COSGFecha, 
            a.COSGUsucodigo, 
            a.BMUsucodigo, 
            c.CMPProceso, 
            c.CMPid,
            c.CMPLinea,
            b.COEGReciboGarantia,
            b.Mcodigo, 
            d.SNnombre,
            case when b.COEGTipoGarantia = 1 
            	then 
                	'Participación' 
                else 
                	'Cumplimiento' 
                end as COEGTipoGarantia, 
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
            b.COEGFechaRecibe, 
            b.COEGMontoTotal, 
            e.CODGMonto, 
            e.CODGFecha, 
            e.CODGFechaFin, 
            f.COTRDescripcion, 
            g.Bdescripcion, 
            e.CODGNumDeposito, 
            h.Mnombre, 
            b.COEGid
        from COSeguiGarantia a
			inner join COHEGarantia b 
			on b.COEGid = a.COEGid
			left join CMProceso c
			on c.CMPid  = b.CMPid
			inner join SNegocios d
			on d.SNid = b.SNid
			inner join COHDGarantia e
			on e.COEGid = b.COEGid
			inner join COTipoRendicion f
			on 	f.COTRid = e.COTRid
			inner join Bancos g
			on g.Bid = e.Bid
			inner join Monedas h
			on h.Mcodigo = b.Mcodigo
		where a.COSGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.COSGid#">	
    </cfquery>
</cfif>
<cf_templateheader title="Seguimientos de Garantías">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
	<cf_web_portlet_start skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Seguimiento de Garantias'>
		<cfoutput>
            <form name="form1" action="SeguimientoGarantias_SQL.cfm" method="post">               
            <cf_navegacion name="CMPid" default="" 	navegacion="navegacion">
				<table>				
                    <tr>
                    	<td align="right" nowrap><strong>Proceso:</strong></td>
            			<td nowrap>
                		<input type="hidden" id="CMPProceso" name="CMPProceso" value="#rsCMPProceso.CMPProceso#" tabindex="1">
                		#rsCMPProceso.CMPProceso# </td>
				
                		<input type="hidden" id="CMPid" name="CMPid" value="#rsCMPProceso.CMPid#" tabindex="1">
                		<input type="hidden" id="COEGid" name="COEGid" value="#rsCMPProceso.COEGid#" tabindex="1">
						
                    <tr>
                    	<td align="right" nowrap><strong>Linea:</strong></td>
            			<td nowrap>
                		<input type="hidden" id="CMPLinea" name="CMPLinea" value="#rsCMPProceso.CMPLinea#" tabindex="1">
                		#rsCMPProceso.CMPLinea# </td>
                    </tr>
					
                    <tr>
                    	<td align="right" nowrap><strong>Garantia:</strong></td>
            			<td nowrap>
                		<input type="hidden" id="COEGReciboGarantia" name="COEGReciboGarantia" value="#rsCMPProceso.COEGReciboGarantia#" tabindex="1">
                		#rsCMPProceso.COEGReciboGarantia# </td>                    
                    	<td align="right" nowrap><strong>Proveedor:</strong></td>
            			<td nowrap>
                		<input type="hidden" id="SNnombre" name="SNnombre" value="#rsCMPProceso.SNnombre#" tabindex="1">
                		#rsCMPProceso.SNnombre# </td>
                    </tr>
                    <tr>
                    	<td align="right" nowrap colspan="1">
                        	<strong>Estado de la garantía:</strong> 
                        </td>
                        <td>
                        	#rsCMPProceso.Estado#
                        </td>
                    </tr>
					
					<tr>
                    	<td align="right" nowrap><strong>Tipo Garantia:</strong></td>
            			<td nowrap>
                		<input type="hidden" id="COEGTipoGarantia" name="COEGTipoGarantia" value="#rsCMPProceso.COEGTipoGarantia#" tabindex="1">
                		#rsCMPProceso.COEGTipoGarantia# </td>
                    	<td align="right" nowrap><strong>Fecha Recibe:</strong></td>
            			<td nowrap>
                		<input type="hidden" id="COEGFechaRecibe" name="COEGFechaRecibe" value="#rsCMPProceso.COEGFechaRecibe#" tabindex="1">
                		#LSDateFormat(rsCMPProceso.COEGFechaRecibe,'dd/mm/yyyy')# </td>  
                    </tr>
					
					<tr>
						<td align="right" nowrap><strong>Monto Garantia:</strong></td>
            			<td nowrap>
                		<input type="hidden" id="COEGMontoTotal" name="COEGMontoTotal" value="#rsCMPProceso.COEGMontoTotal#" tabindex="1">
                		#NumberFormat(rsCMPProceso.COEGMontoTotal,',_.__')#</td>                    	  
					<td align="right" nowrap><strong>Moneda:</strong></td>
            			<td nowrap>
                		<input type="hidden" id="Mnombre" name="Mnombre" value="#rsCMPProceso.Mnombre#" tabindex="1">
                		#rsCMPProceso.Mnombre# </td>                   	
                    </tr>					
					<tr><td></td></tr> <tr><td></td></tr> <tr><td></td></tr> <tr><td></td></tr>								
									
					<tr>
						<td align="right" nowrap rowspan="2" valign="top"><strong>Observaciones:</strong></td>
            			<td rowspan="2">
							<cfif vieneform eq '0'>
							<textarea cols="36" rows="3" name="COSGObservacion" tabindex="1"></textarea>
							</cfif>
							<cfif vieneform eq '1'>
							<input type="hidden" id="COSGObservacion" name="COSGObservacion" value="#rsCMPProceso.COSGObservacion#" tabindex="1">
                		#rsCMPProceso.COSGObservacion# </td>
							</cfif>
            			</td>
					
						<td align="right" nowrap><strong><cfif vieneform eq '1'>Fecha Observación:</cfif></strong> </td>
						<td>
							<cfif vieneform eq '0'>
							<cf_sifcalendario name="Pfecha" id="Pfecha" tabindex="1" 
					onchange="obtenerTC(this.form);" onblur="obtenerTC(this.form);" value="#fecha#">
							</cfif>
							<cfif vieneform eq '1'>
							<input type="hidden" id="COSGFecha" name="COSGFecha" value="#rsCMPProceso.COSGFecha#" tabindex="1">                		 
						 Fecha Observación: #LSDateFormat(rsCMPProceso.COSGFecha,'dd/mm/yyyy')#
							</cfif>							
					</td>
					</tr>
					
					<tr>
						<td align="right" nowrap></td>
            			<td nowrap="2">
							<cfif vieneform eq '0'>
								<input name="CambiarE" type="submit" value="Agregar" tabindex="1">
							</cfif> 
						</td>
					</tr>
                    <cfif vieneform eq '1'>
                        <tr>
                            <td></td><td></td>
                            <td align="center">
                                <input name="nuevo" type="button" 
                                onclick="javascript=window.location.href='SeguimientoGarantias-form.cfm?CMPid=#form.CMPid#&COEGid=#rsCMPProceso.COEGid#'" value="Nuevo" tabindex="1" />
                            </td>
                        </tr>
                    </cfif>
                </table>	
	</form>				
				
		<!---TABLA QUE MUESTRA LOS DISTINTOS DETALLES DE UNA GARANTIA--->				
				<table cellpadding="0" cellspacing="0" border="0" width="100%" title="Detalles de la Garantia">
					<tr>
						<td style="vertical-align:top" width="100%">
                        	<cfset LvarTCventaE = BuscaTC(rsCMPProceso.Mcodigo, rsCMPProceso.COEGFechaRecibe,'V')> 
                            
							<cfflush interval="16">
						  
							<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
							returnvariable="pLista">
							<cfinvokeargument name="tabla" 	value=" COHDGarantia a
                                                                    inner join COHEGarantia b
                                                                    on b.COEGid = a.COEGid
																	and a.COEGVersion = b.COEGVersion
                                                                    left join CMProceso c
                                                                    on c.CMPid  = b.CMPid
                                                                    inner join SNegocios d
                                                                    on d.SNid = b.SNid
                                                                    inner join COTipoRendicion f
                                                                    on 	f.COTRid = a.COTRid
                                                                    inner join Bancos g
                                                                    on g.Bid = a.Bid
                                                                    inner join Monedas h
                                                                    on h.Mcodigo=b.Mcodigo"/>																											
								<cfinvokeargument name="columnas"       value="a.CODGid, 
                                											   a.COEGid, 
                                                                               f.COTRDescripcion, 
                                                                               a.CODGMonto, 
                                                                               h.Mnombre, 
                                                                               a.CODGFechaFin, 
                                                                               g.Bdescripcion,
                                                                               a.CODGNumeroGarantia,
                                                                               ((a.CODGMonto * a.CODGTipoCambio) / #LvarTCventaE#) as MontoMonedaEncabezado"/>
								<cfinvokeargument name="filtro" 		value="a.COEGid = #rsCMPProceso.COEGid# and b.COEGVersionActiva= 1"/>
								<cfinvokeargument name="desplegar" 		value="CODGNumeroGarantia, COTRDescripcion, CODGMonto, Mnombre, MontoMonedaEncabezado, CODGFechaFin , Bdescripcion"/>
								<cfinvokeargument name="etiquetas" 		value="Documento, Tipo, Monto , Moneda, Monto moneda encabezado, Fecha Vencimiento, Banco"/>
								<cfinvokeargument name="formatos" 		value="S,S,M,S,M,D,S"/>
								<cfinvokeargument name="align" 			value="left,left,right,center,right,center,left"/>
								<cfinvokeargument name="usaAJAX" 		value="no"/>
								<cfinvokeargument name="conexion" 		value="#session.DSN#"/>
								<cfinvokeargument name="ajustar" 		value="S"/>
								<cfinvokeargument name="debug" 			value="N"/>
								<cfinvokeargument name="Keys" 			value="CODGid"/>
								<cfinvokeargument name="mostrar_filtro" value="False"/>
								<cfinvokeargument name="filtrar_automatico" value="false"/> 
								<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
                                <cfinvokeargument name="showlink" 		value="false"/>
								<cfinvokeargument name="MaxRows" 		value="30"/>
								<cfinvokeargument name="PageIndex" 		value="2"/>	
								<cfinvokeargument name="incluyeForm" 	value="false"/>
								<cfinvokeargument name="formName" 		value="formDetalles"/>
																			
							</cfinvoke>	
						</td>
					</tr>
				</table>
				
		<!---TABLA QUE MUESTRA LAS DISTINTAS OBSERVACIONES REALIZADAS A UNA GARANTIA--->
		<cfset LvarNombre = "f.Pnombre #_Cat# '' #_Cat# f.Papellido1 #_Cat# '' #_Cat# f.Papellido2">
				<table cellpadding="0" cellspacing="0" border="0" width="100%" title="Observaciones de la Garantia">
					<tr>
						<td style="vertical-align:top" width="100%">
							<cfflush interval="16">
                            <cfset Navegacion = Navegacion&'&COEGid=' &form.COEGid>
							<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
							 returnvariable="pLista">
								<cfinvokeargument name="tabla" 			value="COSeguiGarantia a
																				inner join COEGarantia b
																				on b.COEGid = a.COEGid
																				left join CMProceso c
																				on c.CMPid  = b.CMPid
																				inner join SNegocios d
																				on d.SNid = b.SNid
                                                                                left outer join Usuario e																				
                                                                                on e.Usucodigo = a.COSGUsucodigo
																				left outer join DatosPersonales f
																				on  e.datos_personales= f.datos_personales 
                                                                                "/>
								<cfinvokeargument name="columnas"       value=" a.COSGid, 
                                												a.COEGid, 
                                                                                a.COSGObservacion, 
                                                                                a.COSGFecha, 
                                                                                a.COSGUsucodigo, 
                                                                                a.BMUsucodigo,
                                                                                b.COEGid,
                                                                                c.CMPProceso,
                                                                                c.CMPid, 
																				e.Usulogin,
                                                                                #LvarNombre# as nombre,
                                                                                '1' as vieneform, 
                                                                                d.SNnombre"/>
								<cfinvokeargument name="filtro" 		value=" a.COEGid = #rsCMPProceso.COEGid#  
                                												and b.COEGReciboGarantia = #rsCMPProceso.COEGReciboGarantia#"/>
								<cfinvokeargument name="desplegar" 		value="COSGObservacion, COSGFecha, nombre"/>
                                <cfinvokeargument name="etiquetas" 		value="Observaciones, Fecha, Usuario Incluyó"/>
								<cfinvokeargument name="usaAJAX" 		value="no"/>
								<cfinvokeargument name="conexion" 		value="#session.DSN#"/>
								<cfinvokeargument name="formatos" 		value="S,D,S"/>
								<cfinvokeargument name="align" 			value="left,left,center"/>
								<cfinvokeargument name="ajustar" 		value="S"/>
								<cfinvokeargument name="irA" 			value="SeguimientoGarantias-form.cfm"/>
                                <cfinvokeargument name="navegacion"		value="#Navegacion#"/>
								<cfinvokeargument name="debug" 			value="N"/>
								<cfinvokeargument name="Keys" 			value="COSGid"/>
								<cfinvokeargument name="mostrar_filtro" value="False"/>
								<cfinvokeargument name="filtrar_automatico" value="True"/> 
								<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
								<cfinvokeargument name="MaxRows" 		value="0"/>
								<cfinvokeargument name="formName" 		value="formSeguimiento"/>	
                                <cfinvokeargument name="PageIndex" 		value="3"/>	
							</cfinvoke>	
						</td>
					</tr>
				</table>			
         
        <cf_qforms>
            <cf_qformsRequiredField name="COSGObservacion" description="Observaciones">
        </cf_qforms>
        </cfoutput>
    <cf_web_portlet_end>
<cf_templatefooter>

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