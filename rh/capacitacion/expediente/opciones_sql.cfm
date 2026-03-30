
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

<cfif form.op eq 'del'>
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

<cfoutput>
	<script language="javascript" type="text/javascript">
		document.location.href = "expediente.cfm?DEid=#form.DEid#&tab=#form.tab#&pagenum=#form.pagenum#";
	</script>
</cfoutput>


