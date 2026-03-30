<cfsetting requesttimeout="3600" enablecfoutputonly="yes">
	<cfif isdefined ('form.FechaHasta') and len(trim(form.FechaHasta))>
		<cfset LvarFechaFin = DateAdd("d", 1, #dateformat(form.FechaHasta,'dd/mm/yyyy')#)>
		<cfset LvarFechaFin = DateAdd("s", -1, #LvarFechaFin#)>
	</cfif>

	<!---Registro Patronal IMSS --->
	<!--- <cfquery name="rsRegistro" datasource="#session.dsn#"> --->
<!--- 		select <cf_dbfunction name="to_char" args="Pvalor" len="11"> as Pvalor  from RHParametros where Ecodigo = #session.Ecodigo# and Pcodigo = 300 --->
<!--- 	</cfquery> --->
<!--- 	<cfset RegistroPatronal = #rsRegistro.Pvalor#> --->

	<cfset RegistroPatronal = #regPat#> <!---Registro Patronal IMSS --->
	<cfset ValidaOfiOEmp = #rePatOfi#> <!---Con esta variable se si es un registro por ofina o no --->

<!---
		select
			p.RHPdescpuesto as Ocupacion,
			de.DESeguroSocial  as SeguroSocial,
			dg1.DGcodigoPostal as CodigoPostal,
			de.DEfechanac as FechaNacimiento,
			dg.DGDescripcion as Lugarnacimiento,
			dg.DGcodigo as ClaveLugarNacimiento,
			de.DEdato5 as UnidadMedicinaFamiliar,
			de.DEdato1 as TipoSalario,
			de.DEsexo as Sexo,
			em.DGid
			from RHTipoAccion a
			inner join DLaboralesEmpleado b
				on a.RHTid = b.RHTid
			inner join  RHPlazas pl
				on pl.RHPid = b.RHPid
			inner join  RHPuestos p
				on ltrim(rtrim(p.RHPcodigoext))  = ltrim(rtrim(pl.RHPcodigo))
				and p.Ecodigo = pl.Ecodigo
			inner join DatosEmpleado de
				on de.DEid = b.DEid
			left outer join DEmpleado em
				on em.DEid = de.DEid
				and em.DIEMtipo = 0
				and em.DEid = (select max(DEid) from LineaTiempo t  where t.Ecodigo = 5 and t.RHPid =  pl.RHPid)
			left outer join asp..DistribucionGeografica  dg1
				on dg1.DGid  = em.DGid

			left outer join DEmpleado emn
				on emn.DEid = de.DEid
				and emn.DIEMtipo = 1
				and emn.DEid = (select max(DEid) from LineaTiempo t  where t.Ecodigo = 5 and t.RHPid =  pl.RHPid)
			left outer join asp..DistribucionGeografica  dg
				on dg.DGid  = emn.DGid
			where a.RHTcomportam = 1
		  			and b.DLfvigencia between '20000101' and '20100101'
--->
	<cfquery name="rsLista" datasource="#session.dsn#">
		select
			<cf_dbfunction name="to_char" args="p.RHPdescpuesto" len="12"> as Ocupacion,
			<cf_dbfunction name="to_char" args="de.DESeguroSocial" len="11"> as SeguroSocial,
			dg1.DGcodigoPostal as CodigoPostal,
			dg1.DGid,
			de.DEnombre,DEapellido1,DEapellido2,
			de.DEfechanac as FechaNacimiento,
			<cf_dbfunction name="to_char" args="dg.DGDescripcion" len="25">  as Lugarnacimiento,
			coalesce(dg.DGcodigo,'00') as ClaveLugarNacimiento,
			<cf_dbfunction name="to_char" args="de.DEdato5" len="3"> as UnidadMedicinaFamiliar,	<!-----primeras 3 posiciones--->
			<!---<cf_dbfunction name="to_char" args="de.DEdato1" len="1">---> de.DEtiposalario as TipoSalario,
			de.DEsexo as Sexo
			from RHTipoAccion a
			inner join DLaboralesEmpleado b
				on a.RHTid = b.RHTid
			<!---inner join  RHPlazas pl
				on pl.RHPid = b.RHPid--->
			<!--- esto es mi c�digo +++++++++++++++++++++++++++++++++++++++++++ --->
			<cfif ValidaOfiOEmp eq "1">
			inner join oficinas o
				on o.Ocodigo = b.Ocodigo
			</cfif>
			<!--- esto es mi c�digo +++++++++++++++++++++++++++++++++++++++++++ --->
			inner join  RHPuestos p
				on ltrim(rtrim(p.RHPcodigo))  = ltrim(rtrim(b.RHPcodigo))
				and p.Ecodigo = b.Ecodigo
			inner join DatosEmpleado de
				on de.DEid = b.DEid
				and de.Ecodigo = #session.Ecodigo#
			left outer join DEmpleado em 	<!------direcciones del empleado--->
				on em.DEid = de.DEid
				and em.DIEMtipo = 0 		<!----- direccion de residencia 1 nacimiento--->
				<!---and em.DEid = (select max(DEid) from LineaTiempo t
									where t.Ecodigo = #session.Ecodigo#  and t.RHPid =  pl.RHPid)---><!-----session.Ecodigo--->
			left outer join <cf_dbdatabase table="DistribucionGeografica" datasource="asp"> as dg1
				on dg1.DGid  = em.DGid
			left outer join DEmpleado emn
				on emn.DEid = de.DEid
				and emn.DIEMtipo = 1
				<!---and emn.DEid = (select max(DEid) from LineaTiempo t  where t.Ecodigo = #session.Ecodigo# and t.RHPid =  pl.RHPid)--->
			left outer join <cf_dbdatabase table="DistribucionGeografica" datasource="asp"> as dg
				on dg.DGid  = emn.DGid
			where a.RHTcomportam = 1
			<cfif ValidaOfiOEmp eq "1">
				and o.Onumpatronal = '#RegistroPatronal#'
			</cfif>
		  <cfif isdefined("form.FechaHasta") and len(trim(form.FechaHasta)) and not isdefined ("form.FechaDesde")>
					 and b.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FechaHasta)#">
		  <cfelseif isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) and not isdefined ("form.FechaHasta")>
					 and b.DLfvigencia >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FechaDesde)#">
		  <cfelseif isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta))>
				and b.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FechaDesde)#"> and #(LvarFechaFin)#
		  </cfif>
	</cfquery>

	<cffunction name="getNivel" access="private" output="false">
		<cfargument name="NGid" type="numeric" required="yes">
		<cfargument name="DGid" type="numeric" required="yes">

		<cfquery name="unDGTmp" datasource="asp">
			select * from DistribucionGeografica
			where DGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DGid#">
		</cfquery>

		<cfif unDGTmp.NGid eq Arguments.NGid>
			<cfset codEntidad = unDGTmp.DGcodigoPostal>
			<cfset descEstado = unDGTmp.DGDescripcion>
		<cfelse>
			<cfset getNivel(NGid=#Arguments.NGid#,DGid=#unDGTmp.DGidPadre#)>
		</cfif>
	</cffunction>

<cfset fnprocesaLista(rsLista)>
	<cffunction name="fnprocesaLista" access="private" output="false">
		<cfargument name="rsLista" type="query" required="yes">
		<cfset hilera = ''>
		<cfset linea = 1>

		<!--- OPARRALES 2018-11-08 Validamos que el empleado tenga configurado un NivelGeografico --->
		<cfif rsLista.DGid eq ''>
			<cfthrow message="Distribucion Geografica: " detail="El empleado #rsLista.DENOMBRE# #rsLista.DEAPELLIDO1# #rsLista.DEAPELLIDO2# no tiene configurada una Distribucion Geografica.">
		</cfif>

		<cfloop query="rsLista">

			<cfset codEntidad = ''>
			<cfset descEstado = ''>
			<cfquery datasource="asp" name="rsEstado">
				select NGid from NivelGeografico
				where NGidPadre = (select NGid from NivelGeografico where NGidPadre is null)
			</cfquery>

			<cfset getNivel(NGid=#rsEstado.NGid#,DGid=#rsLista.DGid#)>

			<cfif len(codEntidad) gt 2>
				<cfthrow message="El codigo de la entidad es mayor a dos caracteres." detail="Empleado: #DEnombre# #DEapellido1# #DEapellido2#">
			</cfif>
			<cfif len(descEstado) eq 0>
				<cfthrow message="No existe una descripcion para el estado." detail="Empleado: #DEnombre# #DEapellido1# #DEapellido2#">
			<cfelse>
				<cfset descEstado = lcase(descEstado)>
				<cfset descEstado = replace(#descEstado#,"á","a","ALL")>
		        <cfset descEstado = replace(#descEstado#,"é","e","ALL")>
		        <cfset descEstado = replace(#descEstado#,"í","i","ALL")>
		        <cfset descEstado = replace(#descEstado#,"ó","o","ALL")>
		        <cfset descEstado = replace(#descEstado#,"ú","u","ALL")>
		        <cfset descEstado = replace(#descEstado#,"ü","u","ALL")>
		        <cfset descEstado = ucase(descEstado)>
			</cfif>

			<cfif linea GT 1>
				<cfset hilera = hilera & '#chr(13)##chr(10)#'>
			</cfif>
			<cfset hilera = hilera & RepeatString("0",11-len(trim(RegistroPatronal)))&'#RegistroPatronal#'>
			<cfset hilera = hilera & RepeatString("0",11-len(trim(SeguroSocial)))&'#SeguroSocial#'>
			<cfset hilera = hilera & '#trim(CodigoPostal)#'&RepeatString(" ", 5-len(trim(CodigoPostal)))>
			<cfset hilera = hilera & '#DateFormat(FechaNacimiento,'DDMMYYYY')#'& RepeatString(" ", 8-len(trim(DateFormat(FechaNacimiento,'DDMMYYYY'))))>
			<cfset hilera = hilera & '#trim(descEstado)#' &RepeatString(" ", 25-len(trim(descEstado)))>
			<cfset hilera = hilera & RepeatString("0",2-len(trim(codEntidad)))&'#trim(codEntidad)#'>
			<cfset miUMF = '000'>
			<cfif trim(UnidadMedicinaFamiliar) neq ''>
				<cfset miUMF = #UnidadMedicinaFamiliar#>
			</cfif>
			<cfset hilera = hilera & '#miUMF#'>
			<cfset hilera = hilera & '#trim(Ocupacion)#'& RepeatString(" ", 12-len(trim(Ocupacion)))>
			<cfset hilera = hilera & '#trim(Sexo)#'>
			<cfset hilera = hilera & '#trim(TipoSalario)#'& RepeatString(" ", 1-len(trim(TipoSalario)))>
			<cfset hilera = hilera & ' '>

		<!----Reemplazar caracteres no validos----->
		<!--- <cfset hilera = REReplaceNoCase(hilera,'Á?','A',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'É','E',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Í?','I',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ó','O',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ú','U',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ñ','N',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ü','U',"all")> --->
			<cfset hilera = Ucase(hilera)>

			<cfset linea = 2>

		</cfloop>
	</cffunction>

	<cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'DatAfi')>
	<cffile action="write" addNewLine="no" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">
	<cfheader name="Content-Disposition" value="attachment;filename=DatosAfiliatorios.txt">
	<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">