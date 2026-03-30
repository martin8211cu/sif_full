<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 9-5-2006.
		Motivo: Se incorpora la posibilidad de filtrar por el cobrador de cada dirección.

	Modificado por: Ana Villavicencio
	Fecha: 03 de marzo del 2006
	Motivo: Agregar el filtro de Clasificación por dirección.

	Modificado por Gustavo Fonseca Hernández.
		Fecha: 11-10-2005.
		Motivo: Se arregla los filtros de valores de clasificación que antes se hacían por SNCDid (estaba mal) y quedó con SNCDvalor.
		También se arregló para que filtrara los socios de negocios por empresa.		

	Modificado por Gustavo Fonseca Hernández.
		Fecha: 9-8-2005.
		Motivo: Se da tratamiento para que tome en cuenta los socios de negocios corporativos(Ecodigo is null)
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','SIF - Cuentas por Cobrar')>
<cfset TIT_SocXClas 	= t.Translate('TIT_SocXClas','Socios de Negocios por Clasificación')>
<cfset TIT_SocXClasXD 	= t.Translate('TIT_SocXClasXD','Clasificación de Socios de Negocios por Dirección')>
<cfset LB_DatosReporte 	= t.Translate('LB_DatosReporte','Datos del Reporte')>
<cfset LB_ClasSoc 		= t.Translate('LB_ClasSoc','Clasificaci&oacute;n de Socios')>
<cfset LB_ClasDirSoc 	= t.Translate('LB_ClasDirSoc','Clasificaci&oacute;n de Direcci&oacute;n de Socio')>
<cfset LB_Clasif 		= t.Translate('LB_Clasif','Clasificaci&oacute;n')>
<cfset LB_ClasifSA 		= t.Translate('LB_Clasif','Clasificación')>
<cfset LB_ClasifDesde	= t.Translate('LB_ClasifDesde','Valor Clasificación desde')>
<cfset LB_ClasifHasta	= t.Translate('LB_ClasifHasta','Valor Clasificación hasta')>
<cfset LB_Cobrador 	= t.Translate('LB_Cobrador','Cobrador')>
<cfset LB_LstCobrador 	= t.Translate('LB_LstCobrador','Lista de Cobradores')>
<cfset LB_Todos 		= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Identificacion = t.Translate('LB_Identificacion','Identificaci&amp;oacute;n','/sif/generales.xml')>
<cfset LB_LstCobrxDir 	= t.Translate('LB_LstCobrxDir','Lista de Cobradores por Direcci&oacute;n')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset LB_Estado 	= t.Translate('LB_Estado','Estado','/sif/generales.xml')>
<cfset LB_Resumido 		= t.Translate('LB_Consulta','Resumido')>
<cfset LB_Detallado 	= t.Translate('LB_Detallado','Detallado por Documento')>
<cfset LB_CorpLoc 	= t.Translate('LB_CorpLoc','Corporativo/Local')>
<cfset LB_Corporativo 	= t.Translate('LB_Corporativo','Corporativo')>
<cfset LB_Local 	= t.Translate('LB_Local','Local')>
<cfset LB_Hora 	= t.Translate('LB_Hora','Hora')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Cobrador 	= t.Translate('LB_Cobrador','Cobrador')>

