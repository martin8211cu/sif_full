<cfparam name="url.periodo" 		type="integer" 	default="-1">	<!----Periodo--->
<cfparam name="url.mes" 			type="integer"	default="-1">	<!----Mes--->
<cfparam name="url.calendariopago" 	type="string" 	default="-1">	<!---Calendario de pago---->
<cfparam name="url.historico" 		type="string" 	default="0">	<!---Son nominas historicas---->

<cf_dbfunction name="OP_concat" returnvariable="CAT" >

 
<cf_dbtemp name="TEMP_SSVMN" returnvariable="TMPSSVMN" datasource="#session.dsn#">
    <cf_dbtempcol name="DEid"  				type="numeric" 	mandatory="no">
    <cf_dbtempcol name="Identificacion"  	type="varchar(60)" 	mandatory="no">
    <cf_dbtempcol name="Nombre"  			type="varchar(60)"	mandatory="no">
    <cf_dbtempcol name="Periodo"  			type="date" 		mandatory="no">
    <cf_dbtempcol name="MontoDed"  			type="integer" 	mandatory="no">
    <cf_dbtempcol name="SalarioB"  			type="integer" 	mandatory="no">
    <cf_dbtempcol name="SalarioL"  			type="integer" 	mandatory="no">
    <cf_dbtempcol name="TipoPago"  			type="varchar(2)" 	mandatory="no"> <!---Tipo Pago = 04 --->
    <cf_dbtempcol name="Constante01"  		type="varchar(9)" 	mandatory="no"> <!--- '000900000' --->
    <cf_dbtempcol name="Tiporeg"	  		type="varchar(2)" 	mandatory="no"> <!--- 21 => 01061 Ajuste Póliza SSVMN  / 01060 Póliza S.S.V.M.N. | 11 => 70040 Prestamo SSVMN--->
    <cf_dbtempcol name="TDid"	  			type="numeric" 	mandatory="no">
</cf_dbtemp>





DEid,Identificacion,Apellido1,Apellido2,Nombre,Periodo,MontoDed,SalarioB,SalarioL,TipoPago,Constante01'000900000' ,Tiporeg


<!----Variables de traduccion---->
<cfinvoke Key="MSG_NoHayDatosParaLosFiltrosSeleccionados" Default="No hay datos para los filtros seleccionados" returnvariable="MSG_NoHayDatosParaLosFiltrosSeleccionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSeHaDefinidoElFormatoParaLaGeneracionDelArchivo" Default="No se ha definido el formato para la generación del archivo" returnvariable="MSG_NoSeHaDefinidoElFormatoParaLaGeneracionDelArchivo" component="sif.Componentes.Translate" method="Translate"/>
<cfset prefijo = ''>
<cfif isdefined("url.historico") and url.historico EQ 1>
	<cfset prefijo = 'H'>
</cfif>
<!----Verificar si existe calendario de pago---->
<cfquery name="rsExisteCalendario" datasource="#session.DSN#">
	select CPid, CPhasta, <cf_dbfunction name="date_format" args="CPhasta,yyyymmdd"> as FechaST
	from CalendarioPagos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("url.periodo") and url.periodo NEQ -1 and isdefined("url.mes") and url.mes NEQ -1>
			and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			and CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
		<cfelseif isdefined("url.calendariopago") and url.calendariopago NEQ -1>
			and CPid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.calendariopago#"   list="true">)
		</cfif>
</cfquery>

 
<cfif rsExisteCalendario.RecordCount EQ 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select '#MSG_NoHayDatosParaLosFiltrosSeleccionados#' as Error
		from dual
	</cfquery>
