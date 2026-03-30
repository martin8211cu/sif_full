<!---

Columnas del archivo para la Junta de pensiones y Jubilaciones del Magisterio Nacional

En este archivo se deben reportar las deducciones por concepto de régimen de pensiones pertenecientes a la Junta de Pensiones y Jubilaciones del Magisterio Nacional de aquellos funcionarios que perteneces a este régimen
Las deducciones a reportar son:
•	JPMN Régimen de Reparto (Columna Cuota Obrera)
Y las cargas a reportar con:
•	JPMN Empleado 0.4% 
•	JPMN Patronal 0.1%  sumados (Columna 5 x mil:)
•	Capitalización Empleado (Columna Cuota Obrera)
•	Capitalización Patronal (Columna Cuota Patronal)
Además se debe reportar el salario total del funcionario.
	
•         Cédula: la cédula con que se reportó en el momento de cancelación de la planilla
•         Tipo de cédula: corresponde al tipo de documento que posee cada persona, por ejemplo: residencia, pasaporte, permiso de trabajo o una situación indefinida, para cada uno de estos casos en esta columna se ingresará la primera letra según corresponda (residencia= R, pasaporte= P, Permiso de trabajo= T, Indefinido= I).  Es importante aclarar que la letra N es para nacionales y para estos casos no debe de ingresarse.
•         Primer apellido
•         Segundo apellido
•         Nombre
•         Fondo: el fondo el tipo de régimen para el que cotiza la persona, por ejemplo para el RCC corresponde el número 1 y para el fondo de Reparto corresponde el número 2.  Les recordamos que la información solicitada es para los casos del Régimen de Capitalización Colectiva.
•         Periodo: el periodo de trabajo que se está cancelando, este debe de ingresarse con el formato: último día del mes / mes / año, por ejemplo: 31/08/2013.
•         Salario: es el monto cancelado al trabajador por el periodo específico de pago.
•         Cuota obrera: es el porcentaje cancelado a la Junta por este concepto, en el caso del Régimen de Capitalización Colectiva (RCC) corresponde al 8% del salario reportado.
•         Cuota Patronal: es el porcentaje cancelado a la Junta por este concepto, en el caso del Régimen de Capitalización Colectiva (RCC) corresponde al 6.75% del salario reportado.
•         5 x mil: es el porcentaje cancelado a la Junta por este concepto, en el caso del Régimen de Capitalización Colectiva (RCC) corresponde al 0.5% del salario reportado.
•         Suma de cotizaciones: corresponde a la suma de la cotización obrera , patronal y 5 x mil.
•         Tipo de planilla: se refiere al tipo de pago que se realiza, puede ser pago de planilla ordinaria, planilla escolar, planilla adicional o planilla especial, para cada uno de estos casos se ingresa las siguientes siglas según corresponda: ordinaria = SO, planilla escolar= SE, planilla adicional= PA, planilla especial= PE


--->


<cfparam name="url.periodo" 		type="integer" 	default="-1">	<!----Periodo--->
<cfparam name="url.mes" 			type="integer"	default="-1">	<!----Mes--->
<cfparam name="url.calendariopago" 	type="string" 	default="-1">	<!---Calendario de pago---->
<cfparam name="url.historico" 		type="string" 	default="0">	<!---Son nominas historicas---->
<!---Constante para definir tipo Nomina SO = Salario Ordinario / SE = Salario Escolar / PA = Planilla Adicional / PE = Planilla Especial ---->
<cfparam name="url.Constante" 		type="string" 	default="">		

<cf_dbfunction name="OP_concat" returnvariable="CAT" >

 
<cf_dbtemp name="TEMP_JPMN" returnvariable="TMPJPMN" datasource="#session.dsn#">
    <cf_dbtempcol name="DEid"  				type="numeric" 	mandatory="no">
    <cf_dbtempcol name="Identificacion"  	type="varchar(60)" 	mandatory="no">
    <cf_dbtempcol name="TipoIdentificacion" type="varchar(1)" 	mandatory="no">
    <cf_dbtempcol name="Apellido1"  		type="varchar(60)" 	mandatory="no">
    <cf_dbtempcol name="Apellido2"  		type="varchar(60)" 	mandatory="no">
    <cf_dbtempcol name="Nombre"  			type="varchar(60)"	mandatory="no">
    <cf_dbtempcol name="Regimen"  			type="varchar(1)" 	mandatory="no">
    <cf_dbtempcol name="Periodo"  			type="date" 		mandatory="no">
    <cf_dbtempcol name="Salario"  			type="money" 	mandatory="no">
    <cf_dbtempcol name="CuotaObreraC"  		type="money" 	mandatory="no">
    <cf_dbtempcol name="CuotaObreraR"  		type="money" 	mandatory="no">	
    <cf_dbtempcol name="CuotaObrera"  		type="money" 	mandatory="no">		
    <cf_dbtempcol name="CuotaPatronal"  	type="money" 	mandatory="no">
    <cf_dbtempcol name="CincoxMil"  		type="money" 	mandatory="no">
    <cf_dbtempcol name="SumaCotizacion" 	type="money" 	mandatory="no">
    <cf_dbtempcol name="TipoPlanilla"  		type="varchar(2)" 	mandatory="no">
