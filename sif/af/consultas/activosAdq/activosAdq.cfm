<cfset Regresar = "/sif/af/MenuConsultasAF.cfm">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
			<!--- Consultas para pintar el formulario --->
			<!--- Periodo --->
			<cfquery name="rsPeriodo" datasource="#session.dsn#">
				select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
				from Parametros
				where Ecodigo = #session.Ecodigo#
					and Pcodigo = 50
					and Mcodigo = 'GN'
			</cfquery>
			
			<!--- Periodos --->
			<cfset rsPeriodos = QueryNew("Pvalor")>
			<cfset temp = QueryAddRow(rsPeriodos,3)>
			<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-2,1)>
			<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-1,2)>
			<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor,3)>
			
			<!--- Mes --->
			<cfquery name="rsMes" datasource="#session.dsn#">
				select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
				from Parametros
				where Ecodigo = #session.Ecodigo#
					and Pcodigo = 60
					and Mcodigo = 'GN'
			</cfquery>
			
			<!--- Meses --->
			<cfquery name="rsMeses" datasource="sifControl">
				select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
				from Idiomas a, VSidioma b 
				where a.Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Idioma#">
					and b.VSgrupo = 1
					and a.Iid = b.Iid
				order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
			</cfquery>
			
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr><td nowrap>&nbsp;</td></tr>
				<tr>
					<td valign="top" width="45%" align="center">
						<table width="90%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td>
									<cf_web_portlet_start border="true" titulo="Reporte de Activos" skin="info1">
										<p align="justify">En &eacute;sta consulta se muestra la informaci&oacute;n de todos los activos adquiridos, agrupados
										&eacute;stos por Centro funcional, Categor&iacute;a, Clase. Este reporte
										se puede generar en varios formatos - Html, pdf y xls-,
										mejorando su presentaci&oacute;n y aumentando as&iacute; su utilidad
										y eficiencia en el traslado de datos. </p>
									<cf_web_portlet_end>
								</td>
							</tr>
						</table>
					</td>
						
					<td valign="top" width="55%" align="center">					
						<cfoutput>
						<form method="get" name="form1" action="activosAdq-rep.cfm">
							<table width="90%" border="0" cellspacing="0" cellpadding="1">
								<!--- Línea No. 1 --->
								<tr>
									<td align="right" width="25%" nowrap><strong>Categor&iacute;a Inicial:&nbsp;</strong></td>
									<td nowrap>
										<cfset ValuesArray=ArrayNew(1)>
										<cf_conlis
											Campos="ACcodigoI, ACcodigodescI, ACdescripcionI, ACmascaraI"
											Desplegables="N,S,S,N"
											Modificables="N,S,N,N"
											Size="0,10,40,0"
											ValuesArray="#ValuesArray#"
											Title="Lista de Categorías"
											Tabla="ACategoria a"
											Columnas="ACcodigo as ACcodigoI, 
													  ACcodigodesc as ACcodigodescI, 
													  ACdescripcion as ACdescripcionI, 
													  ACmascara as ACmascaraI"
											Filtro="Ecodigo = #Session.Ecodigo# 
											order by ACcodigodesc, ACdescripcion"
											Desplegar="ACcodigodescI, ACdescripcionI"
											Etiquetas="Código,Descripción"
											filtrar_por="ACcodigodesc, ACdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="ACcodigoI, ACcodigodescI, ACdescripcionI, ACmascaraI"
											Asignarformatos="I,S,S,S"
											funcion="asignarCategoriaFinal"
											tabindex="2" />
									</td>
								</tr>
								<!--- Línea No. 2 --->
								<tr>
									<td align="right" width="25%" nowrap><strong>Categor&iacute;a Final:&nbsp;</strong></td>
									<td nowrap>
										<cfset ValuesArray=ArrayNew(1)>
										<cf_conlis
											Campos="ACcodigoF, ACcodigodescF, ACdescripcionF, ACmascaraF"
											Desplegables="N,S,S,N"
											Modificables="N,S,N,N"
											Size="0,10,40,0"
											ValuesArray="#ValuesArray#"
											Title="Lista de Categorías"
											Tabla="ACategoria a"
											Columnas="ACcodigo as ACcodigoF, 
													  ACcodigodesc as ACcodigodescF, 
													  ACdescripcion as ACdescripcionF, 
													  ACmascara as ACmascaraF"
											Filtro="Ecodigo = #Session.Ecodigo# 
											order by ACcodigodesc, ACdescripcion"
											Desplegar="ACcodigodescF, ACdescripcionF"
											Etiquetas="Código,Descripción"
											filtrar_por="ACcodigodesc, ACdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="ACcodigoF, ACcodigodescF, ACdescripcionF, ACmascaraF"
											Asignarformatos="I,S,S,S"
											funcion="validaClaseFinal"
											tabindex="2" />
									</td>
								</tr>
								<!--- Línea No. 3 --->
								<tr>
									<td align="right" width="25%" nowrap><strong>Clase Inicial:&nbsp;</strong></td>
									<td nowrap>
										<cfset ValuesArray=ArrayNew(1)>
										<cf_conlis
											Campos="ACidI, ACcodigodescClasI, ACdescripcionClasI"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											ValuesArray="#ValuesArray#"
											Title="Lista de Clases"
											Tabla="AClasificacion a"
											Columnas="ACid as ACidI, ACcodigodesc as ACcodigodescClasI, ACdescripcion as ACdescripcionClasI, ACdescripcion as GATdescripcionI"
											Filtro="Ecodigo = #Session.Ecodigo# 
											and ACcodigo = $ACcodigoI,numeric$ 
											order by ACcodigodescClasI, ACdescripcionClasI"
											Desplegar="ACcodigodescClasI, ACdescripcionClasI"
											Etiquetas="Código,Descripción"
											filtrar_por="ACcodigodesc, ACdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="ACidI, ACcodigodescClasI,ACdescripcionClasI,GATdescripcionI"
											Asignarformatos="I,S,S,S"
											funcion="asignarClaseFinal"
											debug="false"
											left="250"
											top="150"
											width="500"
											height="300"
											tabindex="2" />
									</td>
								</tr>
								<!--- Línea No. 4 --->
								<tr>
									<td align="right" width="25%" nowrap><strong>Clase Final:&nbsp;</strong></td>
									<td nowrap>
										<cfset ValuesArray=ArrayNew(1)>
										<cf_conlis
											Campos="ACidF, ACcodigodescClasF, ACdescripcionClasF"
											Desplegables="N,S,S"
											Modificables="N,S,N"
											Size="0,10,40"
											ValuesArray="#ValuesArray#"
											Title="Lista de Clases"
											Tabla="AClasificacion a"
											Columnas="ACid as ACidF, ACcodigodesc as ACcodigodescClasF, ACdescripcion as ACdescripcionClasF, ACdescripcion as GATdescripcionF"
											Filtro="Ecodigo = #Session.Ecodigo# 
											and ACcodigo = $ACcodigoF,numeric$ 
											order by ACcodigodescClasF, ACdescripcionClasF"
											Desplegar="ACcodigodescClasF, ACdescripcionClasF"
											Etiquetas="Código,Descripción"
											filtrar_por="ACcodigodesc, ACdescripcion"
											Formatos="S,S"
											Align="left,left"
											Asignar="ACidF, ACcodigodescClasF,ACdescripcionClasF,GATdescripcionF"
											Asignarformatos="I,S,S,S"
											debug="false"
											left="250"
											top="150"
											width="500"
											height="300"
											tabindex="2"/>
									</td>
								</tr>

								<!--- Línea No. 5 --->
								<tr>
									<td align="right" width="25%" nowrap><strong>Centro Funcional Inicial:&nbsp;</strong></td>
									<td><cf_rhcfuncional name="CFcodigoI" desc="CFdescripcionI" id="CFidI" form="form1" tabindex="1"></td>
								</tr>
								<!--- Línea No. 6 --->
								<tr>
									<td align="right" width="25%" nowrap><strong>Centro Funcional Final:&nbsp;</strong></td>
									<td><cf_rhcfuncional name="CFcodigoF" desc="CFdescripcionF" id="CFidF" form="form1" tabindex="1"></td>
								</tr>
								<!--- Línea No. 7 --->
								<tr>
									<td align="right" width="25%" nowrap><strong>Oficina Inicial:&nbsp;</strong></td>
									<td><cf_sifoficinas Ocodigo="OcodigoI" Oficodigo="OficodigoI" Odescripcion="OdescripcionI" form="form1" tabindex="1"></td>
								</tr>
								<!--- Línea No. 8 --->
								<tr>
									<td align="right" width="25%" nowrap><strong>Oficina Final:&nbsp;</strong></td>
									<td><cf_sifoficinas Ocodigo="OcodigoF" Oficodigo="OficodigoF" Odescripcion="OdescripcionF" form="form1" tabindex="1"></td>
								</tr>
								<!--- Línea No. 9 --->
								<tr>
									<td align="right" width="25%" nowrap><strong>Tipo de Activo:&nbsp;</strong></td>
									<td>
										<cf_siftipoactivo id="AFCcodigopadre" name="AFCcodigoclaspadre" desc="Cdescpadre" tabindex="1">
									</td>
								</tr>
								<!--- Línea No. 10 --->
								<tr><td nowrap colspan="2">&nbsp;</td></tr>
								<!--- Línea No. 11 --->
								<tr>
									<td align="center" colspan="2">
										<fieldset>
										<legend>Estado Activo desde</legend>
											<table width="100%"  border="0" cellspacing="0" cellpadding="0">
												<tr>
													<td nowrap><strong>Periodo:&nbsp;</strong></td>
													<td nowrap>
														<select name="Periodo" onChange="javascript:CambiarMes();" tabindex="1">
															<cfloop query="rsPeriodos">
																<option value="#Pvalor#" <cfif rsPeriodo.Pvalor eq rsPeriodos.Pvalor>selected</cfif>>#Pvalor#</option>
															</cfloop>
														</select>
													</td>
													<td nowrap><strong>Mes:&nbsp;</strong></td>
													<td nowrap>
														<select name="Mes" tabindex="1"></select>
													</td>
												</tr>
											</table>
										</fieldset>
									</td>
								</tr>
								<!--- Línea No. 12 --->
								<tr><td colspan="2" nowrap>&nbsp;</td></tr>
								<!--- Línea No. 13 --->
								<tr>
									<td align="right" width="25%" nowrap><strong>Formato:&nbsp;</strong></td>
									<td>
										<select name="Formato" id="Formato" tabindex="1" onChange="javascript: showChkbox(this.form);">
											<option value="1">FLASHPAPER</option>
											<option value="2">PDF</option>
											<option value="3">Exportar a Archivo TXT</option>
											<option value="4">Exportar a Archivo Excel</option>
										</select>
									</td>
								</tr>
								<!--- Línea No. 14 --->
								<tr id="TR_DatosVariables"><td nowrap align="right"><strong>Datos Variables:&nbsp;</strong></td>
								    <td nowrap>
										<cfquery name="datosVariables" datasource="#session.dsn#">
											select a.DVid, a.DVetiqueta from DVdatosVariables a
												inner join DVconfiguracionTipo b
													on a.DVid = b.DVid
											where DVTcodigoValor = 'AF'
										</cfquery>
										<fieldset id="fiel">
											<select name="DVid">
												<cfloop query="datosVariables">
													<option value="#datosVariables.DVid#">#datosVariables.DVetiqueta#</option>
												</cfloop>
											</select>
											<img src="../../../imagenes/mas.gif" name="agregar" onclick="crear(this)" />
										</fieldset>
									</td>
								</tr>
								<!--- Línea No. 15 --->
								<tr>
									<td align="center" colspan="2">
										<cf_botones values="Generar, Limpiar" names="Reporte, Limpiar" tabindex="1">
									</td>
								</tr>
								<!--- Línea No. 16 --->
								<tr><td nowrap>&nbsp;</td></tr>
							</table>
						</form>
						</cfoutput>
					</td>
				</tr>
			</table>
