<cf_templateheader title="Reporte de inconsistencias">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Reporte de inconsistencias">
<!---Querys--->
<cfif not isdefined("form.btnConsultar")>
		<cfquery name="rsPeriodo" datasource="#session.dsn#">
			select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
			from Parametros
			where Ecodigo = #session.Ecodigo#
				and Pcodigo = 50
				and Mcodigo = 'GN'
		</cfquery>

		<cfset rsPeriodos = QueryNew("Pvalor")>
		<cfset temp = QueryAddRow(rsPeriodos,8)>
		<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-7,1)>
		<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor-1,7)>
		<cfset temp = QuerySetCell(rsPeriodos,"Pvalor",rsPeriodo.Pvalor,8)>
		
		<cfquery name="rsMes" datasource="#session.dsn#">
			select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
			from Parametros
			where Ecodigo = #session.Ecodigo#
			and Pcodigo = 60
			and Mcodigo = 'GN'
		</cfquery>
		<cfquery name="rsMeses" datasource="sifControl">
			select <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor"> as Pvalor, b.VSdesc as Pdescripcion
			from Idiomas a
				inner join VSidioma b 
					on a.Iid = b.Iid
			where a.Icodigo = '#Session.Idioma#'
			  and b.VSgrupo = 1
			order by <cf_dbfunction name="to_number" datasource="sifControl" args="b.VSvalor">
		</cfquery>
	
		<cfquery name="rsOficinas" datasource="#session.dsn#">
			select Ocodigo,Oficodigo,Odescripcion 
			from  Oficinas
			where Ecodigo = #session.Ecodigo#
			order by Oficodigo
		</cfquery>
		
		<cfquery name="rsPermiteValesDeMejora" datasource="#session.dsn#">
			select Pvalor
			from Parametros
			where Pcodigo=1300
		</cfquery>
</cfif>

