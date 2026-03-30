
	<cf_templateheader title="Contabilidad General - Consolidado de Empresas">
		<cfinclude template="../../../sif/cg/consultas/Funciones.cfm">
		<cfset periodo_actual=get_val(30).Pvalor>
		<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
			select a.Mcodigo, b.Mnombre, b.Msimbolo, b.Miso4217
			from Empresas a, Monedas b 
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a.Mcodigo = b.Mcodigo
		</cfquery>

		<cfquery name="rsParam" datasource="#Session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Pcodigo = 660
		</cfquery>
		<cfif rsParam.recordCount> 
			<cfquery name="rsMonedaConvertida" datasource="#Session.DSN#">
				select Mcodigo, Mnombre
				from Monedas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParam.Pvalor#">
			</cfquery>
		</cfif>
        
        <!--- cambio para informe --------------->
        <cfquery name="rsParam" datasource="#Session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and Pcodigo = 3900
		</cfquery>
		<cfif rsParam.recordCount> 
			<cfquery name="rsMonedaInforme" datasource="#Session.DSN#">
				select Mcodigo, Mnombre
				from Monedas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsParam.Pvalor#">
			</cfquery>
		</cfif>
		<!--- --->

		<script language="JavaScript1.2" type="text/javascript" src="../../../../sif/js/sinbotones.js"></script>
		<cfoutput>
        <form name="form1" method="post" action="consolidado-cuentasPMI.cfm" style="margin:0;" onSubmit="return sinbotones(); validar(this); ">        
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" tituloalign="center" titulo="Consolidado de Empresas">
			<cfinclude template="../../../sif/portlets/pNavegacion.cfm">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
				<tr>
					<td width="52%" valign="top">
						<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
						  	<tr>
								<td>&nbsp;</td>
						  	</tr>
						  	<tr>
								<td>                               
                                   <cf_web_portlet_start border="true" titulo="Consolidado de Empresas" skin="info1">
                                   <table width="95%" border="0" cellpadding="2" cellspacing="0" align="center">
                                        <tr>
                                            <td>
                                                <div align="justify" style="font-size:12px;">
                                                    En &eacute;ste reporte se muestra un consolidado de Empresas.
                                                    Seleccione los par&aacute;metros necesarios para aumentar así 
                                                    su utilidad y eficiencia en el traslado de datos.
                                                    <br />
                                                    <br />
                                                </div>
                                            </td>
                                        </tr>
                                    </table>
                                	<cf_web_portlet_end>
								</td>
						  	</tr>
                            <tr>
                            	<td>
									<table>
                                    	<td width="100"><div align="right">Moneda:</div></td>
                                        <td width="350" rowspan="2" valign="top">
                                       		<table border="0" cellspacing="0" cellpadding="2">
                                                <tr>
                                                    <td width="30" nowrap><input name="mcodigoopt" type="radio" value="-2" checked tabindex="1">
                                                    </td>
                                                    <td width="70" nowrap> Local:</td>
                                                    <td width="254"><cfoutput><strong>#rsMonedaLocal.Mnombre#</strong></cfoutput></td>
                                                </tr>
                                                <cfif isdefined("rsMonedaConvertida")>
                                                    <tr>
                                                        <td nowrap><input name="mcodigoopt" type="radio" value="-3" tabindex="6"></td>
                                                        <td nowrap>Convertida:</td>
                                                        <td><cfoutput><strong>#rsMonedaConvertida.Mnombre#</strong></cfoutput></td>
                                                    </tr>
                                                </cfif>
                                                
                                                <!--- Aqui ira la Moneda de Informe B15  --->
                                                <cfif isdefined("rsMonedaInforme")>
                                                    <tr>
                                                        <td nowrap><input name="mcodigoopt" type="radio" value="-4" tabindex="7"></td>
                                                        <td nowrap>Informe:</td>
                                                        <td><cfoutput><strong>#rsMonedaInforme.Mnombre#</strong></cfoutput></td>
                                                    </tr>
                                                </cfif> 
                                                <!---          --->                                               
                                                                                                
                                        	</table>  
                                        </td> 
                           			</table>
                            	</td> 
							</tr>
						</table>
                    </td>
                    
					<td width="48%" valign="top">                        
						<table border="0" align="center" cellpadding="3" cellspacing="0">
							<tr><td colspan="2" nowrap="nowrap"><strong>Grupo de Empresas</strong></td>
							</tr>
							<tr><td colspan="2">
								<cfquery name="anexos" datasource="#session.DSN#">
									select GEid, GEcodigo, GEnombre 
									from AnexoGEmpresa
									where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
									order by GEcodigo
								</cfquery>
								<select name="GEid">
									<!--- <option value="">-seleccionar-</option> --->
									<cfloop query="anexos">
										<option value="#anexos.GEid#">#trim(anexos.GEnombre)# - #anexos.GEnombre#</option>
									</cfloop>
								</select>
							</td>
							</tr>
							<tr>
                            	<td nowrap="nowrap"><strong>Per&iacute;odo</strong></td>
							  	<td nowrap="nowrap"><strong>Mes</strong></td>
							</tr>
							<tr><td>
								<select name="periodo">
									<option value="#periodo_actual#">#periodo_actual#</option>
									<cfloop step="-1" from="#periodo_actual-1#" to="#periodo_actual-3#" index="i"  >
										<option value="#i#" >#i#</option>
									</cfloop>
								</select>
							</td>
							  <td><select name="mes">
								 <!---  <option value="">-seleccionar-</option> --->
								  <option value="1" >Enero</option>
								  <option value="2" >Febrero</option>
								  <option value="3" >Marzo</option>
								  <option value="4" >Abril</option>
								  <option value="5" >Mayo</option>
								  <option value="6" >Junio</option>
								  <option value="7" >Julio</option>
								  <option value="8" >Agosto</option>
								  <option value="9" >Setiembre</option>
								  <option value="10" >Octubre</option>
								  <option value="11" >Noviembre</option>
								  <option value="12" >Diciembre</option>
								</select></td>
							</tr>
							<tr><td nowrap="nowrap"><strong>Tipo</strong></td>
							  <td nowrap="nowrap"><strong>Nivel</strong></td>
							</tr>
							<tr>
								<td>
									<select name="tipo">
										<option value="1">Balance General</option>
										<option value="2">Estado de Resultados</option>
									</select>									
								</td>
								<td><select name="nivel">
									<option value="1">1</option>
									<option value="2">2</option>
									<option value="3">3</option>
									<option value="4">4</option>
									<option value="5">5</option>
									<option value="6">6</option>
									<option value="7">7</option>
									<option value="8">8</option>
									<option value="9">9</option>
								  </select>                                    
								</td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
							<tr><td colspan="2" align="center"><input type="submit" value="Consultar" name="Consultar"></td>
							</tr>
							<tr>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							</tr>
						</table> 
					</td>
				</tr>
			</table>
		<cf_web_portlet_end>
        </form>
        </cfoutput>
            

		<script language="javascript1.2" type="text/javascript">
			function validar(f){
				var mensaje = '';
				if ( document.form1.GEid.value == '' ){
					mensaje += ' - El campo Grupo de Empresas es requerido.\n';
				}
				if ( document.form1.mes.value == '' ){
					mensaje += ' - El campo Mes es requerido.\n';
				}

				if ( mensaje != '' ){
					alert('Se presentaron los siguientes errores:\n' + mensaje)
					return false;
				}
				return true;
			}
		</script>


	<cf_templatefooter>
