<cfparam name="url.periodo" 		type="integer" 	default="-1">	<!----Periodo--->
<cfparam name="url.mes" 			type="integer"	default="-1">	<!----Mes--->
<cfparam name="url.calendariopago" 	type="numeric" 	default="-1">	<!---Calendario de pago---->
<cfparam name="url.historico" 		type="string" 	default="0">	<!---Son nominas historicas---->
<!----Variables de traduccion---->
<cfinvoke Key="MSG_NoHayDatosParaLosFiltrosSeleccionados" Default="No hay datos para los filtros seleccionados" returnvariable="MSG_NoHayDatosParaLosFiltrosSeleccionados" component="sif.Componentes.Translate" method="Translate"/>
<cfinvoke Key="MSG_NoSeHaDefinidoElFormatoParaLaGeneracionDelArchivo" Default="No se ha definido el formato para la generación del archivo" returnvariable="MSG_NoSeHaDefinidoElFormatoParaLaGeneracionDelArchivo" component="sif.Componentes.Translate" method="Translate"/>
<cfset prefijo = ''>
<cfif isdefined("url.historico") and url.historico EQ 1>
	<cfset prefijo = 'H'>
</cfif>
<!---►►Tabla Temporal de Datos◄◄--->
<cf_dbtemp name="Temp_rhDeducAsoSUTEl_V1" returnvariable="DATOS" datasource="#session.dsn#">
	<cf_dbtempcol name="Identidad" 	type="varchar(60)"  mandatory="yes">
	<cf_dbtempcol name="Codigo" 	type="varchar(60)"	mandatory="yes">
    <cf_dbtempcol name="Monto" 	    type="varchar(20)"	mandatory="no">
    <cf_dbtempcol name="Mes" 	    type="varchar(2)"	mandatory="no"> 
    <cf_dbtempcol name="Nombre" 	type="varchar(60)"	mandatory="no"> 
</cf_dbtemp>
<!----Verificar si existe calendario de pago---->
<cfquery name="rsExisteCalendario" datasource="#session.DSN#">
	select 1 from CalendarioPagos 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		<cfif isdefined("url.periodo") and url.periodo NEQ -1 and isdefined("url.mes") and url.mes NEQ -1>
			and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
			and CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
		<cfelseif isdefined("url.calendariopago") and url.calendariopago NEQ -1>
			and CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.calendariopago#">
		</cfif>
</cfquery>
<cfquery name="rsParametro" datasource="#session.DSN#">
	select 1
	from RHReportesNomina 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and RHRPTNcodigo = 'DEDAS'
</cfquery>
<cfif rsParametro.RecordCount EQ 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select '#MSG_NoSeHaDefinidoElFormatoParaLaGeneracionDelArchivo#' as Error
		from dual
	</cfquery>
