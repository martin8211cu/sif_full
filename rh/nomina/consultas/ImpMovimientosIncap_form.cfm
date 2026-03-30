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
    select <cf_dbfunction name="to_char" args="de.DESeguroSocial" len="11"> as SeguroSocial,
    		de.DEapellido1, de.DEapellido2, de.DEnombre,b.DEid, de.DEsdi,
            b.DLfvigencia as FechaInicio,
            case a.RHTcomportam
				when 5 then '12'
			end as tipoMovimiento,
            de.DEidentificacion,
            <cf_dbfunction name="to_char" args="b.RHfolio" len="7"> as RHfolio,
			<cf_dbfunction name="datediff" args="b.DLfvigencia, b.DLffin"> + 1 as diasDiferencia
			from RHTipoAccion a
			inner join DLaboralesEmpleado b
				on a.RHTid = b.RHTid
			inner join DatosEmpleado de
				on de.DEid = b.DEid
			<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
			<cfif ValidaOfiOEmp eq "1">
			inner join oficinas o
				on o.Ocodigo = b.Ocodigo
			</cfif>
			<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
			where a.Ecodigo = #session.Ecodigo#
            and a.RHTcomportam in (5)

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
          group by b.DEid,de.DEsdi,de.DESeguroSocial,de.DEapellido1,de.DEapellido2,de.DEnombre,a.RHTcomportam,b.DLfvigencia,b.DLffin,b.RHfolio,de.DEidentificacion
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

			<cfset hilera = hilera & RepeatString("0",11-len(trim(RegistroPatronal))) & '#RegistroPatronal#'>
			<cfset hilera = hilera & RepeatString("0",11-len(trim(SeguroSocial))) & '#SeguroSocial#'>
            <cfset hilera = hilera & '#trim(DEapellido1)#' & RepeatString(" ",27-len(trim(DEapellido1)))>
            <cfset hilera = hilera & '#trim(DEapellido2)#' & RepeatString(" ",27-len(trim(DEapellido2)))>
            <cfset hilera = hilera & '#trim(DEnombre)#' & RepeatString(" ",27-len(trim(DEnombre)))>
            <cfset hilera = hilera & '               '>
            <cfset hilera = hilera & '#DateFormat(FechaInicio,'DDMMYYYY')#'& RepeatString(" ", 8-len(trim(DateFormat(FechaInicio,'DDMMYYYY'))))>
            <cfset hilera = hilera & '     '>
			<cfset hilera = hilera & RepeatString("0",2-len(trim(tipoMovimiento)))&'#tipoMovimiento#'>
			<cfset hilera = hilera & '00000'> <!---NÃºmero de GuÃ­a--->
            <cfset hilera = hilera & RepeatString(" ",5-len(trim(DEidentificacion))) & '#trim(DEidentificacion)#'>
            <cfset hilera = hilera & '     '>
            <cfset hilera = hilera & '1'> <!---Numero de Folio--->
            <cfset hilera = hilera & '                  '>
            <cfset hilera = hilera & RepeatString("0",8-len(trim(RHfolio))) & '#trim(RHfolio)#'>
            <cfset hilera = hilera & RepeatString("0",2-len(trim(diasDiferencia))) & '#trim(diasDiferencia)#'>


		<!----Reemplazar caracteres no validos----->
			<!--- <cfset hilera = REReplaceNoCase(hilera,'Ã?','A',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã‰','E',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã?','I',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã“','O',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ãš','U',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã‘','N',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ãœ','U',"all")> --->
			<cfset hilera = Ucase(hilera)>

			<cfset linea = linea + 1 >
		</cfloop>
        	 <cfset linea = linea-1>
             <cfset hilera = hilera & '#chr(13)##chr(10)#'>
             <cfset hilera = hilera & '*************                                           '>
             <cfset hilera = hilera & RepeatString("0",6-len('#linea#')) & '#linea#'>
             <cfset hilera = hilera & '                                                                       00000                             '>

	</cffunction>
	<cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'Mov')>
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">
	<cfheader name="Content-Disposition" value="attachment;filename=ImpMovIncapacidades.dat">
	<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">