<cfset LB_Estado = t.Translate('LB_Estado','Estado','/sif/generales.xml')>
<cfset LB_Valor = t.Translate('LB_Valor','Valor','/sif/generales.xml')>
<cfset LB_SaldoTot 	= t.Translate('LB_SaldoTot','Saldo Total')>
<cfset MSG_Codigo 	= t.Translate('MSG_Codigo','Código','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>
<cfset LB_Totales 	= t.Translate('LB_Totales','Totales')>
<cfset LB_TotMon 	= t.Translate('LB_TotMon','Total Moneda')>
<cfset LB_Criterio 	= t.Translate('LB_Criterio','Criterio de Seleción')>
<cfset BTN_Clasificacion = t.Translate('BTN_Clasificacion','Clasificación','/sif/generales.xml')>
<cfset LB_Socio_Ini = t.Translate('LB_Socio_Ini','Socio de Negocios Inicial')>
<cfset LB_Socio_Fin = t.Translate('LB_Socio_Fin','Socio de Negocios Final')>
<cfset LB_OficIni		= t.Translate('LB_OficIni','Oficina Inicial')>
<cfset LB_OficFin		= t.Translate('LB_OficFin','Oficina Final')>

<cf_templateheader title="#LB_TituloH#">

<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_SocXClas#'>


<cfquery name="rsValores" datasource="#session.dsn#">
	select b.SNCEid, b.SNCDid, b.SNCDdescripcion 
	from SNClasificacionE a, SNClasificacionD b
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	and b.SNCEid = a.SNCEid
	ORDER BY a.SNCEcodigo, a.SNCEdescripcion
</cfquery>

<cfquery name="rsEstados" datasource="#session.DSN#">
	select ESNdescripcion, ESNid, ESNcodigo
	from EstadoSNegocios
	where Ecodigo = #session.Ecodigo#
</cfquery>
 

<cfinclude template="../../Utiles/sifConcat.cfm">
<form name="form1" action="SociosxClasificacion.cfm" method="get">

<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend><cfoutput>#LB_DatosReporte#</cfoutput></legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
                <cfoutput>
					<td>&nbsp;</td>
					<td colspan="3">
						<input name="TClasif" id="TClasif1" type="radio" value="0" checked tabindex="1" onclick="funcDesVisualizar();">
						<label for="TClasif1" style="font-style:normal; font-variant:normal;">#LB_ClasSoc#</label>
						<input name="TClasif" id="TClasif2" type="radio" value="1" tabindex="1" onclick="funcVisualizar();">
						<label for="TClasif2"  style="font-style:normal; font-variant:normal;">#LB_ClasDirSoc#</label>
					</td>
				</cfoutput>	
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
                <cfoutput>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_Clasif#&nbsp;</strong></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1"></td>
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%"><strong>#LB_ClasifDesde#:&nbsp;</strong></td>
					<td width="10%"><strong>#LB_ClasifHasta#:&nbsp;</strong></td>
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
				</cfoutput>
				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong><cfoutput>&nbsp;&nbsp;&nbsp;#LB_Estado#:&nbsp;</cfoutput></strong>
					 <select name="ESNid" id="ESNid" tabindex="1">
						<cfoutput query="rsEstados"> 
						  <option value="#ESNid#">#ESNdescripcion#</option>
						</cfoutput> 
					  </select>
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
                <cfoutput>
				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong>#LB_Formato#&nbsp;</strong>
					<select name="Formato" id="Formato" tabindex="1">
						<option value="1">FLASHPAPER</option>
						<option value="2">PDF</option>
					</select>
					</td>
					<td colspan="3">&nbsp;</td>
				</tr>
                </cfoutput>
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">
					<cf_botones values="Generar" names="Generar"  tabindex="1">
					</td>
				</tr>
			</table>
			</fieldset>
		</td>	
	</tr>
</table>
	
</form>
<cf_web_portlet_end>			

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

<cfif isdefined("url.Generar")>
<!--- <cfdump var="#form#">
<cf_dump var="#url#"> --->
	<cfquery name="rsConsultaCorp" datasource="asp">
		select *
		from CuentaEmpresarial
		where Ecorporativa is not null
		  and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#" >
	</cfquery>
	<cfif isdefined('session.Ecodigo') and 
		  isdefined('session.Ecodigocorp') and
		  session.Ecodigo NEQ session.Ecodigocorp and
		  rsConsultaCorp.RecordCount GT 0>
		  <cfset filtro = " a.Ecodigo=#session.Ecodigo# ">
	<cfelse>
		  <cfset filtro = " a.Ecodigo is null ">								  
	</cfif>
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
		select d.SNid, a.SNCEid, a.SNCEcodigo, a.SNCEdescripcion,  b.SNCDid, rtrim(ltrim(b.SNCDvalor)) as SNCDvalor, b.SNCDdescripcion, 
		c.Edescripcion, e.ESNid, f.ESNdescripcion, case when e.SNidCorporativo > 0  then '#LB_Corporativo#' else '#LB_Local#'  end as Tipo_Socio
		<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
			,e.SNnumero as Codigo,
			e.DEidCobrador,
			e.SNnombre as Nombre
		<cfelse>
			,ds.DEidCobrador,
			d.id_direccion,
			coalesce(ds.SNDcodigo, e.SNnumero) as Codigo,
			coalesce(ds.SNnombre, e.SNnombre) as Nombre
		</cfif>
		from SNClasificacionE a  
		<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
		inner join SNClasificacionD b 
			inner join SNClasificacionSND d 
				inner join SNegocios e 
					inner join EstadoSNegocios f 
					   on f.ESNid = e.ESNid 
					  and f.Ecodigo = e.Ecodigo 
				   on e.SNid = d.SNid 
			   on d.SNCDid = b.SNCDid 
		   on b.SNCEid = a.SNCEid 
		   <cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
			   inner join DatosEmpleado g
					on g.DEid = e.DEidCobrador<!--- --->
		   </cfif>
		<cfelse>	
			inner join SNClasificacionD b 
				inner join SNClasificacionSND d 
					inner join SNDirecciones ds
						inner join SNegocios e 
							inner join EstadoSNegocios f 
							   on f.ESNid = e.ESNid 
							  and f.Ecodigo = e.Ecodigo 
						   on e.SNid = ds.SNid 
						  and e.Ecodigo = ds.Ecodigo
						  and e.SNcodigo = ds.SNcodigo
					   on ds.SNid = d.SNid
					  and ds.id_direccion = d.id_direccion
				   on d.SNCDid = b.SNCDid 
			   on b.SNCEid = a.SNCEid 
		   	<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
				inner join DatosEmpleado g
					on g.DEid = ds.DEidCobrador <!------>
			</cfif>
		</cfif>
		inner join Empresas c 
		   on c.Ecodigo = e.Ecodigo 

		where #filtro#
			and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
				and g.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEidCobrador#">
			</cfif>
			 <cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
			and a.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
			 </cfif>
			 <!--- Valores de Clasificación --->
			<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
				<cfif url.SNCDvalor1 gt url.SNCDvalor2> <!--- si el primero es mayor que el segundo. --->
					and b.SNCDvalor between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor2#">
									 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor1#">
				<cfelse>
					and b.SNCDvalor between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor1#"> 
									 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor2#">
				</cfif>
			<cfelseif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
				and b.SNCDvalor >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor1#"> 
			<cfelseif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
				and rtrim(ltrim(b.SNCDvalor)) <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#"> 
			</cfif>
			<cfif isdefined("url.ESNid") and len(trim(url.ESNid))>
				and f.ESNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESNid#">
			</cfif>
		order by b.SNCDid, a.SNCEcodigo, b.SNCDvalor
	</cfquery>
    
    
	<!--- <cf_dump var="#rsReporte#"> --->
	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
		<cfset MSG_RegLim = t.Translate('MSG_RegLim','Se han generado mas de 5000 registros para este reporte.')>
		<cf_errorCode	code = "50196" msg = "#MSG_RegLim#">
		<cfabort>
	</cfif>	

	<!--- Busca descripción del Encabezado de la Clasificación --->
	<cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
		<cfquery name="rsSNCEid" datasource="#session.DSN#">
			select SNCEdescripcion 
			from SNClasificacionE
			where SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
			and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>

	<!--- Busca descripción del Detalle 1 de la Clasificación --->
	<cfif isdefined("url.SNCDid1") and len(trim(url.SNCDid1))>
		<cfquery name="rsSNCDid1" datasource="#session.DSN#">
			select SNCDdescripcion 
			from SNClasificacionD
			where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid1#">
		</cfquery>
	</cfif>
	
	<!--- Busca descripción del Detalle 2 de la Clasificación --->
	<cfif isdefined("url.SNCDid2") and len(trim(url.SNCDid2))>
		<cfquery name="rsSNCDid2" datasource="#session.DSN#">
			select SNCDdescripcion 
			from SNClasificacionD
			where SNCDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCDid2#">
		</cfquery>
	</cfif>
	
	
	<!--- Busca descripción del Estado del Socio de Negocios --->
	<cfif isdefined("url.ESNid") and len(trim(url.ESNid))>
		<cfquery name="rsESNid" datasource="#session.DSN#">
			select ESNdescripcion 
			from EstadoSNegocios
			where ESNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ESNid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>

	<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
		<cfset formatos = "flashpaper">
	<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
		<cfset formatos = "pdf">
	</cfif>
	  <cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cc.reportes.SNegociosxCategorias"/>
	<cfelse>
	  <cfreport format="#formatos#" template= "SNegociosxCategorias.cfr" query="rsReporte">
		<cfif isdefined("rsSNCEid") and rsSNCEid.recordcount gt 0>
			<cfreportparam name="SNCEdescripcion" value="#rsSNCEid.SNCEdescripcion#">
		</cfif>
		
		<cfif isdefined("rsSNCDid1") and rsSNCDid1.recordcount gt 0>
			<cfreportparam name="SNCDdescripcion1" value="#rsSNCDid1.SNCDdescripcion#">
		</cfif>
		<cfif isdefined("url.Cobrador") and len(trim(url.Cobrador)) eq 0>
			<cfset url.cobrador = 'Todos'>
		</cfif>
		<cfreportparam name="Cobrador" value="#url.Cobrador#">
		
		<cfif isdefined("rsSNCDid2") and rsSNCDid2.recordcount gt 0>
			<cfreportparam name="SNCDdescripcion2" value="#rsSNCDid2.SNCDdescripcion#">
		</cfif>
		
		<cfif isdefined("rsESNid") and rsESNid.recordcount gt 0>
			<cfreportparam name="ESNdescripcion" value="#rsESNid.ESNdescripcion#">
		</cfif>
		<cfif isdefined("url.TClasif") and url.TClasif EQ 0>
			<cfreportparam name="Titulo" value="#TIT_SocXClas#">
		<cfelse>
			<cfreportparam name="Titulo" value="#TIT_SocXClasXD#">
		</cfif>
		<cfreportparam name="TClasif" value="#url.TClasif#">
        <cfreportparam name="LB_Fecha" 		value="#LB_Fecha#">
        <cfreportparam name="LB_Hora" 		value="#LB_Hora#">
        <cfreportparam name="LB_Cobrador" 	value="#LB_Cobrador#">
        <cfreportparam name="LB_ClasifSA" 	value="#LB_ClasifSA#">
        <cfreportparam name="LB_Valor" 		value="#LB_Valor#">
        <cfreportparam name="LB_SaldoTot" 	value="#LB_SaldoTot#">
        <cfreportparam name="MSG_Codigo" 	value="#MSG_Codigo#">
        <cfreportparam name="LB_SocioNegocio" 	value="#LB_SocioNegocio#">
        <cfreportparam name="LB_Totales" 	value="#LB_Totales#">
        <cfreportparam name="LB_TotMon" 	value="#LB_TotMon#">
        <cfreportparam name="LB_Criterio" 	value="#LB_Criterio#">
        <cfreportparam name="BTN_Clasificacion" 	value="#BTN_Clasificacion#">
        <cfreportparam name="LB_ClasifDesde" 	value="#LB_ClasifDesde#">
        <cfreportparam name="LB_ClasifHasta" 	value="#LB_ClasifHasta#">
        <cfreportparam name="LB_Socio_Ini" 	value="#LB_Socio_Ini#">
        <cfreportparam name="LB_Socio_Fin" 	value="#LB_Socio_Fin#">
        <cfreportparam name="LB_OficIni" 	value="#LB_OficIni#">
        <cfreportparam name="LB_OficFin" 	value="#LB_OficFin#">
        <cfreportparam name="LB_Estado" 	value="#LB_Estado#">
        <cfreportparam name="LB_CorpLoc" 	value="#LB_CorpLoc#">
	</cfreport>
	</cfif>
</cfif>

<cf_qforms form ="form1">
<cfoutput>
<script language="javascript" type="text/javascript">
<!-- //
	objForm.SNCEcodigo.required = true;
	objForm.SNCEcodigo.description="#LB_ClasifSA#";
	
//-->	
</script>
</cfoutput>
 


