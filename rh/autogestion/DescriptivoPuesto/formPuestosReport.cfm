<!--- Modificado en notepad --->
<cfif isdefined('url.RHPcodigo') and LEN(TRIM(url.RHPcodigo))>
	<cfset form.RHPcodigo = url.RHPcodigo>
</cfif>
<cfif isdefined('url.RHPcodigoext') and LEN(TRIM(url.RHPcodigoext))>
	<cfset form.RHPcodigoext = url.RHPcodigoext>
</cfif>
<cfif isdefined('url.formato') and LEN(TRIM(url.formato)) and not isdefined('form.formato')>
	<cfset form.formato = url.formato>
</cfif>
<cfparam name="form.formato" default="Flashpaper">
<!---  <cfset url.imprimir = "">--->

<!--- Requiere que est definido el RHPcodigo--->
<cfif isdefined("url.RHPcodigo") and len(trim(url.RHPcodigo)) gt 0>
	<cfset form.RHPcodigo = url.RHPcodigo>
</cfif>
<cfif isdefined("url.o") and len(trim(url.o)) gt 0>
	<cfset form.o = url.o>
</cfif>
<cfif isdefined("url.sel") and len(trim(url.sel)) gt 0>
	<cfset form.sel = url.sel>
</cfif>
<cfif isdefined("url.RHDPPid") and len(trim(url.RHDPPid)) gt 0>
	<cfset form.RHDPPid = url.RHDPPid>
</cfif>


<cfif not isdefined("form.RHPcodigo") or len(trim(form.RHPcodigo)) eq 0>
	<strong><cf_translate key="MSG_DebeSeleccionarUnPuestoParaMostrarElReporte">Debe seleccionar un puesto para mostrar el reporte</cf_translate></strong>.
	<cfabort>
	
</cfif>
<script >
	function funcRegresar(){
		location.href="PerfilPuesto.cfm?sel=<cfoutput>#form.sel#</cfoutput>&o=<cfoutput>#form.o#</cfoutput>&RHDPPid=<cfoutput>#form.RHDPPid#</cfoutput>";
	}
</script>
<!--- Consultas --->
<!--- 1. Consulta informacin de los parmetros del reporte --->
<cfquery name="rsPrms" datasource="#session.dsn#">
	select 	CRPohabilidad, 	CRPoconocim, 	CRPomision, 	CRPoobj, 		CRPoespecif, CRPoencab, CRPoubicacion, CRPepie,
			CRPehabilidad, 	CRPeconocim, 	CRPemision, 	CRPeobjetivo,	CRPeespecif, CRPeencab, CRPeubicacion, CRPeini, 
		 	coalesce(CRPihabilidad,0) as CRPihabilidad, 	
			coalesce(CRPiconocimi,0) as CRPiconocimi, 	
			coalesce(CRPimision,0) as CRPimision, 	
			coalesce(CRPiobj,0) as CRPiobj, 	
			coalesce(CRPiespecif,0) as CRPiespecif, 	
			coalesce(CRPiencab,0) as CRPiencab, 	
			coalesce(CRPiubicacion ,0) as CRPiubicacion ,
			coalesce(CRPipie ,0) as CRPipie
	from RHConfigReportePuestos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

	<!--- Valida que los parmetros esten definidos --->
	<cfif rsPrms.RecordCount eq 0>
		<strong>
		<cf_translate key="MSG_LosParametrosDelReporteNoHanSidoDefinidosDebeDefinirlosParaPoderPintarElReporte">Los par&aacute;metros del reporte no han sifo definidos, debe definirlos para poder pintar el reporte</cf_translate>.</strong>
		<cfabort>
	</cfif>

	<!--- 2. Consulta informacin del Puesto --->
	<cfquery name="rsQry" datasource="#session.dsn#">
		select  a.RHPdescpuesto as puesto, coalesce(a.RHPcodigoext,a.RHPcodigo) as codpuesto,
				b.RHTPdescripcion as tipoPuesto,b.RHTinfo as  informacionTipo, 
				c.RHDPmision as mision, c.RHDPobjetivos as objetivos,
				a.BMfecha,c.BMfechamod,coalesce(a.BMusuario,-1) BMusuario,coalesce(c.BMusumod,-1) as BMusumod,UsuarioJefeCF,FechaModJefeCF
		from RHPuestos a 
		left outer join RHTPuestos b
		  on a.RHTPid = b.RHTPid 
		left outer join RHDescripPuestoP c
		  on  a.RHPcodigo = c.RHPcodigo 
		  and a.Ecodigo   = c.Ecodigo 
		  and c.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	</cfquery>


	<!--- Valida que la consulta del Puesto obtenga resultados --->
	<cfif rsQry.RecordCount eq 0>
		<strong>
		<cf_translate key="MSG_PuestoInvalidoParaMostrarElReporte">Puesto inv&aacute;lido para mostrar el reporte</cf_translate>.</strong>
		<cfabort>
	<cfelse>
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec" />
		<cfset dataUsuario		 	= sec.getUsuarioByCodNoEmp(rsQry.BMusuario,'DatosEmpleado') >
		<cfset dataUsuarioMod 		= sec.getUsuarioByCodNoEmp(rsQry.BMusumod,'DatosEmpleado') >
		<cfif isdefined("rsQry.UsuarioJefeCF") and len(trim(rsQry.UsuarioJefeCF))>
			<cfset dataUsuarioJefeCF 	= sec.getUsuarioByCodNoEmp(rsQry.UsuarioJefeCF,'DatosEmpleado') >
		</cfif>	
	</cfif>
	
	

	

<!--- 3. Consulta informacin de niveles utilizados en las habilidades requeridas del puesto --->
<cfquery name="rsNivelesUHab" datasource="#session.dsn#">
	select distinct RHNcodigo, RHNdescripcion
	from RHNiveles a, RHHabilidades b, RHHabilidadPuestoP c, RHPuestos d ,RHDescripPuestoP x
	where a.RHNid = c.RHNid
	  and b.RHHid = c.RHHid
	  and c.RHDPPid = x.RHDPPid
	  and d.Ecodigo = x.Ecodigo
	  and x.RHPcodigo = d.RHPcodigo
	  and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and d.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
</cfquery>



