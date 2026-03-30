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
			<cf_dbfunction name="to_char" args="de.DESeguroSocial" len="11"> as SeguroSocial,de.DEapellido1, de.DEapellido2, de.DEnombre,
			lt.DLfvigencia as LTdesde,a.RHTcomportam, lt.DLsalario, de.DEtiposalario,et.TEid,de.CURP,
			(select top 1 RHHmonto from RHHistoricoSDI where RHHfuente = 1  and DEid = de.DEid order by RHHfecha desc) as DEsdi,
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
          group by lt.DEid,de.DESeguroSocial,de.DEapellido1,de.DEapellido2,de.DEnombre,a.RHTcomportam,lt.DLfvigencia,de.DEidentificacion,
			DEtiposalario,de.CURP,lt.DLsalario,et.TEid,de.DEsdi,j.RHJJornadaIMSS,o.ONumGuia,de.DEid
	</cfquery>
	<cfset fnprocesaLista(rsLista)>
	<cffunction name="fnprocesaLista" access="private" output="false">
		<cfargument name="rsLista" type="query" required="yes">
		<cfset hilera = ''>
		<cfloop query="rsLista">

			<cfif rsLista.currentRow gt 1>
				<cfset hilera &= '#chr(13)##chr(10)#'>
			</cfif>
			<cfset hilera &= RepeatString("0",11-len(trim(RegistroPatronal))) & '#RegistroPatronal#'>
			<cfset hilera &= RepeatString("0",11-len(trim(SeguroSocial))) & '#SeguroSocial#'>
            <cfset hilera &= '#trim(DEapellido1)#' & RepeatString(" ",27-len(trim(DEapellido1)))>
            <cfset hilera &= '#trim(DEapellido2)#' & RepeatString(" ",27-len(trim(DEapellido2)))>
            <cfset hilera &= '#trim(DEnombre)#' & RepeatString(" ",27-len(trim(DEnombre)))>
			<cfset hilera &= RepeatString("0",6-len(replace(replace(LSCurrencyformat(DEsdi,'none'),'.',''),",",''))) & '#replace(replace(LSCurrencyformat(DEsdi,'none'),'.',''),",",'')#'>
            <!--- <cfset hilera &= RepeatString("0",6-len(replace(replace(LSCurrencyformat(DEsdi,'none'),'.',''),",",''))) & '#replace(replace(LSCurrencyformat(DEsdi,'none'),'.',''),",",'')#'> ---><!---Salario Infonavit--->
			<cfset hilera &= RepeatString("0",6)>
            <cfset hilera &= RepeatString(" ",1-len(trim(TEid))) & '#trim(TEid)#'>
            <cfset hilera &= RepeatString(" ",1-len(trim(DEtiposalario))) & '#trim(DEtiposalario)#'>
            <cfset hilera &= '#trim(RHJJornadaIMSS)#'><!--- Semana o Jornada Reducida--->
            <cfset hilera &= '#DateFormat(LTdesde,'DDMMYYYY')#'& RepeatString(" ", 8-len(trim(DateFormat(LTdesde,'DDMMYYYY'))))>
            <cfset hilera &= '000'><!---UMF--->
            <cfset hilera &= '  '><!--- Relleno --->
			<cfset hilera &= RepeatString("0",2-len(trim(tipoMovimiento)))&'#tipoMovimiento#'>
			<cfset hilera &= '#ONumGuia#'><!--- Numero de guia --- Se da por hecho que siempre trae 5 caracteres, ya se valido en catalogo. --->
            <cfset hilera &= RepeatString(" ",5-len(trim(DEidentificacion))) & '#trim(DEidentificacion)#'>
            <cfset hilera &= '     '>
            <cfset hilera &= ' '>
            <cfset hilera &= RepeatString(" ",18-len(trim(CURP))) & '#trim(CURP)#'>
           	<cfset hilera &= '9'>


		<!----Reemplazar caracteres no validos----->
			<!--- <cfset hilera = REReplaceNoCase(hilera,'Ã?','A',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã‰','E',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã?','I',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã“','O',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ãš','U',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã‘','N',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ãœ','U',"all")> --->

		</cfloop>
		<!--- <cfset hilera = left(hilera,(rsLista.RecordCount * 168))> --->
        	<!---  <cfset linea = linea-1>
             <cfset hilera &= '#chr(13)##chr(10)#'>
             <cfset hilera &= '*************                                           '>
             <cfset hilera &= RepeatString("0",6-len('#linea#')) & '#linea#'>
             <cfset hilera &= '                                                                       00000                             9'> --->
	</cffunction>
	<cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'Mov')>
	<cffile action="write" addNewLine="no" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">
	<cfheader name="Content-Disposition" value="attachment;filename=ImpMovReingreso.dat">
	<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
