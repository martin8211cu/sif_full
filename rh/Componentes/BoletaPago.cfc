<cfcomponent>
	<!---►►►►►►►►►Funcion para recuperar el mensaje de la boleta de pago◄◄◄◄◄◄◄◄◄--->
	<cffunction name="getMensajeBoleta" access="public" returntype="query">
		<cfargument name="Conexion" type="string"  required="no">
        <cfargument name="Ecodigo"  type="numeric" required="no">
        
        <cfif NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('session.dsn')>
        	<CFSET  Arguments.Conexion = session.dsn>
        </cfif>
        <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('session.Ecodigo')>
        	<CFSET  Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        
		<cfquery name="rsMensajeBoleta" datasource="#Arguments.Conexion#">
        	select Ecodigo,Mensaje,BMfechaalta,BMUsucodigo,ts_rversion
            	from MensajeBoleta
            where 1=1
            <CFIF ISDEFINED('Arguments.Ecodigo')>
            	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
            </CFIF>
        </cfquery>
		<cfreturn rsMensajeBoleta>
	</cffunction>
    <!---►►►►►►►►►Funcion para Actualizar el mensaje de la boleta de pago◄◄◄◄◄◄◄◄◄--->
    <cffunction name="SetMensajeBoleta" access="public" returntype="query">
		<cfargument name="Conexion" type="string"  required="no">
        <cfargument name="Ecodigo"  type="numeric" required="no">
        <cfargument name="Mensaje"  type="string"  required="no" default="">
        
        <cfif NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('session.dsn')>
        	<CFSET  Arguments.Conexion = session.dsn>
        </cfif>
        <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('session.Ecodigo')>
        	<CFSET  Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif getMensajeBoleta().recordCount>
        	<cfquery name="rsMensajeBoleta" datasource="#Arguments.Conexion#">
        		Update MensajeBoleta set 
                	Mensaje 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Mensaje#">,
                    BMfechaalta = <cf_dbfunction name="now">,
                    BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usucodigo#">
                where 1=1
                <CFIF ISDEFINED('Arguments.Ecodigo')>
                    and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                </CFIF>
        	</cfquery>
        <cfelse>
        	<cfquery name="rsMensajeBoleta" datasource="#Arguments.Conexion#">
        		Insert into MensajeBoleta (Ecodigo,Mensaje,BMfechaalta,BMUsucodigo) values (
                	<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Mensaje#">,
                   	<cf_dbfunction name="now">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.Usucodigo#">
                    )
        	</cfquery>
        </cfif>
		<cfreturn rsMensajeBoleta>
	</cffunction>
    <!---►►►►►►►►►Funcion para Obtener la ruta de la boleta de pago◄◄◄◄◄◄◄◄◄--->
    <cffunction name="GetRutaBoleta" access="public" returntype="struct">
    	<cfargument name="Conexion" type="string"  required="no">
        <cfargument name="Ecodigo"  type="numeric" required="no">
    	
		<cfif NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('session.dsn')>
        	<CFSET  Arguments.Conexion = session.dsn>
        </cfif>
        <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('session.Ecodigo')>
        	<CFSET  Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        
    	<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#Arguments.Conexion#" Ecodigo="#Arguments.Ecodigo#" pvalor="720" default="10" returnvariable="TipoBoletaPago"/>
            
        <cfswitch expression="#TipoBoletaPago#"> 
            <cfcase value="10"> 
                <cfset Ruta.autogestion = '/cfmx/rh/expediente/consultas/HBoletaPago.cfm'>
                <cfset Ruta.pago        = '/cfmx/rh/pago/operacion/EnviarEmails.cfm'>
            </cfcase> 
            <cfcase value="20">
                <cfset Ruta.autogestion = '/cfmx/rh/expediente/consultas/HBoletaPagoDosTercios.cfm'>
                <cfset Ruta.pago        = '/cfmx/rh/pago/operacion/EnviarEmailsDosTercios.cfm'>
            </cfcase>
            <cfcase value="30">
                <cfset Ruta.autogestion = '/cfmx/rh/expediente/consultas/HBoletaPagoDosTercios.cfm'>
                <cfset Ruta.pago        = '/cfmx/rh/pago/operacion/EnviarEmailsDosTercios.cfm'>
            </cfcase>
            <cfcase value="40">
                <cfset Ruta.autogestion = '/cfmx/rh/expediente/consultas/HBoletaPagoDosTerciosImp.cfm'>				
                <cfset Ruta.pago        = '/cfmx/rh/pago/operacion/EnviarEmailsDosTerciosImp.cfm'>
            </cfcase>
            <cfdefaultcase> 
                <cfset Ruta.autogestion = '/cfmx/rh/expediente/consultas/HBoletaPago.cfm'>
                <cfset Ruta.pago        = '/cfmx/rh/pago/operacion/EnviarEmails.cfm'>
            </cfdefaultcase> 
        </cfswitch> 
        <cfset structRuta = StructNew()>  
        <cfset StructInsert(structRuta, "autogestion", Ruta.autogestion, 1)>  
        <cfset StructInsert(structRuta, "pago",        Ruta.pago, 1)>  
        <cfreturn structRuta>
	</cffunction>
    
    <cffunction access="public" name="getEmail" output="false" returntype="string">
        <cfargument name="Usucodigo" required="yes" type="numeric">
        <cfquery name="rs" datasource="asp">
            select b.Pemail1 as Email
            from Usuario a
            	inner join DatosPersonales b
                	on a.datos_personales = b.datos_personales
            where a.Usucodigo = #Arguments.Usucodigo#
        </cfquery>
        <cfreturn rs.Email>
	</cffunction>
    <cffunction access="public" name="EnvioBoletasPago" output="true" returntype="string">
    	<cfargument name="Conexion" 		type="string"  	required="no">
        <cfargument name="Ecodigo"  		type="numeric" 	required="no">
        <cfargument name="RCNid" 			type="numeric" 	required="yes">
        <cfargument name="MensajeBoleta" 	type="string" 	required="no" default="">
        
    	
		<cfif NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('session.dsn')>
        	<CFSET Arguments.Conexion = session.dsn>
        </cfif>
        <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('session.Ecodigo')>
        	<CFSET Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        
        <cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="720" default="20" returnvariable="TipoBoletaPago"/>
        
        <cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="190" default="" returnvariable="EmailDE"/>
		
        <cfquery name="rsPlanilla" datasource="#Arguments.Conexion#">
            select a.RCNid, b.DEid, b.DEemail
            from SalarioEmpleado a
            	inner join DatosEmpleado b
                	on b.DEid = a.DEid
            where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
             and <cf_dbfunction name="length"	args="b.DEemail"> > 0
             and b.DEemail is not null
        </cfquery>
        <cfloop query="rsPlanilla">
        
        	<cfinvoke method="ArmaCorreo" returnvariable="Mensaje">
            	<cfinvokeargument name="DEid"  			value="#rsPlanilla.DEid#">
                <cfinvokeargument name="RCNid" 			value="#rsPlanilla.RCNid#">
                <cfinvokeargument name="MensajeBoleta" 	value="#Arguments.MensajeBoleta#">
            </cfinvoke>
            
            <cfinvoke method="enviarCorreo">
            	<cfinvokeargument name="from" 		value="#EmailDE#">
                <cfinvokeargument name="to" 		value="#rsPlanilla.DEemail#">
                <cfinvokeargument name="subject" 	value="Boleta de Pago">
                <cfinvokeargument name="message" 	value="#Mensaje#">
            </cfinvoke>
        </cfloop>
   
		
        
	</cffunction>
    
    <!--- FUNCIONES--->