<!--- 4. Consulta habilidades requeridas por el puesto --->
<cfquery name="rsHabilidades" datasource="#session.dsn#">
	select a.RHNcodigo, b.RHHdescripcion
	from RHNiveles a, RHHabilidades b, RHHabilidadPuestoP c, RHPuestos d ,RHDescripPuestoP x
	where a.RHNid = c.RHNid
	and b.RHHid = c.RHHid
    and c.RHDPPid = x.RHDPPid
    and d.Ecodigo = x.Ecodigo
    and x.RHPcodigo = d.RHPcodigo
	and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and d.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
    and c.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
</cfquery>


<!--- 5. Consulta informacin de niveles utilizados en los conocimientos requeridas del puesto --->
<cfquery name="rsNivelesUCon" datasource="#session.dsn#">
	select distinct RHNcodigo, RHNdescripcion
	from RHNiveles a, RHConocimientos b, RHConocimientoPuestoP c, RHPuestos d ,RHDescripPuestoP x
	where a.RHNid = c.RHNid
	and b.RHCid = c.RHCid
	and coalesce(b.RHCinactivo,0) = 0 
	and c.RHDPPid = x.RHDPPid
    and d.Ecodigo = x.Ecodigo
    and x.RHPcodigo = d.RHPcodigo	
	and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and d.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	and c.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">

</cfquery>


<!--- 6. Consulta conocimientos requeridos por el puesto --->
<cfquery name="rsConocimientos" datasource="#session.dsn#">
	select a.RHNcodigo, b.RHCdescripcion
	from RHNiveles a, RHConocimientos b, RHConocimientoPuestoP c, RHPuestos d ,RHDescripPuestoP x
	where a.RHNid = c.RHNid
	and coalesce(b.RHCinactivo,0) = 0 
	and b.RHCid = c.RHCid
	and c.RHDPPid = x.RHDPPid
    and d.Ecodigo = x.Ecodigo
    and x.RHPcodigo = d.RHPcodigo
	and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and d.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	and c.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">

</cfquery>


<!--- 7. Consulta perfil del puesto (encabezados detalle) --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Deseable"
	Default="Deseable"
	returnvariable="LB_Deseable"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Intercambiable"
	Default="Intercambiable"
	returnvariable="LB_Intercambiable"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Requerido"
	Default="Requerido"
	returnvariable="LB_Requerido"/>

<cfquery name="rsValores" datasource="#session.dsn#">
	select 		b.RHECGid, b.RHECGcodigo, b.RHECGdescripcion, c.RHDCGid, c.RHDCGcodigo, c.RHDCGdescripcion,
	case when a.RHVPtipo = 10 then '(#LB_Deseable#)' 
		 when a.RHVPtipo = 20 then '(#LB_Intercambiable#)' 
		 when a.RHVPtipo = 30 then '(#LB_Requerido#)' else '' end as  RHVPtipo
	from 		RHValorPuestoP a, RHECatalogosGenerales b, RHDCatalogosGenerales c ,RHDescripPuestoP x
	where 		x.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	and 		x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and 		x.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
	and         a.RHDPPid = x.RHDPPid
	and 		a.RHECGid = b.RHECGid
	and 		a.RHDCGid = c.RHDCGid
	and 		b.RHECGid = c.RHECGid
	order by	b.RHECGcodigo, c.RHDCGcodigo
</cfquery>




<!---- 8. Consulta de los datos variables (Especificaciones)--->
<!--- 
<cfquery name="rsDatosVariables" datasource="#session.dsn#">
	select 	a.RHDVPorden, x.RHPcodigo, a.RHDDVlinea, a.RHEDVid, coalesce(a.RHDDVvalor, c.RHDDVvalor) as RHDDVvalor,
			b.RHEDVcodigo, b. RHEDVdescripcion, 
			c.RHDDVcodigo, c.RHDDVdescripcion
	from RHDVPuestoP a
		inner join RHDescripPuestoP x
			on a.RHDPPid = x.RHDPPid
			and x.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		left outer join RHEDatosVariables b
			on a.RHEDVid = b. RHEDVid
			and x.Ecodigo = b.Ecodigo
		left outer join RHDDatosVariables c
			on a.RHDDVlinea = c.RHDDVlinea
			and x.Ecodigo = c.Ecodigo
	where x.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#"> 
		and x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by a.RHDVPorden
</cfquery>
 --->

<cfquery name="rsDatosVariablesP" datasource="#session.dsn#">
	select 	a.RHDVPorden, x.RHPcodigo, a.RHDDVlinea, a.RHEDVid, 
			b.RHEDVcodigo, b. RHEDVdescripcion, 
			c.RHDDVcodigo, c.RHDDVdescripcion
	from RHDVPuestoP a
		inner join RHDescripPuestoP x
			on a.RHDPPid = x.RHDPPid
			and x.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
		left outer join RHEDatosVariables b
			on a.RHEDVid = b. RHEDVid
			and x.Ecodigo = b.Ecodigo
		left outer join RHDDatosVariables c
			on a.RHDDVlinea = c.RHDDVlinea
			and x.Ecodigo = c.Ecodigo
	where x.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#"> 
		and x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by a.RHDVPorden
</cfquery>

<cfquery name="rsDatosVariables1" datasource="#session.dsn#">
	select 	a.RHDDVlinea, a.RHEDVid,a.RHDDVvalor
	from RHDVPuestoP a
	inner join RHDescripPuestoP x
		on a.RHDPPid = x.RHDPPid 

	where x.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#"> 
	and x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHDDVvalor is not null
	and x.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">

	 union

	select 	a.RHDDVlinea, a.RHEDVid,c.RHDDVvalor 
	from RHDVPuestoP a
		inner join RHDescripPuestoP x
		on a.RHDPPid = x.RHDPPid 
		left outer join RHDDatosVariables c
		on a.RHDDVlinea = c.RHDDVlinea
		and x.Ecodigo = c.Ecodigo
	where x.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		and x.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHDDVvalor is null    
		and x.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">
