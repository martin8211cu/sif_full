<cfsetting requesttimeout="3600" enablecfoutputonly="yes">
	<cfif isdefined ('form.FechaHasta') and len(trim(form.FechaHasta))>
		<cfset LvarFechaFin = DateAdd("d", 1, #dateformat(form.FechaHasta,'dd/mm/yyyy')#)>
		<cfset LvarFechaFin = DateAdd("s", -1, #LvarFechaFin#)>
	</cfif>

	<!--- Se crea una tabla temporal en la base de datos --->
    <cf_dbtemp name="RHSUAMovimientos" returnvariable="RHSUAMovimientos">
		<cf_dbtempcol name="DEid"   			type="numeric"      	mandatory="yes">
		<cf_dbtempcol name="SeguroSocial" 		type="char(11)"     	mandatory="no">
		<cf_dbtempcol name="RHTcomportam" 		type="numeric"  		mandatory="no">
		<cf_dbtempcol name="tipoMovimiento" 	type="char(2)"     		mandatory="no">
        <cf_dbtempcol name="LTdesde" 			type="datetime"     	mandatory="no">
        <cf_dbtempcol name="RHfolio" 			type="char(8)"     		mandatory="no">
        <cf_dbtempcol name="diasIncidencia" 	type="numeric"     		mandatory="no">
        <cf_dbtempcol name="salarioDiario" 		type="money"     		mandatory="no">
	</cf_dbtemp>

	<!---Solo obtiene el Registro Patronal IMSS --->
	<!--- <cfquery name="rsRegistro" datasource="#session.dsn#"> --->
<!--- 		select <cf_dbfunction name="to_char" args="Pvalor" len="11"> as Pvalor from RHParametros where Ecodigo = #session.Ecodigo# and Pcodigo = 300 --->
<!---  	</cfquery> --->
<!---  	<cfset RegistroPatronal = #rsRegistro.Pvalor#> --->

	<cfset RegistroPatronal = #regPat#>
	<cfset ValidaOfiOEmp = #rePatOfi#> <!---Con esta variable se si es un registro por ofina o no --->

	<cfquery datasource="#session.dsn#">
    insert into #RHSUAMovimientos#(DEid,SeguroSocial,RHTcomportam,tipoMovimiento,LTdesde,RHfolio,diasIncidencia,salarioDiario)
    select lt.DEid,
			<cf_dbfunction name="to_char" args="de.DESeguroSocial" len="11"> as SeguroSocial,
			a.RHTcomportam,
			case a.RHTcomportam
				when 2 then '02'
				when 8 then '07'
				when 1 then '08'
				when 13 then '11'
				when 5 then '12'
			end as tipoMovimiento,
			lt.DLfvigencia as LTdesde,
			lt.RHfolio as RHfolio,
			<cf_dbfunction name="datediff" args="lt.DLfvigencia, lt.DLffin">+1 as diasIncidencia,
			de.DEsdi as salarioDiario
			from RHTipoAccion a
			inner join DLaboralesEmpleado lt
				on a.RHTid = lt.RHTid
			inner join DatosEmpleado de
				on de.DEid = lt.DEid
			<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
			<cfif ValidaOfiOEmp eq "1">
			inner join oficinas o
				on o.Ocodigo = lt.Ocodigo
			</cfif>
			<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
			where a.Ecodigo = #session.Ecodigo#
            and a.RHTcomportam in (2,1,5,13)
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
          group by lt.DEid,de.DESeguroSocial,a.RHTcomportam,lt.DLfvigencia,lt.RHfolio,lt.DLffin,de.DEsdi
		<!---select
			<cf_dbfunction name="to_char" args="de.DESeguroSocial" len="11"> as SeguroSocial,
			a.RHTcomportam,
			case a.RHTcomportam
				when 2 then '02'
				when 8 then '07'
				when 1 then '08'
				when 13 then '11'
				when 5 then '12'
				when 13 then '11'
			end as tipoMovimiento,
			lt.LTdesde,
			<!---(select RHfolio from DLaboralesEmpleado lab
				where lab.DEid = lt.DEid and lab.RHTid = lt.RHTid
				and lab.DLfvigencia = lt.LTdesde and lab.DLffin = lt.LThasta
			and DLlinea = ( select max(DLlinea) from DLaboralesEmpleado lab
				where lab.DEid = lt.DEid and lab.RHTid = lt.RHTid
				and lab.DLfvigencia = lt.LTdesde and lab.DLffin = lt.LThasta)
			)---> as RHfolio,
			<cf_dbfunction name="datediff" args="lt.LTdesde, lt.LThasta">+1 as diasIncidencia,
			de.DEsdi <cf_dbfunction name="to_number" args="de.DEsdi" dec="2"> as salarioDiario
			from RHTipoAccion a
			inner join LineaTiempo lt
				on a.RHTid = lt.RHTid
			inner join DatosEmpleado de
				on de.DEid = lt.DEid
			where a.Ecodigo = #session.Ecodigo#
            and a.RHTcomportam in (2,8,1,13,5)
            <!---and de.DESeguroSocial = '67735313933'--->
		  <cfif isdefined("form.FechaHasta") and len(trim(form.FechaHasta)) and not isdefined ("form.FechaDesde")>
					 and lt.LTdesde <= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FechaHasta)#">
		  <cfelseif isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) and not isdefined ("form.FechaHasta")>
					 and lt.LTdesde >= <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FechaDesde)#">
		  <cfelseif isdefined("form.FechaDesde") and len(trim(form.FechaDesde)) and isdefined("form.FechaHasta") and len(trim(form.FechaHasta))>
				and lt.LTdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FechaDesde)#"> and #(LvarFechaFin)#
		  </cfif> --->
	</cfquery>

     <!---<cf_dumptable var = "#RHSUAMovimientos#">--->

    <!---SML. Validar los reingresos--->
    <cfquery name="rsLista1" datasource="#session.DSN#">
    	select DEid,LTdesde from #RHSUAMovimientos#
        where RHTcomportam = 1
    </cfquery>

    <cfloop query="rsLista1">
    	<cfquery name="rsValidaAlta" datasource="#session.DSN#">
        	select COUNT(1) cantAltas
			from DLaboralesEmpleado a
				inner join RHTipoAccion b on a.RHTid = b.RHTid
					and a.Ecodigo = b.Ecodigo
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista1.DEid#">
				and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and a.DLfvigencia < <cfqueryparam cfsqltype="cf_sql_date" value="#rsLista1.LTdesde#">
				and b.RHTcomportam = 1
        </cfquery>

        <cfif isdefined('rsValidaAlta') and rsValidaAlta.cantAltas LTE 1>
        	<cfquery name="rsElimina" datasource="#session.DSN#">
        		delete #RHSUAMovimientos#
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista1.DEid#">
					and RHTcomportam = 1
                    and LTdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#rsLista1.LTdesde#">
        	</cfquery>
        </cfif>
    </cfloop>

    <cfquery name="rsLista" datasource="#session.DSN#">
    	select DEid,SeguroSocial,RHTcomportam,tipoMovimiento,LTdesde,RHfolio,diasIncidencia,salarioDiario
        	from #RHSUAMovimientos#
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
			<cfset hilera = hilera & RepeatString("0",2-len(trim(tipoMovimiento)))&'#tipoMovimiento#'>
			<cfset hilera = hilera & '#DateFormat(LTdesde,'DDMMYYYY')#'& RepeatString(" ", 8-len(trim(DateFormat(LTdesde,'DDMMYYYY'))))>

			<cfif RHTcomportam eq 5>
				<cfset hilera = hilera & '#trim(RHfolio)#' &RepeatString(" ", 8-len(trim(RHfolio)))>
			<cfelse>
				<cfset hilera = hilera  & '#trim(RHfolio)#' &RepeatString(" ", 8)>
			</cfif>

			<cfif RHTcomportam eq 5 or RHTcomportam eq 13>
				<cfset hilera = hilera & RepeatString("0", 2-len(trim(mid(diasIncidencia,1,2))))&'#mid(diasIncidencia,1,2)#' >
			<cfelse>
				<cfset hilera = hilera & RepeatString("0", 2) >
			</cfif>

			<cfif RHTcomportam eq 1>

            <!---<cfset SDI = salarioDiario>--->
            <cfset hilera = hilera & RepeatString("0",7-len(replace(replace(LSCurrencyformat(salarioDiario,'none'),'.',''),",",''))) & '#replace(replace(LSCurrencyformat(salarioDiario,'none'),'.',''),",",'')#'>
            <cfelse>
            <cfset hilera = hilera & "0000000">
            </cfif>


		<!----Reemplazar caracteres no validos----->
		 	<!--- <cfset hilera = REReplaceNoCase(hilera,'Ã?','A',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã‰','E',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã?','I',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã“','O',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ãš','U',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã‘','N',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ãœ','U',"all")> --->
			<cfset hilera = Ucase(hilera)>

			<cfset linea = 2>
		</cfloop>

	</cffunction>
	<cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'Mov')>
	<cffile action="write" addnewline="false" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">
	<cfheader name="Content-Disposition" value="attachment;filename=ImportacionMovimientos.txt">
	<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">

