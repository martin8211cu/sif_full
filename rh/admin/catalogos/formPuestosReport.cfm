<!--- <cfquery name="rsOBJ" datasource="#session.dsn#">
	select  RHDPobjetivos  from RHDescriptivoPuesto where RHPcodigo = 'DH0705' 
</cfquery>
<cf_dump var="#rsOBJ#"> --->

<!--- Modificado en notepad --->
<cfquery name="RSTipo" datasource="#session.DSN#">
	select ltrim(rtrim(Pvalor)) as Modo  
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and Pcodigo = 690				
</cfquery>


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
<cfif not isdefined("form.RHPcodigo") or len(trim(form.RHPcodigo)) eq 0>
	<strong><cf_translate key="MSG_DebeSeleccionarUnPuestoParaMostrarElReporte">Debe seleccionar un puesto para mostrar el reporte</cf_translate></strong>.
	<cfabort>
	
</cfif>
<script >
	function funcRegresar(){
		location.href="../consultas/ReportePuestos.cfm";
	}
</script>
<!--- Consultas --->
<!--- 1. Consulta informacion de los parametros del reporte --->
<cfquery name="rsPrms" datasource="#session.dsn#">
	select 	CRPohabilidad, 	CRPoconocim, 	CRPomision, 	CRPoobj, 		CRPoespecif, CRPoencab, CRPoubicacion, CRPepie,
			CRPehabilidad, 	CRPeconocim, 	CRPemision, 	CRPeobjetivo,	CRPeespecif, CRPeencab, CRPeubicacion, CRPeini,
			 CRPoPuntajes,		coalesce(CRPiPuntajes,0) as CRPiPuntajes,CRPePuntajes, 
		 	coalesce(CRPihabilidad,0) as CRPihabilidad, 	
			coalesce(CRPiconocimi,0) as CRPiconocimi, 	
			coalesce(CRPimision,0) as CRPimision, 	
			coalesce(CRPiobj,0) as CRPiobj, 	
			coalesce(CRPiespecif,0) as CRPiespecif, 	
			coalesce(CRPiencab,0) as CRPiencab, 	
			coalesce(CRPiubicacion ,0) as CRPiubicacion ,
			coalesce(CRPipie ,0) as CRPipie,
			CRPoHAY,coalesce(CRPiHAY ,0) as CRPiHAY,CRPeHAY
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
<cfif isdefined("RSTipo") and len(trim(RSTipo.Modo)) and RSTipo.Modo eq 'P'>
	<cfquery name="rsUltimaAprob" datasource="#session.dsn#">
		select max(RHDPPid) as RHDPPid from RHDescripPuestoP
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		and Estado    = 50
	</cfquery>
	<cfif rsUltimaAprob.recordCount GT 0 and len(trim(rsUltimaAprob.RHDPPid))>

	
		<cfquery name="rsQry" datasource="#session.dsn#">
			select  a.RHPdescpuesto as puesto, coalesce(a.RHPcodigoext,a.RHPcodigo) as codpuesto,
					b.RHTPdescripcion as tipoPuesto,b.RHTinfo as  informacionTipo, 
					c.RHDPmision as mision, 
					
					<cfif isdefined('url.CFid') and len(trim(url.CFid))>
						y.RHDPCFresp as objetivos,
					<cfelse>
						c.RHDPobjetivos as objetivos,  
					</cfif>
					
					
					c.RHDPespecificaciones as especificaciones,
					a.BMfecha,a.BMfechamod,coalesce(a.BMusuario,-1) BMusuario,coalesce(a.BMusumod,-1) as BMusumod,UsuarioJefeCF,FechaModJefeCF,
					UsuarioJefeAsesor,FechaModJefeAsesor,a.ptsTotal
			from RHPuestos a 
				left outer join RHTPuestos b
					on a.RHTPid = b.RHTPid 
				left outer join RHDescriptivoPuesto c
				  	on a.RHPcodigo = c.RHPcodigo and 
					a.Ecodigo = c.Ecodigo 
				inner join RHDescripPuestoP x
					on  a.RHPcodigo = x.RHPcodigo 
					and a.Ecodigo   = x.Ecodigo 
					and x.RHDPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUltimaAprob.RHDPPid#">

				<cfif isdefined('url.CFid') and len(trim(url.CFid))>
					left outer join RHDescriptivoPuestoCF y
						on y.RHPcodigo = a.RHPcodigo
						and y.CFid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
				</cfif>		
					
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		</cfquery>
		
	<cfelse>
		<cfquery name="rsQry" datasource="#session.dsn#">
			select  a.RHPdescpuesto as puesto, coalesce(a.RHPcodigoext,a.RHPcodigo) as codpuesto,
					b.RHTPdescripcion as tipoPuesto,b.RHTinfo as  informacionTipo, 
					c.RHDPmision as mision, 
					
					<cfif isdefined('url.CFid') and len(trim(url.CFid))>
						x.RHDPCFresp as objetivos,
					<cfelse>
						c.RHDPobjetivos as objetivos, 
					</cfif>
					
					
					c.RHDPespecificaciones as especificaciones,
					a.BMfecha,a.BMfechamod,coalesce(a.BMusuario,-1) BMusuario,coalesce(a.BMusumod,-1) as BMusumod,a.ptsTotal
			from RHPuestos a 
				left outer join RHTPuestos b
			  		on a.RHTPid = b.RHTPid 
				left outer join RHDescriptivoPuesto c
			  		on a.RHPcodigo = c.RHPcodigo 
					and a.Ecodigo = c.Ecodigo 
				<cfif isdefined('url.CFid') and len(trim(url.CFid))>
					left outer join RHDescriptivoPuestoCF x
						on x.RHPcodigo = a.RHPcodigo
						and x.CFid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
				</cfif>	
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
		</cfquery>			
	</cfif>