<!---	
	select 	a.RHDDVlinea, a.RHEDVid,a.RHDDVvalor
	from RHDVPuesto a
	inner join RHDescripPuestoP x
		on a.RHPcodigo = x.RHPcodigo 
		and x.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">

	where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#"> 
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHDDVvalor is not null

	 union

	select 	a.RHDDVlinea, a.RHEDVid,c.RHDDVvalor 
	from RHDVPuesto a
		inner join RHDescripPuestoP x
		on a.RHPcodigo = x.RHPcodigo 
		and x.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHDPPid#">	
		left outer join RHDDatosVariables c
		on a.RHDDVlinea = c.RHDDVlinea
		and a.Ecodigo = c.Ecodigo
	where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#"> 
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHDDVvalor is null--->
</cfquery>

<cfquery name="rsDatosVariables"  dbtype="query">
	select
			rsDatosVariablesP.RHDVPorden, 
			rsDatosVariablesP.RHPcodigo, 
			rsDatosVariablesP.RHDDVlinea, 
			rsDatosVariablesP.RHEDVid,
			rsDatosVariablesP.RHEDVcodigo, 
			rsDatosVariablesP.RHEDVdescripcion, 
			rsDatosVariablesP.RHDDVcodigo, 
			rsDatosVariablesP.RHDDVdescripcion,
			rsDatosVariables1.RHDDVvalor
	from 	rsDatosVariablesP,rsDatosVariables1
	where rsDatosVariablesP.RHDDVlinea = rsDatosVariables1.RHDDVlinea
	and   rsDatosVariablesP.RHEDVid  =  rsDatosVariables1.RHEDVid
	
</cfquery>






<!--- CREACION DE TABLA CON ENCABEZADOS EN ORDEN --->
<!---VARIABLES DE TRADUCCION--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ResponsablesYAprobacion"
	Default="Responsables y Aprobación"
	returnvariable="LB_ResponsablesYAprobacion"/>



<cfset Kini = 1>
<cfset Khabilidad = 2>
<cfset Kconocim = 3>
<cfset Kmision = 4>
<cfset Kobj = 5>
<cfset Kespecif = 6>
<cfset Kencab = 7>
<cfset Kubicacion = 8>
<cfset KResponsables = 9>
<cfset myQuery = QueryNew("llave, orden, etiqueta, mostrar")>
<cfset newRow = QueryAddRow(MyQuery, 9)>
<cfset temp = QuerySetCell(myQuery, "llave", Kini, 1)>
<cfset temp = QuerySetCell(myQuery, "mostrar", 1, 1)>
<cfset temp = QuerySetCell(myQuery, "etiqueta", rsPrms.CRPeini, 1)>
<cfset temp = QuerySetCell(myQuery, "llave", Khabilidad, 2)>
<cfset temp = QuerySetCell(myQuery, "orden", rsPrms.CRPohabilidad, 2)>
<cfset temp = QuerySetCell(myQuery, "mostrar", rsPrms.CRPihabilidad, 2)>
<cfset temp = QuerySetCell(myQuery, "etiqueta", rsPrms.CRPehabilidad, 2)>
<cfset temp = QuerySetCell(myQuery, "llave", Kconocim, 3)>
<cfset temp = QuerySetCell(myQuery, "orden", rsPrms.CRPoconocim, 3)>
<cfset temp = QuerySetCell(myQuery, "mostrar", rsPrms.CRPiconocimi, 3)>
<cfset temp = QuerySetCell(myQuery, "etiqueta", rsPrms.CRPeconocim, 3)>
<cfset temp = QuerySetCell(myQuery, "llave", Kmision, 4)>
<cfset temp = QuerySetCell(myQuery, "orden", rsPrms.CRPomision, 4)>
<cfset temp = QuerySetCell(myQuery, "mostrar", rsPrms.CRPimision, 4)>
<cfset temp = QuerySetCell(myQuery, "etiqueta", rsPrms.CRPemision, 4)>
<cfset temp = QuerySetCell(myQuery, "llave", Kobj, 5)>
<cfset temp = QuerySetCell(myQuery, "orden", rsPrms.CRPoobj, 5)>
<cfset temp = QuerySetCell(myQuery, "mostrar", rsPrms.CRPiobj, 5)>
<cfset temp = QuerySetCell(myQuery, "etiqueta", rsPrms.CRPeobjetivo, 5)>
<cfset temp = QuerySetCell(myQuery, "llave", Kespecif, 6)>
<cfset temp = QuerySetCell(myQuery, "orden", rsPrms.CRPoespecif, 6)>
<cfset temp = QuerySetCell(myQuery, "mostrar", rsPrms.CRPiespecif, 6)>
<cfset temp = QuerySetCell(myQuery, "etiqueta", rsPrms.CRPeespecif, 6)>
<cfset temp = QuerySetCell(myQuery, "llave", Kencab, 7)>
<cfset temp = QuerySetCell(myQuery, "orden", rsPrms.CRPoencab, 7)>
<cfset temp = QuerySetCell(myQuery, "mostrar", rsPrms.CRPiencab, 7)>
<cfset temp = QuerySetCell(myQuery, "etiqueta", rsPrms.CRPeencab, 7)>
<cfset temp = QuerySetCell(myQuery, "llave", Kubicacion, 8)>
<cfset temp = QuerySetCell(myQuery, "orden", rsPrms.CRPoubicacion, 8)>
<cfset temp = QuerySetCell(myQuery, "mostrar", rsPrms.CRPiubicacion, 8)>
<cfset temp = QuerySetCell(myQuery, "etiqueta", rsPrms.CRPeubicacion, 8)>
<cfset temp = QuerySetCell(myQuery, "llave", KResponsables, 9)>
<cfset temp = QuerySetCell(myQuery, "orden", 'rsPrms.CRPeubicacion', 9)>
<cfset temp = QuerySetCell(myQuery, "mostrar", 1, 9)>
<cfset temp = QuerySetCell(myQuery, "etiqueta", LB_ResponsablesYAprobacion, 9)>

<cfquery name="rsEtiqs" dbtype="query">
	select llave, etiqueta
	from myQuery
	where mostrar = 1
	order by orden
</cfquery>


