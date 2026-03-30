
<!--- 
	Creado por Mauricio Esquivel / Gustavo Fonseca H.
		Fecha: 03-10-2005
		Motivo: Creación del reporte de Estado de Cuenta del Socio de Negocios por Clasificación x Mes.(solo en CxC).
	Modificado por: Gustavo Fonseca H.
		Fecha: 24-11-2005
		Motivo: Se agrega el check de "enviar correo". Se hace que al chequerlo se escoja el formato PDF y si lo desChequea escoja el formato Flashpaper.
	Modificado por Gustavo Fonseca H.
		Fecha: 6-12-2005.
		Motivo: Se agrega check para que permita ordenar los estados de cuenta por número de Reclamo.
--->


<cf_templateheader title="SIF - Cuentas por Cobrar">

<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Estado&nbsp;de&nbsp;Cuenta&nbsp;del&nbsp;Socio&nbsp;de&nbsp;Negocios&nbsp;por&nbsp;Clasificaci&oacute;n y Mes'>
<script language="JavaScript" src="../../js/fechas.js"></script>
<cfset fnParametros()>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfoutput>

<form name="form1" action="Estado_Cuenta_ClasiFxMes_SQL.cfm" method="get">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>Datos del Reporte</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><strong>Clasificaci&oacute;n:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%"><strong>Valor&nbsp;Clasificaci&oacute;n&nbsp;desde:&nbsp;</strong></td>
					<td width="10%"><strong>Valor&nbsp;Clasificaci&oacute;n&nbsp;hasta:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid1" name="SNCDvalor1" desc="SNCDdescripcion1" tabindex="1"></td>					
					<td width="10%" nowrap><cf_sifSNClasfValores SNCEid ="1" form="form1" id="SNCDid2" name="SNCDvalor2" desc="SNCDdescripcion2" tabindex="1"></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Socio&nbsp;de&nbsp;Negocios&nbsp;Inicial:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>Socio&nbsp;de&nbsp;Negocios&nbsp;Final:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifsociosnegocios2  tabindex="1"></td>
					 <td align="left"><cf_sifsociosnegocios2 form ="form1" frame="frsocios2" SNcodigo="SNcodigob2" SNnombre="SNnombreb2" SNnumero="SNnumerob2"  tabindex="1"></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Mes:</strong></td>
					<td nowrap align="left" width="10%"><strong>A&ntilde;o:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left">
						<select name="mes"  tabindex="1">
							<cfloop query="rsMeses">
								<option value="#VSvalor#">#VSdesc#</option>
							</cfloop>	
						</select>
					</td>
					<td nowrap align="left">
						<select name="periodo"  tabindex="1">
							<cfloop query="rsPer">
								<option value="#Speriodo#">#Speriodo#</option>
							</cfloop>
						</select>
					</td>
					<td colspan="4">&nbsp;</td>					
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td style="text-decoration:underline"><strong>Orden&nbsp;de&nbsp;la&nbsp;Consulta:</strong></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Clasificaci&oacute;n:&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion id="SNCEid_Orden" name="SNCEcodigo_Orden" desc="SNCEdescripcion_orden" form="form1" tabindex="1"></td>
					<td><strong>Orientaci&oacute;n</strong></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%">
						<input name="chk_cod_Direccion" id="chk_cod_Direccion" value="1" type="checkbox" tabindex="1" onclick="Verificar();" checked>
						<label for="chk_cod_Direccion" style="font-style:normal;font-weight:normal">&nbsp;<strong>Imprimir&nbsp;por&nbsp;C&oacute;digo&nbsp;de&nbsp;Direcci&oacute;n</strong></label></td>
				  <td nowrap style="width:10% ">
				  	<label for="ord1" style="font-style:normal;font-weight:normal"><strong>Vertical:</strong></label> <input name="Orientacion" id="ord1" type="radio" value="1" checked tabindex="1">	
					<label for="ord2" style="font-style:normal;font-weight:normal"><strong>Horizontal:</strong></label> <input name="Orientacion" id="ord2" type="radio" value="2" tabindex="1"></td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%" nowrap><strong>Cobrador:</strong></td>
					<input type="hidden" name="DEidCobrador" value="" >
					<input type="hidden" name="Cobrador" value="Todos" >
				</tr>
				<tr id="sinSNDirecciones">
					<td>&nbsp;</td>	
					 <td width="10%" nowrap><!--- --->
					 <cf_conlis 
							<!--- -----El título se muestra en el Conlis y en el onMouseOver de la Imágen que levanta el Conlis. --->
							title="Lista de Cobradores"
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
							etiquetas="Identificaci&oacute;n, Cobrador"
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
							title="Lista de Cobradores por Direcci&oacute;n"
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
							etiquetas="Identificaci&oacute;n, Cobrador"
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
					<td><input name="chk_email" id="chk_email" type="checkbox" value="1" tabindex="1" 
							onclick="javascript: AsignarFormato(2,1);"> 
							<label for="chk_email" style="font-style:normal;font-weight:normal"><strong>Enviar&nbsp;Correo</strong></label></td>
					<td align="left" width="10%"><strong>Formato:&nbsp;</strong>
					
					<select name="Formato" id="Formato" tabindex="1">
						<option value="1">FLASHPAPER</option>
						<option value="2">PDF</option>
						<option value="3">EXCEL</option>
					</select>
					</td>
					<td colspan="1">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				  <td valign="middle">
				  	<input name="ordenado" id="ordenado" type="checkbox" value="1" tabindex="1"/>
					<label for="ordenado" style="font-style:normal;font-weight:normal"><strong>Ordenar por Reclamo</strong></label></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
				  <td valign="middle">
				  	<input name="SaldoCero" id="SaldoCero" type="checkbox" value="1" tabindex="1" checked/>
					<label for="SaldoCero" style="font-style:normal;font-weight:normal"><strong>Incluir Estados de Cuenta sin saldos</strong></label></td>
					<td>&nbsp;</td>
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr><td colspan="4"><cf_botones values="Generar" names="Generar" tabindex="1"></td></tr>
				<tr><td>&nbsp;<input name="TipoReporte" type="hidden" value="1"></td></tr>
			</table>
			</fieldset>			
		</td>	
	</tr>