<!---Funciones en Javascript del formulario de filtro--->
	<script language="javascript1.2" type="text/javascript">
		var form = document.form1;
		num=0;
		function crear(obj) {
		  num++;
		 if (document.getElementById(form.DVid.value) != null)
		 {
			 alert('El Dato Variable ya fue agregado a la lista');
			 return;
		 }
		 
		  <!---Se crea el conetenedor--->
		  fi = document.getElementById('fiel'); 
		  contenedor = document.createElement('div');
		  contenedor.id = 'div'+num; 
		  fi.appendChild(contenedor); 
		
		  <!---Crea el campo que se ver en pantalla--->
		  ele = document.createElement('label');
		  ele.id = form.DVid.value;
		  ele.innerHTML = form.DVid.options[form.DVid.selectedIndex].text;
		  contenedor.appendChild(ele); 
		  
		  <!---Crea el boton de Eliminar--->
		  ele = document.createElement('img'); 
		  ele.src = '../../../imagenes/Borrar01_S.gif';
		  ele.name = 'div'+num; 
		  ele.onclick = function () {borrar(this.name)}
		  contenedor.appendChild(ele); 
		  
		  <!---Crea el Hiden que se enviar en el Form--->
		  ele = document.createElement('input');
		  ele.type = 'hidden'; 
		  ele.name = 'DatosVariables'; 
		  ele.value = form.DVid.value;
		  contenedor.appendChild(ele); 
		  
		}
		function borrar(obj) {
		  fi = document.getElementById('fiel'); 
		  fi.removeChild(document.getElementById(obj)); 
		}

		function showChkbox(f) {
			var TR_DatosVariables = document.getElementById("TR_DatosVariables");
				TR_DatosVariables.style.display  = "";
			if (f.Formato.value == '1' || f.Formato.value == '2')
				TR_DatosVariables.style.display  = "none";
			{
				
			}
		}
		function asignarCategoriaFinal() 
		{
			if (form.ACcodigodescF.value == "") 
			{
				form.ACcodigoF.value = form.ACcodigoI.value; 
				form.ACcodigodescF.value = form.ACcodigodescI.value;
				form.ACdescripcionF.value = form.ACdescripcionI.value;
				form.ACmascaraF.value = form.ACmascaraI.value;
				form.ACcodigodescClasI.focus();
			}
		}
	
		function asignarClaseFinal()
		{
			if (form.ACcodigodescI.value == form.ACcodigodescF.value) 
			{
				form.ACidF.value = form.ACidI.value;
				form.ACcodigodescClasF.value = form.ACcodigodescClasI.value;
				form.ACdescripcionClasF.value = form.ACdescripcionClasI.value;
				form.ACcodigodescClasF.focus();
			}
			else {
				form.ACidF.value = "";
				form.ACcodigodescClasF.value = "";
				form.ACdescripcionClasF.value = "";
				form.ACcodigodescClasF.focus();
			}
		}
	
		function validaClaseFinal()
		{
			if (form.ACcodigodescI.value != form.ACcodigodescF.value)
			{
				form.ACidF.value = "";
				form.ACcodigodescClasF.value = "";
				form.ACdescripcionClasF.value = "";
				form.ACcodigodescClasF.focus();
			}
		}

		function CambiarMes()
		{
			var oCombo = form.Mes;
			var vPeriodo = form.Periodo.value;
			var cont = 0;
			oCombo.length=0;
			<cfoutput query="rsMeses">
				if ( (#Trim(rsPeriodo.Pvalor)# > vPeriodo) || ((#Trim(rsPeriodo.Pvalor)# == vPeriodo) && (#Trim(rsMes.Pvalor)# >= #rsMeses.Pvalor#)) )
				{
					oCombo.length=cont+1;
					oCombo.options[cont].value='#Trim(rsMeses.Pvalor)#';
					oCombo.options[cont].text='#Trim(rsMeses.Pdescripcion)#';
					<cfif rsMeses.Pvalor eq rsMes.Pvalor>
						if (#Trim(rsPeriodo.Pvalor)# == vPeriodo)
							oCombo.options[cont].selected = true;
					</cfif>
					cont++;
				};
			</cfoutput>
		}
			
		function _forminit()
		{
			form.ACcodigodescI.focus();
			CambiarMes();
		}
	
		function _formclose(){ }
		_forminit();
		showChkbox(document.form1);
</script>						
			
		<cf_web_portlet_end>
	<cf_templatefooter>