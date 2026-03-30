<!---
	  OPARRALES 19-07-2017
 --->
<cfsetting requesttimeout="3600" enablecfoutputonly="yes">
	<cfif isdefined ('form.FechaHasta') and len(trim(form.FechaHasta))>
		<cfset LvarFechaFin = DateAdd("d", 1, #dateformat(form.FechaHasta,'dd/mm/yyyy')#)>
		<cfset LvarFechaFin = DateAdd("s", -1, #LvarFechaFin#)>
	</cfif>

	<cfset RegistroPatronal = #regPat#><!---Registro Patronal IMSS --->
	<cfset ValidaOfiOEmp = #rePatOfi#><!---Con esta variable se si es un registro por ofina o no --->

	<!--- <cfquery name="rsLista" datasource="#session.dsn#">
    select
			<cf_dbfunction name="to_char" args="de.DESeguroSocial" len="11"> as SeguroSocial,de.DEapellido1, de.DEapellido2, de.DEnombre,
			lt.DLfvigencia as LTdesde,a.RHTcomportam, lt.DLsalario, de.DEtiposalario,et.TEid,de.CURP,de.DEsdi,
			case a.RHTcomportam
				when 1 then '08' end
				as tipoMovimiento,
			 de.DEidentificacion,j.RHJJornadaIMSS,o.ONumGuia
			from RHTipoAccion a
			inner join DLaboralesEmpleado lt
				on a.RHTid = lt.RHTid
			inner join RHJornadas j on j.RHJid = lt.RHJid
			inner join DatosEmpleado de
				on de.DEid = lt.DEid
            left join EmpleadosTipo et
            	on et.DEid =lt.DEid
			<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
			inner join Oficinas o
				on o.Ocodigo = lt.Ocodigo
			<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
			where a.Ecodigo = #session.Ecodigo#
            and a.RHTcomportam in (1)
          <cfif ValidaOfiOEmp eq "1">
				and o.Onumpatronal = '#RegistroPatronal#'
		  </cfif>
		  <cfif isdefined("form.FechaHasta") and len(trim(form.FechaHasta)) and not isdefined ("form.FechaDesde")>
					 and lt.DLfvigencia <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FechaHasta)#">
		  <cfelseif isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) and not isdefined ("form.FechaHasta")>
					 and lt.DLfvigencia >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FechaDesde)#">
		  <cfelseif isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta))>
				and lt.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FechaDesde)#"> and #(LvarFechaFin)#
		  </cfif>
          group by lt.DEid,de.DESeguroSocial,de.DEapellido1,de.DEapellido2,de.DEnombre,a.RHTcomportam,lt.DLfvigencia,de.DEidentificacion,DEtiposalario,de.CURP,lt.DLsalario,et.TEid,de.DEsdi,j.RHJJornadaIMSS,o.ONumGuia
	</cfquery> --->

	<!---
		fuente:
			0 indefinido
			1 Automatico (Proceso interno que afecte SDI) ej. Accion de Nombramiento (Comportamiento = 1)
			2 Manual (SDI Bimestral)
			3 SDI por Aniversario
			4 Accion de Aumento (comportamiento = 6)
	--->
	<cfquery name="rsLista" datasource="#session.dsn#">
		select
			de.DEid,
			de.DEidentificacion,
			de.DEnombre,
			de.DEapellido1,
			de.DEapellido2,
			hh.RHHmonto,
			de.DEtiposalario,
			de.CURP,
			de.DEidentificacion,
			<cf_dbfunction name="to_char" args="de.DESeguroSocial" len="11"> as SeguroSocial,
			max(hh.RHHfecha) as ultimo
		from
			RHHistoricoSDI hh,
			DatosEmpleado de
		where
			hh.DEid = de.DEid
		and hh.RHHfuente = #form.TIPOCAMBIOS#<!--- Cambio salarial(Accion de aumento,Aniversario,SDI Bimestral) --->

		and hh.RHHfecha between  <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FechaDesde)#">
		and  <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FECHAHASTA)#">
		group by
			de.DEid,
			de.DEidentificacion,
			de.DEnombre,
			de.DEapellido1,
			de.DEapellido2,
			hh.RHHmonto,
			de.DEtiposalario,
			de.CURP,
			de.DEidentificacion,
			<cf_dbfunction name="to_char" args="de.DESeguroSocial" len="11">
	</cfquery>
	<cfset fnprocesaLista(rsLista)>
	<cffunction name="fnprocesaLista" access="private" output="false">
		<cfargument name="rsLista" type="query" required="yes">
		<cfset hilera = ''>
		<cfset rCount = 1>
		<cfloop query="rsLista">
			<!--- Buscamos la relacion del Empleado con Oficinas y Jornadas laborales
				  respecto a su ultima accion de nombramiento.
			 --->
			<cfquery name="rsExtrasXAlta" datasource="#session.dsn#">
				select top 1
					dle.DLfvigencia,
					o.Ocodigo,
					j.RHJJornadaIMSS,
					o.ONumGuia
				from
					DLaboralesEmpleado dle,
					RHJornadas j,
					RHTipoAccion ta,
					Oficinas o
				where
					dle.RHJid = j.RHJid
				and ta.RHTid = dle.RHTid
				<cfif ValidaOfiOEmp eq "1">
					and o.Onumpatronal = '#RegistroPatronal#'
		  		</cfif>
				and o.Ocodigo = dle.Ocodigo
				and ta.RHTcomportam = 1
				and	dle.Ecodigo = #session.Ecodigo#
				and	dle.DEid = #rsLista.DEid#
				order by DLfvigencia desc
			</cfquery>
			<cfif rsExtrasXAlta.RecordCount eq 0>
			<cfcontinue>
			</cfif>

			<cfif rCount gt 1>
				<cfset hilera &= '#chr(13)##chr(10)#'>
			</cfif>
			<cfset hilera &= RepeatString("0",11-len(trim(RegistroPatronal))) & '#RegistroPatronal#'>
			<cfset hilera &= RepeatString("0",11-len(trim(SeguroSocial))) & '#SeguroSocial#'>
            <cfset hilera &= '#trim(DEapellido1)#' & RepeatString(" ",27-len(trim(DEapellido1)))>
            <cfset hilera &= '#trim(DEapellido2)#' & RepeatString(" ",27-len(trim(DEapellido2)))>
            <cfset hilera &= '#trim(DEnombre)#' & RepeatString(" ",27-len(trim(DEnombre)))>
			<cfset hilera &= RepeatString("0",6-len(replace(replace(LSCurrencyformat(RHHmonto,'none'),'.',''),",",''))) & '#replace(replace(LSCurrencyformat(RHHmonto,'none'),'.',''),",",'')#'>
            <!--- <cfset hilera &= RepeatString("0",6-len(replace(replace(LSCurrencyformat(DEsdi,'none'),'.',''),",",''))) & '#replace(replace(LSCurrencyformat(DEsdi,'none'),'.',''),",",'')#'> ---><!---Salario Infonavit--->
			<cfset hilera &= RepeatString("0",6)>
            <cfset hilera &= RepeatString(" ",1-len(trim('0'))) & '#trim("0")#'>
            <cfset hilera &= RepeatString(" ",1-len(trim(DEtiposalario))) & '#trim(DEtiposalario)#'>
            <cfset hilera &= '#trim(rsExtrasXAlta.RHJJornadaIMSS)#'><!--- Semana o Jornada Reducida--->
            <cfset hilera &= '#DateFormat(ultimo,'DDMMYYYY')#'& RepeatString(" ", 8-len(trim(DateFormat(rsExtrasXAlta.DLfvigencia,'DDMMYYYY'))))>
            <cfset hilera &= '000'><!---UMF--->
            <cfset hilera &= '00'><!--- Relleno --->
			<cfset hilera &= RepeatString("0",2-len(trim('07')))&'#"07"#'>
			<cfset hilera &= '#rsExtrasXAlta.ONumGuia#'><!--- Numero de guia --- Se da por hecho que siempre trae 5 caracteres, ya se valido en catalogo. --->
            <cfset hilera &= RepeatString(" ",5-len(trim(DEidentificacion))) & '#trim(DEidentificacion)#'>
            <cfset hilera &= '     '>
            <cfset hilera &= ' '>
            <cfset hilera &= RepeatString(" ",18-len(trim(CURP))) & '#trim(CURP)#'>
           	<cfset hilera &= '9'>
			<cfset rCount++>
		</cfloop>
	</cffunction>
<cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
<cfset txtfile = GetTempFile(getTempDirectory(), 'Mov')>
<cffile action="write" addNewLine="no" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">
<cfheader name="Content-Disposition" value="attachment;filename=ImpMovModifSal.dat">
<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">