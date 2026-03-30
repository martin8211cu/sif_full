<!---
	MÃ³dulo      : Activos Fijos / Control de Responsables
	Nombre      : Consulta Documentos por Centro Funcional
	DescripciÃ³n :
		Muestra por reporte de documentos por vale, filtrado por Tipo de Documentos,
		Placa y Centro Funcional. Agrupado por Centro de Custodia y Centro
		Funcional.
	Hecho por   : Steve Vado RodrÃ­guez
	Creado      : 15/11/2005
	Modificado  : 
 --->

<!--- Valida que los parametros vengan por URL --->
<cfif isdefined("url.chkverresumida")>
	<cfset form.chkverresumida = url.chkverresumida >
</cfif>
<cfif isdefined("url.chkverdetalle")>
	<cfset form.chkverdetalle = url.chkverdetalle >
</cfif>
<cfif isdefined("url.chkvercategoria")>
	<cfset form.chkvercategoria = url.chkvercategoria >
</cfif>
<cfif isdefined("url.chkverclase")>
	<cfset form.chkverclase = url.chkverclase >
</cfif>
<cfif isdefined("url.chkverserie")>
	<cfset form.chkverserie = url.chkverserie >
</cfif>
<cfif isdefined("url.chkveringreso")>
	<cfset form.chkveringreso = url.chkveringreso >
</cfif>
<cfif isdefined("url.chkverfultran")>
	<cfset form.chkverfultran = url.chkverfultran >
</cfif>
<cfif isdefined("url.chkverestado")>
	<cfset form.chkverestado = url.chkverestado >
</cfif>
<cfif isdefined("url.chkverusuario")>
	<cfset form.chkverusuario = url.chkverusuario >
</cfif>