<!--- FUNCION SIMPLE QUE PASA NMEROS ENTEROS A ROMANOS --->
<cffunction name="fnRoman" returntype="string">
	<cfargument name="number" type="numeric" required="yes">
	<cfset result = ''>
		<cfswitch expression="#number#">
			<cfcase value="1"><cfset result = 'I'></cfcase>
			<cfcase value="2"><cfset result = 'II'></cfcase>
			<cfcase value="3"><cfset result = 'III'></cfcase>
			<cfcase value="4"><cfset result = 'IV'></cfcase>
			<cfcase value="5"><cfset result = 'V'></cfcase>
			<cfcase value="6"><cfset result = 'VI'></cfcase>
			<cfcase value="7"><cfset result = 'VII'></cfcase>
			<cfcase value="8"><cfset result = 'VIII'></cfcase>
			<cfcase value="9"><cfset result = 'IX'></cfcase>
		</cfswitch>

	<cfreturn result>
</cffunction>
<style type="text/css">
H1.Corte_Pagina
{
PAGE-BREAK-AFTER: always
}

.title0 {
	font-family: sans-serif;
	font-size: 23px;
	font-style: normal;
	font-weight: bold;
	text-transform: uppercase;
	list-style-type: upper-roman;
	text-align:center;
}
.title0b {
	font-family: serif;
	font-size: 20px;
	font-style: normal;
	text-align:center;
}
.title1 {
	font-family: serif;
	font-size: 20px;
	font-style: normal;
	font-weight: bold;
	text-transform: uppercase;
	list-style-type: upper-roman;
}
.title2 {
	font-family:  Times New Roman;
	font-size: 18px;
	font-style: normal;
	font-weight: bold;
	list-style-type: decimal;
}
.title3 {
	font-family: Times New Roman;
	font-size: 18px;
	font-style: normal;
	font-weight: bold;
}
.texto1 {
	font-family: Times New Roman;
	font-size: 18px;
	font-weight: normal;
}
.texto2 {
	font-family: Times New Roman;
	font-size: 18px;
	font-weight: normal;
}
.texto3 {
	font-family: Times New Roman;
	font-size:16px;
	font-weight: normal;
}

</style>


