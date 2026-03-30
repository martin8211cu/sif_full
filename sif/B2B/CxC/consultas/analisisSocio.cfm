<cfset javaRT = createobject("java","java.lang.Runtime").getRuntime()>
<cfset javaRT.gc()>

<cfquery name="rsOficinas" datasource="#session.DSN#">
	Select Ocodigo, Oficodigo, Odescripcion
	from Oficinas
	where Ecodigo = #Session.Ecodigo#
	order by Odescripcion
</cfquery>
<cfset navegacion = "">

<cfif isdefined('url.CatSoc') and not isdefined('form.CatSoc')>
	<cfset form.CatSoc = url.CatSoc>
</cfif>
<cfif isdefined("session.SocioCxC") and len(trim(session.SocioCxC))>
	<cfset form.SNcodigo = session.SocioCxC>
</cfif>
<cfif isDefined("session.B2B.SNcodigo") and not isDefined("form.SNcodigo")>
	<cfset form.SNcodigo = session.B2B.SNcodigo>
</cfif>
<cfif isDefined("Url.SNnumero") and not isDefined("form.SNnumero")>
	<cfset form.SNnumero = Url.SNnumero>
</cfif>
<cfif isDefined("Url.Ocodigo_F") and not isDefined("form.Ocodigo_F")>
	<cfset form.Ocodigo_F = Url.Ocodigo_F>
</cfif>
<cfif isDefined("Url.id_direccion") and not isDefined("form.id_direccion")>
	<cfset form.id_direccion = Url.id_direccion>
</cfif>

<cfif isdefined("session.B2B.SNcodigo") and len(trim(session.B2B.SNcodigo))>
	<cfquery name="rsSNid" datasource="#session.DSN#">
		select SNid
		from SNegocios
		where Ecodigo = #session.Ecodigo#
		  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.B2B.SNcodigo#">
	</cfquery>
	<cfoutput>
		<script language="javascript1.1" type="text/javascript">
			function funcAgregar(){
				var PARAM  = "/cfmx/sif/B2B/CxC/catalogos/Contacto.cfm?SNcodigo=#session.B2B.SNcodigo#&Nuevo=1";
				open(PARAM,'V1','left=100,top=150,scrollbars=yes,resizable=no,width=1000,height=350')
			}
		</script>
	</cfoutput>
	<cf_dbfunction name="to_char" args="ds.SNDcodigo" returnvariable="LvarSNDcodigo">
	<cf_dbfunction name="concat" args="dp.Pnombre, ' ',dp.Papellido1,' ',dp.Papellido2" returnvariable="Lvarnombre">
	<cfquery name="rsContactoSocio" datasource="#session.DSN#">
		select 
			cs.CSEid, 
			hd.CCTcodigo,
			hd.Ddocumento,
			cs.HDid, 
			us.Usulogin, 
			cs.CSEFecha, 
			cs.TCid, 
			cs.CSEnombreContacto,
			#PreserveSingleQuotes(Lvarnombre)# as Responsable
		from ContactoSocioE cs
			left outer join HDocumentos hd
				on hd.HDid = cs.HDid

			inner join Usuario us
				inner join DatosPersonales dp
					on dp.datos_personales = us.datos_personales
				on us.Usucodigo = cs.Usucodigo

			left outer join SNDirecciones ds
				on ds.SNid = cs.SNid
				and ds.id_direccion = cs.id_direccion
		where cs.SNid = #rsSNid.SNid# 
		  and cs.CSEEstatus = 1
		  <cfif isdefined("form.id_direccion")>
			  	and cs.id_direccion = #form.id_direccion#
		  </cfif>
	</cfquery>
