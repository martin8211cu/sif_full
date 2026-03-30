<!---
	Modificado por: Ana Villavicencio
	Fecha: 03 de marzo del 2006
	Motivo: Agregar el filtro de Clasificación por dirección.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','SIF - Cuentas por Cobrar')>
<cfset TIT_SalXClas 	= t.Translate('TIT_SalXClas','Saldos&nbsp;por&nbsp;Clasificaci&oacute;n')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Datos del Reporte')>
<cfset LB_ClasSoc 		= t.Translate('LB_ClasSoc','Clasificaci&oacute;n de Socios')>
<cfset LB_ClasDirSoc 	= t.Translate('LB_ClasDirSoc','Clasificaci&oacute;n de Direcci&oacute;n de Socio')>
<cfset LB_Consulta 		= t.Translate('LB_Consulta','Consulta')>
<cfset LB_Resumido 		= t.Translate('LB_Consulta','Resumido')>
<cfset LB_Detallado 	= t.Translate('LB_Detallado','Detallado por Documento')>
<cfset LB_Clasif 		= t.Translate('LB_Clasif','Clasificaci&oacute;n')>
<cfset LB_ClasifSA 		= t.Translate('LB_Clasif','Clasificación')>
<cfset LB_ClasifDesde	= t.Translate('LB_ClasifDesde','Valor Clasificación desde')>
<cfset LB_ClasifHasta	= t.Translate('LB_ClasifHasta','Valor Clasificación hasta')>
<cfset LB_SNIni			= t.Translate('LB_SNIni','Socio de Negocios Inicial')>
<cfset LB_SNFin			= t.Translate('LB_SNFin','Socio de Negocios Final')>
<cfset LB_OficIni		= t.Translate('LB_OficIni','Oficina Inicial')>
<cfset LB_OficFin		= t.Translate('LB_OficFin','Oficina Final')>
<cfset LB_Cobrador 		= t.Translate('LB_Cobrador','Cobrador')>
<cfset LB_LstCobrador 	= t.Translate('LB_LstCobrador','Lista de Cobradores')>
<cfset LB_Todos 		= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificaci&amp;oacute;n','/sif/generales.xml')>
<cfset LB_LstCobrxDir 	= t.Translate('LB_LstCobrxDir','Lista de Cobradores por Direcci&oacute;n')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>

<cf_templateheader title="#LB_TituloH#">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_SalXClas#'>
<cfinclude template="../../Utiles/sifConcat.cfm">