<!--- <cfsavecontent variable="string"> --->
<cfif isdefined('form.formato') and form.formato NEQ 'HTML'>
<cfdocument format="#form.formato#" 
			marginleft="2" 
			marginright="2" 
			marginbottom="3"
			margintop="1" 
			unit="cm" 
			pagetype="letter">
	<cfdocumentitem type="footer">
		<table border="0" align="center" cellpadding="0" cellspacing="0" width="100%">
		 <tr>
			<td align="left"  style="font-size:23px; font-family: Times New Roman; font-weight: normal;">
				<cfif rsPrms.CRPipie eq 1>
					<cfoutput>#rsPrms.CRPepie#</cfoutput>
				</cfif>
			</td>
			<td align="right" valing="top"  style="font-size:18px; font-family: Times New Roman; font-weight: normal;">
				<!--- 
				<cfoutput><cf_translate key="LB_Pagina">P&aacute;gina</cf_translate>#cfdocument.currentpagenumber# <cf_translate key="LB_De">de</cf_translate>#cfdocument.totalpagecount#</cfoutput>
				 --->
			</td>
		  </tr>
	  </table>
	</cfdocumentitem>
	<table border="0" align="center" cellpadding="0" cellspacing="0" width="100%">
		<tr>
			<td>&nbsp;</td>
			<td colspan="3" style="font-size:14px; font-family: Times New Roman; font-weight: normal;">
					<cfoutput>#LSDateFormat(Now(),'dd/mm/yyyy')#</cfoutput>&nbsp;
			</td>
			<td>&nbsp;</td>
	  	</tr>
		  	<tr>
		  	<td>&nbsp;</td>
			<td colspan="3" style="font-family: Times New Roman; font-size: 23px;	font-style: italic;	font-weight: bold;	text-transform: uppercase;	list-style-type: upper-roman; text-align:center;">
				<cf_translate key="LB_DescripcionDelPuestoPROPUESTO">DESCRIPCI&Oacute;N DEL PUESTO (PROPUESTO)</cf_translate>
			</td>
			<td>&nbsp;</td>
	  	</tr>
	  	<tr>
			<td >&nbsp;</td>
			<td colspan="3" style="font-family: Times New Roman;font-size: 20px;font-style: normal;text-align:center;">
				<cfoutput>#rsQry.codpuesto# - #rsQry.puesto#</cfoutput>
			</td>
			<td>&nbsp;</td>
	  	</tr>
	  	<tr><td colspan="5">&nbsp;</td></tr>
		<cfloop query="rsEtiqs">
	  		<tr>
				<td>&nbsp;</td>
				<td colspan="3" style="font-family: Times New Roman; font-size: 20px; font-style: italic;	font-weight: bold; text-transform: uppercase; list-style-type: upper-roman;">
					<cfoutput>#fnRoman(CurrentRow)#. #Ucase(etiqueta)#</cfoutput>
				</td>
				<td>&nbsp;</td>
			</tr>
	  		<tr>
				<td>&nbsp;</td>
				<td colspan="3">
		  			<cfswitch expression="#llave#">
					<cfcase value="1"><!--- Kini --->
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  			<tr>
								<td  nowrap width="160" style="font-family: Times New Roman; font-size: 18px; font-style: normal; font-weight: bold;">
									<cf_translate key="LB_TipoPuesto">Tipo Puesto</cf_translate>
								</td>
								<td width="639" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<cfif len(trim(rsQry.tipoPuesto)) gt 0>
										<cfoutput>#rsQry.tipoPuesto#</cfoutput>
									<cfelse>No se ha definido.
									</cfif>
								</td>				
				  			</tr>
				  			<!--- <tr><td>&nbsp;</td></tr>
				  			<tr>
								<td colspan="2" nowrap="true" style="font-family: Times New Roman; font-size: 18px; font-style: normal; font-weight: bold;">
									<cf_translate key="LB_InformacionAdicional">Informaci&oacute;n Adicional</cf_translate>:
								</td>
				  			</tr>
				  			<tr>
								<td width="60">&nbsp;</td>
								<td width="739" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<cfif len(trim(rsQry.informacionTipo)) gt 0>
											<cfoutput>#rsQry.informacionTipo#</cfoutput>
										<cfelse>No se ha definido.
									</cfif>
									<!---<cfoutput>#rsQry.informacionTipo#</cfoutput>--->
								</td>
				  			</tr> --->
						</table>
					</cfcase> 
					<cfcase value="2"><!--- Khabilidad --->
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="60">&nbsp;</td>								
								<td nowrap width="60" valign="top" style="font-family: Times New Roman; font-size: 18px; font-style: normal; font-weight: bold;">
									<cf_translate key="LB_Niveles">Niveles</cf_translate>
								</td>
								<td nowrap width="678" valign="top" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<cfif rsNivelesUHab.RecordCount gt 0>
											<cfloop query="rsNivelesUHab">
												<tr><td style="font-family: Times New Roman; font-size: 18px; font-weight: normal;"><cfoutput>#RHNcodigo# - #RHNdescripcion#</cfoutput></td></tr>
											</cfloop>
										<cfelse>
											<tr>
												<td nowrap style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
													<cf_translate key="LB_NoSeHanDefinido">No se han definido</cf_translate>.
												</td>
											</tr>
										</cfif>
									</table>
								</td>
							</tr>
							<tr><td colspan="3">&nbsp;</td></tr>
							<cfif rsHabilidades.RecordCount>
								<tr>
									<td nowrap colspan="3">
										<table width="598" align="center" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td nowrap style="font-family: Times New Roman;	font-size: 18px; font-style: italic; font-weight: bold;">
													<cf_translate key="LB_Nivel">Nivel</cf_translate>
												</td>
												<td nowrap  style="font-family: Times New Roman;font-size: 18px;font-style: italic; font-weight: bold;">
													<cf_translate key="LB_Habilidad">Habilidad</cf_translate>
												</td>
											</tr>
											
											<cfloop query="rsHabilidades">
												<tr>
													<cfoutput>
														<td nowrap style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">#RHNcodigo#</td>
														<td nowrap style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">#RHHdescripcion#</td>
													</cfoutput>
												</tr>
											</cfloop>  
										</table>
									</td>
								</tr>
							</cfif>
						</table>
					</cfcase>
					<cfcase value="3"><!--- Kconocim --->
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="60">&nbsp;</td>
								<td nowrap width="60" valign="top" style="font-family: Times New Roman;font-size: 18px;font-style: normal;font-weight: bold;">
									<cf_translate key="LB_Niveles">Niveles</cf_translate>
								</td>
								<td nowrap valign="top" width="678"  style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<cfif rsNivelesUCon.RecordCount gt 0>
											<cfloop query="rsNivelesUCon">
												<tr><td style="font-family: Times New Roman; font-size: 18px; font-weight: normal;"><cfoutput>#RHNcodigo# - #RHNdescripcion#</cfoutput></td></tr>
											</cfloop>
										<cfelse>
											<tr><td nowrap  style="font-family: Times New Roman; font-size: 18px; font-weight: normal;"><cf_translate key="LB_NoSeHanDefinido">No se han definido</cf_translate>.</td></tr>
										</cfif>
									</table>
								</td>
							</tr>
							<tr><td colspan="3">&nbsp;</td></tr>
							<cfif rsConocimientos.RecordCount gt 0>
								<tr>
									<td nowrap colspan="3" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
										<table width="599" align="center" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td nowrap style="font-family: Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;">
													<cf_translate key="LB_Nivel">Nivel</cf_translate>
												</td>
												<td nowrap style="font-family: Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;">
													<cf_translate key="LB_Conocimiento">Conocimiento</cf_translate>
												</td>
											</tr>
											<cfloop query="rsConocimientos">
												<tr>
													<cfoutput>
														<td nowrap style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">#RHNcodigo#</td>
														<td nowrap style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">#RHCdescripcion#</td>
													</cfoutput>
												</tr>
											</cfloop>
										</table>
									</td>
								</tr>
							</cfif>
						</table>
					</cfcase>
					<cfcase value="4"><!--- Kmision --->
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr><td width="60">&nbsp;</td>
								<td width="739" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<cfoutput><cfif len(trim(rsQry.mision)) gt 0>#(rsQry.mision)#<cfelse><cf_translate key="LB_NoSeHaDefinido">No se ha definido</cf_translate></cfif></cfoutput>
								</td>
						  	</tr>
						</table>
					</cfcase>
					<cfcase value="5"><!--- Kobj --->
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="60">&nbsp;</td>
								<td width="738" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<cfoutput><cfif len(trim(rsQry.objetivos)) gt 0>#(rsQry.objetivos)#<cfelse><cf_translate key="LB_NoSeHaDefinido">No se ha definido</cf_translate></cfif></cfoutput>
								</td>
						  	</tr>
						</table>
					</cfcase>
					<cfcase value="6"><!--- Kespecif --->
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<cfoutput>
								<cfset corte = ''>
								<cfloop query="rsDatosVariables">
									<cfif corte neq rsDatosVariables.RHEDVid>
										<tr>
											<td width="60">&nbsp;</td>
											<td width="678" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">#rsDatosVariables.RHEDVdescripcion#</td>
										</tr>
									</cfif>
									<tr>
										<td width="60">&nbsp;</td>	
										<td width="678" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">#rsDatosVariables.RHDDVvalor#<br></td>
									</tr>
								</cfloop>
							</cfoutput>
						</table>
					</cfcase>
					<cfcase value="7"><!--- Kencab --->
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						 	<cfset corteval = "">
						 	<cfset contador = 0>
						  	<cfloop from="1" to="#rsValores.RecordCount#" index="i">
						  		<cfoutput>
							  		<tr>
							  			<td width="60">&nbsp;</td>	
							 			<td width="678">
											<table width="678"  border="0" cellspacing="0" cellpadding="0">
												<cfif corteval neq rsValores.RHECGcodigo[i]>
													<cfset contador = contador + 1>
													<tr>
														<td width="198" style="font-family: Times New Roman; font-size: 18px; font-style: normal; font-weight: bold;list-style-type: decimal;">
															<cfif contador gt 1>
																<br>
															</cfif>
															#contador#.&nbsp;#rsValores.RHECGdescripcion[i]#
														</td>
													</tr>
													<cfset corteval =rsValores.RHECGcodigo[i]>
												</cfif>
												<tr>
													<td width="600"  style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
														&nbsp;&nbsp;&nbsp;#rsValores.RHDCGdescripcion[i]#&nbsp;&nbsp;&nbsp;#rsValores.RHVPtipo[i]#
													</td>
												</tr>
											</table>
							  			</td>
							   		</tr>
						  		</cfoutput>
						  </cfloop>
						</table>
					</cfcase>
					<cfcase value="8"><!--- Kubicacion --->
						<cfinclude template="Puestos-jerarquiaPuesto.cfm">
					</cfcase>
					<cfcase value="9"><!--- KResponsables --->
						<!--- <cfif isdefined("url.imprimir")> --->	
							<cfoutput>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="2" style="font-family:  Times New Roman;font-size: 18px;font-style: italic;text-decoration: underline;font-weight: bold;list-style-type: decimal;">
										Creaci&oacute;n
									</td>
								</tr>
								<tr>
									<td style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">
										&nbsp;&nbsp;&nbsp;Analista:
									</td>
									<td >	
										<cfif dataUsuario.RecordCount neq 0>
											#dataUsuario.Pnombre# #dataUsuario.Papellido1# #dataUsuario.Papellido2#
										</cfif>
									</td>
								</tr>
								<tr>
									<td style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Fecha:</td>
									<td style="font-family: Times New Roman;font-size: 18px;font-weight: normal;">#LSDateFormat(rsQry.BMfecha,'dd/mm/yyyy')#</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td colspan="2" style="font-family:  Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;text-decoration: underline;list-style-type: decimal;">
										Aprobaci&oacute;n DH
									</td>
								</tr>
								<tr>
									<td colspan="2" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Puesto:</td>
								</tr>
								<tr>
									<td colspan="2" style="font-family:  Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;list-style-type: decimal;">Nombre:</td>
								</tr>
								<tr><td colspan="2" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Firma:</td></tr>
								<tr>																	<td colspan="2" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Fecha:</td></tr>
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td colspan="2" style="font-family:  Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;text-decoration: underline;list-style-type: decimal;">
										Aprobaci&oacute;n Area
									</td>
								</tr>
								<tr>
									<td  style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Puesto:</td>
									<td>
										<cfif isdefined("dataUsuarioJefeCF") and dataUsuarioJefeCF.RecordCount gt 0>
											<cfquery name="RSPuestoCF" datasource="#session.DSN#">
												select RHPdescpuesto  from 	LineaTiempo a
												inner join RHPlazas b
													on a.Ecodigo = b.Ecodigo
													and a.RHPid = b.RHPid
												inner join RHPuestos c
													on 	b.Ecodigo = c.Ecodigo
													and b.RHPpuesto = c.RHPcodigo 
												where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataUsuarioJefeCF.llave#">
												and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between  LTdesde and LThasta
											</cfquery>
											<cfif isdefined("RSPuestoCF") and RSPuestoCF.RecordCount gt 0>
												#RSPuestoCF.RHPdescpuesto#
											</cfif>
										</cfif>
									</td>
								
								</tr>	
								<tr>
									<td  style="font-family:  Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;list-style-type: decimal;">Nombre:</td>
									<td> 
										<cfif isdefined("dataUsuarioJefeCF") and dataUsuarioJefeCF.RecordCount gt 0>
											#dataUsuarioJefeCF.Pnombre# #dataUsuarioJefeCF.Papellido1# #dataUsuarioJefeCF.Papellido2#
										</cfif>
									</td>
								</tr>
								<tr><td colspan="2" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Firma:</td></tr>
								<tr>
									<td colspan="1" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Fecha:</td>
									<td style="font-family: Times New Roman;font-size: 18px;font-weight: normal;"><cfif isdefined("dataUsuarioJefeCF") and   dataUsuarioJefeCF.RecordCount neq 0>#LSDateFormat(rsQry.FechaModJefeCF,'dd/mm/yyyy')#</cfif></td>
								</tr>
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td colspan="2" style="font-family:  Times New Roman;font-size: 18px;font-style: normal;font-weight: bold;text-decoration: underline;list-style-type: decimal;">Actualizaci&oacute;n</td>
								</tr>	
								<tr>
									<td style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Analista:</td>
									<td  style="font-family: Times New Roman;font-size: 18px;font-weight: normal;">	
										<cfif isdefined("dataUsuarioMod") and dataUsuarioMod.RecordCount neq 0>
											#dataUsuarioMod.Pnombre# #dataUsuarioMod.Papellido1# #dataUsuarioMod.Papellido2#
										</cfif>
									</td>
								</tr>	
								<tr>
									<td style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Fecha:</td>
									<td style="font-family: Times New Roman;font-size: 18px;font-weight: normal;"><cfif isdefined("dataUsuarioMod") and  dataUsuarioMod.RecordCount neq 0>#LSDateFormat(rsQry.BMfechamod,'dd/mm/yyyy')#</cfif></td>
								</tr>	
							</table>
							</cfoutput>
						<!--- </cfif> --->
					</cfcase> 
		  			</cfswitch>
				</td>
				<td>&nbsp;</td>
	  		</tr>
	  		<tr><td colspan="5">&nbsp;</td></tr>
		</cfloop> 
	<tr><td colspan="5">&nbsp;</td></tr>
