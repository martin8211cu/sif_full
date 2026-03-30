<!---
	Modificado por: Ana Villavicencio
	Fecha: 09 de marzo del 2006
	Motivo: Agregar el filtro de Clasificación por dirección.

	Creado  por Ana Villavicencio
	Fecha: 09 de diciembre del 2005
	Motivo: Nuevo reporte de Socios sin Clasificar.
--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset TIT_RepSalsClas	= t.Translate('TIT_RepSalsClas','Cuentas por Cobrar - Reporte de Socios sin Clasificaci&oacute;n')>
<cfset TIT_SocsClas		= t.Translate('TIT_SocsClas','Socios sin Clasificaci&oacute;n')>
<cfset LB_DatosRep 		= t.Translate('LB_DatosRep','Datos del Reporte')>
<cfset TIT_DirSocsClas	= t.Translate('TIT_DirSocsClas','Direcci&oacute;n de Socios sin Clasificaci&oacute;n')>
<cfset LB_ClasifIni	= t.Translate('LB_ClasifIni','Clasificación inicial')>
<cfset LB_ClasifFin	= t.Translate('LB_ClasifFin','Clasificación Final')>
<cfset LB_Socio_Ini = t.Translate('LB_Socio_Ini','Socio de Negocios Inicial')>
<cfset LB_Socio_Fin = t.Translate('LB_Socio_Fin','Socio de Negocios Final')>
<cfset LB_Cobrador 	= t.Translate('LB_Cobrador','Cobrador')>
<cfset LB_Todos 		= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_LstCobrador 	= t.Translate('LB_LstCobrador','Lista de Cobradores')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificaci&amp;oacute;n','/sif/generales.xml')>
<cfset LB_LstCobrxDir 	= t.Translate('LB_LstCobrxDir','Lista de Cobradores por Direcci&oacute;n')>
<cfset LB_Ambos 		= t.Translate('LB_Ambos','Ambos')>
<cfset LB_Clientes 		= t.Translate('LB_Clientes','Clientes')>
<cfset LB_Proveedores 	= t.Translate('LB_Proveedores','Proveedores')>
<cfset LB_ClasEmpr 		= t.Translate('LB_ClasEmpr','Clasificaciones solo de la empresa')>


<cfoutput>
<cf_templateheader title="#TIT_RepSalsClas#">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_SocsClas#'>
<cfinclude template="../../Utiles/sifConcat.cfm">
<form name="form1" method="post" action="SociosSinClasificarResCC.cfm">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>#LB_DatosRep#</legend>
			<table  width="100%" cellpadding="2" cellspacing="2" border="0">
				<tr><td colspan="2">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3">
						<input name="TClasif" id="TClasif1" type="radio" value="0" checked tabindex="1" onclick="funcDesVisualizar();">
						<label for="TClasif1" style="font-style:normal; font-variant:normal;">#TIT_SocsClas#</label>
						<input name="TClasif" id="TClasif2" type="radio" value="1" tabindex="1" onclick="funcVisualizar();">
						<label for="TClasif2"  style="font-style:normal; font-variant:normal;">#TIT_DirSocsClas#</label>
					</td>
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_ClasifIni#</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_ClasifFin#</strong></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1" name="Clasif1" id="SNCEid1" desc="SNCEdescripcion1"></td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1" name="Clasif2"  id="SNCEid2" desc="SNCEdescripcion2"></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_Socio_Ini#:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_Socio_Fin#:&nbsp;</strong></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifsociosnegocios2 ClientesAmbos="SI" tabindex="1"></td>
					 <td align="left"><cf_sifsociosnegocios2 ClientesAmbos="SI" form ="form1" frame="frsocios2" SNcodigo="SNcodigob2" SNnombre="SNnombreb2" SNnumero="SNnumerob2" tabindex="1"></td>
					<td colspan="3">&nbsp;</td>
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
					<td colspan="2">
					<input name="SC" type="radio" value="SC" id="SC" tabindex="1" checked onClick="javascript: document.form1.SP.checked=false;document.form1.SA.checked=false;"><label for="SC"><strong>#LB_Clientes#</strong></label>
					<input name="SP" type="radio" value="SP" id="SP" tabindex="1" onClick="javascript: document.form1.SC.checked=false;document.form1.SA.checked=false;"><label for="SP"><strong>#LB_Proveedores#</strong></label>
					<input name="SA" type="radio" value="SA" id="SA" tabindex="1" onClick="javascript: document.form1.SP.checked=false;document.form1.SC.checked=false;"><label for="SA"><strong>#LB_Ambos#</strong></label></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3"><input name="Empresa" type="checkbox" value="Empresa" id="Empresa" tabindex="1"><label for="Empresa"><strong>#LB_ClasEmpr#</strong></label></td>
				</tr>
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">
					<cf_botones values="Generar" names="Generar" tabindex="1">
					</td>
				</tr>
			</table>
			</fieldset>
		</td>
	</tr>
</table>
</form>
<cf_web_portlet_end>
<cf_qforms form ="form1">
<script language="javascript" type="text/javascript">
<!-- //
	objForm.Clasif1.required = true;
	objForm.Clasif1.description="#LB_ClasifIni#";
	objForm.Clasif2.required = true;
	objForm.Clasif2.description="#LB_ClasifFin#";

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