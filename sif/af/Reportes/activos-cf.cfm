<cfif not isdefined("url.imprimir") >
	<cf_templateheader template="#session.sitio.template#">
</cfif>

<cfset mes = url.Mes>
<cfset periodo = url.Periodo>

<cfset params = "&Mes=#url.Mes#" >
<cfset params = params & "&Periodo=#url.Periodo#" >
<cfif isdefined("url.CFpk") >
	<cfset params = params & "&CFid=#url.CFpk#" >
	<cfset params = params & "&CFpk=#url.CFpk#" >
</cfif>

<cfif isdefined("url.ACcodigo") >
	<cfset params = params & "&ACcodigo=#url.ACcodigo#" >
</cfif>

<cfif isdefined("url.ACid") >
	<cfset params = params & "&ACid=#url.ACid#" >
</cfif>

<cfif isdefined("url.dependencias") >
	<cfset params = params & "&dependencias=#url.dependencias#" >
</cfif>

<cfif isdefined("url.responsable") >
	<cfset params = params & "&responsable=#url.responsable#" >
</cfif>

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!--- path para consultar dependecias --->
<cfif isdefined("url.CFpk") and len(trim(url.CFpk)) and isdefined("url.dependencias")>
	<cfquery name="rsPath" datasource="#session.DSN#">
		select CFpath as ruta
		from CFuncional
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFpk#">
	</cfquery>
</cfif>

