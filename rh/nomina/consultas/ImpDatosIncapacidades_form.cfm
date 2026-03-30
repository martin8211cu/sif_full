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

	<cfquery name="rsLista" datasource="#session.dsn#">
		select
			a.Ecodigo,b.DLlinea,b.DEid,
			<cf_dbfunction name="datediff" args="b.DLfvigencia, b.DLffin">+1 as diasDiferencia,
			b.RHItiporiesgo,
			a.RHTsubcomportam,
			<cf_dbfunction name="to_char" args="de.DESeguroSocial" len="11"> as SeguroSocial,
			b.DLfvigencia as FechaInicio,
			<cf_dbfunction name="to_char" args="b.RHfolio" len="8"> as folio,
			<cf_dbfunction name="to_char" args="b.RHporcimss" len="3"> as RHporcimss,
			b.RHItiporiesgo,
			b.RHIconsecuencia,
			b.RHIcontrolincapacidad,
			b.DLffin as FechaFin
		 from RHTipoAccion a
			inner join DLaboralesEmpleado b
				on a.RHTid = b.RHTid
			inner join DatosEmpleado de
				on de.DEid = b.DEid
			<!---left outer join DEmpleado em
				on em.DEid = de.DEid
					and em.DIEMtipo = 0--->
			inner join LineaTiempo lt
				on a.RHTid = lt.RHTid
			<!--- esto es mi c�digo +++++++++++++++++++++++++++++++++++++++++++ --->
			<cfif ValidaOfiOEmp eq "1">
				inner join oficinas o
					on o.Ocodigo = b.Ocodigo
			</cfif>
			<!--- esto es mi c�digo +++++++++++++++++++++++++++++++++++++++++++ --->

			where a.RHTcomportam = 5
				and a.Ecodigo = #session.Ecodigo#
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
		  and DLlinea = ( select max(DLlinea) from DLaboralesEmpleado lab
					where lab.DEid = lt.DEid and lab.RHTid = lt.RHTid
					and lab.DLfvigencia = lt.LTdesde and lab.DLffin = lt.LThasta)
	</cfquery>

<cfset fnprocesaLista(rsLista)>
	<cffunction name="fnprocesaLista" access="private" output="false">
		<cfargument name="rsLista" type="query" required="yes">
		<cfset hilera = ''>
		<cfset linea = 1>

		<cfloop query="rsLista">

			<cfif linea GT 1>
				<cfset hilera = hilera & '#chr(13)##chr(10)#'>
			</cfif>
			<cfset hilera = hilera & RepeatString("0",11-len(trim(RegistroPatronal)))&'#RegistroPatronal#'>
			<cfset hilera = hilera & RepeatString("0",11-len(trim(SeguroSocial)))&'#SeguroSocial#'>
			<cfset hilera = hilera & RepeatString("0",1)><!---Default 0 (tipo de incidencia)---->
			<cfset hilera = hilera & '#DateFormat(FechaInicio,'DDMMYYYY')#'& RepeatString(" ", 8-len(trim(DateFormat(FechaInicio,'DDMMYYYY'))))>
			<cfset hilera = hilera & '#trim(folio)#' &RepeatString("0", 8-len(trim(folio)))>
			<cfset hilera = hilera & RepeatString("0", 3-len(trim(diasDiferencia)))&'#diasDiferencia#' >
			<cfset hilera = hilera & RepeatString("0", 3-len(trim(RHporcimss))) & '#RHporcimss#'>
			<cfset hilera = hilera & RepeatString("0",1-len(trim(RHTsubcomportam)))&'#RHTsubcomportam#'>
			<cfset hilera = hilera & '#RHItiporiesgo#' &RepeatString(" ", 1-len(trim(RHItiporiesgo)))>
			<cfset hilera = hilera & '#RHIconsecuencia#' &RepeatString(" ", 1-len(trim(RHIconsecuencia)))>
			<cfset hilera = hilera & '#RHIcontrolincapacidad#' &RepeatString(" ", 1-len(trim(RHIcontrolincapacidad)))>
			<cfset hilera = hilera & '#DateFormat(FechaFin,'DDMMYYYY')#'& RepeatString(" ", 8-len(trim(DateFormat(FechaFin,'DDMMYYYY'))))>

		<!----Reemplazar caracteres no validos----->
			<!--- <cfset hilera = REReplaceNoCase(hilera,'�?','A',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'É','E',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'�?','I',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ó','O',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ú','U',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ñ','N',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ü','U',"all")> --->
			<cfset hilera = Ucase(hilera)>

			<cfset linea = 2>
		</cfloop>
	</cffunction>
	<cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'DatInc')>
	<cffile action="write" addnewline="false" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">
	<cfheader name="Content-Disposition" value="attachment;filename=DatosIncapacidades.txt">
	<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
