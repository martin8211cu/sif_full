<!---
	Reporte de Empleados Inactivos
	Ultima Modificación: 03/10/2006
	Modificado por Dorian Abarca Gómez
	Modificación Realizada: Se elimina 
	el uso del CFReports porque el archivo 
	cfr está dañado, y se solicitó en HTML.
 --->

<!--- 
	Parametros del Reporte:
	Requeridos:
		-Formato.
	Opcionales:
		-Centro Funcional.
		-Fecha.	
--->


<!--- 
	Se define valor por defecto para la fecha porque ya se auq venga o no
	se requiere para filtrar la consulta del reporte, si no viene a la 
	fecha del día.
 --->
<cfparam name="Url.CumpleHasta" default="#now()#">

<!--- 
	Se Consulta la información del Centro Funcional 
	recibido como Parámetro Cuando Viene.
--->
<cfif isdefined("Url.CFid") and len(trim(Url.CFid)) GT 0>
	<cfquery name="rsCFuncional" datasource="#session.DSN#">
		select CFid, CFcodigo, CFdescripcion
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.CFid#">
	</cfquery>
</cfif>

<!--- 
	Consulta los empleados que a una fecha dada, 
	en un centro funcional dado, están Inactivos.
	Pueden tener un nombramiento posterior a la 
	fecha, por lo tanto lo que se restringe es 
	que a la fecha dada no tenga Linea del Tiempo,
	y que a esa misma fecha ya han sido nombrados.
--->
<cfquery name="rsReporte" datasource="#session.DSN#">
	<!--- Obtiene la Identificacion, Nombre, Centro Funcional, y maaxima fecha hasta a la fecha dada, fecha considerada de cese o 
	algún otro motivo de inactivación del empleado. Por esto no se utiliza la fecha de DLFvigencia de la tabla DLaboralesEmpleado --->
	select	de.DEidentificacion
		, {fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )} as DEnombre
		, cf.CFid ,cf.CFcodigo, cf.CFdescripcion, 
		max(lt.LThasta) as LThasta
	<!--- Busca en la Tabla de Empleados y la La Linea Tiempo. --->
	from DatosEmpleado de
		inner join LineaTiempo lt
			<!--- Usa la Plaza para obtener el Centro Funcional porque el reporte corta por Centro Funcional --->
			inner join  RHPlazas rhp
				inner join CFuncional cf
				on rhp.CFid = cf.CFid
			on rhp.RHPid = lt.RHPid
			<!--- Aquii filtra el Centro Funcional --->
			<cfif isdefined ("Url.CFid")and len(trim(Url.CFid))>
				and rhp.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Url.CFid#">
			</cfif>
		on de.DEid = lt.DEid
		and lt.LThasta <=
			<!--- Aquii filtra la Fecha de Hasta --->
			<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Url.CumpleHasta)#">
	where de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<!--- Verifica que el empleado ya fue nombrado a la fecha que viene por 
		parámetro o a la fecha de hoy si no viene una fecha por parámetro. --->
		and exists (
			select 1
			from DLaboralesEmpleado dl
				inner join RHTipoAccion ta
					on ta.RHTid = dl.RHTid
					and ta.RHTcomportam = 1 <!--- Nombramiento --->
			where dl.DEid = de.DEid
				and dl.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Url.CumpleHasta)#">
		)
		<!--- Verifica que el empleado está inactivo a la fecha que viene por 
		parámetro o a la fecha de hoy si no viene una fecha por parámetro. --->
		and not exists (
			select 1
			from LineaTiempo lt2
			where lt2.DEid = de.DEid
				and <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Url.CumpleHasta)#"> 
				between lt2.LTdesde and lt2.LThasta
		)
	group by de.DEidentificacion
		, {fn concat({fn concat({fn concat({fn concat(de.DEapellido1 , ' ' )}, de.DEapellido2 )}, ' ' )}, de.DEnombre )}
		, cf.CFid ,cf.CFcodigo, cf.CFdescripcion
	order by 3, 6, 1 <!--- Centro Funcional, Fecha de Egreso, Identificacioon --->
</cfquery>

<cfif rsReporte.recordcount GT 3000>
	<br>
	<br>
	<cf_translate  key="LB_SeGeneroUnReporteMasGrandeDeLoPermitido">Se genero un reporte más grande de lo permitido.  Se abortó el proceso</cf_translate>
	<br>
	<br>
	<cfabort>
<cfelseif rsReporte.recordcount EQ 0>
	<br>
	<br>
	<cf_translate  key="LB_NoSeGeneroUnReporteSegunLosFiltrosDados">No se generó un reporte según los filtros dados. Por favor intente de nuevo.</cf_translate>
	<br>
	<br>
	<cfabort>