<cfelse>
	<cfquery name="rsQry" datasource="#session.dsn#">
		select  a.RHPdescpuesto as puesto, coalesce(a.RHPcodigoext,a.RHPcodigo) as codpuesto,
				b.RHTPdescripcion as tipoPuesto,b.RHTinfo as  informacionTipo, 
				c.RHDPmision as mision, 
				
				<cfif isdefined('url.CFid') and len(trim(url.CFid))>
					x.RHDPCFresp as objetivos,
				<cfelse>
					c.RHDPobjetivos as objetivos, 
				</cfif>
				
				c.RHDPespecificaciones as especificaciones,
				a.BMfecha,a.BMfechamod,coalesce(a.BMusuario,-1) BMusuario,coalesce(a.BMusumod,-1) as BMusumod,a.ptsTotal
		from RHPuestos a 
			left outer join RHTPuestos b
		  		on a.RHTPid = b.RHTPid 
			left outer join RHDescriptivoPuesto c
		  		on a.RHPcodigo = c.RHPcodigo 
				and a.Ecodigo = c.Ecodigo 
			<cfif isdefined('url.CFid') and len(trim(url.CFid))>
				left outer join RHDescriptivoPuestoCF x
					on x.RHPcodigo = a.RHPcodigo
					and x.CFid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
			</cfif>		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	</cfquery>
		
</cfif>	

	<!--- Valida que la consulta del Puesto obtenga resultados --->
	<cfif rsQry.RecordCount eq 0>
		<strong>
		<cf_translate key="MSG_PuestoInvalidoParaMostrarElReporte">Puesto inv&aacute;lido para mostrar el reporte</cf_translate>.</strong>
		<cfabort>
	<cfelse>
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec" />
		<cfset dataUsuario = sec.getUsuarioByCodNoEmp(rsQry.BMusuario,'DatosEmpleado') >
		<cfset dataUsuarioMod = sec.getUsuarioByCodNoEmp(rsQry.BMusumod, 'DatosEmpleado') >
		<cfif isdefined("rsQry.UsuarioJefeCF") and len(trim(rsQry.UsuarioJefeCF))>
			<cfset dataUsuarioJefeCF 	= sec.getUsuarioByCodNoEmp(rsQry.UsuarioJefeCF, 'DatosEmpleado') >
		</cfif>	
		<cfif isdefined("rsQry.UsuarioJefeAsesor") and len(trim(rsQry.UsuarioJefeAsesor))>
			<cfset dataUsuarioJefeAsesor 	= sec.getUsuarioByCodNoEmp(rsQry.UsuarioJefeAsesor,'DatosEmpleado') >
		</cfif>				
	</cfif>
	

