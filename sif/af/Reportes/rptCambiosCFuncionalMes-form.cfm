	<form action="rptCambiosCFuncionalMes.cfm" method="post" name="form1" style="margin:0px;">
<table align="center" border="0" width="100%" cellpadding="0" cellspacing="0">
<tr>
	<td valign="top" width="40%" align="left" >
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td>
					<cf_web_portlet_start border="true" titulo="Reporte de Activos por Centro Funcional" skin="info1">
						<p align="justify">En &eacute;ste reporte se muestra la informaci&oacute;n referente a cambios de Centro Funcional por rango de Periodos / Mes / Centro Funcional Origen / Centro Funcional Destino / Fechas.
						Mediante una selección se podrá realizar una búsqueda por rango de categorias si se elige la opción (Categoría), desabilitandose de manera automática la opción clase,
						por otro lado si la seleccionada es la opción clase es requerido ingresar una categoría y apartir de ésta un rango de clases.
						Puede además filtrarse la información por placa, y exportarse la información presentada en el reporte activando el check (Exportar a Archivo).
						</p>
					<cf_web_portlet_end>
				</td>
			</tr>
		</table>
	</td>
<td valign="top" width="60%" align="left">
<table align="right" width="100%" border="0" cellpadding="0" cellspacing="0">
	<tr>
		<td colspan="7">&nbsp;</td></tr>
	<tr>
		<td colspan="7" align="center">
			<strong>Periodo Inicial:&nbsp;&nbsp;&nbsp;</strong> &nbsp;
			<cfif isdefined("url.periodoInicial") and len(trim(url.periodoInicial))>
				<cf_periodos name="periodoInicial" value="#url.periodoInicial#" tabindex="1">
			<cfelse>
				<cf_periodos name="periodoInicial" tabindex="1">
			</cfif>
				<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Periodo Final:</strong> &nbsp;
			<cfif isdefined("url.periodoFinal") and len(trim(url.periodoFinal))>
				<cf_periodos name="periodoFinal" value="#url.periodoFinal#" tabindex="1">
			<cfelse>
				<cf_periodos name="periodoFinal" tabindex="1">
			</cfif>
		</td>
	</tr>
		<tr>
		<td align="center" colspan="7">
		  	<strong>&nbsp;&nbsp;&nbsp;Mes Inicial:&nbsp;&nbsp;&nbsp;</strong> &nbsp;
			<cfif isdefined("url.mesInicial") and len(trim(url.mesInicial))>
				<cf_meses name="mesInicial" value="#url.mesInicial#" tabindex="1">
			<cfelse>
				<cf_meses name="mesInicial" tabindex="1">
			</cfif>
				<strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Mes Final:</strong> &nbsp;
			<cfif isdefined("url.mesFinal") and len(trim(url.mesFinal))>
				<cf_meses name="mesFinal" value="#url.mesFinal#" tabindex="1">
			<cfelse>
				<cf_meses name="mesFinal" tabindex="1">
			</cfif>
		</td>
	</tr>
	<tr>
		<td colspan="7" align="center">
			<fieldset style="width:80%;">
			<legend style="font-family:'Times New Roman', Times, serif; font-size:11pt; font-variant:normal; font-weight:bolder;">Categoria - Clase</legend>
			<table cellpadding="0" cellspacing="0" >
				<tr>
					<td align="left" colspan="5"><input checked="checked" type="radio" name="TipoBus" id="TipoBus" value="1" onclick="Cambia()"/>Categoria</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="2">&nbsp;</td>
					<td colspan="2">&nbsp;</td>
					<td align="right">
					<strong>Inicial:</strong>&nbsp;</td>
					<td>
							<cfset valuesArray = ArrayNew(1)>
						<cfif isdefined("url.codigodesde")>
							<cfset ArrayAppend(valuesArray, url.codigodesde)>
						</cfif>
						<cfif isdefined("url.ACinicio")>
							<cfset ArrayAppend(valuesArray, url.ACinicio)>
						</cfif>
						<cfif isdefined("url.ACdescripciondesde")>							
							<cfset ArrayAppend(valuesArray, url.ACdescripciondesde)>
						</cfif>
						<cf_conlis
							campos="codigodesde, ACinicio, ACdescripciondesde"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Categor&iacute;as"
								valuesArray="#valuesArray#" 
								tabla="ACategoria"
								columnas="ACcodigo as codigodesde, ACcodigodesc as ACinicio, ACdescripcion as ACdescripciondesde"
								filtro="Ecodigo=#SESSION.ECODIGO# order by ACcodigodesc"
								desplegar="ACinicio, ACdescripciondesde"
								filtrar_por="ACcodigodesc, ACdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="codigodesde, ACinicio, ACdescripciondesde"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontrarón Categor&iacute;as --"
								tabindex="1">	</td>
						<td width="10%">&nbsp;</td>
					</tr>
					<tr>
						<td colspan="2">&nbsp;</td>
						<td colspan="2">&nbsp;</td>
						<td align="right"><strong>Final:&nbsp;</strong></td>
						<td><cfset valuesArrayB = ArrayNew(1)>
							<cfif isdefined("url.codigohasta")>
								<cfset ArrayAppend(valuesArrayB, url.codigohasta)>
							</cfif>
							<cfif isdefined("url.AChasta")>
								<cfset ArrayAppend(valuesArrayB, url.AChasta)>
							</cfif>
							<cfif isdefined("url.ACdescripcionhasta")>
								<cfset ArrayAppend(valuesArrayB, url.ACdescripcionhasta)>
							</cfif>
								<cf_conlis
									campos="codigohasta, AChasta, ACdescripcionhasta"
									desplegables="N,S,S"
									modificables="N,S,N"
									size="0,10,40"
									title="Lista de Categor&iacute;as"
									valuesArray="#valuesArrayB#" 
									tabla="ACategoria"
									columnas="ACcodigo as codigohasta, ACcodigodesc as AChasta, ACdescripcion as ACdescripcionhasta"
									filtro="Ecodigo=#SESSION.ECODIGO# order by ACcodigodesc"
									desplegar="AChasta, ACdescripcionhasta"
									filtrar_por="ACcodigodesc, ACdescripcion"
									etiquetas="Código, Descripción"
									formatos="S,S"
									align="left,left"
									asignar="codigohasta, AChasta, ACdescripcionhasta"
									asignarformatos="S, S, S"
									showEmptyListMsg="true"
									EmptyListMsg="-- No se encontrarón Categor&iacute;as --"
									tabindex="1">			
							</td>
						</tr>
						<tr>
							<td align="left"><input type="radio" name="TipoBus" value="2" onclick="Cambia2()" 
								<cfif isdefined("url.TipoBus") and len(trim(url.TipoBus)) and url.TipoBus eq 2>checked="checked"</cfif>
								 />Clase
							</td>
						</tr>		
						<tr>
							<td colspan="2">&nbsp;</td>
							<td colspan="2">&nbsp;</td>
							<td align="right">
								<strong>Categoria:</strong>&nbsp;</td>
							<td>
								<cf_conlis
									campos="ACcodigo, ACcodigodesc, ACdescripcion"
									alt="Categoría, Código, Descripción"
									desplegables="N,S,S"
									modificables="N,S,N"
									size="0,10,40"
									title="Lista de Categor&iacute;as"
									tabla="ACategoria"
									columnas="ACcodigo as ACcodigo, ACcodigodesc as ACcodigodesc, ACdescripcion as ACdescripcion"
									filtro="Ecodigo=#SESSION.ECODIGO#"
									desplegar="ACcodigodesc, ACdescripcion"
									filtrar_por="ACcodigodesc, ACdescripcion"
									etiquetas="Código, Descripción"
									formatos="S,S"
									align="left,left"
									asignar="ACcodigo, ACcodigodesc, ACdescripcion"
									asignarformatos="S, S, S"
									showEmptyListMsg="true"
									EmptyListMsg="-- No se encontraron Categor&iacute;as --"
									tabindex="1"></td>
							<td width="10%">&nbsp;</td>
						</tr>
						<tr>
							<td colspan="2">&nbsp;</td>
							<td colspan="2">&nbsp;</td>
							<td align="right" width="10%" nowrap="nowrap"><strong>Clase Inicial:&nbsp;</strong></td>
							<td>		
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
											and ACcodigo = $ACcodigo,numeric$ 
											order by ACcodigodescClasI, ACdescripcionClasI"
										Desplegar="ACcodigodescClasI, ACdescripcionClasI"
										Etiquetas="Código,Descripción"
										filtrar_por="ACcodigodesc, ACdescripcion"
										Formatos="S,S"
										Align="left,left"
										Asignar="ACidI, ACcodigodescClasI,ACdescripcionClasI,GATdescripcionI"
										Asignarformatos="I,S,S,S"
										debug="false"
										left="250"
										top="150"
										width="500"
										height="300"
										tabindex="2" />
								</td>
							</tr>
							<tr>
								<td colspan="2">&nbsp;</td>
								<td colspan="2">&nbsp;</td>
								<td align="right" width="10%" nowrap="nowrap"><strong>Clase Final:&nbsp;</strong></td>
								<td>
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
											and ACcodigo = $ACcodigo,numeric$ 
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
						</table>
					</fieldset>
					<table align="right" width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td nowrap="nowrap" align="center" colspan="7">
							<strong>Centro Funcional Origen:&nbsp;</strong>&nbsp;
						</td>
					</tr>
					<tr>
						<td nowrap align="right" colspan="5">
							<strong>Desde:&nbsp;&nbsp;</strong>
						</td>
						<td colspan="2">
							<cf_conlis
								campos="CFidinicio, CFcodigoinicio, CFdescripcioninicio"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Centros Funcionales"
								tabla="CFuncional"
								columnas="CFid as CFidinicio, CFcodigo as CFcodigoinicio, CFdescripcion as CFdescripcioninicio"
								filtro="Ecodigo=#SESSION.ECODIGO# order by CFcodigo"
								desplegar="CFcodigoinicio, CFdescripcioninicio"
								filtrar_por="CFcodigo, CFdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="CFidinicio, CFcodigoinicio, CFdescripcioninicio"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Centros Funcionales --"
								tabindex="1">					
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" align="right" colspan="5">
							<strong>Hasta:&nbsp;&nbsp;</strong>
						</td>
						<td>
							<cf_conlis
								campos="CFidfinal, CFcodigofinal, CFdescripcionfinal"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Centros Funcionales"
								tabla="CFuncional"
								columnas="CFid as CFidfinal, CFcodigo as CFcodigofinal, CFdescripcion as CFdescripcionfinal"
								filtro="Ecodigo=#SESSION.ECODIGO# order by CFcodigo"
								desplegar="CFcodigofinal, CFdescripcionfinal"
								filtrar_por="CFcodigo, CFdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="CFidfinal, CFcodigofinal, CFdescripcionfinal"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Centros Funcionales --"
								tabindex="1">
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" align="center" colspan="7"><strong>Centro Funcional Destino:&nbsp;</strong></td>
					</tr>
					<tr>
						<td nowrap="nowrap" align="right" colspan="5"><strong>Desde:&nbsp;&nbsp;</strong></td>
						<td>
							<cf_conlis
								campos="CFDidinicio, CFDcodigoinicio, CFDdescripcioninicio"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Centros Funcionales"
								tabla="CFuncional"
								columnas="CFid as CFDidinicio, CFcodigo as CFDcodigoinicio, CFdescripcion as CFDdescripcioninicio"
								filtro="Ecodigo=#SESSION.ECODIGO# order by CFcodigo"
								desplegar="CFDcodigoinicio, CFDdescripcioninicio"
								filtrar_por="CFcodigo, CFdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="CFDidinicio, CFDcodigoinicio, CFDdescripcioninicio"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Centros Funcionales --"
								tabindex="1">				
						</td>
					</tr>
					<tr>
						<td nowrap="nowrap" align="right" colspan="5"><strong>Hasta:&nbsp;&nbsp;</strong></td>
						<td>
							<cf_conlis
								campos="CFDidfinal, CFDcodigofinal, CFDdescripcionfinal"
								desplegables="N,S,S"
								modificables="S,S,N"
								size="0,10,40"
								title="Lista de Centros Funcionales"
								tabla="CFuncional"
								columnas="CFid as CFDidfinal, CFcodigo as CFDcodigofinal, CFdescripcion as CFDdescripcionfinal"
								filtro="Ecodigo=#SESSION.ECODIGO# order by CFcodigo"
								desplegar="CFDcodigofinal, CFDdescripcionfinal"
								filtrar_por="CFcodigo, CFdescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="CFDidfinal, CFDcodigofinal, CFDdescripcionfinal"
								asignarformatos="S, S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Centros Funcionales --"
								tabindex="1">
						</td>
					</tr>
					<tr>
						<td align="right" width="25%" nowrap colspan="5"><strong>Fecha Desde:&nbsp;&nbsp;</strong></td>
						<td colspan="5"><cf_sifcalendario name="Fechadesde" tabindex="1"></td>
					</tr>
					<tr>
						<td align="right" colspan="5"><strong>Fecha Hasta:&nbsp;&nbsp;</strong></td>
						<td colspan="5"><cf_sifcalendario name="Fechahasta" tabindex="1"></td>
					</tr>
					<tr>
						<td align="right" colspan="5"><strong>Placa:&nbsp;&nbsp;</strong></td>
						<td colspan="5"><cf_sifactivo tabindex="1" permitir_retirados="true"></td>
					</tr>
					<tr>
						<td align="left" colspan="7"><strong>Exportar a archivo</strong>
						<input type="checkbox" name="exportar" value="ok" /></td>
					</tr>
					<tr>
						<td colspan="7">
							<cf_botones values="Filtrar,Limpiar" tabindex="1">
						</td>
					</tr>
				</table>
			</table>
		</table>
			
			
