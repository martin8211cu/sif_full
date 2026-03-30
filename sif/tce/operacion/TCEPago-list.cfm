<!---==ESTADOS DE CUENTA PENDIENTES PARA PAGO--->
<cfquery name="rsPendientesPago" datasource="#session.dsn#">
select count(1) as Total
	from ECuentaBancaria a
	inner join CuentasBancos c
	on c.CBid = a.CBid
	where c.Ecodigo = #session.Ecodigo#
		and c.CBesTCE = 1
		and a.ECStatus = 1
		and not exists (select 1
                        from CBDPagoTCEdetalle ed
                        where ed.ECid = a.ECid)
</cfquery>
<cfset currentPage = GetFileFromPath(GetTemplatePath())>
<cfset LvarPendientes = "#rsPendientesPago.Total#">
<cfset ver = "10,11">
<cfif isdefined("url.lista") and url.lista eq 12>
	<cfset ver = #url.lista#>
</cfif>
<style type="text/css">
<!--
.Estilo1 {
	color: #CC3300;
	font-weight: bold;
	font-size: 10px;
}
-->
</style>

<cfif isdefined("form.btnEliminar") and isdefined("form.chk") and len(trim(Form.chk))>
	<cftransaction>
    <cfloop index = "item"	list = "#Form.chk#"	delimiters = ",">
      	<cfquery name="TCEDetalleDetele" datasource="#session.DSN#">
            delete from CBDPagoTCEdetalle
            where CBPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
        </cfquery>
        <cfquery name="TCEEncabezadoDetele" datasource="#session.DSN#">
            delete from CBEPagoTCE 
            where CBPTCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#item#">
        </cfquery>
	</cfloop>
    </cftransaction>
    <script language="javascript" type="text/javascript">
	<!--//
    	location.href = location.href;
	//-->
    </script>
</cfif>