<cfif not isdefined("url.Exportar")>
	<cfquery datasource="#session.DSN#" name="rsRegistros">
		select count(1) as total
		from AFSaldos s
		
			inner join Activos a
			on a.Aid=s.Aid
		<cfif isdefined("url.responsable") and len(trim(url.responsable))>
			inner join AFResponsables af
				on af.Aid = a.Aid
				and af.Ecodigo = a.Ecodigo
			inner join DatosEmpleado de
				on de.DEid = af.DEid 	
		</cfif>
			
			inner join CFuncional cf
			on cf.CFid=s.CFid
			
			<cfif isdefined("url.CFpk") and len(trim(url.CFpk)) and isdefined("url.dependencias")>
				and upper(cf.CFpath) like '#trim(ucase(rsPath.ruta))#%'
			</cfif>	
		
			inner join ACategoria cat
			on cat.Ecodigo=s.Ecodigo
			and cat.ACcodigo=s.ACcodigo 
			
			inner join  AClasificacion cl
			on cl.Ecodigo   = s.Ecodigo
			and cl.ACcodigo = s.ACcodigo
			and cl.ACid     = s.ACid
		
		where s.Ecodigo = #session.Ecodigo#
		and s.AFSperiodo = #periodo#
		and s.AFSmes = #mes#
		and (s.AFSvaladq+s.AFSvalmej+s.AFSvalrev) > 0
		<cfif isdefined("url.responsable") and len(trim(url.responsable))>
		and AFRffin = (select max(AFRffin) from AFResponsables x  where x.Ecodigo = #session.Ecodigo# and x.Aid = af.Aid )
		</cfif>
		<cfif isdefined("url.CFpk") and len(trim(url.CFpk))>
			<cfif not isdefined("url.dependencias")>
				and s.CFid = #url.CFpk#
			</cfif>
		</cfif>
		<cfif isdefined("url.ACcodigo") and len(trim(url.ACcodigo))>
			and s.ACcodigo = #url.ACcodigo#
		</cfif>
		<cfif isdefined("url.ACid") and len(trim(url.ACid))>
			and s.ACid = #url.ACid#
		</cfif>
	</cfquery>
	
	<cfif rsRegistros.total gt 10000>
		<cf_errorCode	code = "50103" msg = "La salida para consulta devuelve más de 10000 registros, debe limitar esta salida restringiendo los filtros.">
	</cfif>
</cfif>

<cfquery name="data" datasource="#session.dsn#">
	select cf.CFcodigo as CodigoCF, 
		   cf.CFdescripcion as DescripcionCF, 
		   s.AFSperiodo as Perido, 
		   s.AFSmes as Mes,
		   a.Aplaca as Placa,
		   a.Aserie as Serie, 
			<cfif isdefined("url.responsable") and len(trim(url.responsable))>
		   de.DEidentificacion as identificacion,
		   de.DEnombre #_Cat# ' ' #_Cat# de.DEapellido1 #_Cat# ' ' #_Cat# de.DEapellido2 as nombre, 
			</cfif>
		   a.Adescripcion as ActDescripcion, 
		   cat.ACdescripcion as CatDescripcion, 
		   cl.ACdescripcion as ClaseDescripcion,
		   (s.AFSvaladq+s.AFSvalmej+s.AFSvalrev) as valor, 
		   (s.AFSdepacumadq+s.AFSdepacummej+s.AFSdepacumrev) as depreciacion, 
		   (s.AFSvaladq+s.AFSvalmej+s.AFSvalrev) - (AFSdepacumadq+AFSdepacummej+AFSdepacumrev) as valorlibros
		   
	from AFSaldos s
		inner join Activos a
		   on a.Aid  = s.Aid
			
		<cfif isdefined("url.responsable") and len(trim(url.responsable))>
		inner join AFResponsables af
			on af.Aid = a.Aid
			and af.Ecodigo = a.Ecodigo
		inner join DatosEmpleado de
			on de.DEid = af.DEid 
		</cfif>	
		inner join CFuncional cf
		on cf.CFid=s.CFid
		<cfif isdefined("url.CFpk") and len(trim(url.CFpk)) and isdefined("url.dependencias")>
			and upper(cf.CFpath) like '#trim(ucase(rsPath.ruta))#%'
		</cfif>	

		inner join ACategoria cat
		on cat.Ecodigo  =s.Ecodigo
		and cat.ACcodigo=s.ACcodigo 
	
		inner join  AClasificacion cl
		on cl.Ecodigo   = s.Ecodigo
		and cl.ACcodigo = s.ACcodigo
		and cl.ACid     = s.ACid
	
	where s.Ecodigo = #session.Ecodigo#
	and s.AFSperiodo = #periodo#
	and s.AFSmes = #mes#
	and (s.AFSvaladq+s.AFSvalmej+s.AFSvalrev) > 0
	<cfif isdefined("url.responsable") and len(trim(url.responsable))>
	and AFRffin = (select max(AFRffin) from AFResponsables x  where x.Ecodigo = #session.Ecodigo# and x.Aid = af.Aid)
	</cfif>
	<cfif isdefined("url.CFpk") and len(trim(url.CFpk))>
		<cfif not isdefined("url.dependencias")>
			and s.CFid = #url.CFpk#
		</cfif>
	</cfif>
	<cfif isdefined("url.ACcodigo") and len(trim(url.ACcodigo))>
		and s.ACcodigo = #url.ACcodigo#
	</cfif>
	<cfif isdefined("url.ACid") and len(trim(url.ACid))>
		and s.ACid = #url.ACid#
	</cfif>
	order by <cfif isdefined("url.responsable") and len(trim(url.responsable))>de.DEnombre,de.DEidentificacion,</cfif>cf.CFcodigo, a.Aplaca
</cfquery>

<cfif isdefined("url.Exportar")>
	<cf_exportQueryToFile query="#data#" separador="#chr(9)#" filename="ActivosXCentroF_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.txt" jdbc="false">
</cfif>

<!--- descripcion de cf--->
<cfif isdefined("url.CFpk") and len(trim(url.CFpk))>
	<cfquery name="rsCentro" datasource="#session.DSN#">
		select CFcodigo, CFdescripcion
		from CFuncional
		where CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFpk#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
</cfif>

<!--- descripcion de categorias --->
<cfif isdefined("url.ACcodigo") and len(trim(url.ACcodigo))>
	<cfquery name="rsCat" datasource="#session.DSN#">
		select ACdescripcion
		from ACategoria
		where ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ACcodigo#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>


	<cfif isdefined("url.ACid") and len(trim(Acid))>
		<!--- descripcion de clase --->
		<cfquery name="rsCla" datasource="#session.DSN#">
			select ACdescripcion
			from AClasificacion
			where ACcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ACcodigo#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and ACid = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.ACid#">
		</cfquery>
	</cfif>
</cfif>


<cf_rhimprime datos="/sif/af/Reportes/activos-cf.cfm" paramsuri="#params#" regresar="/cfmx/sif/af/Reportes/activos-cf-filtro.cfm">
<iframe name="printerIframe" id="printerIframe" src="about:blank"></iframe> 
<cfoutput>
<table width="100%" cellpadding="0" cellspacing="0">
	<cfif isdefined("url.imprimir")>
		<tr>
			<td align="right">
				<table width="10%" align="right" border="0" height="25px">
					<tr><td>Usuario:</td><td>#session.Usulogin#</td></tr>
					<tr><td>Fecha:</td><td>#LSDateFormat(now(), 'dd/mm/yyyy')#</td></tr>
				</table>
			</td>
		</tr>
	</cfif>
	<tr><td align="center" ><span class="titulox"><strong><font size="2">#session.Enombre#</font></strong></span></td></tr>
	<tr><td align="center"><strong>Consulta de Activos por Centro Funcional</strong></td></tr>
	<tr><td align="center"><strong>Centro Funcional:</strong><cfif isdefined("rsCentro") and rsCentro.recordcount gt 0 >&nbsp;#trim(rsCentro.CFcodigo)# - #rsCentro.CFdescripcion#<cfelse>&nbsp;Todos</cfif> </td></tr>
	<cfif isdefined("url.CFpk") and len(trim(url.CFpk)) and isdefined("url.dependencias")><tr><td align="center">Incluye dependencias del Centro Funcional</td></tr></cfif>
	<tr><td align="center"><strong>Categor&iacute;a:</strong> <cfif isdefined("rsCat")>&nbsp;#trim(rsCat.ACdescripcion)#<cfelse>&nbsp;Todas</cfif></td></tr>
	<tr><td align="center"><strong>Clasificaci&oacute;n:</strong> <cfif isdefined("rsCla")>&nbsp;#trim(rsCla.ACdescripcion)#<cfelse>&nbsp;Todas</cfif></td></tr>
</table>
</cfoutput>
<table width="100%" cellpadding="0" cellspacing="0">
	<tr style="padding:10px;">
	<cfif isdefined("url.responsable") and len(trim(url.responsable))>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap" align="center"><strong>Identificaci&oacute;n</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap" align="left"><strong>Nombre</strong></td>
	</cfif>
		<td style="padding:3px; padding-left:15px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Placa</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Descripci&oacute;n</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Categor&iacute;a</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap"><strong>Clase</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap" align="right"><strong>Valor</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap" align="right"><strong>Depreciacion</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap" align="right"><strong>Valor en Libros</strong></td>
		<td style="padding:3px;" bgcolor="#CCCCCC" nowrap="nowrap" align="center"><strong>Serie</strong></td>
		
	</tr>
	<cfflush interval="128">
	<cfset registros = 0 >
	<cfset vCFcodigo = 0 >

	<cfoutput query="data" group="CodigoCF">
		<cfset registros = registros + 1 >

		<cfset vCFcodigo = CodigoCF >
		<tr><td class="tituloListas" colspan="11" style="padding:3px;">Centro Funcional: #trim(CodigoCF)# - #DescripcionCF#</td></tr>
		<cfoutput>
			<tr>
			 <cfif isdefined("url.responsable") and len(trim(url.responsable))>
				<td style="font-size:9px">#identificacion#</td>
				<td style="font-size:9px" nowrap="nowrap">#nombre#</td>
			</cfif>
				<td nowrap="nowrap" style=" padding-left:15px;  font-size:9px" >#Placa#</td>
				<td style="font-size:9px">#ActDescripcion#</td>
				<td style="font-size:9px">#CatDescripcion#</td>
				<td style="font-size:9px">#ClaseDescripcion#</td>
				<td style="font-size:9px" align="right" >#LSNumberFormat(valor,',9.00')#</td>
				<td style="font-size:9px" align="right" >#LSNumberFormat(depreciacion,',9.00')#</td>
				<td style="font-size:9px" align="right" >#LSNumberFormat(valorlibros,',9.00')#</td>
				<td style="font-size:9px" align="right" >#Serie#</td>
			</tr>
		</cfoutput>
	</cfoutput>

	<cfif registros eq 0 >
		<tr><td colspan="7" align="center">--- No se encontraron registros ---</td></tr>
	</cfif>

	<tr><td>&nbsp;</td></tr>
	<tr><td colspan="7" align="center">--- Fin del Reporte ---</td></tr>
	<tr><td>&nbsp;</td></tr>	
</table>	
<cfif not isdefined("url.imprimir") >
	<cf_templatefooter template="#session.sitio.template#">
</cfif>