<cffunction access="private" name="ArmaCorreo" output="true" returntype="string">
	<cfargument name="DEid"  			required="yes" type="numeric">
	<cfargument name="RCNid" 			required="yes" type="numeric">
    <cfargument name="Titulo"   		required="no"  type="string">
	<cfargument name="Conexion" 		required="no"  type="string">
    <cfargument name="Ecodigo"  		required="no"  type="numeric">
    <cfargument name="MensajeBoleta"  	required="no"  type="string" default="">
        
    <cfif NOT ISDEFINED('Arguments.Conexion') AND ISDEFINED('session.dsn')>
		<CFSET  Arguments.Conexion = session.dsn>
    </cfif>
    <cfif NOT ISDEFINED('Arguments.Ecodigo') AND ISDEFINED('session.Ecodigo')>
        <CFSET  Arguments.Ecodigo = session.Ecodigo>
    </cfif>
    
    <cf_dbfunction name="OP_concat"	returnvariable="_Cat">  
	

	<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Semanal"
		Key="LB_Semanal" Default="Semanal"/>

	<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Bisemanal"
		Key="LB_Bisemanal" Default="Bisemanal"/>

	<cfinvoke component="sif.Componentes.Translate" returnvariable="LB_Quincenal"
		method="Translate" Key="LB_Quincenal" Default="Quincenal"/>

	<cfinvoke component="rh.Componentes.RHParametros" method="get" pvalor="1040" default="0" returnvariable="rsMostrarSalarioNominal.Pvalor"/>


 	<cfinvoke component="sif.Componentes.Translate" method="Translate" returnvariable="LB_Boleta"
			xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml"  key="LB_Boleta_Pago" default="Boleta de Pago"/> 
        
        <cfquery name="RCalculoNomina" datasource="#Arguments.Conexion#">
            select c.CPfpago, a.RCdesde, a.RChasta, a.RCDescripcion, b.Tdescripcion
                from RCalculoNomina a
                    inner join TiposNomina b
                         on a.Tcodigo = b.Tcodigo
                        and a.Ecodigo = b.Ecodigo
                    inner join CalendarioPagos c
                        on a.RCNid = c.CPid
            where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		</cfquery>
     <cfquery name="rsMoneda" datasource="#Session.DSN#">
	select Miso4217, Msimbolo 
	from Monedas a
	
	inner join TiposNomina c
	on a.Mcodigo = c.Mcodigo
	
	inner join HRCalculoNomina b
	on b.Tcodigo = c.Tcodigo 
	
	where b.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RCNid#">