<cf_templateheader title="Generar Pago Tarjetas de Cr&eacute;dito">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Generar Pago Tarjetas de Cr&eacute;dito'>
			
			<form style="margin: 0"  name="form2" action="TCEPago.cfm" method="post">
				<table width="100%" align="center" border="0">
					<!---TESORERIA--->
					<tr>
						<td>
							<table cellpadding="0" cellspacing="6" background="0" width="100%" align="center">
								<tr>
									<td class="tituloListas" nowrap align="left">
										&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<strong>Trabajar con Tesorer&iacute;a:</strong>&nbsp;
										<cf_cboTESid onchange="this.form2.submit();" tabindex="1">	
                                     </td>
								</tr>
							</table>						
                         </td>
					</tr>	
                    <tr>
                    	<td>
                            <table cellpadding="0" cellspacing="4" background="0" width="100%" align="center">
                                <td><b>Mostrar los Abonos:</b></td>
                                <td width="85%">					
                                    <select name="lista" tabindex="1" onchange="javascript: location.href= this.options[this.selectedIndex].value;">
                                        <option value="TCEPago-list.cfm?lista=11" <cfif ver neq 12>selected</cfif>>En Proceso</option>
                                        <option value="TCEPago-list.cfm?lista=12" <cfif ver eq 12>selected</cfif>>Emitidos</option>
                                    </select>
                                </td>
                            </table>
                    	</td>        
                    </tr>
					<!---LISTA DE TARJETAS PARA PAGAR--->
					<tr>
						<td>
							<table width="100%" border="0">
								<tr>
									<td>
										<cf_dbfunction name="to_char" returnvariable="ECid" args="a.ECid">
										<cf_dbfunction name="concat" returnvariable="LvarReporte" args="'<img src=''/cfmx/sif/imagenes/iedit.gif'' title=''Editar'' width=''16'' height=''16'' border=''0'' onClick=''javascript: ModificarEstadoCuenta('+#ECid#+');''>'"delimiters="+">
										<cf_dbfunction name="concat" returnvariable="LvarReiniciar" args="'<img src=''/cfmx/sif/imagenes/refresh_o.gif'' title=''Reiniciar Proceso''width=''16'' height=''16'' border=''0'' onClick=''javascript: ReiniciaConciliacion('+#ECid#+');''>'"delimiters="+">
										<cfinvoke 
													 component="sif.Componentes.pListas"
													 method="pLista"
													 returnvariable="pListaRet">
												<cfinvokeargument name="columnas"  				value="	b.Bid,
                                                                                                        pb.CBPTCid
                                                                                                        ,m.Miso4217             
																										,b.Bdescripcion 		
																										,pb.CBPTCdescripcion 	
                                                                                                        ,case pb.CBPTCestatus when 10 then 'En Digitaci&oacute;n' when 11 then 'En Proceso' when 12 then 'Emitido' when 13 then 'Cancelado' end as estatus
																										,pb.CBPTCfecha	
                                                                                                        ,pb.CBPTCestatus
                                                                                                        ,case when pb.CBPTCestatus > 10 then  pb.CBPTCid else 0 end as inactivecol
                                                                                                        ,(select coalesce((select coalesce(sum(CBDPTCmonto),0) from CBDPagoTCEdetalle where CBPTCid = p.CBPTCid) / p.CBPTCtipocambio,0)
                                                                                                        from CBEPagoTCE p 
                                                                                                        where p.CBPTCid = pb.CBPTCid) as Monto"/>
																										
												<cfinvokeargument name="tabla"  				value="CBEPagoTCE pb
                                                														inner join CuentasBancos cb
                                                                                                        on cb.CBid = pb.CBid
																										inner join Bancos b
                                                                                                        on b.Bid = cb.Bid
                                                                                                        inner join Monedas m
                                                                                                        on m.Mcodigo = cb.Mcodigo
                                                                                                        and m.Ecodigo = cb.Ecodigo"/>
												
												<cfinvokeargument name="filtro"   				value="cb.Ecodigo = #Session.Ecodigo#  
                                                														and pb.CBPTCestatus in (#ver#)"/>
												<cfinvokeargument name="inactivecol"            value="inactivecol"/>
												<cfinvokeargument name="desplegar"  			value="Bdescripcion, CBPTCdescripcion, CBPTCfecha, Miso4217, Monto, estatus"/>
												<cfinvokeargument name="etiquetas"  			value="Beneficiario, Descripci&oacute;n, Fecha, Moneda, Monto, Estatus"/>
												<cfinvokeargument name="formatos"   			value="S,S,D,S,M,S"/>
												<cfinvokeargument name="align"      			value="left,left,left,left,left,left"/>
												<cfinvokeargument name="ajustar"    			value="N"/>
												<cfinvokeargument name="irA"        			value="TCEPago.cfm"/>
												<cfinvokeargument name="showLink" 				value="true"/>
												<cfinvokeargument name="checkboxes" 	 	 	value="S"/>
												<cfinvokeargument name="lineaRoja" 				value="CBPTCestatus EQ 11"/>
												<cfif #LvarPendientes# gt 0> 
													<cfinvokeargument name="botones"    		value="Nuevo,Eliminar"/>
                                                <cfelse>
                                                	<cfinvokeargument name="botones"    		value="Eliminar"/>
												</cfif>
												<cfinvokeargument name="showEmptyListMsg" 		value="true"/>
												<cfinvokeargument name="maxrows" 				value="15"/>
												<cfinvokeargument name="keys"             		value="CBPTCid"/>
												<cfinvokeargument name="mostrar_filtro"			value="true"/>
												<cfinvokeargument name="filtrar_automatico" 	value="true"/>
                                                <cfinvokeargument name="formname"				value="form2"/>
												<cfinvokeargument name="incluyeform"			value="false"/>
										</cfinvoke>									
									</td>
								</tr>
							</table>						
						</td>
					</tr>
					<span class="Estilo1">
					<cfif #LvarPendientes# gt 0> 
                    </span>
						<tr>
							<td align="center">
                            	<cfset exis = 'Existe'>
                                <cfset esta = 'estado'>
                            	<cfif #LvarPendientes# gt 1>
                                	<cfset exis = 'Existen'>
                                    <cfset esta = 'estados'>
                                </cfif> 
								<div align="center" class="Estilo1"><cfoutput>#exis# #LvarPendientes# #esta#</cfoutput> de cuenta para incluir en un pago</div>
							</td>
						</tr>
					<cfelse>
						<tr>
							<td align="center">
								<div align="center" class="Estilo1">No existen estados de cuenta para incluir en un pago</div>
							</td>
						</tr>
					</cfif>
				</table>
			</form>
<cf_templatefooter>
<script language="javascript" type="text/javascript">
<!--//
	function algunoMarcado(){
		var aplica = false;
		var form = document.form2;
		if (form.chk) {
			if (form.chk.value) {
				aplica = form.chk.checked;
			} else {
				for (var i=0; i<form.chk.length; i++) {
					if (form.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			return (aplica);
		} else {
			alert('Debe seleccionar al menos un grupo de transacciones antes de realizar esta acción!');
			return false;
		}
	}
	<cfoutput>
	function funcEliminar(){
		if (algunoMarcado() && confirm("Est\u00e1 seguro de que desea eliminar los grupos de transacciones seleccionados?"))
			document.form2.action = "#CurrentPage#";
		else
			return false;
	}
	</cfoutput>
//-->
</script>
<cfif isdefined("url.OPnum")>
	<script language="javascript">
		alert('Se gener\u00f3 la Orden de Pago Num.<cfoutput>#url.OPnum#</cfoutput>');
	</script>
</cfif>