<!--- 3. Consulta informacin de niveles utilizados en las habilidades requeridas del puesto --->

<cfquery name="rsNivelesUHab" datasource="#session.dsn#">
	select distinct RHNcodigo, RHNdescripcion,RHNequivalencia 
	from RHNiveles a, RHHabilidades b, RHHabilidadesPuesto c, RHPuestos d
	where a.RHNid = c.RHNid
	  and b.RHHid = c.RHHid
	  and c.RHPcodigo = d.RHPcodigo
	  and c.Ecodigo = d.Ecodigo
	  and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and d.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	  order by RHNequivalencia desc
</cfquery>

<!---  3.1 Consulta de items por habilidad requerida por el puesto --->
<cfquery name="rsItemsHab" datasource="#session.dsn#">
	select distinct c.RHIHid,RHIHorden
	from RHIHabilidad a, RHHabilidades b, RHHabilidadesPuesto c, RHPuestos d
	where a.RHIHid = c.RHIHid
	  and b.RHHid = c.RHHid
	  and c.RHPcodigo = d.RHPcodigo
	  and c.Ecodigo = d.Ecodigo
	  and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and d.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	  order by RHIHorden desc
</cfquery>


<!--- 4. Consulta habilidades requeridas por el puesto --->
<!---<cfquery name="rsHabilidades" datasource="#session.dsn#">
	select a.RHNcodigo, b.RHHdescripcion,RHNequivalencia,RHIHorden,RHIHdescripcion
	from RHNiveles a, RHHabilidades b, RHHabilidadesPuesto c, RHPuestos d, RHIHabilidad e
	where a.RHNid = c.RHNid
	and b.RHHid = c.RHHid
	and c.RHPcodigo = d.RHPcodigo
	and c.Ecodigo = d.Ecodigo
	and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and d.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	and e.RHHid = c.RHHid
	and e.RHIHid = c.RHIHid
	 order by RHNequivalencia desc
</cfquery>--->
<cfquery name="rsHabilidades" datasource="#session.dsn#">
	Select a.RHNcodigo, b.RHHdescripcion,RHNequivalencia,e.RHIHorden,e.RHIHdescripcion
	from RHNiveles a
	    inner join RHHabilidades b
            on a.Ecodigo=b.Ecodigo
        inner join  RHHabilidadesPuesto c     
            on a.RHNid = c.RHNid
            and b.RHHid = c.RHHid
        inner join  RHPuestos d
            on c.RHPcodigo = d.RHPcodigo
            and c.Ecodigo = d.Ecodigo
            and d.Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
        	and d.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
       left join RHIHabilidad e     
            on e.RHHid = c.RHHid
         	and e.RHIHid = c.RHIHid
	 order by RHNequivalencia desc
</cfquery>

<!--- 5. Consulta informacin de niveles utilizados en los conocimientos requeridas del puesto --->
<cfquery name="rsNivelesUCon" datasource="#session.dsn#">
	select distinct RHNcodigo, RHNdescripcion,RHNequivalencia
	from RHNiveles a, RHConocimientos b, RHConocimientosPuesto c, RHPuestos d
	where a.RHNid = c.RHNid
	and coalesce(b.RHCinactivo,0) = 0 
	and b.RHCid = c.RHCid
	and c.RHPcodigo = d.RHPcodigo
	and c.Ecodigo = d.Ecodigo
	and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and d.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	
	 order by RHNequivalencia desc
</cfquery>

<!--- 6. Consulta conocimientos requeridos por el puesto --->
<cfquery name="rsConocimientos" datasource="#session.dsn#">
	select a.RHNcodigo, b.RHCdescripcion,RHNequivalencia
	from RHNiveles a, RHConocimientos b, RHConocimientosPuesto c, RHPuestos d
	where a.RHNid = c.RHNid
	and b.RHCid = c.RHCid
	and coalesce(b.RHCinactivo,0) = 0 <!------>
	and c.RHPcodigo = d.RHPcodigo
	and c.Ecodigo = d.Ecodigo
	and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and d.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	
	 order by RHNequivalencia desc
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
	from 		RHValoresPuesto a, RHECatalogosGenerales b, RHDCatalogosGenerales c
	where 		a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
	and 		a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and 		a.RHECGid = b.RHECGid
	and 		a.RHDCGid = c.RHDCGid
	and 		b.RHECGid = c.RHECGid
	order by	b.RHECGcodigo, c.RHDCGcodigo