</cf_dbtemp>

<!----Variables de traduccion---->
<cfinvoke Key="MSG_NoHayDatosParaLosFiltrosSeleccionados" Default="No hay datos para los filtros seleccionados" returnvariable="MSG_NoHayDatosParaLosFiltrosSeleccionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSeHaDefinidoElFormatoParaLaGeneracionDelArchivo" Default="No se ha definido el formato para la generación del archivo" returnvariable="MSG_NoSeHaDefinidoElFormatoParaLaGeneracionDelArchivo" component="sif.Componentes.Translate" method="Translate"/>
<cfset prefijo = ''>
<cfif isdefined("url.historico") and url.historico EQ 1>
	<cfset prefijo = 'H'>
</cfif>
<!----Verificar si existe calendario de pago---->
<cfquery name="rsExisteCalendario" datasource="#session.DSN#">
	select CPid, CPhasta,CPtipo from CalendarioPagos 
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
	<cfquery name="rsPeriodo" dbtype="query">
		select max(CPhasta)  as Periodo from rsExisteCalendario
	</cfquery>

	<cfquery name="rsCPtipo" dbtype="query">
		select distinct CPtipo  from rsExisteCalendario
	</cfquery>


	<cfquery name="rsEmpleados" datasource="#session.DSN#">
 		insert into #TMPJPMN# (DEid,Identificacion,TipoIdentificacion,Apellido1,Apellido2,Nombre,Salario,Regimen,Periodo)
	 	select de.DEid,de.DEidentificacion, de.NTIcodigo, de.DEapellido1,de.DEapellido2,de.DEnombre
			,sum(coalesce(se.SEsalariobruto,0) + coalesce(se.SEincidencias,0)) as SalarioBruto
			, '1',<cfqueryparam cfsqltype="cf_sql_date" value="#rsPeriodo.Periodo#">
		from #prefijo#SalarioEmpleado se
		inner join DatosEmpleado de
			on de.DEid = se.DEid
		where se.RCNid in (<cfqueryparam  cfsqltype="cf_sql_numeric" value="#ValueList(rsExisteCalendario.CPid)#" list="true">)
		<!--- and de.DEid in ( 932, 3182)--->
		group by de.DEid,de.DEidentificacion,de.NTIcodigo, de.DEapellido1,de.DEapellido2,de.DEnombre
	</cfquery>


	<!---ljs parametro Cargas usadas para la capitalizacion Patrono de usada en el exportador JPMN--->
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
	    ecodigo="#session.Ecodigo#" pvalor="2553" default="" returnvariable="lvarCargaCapEmpJPMN"/>

	<!---ljs parametro Cargas usadas para la capitalizacion Empleado de usada en el exportador JPMN--->
	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
	    ecodigo="#session.Ecodigo#" pvalor="2554" default="" returnvariable="lvarCargaCapPatJPMN"/>

	<!---ljs parametro Cargas usadas para la capitalizacion Patrono de usada en el exportador JPMN--->
    <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
        ecodigo="#session.Ecodigo#" pvalor="2555" default="" returnvariable="lvarCargaCxMil"/>

    <!---ljs parametro Cargas usadas para la capitalizacion Patrono de usada en el exportador JPMN--->
    <cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.dsn#" 
        ecodigo="#session.Ecodigo#" pvalor="2556" default="" returnvariable="lvarDeducRepT"/>        

	<cfquery name="rsEmpleados" datasource="#session.DSN#">
		update #TMPJPMN# set 
			CuotaObreraC = 
				coalesce((select sum(hc.CCvaloremp) 
						from  #prefijo#CargasCalculo hc
						where hc.DClinea in (select DClinea from DCargas 
											where DCcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lvarCargaCapEmpJPMN#" list="true">))
						and hc.DEid = #TMPJPMN#.DEid
						and hc.RCNid in (<cfqueryparam  cfsqltype="cf_sql_numeric" value="#ValueList(rsExisteCalendario.CPid)#" list="true">)

					),0)

			,CuotaPatronal = 
				coalesce((select sum(hc.CCvalorpat) 
						from  #prefijo#CargasCalculo hc
						where hc.DClinea in (select DClinea from DCargas 
											where DCcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lvarCargaCapPatJPMN#" list="true">))
						and hc.DEid = #TMPJPMN#.DEid
						and hc.RCNid in (<cfqueryparam  cfsqltype="cf_sql_numeric" value="#ValueList(rsExisteCalendario.CPid)#" list="true">)
					),0)

			,CincoxMil = 
				coalesce((select sum(hc.CCvaloremp) + sum(hc.CCvalorpat) 
						from  #prefijo#CargasCalculo hc
						where hc.DClinea in (select DClinea from DCargas 
											where DCcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lvarCargaCxMil#" list="true">)
											)
						and hc.DEid = #TMPJPMN#.DEid
						and hc.RCNid in (<cfqueryparam  cfsqltype="cf_sql_numeric" value="#ValueList(rsExisteCalendario.CPid)#" list="true">)
					),0)

			,CuotaObreraR = 
				coalesce((select sum(hd.DCvalor)
						from  #prefijo#DeduccionesCalculo  hd
						where hd.Did in (select Did from DeduccionesEmpleado d 
											inner join TDeduccion td
												on td.TDid = d.TDid 
											where td.TDcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lvarDeducRepT#" list="true">)
											)
						and hd.DEid = #TMPJPMN#.DEid
						and hd.RCNid in (<cfqueryparam  cfsqltype="cf_sql_numeric" value="#ValueList(rsExisteCalendario.CPid)#" list="true">)
					),0)

			,TipoIdentificacion = case 	when TipoIdentificacion = 'C' then 'N'
											when TipoIdentificacion = 'G' then 'I'
									else
										TipoIdentificacion
									 end
			,TipoPlanilla = <cfif isDefined('url.Constante') and #url.Constante# NEQ '-1'>
								ltrim(rtrim('#url.Constante#'))
							<cfelse>
								''
							</cfif>

	</cfquery>

	<cfquery name="rsEmpleados" datasource="#session.DSN#">
		update #TMPJPMN# set 
						SumaCotizacion = CuotaObreraC + CuotaPatronal + CincoxMil + CuotaObreraR
						,CuotaObrera = CuotaObreraC + CuotaObreraR
	</cfquery>


	<cfquery name="rsEmpleados" datasource="#session.DSN#">
		update #TMPJPMN# set Regimen = '2'  
			where DEid not in (select hc.DEid 
								from  #prefijo#CargasCalculo hc
								where hc.DClinea in (select DClinea from DCargas 
													where DCcodigo in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#lvarCargaCapEmpJPMN#" list="true">))
								and hc.DEid = #TMPJPMN#.DEid
								and hc.RCNid in (<cfqueryparam  cfsqltype="cf_sql_numeric" value="#ValueList(rsExisteCalendario.CPid)#" list="true">)
								)	
	</cfquery>
    
    <cfquery name="ERR" datasource="#session.DSN#">
            Select  Identificacion
					,TipoIdentificacion
					,Apellido1
					,Apellido2
					,Nombre
					,Regimen
					,<cf_dbfunction name="date_format"	args="Periodo,DD/MM/YYYY"> as Periodo
					,<cf_dbfunction name="to_number"	args="Salario" dec="2"> as Salario
					,<cf_dbfunction name="to_number"	args="CuotaObrera" dec="2"> as CuotaObrera
					,<cf_dbfunction name="to_number"	args="CuotaPatronal" dec="2"> as CuotaPatronal
					,<cf_dbfunction name="to_number"	args="CincoxMil" dec="2"> as CincoxMil
					,<cf_dbfunction name="to_number"	args="SumaCotizacion" dec="2"> as SumaCotizacion
					,TipoPlanilla
            from #TMPJPMN#
            where SumaCotizacion > 0
            order by Identificacion
    </cfquery>  
</cfif>