<!---  AREA DE PINTADO  --->
<form action="inconsistencias_form.cfm" method="post" name="form1">
	<cfoutput>				  
		<table  border="0" width="100%">				
			<tr>
				<td align="left" nowrap="nowrap" colspan="3">
					<fieldset><legend>Tipos de Inconsistencias</legend>
						<table width="100%" border="0">
							<tr>
							  <td width="18%"><input tabindex="1" type="checkbox" name="dep" />No depreciados</td>
							  <td width="21%"><input tabindex="1" type="checkbox" name="mej" />Mejora negativa</td>
							  <td width="22%"><input tabindex="1" type="checkbox" name="adq" />Adquisición 0</td>
							  <td width="25%"><input tabindex="1" type="checkbox" name="finc" />Fechas Inconsistentes</td>
							  <td width="14%"><input tabindex="1" type="checkbox" name="vales" />Varios Vales</td>
							</tr>
							<tr>
								<td><input tabindex="1" type="checkbox" name="rep" />Placas Repetidas</td>
								<td width="21%"><input tabindex="1" type="checkbox" name="val" />Saldos en revaluación</td>
								<td><input tabindex="1" type="checkbox" name="tran" <cfif #rsPermiteValesDeMejora.Pvalor# NEQ 1>disabled="disabled" </cfif>/>Vales por Mejora</td>
								<td><input tabindex="1" type="checkbox" name="vu"  onclick="javascript: if (this.checked) funcAlert()"/>VU diferente a categoria/clase</td>
								<td><input tabindex="1" type="checkbox" name="sinvale" />Sin Vale</td>
							</tr>
						</table>
					</fieldset>
				</td>
			</tr>					 
			<tr>
				<td align="left" nowrap="nowrap" >
					<fieldset><legend><input checked="checked" type="radio" name="TipoBus" id="TipoBus" value="1" onclick="Cambia()"/>Filtro Por Categoria</legend>
					<table width="50%" border="0" align="center">
						<tr>
							<td align="right"><strong>Inicial:&nbsp;</strong></td>
							<td>							
								<cf_conlis
								campos="codigodesde, ACinicio, ACdescripciondesde"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Categor&iacute;as"
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
								tabindex="1"
								MaxRowsQuery="2000">	
							</td>		
						</tr>
						<tr>
							<td align="right"><strong>Final:&nbsp;</strong></td>
							<td>
								<cf_conlis
								campos="codigohasta, AChasta, ACdescripcionhasta"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de Categor&iacute;as"
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
								tabindex="1"
								MaxRowsQuery="2000">			
							</td>
						</tr>
					</table>
				</fieldset>
				</td>
			</tr>
			<tr>
				<td align="left" nowrap="nowrap" >
					<fieldset>
						<legend>
							<input type="radio" name="TipoBus" value="2" onclick="Cambia2()" 
							<cfif isdefined("url.TipoBus") and len(trim(url.TipoBus)) and url.TipoBus eq 2>checked="checked"</cfif>/>Filtro Por Categoria/Clase
						</legend>
						<table  align="center" width="50%">
							<tr>
								<td><strong>Categoria</strong></td>
								<td>
									<cf_conlis
									campos="ACcodigo, ACcodigodesc, ACdescripcion"
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
									tabindex="1"
									MaxRowsQuery="2000">
								</td>
							</tr>	
							<tr>
								<td align="right" width="10%" nowrap="nowrap"><strong>Inicial:&nbsp;</strong></td>
								<td>		
									<cfset ValuesArray=ArrayNew(1)>
									<cf_conlis
									Campos="ACidI, ACcodigodescClasI, ACdescripcionClasI"
									Desplegables="N,S,S"
									Modificables="N,S,N"
									Size="0,10,40"
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
									funcion="asignarClaseFinal"
									debug="false"
									left="250"
									top="150"
									width="500"
									height="300"
									tabindex="2"
									MaxRowsQuery="2000" />
								</td>
							</tr>
				    		<tr>
								<td align="right" width="10%" nowrap="nowrap"><strong>Final:&nbsp;</strong></td>
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
								tabindex="2"
								MaxRowsQuery="2000"/>		
							</td>
						</tr>
						</table>
					</fieldset>
				</td>
			</tr>
			<tr>
				<td>
					<fieldset>
						<table  align="center">
							<tr>
								<td><div align="right"><strong>Oficina inicial:</strong></div></td>
					  			<td nowrap="nowrap">
									<select name="OficinaIni" tabindex="2">
										<option value="" selected></option>
										<cfloop query="rsOficinas">
											<option value="#Oficodigo#">#Oficodigo#-#Odescripcion#</option>
										</cfloop>
									</select>
									<strong>Final</strong>
									<select name="OficinaFin" tabindex="2">
										<option value="" selected></option>
										<cfloop query="rsOficinas">
											<option value="#Oficodigo#">#Oficodigo#-#Odescripcion#</option>
										</cfloop>
									</select>
								</td>
				  			</tr>
						  	<tr>
								<td><div align="right"><strong>Perido:</strong></div></td>
								<td nowrap="nowrap">
									<cf_periodos tabindex="1">
									<strong>Mes:</strong>
									<select name="Mes" tabindex="2">
										<cfloop query="rsMeses">
											<option value="#Pvalor#">#Pdescripcion#</option>
										</cfloop>
									</select>
							   </td>
						    </tr>
						</table>
					</fieldset>
				</td>
			</tr>
			<tr><td align="center"><cf_botones values="Consultar,Limpiar"  tabindex="3"></td></tr>
			</table>
			</cfoutput>
		</form>
	<cf_web_portlet_end>
	<cf_templatefooter>
	<script language="javascript" type="text/javascript">
	function Cambia(){
		//alert("Filtró por rango de Categoría");
		document.form1.TipoBus[0].checked=true;
		setReadOnly_form1_codigodesde(false);//para inhabilitar un conlis 
		setReadOnly_form1_codigohasta(false);
		document.form1.codigodesde.value='';
		document.form1.codigohasta.value='';
		setReadOnly_form1_ACidI(true);
		setReadOnly_form1_ACidF(true);
		setReadOnly_form1_ACcodigo(true);	
		limpiaACidI();
		limpiaACidF();
		limpiaACcodigo();		
		//limpiacodigodesde();//para limpiar un conlis
//		limpiacodigohasta();
		
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
<script language="javascript1.2">
	function funcAlert(){
	
	alert('Debe indicar una categoria o clase');
	
	}
</script>
	<cf_qforms form = 'form1'>