</table>	
</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>

<cf_qforms>
            <cf_qformsRequiredField name="SNcodigo" description="Socio de Negocios Inicial">
			<cf_qformsRequiredField name="SNcodigob2" description="Socio de Negocios Final">
			<cf_qformsRequiredField name="SNCEid" description="Clasificación">
			<cf_qformsRequiredField name="SNCDid1" description="Valor Clasificación desde">
			<cf_qformsRequiredField name="SNCDid2" description="Valor Clasificación Hasta">
			<cf_qformsRequiredField name="SNCEid_Orden" description="Orden de impresión por Clasificación">
</cf_qforms>
<script language="javascript" type="text/javascript">
	function AsignarFormato(tipo,nuevo){
		//Esto selecciona en el campo del combo 
		if(document.form1.chk_email.checked){
			if (document.form1.Formato.options) {
				for (var i = 0; i < document.form1.Formato.options.length; i++) {
					if (document.form1.Formato.options[i].value == tipo) {
						document.form1.Formato.options.selectedIndex = i;
					}
				}
			}
		
		}
		
		if(!document.form1.chk_email.checked){
			if (document.form1.Formato.options) {
				for (var i = 0; i < document.form1.Formato.options.length; i++) {
					if (document.form1.Formato.options[i].value == nuevo) {
						document.form1.Formato.options.selectedIndex = i;
					}
				}
			}
		}	
		
	}

//-->	
</script>

<script language="javascript" type="text/javascript">
	function funcGenerar(){
		lvarjsPeriodo = eval(document.form1.periodo.value * 100) + eval(document.form1.mes.value);
		if (lvarjsPeriodo >= <cfoutput>#LvarPeriodoActual * 100 + LvarmesActual#</cfoutput>) {
			alert('El mes seleccionado no esta cerrado.  Debe seleccionar un mes a imprimir menor que <cfoutput>#LvarmesActual# - #LvarPeriodoActual#</cfoutput> ');
			return false;
		}
	}

	function funcVisualizar(){
		document.getElementById("sinSNDirecciones").style.display='none'; 
		document.getElementById("conSNDirecciones").style.display=''
		document.form1.DEidCobrador_SNegocios1.value='';
		document.form1.DEidentificacion1.value='';
		document.form1.Cobrador1.value='';
		document.form1.DEidCobrador_SNdirecciones2.value='';
		document.form1.DEidentificacion2.value='';
		document.form1.Cobrador2.value='';
		document.form1.DEidCobrador.value='';
		
	}
	function funcDesVisualizar(){
		document.getElementById("conSNDirecciones").style.display='none'; 
		document.getElementById("sinSNDirecciones").style.display=''
		document.form1.DEidCobrador_SNegocios1.value='';
		document.form1.DEidentificacion1.value='';
		document.form1.Cobrador1.value='';
		document.form1.DEidCobrador_SNdirecciones2.value='';
		document.form1.DEidentificacion2.value='';
		document.form1.Cobrador2.value='';
		document.form1.DEidCobrador.value='';
	}

	function Verificar(){
		if (document.getElementById("chk_cod_Direccion").checked == true){
			funcVisualizar();
			}
		else{
			funcDesVisualizar();		
		}
	}
	Verificar();
</script>

<cffunction name="fnParametros" access="private" output="no" returntype="any">
    <cfquery name="rsPer" datasource="#Session.DSN#">
        select Speriodo, count(1) as Cantidad
        from SNSaldosIniciales
        where Ecodigo = #Session.Ecodigo#
        group by Speriodo
        order by Speriodo desc
    </cfquery>
	<cfif rsPer.recordCount  EQ 0>
		<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('No existen Saldos Iniciales para ningún Periodo!')#" >
	</cfif>
    <cfquery name="rsMeses" datasource="sifControl">
        select <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl"> as VSvalor, b.VSdesc 
        from Idiomas a
        	inner join VSidioma b 
            on a.Iid = b.Iid
        where a.Icodigo = '#Session.Idioma#'
            and b.VSgrupo = 1
        order by <cf_dbfunction args="b.VSvalor" name="to_number" datasource="sifControl">
    </cfquery>
    <cfquery name="rsMesActual" datasource="#Session.DSN#">
        select Pvalor
        from Parametros
        where Ecodigo = #session.ecodigo#
        and Pcodigo = 60
    </cfquery>
    <cfset LvarMesActual = rsMesActual.Pvalor>
    <cfquery name="rsPeriodoActual" datasource="#Session.DSN#">
		select Pvalor
        from Parametros
        where Ecodigo = #session.ecodigo#
        and Pcodigo = 50    
     </cfquery>
     <cfset LvarPeriodoActual = rsPeriodoActual.Pvalor>
</cffunction>