<!--- Consultas --->
<cfquery name="rsTipoDocumento" datasource="#session.DSN#">
	select 	CRTDid, CRTDdescripcion, CRTDdefault 
	from CRTipoDocumento
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cf_templateheader title="Documentos por Vale">
		<cfinclude template="../../../portlets/pNavegacion.cfm">				
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Documentos por Centro Funcional">
		<cfif not isdefined("form.btnConsultar")>	
			<iframe id="frameAplaca" name="frameAplaca" 
				marginheight="0" 
				marginwidth="0" 
				frameborder="0" 
				height="0" 
				width="0" scrolling="no"></iframe>
			<form action="DocumentosPorValeRep.cfm" method="post" name="form1" onSubmit="return fnRevisarForm()">
				<cfoutput>
				<table width="100%" border="0">
					<tr>
						<td  valign="top"width="32%"> 
							<cf_web_portlet_start border="true" titulo="Documentos por Centro Funcional" skin="info1">
							<div align="center">
						  		<p align="justify">
									Muestra un reporte de documentos por vale, filtrado por Tipo de Documentos,
									Placa y Centro Funcional. Agrupado por Centro de Custodia y Centro
									Funcional.								
									<br><br>
									La opci&oacute;n Incluir Hijos incluye todos los Centros Funcionales
									que son hijos del indicado en el filtro.								</p>
							</div>
							<cf_web_portlet_end>						
						</td>
						<td width="3%">&nbsp;</td>
					  	<td width="65%">
					  		<table width="100%" border="0">
                        		<tr>
                          			<td width="20%" nowrap="nowrap" align="right">Centro Funcional (Inicial):</td>
                         			<td colspan="4">
										<cf_conlis
											Campos="CFidIni,CFcodigoIni,CFdescripcionIni"
											tabindex="6"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,15,50"
											Title="Lista de Centros Funcionales"
											Tabla="CRCCCFuncionales a
													inner join CFuncional b
													on a.CFid = b.CFid
													and b.Ecodigo = #Session.Ecodigo#
													inner join CRCentroCustodia c
													on a.CRCCid = c.CRCCid "
											Columnas="distinct  b.CFid as CFidIni,b.CFcodigo as CFcodigoIni,b.CFdescripcion as CFdescripcionIni"
											Filtro="1=1 order by CFcodigo,CFdescripcion"
											Desplegar="CFcodigoIni,CFdescripcionIni"
											Etiquetas="C&oacute;digo,Descripci&oacute;n"
											filtrar_por="b.CFcodigo,b.CFdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="CFidIni,CFcodigoIni,CFdescripcionIni"
											Asignarformatos="I,S,S"
											funcion="resetEmpleado"/>
									</td>
                        		</tr>
                        		<tr>
                          			<td width="20%" align="right">Centro Funcional (Final):</td>
                          			<td colspan="4">
										<cf_conlis
											Campos="CFidFin,CFcodigoFin,CFdescripcionFin"
											tabindex="6"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,15,50"
											Title="Lista de Centros Funcionales"
											Tabla="CRCCCFuncionales a
													inner join CFuncional b
													on a.CFid = b.CFid
													and b.Ecodigo = #Session.Ecodigo#
													inner join CRCentroCustodia c
													on a.CRCCid = c.CRCCid "
											Columnas="distinct b.CFid as CFidFin,b.CFcodigo as CFcodigoFin,b.CFdescripcion as CFdescripcionFin"
											Filtro="1=1 order by CFcodigo,CFdescripcion"
											Desplegar="CFcodigoFin,CFdescripcionFin"
											Etiquetas="C&oacute;digo,Descripci&oacute;n"
											filtrar_por="b.CFcodigo,b.CFdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="CFidFin,CFcodigoFin,CFdescripcionFin"
											Asignarformatos="I,S,S"
											funcion="resetEmpleado"/>
									</td>
                        		</tr>
                        		<tr>
                          			<td width="20%" align="right">Placa:</td>
                          			<td colspan="4">
										<input type="text" name="AplacaINI"
											value="" size="20" 
											tabindex="3"
											onblur="javascript:traeAplacaINI(this.value);" />
                              			<input type="text" name="AdescripcionINI"
										 	value="" size="40" 
											tabindex="-1"
											readonly />
                              			<a href="javascript:doConlisAplacaINI();" tabindex="-1"> 
											<img src="/cfmx/sif/imagenes/Description.gif"
												alt="Lista de Placas"
												name="imagenAplaca"
												width="18" 
												height="14"
												border="0" 
												align="absmiddle" /> 
										</a>
									</td>
                        		</tr>
                        		<tr>
                          			<td align="right">Estado:</td>
                          			<td>
						  				<select name="estado" tabindex="5">
							  				<option value="A,T" selected>Activos y En Tr&aacute;nsito</option>							  
                              				<option value="A">Activos</option>
                              				<option value="I">Inactivos</option>
                              				<option value="T">En Tr&aacute;nsito</option>
							  				<option value="">Todos</option>
                            			</select>                          
						  			</td>
                        		</tr>
                        		<tr>
                          			<td align="right">Tipo de Documento:</td>
                          			<td width="24%" align="left" >
										<select name="TipoVale" tabindex="6">
											<option value="-1" label="Todos" <cfif isdefined("CRTDdefault") and trim(CRTDdefault) NEQ 1 > selected </cfif> >Todos</option>
											<cfloop query="rsTipoDocumento">
												<option value="#CRTDid#" label="#CRTDdescripcion#" <cfif isdefined("CRTDdefault") and trim(CRTDdefault) EQ 1> selected </cfif> >#CRTDdescripcion#</option>
											</cfloop>
										</select> 
						  			</td>
                          			<td width="16%" align="right">Incluir Hijos</td>
                          			<td width="4%" align="left"><input name="IncluyeHijo" type="checkbox" value="1"  tabindex="7"/></td>
                          			<td width="17%" align="left">&nbsp;</td>
                          			<td width="19%" align="left">&nbsp;</td>
                        		</tr>
								<tr>
									<td align="right">Descripcion:</td>
                          			<td>
						  				<input type="text" name="descripcion" id="descripcion" size="%50"/>                          
						  			</td>
								</tr>
                        		<tr>
                          			<td>&nbsp;</td>
                        		</tr>						
								<tr>
									<td colspan="6" align="center">
							
										<fieldset style="width:80%;">
										<legend style="font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:normal; font-weight:bolder;">Informaci&oacute;n Opcional</legend>
										<table cellpadding="0" cellspacing="0" align="center" style="width:80%">
											<tr><td colspan="4">&nbsp;</td></tr>
											<tr>
												<td align="right"><strong>Mostrar Fecha de Ingreso:</strong></td>
												<td>
													<input type="checkbox" name="chkveringreso" 
														<cfif not isdefined("url.reporte")>checked="checked"</cfif> 
														<cfif isdefined("form.chkveringreso")>checked</cfif> />
												</td>
												<td align="right"><strong>Mostrar Fecha &Uacute;ltima Transacci&oacute;n:</strong></td>
												<td>
													<input type="checkbox" name="chkverfultran" 
														<cfif not isdefined("url.reporte")>checked="checked"</cfif> 
														<cfif isdefined("form.chkverfultran")>checked</cfif> />
												</td>									
											</tr>
										
											<tr>
												<td align="right"><strong>Mostrar Desc. Resumida:</strong></td>
												<td>
													<input type="checkbox" name="chkverresumida" 
														<cfif isdefined("form.chkverresumida")>checked</cfif> />
												</td>													
												<td align="right"><strong>Mostrar Desc. Detallada:</strong></td>
												<td>
													<input type="checkbox" name="chkverdetalle" 
														<cfif not isdefined("url.reporte")>checked="checked"</cfif> 
														<cfif isdefined("form.chkverdetalle")>checked</cfif> />
												</td>
											</tr>
										
											<tr>
												<td align="right"><strong>Mostrar Serie:</strong></td>
												<td>
													<input type="checkbox" name="chkverserie" 
														<cfif not isdefined("url.reporte")>checked="checked"</cfif> 
														<cfif isdefined("form.chkverserie")>checked</cfif> />
												</td>
												<td align="right"><strong>Mostrar Estado:</strong></td>
												<td>
													<input type="checkbox" name="chkverestado" 
														<cfif isdefined("form.chkverestado")>checked</cfif> />
												</td>
											</tr>
									
											<tr>
												<td align="right"><strong>Mostrar Categor&iacute;a:</strong></td>
												<td>
													<input type="checkbox" name="chkvercategoria" 
														<cfif isdefined("form.chkvercategoria")>checked</cfif> />
												</td>
												<td align="right"><strong>Mostrar Clase:</strong></td>
												<td>
													<input type="checkbox" name="chkverclase" 
														<cfif isdefined("form.chkverclase")>checked</cfif> />
												</td>									
											</tr>
											
											<tr>
												<td align="right" colspan="2">&nbsp;</td>		
												<td align="right"><strong>Mostrar Usuario:</strong></td>
												<td>
													<input type="checkbox" name="chkverusuario" 
														<cfif isdefined("form.chkverusuario")>checked</cfif> />
												</td>
											</tr>

										</table>											
										</fieldset>							
									</td>
								</tr>
                        		<tr>
                          			<td>&nbsp;</td>
                        		</tr>
                        		<tr>
                          			<td colspan="6" align="center">
										<div align="center">
											<input name="btnConsultar" type="submit" value="Consultar" tabindex="8"/>
											<input type="reset" name="Reset" value="Limpiar" tabindex="9"/>
											<input name="sTipoVale" type="hidden" value="Todos" />
											<input name="sCCIni" type="hidden" value="1" />
											<input name="sCCFin" type="hidden" value="1" />
											<input type="hidden" value="0" name="errorFlag" id="errorFlag"/> 
                          				</div>
									</td>
                        		</tr>
                      		</table>
					  	</td> 
					</tr>
				</table> 
				</cfoutput>
			</form> 
		</cfif> 
		<cf_web_portlet_end>
	<cf_templatefooter> 

