
<cf_dbtemp name="RHTMPReportes" returnvariable="temp_reportes">
	<cf_dbtempcol name="codigo" 	 type="varchar(255)" 	mandatory="yes">
	<cf_dbtempcol name="descripcion" type="varchar(255)"	mandatory="yes">
	<cf_dbtempcol name="ruta" 		 type="varchar(255)" 	mandatory="yes">
	<cf_dbtempcol name="nombre" 	 type="varchar(255)"	mandatory="yes">
	<cf_dbtempcol name="sistema"	 type="varchar(15)"		mandatory="yes">
	<cf_dbtempcol name="categoria"	 type="varchar(255)"	mandatory="yes">
	<cf_dbtempcol name="fecha"		 type="datetime"		mandatory="yes">
</cf_dbtemp>

<cfset rootdir = expandpath('')>
<cfset directorio = "#rootdir#/repUsuario">
<cfset directorio = replace(directorio, '\', '/', 'all') >

<cfdirectory action="list" directory="#directorio#" name="reportes">

<cfloop query="reportes">
	<cfif ucase(reportes.type) eq 'DIR' and listfind('RH,SIF',ucase(reportes.name)) >
		<cfset directorio = reportes.directory >
		<cfset subdirectorio = reportes.name >
		<cfdirectory action="list" directory="#directorio#/#subdirectorio#" name="listado">
		
		<cfloop query="listado">
			<cfquery name="datos" datasource="#session.DSN#">
				select RHRURcodigo as codigo, RHRURdescripcion as descripcion, RHRURsistema as sistema, RHRURfechaModificacion as fecha, RHRURcategoria as categoria
				from RHRUReportes
				where <!--- Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  and  --->  <!--- JCG  --->
				  upper(RHRURnombre) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ucase(listado.name)#">
				order by RHRURcodigo  
			</cfquery>
			<cfif datos.recordcount gt 0>
				<cfquery datasource="#session.DSN#">
					insert into #temp_reportes#(codigo, descripcion, ruta,nombre,sistema,categoria,fecha)
					values( <cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.codigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.descripcion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#directorio#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#listado.name#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#subdirectorio#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#datos.categoria#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#datos.fecha#"> )
				</cfquery>
			</cfif>
		</cfloop>
	</cfif>
</cfloop>

<cfquery name="datos" datasource="#session.DSN#">
	select codigo, descripcion, ruta, nombre as archivo, sistema, fecha, categoria
	from #temp_reportes#
	order by sistema, categoria, codigo
</cfquery>

<br>
<form name="form1" method="post" action="ejecutar-reporte-sql.cfm" >
	<cfoutput>
	<table width="98%" border="0" cellpadding="2" >
		<tr><td colspan="3">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<td><strong>#vProceso#</strong></td>
					<td align="right"><a href="/cfmx/repUsuario/instaladores/cf_reportbuilder_7_installer.rar"><table><tr><td>Bajar Report Builder 7</td><td><img border="0" src="/cfmx/rh/imagenes/download.gif" /></td></tr></table></a></td>
				</tr>
				<tr>
					<td><strong>#vListado#</strong></td>
					<td align="right"><a href="/cfmx/repUsuario/instaladores/cf_reportbuilder_8_installer.rar"><table><tr><td>Bajar Report Builder 8</td><td><img border="0" src="/cfmx/rh/imagenes/download.gif" /></td></tr></table></a></td>
				</tr>
			</table>
		</td></tr>
		<tr>
			<td colspan=3><hr></td>
		</tr>	
		<tr>
			<td width="1%" nowrap="nowrap"><strong>#vFormato#:&nbsp;</strong></td>
			<td>
				<select name="formato">
					<option value="PDF">PDF</option>
					<option value="FlashPaper">Flashpaper</option>
					<option value="Excel">Excel</option>
					<option value="RTF">RTF</option>
					<option value="HTML">HTML</option>
					<option value="XML">XML</option>
					<!---<option value="html">HTML</option>--->
				</select>
			</td>

			<td width="1%" nowrap="nowrap">
			<table border="0">
				<tr>
					<td width="99%" nowrap="nowrap" align=right><strong>Fecha Inicio:&nbsp;</strong></td>
					<cfset vfecha = LSDateFormat(now(), 'dd/mm/yyyy') >
					<td width="99%" nowrap="nowrap" align=right><cf_sifcalendario form="form1" name="desde" value="#vfecha#"></td>
					<td width="99%" nowrap="nowrap" align=right><strong>Fecha Final:&nbsp;</strong></td>
					<td width="99%" nowrap="nowrap" align=right><cf_sifcalendario form="form1" name="hasta" value="01/01/6100"></td>
				</tr>	
			</table>	
		</tr>
	</table>
	</cfoutput>

	<input type="hidden"	name="ruta" 		value="">
	<input type="hidden" 	name="directorio" 	value="">
	<input type="hidden" 	name="archivo" 		value="">

	
	<table width="98%%" align="center" cellpadding="2" cellspacing="0">
		<cfoutput>
		<tr class="tituloListas">
			<td>#vReporte#</td>
			<td>#vDescripcion#</td>
			<td>#vArchivo#</td>
			<td align="center">#vFecha#</td>
			<td>&nbsp;</td>
		</tr>
		</cfoutput>
		<cfoutput query="datos" group="sistema">
			<cfoutput group="categoria">
				<tr>
					<td colspan="7" bgcolor="##f5f5f5"><strong>#vSistema#: #datos.sistema# - #vcategoria#: <cfif datos.categoria eq 'estructura'>#vestructura#<cfelseif datos.categoria eq 'empleados'>#vEmpleados#<cfelseif datos.categoria eq 'nomina'>#vnomina#<cfelseif datos.categoria eq 'parametros'>#vparametros#</cfif></strong></td>
				</tr>
				<cfoutput>
					<tr>
						<td>#datos.codigo#</td>
						<td>#datos.descripcion#</td>
						<td>#datos.archivo#</td>
						<td align="center">#LSDateFormat(datos.fecha, 'dd/mm/yyyy')#  #LSTimeFormat(datos.fecha, 'hh:mm tt')#</td>
						<td align="center" title="#vEjecutar#"><a href="javascript: ejecutar('#datos.codigo#', '#JSStringFormat(datos.ruta)#','#datos.sistema#','#JSStringFormat(datos.archivo)#');"><img border="0" src="/cfmx/rh/imagenes/Bullet01.gif"></a></td>
						<!---<td align="center"><input type="submit" name="btnEjecutar" class="btnNormal" value="#vEjecutar#" onClick="javascript:return ejecutar('#datos.codigo#', '#JSStringFormat(datos.ruta)#','#datos.sistema#','#JSStringFormat(datos.archivo)#');"></td>--->
					</tr>
				</cfoutput>
			</cfoutput>
		</cfoutput>
		<cfif datos.recordcount eq 0>
			<tr><td colspan="5" align="center"><strong><cf_translate key="MSG_NoSeEncontraronRegistros" xmlfile="rh/generales.xml">No se encontraron registros</cf_translate></strong></td></tr>
		</cfif>
	</table>
</form>

<script language="javascript1.2" type="text/javascript">
	function ejecutar(codigo, ruta, directorio, archivo){
		if ( confirm('<cfoutput>#vFormatoSeguro#</cfoutput>') ){
			document.form1.ruta.value = ruta;
			document.form1.directorio.value = directorio;
			document.form1.archivo.value = archivo;
			document.form1.submit();
		}
	}
</script> 

