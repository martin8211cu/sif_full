<!---<cfdump var="#form#">--->
<cfif isdefined("url.Periodo") and len(trim(url.Periodo))>
	<cfset form.Periodo = url.Periodo>
</cfif>
<cfif isdefined("url.Mes") and len(trim(url.Mes))>
	<cfset form.Mes = url.Mes>
</cfif>
<cfif isdefined("url.TDid") and len(trim(url.TDid))>
	<cfset form.TDid = url.TDid>
</cfif>

<cfset vs_tablaCalculo = 'HRCalculoNomina'>
<cfset vs_tablaDeducciones = 'HDeduccionesCalculo'>

<!-----==========================================================================================--->
<!----==================================== CONSULTAS  ==========================================---->
<!-----==========================================================================================--->
<!----TABLA TEMPORAL DE TRABAJO---->
<cf_dbtemp name="TEMPAcciones" returnvariable="TMPAccionesX" datasource="#session.DSN#">
	<cf_dbtempcol name="DLlinea"		type="numeric"  	mandatory="yes">
	<cf_dbtempcol name="DEid"			type="numeric"  	mandatory="no">
	<cf_dbtempcol name="DEidentificacion"	type="varchar(80)"	mandatory="no">
	<cf_dbtempcol name="RHTNoMuestraCS"	type="int"			mandatory="no">
	
	<cf_dbtempcol name="NombreCompleto"	type="varchar(80)"	mandatory="no">
	
	<cf_dbtempcol name="RHTid"			type="numeric"  	mandatory="no">
	<cf_dbtempcol name="DesTipoAccion"	type="varchar(255)"	mandatory="no">
	
	<cf_dbtempcol name="DLfvigencia"    type="datetime"	    mandatory="no">
	<cf_dbtempcol name="DLffin"         type="datetime"	    mandatory="no">
	<cf_dbtempcol name="DLfechaaplic"   type="datetime"	    mandatory="no">
	
	<cf_dbtempcol name="DLobs"   		type="varchar(255)"	mandatory="no">
	
	<cf_dbtempcol name="RHPid"			type="numeric" 		mandatory="no">
	<cf_dbtempcol name="DesPlaza"		type="varchar(60)"	mandatory="no">
	<cf_dbtempcol name="RHPidant"		type="numeric" 		mandatory="no">
	<cf_dbtempcol name="DesPlazaAnt"	type="varchar(60)"	mandatory="no">
	
	<cf_dbtempcol name="RHPCodigo"		type="char(10)" 	mandatory="no">
	<cf_dbtempcol name="DesPuesto"		type="varchar(60)"	mandatory="no">
	<cf_dbtempcol name="RHPCodigoant"	type="char(10)" 	mandatory="no">
	<cf_dbtempcol name="DesPuestoAnt"	type="varchar(60)"	mandatory="no">
	
	<cf_dbtempcol name="Tcodigo"		type="char(5)"  	mandatory="no">
	<cf_dbtempcol name="DesTnomina"		type="varchar(60)"	mandatory="no">
	<cf_dbtempcol name="Tcodigoant"		type="char(5)"  	mandatory="no">
	<cf_dbtempcol name="DesTNominaAnt"	type="varchar(60)"	mandatory="no">
	
	<cf_dbtempcol name="RVid"			type="numeric" 		mandatory="no">
	<cf_dbtempcol name="DesRegVac"		type="varchar(60)"	mandatory="no">
	<cf_dbtempcol name="RVidant"		type="numeric" 		mandatory="no">
	<cf_dbtempcol name="DesRegVacAnt"	type="varchar(60)"	mandatory="no">
	
	<cf_dbtempcol name="Dcodigo"        type="int"	    	mandatory="no">
	<cf_dbtempcol name="DesDepar"		type="varchar(60)"	mandatory="no">
	<cf_dbtempcol name="Dcodigoant"     type="int"	    	mandatory="no">
	<cf_dbtempcol name="DesDeparAnt"	type="varchar(60)"	mandatory="no">
		
	<cf_dbtempcol name="Ocodigo"        type="int"	    	mandatory="no">
	<cf_dbtempcol name="DesOficina"		type="varchar(60)"	mandatory="no">
	<cf_dbtempcol name="Ocodigoant"     type="int"	    	mandatory="no">
	<cf_dbtempcol name="DesOficinaAnt"	type="varchar(60)"	mandatory="no">
	
	<cf_dbtempcol name="RHJid"          type="numeric"  	mandatory="no">
	<cf_dbtempcol name="DesJornada"	type="varchar(60)"		mandatory="no">
	<cf_dbtempcol name="RHJidant"       type="numeric"  	mandatory="no">
	<cf_dbtempcol name="DesJornadaAnt"	type="varchar(60)"	mandatory="no">

	<cf_dbtempcol name="DLsalario"      type="money"		mandatory="no">	
	<cf_dbtempcol name="DLsalarioant"   type="money"		mandatory="no">
	
	<cf_dbtempcol name="DLporcsal"      type="float"		mandatory="no">
	<cf_dbtempcol name="DLporcsalant"   type="float"		mandatory="no">   
	
	<cf_dbtempcol name="DLporcplaza"   	type="float"		mandatory="no">   
	<cf_dbtempcol name="DLporcplazaant"	type="float"		mandatory="no">   

