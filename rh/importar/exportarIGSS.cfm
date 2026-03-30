<!--- VARIABLES DE TRADUCCION --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Semanal" default="Semanal"	returnvariable="LB_Semanal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Bisemanal" default="Bisemanal" returnvariable="LB_Bisemanal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Quincenal" default="Quincenal" returnvariable="LB_Quincenal"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Mensual" default="Mensual" returnvariable="LB_Mensual"/>
<!--- FIN DE VARIABLES DE TRADUCCION --->
<cfparam name="url.tiporep" type="string">
<cfparam name="url.CPmes" type="numeric">
<cfparam name="url.CPperiodo" type="numeric">

<cfparam name="session.debug" type="boolean" default="false">
<cfset session.debug = false>
<cfsetting requesttimeout="#3600#">
<!--- NUMERO PATRONAL --->
<cfquery name="rscheck3" datasource="#session.DSN#">
	select Pvalor as numeropatronal
	from RHParametros
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and Pcodigo = 300
</cfquery>
<cfset bNumeropatronal = rscheck3.numeropatronal>
<!--- DATOS DE LA EMPRESA --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Enombre,Eidentificacion,direccion1,Etelefono1,Etelefono2,Efax,atencion,direccion2,Eactividad,
	<cfif ListFind('sybase,sqlserver', Application.dsinfo[session.dsn].type)>
	case when charindex('.', ciudad) > 1 then substring( ciudad, 1, charindex('.',ciudad)-1) else null end  as CodigoMunicipio,
	case when charindex('.', estado) > 1 then substring( estado, 1, charindex('.',estado)-1) else null end  as CodigoDepto,
	<cfelseif ListFind('oracle', Application.dsinfo[session.dsn].type) >
	coalesce(substr(ciudad,0,instr(ciudad,'.',1)-1), '') as CodigoMunicipio,
	coalesce(substr(estado,0,instr(estado,'.',1)-1), '') as CodigoDepto,
	<cfelse>
	null,null,
	</cfif>
	ciudad, estado
	from Empresa a
	inner join Direcciones b
		on b.id_direccion =a.id_direccion
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
	  and Ereferencia = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfset Empresa = ucase(rsEmpresa.Enombre)> 