</cfquery>
   
	<cfquery name="HRCalculoNomina" datasource="#Arguments.Conexion#">
		select a.Tcodigo,
		case Ttipopago 
		when 0 then '#LB_Semanal#'
		when 1 then '#LB_Bisemanal#'
		when 2 then '#LB_Quincenal#'
		else ''
		end as   descripcion,
		a.RCdesde
		from RCalculoNomina a
		  inner join TiposNomina b
			 on a.Tcodigo = b.Tcodigo
			and a.Ecodigo =  b.Ecodigo
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
	</cfquery>
	
	
	<cfquery name="rsEncabEmpleado" datasource="#Arguments.Conexion#">
		select DEapellido1 #_Cat# '  '#_Cat# DEapellido2 #_Cat# ' ' #_Cat# DEnombre  as nombreEmpl, DEemail, DEidentificacion, NTIdescripcion
		 from DatosEmpleado de
         	inner join NTipoIdentificacion ti
            	on de.NTIcodigo = ti.NTIcodigo
		where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
	</cfquery>
	
	<cfquery name="rsSalBrutoMensual" datasource="#Arguments.Conexion#">
		select coalesce(PEsalario,0) as PEsalario
		  from PagosEmpleado a
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		  and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and a.PEtiporeg = 0
		  and a.PEdesde = (select max(PEdesde)
                             from PagosEmpleado
                            where DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
                              and RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
                              and PEtiporeg = 0)
	</cfquery>
	
	<cfquery name="rsSalBrutoRelacion" datasource="#Session.DSN#">
		select coalesce(sum(PEmontores),0) as Monto
		 from PagosEmpleado a
		where a.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		  and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and a.PEtiporeg = 0
	</cfquery>
	
	<cfquery name="rsRetroactivos" datasource="#Session.DSN#">
		select sum(PEmontores) as Monto
		  from PagosEmpleado a
		where a.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		  and a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and a.PEtiporeg > 0
	</cfquery>
	
	<cfquery name="rsSalarioEmpleado" datasource="#Session.DSN#">
		 select SErenta, SEcargasempleado, SEdeducciones
		from SalarioEmpleado 
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
	</cfquery>
	
	<cfquery name="rsIncidenciasCalculo" datasource="#Session.DSN#">
		select  <cf_dbfunction name="to_char" args="ICid"  > as ICid, b.CIdescripcion, a.ICfecha, 
			   (case when CItipo < 2 then a.ICvalor
			   	else null end) as ICvalor, 
			   (case when (CItipo < 2 and a.ICvalor > 0) then round(a.ICmontores/(a.ICvalor*1.00), 2) 
			         when (CItipo = 3 and a.ICvalor > 0) then a.ICvalor
			   else null end) as ICvalorcalculado, 
			   a.ICmontores, a.ICcalculo
		from IncidenciasCalculo a
        	inner join CIncidentes b
            	on a.CIid = b.CIid
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		  and CIcarreracp = 0		<!--- no considera conceptos de pago por carrera profesional --->		
		order by b.CIcodigo
	</cfquery>
	
	<cfif rsIncidenciasCalculo.recordCount GT 0>
		<cfquery name="rsSumIncidencias" dbtype="query">
			select sum(ICmontores) as Monto
			from rsIncidenciasCalculo
		</cfquery>
		<cfset montoIncidencias = rsSumIncidencias.Monto + Iif(Len(Trim(rsRetroactivos.Monto)), DE(rsRetroactivos.Monto), DE("0.00"))>
	<cfelse>
		<cfset montoIncidencias = 0.00 + Iif(Len(Trim(rsRetroactivos.Monto)), DE(rsRetroactivos.Monto), DE("0.00"))>
	</cfif>			
	
	<cfquery name="rsIncidenciasCarreraP" datasource="#Session.DSN#">
		select  <cf_dbfunction name="to_char" args="ICid"  > as ICid, b.CIdescripcion, a.ICfecha, 
			   (case when CItipo < 2 then a.ICvalor
			   	else null end) as ICvalor, 
			   (case when (CItipo < 2 and a.ICvalor > 0) then round(a.ICmontores/(a.ICvalor*1.00), 2) 
			         when (CItipo = 3 and a.ICvalor > 0) then a.ICvalor
			   else null end) as ICvalorcalculado, 
			   a.ICmontores, a.ICcalculo,CCPid, CCPacumulable, CCPprioridad, TCCPid
		from IncidenciasCalculo a
        	inner join CIncidentes b
            	on a.CIid = b.CIid
            inner join ConceptosCarreraP c
            	on c.CIid = b.CIid
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		  and CIcarreracp = 1		<!--- considera conceptos de pago por carrera profesional --->
		order by b.CIcodigo
	</cfquery>
	
	<cfif rsIncidenciasCarreraP.recordCount GT 0>
		<cfquery name="rsSumIncidencias" dbtype="query">
			select sum(ICmontores) as Monto
			from rsIncidenciasCarreraP
		</cfquery>
		<cfset montoCarreraP = rsSumIncidencias.Monto >
	<cfelse>
		<cfset montoCarreraP = 0.00 >
	</cfif>			
	
	<cfquery name="rsTotalesResumido" dbtype="query">
		select #rsSalBrutoRelacion.Monto# + #montoIncidencias# + #montoCarreraP# as Pagos,
			   SErenta + SEcargasempleado + SEdeducciones as Deducciones,
			   (#rsSalBrutoRelacion.Monto# + #montoIncidencias#  + #montoCarreraP#) - (SErenta + SEcargasempleado + SEdeducciones) as Liquido
		from rsSalarioEmpleado
	</cfquery>
	
	<cfquery name="rsCargas" datasource="#Session.DSN#">
		select <cf_dbfunction name="to_char" args="a.DClinea"  >  as DClinea, CCvaloremp, CCvalorpat, DCdescripcion, ECauto, ECresumido, c.ECid
		from CargasCalculo a
        	inner join DCargas b
            	on a.DClinea = b.DClinea
            inner join ECargas c
            	on b.ECid = c.ECid
		where RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		  and CCvaloremp is not null
		  and CCvaloremp <> 0
		  order by c.ECid
	</cfquery>
	
	<cfquery name="rsSumCargas" dbtype="query">
		select sum(CCvaloremp) as cargas
		from rsCargas
	</cfquery>
	<cfif rsSumCargas.recordCount GT 0>
		<cfset SumCargas = rsSumCargas.cargas>
	<cfelse>
		<cfset SumCargas = 0.00>
	</cfif>
	
	<cfquery name="rsDeducciones" datasource="#Session.DSN#">
		select <cf_dbfunction name="to_char" args="a.Did"  >  as Did, a.DCvalor, 
			   a.DCinteres, a.DCcalculo, b.Ddescripcion, 
			   b.Dvalor, b.Dmetodo, case when b.Dcontrolsaldo = 1 then isnull(b.Dsaldo, 0.00) - a.DCvalor else null end as DCsaldo, 
			   b.Dcontrolsaldo, b.Dreferencia
		from DeduccionesCalculo a
        	inner join DeduccionesEmpleado b
            	on a.Did = b.Did
		where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and a.DEid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		order by b.Dreferencia
	</cfquery>
    
	<cfquery name="rsSumDeducciones" dbtype="query">
		select sum(DCvalor) as deduc
		from rsDeducciones
	</cfquery>
    
	<cfif rsSumDeducciones.recordCount GT 0>
		<cfset SumDeducciones = rsSumDeducciones.deduc>
	<cfelse>
		<cfset SumDeducciones = 0.00>
	</cfif>
	
	<cfquery name="rsDetalleMovimientos" datasource="#Session.DSN#">
		select 
			case when a.DLfvigencia is not null then <cf_dbfunction name="date_format" args="a.DLfvigencia,DD/MM/YY"> else '&nbsp;' end as Vigencia,
			case when a.DLffin is not null then <cf_dbfunction name="date_format" args="a.DLffin,DD/MM/YY">  else '&nbsp;' end as Finalizacion,
			<cf_dbfunction name="to_char" args="a.DLsalario"  >  as DLsalario, 
			<cf_dbfunction name="to_char" args="a.DLsalarioant"  >  as DLsalarioant, 
			<cf_dbfunction name="date_format" args="a.DLfechaaplic,DD/MM/YY">  as FechaAplicacion,
			b.RHTdesc as Descripcion
		from DLaboralesEmpleado a, RHTipoAccion b, RCalculoNomina c
		where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and c.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		and a.RHTid = b.RHTid
		and a.Ecodigo = b.Ecodigo
		and a.Ecodigo = c.Ecodigo
		and a.DLfechaaplic between c.RCdesde and c.RChasta
		order by a.DLfechaaplic
	</cfquery>
	
	<!--- ================================================================== --->
	<!--- Calculo de salario por hora  										 ---> 
	<!--- ================================================================== --->
	<cfquery name="rsDias" datasource="#Session.DSN#">
		select <cf_dbfunction name="to_float" args="FactorDiasSalario"> as dias, r.RChasta
		from TiposNomina t, RCalculoNomina r
		where t.Ecodigo = r.Ecodigo
		  and t.Tcodigo = r.Tcodigo
		  and r.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
		  and r.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<cfif isdefined('rsSalBrutoMensual') and rsSalBrutoMensual.RecordCount EQ 0>
		<cfset vSalarioBruto = rsSalBrutoMensual.PEsalario >
	<cfelse>
		<cfset vSalarioBruto = 0>
	</cfif>
	<cfif isdefined('rsDias') and rsDias.RecordCount GT 0>
		<cfset vDiasNomina = rsDias.dias >
	<cfelse>
		<cfset vDiasNomina = 0>
	</cfif>


	<cfset vHorasDiarias = 0 >
	<cfquery name="rsHoras" datasource="#session.DSN#" >
		select RHJhoradiaria, RHJornadahora
		from RHJornadas a, LineaTiempo b
		where b.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
		and a.Ecodigo = #Session.Ecodigo#
		and b.Ecodigo = #Session.Ecodigo#
		and a.RHJid = b.RHJid
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDias.RChasta#"> between LTdesde and LThasta 
	</cfquery>
	<cfif isdefined('rsHoras') and rsHoras.RecordCount GT 0>
		<cfset vHorasDiarias = rsHoras.RHJhoradiaria >
		<cfset vJornadaporHora = rsHoras.RHJornadahora>
	<cfelse>
		<cfset vHorasDiarias = 0>
		<cfset vJornadaporHora = 0>	
	</cfif>
	<cfif vSalarioBruto GT 0 and vDiasNomina GT 0 and vHorasDiarias GT 0>
		<cfset vSalarioHora = (vSalarioBruto/vDiasNomina)/vHorasDiarias >	
	<cfelse>
		<cfset vSalarioHora = 0>
	</cfif>	
	<!--- ================================================================== --->
	<!--- ================================================================== --->

	<!--- ARMA EL EMAIL--->
	<cfsavecontent variable="info">
	<cfoutput>
	<html>
	<head>
	<title>#LB_Boleta#</title>
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
	</head>
	
	<body>
	<style type="text/css">
		td {font-size: 8pt; font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: normal}
	</style>
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="2" style="border: 2px solid black;">
	  <tr>
		<td align="center"><strong>#Session.Enombre#</strong></td>
	  </tr>
	  <tr>
		<td align="center"><strong><cf_translate  key="LB_Boleta_Pago" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Boleta de Pago</cf_translate>: #RCalculoNomina.RCDescripcion#</strong></td>
	  </tr>
	  <tr>
		<td align="center"><strong><cf_translate  key="LB_Del" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Del</cf_translate>: #LSDateFormat(RCalculoNomina.RCdesde,'dd/mm/yyyy')# <cf_translate  key="LB_Al" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">al</cf_translate> #LSDateFormat(RCalculoNomina.RChasta,'dd/mm/yyyy')# </strong></td>
	  </tr>
	  <tr>
		<td align="center"><strong><cf_translate  key="LB_Fecha_de_Pago" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Fecha de Pago</cf_translate>: #LSDateFormat(RCalculoNomina.CPfpago,'dd/mm/yyyy')#</strong></td>
	  </tr>
	  <tr>
	    <td align="center">&nbsp;</td>
      </tr>
	  <tr>
		<td align="center"><table width="100%"  border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td width="30%" nowrap><strong><cf_translate  key="LB_Nombre_Completo" xmlfile="/rh/generales.xml">Nombre Completo</cf_translate>: </strong></td>
			<td nowrap>#rsEncabEmpleado.NombreEmpl#</td>
		  </tr>
		  <tr>
			<td nowrap><strong><cf_translate  key="LB_Cedula" xmlfile="/rh/generales.xml">C&eacute;dula</cf_translate>:</strong></td>
			<td nowrap>#rsEncabEmpleado.DEidentificacion#</td>
		  </tr>
		  <tr>
			<td nowrap><strong><cf_translate  key="LB_Salario_Bruto_Mensual" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario Bruto Mensual</cf_translate>:</strong></td>
			<td align="right" nowrap><strong>#LSCurrencyFormat(rsSalBrutoMensual.PEsalario, 'none')#</strong></td>
		  </tr>
		  <cfif rsMostrarSalarioNominal.Pvalor eq 1>
			<cfif HRCalculoNomina.Tcodigo neq 3>
				<cfquery name="rsLineaTiempo" datasource="#Session.DSN#">
					select LTsalario from LineaTiempo
					where 
					<cfqueryparam cfsqltype="cf_sql_date" value="#HRCalculoNomina.RCdesde#">  between LTdesde and LThasta
					and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				</cfquery>
				<cfif rsLineaTiempo.recordCount EQ 0>
					<cfquery name="rsLineaTiempo" datasource="#Session.DSN#">
						select LTsalario from LineaTiempo
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
						and LThasta =    (select max(LThasta) from LineaTiempo  where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">)
					</cfquery>
				</cfif>
				
				<cfinvoke component="rh.Componentes.RH_Funciones" 
					method="salarioTipoNomina"
					salario = "#rsLineaTiempo.LTsalario#"
					Tcodigo = "#HRCalculoNomina.Tcodigo#"
					returnvariable="var_salarioTipoNomina">
				<tr>
					<td nowrap><strong><cf_translate  key="LB_Salario" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario</cf_translate>&nbsp;#HRCalculoNomina.descripcion#:&nbsp;</strong></td>
					<td align="right" nowrap><strong>#LSCurrencyFormat(var_salarioTipoNomina, 'none')#</strong></td>
				</tr>
			</cfif>
		 </cfif>   		  
		  
		  <tr>
			<td nowrap><strong><cf_translate  key="LB_SalarioBruto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario Bruto</cf_translate> #RCalculoNomina.RCDescripcion#:</strong></td>
			<td align="right" nowrap><strong>#LSCurrencyFormat(rsSalBrutoRelacion.Monto, 'none')#</strong></td>
		  </tr>
		  <cfif vJornadaporHora GT 0>
		  <tr>
			<td nowrap><strong><cf_translate  key="LB_Salario_por_Hora" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario por Hora</cf_translate>:</strong></td>
			<td align="right" nowrap><strong>#LSCurrencyFormat(vSalarioHora, 'none')#</strong></td>
		  </tr>
		  </cfif>
		</table></td>
	  </tr>
	  <tr>
	    <td align="center">&nbsp;</td>
      </tr>
	  <tr>
		<td align="center" style="border-top: 2px solid black; "><table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr align="center">
			<td colspan="5" bgcolor="##999999" style="border-bottom: 1px solid black "><strong><cf_translate  key="LB_InformacionResumida" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Informaci&oacute;n de Pago Resumida</cf_translate></strong></td>
			</tr>
		  <tr>
		    <td colspan="5" align="center" nowrap>&nbsp;</td>
	      </tr>
		  <tr>
			<td colspan="2" align="center" bgcolor="##CCCCCC" nowrap><strong><cf_translate  key="LB_Conceptos_de_Pago" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Conceptos de Pago</cf_translate></strong></td>
			<td width="20" align="center" nowrap>&nbsp;</td>
			<td colspan="2" align="center" bgcolor="##CCCCCC" nowrap><strong><cf_translate  key="LB_Deducciones" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Deducciones</cf_translate></strong></td>
		  </tr>
		  <tr>
			<td nowrap><cf_translate  key="LB_SalarioBruto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario Bruto</cf_translate>:</td>
			<td align="right" nowrap>#LSCurrencyFormat(rsSalBrutoRelacion.Monto, 'none')#</td>
			<td align="right" nowrap>&nbsp;</td>
			<td nowrap><cf_translate  key="LB_Cargas" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Cargas Laborales</cf_translate>:</td>
			<td align="right" nowrap><cfif rsSalarioEmpleado.SEcargasempleado GT 0>(</cfif>#LSCurrencyFormat(rsSalarioEmpleado.SEcargasempleado,'none')#<cfif rsSalarioEmpleado.SEcargasempleado GT 0>)</cfif></td>
		  </tr>
		  <tr>
			<td nowrap><cf_translate  key="LB_Otros_Movimientos" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Otros Movimientos</cf_translate>:</td>
			<td align="right" nowrap>
				#LSNumberFormat(montoIncidencias+montoCarreraP, '(___,___,___,___,___.__)')#
			</td>
			<td align="right" nowrap>&nbsp;</td>
			<td nowrap><cf_translate  key="LB_Otras_Deducciones" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Otras Deducciones</cf_translate>:</td>
			<td align="right" nowrap><cfif rsSalarioEmpleado.SEdeducciones GT 0>(</cfif>#LSCurrencyFormat(rsSalarioEmpleado.SEdeducciones,'none')#<cfif rsSalarioEmpleado.SEdeducciones GT 0>)</cfif></td>
		  </tr>
		  <tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap><cf_translate key="LB_Renta" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Renta</cf_translate>:</td>
			<td align="right" nowrap><cfif rsSalarioEmpleado.SErenta GT 0>(</cfif>#LSCurrencyFormat(rsSalarioEmpleado.SErenta,'none')#<cfif rsSalarioEmpleado.SErenta GT 0>)</cfif></td>
		  </tr>
		  <tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
		  </tr>
		  <tr>
			<td nowrap><strong><cf_translate  key="LB_Total" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Total</cf_translate>:</strong></td>
			<td align="right" nowrap>#LSNumberFormat(rsTotalesResumido.Pagos, '(___,___,___,___,___.__)')#</td>
			<td align="right" nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td align="right" nowrap><cfif rsTotalesResumido.Deducciones GT 0>(</cfif>#LSCurrencyFormat(rsTotalesResumido.Deducciones, 'none')#<cfif rsTotalesResumido.Deducciones GT 0>)</cfif></td>
		  </tr>
		  <tr>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap>&nbsp;</td>
			<td nowrap><strong><cf_translate  key="LB_SalarioLIquido" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario L&iacute;quido</cf_translate>:</strong></td>
			<td align="right" nowrap>
				<strong>#rsMoneda.Msimbolo# #LSNumberFormat(rsTotalesResumido.Liquido, '(___,___,___,___,___.__)')#</strong>
			</td>
		  </tr>
		</table></td>
	  </tr>
	  <tr>
		<td align="center">&nbsp;</td>
	  </tr>
	  <tr>
		<td align="center" style="border-top: 2px solid black; ">
		<!--- Parametro general de RH para determinar si se pinta o no las columnas de "Unidades" y "Valor" --->
			<cfquery name="rsParamRH" datasource="#Session.DSN#">
				select Pvalor
				from RHParametros
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and Pcodigo = 550
			</cfquery>				
			<cfset cantCols = 5>
			<cfset tamColDescr = 50>
			
			<cfif isdefined('rsParamRH') and rsParamRH.recordCount GT 0>
				<cfif rsParamRH.Pvalor EQ 1>
					<cfset cantCols = 5>
					<cfset tamColDescr = 50>
				<cfelse>
					<cfset cantCols = 3>
					<cfset tamColDescr = 75>
				</cfif>
			</cfif>
			
			<table width="100%"  border="0" cellspacing="0" cellpadding="2">
			  <tr align="center">
				<td colspan="6" bgcolor="##999999" style="border-bottom: 1px solid black "><strong><cf_translate  key="LB_Otros_Movimientos" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Otros Movimientos</cf_translate></strong></td>
			  </tr>
			  <cfif (rsIncidenciasCalculo.recordCount + rsIncidenciasCarreraP.recordCount) GT 0>
				  <tr>
					<td width="10%" align="center" nowrap><strong><cf_translate  key="LB_Fecha" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Fecha</cf_translate></strong></td>
					<td width="#tamColDescr#%" colspan="2" align="left" nowrap><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_DESCRIPCION">Descripci&oacute;n</cf_translate></strong></td>
					<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
						<td width="10%" align="right" nowrap><strong><cf_translate  key="LB_Unidades" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Unidades</cf_translate></strong></td>
						<td width="15%" align="right" nowrap><strong><cf_translate  key="LB_Valor" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Valor</cf_translate></strong></td>
					</cfif>
					<td width="15%" align="right" nowrap><strong><cf_translate  key="LB_Monto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Monto</cf_translate></strong></td>
				  </tr>
				  <cfloop query="rsIncidenciasCalculo">
					  <tr>
						<td align="center" style="border-top: 1px solid gray; " nowrap>#LSDateFormat(ICfecha,'dd/mm/yyyy')#</td>
						<td align="left" colspan="2" style="border-top: 1px solid gray; " nowrap>#CIdescripcion#</td>
						<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
							<td align="right" style="border-top: 1px solid gray; " nowrap><cfif Len(Trim(ICvalor))>#LSNumberFormat(ICvalor,'(___,___,___,___,___.__)')#<cfelse>&nbsp;</cfif></td>
							<td align="right" style="border-top: 1px solid gray; " nowrap><cfif Len(Trim(ICvalorcalculado))>#LSNumberFormat(ICvalorcalculado,'(___,___,___,___,___.__)')#<cfelse>&nbsp;</cfif></td>
						</cfif>						
						<td align="right" style="border-top: 1px solid gray; " nowrap>#LSNumberFormat(ICmontores,'(___,___,___,___,___.__)')#</td>
					  </tr>
				  </cfloop>
				  
				  <cfif rsIncidenciasCarreraP.recordCount GT 0 >
					  <tr><td colspan="6" bgcolor="##CCCCCC" ><strong><cf_translate key="LB_Carerra_Profesional" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Carrera Profesional</cf_translate></strong></td></tr>
					   <tr>
						<td width="10%" align="center" nowrap><strong><cf_translate  key="LB_Fecha" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Fecha</cf_translate></strong></td>
						<td width="#tamColDescr#%" align="left" nowrap><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_DESCRIPCION">Descripci&oacute;n</cf_translate></strong></td>
						<td align="left" nowrap><strong><cf_translate xmlfile="/rh/generales.xml" key="LB_Puntos">Puntos</cf_translate></strong></td>
						<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
							<td width="10%" align="right" nowrap><strong><cf_translate  key="LB_Unidades" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Unidades</cf_translate></strong></td>
							<td width="15%" align="right" nowrap><strong><cf_translate  key="LB_Valor" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Valor</cf_translate></strong></td>
						</cfif>
						<td width="15%" align="right" nowrap><strong><cf_translate  key="LB_Monto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Monto</cf_translate></strong></td>
					  </tr>
					  <cfloop query="rsIncidenciasCarreraP">
						<cfinvoke component="rh.Componentes.RH_CalculoCP" method="AcumulaConceptos" returnvariable="Conceptos" conexion="#session.DSN#"
							ecodigo = "#session.Ecodigo#" ccpid = "#rsIncidenciasCarreraP.CCPid#" acumula = "#rsIncidenciasCarreraP.CCPacumulable#" tccpid="#rsIncidenciasCarreraP.TCCPid#"
							prioridad="#rsIncidenciasCarreraP.CCPprioridad#" rcdesde="#RCalculoNomina.RCdesde#" rchasta="#RCalculoNomina.RChasta#" deid = "#Arguments.DEid#"/>
					  <tr>
						<td align="center" style="border-top: 1px solid gray; " nowrap>#LSDateFormat(ICfecha,'dd/mm/yyyy')#</td>
						<td align="left" style="border-top: 1px solid gray; " nowrap>#CIdescripcion#</td>
						<td align="right" style="border-top: 1px solid gray; " nowrap>#Conceptos.valor#</td>
							<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
								<td align="right" style="border-top: 1px solid gray; " nowrap><cfif Len(Trim(ICvalor))>#LSNumberFormat(ICvalor,'(___,___,___,___,___.__)')#<cfelse>&nbsp;</cfif></td>
								<td align="right" style="border-top: 1px solid gray; " nowrap><cfif Len(Trim(ICvalorcalculado))>#LSNumberFormat(ICvalorcalculado,'(___,___,___,___,___.__)')#<cfelse>&nbsp;</cfif></td>
							</cfif>							
						<td align="right" style="border-top: 1px solid gray; " nowrap>#LSNumberFormat(ICmontores,'(___,___,___,___,___.__)')#</td>
					  </tr>
					  </cfloop>
				  </cfif>
				  
				  <cfif Len(Trim(rsRetroactivos.Monto)) and Trim(rsRetroactivos.Monto) NEQ 0>
				  <tr>
					<td align="center" style="border-top: 1px solid gray; " nowrap>&nbsp;</td>
					<td align="left" style="border-top: 1px solid gray; " colspan="2" nowrap><cf_translate  key="LB_AJUSTE_RETROACTIVO" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">AJUSTE RETROACTIVO</cf_translate></td>
					<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
						<td align="right" style="border-top: 1px solid gray; " nowrap>&nbsp;</td>
						<td align="right" style="border-top: 1px solid gray; " nowrap>&nbsp;</td>
					</cfif>							
					<td align="right" style="border-top: 1px solid gray; " nowrap>#LSNumberFormat(rsRetroactivos.Monto,'(___,___,___,___,___.__)')#</td>
				  </tr>
				  </cfif>
				  <tr>
					<td align="left" style="border-top: 2px solid black; " nowrap><strong><cf_translate  key="LB_Total" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Total</cf_translate>:</strong></td>
					<td align="left" style="border-top: 2px solid black; " nowrap colspan="2">&nbsp;</td>
					<cfif isdefined('rsParamRH') and rsParamRH.Pvalor EQ 1>
						<td align="right" style="border-top: 2px solid black; " nowrap>&nbsp;</td>
						<td align="right" style="border-top: 2px solid black; " nowrap>&nbsp;</td>
					</cfif>							
					<td align="right" style="border-top: 2px solid black; " nowrap>
						<strong>#rsMoneda.Msimbolo# #LSNumberFormat(montoIncidencias+montocarreraP, '(___,___,___,___,___.__)')#</strong>
					</td>
				  </tr>
			  <cfelse>
				  <tr>
					<td colspan="#tamColDescr#" align="center"><strong>--- <cf_translate  key="LB_NoSeEncontraronRegistros" xmlfile="/rh/generales.xml">No se encontraron otros movimientos registrados</cf_translate> ---</strong></td>
				  </tr>
			  </cfif>
			</table>
		
		</td>
	  </tr>
	  
	  <tr>
		<td align="center">&nbsp;</td>
	  </tr>

	  <tr>
		<td align="center" style="border-top: 2px solid black; "><table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr align="center">
			<td colspan="2" bgcolor="##999999" style="border-bottom: 1px solid black "><strong><cf_translate  key="LB_Cargas" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Cargas Laborales</cf_translate></strong></td>
		  </tr>
		  <cfset idBandera= "" >		
		  <cfif rsCargas.recordCount GT 0>		     
			  <tr>
				<td nowrap><strong><cf_translate  key="LB_DESCRIPCION" xmlfile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
				<td align="right" nowrap><strong><cf_translate  key="LB_Monto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Monto</cf_translate></strong></td>
			  </tr>
		  <cfloop query="rsCargas">				  			  			  											
			  	<cfif rsCargas.ECresumido is  1 >										            
					   <cfif idBandera neq #rsCargas.ECid#>  					     				  		 			  
			  				<cfquery name = "rsCargasCalculoResumido" datasource="#Session.DSN#">
						   		 select e.ECdescripcion as descripcion, sum(cc.CCvaloremp) as empleado
								 from CargasCalculo cc, ECargas e, DCargas d
								 where cc.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#"> 
				  				 and cc.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
								 and e.ECid = #rsCargas.ECid#
				  				 and cc.DClinea = d.DClinea
				  	        	 and e.ECid = d.ECid  
				  				 and e.Ecodigo = #Session.Ecodigo#					
                    		     and cc.CCvaloremp is not null
		            			 and cc.CCvaloremp <> 0					
								 group by e.ECdescripcion, e.ECid 																					
				           </cfquery>							   
					   		<cfset idBandera=#rsCargas.ECid# >							   					   		    
			               <tr>						   				      		  
							   <td style="border-top: 1px solid gray; " nowrap>#rsCargasCalculoResumido.descripcion#</td>
				      		   <td align="right" style="border-top: 1px solid gray; " nowrap><cfif rsCargasCalculoResumido.empleado NEQ 0>(</cfif>#LSCurrencyFormat(rsCargasCalculoResumido.empleado,'none')#<cfif rsCargasCalculoResumido.empleado NEQ 0>)</cfif></td>
						   </tr>						   								  			    			  			      		   
			  		</cfif>	  
					
			  <cfelse>
			  			  	
			  		<tr>
						<td style="border-top: 1px solid gray; " nowrap>#DCdescripcion#</td>
						<td align="right" style="border-top: 1px solid gray; " nowrap><cfif CCvaloremp NEQ 0>(</cfif>#LSCurrencyFormat(CCvaloremp,'none')#<cfif CCvaloremp NEQ 0>)</cfif></td>
			  		</tr>			  		
			  			  
			  </cfif>
		</cfloop>	
		<tr>
					<td style="border-top: 2px solid black; " nowrap><strong><cf_translate  key="LB_Total" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Total</cf_translate>:</strong></td>
					<td align="right" style="border-top: 2px solid black; " nowrap>
					<strong>#rsMoneda.Msimbolo# <cfif SumCargas NEQ 0>(</cfif>#LSCurrencyFormat(SumCargas,'none')#<cfif SumCargas NEQ 0>)</cfif></strong>
					</td>
	  		  </tr>	  
		  <cfelse>
			  <tr align="center">
				<td colspan="2"><strong>--- <cf_translate  key="LB_NoSeEncontraronRegistros">No se encontraton cargas laborales registradas</cf_translate> ---</strong></td>
			  </tr>
		  </cfif>
		  
		</table></td>
	  </tr>
	  <tr>
		<td align="center">&nbsp;</td>
	  </tr>
	  <tr>
		<td align="center" style="border-top: 2px solid black; "><table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr align="center">
			<td colspan="4" bgcolor="##999999" style="border-bottom: 1px solid black "><strong><cf_translate  key="LB_Otras_Deducciones" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Otras Deducciones</cf_translate></strong></td>
		  </tr>
		  <cfif rsDeducciones.recordCount GT 0>
			  <tr>
				<td width="60%" nowrap><strong><cf_translate  key="LB_DESCRIPCION" xmlfile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
				<td width="20%" nowrap><strong><cf_translate  key="LB_Referencia" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Referencia</cf_translate></strong></td>
				<td align="right" nowrap><strong><cf_translate  key="LB_SaldoPosterior" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Saldo Posterior</cf_translate></strong></td>
				<td width="10%" align="right" nowrap><strong><cf_translate  key="LB_Monto" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Monto</cf_translate></strong></td>
			  </tr>
			  <cfloop query="rsDeducciones">
			  <tr>
				<td style="border-top: 1px solid gray; " nowrap>#Ddescripcion#&nbsp;</td>
				<td style="border-top: 1px solid gray; " nowrap>#Dreferencia#&nbsp;</td>
				<td width="10%" align="right" style="border-top: 1px solid gray; " nowrap><cfif Dcontrolsaldo EQ 1>#LSCurrencyFormat(DCsaldo,'none')#<cfelse>&nbsp;</cfif></td>
				<td align="right" style="border-top: 1px solid gray; " nowrap><cfif DCvalor NEQ 0>(</cfif>#LSCurrencyFormat(DCvalor,'none')#<cfif DCvalor NEQ 0>)</cfif></td>
			  </tr>
			  </cfloop>
			  <tr>
				<td style="border-top: 2px solid black; " nowrap><strong><cf_translate  key="LB_Total">Total</cf_translate>:</strong></td>
				<td style="border-top: 2px solid black; " nowrap>&nbsp;</td>
				<td style="border-top: 2px solid black; " align="right" nowrap>&nbsp;</td>
				<td style="border-top: 2px solid black; " align="right" nowrap>
					<strong>#rsMoneda.Msimbolo# <cfif SumDeducciones NEQ 0>(</cfif>#LSCurrencyFormat(SumDeducciones,'none')#<cfif SumDeducciones NEQ 0>)</cfif></strong>
				</td>
			  </tr>
		  <cfelse>
		  <tr align="center">
			<td colspan="4"><strong>--- <cf_translate  key="LB_NoSeEncontraronRegistros" xmlfile="/rh/generales.xml">No se encontraron deducciones registradas</cf_translate> ---</strong></td>
		  </tr>
		  </cfif>
		</table></td>
	  </tr>
	  <tr>
		<td align="center">&nbsp;</td>
	  </tr>
	  <tr>
		<td align="center" style="border-top: 2px solid black; "><table width="100%"  border="0" cellspacing="0" cellpadding="2">
		  <tr align="center">
			<td colspan="5" bgcolor="##999999" style="border-bottom: 1px solid black "><strong><cf_translate key="LB_Detalle_de_Movimientos" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Detalle de Movimientos</cf_translate></strong></td>
		  </tr>
		  <cfif rsDetalleMovimientos.recordCount GT 0>
			  <tr>
				<td width="10%" align="center" nowrap><strong><cf_translate  key="LB_Del" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Rige</cf_translate></strong></td>
				<td width="10%" align="center" nowrap><strong><cf_translate  key="LB_Al" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Vence</cf_translate></strong></td>
				<td width="60%" nowrap><strong><cf_translate  key="LB_DESCRIPCION" xmlfile="/rh/generales.xml">Descripci&oacute;n</cf_translate></strong></td>
				<td width="10%" align="right" nowrap><strong><cf_translate  key="LB_SalarioAnterior" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario Anterior</cf_translate></strong></td>
				<td width="10%" align="right" nowrap><strong><cf_translate  key="LB_SalarioPosterior" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Salario Posterior</cf_translate></strong></td>
			  </tr>
			  <cfloop query="rsDetalleMovimientos">
			  <tr>
				<td align="center" style="border-top: 1px solid gray; " nowrap>#Vigencia#&nbsp;</td>
				<td align="center" style="border-top: 1px solid gray; " nowrap>#Finalizacion#&nbsp;</td>
				<td style="border-top: 1px solid gray; " nowrap>#Descripcion#&nbsp;</td>
				<td align="right" style="border-top: 1px solid gray; " nowrap>#DLsalarioant#&nbsp;</td>
				<td align="right" style="border-top: 1px solid gray; " nowrap>#DLsalario#&nbsp;</td>
			  </tr>
			  </cfloop>
		  <cfelse>
		  <tr align="center">
			<td colspan="5"><strong>--- <cf_translate  key="LB_NoSeEncontraronRegistros" xmlfile="/rh/generales.xml">No se encontraron movimientos registrados</cf_translate> ---</strong></td>
		  </tr>
		  </cfif>
		</table></td>
	  </tr>
	  <tr>
		<td align="center">&nbsp;</td>
	  </tr>
	  <tr>
		<td align="center" style="border-top: 2px solid black; "><strong><cf_translate  key="MSG_Fin_de_Boleta_de_Pago" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Fin de Boleta de Pago</cf_translate>: #RCalculoNomina.RCDescripcion#</strong></td>
	  </tr>
	  <tr>
		<td align="center"><cf_translate  key="MSG_Mensaje_generado" xmlfile="/rh/expediente/consultas/HResultadoCalculo.xml">Este mensaje es generado autom&aacute;ticamente por el sistema de Recursos Humanos. Por favor no responda a este mensaje</cf_translate>. </td>
	  </tr>
      <cfif len(trim(Arguments.MensajeBoleta))>
        <tr>
        	<td align="center"><cfoutput>#Arguments.MensajeBoleta#</cfoutput></td>
        </tr>
      </cfif>
	</table>
	</body>
	</html>
	</cfoutput>	
	</cfsavecontent>
	<cfreturn info>
</cffunction>
    <cffunction access="public" name="enviarCorreo" output="true">
        <cfargument name="from" 	required="yes" type="string">
        <cfargument name="to" 		required="yes" type="string">
        <cfargument name="subject" 	required="yes" type="string">
        <cfargument name="message" 	required="yes" type="string">
        
            <cfquery datasource="#session.dsn#">
                insert into SMTPQueue 
                    (SMTPremitente, SMTPdestinatario, SMTPasunto,
                    SMTPtexto, SMTPhtml)
                 values(
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.from)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.to)#">,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#subject#">,
                    <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Arguments.message#">,
                    1)
            </cfquery>
    </cffunction>
</cfcomponent>