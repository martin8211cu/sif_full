<!--- Proveduria Corporativa --->
<cfparam name="form.EcodigoE" default="#session.Ecodigo#">
<cfset lvarProvCorp = false>
<cfset lvarFiltroEcodigo = #session.Ecodigo#>
<cfquery name="rsProvCorp" datasource="#session.DSN#">
	select Pvalor 
	from Parametros 
	where Ecodigo=#session.Ecodigo#
	and Pcodigo=5100
</cfquery>
<cfif rsProvCorp.recordcount gt 0 and rsProvCorp.Pvalor eq 'S'>
	<cfset lvarProvCorp = true>
	<cfquery name="rsEProvCorp" datasource="#session.DSN#">
		select EPCid
		from EProveduriaCorporativa
		where Ecodigo = #session.Ecodigo#
		 and EPCempresaAdmin = #session.Ecodigo#
	</cfquery>
	<cfif rsEProvCorp.recordcount gte 1>
		<cfquery name="rsDProvCorp" datasource="#session.DSN#">
			select DPCecodigo as Ecodigo, Edescripcion
			from DProveduriaCorporativa dpc
				inner join Empresas e
					on e.Ecodigo = dpc.DPCecodigo
			where dpc.Ecodigo = #session.Ecodigo#
			 and dpc.EPCid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsEProvCorp.EPCid)#" list="yes">)
			union
			select e.Ecodigo, e.Edescripcion
			from Empresas e
			where e.Ecodigo = #session.Ecodigo#
			order by 2
		</cfquery>
        <cfloop from="1" to="#rsDProvCorp.recordcount#" index="i">
            <cfset Ecodigos = ValueList(rsDProvCorp.Ecodigo)>
        </cfloop>
	</cfif>    
	<cfif not isdefined('Session.Compras.ProcesoCompra.Ecodigo')>
		<cfset Session.Compras.ProcesoCompra.Ecodigo = session.Ecodigo>
	</cfif>
</cfif>

<cf_templateheader title="Compras - Consecutivo de &Oacute;rdenes de Compra">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Rango de &Oacute;rdenes de Compra y Fechas'>
        
		<form name="form1" method="post" action="ListadoConsecutivoOrdenes-form.cfm">
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
				<tr><td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td width="50%" valign="top">
						<table width="100%">
							<tr>
								<td> 
									<cf_web_portlet_start border="true" titulo="Consecutivos de &Oacute;rdenes de Compra" skin="info1">
										<div align="justify">
											<p>Muestra un consecutivo de &oacute;rdenes de compra de acuerdo al tipo de &oacute;rden seleccionado, que puede ser una &oacute;rden de compra al exterior o local, adem&aacute;s se escoge un rango de &oacute;rdenes de compra y de fechas.</p>
										</div>
									<cf_web_portlet_end> 
								</td>
							</tr>
						</table>
					</td>
					
					<td width="50%" valign="top">
						<table width="100%" cellpadding="0" cellspacing="0" align="center">
                        
                        	<cfif rsEProvCorp.recordcount gte 1>    
                                <tr>
                                    <td nowrap align="right"><strong>Empresa:&nbsp;</strong></td>
                                    <td colspan="2">
                                        <select name="EcodigoE" onchange="cargarPagina();">
                                            <option value="<cfoutput>#Ecodigos#</cfoutput>">--Todas--</option>
                                            <cfloop query="rsDProvCorp">
                                                <option value="<cfoutput>#rsDProvCorp.Ecodigo#</cfoutput>" <cfif (isdefined('form.EcodigoE') and form.EcodigoE eq rsDProvCorp.Ecodigo)> selected</cfif>><cfoutput>#rsDProvCorp.Edescripcion#</cfoutput></option>		
                                            </cfloop>	
                                        </select>  
                                    </td>
                                </tr>
                             <cfelse>
                                <input type="hidden" name="EcodigoE" value="-2"/>
                            </cfif>
                            <tr><td>&nbsp;</td></tr> 
                            <tr>
                            	<td nowrap align="right"><strong>Tipo de &oacute;rden:&nbsp;</strong></td>
                            	<td>
                                    <select name="TipoOrden" >
                                        <option value="T">---Todas---</option>
                                        <option value="L">Local</option>
                                        <option value="I">Exterior</option>
                                    </select>
                                </td>
                            </tr>  
                            <tr><td>&nbsp;</td></tr>                      
							<tr>
								<td align="right" nowrap><strong>&Oacute;rden de Compra Inical:</strong>&nbsp;</td>
								<td nowrap colspan="3">
									<input type="text" name="NumeroOC1" maxlength="10" value="" size="10" onBlur="javascript:existeOrden(1,this.value);" >									
                                    <input type="text" name="ObservacionOC1" id="ObservacionOC1" tabindex="1" readonly value="" size="40" maxlength="80">
									<input type="hidden" name="IDOC1" value="" >
								</td>
							</tr>
						
							<tr>
								<td align="right" nowrap><strong>&Oacute;rden de Compra Final:</strong>&nbsp;</td>
								<td nowrap colspan="3">
									<input type="text" name="NumeroOC2" maxlength="10" value="" size="10" onBlur="javascript:existeOrden(2,this.value);" >									
                                    <input type="text" name="ObservacionOC2" id="ObservacionOC2" tabindex="1" readonly value="" size="40" maxlength="80">
									<input type="hidden" name="IDOC2" value="" >
								</td>
							</tr>
                            <tr><td>&nbsp;</td></tr>
                                <tr align="left">
                                <td width="50%" nowrap align="right"><strong>De la Fecha:</strong></div></td>
                                <td width="50%" nowrap><cf_sifcalendario name="FechaInicial" value="" tabindex="1"></td>
                                <td width="1%">&nbsp;</td>
						    </tr>
                            <tr align="left">
								<td width="50%" nowrap align="right"><strong>Hasta:</strong></div></td>
								<td width="50%" nowrap><cf_sifcalendario name="FechaFinal" value="" tabindex="1"></td>
								<td width="1%">&nbsp;</td>
						    </tr>
                            <tr><td>&nbsp;</td></tr>
                            <tr>
                            	<td align="right"><strong>Exportar a Excel:&nbsp;</strong>
								</td>
                                <td><input type="checkbox" name="toExcel" /></td>
                            </tr>
                            <tr><td>&nbsp;</td></tr>
                            <tr>
								<td align="center" colspan="4">
									<input type="submit" name="Consultar" value="Consultar">
                                    <input type="reset"  name="Limpiar" value="Limpiar">
								</td>
							</tr>
						</table>
					</td>
				</tr>
			</table>
		</form>
		<iframe name="frComprador" id="frComprador" width="0" height="0" style="visibility:"></iframe>
		
    <cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript" type="text/javascript">
	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin2', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function existeOrden(opcion, value){
		
		var _form = document.form1;
		var empresa = _form.EcodigoE.value;		
		
		if (!/^([0-9])*$/.test(value)){
			alert("El valor insertado " + value + " no es un número")
		}
		else{
			if ( value !='' ){
				document.getElementById("frComprador").src = "OrdenesConsulta.cfm?NumeroOC=" + value + "&opcion=" + opcion + "&Empresas=" + empresa;
			}
		}
	}
	
	function cargarPagina(){
		document.form1.action = "";
		document.form1.submit();
	}
	
</script>