</cfquery>

<!---- 8. Consulta de los datos variables (Especificaciones)--->
<cfquery name="rsDatosVariablesP" datasource="#session.dsn#">
	select 	a.RHDVPorden, a.RHPcodigo, a.RHDDVlinea, a.RHEDVid,
			b.RHEDVcodigo, b. RHEDVdescripcion, 
			c.RHDDVcodigo, c.RHDDVdescripcion
	from RHDVPuesto a
		left outer join RHEDatosVariables b
			on a.RHEDVid = b. RHEDVid
			and a.Ecodigo = b.Ecodigo
		left outer join RHDDatosVariables c
			on a.RHDDVlinea = c.RHDDVlinea
			and a.Ecodigo = c.Ecodigo
	where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#"> 
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by a.RHDVPorden
</cfquery>


<cfquery name="rsDatosVariables1" datasource="#session.dsn#">
	select 	a.RHDDVlinea, a.RHEDVid,a.RHDDVvalor
	from RHDVPuesto a
	where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#"> 
	and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and a.RHDDVvalor is not null

	union

	select 	a.RHDDVlinea, a.RHEDVid,c.RHDDVvalor 
	from RHDVPuesto a
		left outer join RHDDatosVariables c
		on a.RHDDVlinea = c.RHDDVlinea
		and a.Ecodigo = c.Ecodigo
	where a.RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#"> 
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and a.RHDDVvalor is null
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

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_PuntosHAY"
	Default="Puntos HAY"
	returnvariable="LB_PuntosHAY"/>


<cfset Kini = 1>
<cfset Khabilidad = 2>
<cfset Kconocim = 3>
<cfset Kmision = 4>
<cfset Kobj = 5>
<cfset Kespecif = 6>
<cfset Kencab = 7>
<cfset Kubicacion = 8>
<cfset KPuntosHAY = 9>
<cfset KResponsables = 10>
<cfset Kpuntajes = 11>

<cfset myQuery = QueryNew("llave, orden, etiqueta, mostrar")>
<cfset newRow = QueryAddRow(MyQuery, 11)>
<cfset temp = QuerySetCell(myQuery, "llave", Kini, 1)>
<!--- <cfset temp = QuerySetCell(myQuery, "orden", 1, 1)> --->
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
<!--- <cfif isdefined("url.imprimir")> --->
<cfset temp = QuerySetCell(myQuery, "llave", KPuntosHAY, 9)>
<cfset temp = QuerySetCell(myQuery, "orden", rsPrms.CRPOHAY, 9)>
<cfset temp = QuerySetCell(myQuery, "mostrar", rsPrms.CRPIHAY, 9)>
<cfset temp = QuerySetCell(myQuery, "etiqueta", rsPrms.CRPEHAY, 9)>

<cfset temp = QuerySetCell(myQuery, "llave", KResponsables, 10)>
<cfset temp = QuerySetCell(myQuery, "orden", 'rsPrms.CRPeubicacion', 10)>
<cfset temp = QuerySetCell(myQuery, "mostrar", 1, 10)>
<cfset temp = QuerySetCell(myQuery, "etiqueta", LB_ResponsablesYAprobacion, 10)>

<cfset temp = QuerySetCell(myQuery, "llave", Kpuntajes, 11)>
<cfset temp = QuerySetCell(myQuery, "orden", 'rsPrms.CRPoPuntajes', 11)>
<cfset temp = QuerySetCell(myQuery, "mostrar", rsPrms.CRPiPuntajes, 11)>
<cfset temp = QuerySetCell(myQuery, "etiqueta", rsPrms.CRPePuntajes, 11)>
<!--- </cfif> --->

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
	<!--- <cfif isdefined("url.imprimir")> --->
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
			<cfcase value="10"><cfset result = 'X'></cfcase>
			<cfcase value="11"><cfset result = 'XI'></cfcase>
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

