<cfsetting requesttimeout="3600">
<cfset fechaInicio = form.FechaDesde>
<cfset fechaFinal = form.FechaHasta>

<cfset mesInicio = Mid(fechaInicio,4,2)>
<cfset mesFinal = Mid(fechaFinal,4,2)>

	<cfset RegistroPatronal1 = #regPat#> <!--- Registro Patronal IMSS --->
	<cfset ValidaOfiOEmp1 = #rePatOfi#> <!--- Con esta variable se si es un registro por ofina o no --->

	<cfif mesInicio is 01 and mesFinal is 02>
		<cfset Meses = 1 >

	<cfelseif mesInicio is 03 and mesFinal is 04>
		<cfset Meses = 3 >

	<cfelseif mesInicio is 05 and mesFinal is 06>
		<cfset Meses = 5 >

	<cfelseif mesInicio is 07 and mesFinal is 08>
		<cfset Meses = 7 >

	<cfelseif mesInicio is 09 and mesFinal is 10>
		<cfset Meses = 9 >

	<cfelseif mesInicio is 11 and mesFinal is 12>
		<cfset Meses = 11 >

   	<cfelse>
        <cfthrow message = "El Rango del Fechas No Esta Dentro De Un Bimestre Valido">
	</cfif>

<cfset Periodo = Mid(fechaInicio,7,4)>

<cfif #Meses# GTE 11>
	<cfset PeriodoDos = Periodo +1>
<cfelse>
	<cfset PeriodoDos = Periodo>
</cfif>

<cfset FechaInicioN =  createdate(#Periodo#,#mesInicio#,01)>
<cfset FechaFinalN 	=  dateadd('m',2,#FechaInicioN#-1)>

<cfswitch expression="#Meses#">
	<cfcase value="1">  <cfset vBimestre = ' Enero - Febrero '><cfset periodoRpte ='0103#PeriodoDos#'></cfcase>
    <cfcase value="3">  <cfset vBimestre = ' Marzo - Abril '><cfset periodoRpte = '0105#PeriodoDos#'> </cfcase>
    <cfcase value="5">  <cfset vBimestre = ' Mayo - Junio '><cfset periodoRpte = '0107#PeriodoDos#'>  </cfcase>
    <cfcase value="7">  <cfset vBimestre = ' Julio - Agosto '><cfset periodoRpte = '0109#PeriodoDos#'> </cfcase>
    <cfcase value="9">  <cfset vBimestre = ' Septiembre - Octubre '><cfset periodoRpte = '0111#PeriodoDos#'> </cfcase>
    <cfcase value="11"> <cfset vBimestre = ' Noviembre - Diciembre '><cfset periodoRpte = '0101#PeriodoDos#'> </cfcase>
</cfswitch>

<cfinvoke component="rh.Componentes.RH_ReporteCalculoSDI_IDSE" method="CargarDatos" returnvariable="rsDatosEmpleado">
	<cfinvokeargument name = "FInicio" value = "#FechaInicioN#">
    <cfinvokeargument name = "FFinal" value = "#FechaFinalN#">
    <cfinvokeargument name = "MesInic" value = "#Meses#">
    <cfinvokeargument name = "PeriodoInic" value = "#Periodo#">
	<cfinvokeargument name = "ValidaOfiOEmp" value = "#ValidaOfiOEmp1#">
	<cfinvokeargument name = "RegistroPatronal" value = "#RegistroPatronal1#">
</cfinvoke>

		<cfset fila = ''>
		<cfset linea = 1>
		<cfloop query="rsDatosEmpleado">
			<cfif linea GT 1>
				<cfset fila = fila & '#chr(13)##chr(10)#'>
			</cfif>

            <cfset fila = fila & RepeatString("0",11-len(trim(RegPatron)))&'#RegPatron#'>
			<cfset fila = fila & RepeatString("0",11-len(trim(NSS)))&'#NSS#'>
			<cfset fila = fila & 07>
            <cfset FechaValidacion = periodoRpte > <!---'01' & '#mesInicio#' & '#Periodo#'--->
			<cfset fila = fila & FechaValidacion>
            <cfset fila = fila & '        '>
            <cfset SDICalculado = replace(LSCurrencyformat(MtoSDITopado,'none'),'.','')>
            <cfset fila = fila & RepeatString("0",9-len(replace(SDICalculado,',',''))) & '#replace(SDICalculado,',','')#'>
            <!---<cfset fila = fila & RepeatString("0",9-len(replace(LSCurrencyformat(MtoSDITopado,'none'),'.',''))) &'#replace(LSCurrencyformat(MtoSDITopado,'none'),'.','')#'>--->

            <!--- Redondear a 2 decimales --->
          <!---  <cfset SDINumero = MtoSDICalculado>
			<cfset RedondearSDI = SDINumero * 100>
			<cfset RedondearSDI = Round(RedondearSDI)>
			<cfset RedondearSDI = RedondearSDI / 100>
            <cfset CantDigSID = Len(RedondearSDI)>

            <cfif CantDigSID EQ 5>
            		<cfset RedondearSDI = Replace(RedondearSDI,'.','')>
                    <cfset fila = fila & RepeatString("0",7-len(trim(RedondearSDI)))&'#RedondearSDI#'>
             		<cfset fila = fila & RepeatString("0",7-len(trim(RedondearSDI)))&'#RedondearSDI#'>
            <cfelseif CantDigSID EQ 4>
            		<cfset fila = fila & RepeatString("0",6-len(trim(RedondearSDI)))&'#RedondearSDI#' & '0'>
         	<cfelseif CantDigSID LTE 3>

           	<cfelse>
                	<cfset fila = fila & RepeatString("0",7)>
             </cfif>--->

            <!----Reemplazar caracteres no validos----->
			<!--- <cfset fila = REReplaceNoCase(fila,'�?','A',"all")> --->
<!--- 			<cfset fila = REReplaceNoCase(fila,'É','E',"all")> --->
<!--- 			<cfset fila = REReplaceNoCase(fila,'�?','I',"all")> --->
<!--- 			<cfset fila = REReplaceNoCase(fila,'Ó','O',"all")> --->
<!--- 			<cfset fila = REReplaceNoCase(fila,'Ú','U',"all")> --->
<!--- 			<cfset fila = REReplaceNoCase(fila,'Ñ','N',"all")> --->
<!--- 			<cfset fila = REReplaceNoCase(fila,'Ü','U',"all")> --->
			<cfset fila = Ucase(fila)>

			<cfset linea = 2>
		</cfloop>
<cfset archivo = "#trim(session.Usucodigo)#_#hour(now())##minute(now())##second(now())#">
<cfset txtfile = GetTempFile(getTempDirectory(), 'MovBim')>
<cffile action="write" nameconflict="overwrite" file="#txtfile#" output="#fila#" charset="utf-8">
<cfheader name="Content-Disposition" value="attachment;filename=ImpMovBimestrales.txt">
<cfcontent file="#txtfile#" type="text/plain" deletefile="yes">