<script language="javascript1.2" type="text/javascript">
	var popUpWinAplaca=null;
	document.form1.CFcodigoIni.focus();
	
	function fnRevisarForm () {
		var ret = true;
		var f = document.form1;

		if (f.CFidIni.value == '' && f.CFidFin.value == '' && f.AplacaINI.value == '') {
			alert('Debe de escoger una placa o un rango de centros funcionales');
			ret = false;
		}		
		if (ret == true) {
			if (f.CFidIni.value == '' && f.CFidFin.value == '') {
			
			} else {
				if (f.CFidIni.value == '' || f.CFidFin.value == '') {
					alert('Debe digitar un rango de centros funcionales');

					if (f.CFidIni.value == '' && f.CFidFin != '') {
						f.CFidIni.value = f.CFidFin.value;
						f.CFcodigoIni.value = f.CFcodigoFin.value;
						f.CFdescripcionIni.value = f.CFdescripcionFin.value;
					} else {
						if (f.CFidFin.value == '' && f.CFidIni != '') {
							f.CFidFin.value = f.CFidIni.value;
							f.CFcodigoFin.value = f.CFcodigoIni.value;
							f.CFdescripcionFin.value = f.CFdescripcionIni.value;
						}
					}
					ret = false;
				}
			}			
		}		
		return ret;
	}
	
	function popUpWindowAplaca(URLStr, left, top, width, height)
	{
	  if(popUpWinAplaca)
	  {
		if(!popUpWinAplaca.closed) popUpWinAplaca.close();
	  }
	  popUpWinAplaca = open(URLStr, 'popUpWinAplaca', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisAplacaINI(){
		var conlisArgs = 'form=form1&desc=AdescripcionINI&name=AplacaINI';
		popUpWindowAplaca('/cfmx/sif/Utiles/ConlisPlaca.cfm?'+conlisArgs,250,200,650,550);
	}
	
	function traeAplacaINI(value){
		if (value!='')	{
			var conlisArgs = 'form=form1&desc=AdescripcionINI&name=AplacaINI';
			conlisArgs = conlisArgs + '&filtro_Aplaca=' + escape(value);
			document.getElementById('frameAplaca').src = '/cfmx/sif/Utiles/traePlaca.cfm?'+conlisArgs;
		} else {
			document.form1.AplacaINI.value = '';
			document.form1.AdescripcionINI.value = '';
		}
	}	
</script>