</cf_dbtemp>

<!-----==========================================================================================--->

<!--- Averiguar si hay que utilizar la tabla salarial --->
<cfquery name="rsTipoTabla" datasource="#Session.DSN#">
	select CSusatabla
	from ComponentesSalariales
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and CSsalariobase = 1
</cfquery>
<cfif rsTipoTabla.recordCount GT 0>
	<cfset usaEstructuraSalarial = rsTipoTabla.CSusatabla>
<cfelse>
	<cfset usaEstructuraSalarial = 0>
</cfif>

<cfquery name="rsActual" datasource="#Session.DSN#">
	SELECT 	a.DLlinea, 
			a.DLfechaaplic,
			a.DLfvigencia, 
			a.DLffin,
			a.DEid,ab.DEidentificacion,
			<cf_dbfunction name="concat" args="ab.DEnombre,' ',ab.DEapellido1,' ',ab.DEapellido2" > as NombreCompleto,
			a.DLsalario, coalesce(a.DLsalarioant,0) as  DLsalarioant,
			a.DLobs, 
			a.DLporcplaza, 
			coalesce(a.DLporcplazaant,0) as DLporcplazaant,
			a.DLporcsal, 
			coalesce(a.DLporcsalant,0) as DLporcsalant,
			coalesce(c.RHTNoMuestraCS,0) as RHTNoMuestraCS,
			
			rtrim(c.RHTcodigo) as TipoAccion, 
			c.RHTdesc as DesTipoAccion, 
			
			b.Tdescripcion as DesNomina, 
			e.RHPid,coalesce(a.RHPidant,0) as RHPidant,
			e.CFid,
			{fn concat({fn concat(rtrim( coalesce(pp.RHPPcodigo, e.RHPcodigo) ) , ' - ' )},  coalesce(pp.RHPPdescripcion, e.RHPdescripcion) )}  as RHPdescripcion_Plaza, 
			
			coalesce(ltrim(rtrim(f.RHPcodigoext)),ltrim(rtrim(f.RHPcodigo))) as RHPcodigo_Puesto, a.RHPcodigoant,
			f.RHPdescpuesto as DesPuesto, 
			g.Descripcion as RegVacaciones, 
			h.Odescripcion as DesOficina, 
			i.Ddescripcion as DesDepartamento, 
			{fn concat({fn concat(rtrim(j.RHJcodigo) , ' - ' )},  j.RHJdescripcion )} as Jornada,
			a.RHCPlinea,
			s.RHTTid, rtrim(s.RHTTcodigo) as RHTTcodigo, s.RHTTdescripcion, 
			t.RHCid, rtrim(t.RHCcodigo) as RHCcodigo, t.RHCdescripcion, 
			u.RHMPPid, rtrim(u.RHMPPcodigo) as RHMPPcodigo, u.RHMPPdescripcion,
			a.Tcodigo,a.RHJid,
			coalesce(a.RHJidant,0) as RHJidant,
			a.RHTid,a.RVid,
			coalesce(a.RVidant,0) as RVidant,
			a.Dcodigo,
			coalesce(a.Dcodigoant,0) as Dcodigoant, 
			a.Ocodigo,
			coalesce(a.Ocodigoant,0) as Ocodigoant,
			a.Tcodigoant<!-----Como no existe un RHCPlinea anterior, se usa el Tcodigo ant, 
																			para que en los empleados que solo tienen la primera accion de 
																			nombramiento no aparezca la tabla/puesto/categoria de la accion de 
																			nombramiento aplicada------>
	FROM DLaboralesEmpleado a
	
		inner join DatosEmpleado ab 
		on ab.DEid = a.DEid
		
		inner join RHTipoAccion c
		on a.RHTid = c.RHTid
		
		inner join TiposNomina b
		on a.Tcodigo = b.Tcodigo
		and a.Ecodigo = b.Ecodigo
		
		inner join RHPlazas e
		on a.RHPid = e.RHPid
		
		left outer join RHPlazaPresupuestaria pp
		on pp.RHPPid=e.RHPPid
		
		inner join RHPuestos f
		on a.Ecodigo = f.Ecodigo
		and a.RHPcodigo = f.RHPcodigo
		
		inner join RegimenVacaciones g
		on a.RVid = g.RVid
		
		inner join Oficinas h
		on a.Ocodigo = h.Ocodigo
		and a.Ecodigo = h.Ecodigo
		
		inner join Departamentos i
		on a.Dcodigo = i.Dcodigo
		and a.Ecodigo = i.Ecodigo
		
		inner join RHJornadas j
		on a.RHJid = j.RHJid
		and a.Ecodigo = j.Ecodigo
		
		left outer join RHCategoriasPuesto r
			on r.RHCPlinea = a.RHCPlinea
		left outer join RHTTablaSalarial s
			on s.RHTTid = r.RHTTid
		left outer join RHCategoria t
			on t.RHCid = r.RHCid
		left outer join RHMaestroPuestoP u
			on u.RHMPPid = r.RHMPPid
		
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.RHTid#" >
		and a.DLfvigencia between  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#"> and 
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">
		order by a.DLlinea