<form name="form1" method="get" action="SaldosxClasificacionRes.cfm">
<cfoutput>
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>#LB_DatosReporte#</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3">
						<input name="TClasif" id="TClasif1" type="radio" value="0" checked tabindex="1" onclick="funcDesVisualizar();">
						<label for="TClasif1" style="font-style:normal; font-variant:normal;">#LB_ClasSoc#</label>
						<input name="TClasif" id="TClasif2" type="radio" value="1" tabindex="1" onclick="funcVisualizar();">
						<label for="TClasif2"  style="font-style:normal; font-variant:normal;">#LB_ClasDirSoc#</label>
					</td>
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap width="10%" colspan="3"><strong>#LB_Consulta#:&nbsp;</strong>
						<input type="radio" name="tipoResumen" id="tipoR1" value="1" checked onClick="this.form.action = 'SaldosxClasificacionRes.cfm';" tabindex="1">
						<label for="tipoR1" style="font-style:normal; font-variant:normal;">#LB_Resumido#&nbsp;</label>
						&nbsp;&nbsp;&nbsp;
						<input type="radio" name="tipoResumen"  id="tipoR2" value="2" onClick="this.form.action = 'SaldosxClasificacionDet.cfm';" tabindex="1">
						<label for="tipoR2" style="font-style:normal; font-variant:normal;"> #LB_Detallado#</label>
					</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_Clasif#&nbsp;</strong></td>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1"></td>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%"><strong>#LB_ClasifDesde#:&nbsp;</strong></td>
					<td width="10%"><strong>#LB_ClasifHasta#:&nbsp;</strong></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid1" name="SNCDvalor1" desc="SNCDdescripcion1" tabindex="1"></td>
					<td width="10%" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid2" name="SNCDvalor2" desc="SNCDdescripcion2" tabindex="1"></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_SNIni#:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_SNFin#:&nbsp;</strong></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifsociosnegocios2 ClientesAmbos="SI" tabindex="1"></td>
					 <td align="left"><cf_sifsociosnegocios2 ClientesAmbos="SI" form ="form1" frame="frsocios2" SNcodigo="SNcodigob2" SNnombre="SNnombreb2" SNnumero="SNnumerob2" tabindex="1"></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_OficIni#:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_OficFin#:&nbsp;</strong></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifoficinas  tabindex="1"></td>
					 <td align="left"><cf_sifoficinas Ocodigo="Ocodigo2" Oficodigo="Oficodigo2" Odescripcion="Odescripcion2" tabindex="1"></td>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%" nowrap><strong>#LB_Cobrador#:</strong></td>
					<input type="hidden" name="DEidCobrador" value="" >
					<input type="hidden" name="Cobrador" value="#LB_Todos#" >
				</tr>
				<tr id="sinSNDirecciones">
					<td>&nbsp;</td>
					 <td width="10%" nowrap><!--- --->
					 <cf_conlis
							<!--- -----El título se muestra en el Conlis y en el onMouseOver de la Imágen que levanta el Conlis. --->
							title="#LB_LstCobrador#"
							<!--- -----Campos que van a ser pintados por el tag en la pantalla donde se coloque. --->
							campos = "DEidCobrador_SNegocios1, DEidentificacion1, Cobrador1"
							<!--- -----Indica cuales de los campos que van a ser pintados en la panalla van a ser visibles (TextBox) y cuales No (Hidden). --->
							desplegables = "N,S,S"
							<!--- -----Indica cuales campos van a ser modificables y cuales no (readonly), cuando hay campos modificables, se presenta la funcionalidad busqueda al salir del campo en que se digitó, mejor conocido como TAG, y cuando no hay campos modificables, únicames se muestra una lista de selección, mejor conocido como conlis, cuando hay funcionalidad TAG, también hay conlis. Los campos modificables deben ser desplegables, sino son desplegables, se omite funcionalidad de modificable. --->
							modificables = "N,S,N"
							<!--- -----Tamaño de los objetos desplegables, el tamaño asignado a los objetos no desplegables se omite. --->
							size = "0,20,30"
							<!--- -----Valores iniciales de los campos pintados por el tag. --->
							<!--- valuesarray="#Lvar_valuesArray#"  --->
							<!--- -----Tabla para el query, como se observa puede llevar una sintaxis compleja que involucre joins, subqueries, parámetros que cambian dinámicamente en el form donde reside el tag(ver uso de sintaxis $campo,tipo$), variables de coldfusion que serán asignadas en el servidor cuando se este generando el html, que será retornado al cliente. --->
							tabla=" SNegocios a
									inner join DatosEmpleado d
										on d.DEid = a.DEidCobrador"
										<!--- and tc1.Hfecha <=  $EMfecha,date$ --->
							<!--- -----Columnas a retornar por el query, como se obserba, al igual que la tabla puede llevar una sintaxis compleja. --->
							columnas="distinct
										a.DEidCobrador,
										a.DEidCobrador as DEidCobrador_SNegocios,
										d.DEid as DEid_DatosEmpleado,
										d.NTIcodigo,
										d.DEidentificacion as DEidentificacion1,
										d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ', ' #_Cat# d.DEnombre as Cobrador,
										d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ', ' #_Cat# d.DEnombre as Cobrador1"
							<!--- -----filtro del query, , como se obserba, al igual que la tabla puede llevar una sintaxis compleja. --->
							filtro="a.Ecodigo  =#session.Ecodigo#"
							filtrar_por ="DEidentificacion, d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ' ' #_Cat# d.DEnombre"
							<!--- -----campos del query a desplegar la lista del Conlis. --->
							desplegar="DEidentificacion1, Cobrador1"
							tabindex="1"
							<!--- -----etiquetas de la lista del Conlis. --->
							etiquetas="#LB_Identificacion#, #LB_Cobrador#"
							<!--- -----formatos de los campos a desplegar en la lista del Conlis. --->
							formatos="S,S"
							<!--- -----alineamiento de los campos de la lista del Conlis. --->
							align="left,left"
							<!--- -----cortes de la lista del Conlis --->
							<!--- cortes="Mnombre" --->
							<!--- -----campos a asignar cuando se seleccione un item del Conlis, como se observa se pueden asignar mas campos de los pintados por el tag, esto implica que estos campos deben existir en la pantalla donde se pinta el tag. --->
							asignar="DEidCobrador, Cobrador, DEidentificacion1, Cobrador1"
							<!--- -----formatos de los valores a asignar a los campos cuando se seleccione un item del Conlis. --->
							asignarformatos="S, S,S,S">
					 </td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr id="conSNDirecciones" style="display:none">
					<td>&nbsp;</td>
					 <td width="10%" nowrap><!--- --->
					 <cf_conlis
							<!--- -----El título se muestra en el Conlis y en el onMouseOver de la Imágen que levanta el Conlis. --->
							title="#LB_LstCobrxDir#"
							<!--- -----Campos que van a ser pintados por el tag en la pantalla donde se coloque. --->
							campos = "DEidCobrador_SNdirecciones2, DEidentificacion2, Cobrador2"
							<!--- -----Indica cuales de los campos que van a ser pintados en la panalla van a ser visibles (TextBox) y cuales No (Hidden). --->
							desplegables = "N,S,S"
							<!--- -----Indica cuales campos van a ser modificables y cuales no (readonly), cuando hay campos modificables, se presenta la funcionalidad busqueda al salir del campo en que se digitó, mejor conocido como TAG, y cuando no hay campos modificables, únicames se muestra una lista de selección, mejor conocido como conlis, cuando hay funcionalidad TAG, también hay conlis. Los campos modificables deben ser desplegables, sino son desplegables, se omite funcionalidad de modificable. --->
							modificables = "N,S,N"
							<!--- -----Tamaño de los objetos desplegables, el tamaño asignado a los objetos no desplegables se omite. --->
							size = "0,20,30"
							<!--- -----Valores iniciales de los campos pintados por el tag. --->
							<!--- valuesarray="#Lvar_valuesArray#"  --->
							<!--- -----Tabla para el query, como se observa puede llevar una sintaxis compleja que involucre joins, subqueries, parámetros que cambian dinámicamente en el form donde reside el tag(ver uso de sintaxis $campo,tipo$), variables de coldfusion que serán asignadas en el servidor cuando se este generando el html, que será retornado al cliente. --->
							tabla=" SNDirecciones a
									inner join DatosEmpleado d
										on d.DEid = a.DEidCobrador"
							<!--- -----Columnas a retornar por el query, como se obserba, al igual que la tabla puede llevar una sintaxis compleja. --->
							columnas="	distinct
										a.DEidCobrador,
										a.DEidCobrador as DEidCobrador_SNdirecciones,
										d.DEid as DEid_DatosEmpleado ,
										a.id_direccion,
										d.NTIcodigo,
										d.DEidentificacion as DEidentificacion2,
										d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ', ' #_Cat# d.DEnombre as Cobrador,
										d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ', ' #_Cat# d.DEnombre as Cobrador2"
							<!--- -----filtro del query, , como se obserba, al igual que la tabla puede llevar una sintaxis compleja. --->
							filtro="a.Ecodigo  =#session.Ecodigo#"
							filtrar_por ="DEidentificacion, d.DEapellido1 #_Cat# ' ' #_Cat# d.DEapellido2 #_Cat# ' ' #_Cat# d.DEnombre"
							<!--- -----campos del query a desplegar la lista del Conlis. --->
							desplegar="DEidentificacion2, Cobrador2"
							tabindex="1"
							<!--- -----etiquetas de la lista del Conlis. --->
							etiquetas="#LB_Identificacion#, #LB_Cobrador#"
							<!--- -----formatos de los campos a desplegar en la lista del Conlis. --->
							formatos="S,S"
							<!--- -----alineamiento de los campos de la lista del Conlis. --->
							align="left,left"
							<!--- -----cortes de la lista del Conlis --->
							<!--- cortes="Mnombre" --->
							<!--- -----campos a asignar cuando se seleccione un item del Conlis, como se observa se pueden asignar mas campos de los pintados por el tag, esto implica que estos campos deben existir en la pantalla donde se pinta el tag. --->
							asignar="DEidCobrador, Cobrador, DEidentificacion2, Cobrador2"
							<!--- -----formatos de los valores a asignar a los campos cuando se seleccione un item del Conlis. --->
							asignarformatos="S,S,S,S">
					 </td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong>#LB_Formato#&nbsp;</strong>
					<select name="Formato" id="Formato" tabindex="1">
						<option value="1">FLASHPAPER</option>
						<option value="2">PDF</option>
					</select>
					</td>
					<td colspan="2">&nbsp;</td>
				</tr>

				<tr><td colspan="4">&nbsp;</td></tr>
				<tr><td colspan="4"><cf_botones values="Generar" names="Generar" tabindex="1"></td></tr>
			</table>
			</fieldset>
		</td>
	</tr>
</table>
</cfoutput>
</form>
<cf_web_portlet_end>
<cf_qforms form ="form1">

<cfoutput>
<script language="javascript" type="text/javascript">
<!-- //
	objForm.SNCEid.required = true;
	objForm.SNCEid.description="#LB_ClasifSA#";

//-->
</script>
<cf_templatefooter>
<script language="javascript" type="text/javascript">
	function funcVisualizar(){
		document.getElementById("sinSNDirecciones").style.display = 'none';
		document.getElementById("conSNDirecciones").style.display = ''
	}
	function funcDesVisualizar(){
		document.getElementById("conSNDirecciones").style.display = 'none';
		document.getElementById("sinSNDirecciones").style.display = ''
	}

</script>
</cfoutput>