<cfif REFind('soinasp01_negro.css',session.sitio.CSS)>
	<style>
		*{ color:#FFFFFF;}
	</style>
</cfif>
<!--- <cfsavecontent variable="string"> --->
<!---IMPRIME EN FLASH PAPER O ADOBE--->
<cfif isdefined('form.formato') and form.formato NEQ 'HTML'>
<cfdocument format="#form.formato#" 
			marginleft="2" 
			marginright="2" 
			marginbottom="3"
			margintop="1" 
			unit="cm" 
            pagetype="letter" >
	<cfdocumentitem type="footer">
		<table border="0" align="center" cellpadding="0" cellspacing="0" width="100%">
		 
		 <tr>
			<td align="left"  style="font-size:23px; font-family: Times New Roman; font-weight: normal;">
				<cfif rsPrms.CRPipie eq 1>
					<cfoutput>#rsPrms.CRPepie#</cfoutput>
				</cfif>
			</td>
			<td align="right" valing="top"  style="font-size:18px; font-family: Times New Roman; font-weight: normal;">
<!--- <cfoutput><cf_translate key="LB_Pagina">P&aacute;gina</cf_translate>#cfdocument.currentpagenumber# <cf_translate key="LB_De">de</cf_translate>#cfdocument.totalpagecount#</cfoutput> --->
			</td>
		  </tr>
	  </table>
	</cfdocumentitem>
	<table border="0" align="center" cellpadding="2" cellspacing="2" width="100%">
	
		<tr>
			<td width="10%">&nbsp;</td>
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
				<td colspan="3" style="font-family: Times New Roman; font-size: 20px; font-style: italic;	font-weight: bold; text-transform: uppercase; list-style-type: upper-roman;">&nbsp;</td>
				<td>&nbsp;</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
				<td colspan="3" style="font-family: Times New Roman; font-size: 20px; font-style: italic;	font-weight: bold; text-transform: uppercase; list-style-type: upper-roman;">
					<cfoutput>#fnRoman(CurrentRow)#. #Ucase(etiqueta)#</cfoutput>
				</td>
				<td>&nbsp;</td>
			</tr>
	  	<tr>
		<td>&nbsp;</td>
			<td colspan="1">
		  			<cfswitch expression="#llave#">
					<cfcase value="1"><!--- Kini --->
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  			<tr>
								<td  nowrap width="20%" style="font-family: Times New Roman; font-size: 18px; font-style: normal; font-weight: bold;">
									<cf_translate key="LB_TipoPuesto">Tipo Puesto</cf_translate>								</td>
								<td width="80%" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<cfif len(trim(rsQry.tipoPuesto)) gt 0>
										<cfoutput>#rsQry.tipoPuesto#</cfoutput><span style="font-family: Times New Roman; font-size: 20px; font-style: italic;	font-weight: bold; text-transform: uppercase; list-style-type: upper-roman;">.
										<cfoutput>#fnRoman(CurrentRow)#. #Ucase(etiqueta)#</cfoutput></span>
									<cfelse>No se ha definido.
									</cfif>								
								</td>				
				  			</tr>
						</table>
					</cfcase> 
					<cfcase value="2"><!--- Khabilidad --->
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<!---<td width="60">&nbsp;</td>	--->							
								<td colspan="0" nowrap width="20%" valign="top" 
								style="font-family: Times New Roman; font-size: 18px; font-style: normal; font-weight: bold;">
									<cf_translate key="LB_Niveles">Niveles</cf_translate>
							  	</td>
								<td nowrap width="80%" valign="top" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0">
										<cfif rsNivelesUHab.RecordCount gt 0>
											<cfloop query="rsNivelesUHab">
												<tr>
													<td style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
														<cfoutput>#RHNcodigo# - #RHNdescripcion#</cfoutput>
													</td>
												</tr>
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

							<tr><td colspan="2">&nbsp;</td></tr>
						<cfif rsHabilidades.RecordCount>
								<tr>
									<td nowrap colspan="3">
										<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td nowrap width="20%" style="font-family: Times New Roman;	font-size: 18px; font-style: italic; font-weight: bold;">
													<cf_translate key="LB_Nivel">Nivel</cf_translate>
												</td>
												<td nowrap width="80%"  style="font-family: Times New Roman;font-size: 18px;font-style: italic; font-weight: bold;">
													<cf_translate key="LB_Habilidad">Habilidad</cf_translate>
												</td>
											</tr>
											
											<cfloop query="rsHabilidades">
												<cfoutput>
													<tr>
														<td nowrap width="20%" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;" valign="top">#RHNcodigo#</td>
														<td nowrap width="80%"  style="font-family: Times New Roman; font-size: 18px; font-weight: normal;" valign="top">#RHHdescripcion#</td>
													</tr>
													<tr>											
														<td width="20%" >&nbsp;</td>
														<cfif len(trim(RHIHdescripcion)) GT 0>	
														<td width="80%" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
														<strong><cf_translate key="LB_Item">Item</cf_translate></strong>
														   #RHIHorden#&nbsp;-&nbsp;#RHIHdescripcion#
														</td>
														</cfif>
													</tr>
												</cfoutput>
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
								<!---<td width="5%">&nbsp;</td>--->
								<td nowrap width="20%" valign="top" style="font-family: Times New Roman;font-size: 18px;font-style: normal;font-weight: bold;">
									<cf_translate key="LB_Niveles">Niveles</cf_translate>
								</td>
								<td nowrap valign="top" width="80%"  style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="left">
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
										<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0">
											<tr>
												<td width="20%" nowrap style="font-family: Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;">
													<cf_translate key="LB_Nivel">Nivel</cf_translate>
												</td>
												<td width="80%" nowrap style="font-family: Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;">
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
							<tr><td width="5%">&nbsp;</td>
								<td width="95%" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<cfoutput><cfif len(trim(rsQry.mision)) gt 0>#(rsQry.mision)#<cfelse><cf_translate key="LB_NoSeHaDefinido">No se ha definido</cf_translate></cfif></cfoutput>
								</td>
						  	</tr>
						</table>
					</cfcase>
					<cfcase value="5"><!--- Kobj --->
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<!---<td width="10%">4444&nbsp;</td>--->
								<td width="90%" colspan="2">
									<cfoutput><cfif len(trim(rsQry.objetivos)) gt 0>#(rsQry.objetivos)#<cfelse><cfif isdefined('url.CFid') and len(trim(url.CFid))><cf_translate key="LB_NoSeHanDefinidoParaCentroFuncionalSeleccionado">No se ha definido para el Centro Funcional seleccionado</cf_translate><cfelse><cf_translate key="LB_NoSeHaDefinido">No se ha definido</cf_translate></cfif></cfif></cfoutput>
								</td>
						  	</tr>
						</table>					
					
					
						<!--- <table width="799"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td width="60">&nbsp;</td>
								<td width="738" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
									<cfoutput><cfif len(trim(rsQry.objetivos)) gt 0>#(rsQry.objetivos)#<cfelse><cf_translate key="LB_NoSeHaDefinido">No se ha definido</cf_translate></cfif></cfoutput>
								</td>
						  	</tr>
						</table> --->
					</cfcase>
					<cfcase value="6"><!--- Kespecif --->
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<cfoutput>
								<cfset corte = ''>
								<cfloop query="rsDatosVariables">
									<cfif corte neq rsDatosVariables.RHEDVid>
										<tr>
											<td width="10%">&nbsp;</td>
											<td width="90%" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">#rsDatosVariables.RHEDVdescripcion#</td>
										</tr>
									</cfif>
									<tr>
										<td width="10%">&nbsp;</td>	
										<td width="90%" style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">#rsDatosVariables.RHDDVvalor#<br></td>
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
							  			<td width="10%">&nbsp;</td>	
							 			<td width="90%">
											<table width="100%"  border="0" cellspacing="0" cellpadding="0">
												<cfif corteval neq rsValores.RHECGcodigo[i]>
													<cfset contador = contador + 1>
													<tr>
														<td width="90%" style="font-family: Times New Roman; font-size: 18px; font-style: normal; font-weight: bold;list-style-type: decimal;">
															<cfif contador gt 1>
																<br>
															</cfif>
															#contador#.&nbsp;#rsValores.RHECGdescripcion[i]#
														</td>
													</tr>
													<cfset corteval =rsValores.RHECGcodigo[i]>
												</cfif>
												<tr>
													<td width="60%"  style="font-family: Times New Roman; font-size: 18px; font-weight: normal;">
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
					<cfcase value="9"><!--- HAY --->
						<table width="100%"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">
										&nbsp;&nbsp;&nbsp;Puntos HAY:&nbsp;&nbsp;<cfoutput>#rsQry.ptsTotal#</cfoutput>
									</td>
							</tr>
							</table>
					</cfcase>
					
					<cfcase value="10"><!--- KResponsables --->
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
								<cfif isdefined("RSTipo") and len(trim(RSTipo.Modo)) and RSTipo.Modo eq 'P'>
									<tr>
										<td colspan="2" style="font-family:  Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;text-decoration: underline;list-style-type: decimal;">
											Aprobaci&oacute;n DH
										</td>
									</tr>
									<tr>
										<td colspan="1" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Puesto:</td>
										<td>
										<cfif isdefined("dataUsuarioJefeAsesor") and dataUsuarioJefeAsesor.RecordCount gt 0>
											<cfquery name="RSPuestojefe" datasource="#session.DSN#">
												select RHPdescpuesto  from 	LineaTiempo a
												inner join RHPlazas b
													on a.Ecodigo = b.Ecodigo
													and a.RHPid = b.RHPid
												inner join RHPuestos c
													on 	b.Ecodigo = c.Ecodigo
													and b.RHPpuesto = c.RHPcodigo 
												where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#dataUsuarioJefeAsesor.llave#">
												and <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp"> between  LTdesde and LThasta
											</cfquery>
											<cfif isdefined("RSPuestojefe") and RSPuestojefe.RecordCount gt 0>
												#RSPuestojefe.RHPdescpuesto#
											</cfif>
										</cfif>
										</td>
									</tr>
									<tr>
										<td colspan="1" style="font-family:  Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;list-style-type: decimal;">Nombre:</td>
										<td>
											<cfif isdefined("dataUsuarioJefeAsesor") and dataUsuarioJefeAsesor.RecordCount gt 0>
												#dataUsuarioJefeAsesor.Pnombre# #dataUsuarioJefeAsesor.Papellido1# #dataUsuarioJefeAsesor.Papellido2#
											</cfif>
										</td>
									</tr>
									<tr><td colspan="2" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Firma:</td></tr>
									<tr>																	
										<td colspan="1" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Fecha:</td>
										<td style="font-family: Times New Roman;font-size: 18px;font-weight: normal;"><cfif isdefined("dataUsuarioJefeAsesor")>#LSDateFormat(rsQry.FechaModJefeAsesor,'dd/mm/yyyy')#</cfif></td> 
									</tr>
									<tr><td>&nbsp;</td></tr>
									<tr>
										<td colspan="2" style="font-family:  Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;text-decoration: underline;list-style-type: decimal;">
											Aprobaci&oacute;n Area
										</td>
									</tr>
									<tr>
										<td colspan="1" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Puesto:</td>
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
										<td colspan="1" style="font-family:  Times New Roman;font-size: 18px;font-style: italic;font-weight: bold;list-style-type: decimal;">Nombre:</td>
										<td> 
										<cfif isdefined("dataUsuarioJefeCF") and dataUsuarioJefeCF.RecordCount gt 0>
											#dataUsuarioJefeCF.Pnombre# #dataUsuarioJefeCF.Papellido1# #dataUsuarioJefeCF.Papellido2#
										</cfif>
										
									</td>
									</tr>
									<tr><td colspan="2" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Firma:</td></tr>
									<tr>
										<td colspan="1" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">&nbsp;&nbsp;&nbsp;Fecha:</td>
										<td style="font-family: Times New Roman;font-size: 18px;font-weight: normal;"><cfif isdefined("dataUsuarioJefeCF")>#LSDateFormat(rsQry.FechaModJefeCF,'dd/mm/yyyy')#</cfif></td> 
									</tr>
								</cfif>
								
								
								
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
					</cfcase> <!------>
					<cfcase value="11"><!--- KResponsables --->
						<cfquery name="rsPuestoV" datasource="#session.dsn#">
							select  sum(RHSVFpuntos) as pts,  sum(RHSVFpuntosPropuesta) ptsP 
							from RHSValoracionFactores a
							inner join  RHDValoracionFactores b
							on a.RHDVFid=b.RHDVFid 
							and RHPcodigo='0101'
							group by a.RHDVFid
						</cfquery>
							<table width="100%"  border="0" cellspacing="0" cellpadding="0">
								<tr>
									<td width="25%" style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">Puntaje de Puesto:</td>
									<cfoutput><td align="left">#LSNumberFormat(rsPuestoV.pts,"0.00")#</td></cfoutput>
								</tr>
							</table>
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
<!---IMPRESION HTML--->
<cfelse>
	<table border="0" align="center" cellpadding="0" cellspacing="0" width="800" >
		<tr>
			<td colspan="5">
				<table  id="tablabotones" width="100%" cellpadding="0" cellspacing="0" border="0" >
					<tr>
						<td align="right" nowrap>
							<input  style="font-size:9px" type="button"  id="Imprimir" name="Imprimir" value="Imprimir" onClick="imprimir();">
						</td>
					</tr>
					<tr><td><hr></td></tr>
				</table>			
			</td>
	  	</tr>

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
										<table width="598" align="center" border="0" cellspacing="0" cellpadding="3">
											<tr>
												<td nowrap style="font-family: Times New Roman;	font-size: 18px; font-style: italic; font-weight: bold;">
													<cf_translate key="LB_Nivel">Nivel</cf_translate>
												</td>
												<td nowrap  style="font-family: Times New Roman;font-size: 18px;font-style: italic; font-weight: bold;">
													<cf_translate key="LB_Habilidad">Habilidad</cf_translate>
												</td>
											</tr>
											
											<cfloop query="rsHabilidades">
												<cfoutput>
													<tr>
														<td nowrap style="font-family: Times New Roman; font-size: 18px; font-weight: normal;" valign="top">#RHNcodigo#</td>
														<td nowrap style="font-family: Times New Roman; font-size: 18px; font-weight: normal;" valign="top">#RHHdescripcion#</td>
													</tr>
													<tr>
														<td>&nbsp;</td>
														<td style="font-family: Times New Roman; font-size: 18px; font-weight: normal;"><strong><cf_translate key="LB_Item">Item</cf_translate></strong> #RHIHorden#&nbsp;-&nbsp;#RHIHdescripcion#</td>
													</tr>
												</cfoutput>
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
									<cfoutput><cfif len(trim(rsQry.objetivos)) gt 0>#(rsQry.objetivos)#<cfelse><cfif isdefined('url.CFid') and len(trim(url.CFid))><cf_translate key="LB_NoSeHanDefinidoParaCentroFuncionalSeleccionado">No se ha definido para el Centro Funcional seleccionado</cf_translate><cfelse><cf_translate key="LB_NoSeHaDefinido">No se ha definido</cf_translate></cfif></cfif></cfoutput>
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
					<cfcase value="9"><!--- HAY --->
						<table width="799"  border="0" cellspacing="0" cellpadding="0">
							<tr>
								<td style="font-family: Times New Roman;font-size: 18px;font-weight: bold;font-style: italic;">
										&nbsp;&nbsp;&nbsp;Puntos HAY:&nbsp;&nbsp;<cfoutput>#rsQry.ptsTotal#</cfoutput>
									</td>
							</tr>
							</table>
					</cfcase>
					<cfcase value="10"><!--- KResponsables --->
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
								<cfif isdefined("RSTipo") and len(trim(RSTipo.Modo)) and RSTipo.Modo eq 'P'>
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
								 </cfif>
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
<script language="javascript1.2" type="text/javascript">
	function imprimir() {
		var tablabotones = document.getElementById("tablabotones");
        tablabotones.style.display = 'none';
		window.print()	
        tablabotones.style.display = ''
	}
</script>

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