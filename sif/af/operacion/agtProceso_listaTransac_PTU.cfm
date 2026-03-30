<cfset LvarPar = ''>
<cfif isdefined("session.LvarJA") and session.LvarJA>
	<cfset LvarPar = ''>
<cfelseif isdefined("session.LvarJA") and not session.LvarJA>
	<cfset LvarPar = ''>
</cfif>

<cfset params = ''>
<cfif isdefined('form.Filtro_AGTPdescripcion')>
	<cfset params = params & 'Filtro_AGTPdescripcion=#form.Filtro_AGTPdescripcion#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPestadoDesc')>
	<cfset params = params & '&Filtro_AGTPestadoDesc=#form.Filtro_AGTPestadoDesc#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPfalta')>
	<cfset params = params & '&Filtro_AGTPfalta=#form.Filtro_AGTPfalta#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPmesDesc')>
	<cfset params = params & '&Filtro_AGTPmesDesc=#form.Filtro_AGTPmesDesc#'>
</cfif>
<cfif isdefined('form.Filtro_AGTPperiodo')>
	<cfset params = params & '&Filtro_AGTPperiodo=#form.Filtro_AGTPperiodo#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPdescripcion')>
	<cfset params = params & '&HFiltro_AGTPdescripcion=#form.Filtro_AGTPdescripcion#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPestadoDesc')>
	<cfset params = params & '&HFiltro_AGTPestadoDesc=#form.Filtro_AGTPestadoDesc#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPfalta')>
	<cfset params = params & '&HFiltro_AGTPfalta=#form.Filtro_AGTPfalta#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPmesDesc')>
	<cfset params = params & '&HFiltro_AGTPmesDesc=#form.Filtro_AGTPmesDesc#'>
</cfif>
<cfif isdefined('form.HFiltro_AGTPperiodo')>
	<cfset params = params & '&HFiltro_AGTPperiodo=#form.Filtro_AGTPperiodo#'>
</cfif>


<!---IDtrans--->
<cfif isdefined("url.IDtrans") and not (isdefined("IDtrans") and len(trim(IDtrans)))><cfset IDtrans = url.IDtrans></cfif>
<cfif isdefined("form.IDtrans") and not (isdefined("IDtrans") and len(trim(IDtrans)))><cfset IDtrans = form.IDtrans></cfif>
<cfparam name="IDtrans">
<!---AGTPid--->
<cfif isdefined("url.AGTPid") and not (isdefined("AGTPid") and len(trim(AGTPid)))><cfset AGTPid = url.AGTPid></cfif>
<cfif isdefined("form.AGTPid") and not (isdefined("AGTPid") and len(trim(AGTPid)))><cfset AGTPid = form.AGTPid></cfif>
<cfparam name="AGTPid" type="numeric">
<!---filtro--->
<cfset filtro = "a.Ecodigo=#session.Ecodigo# and a.IDtrans = #IDtrans# and a.AGTPid=#AGTPid#">
<!---navegacion--->
<cfset navegacion = "&IDtrans=#IDtrans#&AGTPid=#AGTPid#">
<!---curentPage obtiene la pagina actual porque este fuente puede estar incluido en varios archivos.--->
<cfset currentPage = GetFileFromPath(GetTemplatePath())>
<!---coinsulta datos del encabezado--->
<cfquery name="rsAGTProceso" datasource="#session.dsn#">
	select AGTPdescripcion
	from AGTProceso
	where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AGTPid#">
</cfquery>
<cfset grupodesc = rsAGTProceso.AGTPdescripcion>
<!---botonAccion define la descripcion y la acción del boton de acuerdo con el IDtrans recibido --->
<!--- DEPRECIACION --->
<cfset botonAccion = ArrayNew(2)>

<cfset botonAccion[13][1] = "Regresar">
<cfset botonAccion[13][2] = "DEPRECIACION_PTU">
<cfset botonAccion[13][3] = "Lista de Transacciones de Depreciaci&oacute;n del grupo #grupodesc#">
<cfset botonAccion[13][4] = "Depreciación">
<cfset botonAccion[13][5] = "(afs.AFSvaladq + coalesce(afs.AFSvalmej,0)) as AFSvaladq, a.TAmontolocmej as TAmontolocmej, a.TAmontoorimej as TAmontoorimej, a.TAmontolocadq as TAmontolocadq, a.TAmontooriadq as TAmontooriadq">
<cfset botonAccion[13][6] = "AFSvaladq,TAmontolocmej,TAmontoorimej, TAmontolocadq,TAmontooriadq">
<cfset botonAccion[13][7] = "Monto Original Inversion, Porcentaje Deduccion PTU, Saldo Anterior, Disminucion Base PTU, Saldo Pendiente Disminuir">