</cfif>
<cf_templateheader title="SIF - Cuentas por Cobrar">
           <cf_web_portlet_start titulo='An&aacute;lisis del Saldo Actual de Socio'>
		  	<cfinclude template="../../../portlets/pNavegacion.cfm">
	<cfflush interval="64">
			
			<script language="javascript" type="text/javascript">
				function funcDatos(){
					if (document.form2.SNcodigo.value != '') {
						document.form2.action = "../../ad/catalogos/DatosGSocio.cfm";
						document.form2.submit();}
					else {
							alert('Debe digitar el Socio de Negocios');
							return false;
						}
				}
				
				function funcImprimir(){
					if (document.form2.SNcodigo.value != '') {
						document.form2.action = "ImpresionSaldoCliente.cfm";
						document.form2.method = "get";
						document.form2.submit();}
					else {
							alert('Debe digitar el Socio de Negocios');
							return false;
						}
				}
				
			</script>
			
			<form name="form1" method="post" action="" style="margin:0;">
				<cfif isdefined('form.CatSoc') and form.CatSoc EQ 1>
					<input name="CatSoc"  type="hidden" value="<cfoutput>#form.CatSoc#</cfoutput>">
				</cfif>
				<table align="center" width="100%" border="0" cellspacing="0" cellpadding="3" class="AreaFiltro">
				<cfif not (isdefined("session.SocioCxC") and len(trim(session.SocioCxC)))>
				  <tr nowrap>
					<td>&nbsp;</td>
					<td align="right" nowrap class="FileLabel"><strong>Socio:</strong></td>
					<td>
						<cfoutput>#session.B2B.SNnombre# / Número: #session.B2B.SNnumero#</cfoutput>
					</td>
					<td nowrap class="FileLabel" align="right"><strong>Oficina de Empresa </strong>:
					</td>
					<td>
						<select name="Ocodigo_F" id="Ocodigo_F" tabindex="1">
							<cfif isdefined('rsOficinas') and rsOficinas.recordCount GT 0>
								<option value="-1">-- Todas --</option>
								<cfoutput query="rsOficinas">
									<option value="#rsOficinas.Ocodigo#"<cfif isdefined('form.Ocodigo_F') and len(trim(form.Ocodigo_F)) and form.Ocodigo_F EQ rsOficinas.Ocodigo> selected</cfif>>#rsOficinas.Odescripcion#</option>
								</cfoutput>
							</cfif>
			    	</select>					</td>
					<td nowrap align="center" valign="middle">
						<cfif isdefined('form.CatSoc') and form.CatSoc EQ 1>
							<cfset regresa = '/cfmx/sif/ad/catalogos/Socios.cfm?SNcodigo=#session.B2B.SNcodigo#'>
						</cfif>					
					</td>
				  </tr>
				  </cfif>
				  <tr>
				 	 <td colspan="6">
						<table border="0" cellspacing="0" cellpadding="0" width="50%" align="center">
 							<tr>
    							<td align="center">
									<input type="hidden" name="botonSel" value="">
									<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb" tabindex="-1" style="visibility:hidden;">
								</td>
    							<td align="center">
									<input type="submit" name="Consultar" class="btnNormal" value="Análisis" onclick="javascript: this.form.botonSel.value = this.name; if (window.funcConsultar) return funcConsultar();" tabindex="1">
								</td>
			</form>

								<cfif isdefined("session.B2B.SNcodigo") and len(trim(session.B2B.SNcodigo))>
									<form name="form2" method="post" action="" style="margin:0;">
										<input name="SNcodigo"  type="hidden" value="<cfoutput>#session.B2B.SNcodigo#</cfoutput>">
										<input name="Ocodigo_F"  type="hidden" value="<cfif isdefined("form.Ocodigo_F") and len(trim(form.Ocodigo_F))><cfoutput>#form.Ocodigo_F#</cfoutput><cfelse>-1</cfif>">
										<cfif isdefined('form.CatSoc') and form.CatSoc EQ 1>
											<input name="CatSoc"  type="hidden" value="<cfoutput>#form.CatSoc#</cfoutput>">
										</cfif>
										<td align="center">
											<input type="submit" name="Datos" class="btnNormal" value="Datos" onclick="javascript: if (window.funcDatos) return funcDatos();" tabindex="1">
										</td>									
										<td align="center">
											<input type="submit" name="Imprimir" class="btnNormal" value="Saldo" onclick="javascript: if (window.funcImprimir) return funcImprimir();" tabindex="1">
										</td>
										<td align="center">
											<input type="button" name="reporte" class="btnNormal" value="Antiguedad" onclick="javascript: if (window.funcreporte) return funcreporte();" tabindex="1">
										</td>
										<td align="center">
											<input type="button" name="historico" class="btnNormal" value="Hist&oacute;rico" onclick="javascript: if (window.funcHistorico) return funcHistorico();" tabindex="1">
										</td>
									</form>	
								</cfif>
										
								<cfif isdefined('form.CatSoc') and form.CatSoc EQ 1>
									<cfset regresa = '/cfmx/sif/ad/catalogos/Socios.cfm?SNcodigo=#session.B2B.SNcodigo#'>
									<td align="center">
										<input type="button" name="Regresar" class="btnAnterior" value="Regresar" onclick="javascript:location.href='<cfoutput>#regresa#</cfoutput>'" tabindex="1">
									</td>
								</cfif>								
  							</tr>
						</table>				  
				  </td>
				  </tr>
			  </table>
			</form>
			<br/>
			<cfif not (isdefined("session.SocioCxC") and len(trim(session.SocioCxC)))>
				<cf_qforms>
				<script language="javascript" type="text/javascript">
					<!--//
					objForm.SNcodigo.required = true;			
					objForm.SNcodigo.description = 'Socio de Negocios';
					//-->
				</script>
			</cfif>
			<cfif isdefined('session.B2B.SNcodigo') and session.B2B.SNcodigo NEQ ''>
					<cfquery name="rsSocio" datasource="#session.DSN#">
						select SNcodigo, SNnombre
						from SNegocios
						where Ecodigo= #session.Ecodigo#
						  and SNcodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.B2B.SNcodigo#">
					</cfquery>
					<!--- Esta sección se muestra solo cuando está definido el socio... --->
					<table width="100%"  border="0" cellspacing="0" cellpadding="2" align="center">
					  <tr><td colspan="2" align="center" class="subTitulo">Socio: <cfoutput>#rsSocio.SNcodigo#-#rsSocio.SNnombre#</cfoutput></td></tr>	
					  
			  			<cfif isdefined('form.Ocodigo_F') and form.Ocodigo_F gt -1>
							<cfquery name="rsOficina" datasource="#session.DSN#">
								select Ocodigo, Odescripcion
								from Oficinas
								where Ecodigo= #session.Ecodigo#
								  and Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo_F#">
							</cfquery>
						</cfif>
						<tr><td colspan="2" align="center" class="subTitulo">Oficina: <cfif isdefined("rsOficina")><cfoutput>#rsOficina.Ocodigo#-#rsOficina.Odescripcion#</cfoutput><cfelse>Todas</cfif></td></tr>	
					  
					  <tr><td colspan="2" align="center" >&nbsp;</td></tr>	
					  <tr>
						<td>
							<cfset session.referencia = 'analisisSocio.cfm'>
							<cfinclude template="/sif/B2B/CxC/MenuCC-barGraph-v2.cfm">
						</td>
						<td>
							<cfif isdefined('rsGraficoBar') and rsGraficoBar.recordCount GT 0>
								<cfinclude template="/sif/B2B/CxC/MenuCC-pieGraph.cfm">
							<cfelse>
								&nbsp;
							</cfif>	
						</td>					
					  </tr>
					  <tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>					
					  </tr>
					  
                      <tr>
                        <td colspan="2" class="subTitulo" nowrap="nowrap">
                            Pendientes
                        </td>
                      </tr>	
					
					  <tr>
						<td colspan="2">			
								<cfinvoke
									component="sif.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pLista"
									query="#rsContactoSocio#"
									formname="listaDocum"
									funcion="verContactos"
									fparams="CSEid"
									keys="CSEid"
									desplegar="Responsable, CCTcodigo, Ddocumento, Usulogin, CSEFecha, TCid, CSEnombreContacto"
									etiquetas="Responsable, Transaccion, Documento, Usuario Asignado, Fecha, Tipo, Contacto"
									totalgenerales="SaldoLoc"
									formatos="S, S, S, S, D, S, S"
									align="left, left, left, left, left, left, left"
									navegacion="#navegacion#"
									showlink="false"
									maxrows="0"
									pageindex="2"
									ira="analisisSocio.cfm"/>
									

							</td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
						</tr>
					  <tr>
						<td colspan="2" class="subTitulo">Vencimiento</td>
					  </tr>				  
					  <tr>
						<td colspan="2">
							<cfif isdefined("session.B2B.SNcodigo") and len(trim(session.B2B.SNcodigo))>
								<cfset navegacion = navegacion & "&SNcodigo=" & session.B2B.SNcodigo>
							</cfif>
							<cfif isdefined("form.Ocodigo_F") and len(trim(form.Ocodigo_F))>
								<cfset navegacion = navegacion & "&Ocodigo_F=" & form.Ocodigo_F>
							</cfif>
							<cfif isdefined("form.id_direccion") and len(trim(form.id_direccion))>
								<cfset navegacion = navegacion & "&id_direccion=" & form.id_direccion>
							</cfif>
							<cfinvoke
								component="sif.Componentes.pListas"
								method="pListaQuery"
								returnvariable="pLista"
								query="#rsGraficoBar#"
								formname="listaVencOfi"
								desplegar="direccion, Corriente, SinVencer, P1, P2, P3, P4, P5, Morosidad, Dsaldo"
								etiquetas="Direcci&oacute;n,  Corriente, Sin Vencer, #venc1#, #venc2#, #venc3#, #venc4#, mas de #venc4#, Morosidad, Saldo"
								formatos="S, M, M, M, M, M, M, M, M, M"
								totales="Corriente,SinVencer,P1,P2,P3,P4,P5,Morosidad,Dsaldo"
								align="left, right, right, right, right, right, right, right, right, right"
								navegacion="#navegacion#"
								maxrows="15"
								keys="id_direccion"
								pageindex="1"
								ira="analisisSocio.cfm"/>
						</td>		
					  </tr>
					  <tr>
						<td colspan="2">&nbsp;</td>
					  </tr>		
					  
					  <tr>
					  	<td></td>
					  </tr>
					  
					  <cfif isdefined('rsDocumentos') and rsDocumentos.recordCount GT 0 >				  
						  <tr>
							<td colspan="2" class="subTitulo">Documentos<cfif isdefined("form.id_direccion") and form.id_direccion gt -1> de <cfoutput>#rsDocumentos.direccion#</cfoutput></cfif></td>
						  </tr>	
						  <tr>
							<td colspan="2">				
								<cfinvoke
									component="sif.Componentes.pListas"
									method="pListaQuery"
									returnvariable="pLista"
									query="#rsDocumentos#"
									formname="listaDocum"
									Cortes="Mnombre"
									funcion="verdocumentos"
									fparams="HDid"
									desplegar="Tipo, Documento, Fecha, Vencimiento, Oficina, Monto, Saldo, SaldoLoc"
									etiquetas="Tipo, Documento, Fecha, Vencimiento, Oficina, Monto, Saldo, Local"
									totalgenerales="SaldoLoc"
									formatos="S, S, D, D, S, M, M,M"
									align="left, left, center, center, center, right, right, right"
									navegacion="#navegacion#"
									showlink="false"
									maxrows="0"
									pageindex="2"
									ira="analisisSocio.cfm"/>
							</td>
						  </tr>	
					  </cfif><!--- si está definida la consulta de documentos --->
					</table>
			</cfif><!--- si está definido el socio ??? --->
		<cf_web_portlet_end>
	<cf_templatefooter>