</form>

<script language="javascript" type="text/javascript">
	function Cambia(){
	document.form1.TipoBus[0].checked=true;//a la hora de actualizar deja habilitado unicamente la opcion que esta por default
		//alert("Filtró por rango de Categoría");
		setReadOnly_form1_codigodesde(false);//para inhabilitar un conlis 
		setReadOnly_form1_codigohasta(false);
		document.form1.codigodesde.value='';//limpia los datos seleccionados una vez que cambio de opción.
        document.form1.codigohasta.value='';
		setReadOnly_form1_ACidI(true);
		setReadOnly_form1_ACidF(true);
		setReadOnly_form1_ACcodigo(true);			
		limpiaACidI();
        limpiaACidF();
	    limpiaACcodigo();               
        //limpiacodigodesde();//para limpiar un conlis
		//limpiacodigohasta();
		limpiacodigodesde();//para limpiar un conlis
		limpiacodigohasta();
		
	}
	
	function Cambia2(){
		//alert("Filtró por rango de Clases a partir de una Categoría seleccionada");
		setReadOnly_form1_codigodesde(true);
		setReadOnly_form1_codigohasta(true);
		setReadOnly_form1_ACidI(false);
		setReadOnly_form1_ACidF(false);
		setReadOnly_form1_ACcodigo(false);
	    limpiacodigodesde();//para limpiar un conlis
        limpiacodigohasta();

	}
	Cambia()
</script>



	