</cfquery>

<!---
rsActual
<cf_dump var="#rsActual#">
--->

<cfloop query="rsActual">
	<cfquery datasource="#session.DSN#">
		insert into #TMPAccionesX# 
			(DLlinea,
			DEid,
			DEidentificacion,
			NombreCompleto,
			RHTid,
			DesTipoAccion,
			DLfvigencia,
			DLffin,
			DLfechaaplic,
			DLobs,
			RHPid,
			DesPlaza,
			RHPidant,
			DesPlazaAnt,
			RHPCodigo,
			DesPuesto,
			RHPCodigoant,
			DesPuestoAnt,
			Tcodigo,
			DesTnomina,
			Tcodigoant,
			DesTNominaAnt,
			RVid,
			DesRegVac,
			RVidant,
			DesRegVacAnt,
			Dcodigo,
			DesDepar,
			Dcodigoant,
			DesDeparAnt,
			Ocodigo,
			DesOficina,
			Ocodigoant,
			DesOficinaAnt,
			RHJid,
			DesJornada,
			RHJidant,
			DesJornadaAnt,
			DLsalario,
			DLsalarioant,
			DLporcsal,
			DLporcsalant,
			DLporcplaza,
			DLporcplazaant,
			RHTNoMuestraCS			
			) values (
			#rsActual.DLlinea#,
			#rsActual.DEid#,
			'#rsActual.DEidentificacion#',
			'#rsActual.NombreCompleto#',
			#rsActual.RHTid#,
			'#rsActual.DesTipoAccion#',
			'#LSDateFormat(rsActual.DLfvigencia, "mm/dd/yyyy")#', 
			'#LSDateFormat(rsActual.DLffin, "mm/dd/yyyy")#',
			'#LSDateFormat(rsActual.DLfechaaplic, "mm/dd/yyyy")#',
			'#rsActual.DLobs#',
			#rsActual.RHPid#,
			'#rsActual.RHPdescripcion_Plaza#',
			#rsActual.RHPidant#,
			null,
			'#rsActual.RHPcodigo_Puesto#',
			'#rsActual.DesPuesto#',
			'#rsActual.RHPcodigoant#',
			null,
			'#rsActual.Tcodigo#',
			'#rsActual.DesNomina#',
			'#rsActual.Tcodigoant#',
			null,
			#rsActual.RVid#,
			'#rsActual.RegVacaciones#',
			#rsActual.RVidant#,
			null,
			#rsActual.Dcodigo#,
			'#rsActual.DesDepartamento#',
			#rsActual.Dcodigoant#,
			null,
			#rsActual.Ocodigo#,
			'#rsActual.DesOficina#',
			#rsActual.Ocodigoant#,
			null,
			#rsActual.RHJid#,
			'#rsActual.Jornada#',
			#rsActual.RHJidant#,
			null,
			#rsActual.DLsalario#,
			#rsActual.DLsalarioant#,
			#rsActual.DLporcsal#,
			#rsActual.DLporcsalant#,
			#rsActual.DLporcplaza#,
			#rsActual.DLporcplazaant#,
			#rsActual.RHTNoMuestraCS#
			)
	</cfquery>