<cfelse>
	<cfdocument format="#url.formato#">
		<!--- Se define encabezado de cada página, el mismo será 
		utilizado 1 ves por cada página impresa. --->
		<cfdocumentitem type="header">
		<cfoutput>
			<table width="601" align="center" border="0" cellspacing="0" cellpadding="0" bgcolor="##E3EDEF">
			  <tr>
				<td width="20%" align="left" valign="top">&nbsp;</td>
				<td width="80%" align="center" style="color:##6188A5; font-size:16px; font-family:Arial, Helvetica, sans-serif; " valign="top">#session.Enombre#</td>
				<td width="20%" align="left" rowspan="2" valign="top">
					<table>
						<tr>
							<td width="50%" align="right" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  "><cf_translate  key="LB_Usuario">Usuario:</cf_translate></td>
							<td width="50%" align="right" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  ">#Session.Usuario#</td>
						</tr>
						<tr>
							<td align="right" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  "><cf_translate  key="LB_Fecha">Fecha:</cf_translate></td>
							<td align="right" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  ">#LSDateFormat(Now(),'dd/mm/yyyy')#</td>
						</tr>
						<tr>
							<td align="right" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  ">&nbsp;</td>
							<td align="right" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  ">#cfdocument.currentpagenumber# - #cfdocument.totalpagecount#</td>
						</tr>
					</table>
				</td>
			  </tr>
			  <tr>
				<td align="left" valign="top">&nbsp;</td>
				<td align="center" style="font-size:14px; font-family:Arial, Helvetica, sans-serif; " valign="top"><cf_translate  key="LB_titulo">Empleados Inactivos</cf_translate></td>
				<td align="left" valign="top">&nbsp;</td>
			  </tr>
			</table>
			<table width="601" align="center" border="0" cellspacing="0" cellpadding="0"  bgcolor="##E3EDEF">
			  <tr>
			  	<td width="15%" align="left" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  "><cf_translate  key="LB_Fecha_de_Corte_al">Fecha de Corte al:</cf_translate></td>
				<td width="15%" align="left" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  ">#DateFormat(url.CumpleHasta, "dd/mm/yyyy")#</td>
				<cfif isdefined("rsCFuncional") and rsCFuncional.recordcount gt 0>
				<td width="15%" align="left" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  "><cf_translate  key="LB_Centro_Funcional">Centro Funcional:</cf_translate></td>
				<td width="25%" align="left" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  ">#rsCFuncional.CFcodigo# - #rsCFuncional.CFdescripcion#</td>
				<td width="30%" align="left" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  ">&nbsp;</td>
				<cfelse>
				<td width="70%" align="right" style="font-size:9px; font-family:Arial, Helvetica, sans-serif;  ">&nbsp;</td>
				</cfif>				
			  </tr>
			</table>
		</cfoutput>
		</cfdocumentitem>
		<!--- Se define pie de pagina --->
		<cfdocumentitem type="footer">
		<table width="601" align="center" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td align="right" valign="top" style="font-size:8px; font-family:Arial, Helvetica, sans-serif;  " height="12px">
				<cfoutput>#cfdocument.currentpagenumber# - #cfdocument.totalpagecount#</cfoutput>
			</td>
			</td>
		  </tr>
		</table>
		</cfdocumentitem>
		<!--- Se define cuerpo del reporte --->
		<br>
		<table width="600" align="center" border="0" cellspacing="0" cellpadding="0">
			<tr bgcolor="#E3EDEF" height="28px">
				<td style="font-size:10px; font-family:Arial, Helvetica, sans-serif;  " height="28px"><strong><cf_translate  key="LB_Identificacion">Identificaci&oacute;n</cf_translate></strong></td>
				<td style="font-size:10px; font-family:Arial, Helvetica, sans-serif;  " height="28px"><strong><cf_translate  key="LB_Nombre">Nombre</cf_translate></strong></td>
				<td style="font-size:10px; font-family:Arial, Helvetica, sans-serif;  " height="28px"><strong><cf_translate  key="LB_Fecha_de_Cese">Fecha de Cese</cf_translate></strong></td>
			</tr>
			<cfoutput query="rsReporte" group="CFid">
				<cfif rsReporte.CurrentRow GT 1>
					<tr><td colspan="3">&nbsp;</td></tr>
				</cfif>
				<tr bgcolor="##E3EDEF" height="18px">
					<td colspan="3" style="font-size:10px; font-family:Arial, Helvetica, sans-serif;  " height="18px"><strong>#rsReporte.CFcodigo# - #rsReporte.CFdescripcion#</strong></td>
				</tr>
				<cfoutput>
				<tr height="12px">
					<td style="font-size:8px; font-family:Arial, Helvetica, sans-serif;  " height="12px">#DEidentificacion#</td>
					<td style="font-size:8px; font-family:Arial, Helvetica, sans-serif;  " height="12px">#DEnombre#</td>
					<td style="font-size:8px; font-family:Arial, Helvetica, sans-serif;  " height="12px">#LSDateFormat(LThasta,'dd/mm/yyyy')#</td>
				</tr>
				</cfoutput>
			</cfoutput>
		</table>
	</cfdocument> 
</cfif>