<!---lista--->
<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as value
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 50
		and Mcodigo = 'GN'
</cfquery>
<cfquery name="rsMes" datasource="#session.dsn#">
	select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as value
	from Parametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = 60
		and Mcodigo = 'GN'
</cfquery>
<cfif rsPeriodo.RecordCount neq 1 or rsMes.RecordCount neq 1>
	<cf_errorCode	code = "50090" msg = "No están bien definidos el periodo y mes de auxiliares! Proceso Cancelado!">
</cfif>
<cf_templateheader title="#botonAccion[IDtrans][3]#">
<cf_web_portlet_start titulo="#botonAccion[IDtrans][3]#">
<table width="100%" border="0">
  <tr>
    <td width="5%">&nbsp;</td>
    <td>&nbsp;</td>
    <td width="5%">&nbsp;</td>
  </tr>
  <tr>
    <td >&nbsp;</td>
    <td>
		<cfinclude template="agtProceso_filtroTransac.cfm">
		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="columnas" value="a.ADTPlinea, a.Ecodigo, a.AGTPid, 
													 a.Aid, a.IDtrans, #botonAccion[IDtrans][5]#, a.TAmeses,
													 a.TAperiodo as Periodo, a.TAfalta, '  ' as espacio, 
													 c.Adescripcion as Activo, c.Aplaca, c.Aserie,  
													 d.ACdescripcion as Categoria,
													 e.ACdescripcion as Clase,
													 ((select min(g.Odescripcion) from Oficinas g where g.Ecodigo = f.Ecodigo and g.Ocodigo = f.Ocodigo)) as Oficina,
													 ((select min(h.Ddescripcion) from Departamentos h where h.Ecodigo = f.Ecodigo and h.Dcodigo = f.Dcodigo)) as Departamento,
													 f.CFdescripcion as CentroF"/>
			<cfinvokeargument name="tabla" value="ADTProceso a 
												inner join AGTProceso b on b.AGTPid = a.AGTPid and b.IDtrans = a.IDtrans and b.Ecodigo = a.Ecodigo 
												inner join AFSaldos afs on afs.Aid = a.Aid and afs.AFSperiodo = #rsPeriodo.value#  and afs.AFSmes = #rsMes.value#
												inner join CFuncional f on f.CFid = a.CFid
												inner join Activos c
													inner join ACategoria d on d.ACcodigo = c.ACcodigo and d.Ecodigo = c.Ecodigo
													inner join AClasificacion e on e.ACid = c.ACid and e.ACcodigo = c.ACcodigo and e.Ecodigo = c.Ecodigo
												on c.Aid = a.Aid
												"/>
			<cfinvokeargument name="filtro" value="#filtro# order by CentroF, Categoria, Clase, a.Aid, a.TAperiodo, Aplaca, Adescripcion"/>
			<cfinvokeargument name="cortes" value="CentroF, Categoria, Clase"/>
			<cfinvokeargument name="desplegar" value="Aplaca, Activo, Periodo, #botonAccion[IDtrans][6]#, espacio"/>
			<cfinvokeargument name="totales" value="#botonAccion[IDtrans][6]#"/>
			<cfinvokeargument name="totalgenerales" value="#botonAccion[IDtrans][6]#"/>
			<cfinvokeargument name="etiquetas" value="Placa, Activo, Periodo, #botonAccion[IDtrans][7]#, "/>
			<cfinvokeargument name="formatos" value="V, V, S, #RepeatString('M, ', ListLen(botonAccion[IDtrans][7]))#, V"/>
			<cfinvokeargument name="align" value="left, left, right, #RepeatString('right, ', ListLen(botonAccion[IDtrans][7]))#, left"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="#CurrentPage#"/>
			<cfinvokeargument name="formname" value="fadtproceso"/>
			<cfinvokeargument name="botones" value="#botonAccion[IDtrans][1]#"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>	
			<cfinvokeargument name="showLink" value="false"/>	
			<cfinvokeargument name="FontSize" value="9"/>
			<cfinvokeargument name="MaxRowsQuery" value="500"/>
		</cfinvoke>
	</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
</table>
<cf_web_portlet_end>
<cf_templatefooter>
<!---Funciones en Javascript del formulario de filtro--->
<script language="javascript" type="text/javascript">
	<!--//
	function funcRegresar(){
		<cfif isdefined("Url.DepMnl")>
			<cfoutput>
			document.fadtproceso.action = "agtProceso_genera_DepManual#LvarPar#.cfm?AGTPid=#form.AGTPid#";
			</cfoutput>		
		<cfelse>
			<cfoutput>
			document.fadtproceso.action = "agtProceso_#botonAccion[IDtrans][2]##LvarPar#.cfm?#params#";
			</cfoutput>
		</cfif>
	}
//-->
</script>

