<!--- 
	Modificado por: Ana Villavicencio
	Fecha: 07 de octubre de l2005
	Motivo:  modificar el diseño de la forma, se cambio el estilo de los radio para q fuera del color del fondo

<cfdump var="#form#"> --->

<cf_templateheader title="Estados de Cuenta en Proceso">
		<cfquery name="rsEstadosCuenta" datasource="#Session.DSN#">
			select a.ECid, a.Bid, b.Bdescripcion, a.ECfecha, c.CBdescripcion, a.ECdescripcion, b.Bdescripcion, a.EChasta,
			 case  when a.ECaplicado = 'S' then 'LISTO' else 'EN PROCESO' end as Estado,
			 '<img src=''/cfmx/sif/imagenes/Documentos2.gif'' width=''16'' height=''16'' border=''0'' onClick=''javascript: ModificarEstadoCuenta();''>' as reporte
			from ECuentaBancaria a, Bancos b, CuentasBancos c
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			  and a.Bid = b.Bid 
              and c.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">
			  and a.CBid = c.CBid 
			  and a.EChistorico = 'N'
			  <cfif isdefined('form.filtro_Bdescripcion') and LEN(TRIM(form.filtro_Bdescripcion))>
			  and Upper(b.Bdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#Ucase(Trim(Form.filtro_Bdescripcion))#%">
			  </cfif>
		</cfquery>
		
		<cfinclude template="frame-config.cfm">
		
		<style type="text/css">
			input {background-color: #FAFAFA; font-family: Tahoma, sans-serif; font-size: 8pt; border:1px solid gray}
		</style>
		<form name="frmGO" action="" method="post" style="margin: 0; ">
			<input type="hidden" name="ECid" value="<cfif isdefined("Form.ECid")><cfoutput>#Form.ECid#</cfoutput></cfif>">
			<input type="hidden" name="InicioCons" value="1">
		</form>
		<script language="javaScript" type="text/javascript">
			function ModificarEstadoCuenta() {
				document.frmGO.action='EstadosCuenta.cfm';
				if (document.form1.opt && document.form1.opt.value) {
					document.frmGO.ECid.value = document.form1.opt.value;
				} else if (document.form1.opt) {
					for (var i=0; i<document.form1.opt.length; i++) {
						if (document.form1.opt[i].checked) {
							document.frmGO.ECid.value = document.form1.opt[i].value;
							break;
						}
					}
				}
				document.frmGO.submit();
			}
			
			function funcSiguiente() {
				if (document.form1.opt && document.form1.opt.value) {
					document.frmGO.ECid.value = document.form1.opt.value;
				} else if (document.form1.opt) {
					for (var i=0; i<document.form1.opt.length; i++) {
						if (document.form1.opt[i].checked) {
							document.frmGO.ECid.value = document.form1.opt[i].value;
							break;
						}
					}
				}
				
				if (document.frmGO.ECid.value != '') {
					document.frmGO.action='ConciliacionAutomatica.cfm';
					document.frmGO.submit();
				} else {
					alert('No hay ningún Estado de Cuenta Seleccionado');
				}
			}
		</script>
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="85%" valign="top">
					<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Lista de Estados de Cuenta en Proceso'>
					<cfinclude template="../../portlets/pNavegacion.cfm">
					<form name="form1" action="listaEstadosCuentaEnProceso.cfm" method="post">
					  <input type="hidden" name="ECid" value="<cfif isdefined("Form.ECid")><cfoutput>#Form.ECid#</cfoutput></cfif>">
					  <input type="hidden" name="paso1" value="1">
					  <cfset navegacion = "" >
						<cfinvoke 
							 component="sif.Componentes.pListas"
							 method="pListaQuery"
							 returnvariable="pListaRet">
						  <cfinvokeargument name="query"  				value="#rsEstadosCuenta#"/>
						  <cfinvokeargument name="desplegar"  			value="Bdescripcion, CBdescripcion, ECfecha, Estado, reporte"/>
						  <cfinvokeargument name="etiquetas"  			value="Banco, Cuenta Bancaria, Fecha, Estado, "/>
						  <cfinvokeargument name="formatos"   			value="S,S,D,S,S"/>
						  <cfinvokeargument name="align"      			value="left,left,left,left,left"/>
						  <cfinvokeargument name="ajustar"    			value="N"/>
						  <cfinvokeargument name="irA"        			value=""/>
						  <cfinvokeargument name="radios" 	 	 	    value="S"/>
						  <cfinvokeargument name="botones"    			value="Siguiente"/>
						  <cfinvokeargument name="navegacion" 			value="#navegacion#"/>
						  <cfinvokeargument name="showEmptyListMsg" 	value="true"/>
						  <cfinvokeargument name="maxrows" 				value="15"/>
						  <cfinvokeargument name="keys"             	value="ECid, Bid"/>
						  <cfinvokeargument name="mostrar_filtro"		value="false"/>
						  <cfinvokeargument name="formname"				value="form1"/>
						  <cfinvokeargument name="incluyeform"			value="false"/>
						</cfinvoke>
					 <!---  <table width="98%" border="0" cellspacing="0" cellpadding="2" align="center">
						<tr>
						  <td colspan="6">&nbsp;</td>
					    </tr>
						<tr> 
						  <td width="1%" nowrap bgcolor="#E2E2E2">&nbsp;</td>
						  <td width="22%" nowrap bgcolor="#E2E2E2"><strong>Banco</strong></td>
						  <td width="32%" nowrap bgcolor="#E2E2E2"><strong>Cuenta</strong></td>
						  <td width="19%" align="center" nowrap bgcolor="#E2E2E2"><strong>Fecha</strong></td>
						  <td width="25%" align="center" nowrap bgcolor="#E2E2E2"><strong>Estado</strong></td>
						  <td width="25%" align="center" nowrap bgcolor="#E2E2E2">&nbsp;</td>
					    </tr>
						<cfoutput query="rsEstadosCuenta"> 
						  <tr <cfif rsEstadosCuenta.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>> 
							<td nowrap>
								<input name="opt" type="radio" value="#rsEstadosCuenta.ECid#" id="opt"
								align="absmiddle"
								<cfif isdefined("Form.ECid") and Form.ECid EQ rsEstadosCuenta.ECid> 
								checked<cfelseif currentRow EQ 1> checked</cfif> 
								style=" border:0; background:background-color">
							</td>
							<td nowrap >#rsEstadosCuenta.Bdescripcion#</td>
							<td nowrap>#rsEstadosCuenta.CBdescripcion#</td>
							<td align="center" nowrap>#LSDateFormat(rsEstadosCuenta.EChasta,'DD/MM/YYYY')#</td>
							<td align="center" nowrap><cfif rsEstadosCuenta.ECaplicado EQ "S">
								LISTO
								<cfelse>
								<font color="##0000FF">EN 
								PROCESO</font>  
						    </cfif></td>
						    <td align="center" nowrap>
								<a href="javascript: ModificarEstadoCuenta();" title="Modificar Estado de Cuenta">
									<img src="/cfmx/sif/imagenes/Documentos2.gif" width="16" height="16" border="0">
								</a>
							</td>
					      </tr>
						</cfoutput> 
						<tr> 
						  <td colspan="6">&nbsp;</td>
					    </tr>
						<tr> 
						  <td align="center" colspan="6">
							  <input type="button" name="Siguiente" value="Siguiente >>" onClick="javascript: funcSiguiente();" onmouseover="javascript: this.className='botonDown2';" onmouseout="javascript: this.className='botonUp2';">
						  </td>
						</tr>
						<tr>
						  <td align="center" colspan="6">&nbsp;</td>
					    </tr>
					  </table> --->
					</form>
					<cf_web_portlet_end>
				</td>
			    <td width="15%" valign="top">
					<cfinclude template="frame-Progreso.cfm">
					<br>
					<div class="textoAyuda">
						<strong>Indicaciones:</strong><br><br>
						Seleccione el Estado de Cuenta que desea conciliar y presione el bot&oacute;n de 
						<font color="#003399"><strong>Siguiente >></strong></font>.<br><br>
						Si desea modificar los documentos
						del Estado de Cuenta haga click en el icono <img src="/cfmx/sif/imagenes/Documentos2.gif" width="16" height="16" border="0"><br><br>
						Tambi&eacute;n puede utilizar el cuadro de <font color="#003399"><strong>Pasos</strong></font> para saltar a las dem&aacute;s opciones<br><br>
					</div>
				</td>
			</tr>
		</table>	
	<cf_templatefooter>