<cfif not (isdefined("session.SocioCxC") and len(trim(session.SocioCxC)))>
	<script>document.form1.SNnumero.focus();</script>
</cfif>	
<script language="JavaScript">
	var popUpWin=0;
	var popUpWinSN=0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWinSN) {
			if(!popUpWinSN.closed) popUpWinSN.close();
		}
		popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onfocus = closePopUp;
	}
	function closePopUp(){
		if(popUpWinSN) {
			if(!popUpWinSN.closed) popUpWinSN.close();
			popUpWinSN=null;
		}
	}
	
	function funcreporte() {
		popUpWindow("/cfmx/sif/B2B/CxC/reportes/AntSalCliDet-sql.cfm?SNcodigo=<cfoutput><cfif isdefined("session.B2B.SNcodigo")>#session.B2B.SNcodigo#<cfelse>-1</cfif></cfoutput>",200,75,900,800);
	}
	function funcHistorico() {
		open("/cfmx/sif/B2B/CxC/consultas/analisisSocioHM.cfm?SNcodigo=<cfoutput><cfif isdefined("session.B2B.SNcodigo")>#session.B2B.SNcodigo#<cfelse>-1</cfif></cfoutput>",'V1','left=75,top=75,scrollbars=yes,resizable=yes,width=1000,height=900');
	}
	

	function verdocumentos(HDid){
		var PARAM  = "/cfmx/sif/B2B/CxC/consultas/RFacturasCC2-DetalleDoc.cfm?pop=true&HDid="+ HDid;
		open(PARAM,'V1','left=110,top=150,scrollbars=yes,resizable=yes,width=1000,height=500')
	}
	<cfif isdefined("session.B2B.SNcodigo")>
		function verContactos(CSEid){
			var PARAM  = "/cfmx/sif/B2B/CxC/catalogos/Contacto.cfm?pop=true&SNcodigo=<cfoutput>#session.B2B.SNcodigo#</cfoutput>&CSEid="+ CSEid;
			open(PARAM,'V1','left=100,top=150,scrollbars=yes,resizable=no,width=1000,height=350')
		}
	</cfif>
</script>