</cfloop>

<cfquery name="rsAnterior" datasource="#Session.DSN#">
	SELECT a.DLlinea, b2.Tdescripcion as NominaAnterior,
		case when e2.RHPid is not null then {fn concat({fn concat(rtrim(coalesce(pp.RHPPcodigo, e2.RHPcodigo)) , ' - ' )},  coalesce(pp.RHPPdescripcion, e2.RHPdescripcion) )}  else '' end as PlazaAnterior,
		case when f2.RHPcodigo is not null then {fn concat({fn concat(rtrim(coalesce(f2.RHPcodigoext,f2.RHPcodigo)) , ' - ' )},  f2.RHPdescpuesto )}  else '' end as PuestoAnterior,
		g2.Descripcion as RegVacacionesAnterior, 
		h2.Odescripcion as OficinaAnterior, 
		i2.Ddescripcion as DeptoAnterior,
		case when j2.RHJid is not null then {fn concat({fn concat(rtrim(j2.RHJcodigo) , ' - ' )},  j2.RHJdescripcion )}  else '' end as JornadaAnterior,
		a.Tcodigoant			   
	
	FROM DLaboralesEmpleado a
	
		left outer join TiposNomina b2
		on a.Tcodigoant = b2.Tcodigo
		and a.Ecodigoant = b2.Ecodigo
		
		left outer join RHPlazas e2
		on a.RHPidant = e2.RHPid
		
		left outer join RHPlazaPresupuestaria pp
		on pp.RHPPid=e2.RHPPid
		
		left outer join RHPuestos f2
		on a.Ecodigoant = f2.Ecodigo
		and a.RHPcodigoant = f2.RHPcodigo
		
		left outer join RegimenVacaciones g2
		on a.RVidant = g2.RVid
		
		left outer join Oficinas h2
		on a.Ocodigoant = h2.Ocodigo
		and a.Ecodigoant = h2.Ecodigo
		
		left outer join Departamentos i2
		on a.Dcodigoant = i2.Dcodigo
		and a.Ecodigoant = i2.Ecodigo
		
		left outer join RHJornadas j2
		on a.RHJidant = j2.RHJid
		and a.Ecodigoant = j2.Ecodigo
	
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and a.RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#form.RHTid#" >
		and a.DLfvigencia between  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaDesde)#"> and 
		<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.FechaHasta)#">
	
	order by a.DLlinea
</cfquery>

<cfloop query="rsAnterior">
	<cfquery datasource="#session.DSN#">
		update #TMPAccionesX# set 
			DesDeparAnt 	= '#rsAnterior.DeptoAnterior#',
			DesJornadaAnt 	= '#rsAnterior.JornadaAnterior#',
			DesOficinaAnt 	= '#rsAnterior.OficinaAnterior#',
			DesPuestoAnt 	= '#rsAnterior.PuestoAnterior#',
			DesRegVacAnt	= '#rsAnterior.RegVacacionesAnterior#',
			DesTNominaAnt	= '#rsAnterior.NominaAnterior#',
			DesPlazaAnt		= '#rsAnterior.PlazaAnterior#'
		where DLlinea = #rsAnterior.DLlinea#
	</cfquery>
</cfloop>


<!----================ PINTA EL REPORTE ================---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_RecursosHumanos" Default="Recursos Humanos" XmlFile="/rh/generales.xml" returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_ReporteDeDeduccionesNominasAplicadas" Default="Reporte de deducciones n&oacute;minas aplicadas" returnvariable="LB_ReporteDeDeduccionesNominasAplicadas"/>
<cfinclude template="repMasivas-rep.cfm">