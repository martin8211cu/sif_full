<cfinvoke component="home.Componentes.Seguridad" returnvariable="datosemp"
	method="getUsuarioByCod" tabla="DatosEmpleado" 
	Usucodigo="#session.Usucodigo#" Ecodigo="#session.EcodigoSDC#"
	/>
<cfset DEid = datosemp.llave>
<cfif Len(Trim(DEid)) EQ 0>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_LaAutomatriculaEsExclusivaParaLosEmpleadosDeLaEmpresa"
		Default="La automatrícula es exclusiva para los empleados de la empresa"
		returnvariable="MSG_LaAutomatriculaEsExclusivaParaLosEmpleadosDeLaEmpresa"/>

	<cf_throw message="#MSG_LaAutomatriculaEsExclusivaParaLosEmpleadosDeLaEmpresa#." errorcode="10065">
</cfif>

<cfif form.op eq 'add'>
	<cfquery datasource="#session.dsn#" name="cursos">
		select c.RHCid, c.Mcodigo,
			(	select count(1)
				from RHEmpleadoCurso ec
				where ec.RHCid = c.RHCid
				and ec.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			) as matriculado,
			(c.RHCcupo - (select count(1) from RHEmpleadoCurso ec
				where ec.RHCid = c.RHCid) ) as cupo_disponible
		from RHCursos c
		join RHMateria m
			on m.Mcodigo = c.Mcodigo
		join RHInstitucionesA i
			on i.RHIAid = c.RHIAid
		where c.RHCfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		  and m.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		  and c.RHCautomat = 1
		and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
	</cfquery>
	
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2109" default="" returnvariable="valP"/>
	<cfif cursos.RecordCount>
		<cfif cursos.matriculado eq 0 and cursos.cupo_disponible GT 0>
			<cfquery name="InsertCurso" datasource="#session.dsn#">
				insert into RHEmpleadoCurso (
					DEid, RHCid, Ecodigo, Mcodigo, 
					RHEMnotamin, RHEMnota, RHECtotempresa, RHECtotempleado, 
					idmoneda, RHECcobrar, RHEMestado, 
					BMfecha, BMUsucodigo,RHECestado)
				select
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">, RHCid,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
					c.Mcodigo,
					0 as RHEMnotamin, null as RHEMnota, c.RHECtotempresa, c.RHECtotempleado, 
					c.idmoneda, c.RHECcobrar, 0 as RHEMestado, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					<cfif isdefined('valP') and valP gt 0>
						10
					<cfelse>
						null
					</cfif>
					
				from RHCursos c
				inner join RHMateria m
					on m.Mcodigo = c.Mcodigo
				where c.RHCid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#cursos.RHCid#">
				  and m.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			</cfquery>
			
		<cfelseif cursos.cupo_disponible LTE 0>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_EsteCursoNoTieneCupoDisponible"
				Default="Este curso no tiene cupo disponible"
				returnvariable="MSG_EsteCursoNoTieneCupoDisponible"/>
		
			<cf_throw message="#MSG_EsteCursoNoTieneCupoDisponible#" errorcode="10070">
		</cfif>
	<cfelse>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_EsteCursoNoSePuedeAutomatricular"
			Default="Este curso no se puede automatricular"
			returnvariable="MSG_EsteCursoNoSePuedeAutomatricular"/>
	
		<cf_throw message="#MSG_EsteCursoNoSePuedeAutomatricular#" errorcode="10075">
	</cfif>
<cfelseif form.op eq 'del'>
	<!--- validar que sea desmatriculable, y desmatricular --->


	<cfquery datasource="#session.dsn#" name="cursos">
		select c.RHCid,
				(
					case when c.RHCautomat = 1
						and ec.RHEMestado = 0
						and not exists (select 1 from RHRelacionCap rc, RHDRelacionCap rd
							where rc.RHCid = c.RHCid
							  and rc.RHRCestado = 40
							  and rc.RHRCid = rd.RHRCid
							  and rd.DEid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
						) 
					then 1
					else 0 end
				) as removible
		from RHCursos c
		inner join RHMateria m
			on c.Mcodigo = m.Mcodigo
			and m.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
		join RHEmpleadoCurso ec
			on ec.RHCid = c.RHCid
			  and ec.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#"> 
		where c.RHCfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
		  and c.RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHCid#">
	</cfquery>
	<cfif cursos.removible EQ 1>
		<cfquery datasource="#session.dsn#">
			delete from RHEmpleadoCurso
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			  and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#cursos.RHCid#">
			  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
	<cfelseif cursos.RecordCount And Not cursos.removible>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_EsteCursoNoSePuedeDesmatricular"
			Default="Este curso no se puede desmatricular"
			returnvariable="MSG_EsteCursoNoSePuedeDesmatricular"/>
		<cf_throw message="#MSG_EsteCursoNoSePuedeDesmatricular#" errorcode="10080">
	</cfif>
</cfif>
<cfif isdefined("form.AUT")>
	<cflocation url="pantalla.cfm">
<cfelse>
	<cflocation url=".">
</cfif>

