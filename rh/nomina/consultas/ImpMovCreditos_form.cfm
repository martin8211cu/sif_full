<cf_dbfunction name="OP_concat" returnvariable="_Cat">
<cfsetting requesttimeout="3600" enablecfoutputonly="yes">
	<cfif isdefined ('form.FechaHasta') and len(trim(form.FechaHasta))>
		<cfset LvarFechaFin = DateAdd("d", 1, #dateformat(form.FechaHasta,'dd/mm/yyyy')#)>
		<cfset LvarFechaFin = DateAdd("s", -1, #LvarFechaFin#)>
	</cfif>

<!---Registro Patronal IMSS --->
<!--- 	<cfquery name="rsRegistro" datasource="#session.dsn#"> --->
<!--- 		select <cf_dbfunction name="to_char" args="Pvalor" len="11"> as Pvalor  from RHParametros where Ecodigo = #session.Ecodigo# and Pcodigo = 300 --->
<!--- 	</cfquery> --->
<!--- 	<cfset RegistroPatronal = #rsRegistro.Pvalor#> --->

	<cfset RegistroPatronal = #regPat#> <!--- Registro Patronal IMSS --->
	<cfset ValidaOfiOEmp = #rePatOfi#> <!--- Con esta variable se si es un registro por ofina o no --->


<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
	ecodigo="#session.Ecodigo#" pvalor="2110" default="0" returnvariable="vInfonavit"/>

	<cfset lineae = "">
	<cfloop delimiters="," list="#vInfonavit#" index="i">
		<cfset linea  = ListGetAt(i,1,',')>
		<cfset lineae &=  linea & ',' >
	</cfloop>
		<cfset lineae =  mid(lineae,1,LEN(lineae) - 1)>

    <!---SML. Inicio Reinicio de Descuento--->
	<cfquery name="rsLista" datasource="#session.dsn#">
    select
		u.Did,
		<cf_dbfunction name="to_char" args="de.DESeguroSocial" len="11"> as SeguroSocial,
		<cf_dbfunction name="to_char" args="u.Dreferencia" len="10"> as Dreferencia, 17 as TipoMovimiento,
		u.Dfechaini,
		td.TDdescripcion as metodo,
		u.Dmetodo,
		u.Dvalor as descuento
	from RHTipoAccion a inner join DLaboralesEmpleado b on a.RHTid = b.RHTid and a.RHTcomportam in (1)
		inner join DatosEmpleado de on de.DEid = b.DEid
		inner join DeduccionesEmpleado u on u.DEid = de.DEid
		<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
		<cfif ValidaOfiOEmp eq "1">
	    	inner join oficinas o
			on o.Ocodigo = b.Ocodigo
		</cfif>
		<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
		and u.Ecodigo = de.Ecodigo and u.TDid in (#lineae#) inner join TDeduccion td on td.TDid = u.TDId
		and td.Ecodigo = u.Ecodigo
		and u.Dactivo = 1
	where a.Ecodigo = #session.Ecodigo#
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
	group by u.Did,de.DESeguroSocial,u.Dreferencia,u.Dfechaini,td.TDdescripcion, u.Dvalor,u.Dmetodo
	</cfquery>
	<!---SML. Final Reinicio de Descuento--->

    <!---SML. Inicio Modificacion de Tipo de Descuento--->
   <!--- <cfquery name="rsLista" datasource="#session.dsn#">
    	select top 2 *
		from DeduccionesEmpleado
		where Ecodigo = #session.Ecodigo#
			and TDid in (#lineae#)
			and DEid = (select DEid from DatosEmpleado where DEidentificacion = '114' and Ecodigo = 10)
		order by Dfechafin desc
    </cfquery>--->

    <!---SML. Final Modificacion de Tipo de Descuento--->

<cfset fnprocesaLista(rsLista)>

	<cffunction name="fnprocesaLista" access="private" output="false">
		<cfargument name="rsLista" type="query" required="yes">
		<cfset hilera = ''>
        <cfset linea = 1>
		<cfloop query="rsLista">
			<cfset hilera = hilera & RepeatString("0",11-len(trim(RegistroPatronal)))&'#RegistroPatronal#'>
			<cfset hilera = hilera & RepeatString("0",11-len(trim(SeguroSocial)))&'#SeguroSocial#'>
			<cfset hilera = hilera & '#trim(Dreferencia)#' &RepeatString(" ", 10-len(trim(Dreferencia)))>
            <cfset hilera = hilera & '#trim(TipoMovimiento)#' &RepeatString(" ", 2-len(trim(TipoMovimiento)))>
			<cfset hilera = hilera & '#DateFormat(Dfechaini,'DDMMYYYY')#'& RepeatString(" ", 8-len(trim(DateFormat(Dfechaini,'DDMMYYYY'))))>
            <!--- <cfif find('PORCENTAJE', metodo) or find('porcentaje', metodo) or find('Porcentaje', metodo)>
				<cfset hilera = hilera & '#1#'>
			<cfelseif find('CUOTA FIJA', metodo) or find('Cuota Fija', metodo) or find('cuota fija', metodo)>
				<cfset hilera = hilera & '#2#'>
            <cfelseif find('SMG', metodo) or find('VSM', metodo)>
            	<cfset hilera = hilera & '#3#'>
            <cfelse>
            	<cfset hilera = hilera & '#0#'>
			</cfif> --->

			<cfif Dmetodo eq 0><!--- PORCENTAJE --->
				<cfset hilera = hilera & '1'>
			<cfelseif Dmetodo eq 1><!--- FIJO --->
				<cfset hilera = hilera & '2'>
			<cfelseif Dmetodo eq 2><!--- VUMA --->
				<cfset hilera = hilera & '3'>
			</cfif>
			<cfset hilera = hilera & RepeatString("0",8-len(replace(replace(LSCurrencyformat(descuento,'none'),'.',''),',',''))) & '#replace(replace(LSCurrencyformat(descuento,'none'),'.',''),',','')#'>
			<cfset hilera = hilera & 'N' >

		<!----Reemplazar caracteres no validos----->
			<!--- <cfset hilera = REReplaceNoCase(hilera,'Ã?','A',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã‰','E',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã?','I',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã“','O',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ãš','U',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ã‘','N',"all")> --->
<!--- 			<cfset hilera = REReplaceNoCase(hilera,'Ãœ','U',"all")> --->
			<!--- <cfset hilera = Ucase(hilera) & '#chr(13)##chr(10)#'> --->
		</cfloop>
	</cffunction>
	<cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
	<cfset txtfile = GetTempFile(getTempDirectory(), 'IMPMovCR')>
	<cffile action="write" addnewline="false" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">
	<cfheader name="Content-Disposition" value="attachment;filename=ImportacionMovimientosCredito.txt">
	<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
