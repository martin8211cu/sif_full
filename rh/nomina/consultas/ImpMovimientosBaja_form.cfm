<cfsetting requesttimeout="3600" enablecfoutputonly="yes">
<cfif isdefined ('form.FechaHasta') and len(trim(form.FechaHasta))>
	<cfset LvarFechaFin = DateAdd("d", 1, #dateformat(form.FechaHasta,'dd/mm/yyyy')#)>
	<cfset LvarFechaFin = DateAdd("s", -1, #LvarFechaFin#)>
</cfif>
<!---Registro Patronal IMSS --->
<!--- <cfquery name="rsRegistro" datasource="#session.dsn#"> --->
<!--- 		select <cf_dbfunction name="to_char" args="Pvalor" len="11"> as Pvalor  from RHParametros where Ecodigo = #session.Ecodigo# and Pcodigo = 300 --->
<!--- 	</cfquery> --->
<!---      --->
<!--- 	<cfset RegistroPatronal = #rsRegistro.Pvalor#> --->
<cfset RegistroPatronal = #regPat#><!---Registro Patronal IMSS --->
<cfset ValidaOfiOEmp = #rePatOfi#><!---Con esta variable se si es un registro por ofina o no --->

<cfquery name="rsLista" datasource="#session.dsn#">
    select
		<cf_dbfunction name="to_char" args="de.DESeguroSocial" len="11"> as SeguroSocial,
		de.DEapellido1,
		de.DEapellido2,
		de.DEnombre,
		DateAdd(d,-1,lt.DLfvigencia) as LTdesde,
		a.RHTcomportam,
		<!---
		case a.RHTcomportam
			when 1 then '08'
		end as tipoMovimiento,
		lt.RHfolio as RHfolio,
		--->
		o.ONumGuia,
		de.DEidentificacion,
		lp.RHLPCausa
	from RHTipoAccion a
	inner join DLaboralesEmpleado lt
		on a.RHTid = lt.RHTid
	inner join DatosEmpleado de
		on de.DEid = lt.DEid
          inner join RHLiquidacionPersonal lp
          	on lp.DLlinea = lt.DLlinea
	<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
	inner join Oficinas o
		on o.Ocodigo = lt.Ocodigo
	<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
	where a.Ecodigo = #session.Ecodigo#
          and a.RHTcomportam in (2)
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
          group by lt.DEid,de.DESeguroSocial,de.DEapellido1,de.DEapellido2,de.DEnombre,a.RHTcomportam,lt.DLfvigencia,o.ONumGuia,de.DEidentificacion,lp.RHLPCausa
</cfquery>
<cfset fnprocesaLista(rsLista)>

<cffunction name="fnprocesaLista" access="private" output="false">
	<cfargument name="rsLista" type="query" required="yes">
	<cfset hilera = ''>
	<cfloop query="rsLista">
		<cfif rsLista.currentRow GT 1>
			<cfset hilera &= '#chr(13)##chr(10)#'>
		</cfif>
		<cfset hilera &= RepeatString("0",11-len(trim(RegistroPatronal))) & '#RegistroPatronal#'>
		<cfset hilera &= RepeatString("0",11-len(trim(SeguroSocial))) & '#SeguroSocial#'>
		<cfset hilera &= '#trim(DEapellido1)#' & RepeatString(" ",27-len(trim(DEapellido1)))>
		<cfset hilera &= '#trim(DEapellido2)#' & RepeatString(" ",27-len(trim(DEapellido2)))>
		<cfset hilera &= '#trim(DEnombre)#' & RepeatString(" ",27-len(trim(DEnombre)))>
		<cfset hilera &= '000000000000000'>
		<cfset hilera &= '#DateFormat(LTdesde,'DDMMYYYY')#'& RepeatString(" ", 8-len(trim(DateFormat(LTdesde,'DDMMYYYY'))))>
		<cfset hilera &= '     '>
		<cfset hilera &= '02'><!--- Bajas y/o liquidacion. --->
		<cfset hilera &= RepeatString("0",5-len(trim(ONumGuia))) & '#trim(ONumGuia)#'>
		<cfset hilera &= RepeatString(" ",5-len(trim(DEidentificacion))) & '#trim(DEidentificacion)#'>
		<cfset hilera &= '     '>
		<cfset hilera &= RepeatString(" ",1-len(trim(RHLPCausa))) & '#trim(RHLPCausa)#'>
		<cfset hilera &= '                  ' & '9'>
		<cfset hilera = Ucase(hilera)>
	</cfloop>
</cffunction>

<cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
<cfset txtfile = GetTempFile(getTempDirectory(), 'Mov')>
<cffile action="write" addnewline="no" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">
<cfheader name="Content-Disposition" value="attachment;filename=ImpMovBaja.dat">
<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