</table>
</cfdocument>
<cfelse>
	<table border="0" align="center" cellpadding="0" cellspacing="0" width="800">
		<tr>
			<td>&nbsp;</td>
			<td colspan="3" style="font-size:14px; font-family: Times New Roman; font-weight: normal;">
					<cfoutput>#LSDateFormat(Now(),'dd/mm/yyyy')#</cfoutput>&nbsp;
			</td>
			<td>&nbsp;</td>
	  	</tr>
		  	<tr>
		  	<td>&nbsp;</td>
			<td colspan="3" style="font-family: Times New Roman; font-size: 23px;	font-style: italic;	font-weight: bold;	text-transform: uppercase;	list-style-type: upper-roman; text-align:center;">
				<cf_translate key="LB_DescripcionDelPuesto">DESCRIPCI&Oacute;N DEL PUESTO</cf_translate>
			</td>
			<td>&nbsp;</td>
	  	</tr>
	  	<tr>
			<td >&nbsp;</td>
			<td colspan="3" style="font-family: Times New Roman;font-size: 20px;font-style: normal;text-align:center;">
				<cfoutput>#rsQry.codpuesto# - #rsQry.puesto#</cfoutput>
			</td>
			<td>&nbsp;</td>
	  	</tr>
	  	<tr><td colspan="5">&nbsp;</td></tr>
		<cfloop query="rsEtiqs">
	  		<tr>
				<td>&nbsp;</td>
				<td colspan="3" style="font-family: Times New Roman; font-size: 20px; font-style: italic;	font-weight: bold; text-transform: uppercase; list-style-type: upper-roman;">
					<cfoutput>#fnRoman(CurrentRow)#. #Ucase(etiqueta)#</cfoutput>
				</td>
				<td>&nbsp;</td>
			</tr>
	  		<tr>
				<td>&nbsp;</td>
				<td colspan="3">
		  			<cfswitch expression="#llave#">
					<cfcase value="1"><!--- Kini --->
						<table width="799"  border="0" cellspacing="0" cellpadding="0">
				  			<tr>
								<td  nowrap width="160" style="font-family: Times New Roman; font-size: 18px; font-style: normal; font-weight: bold;">
									<cf_translate key="LB_TipoPuesto">Tipo Puesto</cf_translate>
								</td>
								<td width="639" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<cfif len(trim(rsQry.tipoPuesto)) gt 0>
										<cfoutput>#rsQry.tipoPuesto#</cfoutput>
									<cfelse>No se ha definido.
									</cfif>
								</td>				
				  			</tr>
				  			<tr><td>&nbsp;</td></tr>
				  			<tr>
								<td colspan="2" nowrap="true" style="font-family: Times New Roman; font-size: 18px; font-style: normal; font-weight: bold;">
									<cf_translate key="LB_InformacionAdicional">Informaci&oacute;n Adicional</cf_translate>:
								</td>
				  			</tr>
				  			<tr>
								<td width="60">&nbsp;</td>
								<td width="739" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<cfif len(trim(rsQry.informacionTipo)) gt 0>
											<cfoutput>#rsQry.informacionTipo#</cfoutput>
										<cfelse>No se ha definido.
									</cfif>
									<!---<cfoutput>#rsQry.informacionTipo#</cfoutput>--->
								</td>
				  			</tr>
						</table>
					</cfcase> 
					<cfcase value="2"><!--- Khabilidad --->
						<table width="799"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="60">&nbsp;</td>								
								<td nowrap width="60" valign="top" style="font-family: Times New Roman; font-size: 18px; font-style: normal; font-weight: bold;">
									<cf_translate key="LB_Niveles">Niveles</cf_translate>
								</td>
								<td nowrap width="678" valign="top" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<cfif rsNivelesUHab.RecordCount gt 0>
											<cfloop query="rsNivelesUHab">
												<tr><td style="font-family: Times New Roman; font-size: 18px; font-weight: normal;"><cfoutput>#RHNcodigo# - #RHNdescripcion#</cfoutput></td></tr>
											</cfloop>
										<cfelse>
											<tr>
												<td nowrap style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
													<cf_translate key="LB_NoSeHanDefinido">No se han definido</cf_translate>.
												</td>
											</tr>
										</cfif>
									</table>
								</td>
							</tr>
							<tr><td colspan="3">&nbsp;</td></tr>
							<cfif rsHabilidades.RecordCount>
								<tr>
									<td nowrap colspan="3">
										<table width="598" align="center" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td nowrap style="font-family: Times New Roman;	font-size: 18px; font-style: italic; font-weight: bold;">
													<cf_translate key="LB_Nivel">Nivel</cf_translate>
												</td>
												<td nowrap  style="font-family: Times New Roman;font-size: 18px;font-style: italic; font-weight: bold;">
													<cf_translate key="LB_Habilidad">Habilidad</cf_translate>
												</td>
											</tr>
											
											<cfloop query="rsHabilidades">
												<tr>
													<cfoutput>
														<td nowrap style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">#RHNcodigo#</td>
														<td nowrap style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">#RHHdescripcion#</td>
													</cfoutput>
												</tr>
											</cfloop>  
										</table>
									</td>
								</tr>
							</cfif>
						</table>
					</cfcase>
					<cfcase value="3"><!--- Kconocim --->
						<table width="799"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="60">&nbsp;</td>
								<td nowrap width="60" valign="top" style="font-family: Times New Roman;font-size: 18px;font-style: normal;font-weight: bold;">
									<cf_translate key="LB_Niveles">Niveles</cf_translate>
								</td>
								<td nowrap valign="top" width="678"  style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<cfif rsNivelesUCon.RecordCount gt 0>
											<cfloop query="rsNivelesUCon">
												<tr><td style="font-family: Times New Roman; font-size: 18px; font-weight: normal;"><cfoutput>#RHNcodigo# - #RHNdescripcion#</cfoutput></td></tr>
											</cfloop>
										<cfelse>
											<tr><td nowrap  style="font-family: Times New Roman; font-size: 18px; font-weight: normal;"><cf_translate key="LB_NoSeHanDefinido">No se han definido</cf_translate>.</td></tr>
										</cfif>
									</table>
								</td>
							</tr>
							<tr><td colspan="3">&nbsp;</td></tr>
							<cfif rsConocimientos.RecordCount gt 0>
								<tr>
									<td nowrap colspan="3" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
										<table width="599" align="center" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td nowrap style="font-family: Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;">
													<cf_translate key="LB_Nivel">Nivel</cf_translate>
												</td>
												<td nowrap style="font-family: Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;">
													<cf_translate key="LB_Conocimiento">Conocimiento</cf_translate>
												</td>
											</tr>
											<cfloop query="rsConocimientos">
												<tr>
													<cfoutput>
														<td nowrap style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">#RHNcodigo#</td>
														<td nowrap style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">#RHCdescripcion#</td>
													</cfoutput>
												</tr>
											</cfloop>
										</table>
									</td>
								</tr>
							</cfif>
						</table>
					</cfcase>
					<cfcase value="4"><!--- Kmision --->
						<table width="799"  border="0" cellspacing="0" cellpadding="0">
							<tr><td width="60">&nbsp;</td>
								<td width="739" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<cfoutput><cfif len(trim(rsQry.mision)) gt 0>#(rsQry.mision)#<cfelse><cf_translate key="LB_NoSeHaDefinido">No se ha definido</cf_translate></cfif></cfoutput>
								</td>
						  	</tr>
						</table>
					</cfcase>
					<cfcase value="5"><!--- Kobj --->
						<table width="799"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="60">&nbsp;</td>
								<td width="738" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<cfoutput><cfif len(trim(rsQry.objetivos)) gt 0>#(rsQry.objetivos)#<cfelse><cf_translate key="LB_NoSeHaDefinido">No se ha definido</cf_translate></cfif></cfoutput>
								</td>
						  	</tr>
						</table>
					</cfcase>
					<cfcase value="6"><!--- Kespecif --->
						<table width="799"  border="0" cellspacing="0" cellpadding="0">
							<cfoutput>
								<cfset corte = ''>
								<cfloop query="rsDatosVariables">
									<cfif corte neq rsDatosVariables.RHEDVid>
										<tr>
											<td width="60">&nbsp;</td>
											<td width="678" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">#rsDatosVariables.RHEDVdescripcion#</td>
										</tr>
									</cfif>
									<tr>
										<td width="60">&nbsp;</td>	
										<td width="678" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">#rsDatosVariables.RHDDVvalor#<br></td>
									</tr>
								</cfloop>
							</cfoutput>
						</table>
					</cfcase>
					<cfcase value="7"><!--- Kencab --->
						<table width="799"  border="0" cellspacing="0" cellpadding="0">
						 	<cfset corteval = "">
						 	<cfset contador = 0>
						  	<cfloop from="1" to="#rsValores.RecordCount#" index="i">
						  		<cfoutput>
							  		<tr>
							  			<td width="60">&nbsp;</td>	
							 			<td width="678">
											<table width="678"  border="0" cellspacing="0" cellpadding="0">
												<cfif corteval neq rsValores.RHECGcodigo[i]>
													<cfset contador = contador + 1>
													<tr>
														<td width="198" style="font-family: Times New Roman; font-size: 18px; font-style: normal; font-weight: bold;list-style-type: decimal;">
															<cfif contador gt 1>
																<br>
															</cfif>
															#contador#.&nbsp;#rsValores.RHECGdescripcion[i]#
														</td>
													</tr>
													<cfset corteval =rsValores.RHECGcodigo[i]>
												</cfif>
												<tr>
													<td width="600"  style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
														&nbsp;&nbsp;&nbsp;#rsValores.RHDCGdescripcion[i]#&nbsp;&nbsp;&nbsp;#rsValores.RHVPtipo[i]#
													</td>
												</tr>
											</table>
							  			</td>
							   		</tr>
						  		</cfoutput>
						  </cfloop>
						</table>
					</cfcase>
					<cfcase value="8"><!--- Kubicacion --->
						<cfinclude template="Puestos-jerarquiaPuesto.cfm">
					</cfcase>
					<cfcase value="9"><!--- KResponsables --->
						<!--- <cfif isdefined("url.imprimir")> --->	
							<cfoutput>
							<table width="799"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td colspan="2" style="font-family:  Times New Roman;font-size: 18px;font-style: italic;text-decoration: underline;font-weight: bold;list-style-type: decimal;">
										Creaci&oacute;n
									</td>
								</tr>
								<tr>
									<td style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">
										&nbsp;&nbsp;&nbsp;Analista:
									</td>
									<td >	
										<cfif dataUsuario.RecordCount neq 0>
											#dataUsuario.Pnombre# #dataUsuario.Papellido1# #dataUsuario.Papellido2#
										</cfif>
									</td>
								</tr>
								<tr>
									<td style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Fecha:</td>
									<td style="font-family: Times New Roman;font-size: 18px;font-weight: normal;">#LSDateFormat(rsQry.BMfecha,'dd/mm/yyyy')#</td>
								</tr>
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td colspan="2" style="font-family:  Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;text-decoration: underline;list-style-type: decimal;">
										Aprobaci&oacute;n DH
									</td>
								</tr>
								<tr>
									<td colspan="2" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Puesto:</td>
								</tr>
								<tr>
									<td colspan="2" style="font-family:  Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;list-style-type: decimal;">Nombre:</td>
								</tr>
								<tr><td colspan="2" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Firma:</td></tr>
								<tr>																	<td colspan="2" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Fecha:</td></tr>
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td colspan="2" style="font-family:  Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;text-decoration: underline;list-style-type: decimal;">
										Aprobaci&oacute;n Area
									</td>
								</tr>
								<tr>
									<td colspan="2" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Puesto:</td>
								</tr>	
								<tr>
									<td colspan="2" style="font-family:  Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;list-style-type: decimal;">Nombre:</td>
								</tr>
								<tr><td colspan="2" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Firma:</td></tr>
								<tr><td colspan="2" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Fecha:</td></tr>
								<tr><td>&nbsp;</td></tr>
								<tr>
									<td colspan="2" style="font-family:  Times New Roman;font-size: 18px;font-style: normal;font-weight: bold;text-decoration: underline;list-style-type: decimal;">Actualizaci&oacute;n</td>
								</tr>	
								<tr>
									<td style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Analista:</td>
									<td  style="font-family: Times New Roman;font-size: 18px;font-weight: normal;">	
										<cfif dataUsuarioMod.RecordCount neq 0>
											#dataUsuarioMod.Pnombre# #dataUsuarioMod.Papellido1# #dataUsuarioMod.Papellido2#
										</cfif>
									</td>
								</tr>	
								<tr>
									<td style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Fecha:</td>
									<td style="font-family: Times New Roman;font-size: 18px;font-weight: normal;">#LSDateFormat(rsQry.BMfechamod,'dd/mm/yyyy')#</td>
								</tr>	
							</table>
							</cfoutput>
						<!--- </cfif> --->
					</cfcase> 
		  			</cfswitch>
				</td>
				<td>&nbsp;</td>
	  		</tr>
	  		<tr><td colspan="5">&nbsp;</td></tr>
		</cfloop> 
	<tr><td colspan="5">&nbsp;</td></tr>
	<table border="0" align="center" cellpadding="0" cellspacing="0" width="100%">
	 <tr>
		<td align="left"  style="font-size:23px; font-family: Times New Roman; font-weight: normal;">
			<cfif rsPrms.CRPipie eq 1>
				<cfoutput>#rsPrms.CRPepie#</cfoutput>
			</cfif>
		</td>
	  </tr>
  </table>
</table>
</cfif>
<!--- </cfsavecontent> 

<cfoutput>
	<cfif isdefined("url.imprimir")>
		#string#		
	<cfelse>
		<cf_sifHTML2Word>
			#string#
		</cf_sifHTML2Word>
	</cfif>
</cfoutput>--->