<cfelse>
	<cfif rsExisteCalendario.RecordCount EQ 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			select '#MSG_NoHayDatosParaLosFiltrosSeleccionados#' as Error
			from dual
		</cfquery>
	<cfelse>
          <cf_dbfunction name="OP_concat"	returnvariable="_Cat">
          <cf_dbfunction name="to_char" args="d.CPmes" returnvariable="LvarMes" datasource="#session.dsn#">
         <!---  <cf_dbfunction name="to_char" args="e.DEidentificacion" returnvariable="Cedula" datasource="#session.dsn#">--->
         <cf_dbfunction name="string_part" args="rtrim(e.DEidentificacion)|1|1" 	returnvariable="cedula1"  delimiters="|">
          <cf_dbfunction name="string_part" args="rtrim(e.DEidentificacion)|2|4" 	returnvariable="cedula2"  delimiters="|">
           <cf_dbfunction name="string_part" args="rtrim(e.DEidentificacion)|6|4" 	returnvariable="cedula3"  delimiters="|">
		<cfquery name="Data" datasource="#session.DSN#">					
			<!----Tipos de deduccion--->
			select RIGHT('00' #_Cat# #LvarMes#,2) as mes,ltrim(rtrim(td.TDcodigo)) as codigo, <!---ltrim(rtrim(e.DEdato1)) as identidad,--->
             #Cedula1# #_Cat#'-'#_Cat#
             #Cedula2# #_Cat#'-'#_Cat#
             #Cedula3# as identidad ,
            {fn concat({fn concat({fn concat({fn concat(
		e.DEapellido1 , ' ' )}, e.DEapellido2 )}, ' ' )}, e.DEnombre )}  as Nombre,
        b.DCvalor as Monto
       <!---Convert(INTEGER,b.DCvalor,2) as Monto--->
			from HSalarioEmpleado a
				inner join HDeduccionesCalculo b
					on a.RCNid = b.RCNid
					and a.DEid = b.DEid
				inner join DeduccionesEmpleado c
					on b.Did = c.Did
					and b.DEid = c.DEid
					and c.TDid in (select TDid
									from RHReportesNomina c
										inner join RHColumnasReporte b
											on b.RHRPTNid = c.RHRPTNid
										inner join RHConceptosColumna a
											on a.RHCRPTid = b.RHCRPTid
											and a.TDid is not null
									where c.RHRPTNcodigo = 'DEDAS'
										and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									 )
				inner join TDeduccion td
					on c.TDid=td.TDid
				inner join CalendarioPagos d
					on a.RCNid = d.CPid
					<cfif isdefined("url.periodo") and url.periodo NEQ -1 and isdefined("url.mes") and url.mes NEQ -1>
						and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
						and d.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
					<cfelseif isdefined("url.calendariopago") and url.calendariopago NEQ -1>
						and d.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.calendariopago#">
					</cfif>
					
				inner join DatosEmpleado e
					on a.DEid = e.DEid	
        
                    
			union all
			
			<!---Conceptos de pago--->
			select RIGHT('00' #_Cat# #LvarMes#,2)   as mes,ltrim(rtrim(ci.CIcodigo)) as codigo, <!---ltrim(rtrim(e.DEdato1)) as identidad, --->
             #Cedula1# #_Cat#'-'#_Cat#
             #Cedula2# #_Cat#'-'#_Cat#
             #Cedula3# as identidad ,
            {fn concat({fn concat({fn concat({fn concat(
		e.DEapellido1 , ' ' )}, e.DEapellido2 )}, ' ' )}, e.DEnombre )}  as Nombre,
             <!---Convert(INTEGER,b.ICvalor,2) as Monto--->
             b.ICvalor as Monto
			from HSalarioEmpleado a
				inner join HIncidenciasCalculo b
					on a.RCNid = b.RCNid
					and a.DEid = b.DEid	
					and b.CIid in (select CIid
									from RHReportesNomina c
										inner join RHColumnasReporte b
											on b.RHRPTNid = c.RHRPTNid
										inner join RHConceptosColumna a
											on a.RHCRPTid = b.RHCRPTid
											and a.CIid is not null
									where c.RHRPTNcodigo = 'DEDAS'
										and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
									 )
				inner join CIncidentes ci
					on b.CIid = ci.CIid					
				inner join CalendarioPagos d
					on a.RCNid = d.CPid
					<cfif isdefined("url.periodo") and url.periodo NEQ -1 and isdefined("url.mes") and url.mes NEQ -1>
						and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
						and d.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
					<cfelseif isdefined("url.calendariopago") and url.calendariopago NEQ -1>
						and d.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.calendariopago#">
					</cfif>
				inner join DatosEmpleado e
					on a.DEid = e.DEid	
			union all
			
			<!---Cargas--->
			select RIGHT('00' #_Cat# #LvarMes#,2)  as mes, ltrim(rtrim(dc.DCcodigo)) as codigo,<!---ltrim(rtrim(e.DEdato1)) as identidad,--->
             #Cedula1# #_Cat#'-'#_Cat#
             #Cedula2# #_Cat#'-'#_Cat#
             #Cedula3# as identidad ,
            {fn concat({fn concat({fn concat({fn concat(
		e.DEapellido1 , ' ' )}, e.DEapellido2 )}, ' ' )}, e.DEnombre )}  as Nombre,
            case when b.CCvalorpat=0 then
																				b.CCvaloremp		<!---Convert(INTEGER,b.CCvaloremp,2)--->
																			  else
																				b.CCvalorpat		<!---Convert(INTEGER,b.CCvalorpat,2)--->
																			  end as Monto
			from HSalarioEmpleado a
				inner join HCargasCalculo b
					on a.RCNid = b.RCNid
					and a.DEid = b.DEid
					and b.DClinea in (select DClinea
										from RHReportesNomina c
											inner join RHColumnasReporte b
												on b.RHRPTNid = c.RHRPTNid
											inner join RHConceptosColumna a
												on a.RHCRPTid = b.RHCRPTid
												and a.DClinea is not null
										where c.RHRPTNcodigo = 'DEDAS'
											and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
										 )
				inner join DCargas dc
					on b.DClinea=dc.DClinea
				inner join CalendarioPagos d
					on a.RCNid = d.CPid
					<cfif isdefined("url.periodo") and url.periodo NEQ -1 and isdefined("url.mes") and url.mes NEQ -1>
						and d.CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.periodo#">
						and d.CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.mes#">
					<cfelseif isdefined("url.calendariopago") and url.calendariopago NEQ -1>
						and d.CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.calendariopago#">
					</cfif>
				inner join DatosEmpleado e
					on a.DEid = e.DEid	
		</cfquery>
        
        

        <cfquery name="ERRTemp" dbtype="query">
        	select  mes, codigo, identidad, Nombre, sum(Monto) as Monto 
            	from Data 
           where identidad = identidad
           and codigo = codigo
           GROUP BY mes, codigo, identidad, Nombre
        </cfquery> 

        <cfloop query="ERRTemp">
        	<cfset LvarValor = LSNumberFormat(ERRTemp.Monto,'999.99')>	
         	<cfset LvarValor = replace(LvarValor,'.','','ALL')>
            <cfquery datasource="#session.dsn#">
                insert into #DATOS# (Mes, Codigo, Identidad, Nombre, Monto)
                 values ('#ERRTemp.mes#',#ERRTemp.Codigo#,'#ERRTemp.identidad#','#ERRTemp.Nombre#','#LvarValor#')
            </cfquery>
        </cfloop>
        <cfquery name="ERRTemp" datasource="#session.dsn#">
        	select  Mes, Codigo, Identidad, Nombre, Monto 
            	from #DATOS# 
        </cfquery>

<cfloop query="ERRTemp"><!--- Actualiza campos de la identificacion, agregando unicamente numeros y rellenando con '0' a la izquierda--->
	<cfset NuevaMayuscula =ucase(#ERRTemp.Nombre#)>
	<cfset NuevaMayuscula = REReplaceNoCase(NuevaMayuscula,"Á","A","ALL") >
	<cfset NuevaMayuscula = REReplaceNoCase(NuevaMayuscula,"É","E","ALL") >
	<cfset NuevaMayuscula = REReplaceNoCase(NuevaMayuscula,"Í","I","ALL") >
	<cfset NuevaMayuscula = REReplaceNoCase(NuevaMayuscula,"Ó","O","ALL") >
	<cfset NuevaMayuscula = REReplaceNoCase(NuevaMayuscula,"Ú","U","ALL") >
	<cfset NuevaMayuscula = REReplaceNoCase(NuevaMayuscula,"Ñ","N","ALL") >
    
            <cfquery name="algo" datasource="#session.dsn#">
        	update  #DATOS# 
            set Nombre = '#NuevaMayuscula#'
            where Identidad = '#ERRTemp.Identidad#'
           and Codigo = #ERRTemp.Codigo#
        </cfquery>
</cfloop>

           <cfquery name="ERRTemp" datasource="#session.dsn#">
        	select  Mes, Codigo, Identidad, Nombre, Monto 
            	from #DATOS# 
        </cfquery>
        
        <cfquery name="ERR" datasource="#session.dsn#">
            <cfloop query="ERRTemp">
                 select rtrim('#ERRTemp.mes##ERRTemp.codigo##ERRTemp.identidad##ERRTemp.Nombre##RepeatString(' ', (40 - len(ERRTemp.Nombre)) )##RepeatString(' ', (10 - len(ERRTemp.Monto)) )##rtrim(ERRTemp.Monto)#') as Linea 				                  
                 from dual 
				<cfif ERRTemp.CurrentRow NEQ ERRTemp.RecordCount>
                    Union ALL
                </cfif>
            </cfloop>
        </cfquery> 
	</cfif>
</cfif>