<cfset NIT = rsEmpresa.Eidentificacion	> 
<cfset direccion = ucase(rsEmpresa.direccion1)>
<cfset telefonos = rsEmpresa.Etelefono1>
<cfset email = rsEmpresa.Direccion2>
<cfif LEN(TRIM(rsEmpresa.Etelefono2))><cfset telefonos = telefonos &","&rsEmpresa.Etelefono2></cfif>
<cfset Contacto = rsEmpresa.Atencion>
<cfset fax = rsEmpresa.Efax>
<cfset municipio = rsEmpresa.CodigoMunicipio>
<cfset depto = rsEmpresa.CodigoDepto>
<cfset Actividad = rsEmpresa.Eactividad>
<cfset Lvar_FechaInicio = CreateDate(#url.CPperiodo#,#url.CPmes#,1)>
<cfset Lvar_FechaFin = DateAdd('d',-1,DateAdd('m',1,Lvar_FechaInicio))>
<!--- Obtiene la fecha inicial de las nómias que correspondan al periodo mes indicados por los parámetros --->
<cfquery name="rscheck1" datasource="#session.DSN#">
	select min(CPdesde) as f1 
	from  CalendarioPagos 
	where CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
		and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
		and Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>	
<cfset fechadesde = rscheck1.f1>
<!--- Obtiene la fecha final de las nómias que correspondan al periodo mes indicados por los parámetros --->
<cfquery name="rscheck2" datasource="#session.DSN#">
	select  max(CPhasta) as f2
	from  CalendarioPagos 
	where CPmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPmes#">
		and CPperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#url.CPperiodo#">
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<cfset fechahasta = rscheck2.f2>
<cftransaction>


<!--- TABLA DE LOS EMPLEADOS --->
<cf_dbtemp name="salidaReporteIGSS" returnvariable="salidaRIGSS" datasource="#session.dsn#">
	<cf_dbtempcol name="DEid"			type="numeric" 	mandatory="no">
	<cf_dbtempcol name="IDliquidacion"	type="varchar(10)" 	mandatory="no">
	<cf_dbtempcol name="NumeroAfiliado"	type="varchar(255)" 	mandatory="no">
	<cf_dbtempcol name="nombre"  		type="char(30)"	mandatory="no">
	<cf_dbtempcol name="Apellido1"  	type="char(30)"	mandatory="no">
	<cf_dbtempcol name="Apellido2"  	type="char(30)"	mandatory="no">
	<cf_dbtempcol name="ApellidoCasada"	type="char(30)"	mandatory="no">
	<cf_dbtempcol name="Salario"  		type="money" 	mandatory="no">
	<cf_dbtempcol name="FechaD" 		type="date" 	mandatory="no">
	<cf_dbtempcol name="FechaH" 		type="date" 	mandatory="no">
	<cf_dbtempcol name="CodigoCentro"	type="char(5)" 	mandatory="no">
	<cf_dbtempcol name="NIT"			type="char(20)"	mandatory="no">
	<cf_dbtempcol name="CodOcupacion"	type="char(10)" mandatory="no">
	<cf_dbtempcol name="Condicion"		type="char(1)" 	mandatory="no">
	<cf_dbtempcol name="Deducciones"	type="money" 	mandatory="no">
	<cf_dbtempcol name="Tipo"			type="char(1)" 	mandatory="no">
	<cf_dbtempcol name="RCNid"    	type="numeric"    mandatory="no">
	<cf_dbtempcol name="Tcodigo"    	type="char(5)"    mandatory="no">
</cf_dbtemp>

	<!--- TABLA TEMPORAL PARA CALENDARIOS DE PAGO --->
	<cf_dbtemp name="calendariosRI" returnvariable="calendarioRI">
		<cf_dbtempcol name="RCNid"      type="int"        mandatory="yes">
		<cf_dbtempcol name="Codigo"    type="varchar(10)"   mandatory="no">
		<cf_dbtempcol name="RCdesde"    type="datetime"   mandatory="no">
		<cf_dbtempcol name="RChasta"    type="datetime"   mandatory="no">
		<cf_dbtempcol name="Tcodigo"    type="char(5)"    mandatory="no">
		<cf_dbtempcol name="CPtipo"    type="int"    mandatory="no">
		<cf_dbtempcol name="FechaPago"  type="datetime"   mandatory="no">
		<cf_dbtempkey cols="RCNid">
	</cf_dbtemp>


    <cfset fecha = Now()>
    <cfset fecha1_temp = createdate( 6100, 01, 01 )>
   
   	<!---  SE LLENA LA TABLA DE CALENARIOS  --->
    <cfquery datasource="#session.dsn#">	
		insert into #calendarioRI#(RCNid,Codigo, RCdesde, RChasta, Tcodigo, FechaPago,CPtipo)
		select CPid,
		<cfif ListFind('sybase,sqlserver', Application.dsinfo[session.dsn].type)>
			substring( CPcodigo, 8,3)
			<cfelseif ListFind('oracle', Application.dsinfo[session.dsn].type) >
			substr(CPcodigo,-4,3)
			<cfelse>
			'0'
			</cfif>
			,CPdesde, CPhasta, Tcodigo, CPfpago,CPtipo
		from CalendarioPagos
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		  and CPperiodo = #trim(url.CPperiodo)#
          and CPmes = #trim(url.CPmes)#
		  <cfif isdefined('url.Tcodigo') and len(trim(url.Tcodigo))>
		  		and Tcodigo ='#url.Tcodigo#'
		  </cfif>
		  and CPnocargasley = 0
		  <!--- Excepto los empleados de la nomina confidencial --->
		  and Tcodigo not in ('G3')
		--  and CPtipo <> 2
	</cfquery>
	
    <!---cf_dumptable var="#calendarioRI#" abort="false"--->
    <!---  SE LLENA LA TABLA CON LOS EMPLEADOS QUE ESTAN EN LOS CALENDARIOS DE PAGOS DEL PERIODO--->
    <cfquery name="consulta" datasource="#session.DSN#">
    	select *
    	from HPagosEmpleado a
    	where RCNid = 300161
    </cfquery>
    <!---cfdump var="#consulta#"--->
    <cfquery name="rsEmpleados" datasource="#session.DSN#">
    	insert into #salidaRIGSS#(IDliquidacion,RCNid,Tcodigo,DEid,NumeroAfiliado,nombre,Apellido1,Apellido2,ApellidoCasada,NIT,Tipo)
        	select distinct cp.Codigo,cp.RCNid,cp.Tcodigo,pe.DEid,coalesce(DEdato1,''),DEnombre,DEapellido1,DEapellido2,coalesce(DEdato5,''),DEdato3,'E'
            from #calendarioRI# cp
            inner join HPagosEmpleado pe
                on pe.RCNid = cp.RCNid
            inner join DatosEmpleado de
                on pe.DEid = de.DEid
			inner join CargasEmpleado ce
				on ce.DEid = de.DEid
			inner join DCargas dc
				on dc.DClinea = ce.DClinea
			inner join ECargas ec
				on ec.ECid = dc.ECid
   		where ec.ECauto = 1
		  and dc.DCprovision = 0
		<cfif isdefined('url.Tipo') and url.Tipo EQ 'R'>
		  and CEvaloremp is not null
		  and CEvalorpat is not null
		<cfelseif isdefined('url.Tipo') and url.Tipo EQ 'U'>
		  and CEvaloremp is null
		  and CEvalorpat is null
		</cfif>
    </cfquery>
    <!---cf_dumptable var="#salidaRIGSS#"--->
     <cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #salidaRIGSS#
        set Salario = coalesce((select sum(SEsalariobruto)
        							 from #calendarioRI# cp
									 inner join HSalarioEmpleado hse
									 	on hse.RCNid = cp.RCNid
                                     where hse.DEid = #salidaRIGSS#.DEid
                                       and hse.RCNid = #salidaRIGSS#.RCNid
        							),0.00)
   	</cfquery>
	
	<!--- LO DEFINIDO EN LA CONFIGURACIÓN DEL REPORTE --->
	<cfquery name="rsSalarioOrd" datasource="#session.DSN#">
    	update #salidaRIGSS#
        set Salario = Salario + (select coalesce(sum(ICmontores),0.00)
                            from #calendarioRI# cp
                            inner join HIncidenciasCalculo hic
                            	on hic.RCNid = cp.RCNid
                            where DEid = #salidaRIGSS#.DEid
                              and hic.RCNid = #salidaRIGSS#.RCNid
							  and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'SALORDINARIO'
											where c.RHRPTNcodigo = 'RMI'
											  and c.Ecodigo = #session.Ecodigo#))
    </cfquery>
	 <cfquery name="rsFechaIngreso" datasource="#session.DSN#">
	 	update #salidaRIGSS#
		set FechaD = (select EVfantig 
					from EVacacionesEmpleado
					where DEid = #salidaRIGSS#.DEid)
	 </cfquery>
	 <cfquery name="rsFechaSalida" datasource="#session.DSN#">
    	update #salidaRIGSS#
        set FechaH = (select max(DLfvigencia)
                        from DLaboralesEmpleado le
                            inner join RHTipoAccion ta
                            on ta.Ecodigo = le.Ecodigo
                            and ta.RHTid = le.RHTid
                            and ta.RHTcomportam in(1,2)
                        where le.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
                          and le.DLfvigencia  between <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#">
                              				and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaFin#">
                          and le.DEid = #salidaRIGSS#.DEid
        
        )
    </cfquery>
	<!--- ocupacion --->
	<cfquery name="rsFechaSalida" datasource="#session.DSN#">
		update #salidaRIGSS#
		set CodOcupacion = (select min(c.RHOcodigo)
							from LineaTiempo a
							inner join RHPlazas b
								  on b.RHPid = a.RHPid
							inner join RHPuestos c
								  on c.RHPcodigo = b.RHPPuesto	 
							inner join RHOcupaciones d
								  on d.RHOcodigo =c.RHOcodigo 	   
							where DEid =#salidaRIGSS#.DEid
							  and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#"> between LTdesde and LThasta)
	</cfquery>
	<!--- condicion --->
	<cfquery name="rsFechaSalida" datasource="#session.DSN#">
		update #salidaRIGSS#
		set Condicion =(select case RHTtiponomb
						when 0 then 'P'
						when 1 then 'T'
						else '' end
						from LineaTiempo
						where DEid =#salidaRIGSS#.DEid
						  and <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_FechaInicio#"> between LTdesde and LThasta)
	</cfquery>
	<!--- SALARIO EXTRA --->
	<cfquery name="rsSalarioExtra" datasource="#session.DSN#">
    	update #salidaRIGSS#
        set Salario = Salario + (select coalesce(sum(ICmontores),0.00)
                            from #calendarioRI# cp
                            inner join HIncidenciasCalculo hic
                            	on hic.RCNid = cp.RCNid
                            where DEid = #salidaRIGSS#.DEid
                              and hic.RCNid = #salidaRIGSS#.RCNid
							  and CIid in (select distinct a.CIid
											from RHReportesNomina c
												inner join RHColumnasReporte b
															inner join RHConceptosColumna a
															on a.RHCRPTid = b.RHCRPTid
													 on b.RHRPTNid = c.RHRPTNid
													and b.RHCRPTcodigo = 'SALEXTRA'
											where c.RHRPTNcodigo = 'RMI'
											  and c.Ecodigo = #session.Ecodigo#))
	</cfquery>
	
	<!--- SUSPENDIDOS : Todas aquella acciones relaccionadas con IGSS.  --->
	<cfquery name="rsEmpleados" datasource="#session.DSN#">
		insert into #salidaRIGSS#(DEid,NumeroAfiliado,nombre,Apellido1,Apellido2,ApellidoCasada,NIT,Tipo,FechaD,FechaH)
		select distinct sp.DEid,coalesce(DEdato1,''),DEnombre,DEapellido1,DEapellido2,coalesce(DEdato5,''),DEdato3,'S',sp.DLfvigencia,sp.DLffin
		from DLaboralesEmpleado sp
		inner join RHTipoAccion rh
		  on  sp.RHTid = rh.RHTid 
		  and sp.Ecodigo = rh.Ecodigo 
		inner join DatosEmpleado de
			on de.DEid = sp.DEid
		where sp.DLestado = 0
		  and sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and rh.RHTcomportam = 5 
		<!---  and rh.RHTpaga = 1 --->
		  and  ((sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#fechadesde#">
		  and <cfqueryparam cfsqltype="cf_sql_date" value="#fechahasta#">) 
		  or (sp.DLffin between <cfqueryparam cfsqltype="cf_sql_date" value="#fechadesde#"> 
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#fechahasta#">) 
	   or (<cfqueryparam cfsqltype="cf_sql_date" value="#fechadesde#"> between sp.DLfvigencia and sp.DLffin) 
	   or (<cfqueryparam cfsqltype="cf_sql_date" value="#fechahasta#"> between sp.DLfvigencia and sp.DLffin))
    </cfquery>
	<!--- actualiza la nomina donde se dió --->
	<cfquery name="updateSusp" datasource="#session.DSN#">
		update #salidaRIGSS#
		set IDliquidacion = (select distinct Codigo
							from #calendarioRI#
							where (#salidaRIGSS#.FechaD between RCdesde and RChasta or
									#salidaRIGSS#.FechaH between RCdesde and RChasta)
							  and Tcodigo = #salidaRIGSS#.Tcodigo)
		where Tipo ='S'
	</cfquery>
	<!--- LICENCIAS : Todos aquellos permisos con goce y sin goce. Según lo conversado con Daniell Villagran 22julio2010--->
	<cfquery name="rsEmpleados" datasource="#session.DSN#">
		insert into #salidaRIGSS#(DEid,NumeroAfiliado,nombre,Apellido1,Apellido2,ApellidoCasada,NIT,Tipo)
		select distinct sp.DEid,coalesce(DEdato1,''),DEnombre,DEapellido1,DEapellido2,coalesce(DEdato5,''),DEdato3,'L' 
		from DLaboralesEmpleado sp
		inner join RHTipoAccion rh
		  on  sp.RHTid = rh.RHTid 
		  and sp.Ecodigo = rh.Ecodigo 
		inner join DatosEmpleado de
			on de.DEid = sp.DEid
		where sp.DLestado = 0
		  and sp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">		
		  and rh.RHTcomportam = 4
		<!---  and rh.RHTpaga = 0 --->
		  and  ((sp.DLfvigencia between <cfqueryparam cfsqltype="cf_sql_date" value="#fechadesde#">
		  and <cfqueryparam cfsqltype="cf_sql_date" value="#fechahasta#">) 
		  or (sp.DLffin between <cfqueryparam cfsqltype="cf_sql_date" value="#fechadesde#"> 
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#fechahasta#">) 
	   or (<cfqueryparam cfsqltype="cf_sql_date" value="#fechadesde#"> between sp.DLfvigencia and sp.DLffin) 
	   or (<cfqueryparam cfsqltype="cf_sql_date" value="#fechahasta#"> between sp.DLfvigencia and sp.DLffin))
    </cfquery>
	<!--- actualiza la nomina donde se dió --->
	<cfquery name="updateSusp" datasource="#session.DSN#">
		update #salidaRIGSS#
		set IDliquidacion = (select distinct Codigo
							from #calendarioRI#
							where (#salidaRIGSS#.FechaD between RCdesde and RChasta or
									#salidaRIGSS#.FechaH between RCdesde and RChasta)
							  and Tcodigo = #salidaRIGSS#.Tcodigo)
		where Tipo ='L'
	</cfquery>
<cfquery name="consulta" datasource="#session.DSN#">
	select IDliquidacion||'|'||NumeroAfiliado||'|'||nombre||'|'||Apellido1||'|'||Apellido2
	from #salidaRIGSS#
	where Tipo = 'E'
</cfquery>
<!--- 
<cfdump var="#consulta#">
<cf_dumptable var="#salidaRIGSS#"> --->

<!--- -- encabezado --->
<cf_dbfunction name="date_format" args="RCdesde,dd/mm/yyyy" returnvariable="Lvar_Fdesde">
<cf_dbfunction name="date_format" args="RChasta,dd/mm/yyyy" returnvariable="Lvar_Fhasta">
<cf_dbfunction name="date_format" args="FechaD,dd/mm/yyyy" returnvariable="Lvar_FechaD">
<cf_dbfunction name="date_format" args="FechaH,dd/mm/yyyy" returnvariable="Lvar_FechaH">
<cf_dbtemp name="reporteEIGSS2" returnvariable="reporte1" datasource="#session.dsn#">
	<cf_dbtempcol name="ordenado"	type="int"  			mandatory="no">
	<cf_dbtempcol name="salida"  	type="varchar(1024)" 	mandatory="no">
</cf_dbtemp>
<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 1,'2.1.0'||'|'||'#LSDateFormat(Now(),'dd/mm/yyyy')#'||'|'||'#bNumeropatronal#'||'|'||'<cfif CPmes LTE 9>0</cfif>#CPmes#'||'|'||'#CPperiodo#'||'|'||'#Empresa#'||'|'||'#NIT#'||'|'||'Anamaria.perez@gt.henkel.com'||'|'||'0'
	from dual
</cfquery>	
<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 2,'[centros]'	
	from dual
</cfquery>	
<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 3,'1'||'|'|| '#Empresa#'||'|'||'#direccion#'||'|'||'1'||'|'||'#telefonos#'||'|'||'#fax#'||'|'||'#Contacto#'||'|'||'#email#'||'|'||'#municipio#'||'|'||'#depto#'||'|'||'#actividad#'
	from dual
</cfquery>	
<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 4,'[tiposPlanilla]'
	from dual
</cfquery>	
<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 5,substring(rtrim(Tcodigo),2,2)||'|'||Tdescripcion||'|'||'S'||'|'||
		case Ttipopago 
			when 0 then 'S'
			when 1 then 'C'
			when 2 then 'Q'
			when 3 then 'M'
			else ''
			end ||'|'||'#depto#'||'|'||'#actividad#'||'|'||'N'
		from TiposNomina
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and Tcodigo not in ('G3')
</cfquery>	

<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 6,'[liquidaciones]'
	from dual
</cfquery>	
<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 7,case substring(trim(Codigo),0,2) when '00' then substring(trim(Codigo),3,3) else trim(Codigo) end||'|'|| trim(Tcodigo)||'|'||#preservesinglequotes(Lvar_Fdesde)#||'|'|| #preservesinglequotes(Lvar_Fhasta)#||'|'||
			case CPtipo 
			when 0 then 'O'
			when 1 then 'C'
			when 2 then 'O'
			else '' end||'|'||'PENDIENTE NOTA DE CARGO'
	from #calendarioRI#
</cfquery>	
<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 8,'[empleados]'
	from dual
</cfquery>	
<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 9,case substring(trim(IDliquidacion),0,2) when '00' then substring(trim(IDliquidacion),3,3) else trim(IDliquidacion) end||'|'||Replace(trim(NumeroAfiliado),'-','')||'|'||
	ucase(case INSTRB(nombre, ' ', 1, 1)
	   		 when 0 then trim(nombre)
			 else trim(substring(nombre,1,INSTRB(nombre, ' ', 1, 1)))
			 end)||'|'||ucase(case INSTRB(nombre, ' ', 1, 1)
	   		 when 0 then ''
			 else trim(substring(nombre,INSTRB(nombre, ' ', 1, 1),99))
			 end)||'|'||ucase(trim(Apellido1))||'|'||ucase(trim(Apellido2))||'|'||
	ucase(trim(ApellidoCasada))||'|'||trim(Salario)||'|'||#preservesinglequotes(Lvar_FechaD)#
	||'|'||#preservesinglequotes(Lvar_FechaH)#||'|'||'1'||'|'||Replace(trim(Nit),'-','')||'|'||trim(CodOcupacion)||'|'||trim(Condicion)||'|'
	from #salidaRIGSS#
	where Tipo = 'E'
	order by NumeroAfiliado,IDLiquidacion
</cfquery>	
<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 10,'[suspendidos]'
	from dual
</cfquery>	
<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 11,case substring(trim(IDliquidacion),0,2) when '00' then substring(trim(IDliquidacion),3,3) else trim(IDliquidacion) end||'|'||ucase(trim(NumeroAfiliado))||'|'||ucase(trim(nombre))||'|'||'|'||ucase(trim(Apellido1))||'|'||ucase(trim(Apellido2))||'|'||
	ucase(trim(ApellidoCasada))||'|'||#preservesinglequotes(Lvar_FechaD)#
	||'|'||#preservesinglequotes(Lvar_FechaH)#
	from #salidaRIGSS#
	where Tipo = 'S'	
</cfquery>	
<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 12,'[licencias]'
	from dual
</cfquery>	
<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 13,trim(IDliquidacion)||'|'||trim(NumeroAfiliado)||'|'||ucase(trim(nombre))||'|'||'|'||ucase(trim(Apellido1))||'|'||ucase(trim(Apellido2))||'|'||
	ucase(trim(ApellidoCasada))||'|'||#preservesinglequotes(Lvar_FechaD)#
	||'|'||#preservesinglequotes(Lvar_FechaH)#
	from #salidaRIGSS#
	where Tipo = 'L'
</cfquery>	
<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 14,'[juramento]'
	from dual
</cfquery>	
<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 15,ucase('bajo mi exclusiva y absoluta responsabilidad, declaro que la información que aqui consigno es fiel y exacta, que esta planilla incluye a todos los trabajadores que estuvieron a mi servicio y que sus salarios son los efectivamente devengado, durante el mes arriba indicado')
	from dual
</cfquery>
<cfquery name="ERR" datasource="#session.DSN#">
	insert into #reporte1# (ordenado, salida)
	select 16,'[finPlanilla]'
	from dual
</cfquery>	

<cfquery name="ERR" datasource="#session.DSN#">
	select salida from #reporte1# order by ordenado
</cfquery> 

</cftransaction>
