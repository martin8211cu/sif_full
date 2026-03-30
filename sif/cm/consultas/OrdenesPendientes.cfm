<cf_templateheader title="Compras - Órdenes de Compra Pendientes por Comprador">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Rango de Compradores'>

		<!--- Proveduria Corporativa --->
		<cfset lvarProvCorp = false>
        <cfset lvarFiltroEcodigo = Session.Ecodigo>
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
            <cfif isdefined("Form.Ecodigo_f") and Form.Ecodigo_f neq Session.Compras.ProcesoCompra.Ecodigo>
                <cfset Session.Compras.ProcesoCompra.Ecodigo = Form.Ecodigo_f>
                <cfset Session.Compras.ProcesoCompra.DSlinea = "">
            </cfif>
            <cfif isdefined('Session.Compras.ProcesoCompra.Ecodigo')>
                <cfset lvarFiltroEcodigo = Session.Compras.ProcesoCompra.Ecodigo>
            </cfif>
        </cfif>
		<form name="form1" method="post" action="OrdenesPendientesDatos.cfm">
			<table width="100%" align="center" border="0" cellspacing="0" cellpadding="2">
				<tr><td colspan="2"><cfinclude template="/sif/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td width="40%" valign="top">
						<table width="100%">
							<tr>
								<td> 
									<cf_web_portlet_start border="true" titulo="Consulta de órdenes de Compra Pendientes por Comprador" skin="info1">
										<div align="justify">
											<p> 
											&Eacute;ste reporte muestra las Ordenes de Compra por comprador, según los estados de la Orden de Compra. 
                                            </p>
										</div>
									<cf_web_portlet_end> 
								</td>
							</tr>
						</table>
					</td>
					<!--- Filtro Comprador --->
					<td width="50%" valign="top">
						<table width="100%" cellpadding="0" cellspacing="0" align="center" border="0">
							<!----Solicitante--->
							<tr>
								<td align="right" nowrap><strong>Solicitante:</strong>&nbsp;</td>
								<td nowrap colspan="3">
									<input type="text" name="CMScodigo" maxlength="10" value="" size="10" onBlur="javascript:solicitante(1,this.value);" >
									<input type="text" name="CMSnombre" id="CMSnombre" tabindex="1" readonly value="" size="40" maxlength="80">
									<a href="" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Solicitantes" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisSolicitantes();'></a>
									<input type="hidden" name="CMSid" value="" >
								</td>
							</tr>
							<tr>
								<td width="27%" align="right" nowrap><strong>Del Comprador:</strong>&nbsp;</td>
								<td nowrap colspan="3">
									<input type="text" name="CMCcodigo1" maxlength="10" value="" size="10" onBlur="javascript:comprador(1,this.value);" >
									<input type="text" name="CMCnombre1" id="CMCnombre1" tabindex="1" readonly value="" size="40" maxlength="80">
									<a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores1();'></a>
									<input type="hidden" name="CMCid1" value="" >
								</td>
							</tr>
						
							<tr>
								<td align="right" nowrap><strong>Hasta:</strong>&nbsp;</td>
								<td nowrap colspan="3">
									<input type="text" name="CMCcodigo2" maxlength="10" value="" size="10" onBlur="javascript:comprador(2,this.value);" >
									<input type="text" name="CMCnombre2" id="CMCnombre2" tabindex="1" readonly value="" size="40" maxlength="80">
									<a href="#" tabindex="-1"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Compradores" name="imagen2" width="18" height="14" border="0" align="absmiddle" onClick='javascript: doConlisCompradores2();'></a>
									<input type="hidden" name="CMCid2" value="" >
								</td>
							</tr>
							<!--- Centro Funcional --->
							<tr>
                            	<td nowrap align="right"><strong>Centro Funcional:&nbsp;</strong></td>
                            	<td colspan="2">
									<cf_rhcfuncionalCxP form="form1" size="23" id="CFid" name="CFcodigo" desc="CFdescripcion" tabindex="1">
                                </td>
							</tr>
                            <cfif rsEProvCorp.recordcount gte 1>
                                <tr>
                                    <td nowrap align="right"><strong>Empresa:&nbsp;</strong></td>
                                    <td colspan="2">
                                        <select name="EcodigoE">
                                            <option value="<cfoutput>#Ecodigos#</cfoutput>">--Todas--</option>
                                            <cfloop query="rsDProvCorp">
                                                <option value="<cfoutput>#rsDProvCorp.Ecodigo#</cfoutput>" <cfif (isdefined('form.Ecodigo_f') and form.Ecodigo_f eq rsDProvCorp.Ecodigo) or (not isdefined('form.Ecodigo_f') and rsDProvCorp.Ecodigo EQ lvarFiltroEcodigo)> selected</cfif>><cfoutput>#rsDProvCorp.Edescripcion#</cfoutput></option>		
                                            </cfloop>	
                                        </select>  
                                    </td>
                                </tr>
                             <cfelse>
                             	<input type="hidden" name="EcodigoE" value="-2"/>
                            </cfif>
                            <tr>
                                <td align="right"><strong>Fecha Desde:&nbsp;</strong></td>
                                <td width="60%">
                                    <cf_sifcalendario name="fechaDes">
                                </td>
                               <td width="9%"  align="left" ><strong>&nbsp;&nbsp;Fecha Hasta:&nbsp;</strong></td>
                                <td width="4%" align="left">
                                    <cf_sifcalendario name="fechaHas">
                                </td>
							</tr>
                            
                            <!--- Estado de la Solicitud --->
                            <tr>
                            	<td nowrap align="right" valign="top"><strong>Estado de la Orden:&nbsp;</strong></td>
                                <td colspan="4">
                                    <fieldset>
                                        <legend>Seleccione los Estados:</legend>
                                        <input type="checkbox" name="EOestados" id="EOestados" value="99"/>Procesos de compra pendientes<br />
                                        <input type="checkbox" name="EOestados" id="EOestados" value="10" />Aplicada, surtida Totalmente<br />
										<input type="checkbox" name="EOestados" id="EOestados" value="11" />Aplicada, surtida Parcialmente<br />
                                        <input type="checkbox" name="EOestados" id="EOestados" value="-10" />Pendiente de Aprobación Presupuestaria<br />
                                        <input type="checkbox" name="EOestados" id="EOestados" value="-8" />Orden Rechazada<br />
                                        <input type="checkbox" name="EOestados" id="EOestados" value="-7" />En Proceso de Aprobación<br />
                                        <input type="checkbox" name="EOestados" id="EOestados" value="0" />Pendiente<br />
                                        <input type="checkbox" name="EOestados" id="EOestados" value="5" />Pendiente Vía Proceso<br />
                                        <input type="checkbox" name="EOestados" id="EOestados" value="8" />Pendiente Vía Contrato<br />
                                        <input type="checkbox" name="EOestados" id="EOestados" value="7" />Pendiente OC Directa<br />
                                        <input type="checkbox" name="EOestados" id="EOestados" value="9" />Autorizada por jefe Compras<br />
                                        <input type="checkbox" name="EOestados" id="EOestados" value="70" />Ordenes Anuladas<br />
                                        <input type="checkbox" name="EOestados" id="EOestados" value="55" />Ordenes Canceladas Parcialmente Surtida<br />
                                        <input type="checkbox" name="EOestados" id="EOestados" value="60" />Ordenes Canceladas<br />
                                    </fieldset>
                                </td>
                            </tr>
                            <!--- Mostrar Cantidades --->
                            <tr>
                                <td align="right" valign="baseline"><strong>Mostrar Cantidades:&nbsp;</strong></td>
                                <td align="left">
                                	<input type="checkbox" name="verCantidades" />
                                </td>    
                            </tr>
                            <tr><td>&nbsp;</td></tr>
                            <tr>
								<td align="center" colspan="4">
									<input type="button" name="Consultar" value="Consultar" onclick="javascript:validaEstados();">
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
			
			//Funcion del conlis para los solicitantes
			function doConlisSolicitantes() {
				var params = "";
					params = "?formulario=form1&CMSid=CMSid&CMScodigo=CMScodigo&desc=CMSnombre";
				popUpWindow("/cfmx/sif/cm/consultas/ConlisSolicitantesConsulta.cfm"+params,250,200,650,400);
			}
			//Funcion para obtener el solicitante con su codigo
			function solicitante(opcion, value){
				if ( value !='' ){
					document.getElementById("frComprador").src = "SolicitantesConsulta.cfm?CMScodigo="+value+"&opcion="+opcion;
				}
			}
			
			function doConlisCompradores1() {
				var params = "";
				params = "?formulario=form1&CMCid=CMCid1&CMCcodigo=CMCcodigo1&desc=CMCnombre1&Ecodigo=-1";
				popUpWindow("/cfmx/sif/cm/consultas/ConlisCompradoresConsulta.cfm"+params,250,200,650,400);
			}
			
			function doConlisCompradores2() {
				var params = "";
					params = "?formulario=form1&CMCid=CMCid2&CMCcodigo=CMCcodigo2&desc=CMCnombre2&Ecodigo=-1";
				popUpWindow("/cfmx/sif/cm/consultas/ConlisCompradoresConsulta.cfm"+params,250,200,650,400);
			}
			
			function comprador(opcion, value){
				if ( value !='' )
				return	document.getElementById("frComprador").src = "CompradoresConsulta.cfm?CMCcodigo="+value+"&opcion="+opcion+"&Ecodigo=-1";
			}
			
			//funcion para validar que se seleccione almenos un estado para realizar la consulta
			function validaEstados(){
				var checkboxs = document.getElementsByName("EOestados");
				var cont = 0;
				for (var i=0; i < checkboxs.length; i++) {
					if (checkboxs[i].checked) {
						cont = cont + 1;
					}
				}	
				if (cont > 0)
					return document.form1.submit();
				alert("Debe seleccionar almenos un Estado para realizar la consulta!");
			}
		</script>
        