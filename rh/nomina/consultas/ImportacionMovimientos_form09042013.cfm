<cfsetting requesttimeout="3600" enablecfoutputonly="yes">
	<cfif isdefined ('form.FechaHasta') and len(trim(form.FechaHasta))>
		<cfset LvarFechaFin = DateAdd("d", 1, #dateformat(form.FechaHasta,'dd/mm/yyyy')#)>
		<cfset LvarFechaFin = DateAdd("s", -1, #LvarFechaFin#)>
	</cfif>
	
	<!---Registro Patronal IMSS --->
	<cfquery name="rsRegistro" datasource="#session.dsn#">
		select <cf_dbfunction name="to_char" args="Pvalor" len="11"> as Pvalor  from RHParametros where Ecodigo = #session.Ecodigo# and Pcodigo = 300
	</cfquery>
	<cfset RegistroPatronal = #rsRegistro.Pvalor#>
	
	<cfquery name="rsLista" datasource="#session.dsn#">
    	SELECT LTRIM(RTRIM(DESeguroSocial)) as SeguroSocial, 07 as tipoMovimiento, LTdesde as fecha, DEsdi as salarioDiario,lt.LTdesde
 		FROM DatosEmpleado de left join LineaTiempo lt  on de.DEid = lt.DEid 
		where de.Ecodigo = #session.Ecodigo# and LTdesde = <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(form.FechaDesde)#"> 
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
			end as tipoMovimiento,--->
			<!---lt.LTdesde,--->
			<!---(select RHfolio from DLaboralesEmpleado lab 
				where lab.DEid = lt.DEid and lab.RHTid = lt.RHTid
				and lab.DLfvigencia = lt.LTdesde and lab.DLffin = lt.LThasta
			and DLlinea = ( select max(DLlinea) from DLaboralesEmpleado lab 
				where lab.DEid = lt.DEid and lab.RHTid = lt.RHTid
				and lab.DLfvigencia = lt.LTdesde and lab.DLffin = lt.LThasta)
			) as RHfolio, 
			<cf_dbfunction name="datediff" args="lt.LTdesde, lt.LThasta">+1 as diasIncidencia,
			de.DEsdi <!---<cf_dbfunction name="to_number" args="de.DEsdi" dec="2">---> as salarioDiario
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
    
    <!---<cf_dump var = "#rsLista#">--->
    
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
			
			<!---<cfif RHTcomportam eq 5>
				<cfset hilera = hilera & '#trim(RHfolio)#' &RepeatString(" ", 8-len(trim(RHfolio)))>
			<cfelse>--->
				<cfset hilera = hilera <!--- & '#trim(RHfolio)#'---> &RepeatString(" ", 8)>
			<!---</cfif>--->
			
			<!---<cfif RHTcomportam eq 5 or RHTcomportam eq 13>
				<cfset hilera = hilera & RepeatString("0", 2-len(trim(mid(diasIncidencia,1,2))))&'#mid(diasIncidencia,1,2)#' >
			<cfelse>--->
				<cfset hilera = hilera & RepeatString("0", 2) >
			<!---</cfif>
            --->
			<!---<cfif RHTcomportam eq 1 or RHTcomportam eq 8 or RHTcomportam eq 2 or RHTcomportam eq 5 or RHTcomportam eq 13 >--->
            
            <!---<cfset SDI = salarioDiario>--->
            <cfset hilera = hilera & RepeatString("0",7-len(replace(LSCurrencyformat(salarioDiario,'none'),'.',''))) &'#replace(LSCurrencyformat(salarioDiario,'none'),'.','')#'>
            
            <!--- Redondear a 2 decimales --->
            
           <!--- <cfset SDINumero = SDI>
			<cfset RedondearSDI = SDINumero * 100>
			<cfset RedondearSDI = Round(RedondearSDI)>           
			<cfset RedondearSDI = RedondearSDI / 100>
            <cfset RedondearSDI = Replace(RedondearSDI,'.','')>
            <cfset CantDigSID = Len(RedondearSDI)>--->
            
            <!---<cfthrow message="#CantDigSID#">
            	<cfif CantDigSID GTE 5>
             		<cfset hilera = hilera & RepeatString("0",7-len(trim(RedondearSDI)))&'#RedondearSDI#'>
            	<cfelseif CantDigSID EQ 4>
            		<cfset hilera = hilera & RepeatString("0",6-len(trim(RedondearSDI)))&'#RedondearSDI#' & '0'>
         		<cfelseif CantDigSID LTE 3>
            		<cfset hilera = hilera & RepeatString("0",5-len(trim(RedondearSDI)))&'#RedondearSDI#' & '00'>        	
           		<cfelse>
                	<cfset hilera = hilera & RepeatString("0",7)>
             	</cfif>--->
            <!---</cfif>--->
           

		<!----Reemplazar caracteres no validos----->
			<cfset hilera = REReplaceNoCase(hilera,'Á','A',"all")>
			<cfset hilera = REReplaceNoCase(hilera,'É','E',"all")>
			<cfset hilera = REReplaceNoCase(hilera,'Í','I',"all")>
			<cfset hilera = REReplaceNoCase(hilera,'Ó','O',"all")>
			<cfset hilera = REReplaceNoCase(hilera,'Ú','U',"all")>
			<cfset hilera = REReplaceNoCase(hilera,'Ñ','N',"all")>
			<cfset hilera = REReplaceNoCase(hilera,'Ü','U',"all")>
			<cfset hilera = Ucase(hilera)>
			
			<cfset linea = 2>
		</cfloop>

	</cffunction>
	<cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'Mov')>	
	<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">
	<cfheader name="Content-Disposition" value="attachment;filename=ImportacionMovimientos.txt">
	<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">

