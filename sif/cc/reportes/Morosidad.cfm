<!---
	Modificado por: Ana Villavicencio
	Fecha: 06 de marzo del 2006
	Motivo: Agregar el filtro de Clasificación por dirección.
			Agregar el parámetro del Titulo del reporte segun el filtro de Clasificación por dirección.
			Se creo un nuevo reporte .cfr para cuando se selecciona por direccion.

	Modificado por Gustavo Fonseca Hernández.
		Fecha: 9-8-2005.
		Motivo: Se da tratamiento para que tome en cuenta los socios de negocios corporativos(Ecodigo is null)
 --->

<cf_templateheader title="SIF - Cuentas por Cobrar">

<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Morosidad'>
<cfinclude template="../../portlets/pNavegacion.cfm">
<cfinclude template="../../Utiles/sifConcat.cfm">
<form name="form1" action="Morosidad.cfm" method="get">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend>Datos del Reporte</legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3">
						<input name="TClasif" id="TClasif1" type="radio" value="0" checked tabindex="1" onclick="funcDesVisualizar();">
						<label for="TClasif1" style="font-style:normal; font-variant:normal;">Clasificaci&oacute;n de Socios</label>
						<input name="TClasif" id="TClasif2" type="radio" value="1" tabindex="1" onclick="funcVisualizar();">
						<label for="TClasif2"  style="font-style:normal; font-variant:normal;">Clasificaci&oacute;n de Direcci&oacute;n de Socios</label>
					</td>
				</tr>
				<tr><td colspan="4">&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>Clasificaci&oacute;n&nbsp;</strong></td>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" nowrap width="10%"><cf_sifSNClasificacion form="form1" tabindex="1"></td>
					<td colspan="2">&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td width="10%"><strong>Valor&nbsp;Clasificaci&oacute;n&nbsp;desde:&nbsp;</strong></td>
					<td width="10%"><strong>Valor&nbsp;Clasificaci&oacute;n&nbsp;hasta:&nbsp;</strong></td>
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
					<td nowrap align="left" width="10%"><strong>Socio&nbsp;de&nbsp;Negocios&nbsp;Inicial:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>Socio&nbsp;de&nbsp;Negocios&nbsp;Final:&nbsp;</strong></td>
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
					<td nowrap align="left" width="10%"><strong>Oficina&nbsp;Inicial:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>Oficina&nbsp;Final:&nbsp;</strong></td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifoficinas tabindex="1"></td>
					 <td align="left"><cf_sifoficinas Ocodigo="Ocodigo2" Oficodigo="Oficodigo2" Odescripcion="Odescripcion2" tabindex="1"></td>
					<td>&nbsp;</td>
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
					<td nowrap align="left" width="10%"><strong>Fecha&nbsp;de&nbsp;Corte:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>D&iacute;as&nbsp;Vencidos:&nbsp;</strong></td>
					<td>&nbsp;</td>
				</tr>

				<tr>
					<td>&nbsp;</td>
					<td nowrap align="left"><cf_sifcalendario name="fechaDes" value="#LSDateFormat(now(),'dd/mm/yyyy')#"  tabindex="1"></td>
					<td nowrap align="left"><input name="Dvencimiento" value="" type="text" tabindex="1"> </td>
					<td>&nbsp;</td>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left" width="10%"><strong>Formato:&nbsp;</strong>

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
</form>
<cf_web_portlet_end>
<cf_templatefooter>
<cfif isdefined("url.Generar")>
<!--- <cf_dump var="#form#"> --->
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
		  <cfset filtro = " h.Ecodigo=#session.Ecodigo# ">
	<cfelse>
		  <cfset filtro = " h.Ecodigo is null ">
	</cfif>

	<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="5001">
		select  <cf_dbfunction name="datediff" args="a.Dvencimiento, '#lsdateformat(url.fechaDes,'dd/mm/yyyy')#'"> as Dias_Vencido,
		 b.CCTcodigo, a.Ddocumento, a.Dfecha, a.Dvencimiento, a.Dtotal,   a.Dsaldo,
		 <cfif isdefined('url.TClasif') and url.TClasif EQ 1>
		coalesce(ds.SNnombre,c.SNnombre) as SNnombre,
		coalesce(ds.SNDcodigo,c.SNnumero) as SNnumero,
		<cfelse>
		c.SNnombre,
		c.SNnumero,
		</cfif>
		 c.SNidentificacion,
		 d.Mcodigo, d.Mnombre, e.Edescripcion,
		case b.CCTtipo when  'D' then +(a.Dsaldo)else -(a.Dsaldo)end as Dsaldodc,
		h.SNCEdescripcion, h.SNCEid, h.SNCEcodigo,  g.SNCDid, g.SNCDvalor, g.SNCDdescripcion
		from Documentos a
			inner join CCTransacciones b
				on  b.Ecodigo = a.Ecodigo
				and b.CCTcodigo = a.CCTcodigo
			inner join SNegocios c
				on c.Ecodigo = a.Ecodigo
				and c.SNcodigo = a.SNcodigo
			<cfif isdefined('url.TClasif') and url.TClasif EQ 0>
				inner join SNClasificacionSN f
					on  f.SNid = c.SNid
				<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
				   inner join DatosEmpleado gg
						on gg.DEid = c.DEidCobrador<!--- --->
			    </cfif>
			<cfelse>
				inner join SNDirecciones ds
				   on ds.SNid = c.SNid
				  and ds.Ecodigo = c.Ecodigo
				  and ds.SNcodigo = c.SNcodigo
				  and ds.id_direccion = a.id_direccionFact

				inner join SNClasificacionSND f
				   on f.SNid = ds.SNid
				  and f.id_direccion = ds.id_direccion
				  <cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
					  inner join DatosEmpleado gg
						  on gg.DEid = ds.DEidCobrador <!------>
				  </cfif>
			</cfif>

			inner join SNClasificacionD g
				on g.SNCDid = f.SNCDid
			inner join SNClasificacionE h
				on h.SNCEid = g.SNCEid
			inner join Monedas d
				on d.Ecodigo = a.Ecodigo
				and d.Mcodigo = a.Mcodigo
			inner join Empresas e
				on e.Ecodigo = a.Ecodigo

		where #filtro#
			and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and h.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">

			and <cf_dbfunction name="datediff" args="a.Dvencimiento, '#lsdateformat(url.fechaDes,'dd/mm/yyyy')#'"> >= <cfqueryparam cfsqltype="cf_sql_integer" value="#Dvencimiento#">
			and b.CCTtipo = 'D'
			and Dsaldo > 0
			<cfif isdefined("url.DEidCobrador") and len(trim(url.DEidCobrador))>
				and gg.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.DEidCobrador#">
			</cfif>
			<!--- Clasificación --->
			<cfif isdefined("url.SNCEid") and len(trim(url.SNCEid))>
				and h.SNCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNCEid#">
			</cfif>
			<!--- Valores de Clasificación --->
		<cfif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1)) and isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
			<cfif url.SNCDvalor1 gt url.SNCDvalor2> <!--- si el primero es mayor que el segundo. --->
				and g.SNCDvalor between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor2#">
								 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor1#">
			<cfelse>
				and g.SNCDvalor between <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor1#">
								 and <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor2#">
			</cfif>
		<cfelseif isdefined("url.SNCDvalor1") and len(trim(url.SNCDvalor1))>
			and g.SNCDvalor >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNCDvalor1#">
		<cfelseif isdefined("url.SNCDvalor2") and len(trim(url.SNCDvalor2))>
			and rtrim(ltrim(g.SNCDvalor)) <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(url.SNCDvalor2)#">
		</cfif>
		<!--- Socio de negocios --->
		<cfif isdefined("url.SNnumero") and len(trim(url.SNnumero)) and isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
			<cfif url.SNnumero gt SNnumerob2><!--- si el primero es mayor que el segundo. --->
					and c.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
										and <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
			<cfelse>
					and c.SNnumero between <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
										and <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
			</cfif>
		<cfelseif isdefined("url.SNnumero") and len(trim(url.SNnumero))>
			and c.SNnumero >= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumero#">
		<cfelseif isdefined("url.SNnumerob2") and len(trim(url.SNnumerob2))>
			and c.SNnumero <= <cfqueryparam cfsqltype="cf_sql_char" value="#url.SNnumerob2#">
		</cfif>
		order by d.Mcodigo, h.SNCEid, g.SNCDid
	</cfquery>

	<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
		<cf_errorCode	code = "50196" msg = "Se han generado mas de 5000 registros para este reporte.">
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

	<!--- Busca nombre del Socio de Negocios 1 --->
	<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo))>
		<cfquery name="rsSNcodigo" datasource="#session.DSN#">
			select SNnombre
			from SNegocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigo#">
			and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	</cfif>

	<!--- Busca nombre del Socio de Negocios 2 --->
	<cfif isdefined("url.SNcodigob2") and len(trim(url.SNcodigob2))>
		<cfquery name="rsSNcodigob2" datasource="#session.DSN#">
			select SNnombre
			from SNegocios
			where SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.SNcodigob2#">
			and Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
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
		fileName = "cc.reportes.Morosidad"/>
	<cfelse>
	  <cfreport format="#formatos#" template= "Morosidad.cfr" query="rsReporte">
		<cfif isdefined("rsSNCEid") and rsSNCEid.recordcount gt 0>
			<cfreportparam name="SNCEdescripcion" value="#rsSNCEid.SNCEdescripcion#">
		</cfif>

		<cfif isdefined("rsSNCDid1") and rsSNCDid1.recordcount gt 0>
			<cfreportparam name="SNCDdescripcion1" value="#rsSNCDid1.SNCDdescripcion#">
		</cfif>

		<cfif isdefined("rsSNCDid2") and rsSNCDid2.recordcount gt 0>
			<cfreportparam name="SNCDdescripcion2" value="#rsSNCDid2.SNCDdescripcion#">
		</cfif>

		<cfif isdefined("url.Cobrador") and len(trim(url.Cobrador)) eq 0>
			<cfset url.cobrador = 'Todos'>
		</cfif>
		<cfreportparam name="Cobrador" value="#url.Cobrador#">

		<cfif isdefined("rsSNcodigo") and rsSNcodigo.recordcount gt 0>
			<cfreportparam name="SNcodigo" value="#rsSNcodigo.SNnombre#">
		</cfif>
		<cfif isdefined("rsSNcodigob2") and rsSNcodigob2.recordcount gt 0>
			<cfreportparam name="SNcodigob2" value="#rsSNcodigob2.SNnombre#">
		</cfif>

		<cfif isdefined("url.Dvencimiento") and len(trim(url.Dvencimiento))>
			<cfreportparam name="Dvencimiento" value="#url.Dvencimiento#">
		</cfif>
		<cfif isdefined("url.fechaDes") and len(trim(url.fechaDes))>
			<cfreportparam name="fechaDes" value="#url.fechaDes#">
		</cfif>
		<cfif isdefined("url.TClasif") and url.TClasif EQ 0> --->
			<cfreportparam name="Titulo" value="Morosidad (Socios de Negocios)">
		<cfelse>
			<cfreportparam name="Titulo" value="Morosidad (Dirección de Socios de Negocios)">
		</cfif>
		<cfreportparam name="TClasif" value="#url.TClasif#">
	</cfreport>
	</cfif>
</cfif>
<cf_qforms form ="form1">
<script language="javascript" type="text/javascript">
<!-- //
	objForm.SNCEid.required = true;
	objForm.SNCEid.description="Clasificación";

	objForm.Dvencimiento.required = true;
	objForm.Dvencimiento.description="Días Vencidos";

//-->
</script>


 <script language="javascript" type="text/javascript">
	function funcVisualizar(){
		document.getElementById("sinSNDirecciones").style.display= 'none';
		document.getElementById("conSNDirecciones").style.display =''
	}
	function funcDesVisualizar(){
		document.getElementById("conSNDirecciones").style.display = 'none';
		document.getElementById("sinSNDirecciones").style.display = ''
	}

</script>

