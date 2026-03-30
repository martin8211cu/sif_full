<cf_dbfunction name="OP_concat" returnvariable="_Cat">
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

<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#"
	ecodigo="#session.Ecodigo#" pvalor="2110" default="0" returnvariable="vInfonavit"/>

	<cfset lineae = "">
	<cfloop delimiters="," list="#vInfonavit#" index="i">
		<cfset linea  = ListGetAt(i,1,',')>
		<cfset lineae &=  linea & ',' >
	</cfloop>
		<cfset lineae =  mid(lineae,1,LEN(lineae) - 1)>

	<cfquery name="rsLista" datasource="#session.dsn#">
		select
			u.Did,
			td.TDdescripcion as metodo,
			<!---( u.Dvalor * 10000) as descuento,--->
			u.Dvalor as descuento,
			u.Dfechaini,
			((
				select count(1)
					from RHDJornadas jo
					where jo.RHJid = j.RHJid
			)) as jornadaSemana,
			<cf_dbfunction name="to_char" args="de.DESeguroSocial" len="11"> as SeguroSocial,
			<!---<cf_dbfunction name="to_char" args="de.DEdato2" len="17">---> de.DEidentificacion as claveUbicacion,
			<cf_dbfunction name="to_char" args="u.Dreferencia" len="10"> as Dreferencia,
			de.RFC as regContribuyente,
			de.CURP,
			<cf_dbfunction name="concat" args="ltrim(rtrim(de.DEapellido1)),'$',ltrim(rtrim(de.DEapellido2)),'$',ltrim(rtrim(de.DEnombre))"> as NombreCompleto,

			de.DEtipocontratacion as tipoTrabajor,

			a.RHTtiponomb,

			v.EVfantig as fechaAlta,
			de.DEsdi as salarioDiario

			from RHTipoAccion a
			inner join DLaboralesEmpleado b
				on a.RHTid = b.RHTid
				and a.RHTcomportam = 1
			inner join RHJornadas j
				on j.RHJid = b.RHJid

			inner join DatosEmpleado de
				on de.DEid = b.DEid

			inner join EVacacionesEmpleado v
				on v.DEid = de.DEid
			<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
			<cfif ValidaOfiOEmp eq "1">
	    		inner join oficinas o
				on o.Ocodigo = b.Ocodigo
			</cfif>
			<!--- esto es mi código +++++++++++++++++++++++++++++++++++++++++++ --->
			left join DeduccionesEmpleado u
				on u.DEid = de.DEid
				and u.Ecodigo = de.Ecodigo
				and u.TDid in (#lineae#)
            left join TDeduccion td on td.TDid = u.TDId
            	and td.Ecodigo = u.Ecodigo
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
	</cfquery>

	<cfset fnprocesaLista(rsLista)>
	<cffunction name="fnprocesaLista" access="private" output="false">
		<cfargument name="rsLista" type="query" required="yes">
		<cfset hilera = ''>

		<cfset linea = 1>

		<!---<cfset NombreCompleto = ''>--->
		<cfloop query="rsLista">
			<cfif linea GT 1>
				<cfset hilera = hilera & '#chr(13)##chr(10)#'>
			</cfif>

			<cfset hilera = hilera & RepeatString("0",11-len(trim(RegistroPatronal)))&'#RegistroPatronal#'>
			<cfset hilera = hilera & RepeatString("0",11-len(trim(SeguroSocial)))&'#SeguroSocial#'>
			<cfset hilera = hilera & '#trim(regContribuyente)#' &RepeatString(" ", 13-len(trim(regContribuyente)))>
			<cfset hilera = hilera & '#trim(CURP)#' &RepeatString(" ", 18-len(trim(CURP)))>
			<cfset hilera = hilera & '#trim(NombreCompleto)#' &RepeatString(" ", 50-len(trim(NombreCompleto)))>

			<cfset hilera = hilera & RepeatString("0",1-len(trim(tipoTrabajor))) &'#tipoTrabajor#' >

		<!---	<cfset hilera = hilera & RepeatString("0", 1) &'#mid(RHTtiponomb,1,2)#' > --->

			<!---<cfdump var="#rsLista.jornadaSemana#"> <br>
			<cfif #rsLista.jornadaSemana# eq 1>
				<cfset hilera = hilera & '1'>
			<cfelseif #rsLista.jornadaSemana# eq 2>
				<cfset hilera = hilera & '2'>
			<cfelseif #rsLista.jornadaSemana# eq 3>
				<cfset hilera = hilera & '3'>
			<cfelseif #rsLista.jornadaSemana# eq 4>
				<cfset hilera = hilera & '4'>
			<cfelseif #rsLista.jornadaSemana# eq 5>
				<cfset hilera = hilera & '5'>
			<cfelseif #rsLista.jornadaSemana# eq 0>
				<cfset hilera = hilera & '6'>
			<cfelseif #rsLista.jornadaSemana# eq 6>--->
				<cfset hilera = hilera & '0'>
			<!---</cfif>--->
			<cfset hilera = hilera & '#DateFormat(fechaAlta,'DDMMYYYY')#'& RepeatString(" ", 8-len(trim(DateFormat(fechaAlta,'DDMMYYYY'))))>
            <cfset hilera = hilera & RepeatString("0",7-len(replace(replace(LSCurrencyformat(salarioDiario,'none'),'.',''),",",''))) & '#replace(replace(LSCurrencyformat(salarioDiario,'none'),'.',''),",",'')#'>
			<cfset hilera = hilera & '#trim(claveUbicacion)#' &RepeatString(" ", 17-len(trim(claveUbicacion)))>
			<cfif #len(trim(rsLista.Did))# neq 0>
				<cfset hilera = hilera & '#trim(Dreferencia)#' &RepeatString(" ", 10-len(trim(Dreferencia)))>
			<cfelse>
				<cfset hilera = hilera & '#trim(Dreferencia)#' &RepeatString(" ", 10)>
			</cfif>
			<cfset hilera = hilera & '#DateFormat(Dfechaini,'DDMMYYYY')#'& RepeatString("0", 8-len(trim(DateFormat(Dfechaini,'DDMMYYYY'))))>
			<cfif find('PORCENTAJE', metodo) or find('porcentaje', metodo) or find('Porcentaje', metodo) or find('%', metodo)>
				<cfset hilera = hilera & '#1#'>
			<cfelseif find('CUOTA FIJA', metodo) or find('Cuota Fija', metodo) or find('cuota fija', metodo)>
				<cfset hilera = hilera & '#2#'>
            <cfelseif find('SMG', metodo) or find('VSM', metodo)>
            	<cfset hilera = hilera & '#3#'>
            <cfelse>
            	<cfset hilera = hilera & '#0#'>
			</cfif>
            <cfset hilera = hilera & RepeatString("0",8-len(replace(replace(LSCurrencyformat(descuento,'none'),'.',''),',',''))) & '#replace(replace(LSCurrencyformat(descuento,'none'),'.',''),',','')#'>


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
	<cfset txtfile = GetTempFile(getTempDirectory(), 'IMPTrab')>
	<cffile action="write" addnewline="false" nameconflict="overwrite" file="#txtfile#" output="#hilera#" charset="utf-8">
	<cfheader name="Content-Disposition" value="attachment;filename=ImportacionTrabajadores.txt">
	<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