<cfelse>

    <!---ljs parametro Deducciones usadas para el exportador SSVMN ITCR --->
    <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
        ecodigo="#session.Ecodigo#" pvalor="2557" default="" returnvariable="lvarDeducSSVMN"/>        


	<cfquery name="rsPeriodo" dbtype="query">
		select max(FechaST) as FechaST , max(CPhasta)  as Periodo 
		from rsExisteCalendario
	</cfquery>

	<cfquery name="rsEmpleados" datasource="#session.DSN#">
		insert into #TMPSSVMN# (DEid,TDid,TipoPago,Constante01 ,Tiporeg,MontoDed )

	 		select dc.DEid, d.TDid, '04' as TipoPago,'000900000' as Constante01 ,'' as Tiporeg	,(sum(DCvalor) * 100) as MontoDed
			from #prefijo#DeduccionesCalculo  dc
			inner join DeduccionesEmpleado d 
				on d.Did = dc.Did
				and d.DEid = dc.DEid
			inner join TDeduccion td
				on td.TDid = d.TDid 
				and td.TDcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lvarDeducSSVMN#" list="true">)
			where dc.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsExisteCalendario.CPid)#" list="true">)
			group by dc.DEid, d.TDid
 	</cfquery>
 

	<cfquery datasource="#session.DSN#">
		update #TMPSSVMN# set 
			SalarioB = 
				coalesce((select sum(se.SEsalariobruto + se.SEincidencias)
						from  #prefijo#SalarioEmpleado  se
						where se.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsExisteCalendario.CPid)#" list="true">)
						and se.DEid = #TMPSSVMN#.DEid
						),0)

			,SalarioL = 
				coalesce((select sum(se.SEliquido)
						from  #prefijo#SalarioEmpleado  se
						where se.RCNid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#ValueList(rsExisteCalendario.CPid)#" list="true">)
						and se.DEid = #TMPSSVMN#.DEid
						),0
						)

			, Nombre = (select  DEapellido1 #CAT# ' ' #CAT# DEapellido2 #CAT# ' ' #CAT#  DEnombre from DatosEmpleado de where de.DEid = #TMPSSVMN#.DEid)
			, Identificacion 	= (select  DEidentificacion from DatosEmpleado de where de.DEid = #TMPSSVMN#.DEid)
			,Periodo 	= <cfqueryparam cfsqltype="cf_sql_date" value="#rsPeriodo.Periodo#">
			,Tiporeg = case when TDid = 134 then '21'
							when TDid = 135 then '21'

						else
							'11'
						end
	</cfquery>

<cf_dbfunction name="string_part" args="rtrim(Identificacion)|1|14" 	returnvariable="LvarIdentificacion"  delimiters="|">
	<cf_dbfunction name="length"      args="#LvarIdentificacion#"  		returnvariable="LvarIdentificacionLen" delimiters="|" >
		<cf_dbfunction name="sRepeat"     args="' '|14-coalesce(#LvarIdentificacionLen#,0)" 	returnvariable="LvarIdentificacionStrLS" delimiters="|">


<cf_dbfunction name="string_part" args="rtrim(Nombre)|1|28" 	returnvariable="LvarNombre"  delimiters="|">	
	<cf_dbfunction name="length"      args="#LvarNombre#"  		returnvariable="LvarNombreLen" delimiters="|" >
		<cf_dbfunction name="sRepeat"     args="' '|28-coalesce(#LvarNombreLen#,0)" 	returnvariable="LvarNombreStrLS" delimiters="|">


<cf_dbfunction name="string_part" args="rtrim(TipoPago)|1|2" 	returnvariable="LvarTipoPago"  delimiters="|">	
<cf_dbfunction name="string_part" args="rtrim(Constante01)|1|9" 	returnvariable="LvarConstante01"  delimiters="|">	



<cf_dbfunction name="to_char" args="MontoDed" returnvariable="LvarMontoDed">
    <cf_dbfunction name="string_part" args="rtrim(#LvarMontoDed#)|1|10" 	returnvariable="LvarMontoDedStr"  delimiters="|">
        <cf_dbfunction name="length"      args="#LvarMontoDedStr#"  		returnvariable="LvarMontoDedStrL" delimiters="|" >
                <cf_dbfunction name="sRepeat"     args="'0'|10-coalesce(#LvarMontoDedStrL#,0)" 	returnvariable="LvarMontoDedStrLS" delimiters="|">

<cf_dbfunction name="to_char" args="SalarioB" returnvariable="LvarSalarioB">
    <cf_dbfunction name="string_part" args="rtrim(#LvarSalarioB#)|1|10" 	returnvariable="LvarSalarioBStr"  delimiters="|">
        <cf_dbfunction name="length"      args="#LvarSalarioBStr#"  		returnvariable="LvarSalarioBStrL" delimiters="|" >
                <cf_dbfunction name="sRepeat"     args="'0'|10-coalesce(#LvarSalarioBStrL#,0)" 	returnvariable="LvarSalarioBStrLS" delimiters="|">

<cf_dbfunction name="to_char" args="SalarioL" returnvariable="LvarSalarioL">
    <cf_dbfunction name="string_part" args="rtrim(#LvarSalarioL#)|1|10" 	returnvariable="LvarSalarioLStr"  delimiters="|">
        <cf_dbfunction name="length"      args="#LvarSalarioLStr#"  		returnvariable="LvarSalarioLStrL" delimiters="|" >
                <cf_dbfunction name="sRepeat"     args="'0'|10-coalesce(#LvarSalarioLStrL#,0)" 	returnvariable="LvarSalarioLStrLS" delimiters="|">

    
    <cfquery name="ERR" datasource="#session.DSN#">
            Select  '0' 
            		#CAT# rtrim(#preservesinglequotes(LvarIdentificacion)#) 
					#CAT# #preservesinglequotes(LvarIdentificacionStrLS)#
            		#CAT# #preservesinglequotes(LvarNombre)# 
            		#CAT# #preservesinglequotes(LvarNombreStrLS)# 
            		#CAT# #preservesinglequotes(LvarTipoPago)# 
            		#CAT# #preservesinglequotes(LvarConstante01)# 
            		#CAT# #preservesinglequotes(LvarMontoDedStrLS)# #CAT# rtrim(#preservesinglequotes(LvarMontoDedStr)#)
            		#CAT# #preservesinglequotes(LvarSalarioBStrLS)# #CAT# rtrim(#preservesinglequotes(LvarSalarioBStr)#)
            		#CAT# #preservesinglequotes(LvarSalarioLStrLS)# #CAT# rtrim(#preservesinglequotes(LvarSalarioLStr)#)
            		#CAT# '#rsPeriodo.FechaST#'
            		#CAT# '0'
            		#CAT# Tiporeg

            from #TMPSSVMN#
            order by Identificacion
    </cfquery>    

</cfif>



