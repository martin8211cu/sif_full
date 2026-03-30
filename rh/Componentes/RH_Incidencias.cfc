<cfcomponent name="RH_Incidencias" output="true">
	<!--- 
		***********************
		Variables de Traducción 
		***********************
	--->

	<!--- Valor --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Relacion_Empleado_Concepto_Incidente_y_Fecha_ya_existe."
		Default="La relacion entre Empleado, Concepto de Incidencia y Fecha ya existe"
		returnvariable="vError"/>
	<!--- Empleado --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Empleado"
		Default="Empleado"
		XmlFile="/rh/generales.xml"
		returnvariable="vEmpleado"/>
	<!--- Concepto_Incidente --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="Concepto_Incidente"
		Default="Concepto Incidente"
		XmlFile="/rh/generales.xml"
		returnvariable="vConcepto"/>
	<!--- Fecha --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Fecha"
		Default="Fecha"
		XmlFile="/rh/generales.xml"
		returnvariable="vFecha"/>

	<!--- ******************* --->
	<!--- Alta De Incidencias --->
	<!--- ******************* --->
	<cffunction access="public" name="Alta" returntype="numeric">
		<cfargument name="DEid" 				required="true" 	type="numeric">
		<cfargument name="CIid" 				required="true" 	type="numeric">
		<cfargument name="iFecha" 				required="true" 	type="date">
		<cfargument name="iFechaRebajo" 		required="false" 	type="string" 	default="">
		<cfargument name="iValor" 				required="true" 	type="numeric">
		<cfargument name="CFid" 				required="false" 	type="numeric" 	default="0">
		<cfargument name="RHJid" 				required="false" 	type="numeric" 	default="0">
		<cfargument name="Iespecial" 			required="false" 	type="numeric" 	default="0">
		<cfargument name="Icpespecial" 			required="false" 	type="numeric" 	default="0">		
		<cfargument name="RCNid" 				required="false" 	type="numeric" 	default="0">
		<cfargument name="Mcodigo" 				required="false" 	type="numeric" 	default="0">
		<cfargument name="Imonto" 				required="false" 	type="numeric" 	default="0">
		<cfargument name="Debug" 				required="false" 	type="boolean" 	default="false">
		<cfargument name="TransaccionAbierta" 	required="false" 	type="boolean" 	default="false">
        <cfargument name="Ifechacontrol" 		required="false" 	type="string" 	default="">
        <cfargument name="EIlote" 		required="false" 	type="numeric">
        
        
		<cfif Arguments.TransaccionAbierta>
			<cfinvoke method="pAlta" argumentcollection="#arguments#" returnvariable="Lvar_Iid">
		<cfelse>
			<cftransaction>
				<cfinvoke method="pAlta" argumentcollection="#arguments#" returnvariable="Lvar_Iid">
			</cftransaction>
		</cfif>
		<cfreturn  Lvar_Iid>
	</cffunction>
	
	<cffunction access="private" name="pAlta" returntype="numeric">
		<cfargument name="DEid" 			required="true" 	type="numeric">
		<cfargument name="CIid" 			required="true" 	type="numeric">
		<cfargument name="iFecha" 			required="true" 	type="date" >
		<cfargument name="iFechaRebajo" 	required="false" 	type="string" 	default="" >
		<cfargument name="iValor" 			required="true" 	type="numeric">
		<cfargument name="CFid" 			required="false" 	type="numeric" 	default="0">
		<cfargument name="RHJid" 			required="false" 	type="numeric" 	default="0">
		<cfargument name="Iespecial" 		required="false" 	type="numeric" 	default="0">
		<cfargument name="Icpespecial" 		required="false" 	type="numeric" 	default="0">
		<cfargument name="RCNid" 			required="false" 	type="numeric" 	default="0">
		<cfargument name="Mcodigo" 			required="false" 	type="numeric" 	default="0">
		<cfargument name="Imonto" 			required="false" 	type="numeric" 	default="0">
		<cfargument name="Debug" 			required="false" 	type="boolean" 	default="false">
        <cfargument name="EIlote" 			required="false" 	type="numeric">

		<!--- debe aprobar incidencias normales --->
		<cfset aprobarIncidencias = false >
		<cfquery name="rs_aprueba" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 1010
		</cfquery>
		<cfif trim(rs_aprueba.Pvalor) eq 1 >
			<cfset aprobarIncidencias = true >
		</cfif>
		
		<!--- debe aprobar incidencias tipo calculo --->
		<cfset aprobarIncidenciasCalc = false >
		<cfquery name="rs_apruebacalc" datasource="#session.DSN#">
			select Pvalor
			from RHParametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 1060
		</cfquery>
		<cfif trim(rs_apruebacalc.Pvalor) eq 1 >
			<cfset aprobarIncidenciasCalc = true >
		</cfif>		

		<cfset tipo_incidencia = 'N'>
		<cfquery name="rs_tipoIncidencia" datasource="#session.DSN#">
			select CItipo
			from CIncidentes
			where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CIid#">
		</cfquery>
		<cfif len(trim(rs_tipoIncidencia.CItipo)) and rs_tipoIncidencia.CItipo eq 3>
			<cfset tipo_incidencia = 'C'>
		</cfif>
		
		<cfquery name="rsVerify" datasource="#Session.DSN#">
			select Iid
			from Incidencias 
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#"> 
			  and Ifecha = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(Year(Arguments.iFecha),Month(Arguments.iFecha),Day(Arguments.iFecha))#">
		</cfquery>
		<cfif not isdefined('Arguments.EIlote')>
        	<cfset Arguments.EIlote = "">
        </cfif>
		<cfif rsVerify.recordcount gt 0>
			<!--- ACUMULAR INCIDENCIAS --->
			<cfquery name="rsUpdate" datasource="#Session.DSN#" result="res">
				update Incidencias 
				  set Ivalor = Ivalor + <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.iValor#">,
							   Imonto = Imonto + <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.Imonto#">  <!--- jc --->
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#"> 
				  and Ifecha = <cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(Year(Arguments.iFecha),Month(Arguments.iFecha),Day(Arguments.iFecha))#">
			</cfquery>
			<cfset rsInsert.identity = rsVerify.Iid>
		<cfelse>
			<!--- AGREGAR LA NUEVA INCIDENCIA --->

			<cfquery name="rsInsert" datasource="#Session.DSN#" result="res">
				insert into Incidencias(	DEid,
								 			CIid, 			
											Ifecha,
											IfechaRebajo,
											Ivalor, 
											Ifechasis, 		
											CFid, 			
											RHJid, 		
											Usucodigo, 
											Ulocalizacion, 	
											BMUsucodigo, 	
											Iespecial, 	
											RCNid, 
											Mcodigo, 		
											Imonto, 		
											Icpespecial,
											Iestado,
											NAP,
                                            Ifechacontrol,
                                            EIlote )
				values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#">, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(Year(Arguments.iFecha),Month(Arguments.iFecha),Day(Arguments.iFecha))#">,
						<cfif isdefined("Arguments.iFechaRebajo") and len(trim( Arguments.iFechaRebajo ))><cfqueryparam cfsqltype="cf_sql_date" value="#LSParsedateTime(Arguments.iFechaRebajo)#" ><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.iValor#">,
						<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#" null="#Arguments.CFid LTE 0#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHJid#" null="#Arguments.RHJid LTE 0#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iespecial#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#" null="#Arguments.RCNid LTE 0#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Mcodigo#" null="#Arguments.Mcodigo LTE 0#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Imonto#" scale="2" null="#Arguments.Imonto LTE 0#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Icpespecial#">,
						<!--- Lo que sigue se entiende asi: 
								1. 	Si la incidencia es de un tipo diferente a calculo, leer parametro 1010 y ver si requiere aprobacion. 
									Si requiere se inserta un estado 0 (pendiente de aprobar )sino el estado es 1 (aprobado).
								2. Si la incidencia es de tipo calculo, leer parametro 1060 y ver si requiere aprobacion. 
									Si requiere se inserta un estado 0 (pendiente de aprobar )sino el estado es 1 (aprobado).
							  Se hace asi porque se quiere independizar aprobacion	de incidencias normales y de calculo, son 
							  cosas diferentes. --->
						<cfif tipo_incidencia eq 'N'><cfif aprobarIncidencias >0<cfelse>1</cfif><cfelse><cfif aprobarIncidenciasCalc >0<cfelse>1</cfif></cfif>,	
						<!--- el NAP se usa para mantener desarrollo inicial del tec NO TIENE INTEGRACION con presupuesto por eso esta fijo --->
						<cfif tipo_incidencia eq 'N'><cfif aprobarIncidencias >null<cfelse>100</cfif><cfelse><cfif aprobarIncidenciasCalc >null<cfelse>100</cfif></cfif> 
                        ,<cfif isdefined("Arguments.ifechacontrol") and len(trim( Arguments.ifechacontrol ))><cfqueryparam cfsqltype="cf_sql_date" value="#CreateDate(Year(Arguments.ifechacontrol),Month(Arguments.ifechacontrol),Day(Arguments.ifechacontrol))#"><cfelse>null</cfif>
                        ,<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.EIlote#" voidnull>)
				<cf_dbidentity1 datasource="#session.DSN#" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsInsert" verificar_transaccion="false"> 
		</cfif>
		
		<cfset Lvar_Iid = rsInsert.Identity>
		
		<cfif Arguments.Debug><cfdump var="#res#"></cfif>
		
		<cfinvoke method="updateCMControlSemanal" Iid="#Lvar_Iid#" Debug="#Arguments.Debug#">
		
		<cfif Arguments.Debug>
			<cfquery name="rsDebug" datasource="#Session.DSN#">
				select 
					DEid, 			CIid, 			Ifecha, 		Ivalor, 
					Ifechasis, 		CFid, 			RHJid, 			Usucodigo, 	
					Ulocalizacion, 	BMUsucodigo, 	Iespecial, 		RCNid, 
					Mcodigo,		Imonto, 		Icpespecial
				from Incidencias
				where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iid#">
			</cfquery>
			<cfdump var="#Arguments#">
			<cfdump var="#rsDebug#">
			<cfabort>
		</cfif>
		
		<cfreturn Lvar_Iid>
	</cffunction>
	
	<cffunction access="public" name="updateCMControlSemanal">
		<cfargument name="Iid" required="true" type="numeric">
		<cfargument name="Debug" required="false" type="boolean" default="false">
		<cfset var Lvar_PagaSeptimo 	= false> <!--- Indicador del Pago del Séptimo --->
		<cfset var Lvar_PagaQ250 		= false> <!--- Indicador del Pago del Q250 --->
		<cfset var Lvar_DateWOH 		= ""> <!--- Fecha sin horas\minutos\segundos de la Incidencia --->
		<cfset var Lvar_DateFDOTW		= ""> <!--- Fecha sin horas\minutos\segundos del primer díá de la semana --->
		<cfset var Lvar_DatePartWOH 	= 0> <!--- Indicador del día de la semana de fecha de la incidencia --->
		<cfset var Lvar_DatePartFDP 	= 0> <!--- Indicador del día de la semana definido como primero de la semana en Parámetros de RH --->
		<cfset var Lvar_DatePartDiff 	= 0> <!--- Factor para conseguir la fecha del primer día de la semana a la que corresponde la incidencia --->
		<cfset var Lvar_Iidhn			= 0> <!--- Id de la Incidencia de horas normales --->
		<cfset var Lvar_Iidhea			= 0> <!--- Id de la Incidencia de horas extra a --->
		<cfset var Lvar_Iidheb			= 0> <!--- Id de la Incidencia de horas extra b --->
		<cfset var Lvar_Iidfer			= 0> <!--- Id de la Incidencia de feriados --->
		<cfset var Lvar_RHCMDhn			= 0> <!--- Cantidad de horas normales --->
		<cfset var Lvar_RHCMDhea		= 0> <!--- Cantidad de horas extra a --->
		<cfset var Lvar_RHCMDheb		= 0> <!--- cantidad de horas extra b --->
		<cfif Arguments.Debug>
			<cfdump var="#Arguments#" label="Arguments">
		</cfif>
		<!--- Gravar en la tabla de Control Semanal (Solo cuando paga Séptimo o Q250 o Ambos) --->
		<!---***INICIO Procesamiento Séptimo y Q250***--->
		<!--- Datos Séptimo y Q250 --->
		<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaSeptimo" 
				returnvariable="Lvar_PagaSeptimo">
		<cfinvoke component="rh.Componentes.RH_ControlMarcasCommon" method="fnGetPagaQ250" 
				returnvariable="Lvar_PagaQ250">
		<cfinvoke component="RHParametros" method="init" returnvariable="parametros">
		<cfif Arguments.Debug>
			<cfdump var="Lvar_PagaSeptimo=#Lvar_PagaSeptimo#" label="Lvar_PagaSeptimo">
			<cfdump var="Lvar_PagaQ250=#Lvar_PagaQ250#" label="Lvar_PagaQ250">
		</cfif>
		<cfquery name="rsHoras" datasource="#session.dsn#">
			SELECT 	a.Iid, 
					a.CIid, 			a.Ivalor, 
					a.Ifecha, 			a.DEid,
					d.RHJornadahora, 	d.RHJincHJornada, 
					d.RHJincExtraA, 	d.RHJincExtraB, 
					d.RHJincFeriados, 	d.RHJid
			FROM 	Incidencias a
						LEFT OUTER JOIN 	RHPlanificador b
						ON					b.DEid = a.DEid
						AND					<cf_dbfunction name="to_datechar" args="b.RHPJfinicio"> = 
											<cf_dbfunction name="to_datechar" args="a.Ifecha">
						INNER JOIN 			LineaTiempo c
						ON					c.DEid = a.DEid
						AND					a.Ifecha between c.LTdesde and c.LThasta
						INNER JOIN			RHJornadas d
						ON 					d.RHJid = coalesce(a.RHJid, b.RHJid, c.RHJid)
						AND 				d.RHJmarcar = 1
						AND (
											(	d.RHJornadahora 	= 1 AND
												d.RHJincHJornada 	= a.CIid	) OR
											(	d.RHJincExtraA 		= a.CIid 	) OR
											(	d.RHJincExtraB 		= a.CIid 	) OR
											(	d.RHJincFeriados	= a.CIid 	) 
						)
			WHERE 	a.Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Iid#">
		</cfquery>
		<cfif Arguments.Debug><cfdump var="#rsHoras#" label="rsHoras"></cfif>
		<cfif rsHoras.CIid eq rsHoras.RHJincHJornada>
			<cfset Lvar_Iidhn			= rsHoras.Iid>
			<cfset Lvar_RHCMDhn			= rsHoras.Ivalor>
		<cfelseif rsHoras.CIid eq rsHoras.RHJincExtraA>
			<cfset Lvar_Iidhea			= rsHoras.Iid>
			<cfset Lvar_RHCMDhea		= rsHoras.Ivalor>
		<cfelseif rsHoras.CIid eq rsHoras.RHJincExtraB>
			<cfset Lvar_Iidheb			= rsHoras.Iid>
			<cfset Lvar_RHCMDheb		= rsHoras.Ivalor>
		<cfelseif rsHoras.CIid eq rsHoras.RHJincFeriados>
			<cfset Lvar_Iidfer			= rsHoras.Iid>
		</cfif>
		<cfif Arguments.Debug>
			<cfdump var="Lvar_Iidhn=#Lvar_Iidhn#">
			<cfdump var="Lvar_RHCMDhn=#Lvar_RHCMDhn#">
			<cfdump var="Lvar_Iidhea=#Lvar_Iidhea#">
			<cfdump var="Lvar_RHCMDhea=#Lvar_RHCMDhea#">
			<cfdump var="Lvar_Iidheb=#Lvar_Iidheb#">
			<cfdump var="Lvar_RHCMDheb=#Lvar_RHCMDheb#">
			<cfdump var="Lvar_Iidfer=#Lvar_Iidfer#">
		</cfif>
		<cfif (rsHoras.recordcount GT 0) AND (Lvar_PagaSeptimo or Lvar_PagaQ250)>
			<cfif Arguments.Debug><cfdump var="#rsHoras#" label="rsHoras"></cfif>
			<cfset Lvar_DateWOH = CreateDate(Year(rsHoras.Ifecha),Month(rsHoras.Ifecha),Day(rsHoras.Ifecha))>
			<cfif Arguments.Debug><cfdump var="Lvar_DateWOH=#Lvar_DateWOH#" label="Lvar_DateWOH"></cfif>
			<cfset Lvar_DatePartWOH = DatePart("w",Lvar_DateWOH)-1>
			<cfif Arguments.Debug><cfdump var="Lvar_DatePartWOH=#Lvar_DatePartWOH#" label="Lvar_DatePartWOH"></cfif>
			<cfset Lvar_DatePartFDP = parametros.get(session.dsn,session.ecodigo,780)>
			<cfif Arguments.Debug><cfdump var="Lvar_DatePartFDP=#Lvar_DatePartFDP#" label="Lvar_DatePartFDP"></cfif>
			<cfif len(trim(Lvar_DatePartFDP)) EQ 0>
				<cfset Lvar_DatePartFDP = 1>
			</cfif>
			<cfif Arguments.Debug><cfdump var="Lvar_DatePartFDP=#Lvar_DatePartFDP#" label="Lvar_DatePartFDP"></cfif>
			<cfset Lvar_DatePartDiff = Lvar_DatePartFDP - Lvar_DatePartWOH>
			<cfif Lvar_DatePartDiff GT 0>
				<cfset Lvar_DatePartDiff = Lvar_DatePartDiff - 7>
			</cfif>
			<cfset Lvar_DateFDOTW = DateAdd('d',Lvar_DatePartDiff,Lvar_DateWOH)>
			<cfif Arguments.Debug><cfdump var="Lvar_DateFDOTW=#Lvar_DateFDOTW#" label="Lvar_DateFDOTW"></cfif>
			<cfquery name="rsvInsert" datasource="#session.dsn#">
				select RHCMCSid
				from RHCMControlSemanal 
				where DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHoras.DEid#">
				and RHCMCSfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_DateFDOTW#">
				and RHCMCSpagoseptimo = 0
			</cfquery>
			<cfif Arguments.Debug><cfdump var="#rsvInsert#" label="rsvInsert"></cfif>
			<cfif rsvInsert.recordcount GT 0>
				<cfset rsInsert.identity = rsvInsert.RHCMCSid>
			<cfelse>
				<cfquery name="rsInsert" datasource="#session.dsn#">
					insert into RHCMControlSemanal 
					(DEid, RHCMCSpagoseptimo, RHCMCSmontoseptimo, RHCMCSfecha, 
					BMfecha, BMUsucodigo)
					values(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHoras.DEid#">,
						0, 0.00, 
						<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_DateFDOTW#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
					)
					<cf_dbidentity1 verificar_transaccion="false">
				</cfquery>
				<cf_dbidentity2 name="rsInsert" verificar_transaccion="false">
			</cfif>
			<cfif Arguments.Debug><cf_dumptable name="RHCMControlSemanal" label="RHCMControlSemanal" filtro="RHCMCSid=#rsInsert.identity#" abort="false"></cfif>
			<cfif ListFind("0,1,2,3,4,5,6","#Lvar_DatePartWOH#")>
				<cfquery name="rsRHCMDia" datasource="#session.dsn#">
					SELECT RHCMDid
					FROM RHCMDia 
					where RHCMCSid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">
					  and RHCMDdia=<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_DatePartWOH#">
					  and RHCMDfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_DateWOH#">
				</cfquery>
				<cfif Arguments.Debug><cfdump var="#rsRHCMDia#" label="rsRHCMDia"></cfif>
				<cfif rsRHCMDia.recordcount GT 0>
					<cfquery datasource="#session.dsn#">
						UPDATE RHCMDia 
						SET 
							<cfif rsHoras.CIid eq rsHoras.RHJincHJornada>
								RHCMDhniid= case 
											when (RHCMDhniid is null) or (RHCMDhniid = 0)
											then <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidhn#">
											else RHCMDhniid 
											end
								,RHCMDhn=<cfqueryparam cfsqltype="cf_sql_float" value="#Lvar_RHCMDhn#">
							<cfelseif rsHoras.CIid eq rsHoras.RHJincExtraA>
								RHCMDheaiid=case 
											when (RHCMDheaiid is null) or (RHCMDheaiid = 0)
											then <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidhea#">
											else RHCMDheaiid 
											end
								,RHCMDhea=<cfqueryparam cfsqltype="cf_sql_float" value="#Lvar_RHCMDhea#">
							<cfelseif rsHoras.CIid eq rsHoras.RHJincExtraB>
								RHCMDhebiid=case 
											when (RHCMDhebiid is null) or (RHCMDhebiid = 0)
											then <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidheb#">
											else RHCMDhebiid 
											end
	                            ,RHCMDheb=<cfqueryparam cfsqltype="cf_sql_float" value="#Lvar_RHCMDheb#">
							<cfelseif rsHoras.CIid eq rsHoras.RHJincFeriados>
								RHCMDferiid=case 
											when (RHCMDferiid is null) or (RHCMDferiid = 0)
											then <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidfer#">
											else RHCMDferiid 
											end
							</cfif>
						where RHCMDid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRHCMDia.RHCMDid#">
					</cfquery>
				<cfelse>
					<cfquery datasource="#session.dsn#">
						insert into RHCMDia 
							(RHCMCSid, RHCMDdia, RHCMDfecha, 
							RHJid, RHCMDhn, RHCMDhea, 
							RHCMDheb, RHCMDhniid, RHCMDheaiid, 
							RHCMDhebiid, RHCMDferiid, 
							BMfecha, BMUsucodigo)
						values(
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.identity#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_DatePartWOH#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_DateWOH#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsHoras.RHJid#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#Lvar_RHCMDhn#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#Lvar_RHCMDhea#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#Lvar_RHCMDheb#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidhn#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidhea#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidheb#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Iidfer#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
						)
					</cfquery>
				</cfif>
				<cfif Arguments.Debug><cf_dumptable var="RHCMDia" label="RHCMDia(1)" filtro="RHCMCSid=#rsInsert.identity# and RHCMDdia=#Lvar_DatePartWOH#" abort=false></cfif>
			</cfif>
		<cfelse>
			<cfif Arguments.Debug><cf_dumptable var="RHCMDia" label="RHCMDia(2)" filtro="RHCMDhniid=#Arguments.Iid# OR RHCMDheaiid=#Arguments.Iid# OR RHCMDhebiid=#Arguments.Iid# OR RHCMDferiid=#Arguments.Iid#" abort=false></cfif>
			<cfquery datasource="#session.dsn#">
				update 	RHCMDia 
					set RHCMDhniid = 0,
						RHCMDhn = 0
				where	RHCMDhniid 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update 	RHCMDia 
					set RHCMDheaiid = 0,
						RHCMDhea = 0
				where	RHCMDheaiid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update RHCMDia 
					set RHCMDhebiid = 0,
						RHCMDheb = 0
				where	RHCMDhebiid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				update 	RHCMDia 
					set RHCMDferiid = 0
				where	RHCMDferiid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
			</cfquery>
			<cfquery datasource="#session.dsn#">
				delete 	from RHCMDia 
				where   RHCMDhniid = 0
				and 	RHCMDhn = 0
				and 	RHCMDheaiid = 0
				and 	RHCMDhea = 0
				and		RHCMDhebiid = 0
				and		RHCMDheb = 0
				and		RHCMDferiid = 0
			</cfquery>
			<cfif Arguments.Debug><cf_dumptable var="RHCMDia" label="RHCMDia(3)" filtro="RHCMDhniid=#Arguments.Iid# OR RHCMDheaiid=#Arguments.Iid# OR RHCMDhebiid=#Arguments.Iid# OR RHCMDferiid=#Arguments.Iid#" abort=false></cfif>
		</cfif>
		<cfif Arguments.Debug><cfabort></cfif>
	</cffunction>

	<!--- ********************* --->
	<!--- Cambio De Incidencias --->
	<!--- ********************* --->
	<cffunction access="public" name="Cambio">
		<cfargument name="Iid" required="true" type="numeric">
		<cfargument name="DEid" required="true" type="numeric">
		<cfargument name="CIid" required="true" type="numeric">
		<cfargument name="iFecha" required="true" type="date">
		<cfargument name="iFechaRebajo" required="false" type="string">		
		<cfargument name="iValor" required="true" type="numeric">
		<cfargument name="CFid" required="false" type="numeric" default="0">
		<cfargument name="RHJid" required="false" type="numeric" default="0">
		<cfargument name="Icpespecial" required="false" type="numeric" default="0">
<cfargument name="Imonto" required="false" type="numeric" default="0">		

		<cfset This.chkExists(Arguments.DEid, Arguments.CIid, Arguments.iFecha, Arguments.Iid)>
		<cftransaction>
			<cfquery name="ABC_Incidencia" datasource="#Session.DSN#">
				update Incidencias set 
					DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">, 
					<!---
						************************************************************************
						Se mantiene la regla del negocio que se encontró en el sql original, que
						indicaba que no se modifica el concepto de incidencia.
						Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">, 
						************************************************************************
					--->
					Ifecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.iFecha#">,
					<!---IfechaRebajo = <cfif isdefined(Arguments.iFechaRebajo) and len(trim( Arguments.iFechaRebajo ))><cfqueryparam cfsqltype="cf_sql_date" value="#LSParsedateTime(Arguments.iFechaRebajo)#" ><cfelse>null</cfif>,--->
					IfechaRebajo = <cfif isdefined("Arguments.iFechaRebajo") and len(trim( Arguments.iFechaRebajo ))><cfqueryparam cfsqltype="cf_sql_date" value="#LSParsedateTime(Arguments.iFechaRebajo)#" ><cfelse>null</cfif>,
					Ivalor = <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.iValor#">,
					CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFid#" null="#Arguments.CFid LTE 0#">,
					RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHJid#" null="#Arguments.RHJid LTE 0#">,
					Icpespecial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Icpespecial#">,
					Imonto = <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.Imonto#"> <!--- jc --->
				where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Iid#">
			</cfquery>
			<cfinvoke method="updateCMControlSemanal" Iid="#Form.Iid#">
		</cftransaction>
	</cffunction>
	

	<!--- ********************* --->
	<!--- Incrementar De Incidencias --->
	<!--- ********************* --->
	<cffunction access="public" name="Incrementar">
		<cfargument name="Iid" required="true" type="numeric">
		<cfargument name="iValor" required="true" type="numeric">
			<cfquery name="ABC_Incidencia" datasource="#Session.DSN#">
				update Incidencias 
				set Ivalor = Ivalor + <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.iValor#">
				where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Iid#">
			</cfquery>
			<cfquery name="ABC_Incidencia" datasource="#Session.DSN#">
				delete from Incidencias
				where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Iid#">
				and Ivalor <= 0.00
			</cfquery>
			<cfinvoke method="updateCMControlSemanal" Iid="#arguments.Iid#">
	</cffunction>

	
	<!--- ******************* --->
	<!--- Baja De Incidencias --->
	<!--- ******************* --->
	<cffunction access="public" name="Baja">
		<cfargument name="Iid" required="no" type="numeric">
        <cfargument name="EIlote" required="no" type="numeric">
        <cfquery name="ABC_Incidencia" datasource="#Session.DSN#">
            delete from Incidencias 
            where 
            <cfif isdefined('Arguments.Iid')>
            Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
            <cfelse>
            EIlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIlote#">
            </cfif>
        </cfquery>		
	</cffunction>
	
	
	<!--- ***************************************************************** --->
	<!--- Averigua si existe una Incidencia para un empleado para una fecha --->
	<!--- ***************************************************************** --->
	<cffunction access="public" name="chkExists">
		<cfargument name="DEid" required="true" type="numeric">
		<cfargument name="CIid" required="true" type="numeric">
		<cfargument name="iFecha" required="true" type="date">
		<cfargument name="Iid" required="false" type="numeric">
		<cfquery name="chkExists" datasource="#Session.DSN#">
			select 1
			from Incidencias
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			  and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#">
			  and Ifecha = <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.iFecha#">
			  <cfif isdefined("Arguments.Iid") and Arguments.Iid gt 0>
				  and Iid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
			  </cfif>
		</cfquery>
		<cfif chkExists.recordCount GT 0>
			<cfquery name="rsInfoEmpleado" datasource="#Session.DSN#">
				select DEidentificacion, DEapellido1, DEapellido2, DEnombre
				from DatosEmpleado
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			</cfquery>
			<cfquery name="rsInfoConceptoI" datasource="#Session.DSN#">
				select CIcodigo, CIdescripcion
				from CIncidentes
				where CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#">
			</cfquery>
			<cfset reg = "">
			<cfset msg = "">
			<cfset reg = "/cfmx/rh/nomina/operacion/Incidencias.cfm">
			<cfset msg = "">
			<cfset msg = msg  & "#vError#.<br>">
			<cfset msg = msg  & " #vEmpleado#: #rsInfoEmpleado.DEidentificacion# - #rsInfoEmpleado.DEapellido1# #rsInfoEmpleado.DEapellido2# #rsInfoEmpleado.DEnombre#<br>">
			<cfset msg = msg  & " #vConcepto#: #rsInfoConceptoI.CIcodigo# - #rsInfoConceptoI.CIdescripcion#<br>">
			<cfset msg = msg  & " #vFecha#: #LSDateFormat(Arguments.Ifecha,'dd/mm/yyyy')#.<br> <br>">
			<cf_throw message="#msg#" errorCode="1005">
			<cfabort>
		</cfif>
	</cffunction>
    
    <cffunction name="fnGetDIncidencias" access="public" returntype="query">
    	<cfargument name="Iid"  	type="numeric" required="yes">
        <cfargument name="Ecodigo" 	type="numeric" required="no">
        <cfargument name="Conexion" type="numeric" required="no">
    
    	<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
    
    	<cfquery name="rsIncidencias" datasource="#Arguments.Conexion#">
            select Iid, DEid, CIid, CFid, Ifecha, Ivalor, Ifechasis, Usucodigo, Ulocalizacion, BMUsucodigo, Iespecial, RCNid, Mcodigo, ts_rversion, RHJid, Imonto, Icpespecial, IfechaRebajo, Iusuaprobacion, Ifechaaprobacion, NRP, Inumdocumento, CFcuenta, NAP, Iestado, CFormato, complemento, Ifechacontrol, EIlote
            from Incidencias
            where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
        </cfquery>
        
        <cfreturn rsIncidencias>
    </cffunction>
    
    <cffunction name="fnGetCIncidencias" access="public" returntype="query">
    	<cfargument name="CIid"  	type="numeric" required="no">
        <cfargument name="CIcodigo"  type="string" required="no">
        <cfargument name="Ecodigo" 	type="numeric" required="no">
        <cfargument name="Conexion" type="numeric" required="no">
    
    	<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
    
    	<cfquery name="rsIncidencias" datasource="#Arguments.Conexion#">
            select CIid,CIcodigo,CIdescripcion
            from CIncidentes
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            <cfif isdefined('Arguments.CIid')>
              and CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#">
            </cfif>
            <cfif isdefined('Arguments.CIcodigo')>
              and CIcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CIcodigo#">
            </cfif>
        </cfquery>
        
        <cfreturn rsIncidencias>
    </cffunction>
    
    <cffunction name="fnBajaIncidenciaCalculo" access="public">
    	<cfargument name="ICid"  	type="numeric" required="no">
    	<cfargument name="CIid"  	type="numeric" required="no">
        <cfargument name="DEid"  	type="numeric" required="no">
        <cfargument name="Conexion" type="numeric" required="no">
    
    	<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
    
    	<cfquery datasource="#Arguments.Conexion#">
			delete from IncidenciasCalculo
            where
            <cfif isdefined('Arguments.ICid')>
            	ICid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ICid#">
          	<cfelse>
            	CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CIid#"> and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
            </cfif>
        </cfquery>
    </cffunction>
    
    <cffunction name="fnAltaIncidenciaCalculo" access="public">
    	<cfargument name="RCNid"  			type="numeric" 	required="yes">
    	<cfargument name="CIid"  			type="numeric" 	required="yes">
        <cfargument name="DEid"  			type="numeric" 	required="yes">
        <cfargument name="ICfecha"  		type="date" 	required="no">
        <cfargument name="ICvalor"  		type="numeric" 	required="no">
        <cfargument name="ICfechasis"  		type="date" 	required="no">
        <cfargument name="Usucodigo"  		type="numeric" 	required="no">
        <cfargument name="Ulocalizacion"  	type="string" 	required="no" default="">
        <cfargument name="ICmontoant"  		type="numeric" 	required="no">
        <cfargument name="ICmontores"  		type="numeric" 	required="no">
        <cfargument name="Conexion" 		type="numeric" 	required="no">
    
    	<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.ICfecha')>
        	<cfset Arguments.ICfecha = "">
        </cfif>
        <cfif not isdefined('Arguments.ICvalor')>
        	<cfset Arguments.ICvalor = "">
        </cfif>
        <cfif not isdefined('Arguments.ICfechasis')>
        	<cfset Arguments.ICfechasis = "">
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.ICmontores')>
        	<cfset Arguments.ICmontores = "">
        </cfif>
    
    	<cfquery name="rsInsert" datasource="#Arguments.Conexion#">
			insert into IncidenciasCalculo(RCNid, DEid, CIid, ICfecha, ICvalor, ICfechasis, Usucodigo, Ulocalizacion, ICmontoant, ICmontores)
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.RCNid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.DEid#">,
                <cfqueryparam cfsqltype="cf_sql_numeric" 	value="#Arguments.CIid#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.ICfecha#" 		voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.ICvalor#" 		voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.ICfechasis#" 		voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Usucodigo#" 		voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.Ulocalizacion#" 	voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.ICmontoant#" 		voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_money" 		value="#Arguments.ICmontores#" 		voidnull>
            )
        <cf_dbidentity1 datasource="#Arguments.Conexion#">
        </cfquery>
        <cf_dbidentity2 datasource="#Arguments.Conexion#" name="rsInsert">
        <cfreturn rsInsert.identity>
    </cffunction>
    
    <cffunction name="fnGetEIncidenciaMasiva" access="public" returntype="query">
    	<cfargument name="EIlote"  			type="numeric" 	required="no">
        <cfargument name="Tcodigo"  		type="string" 	required="no">
        <cfargument name="EIestado"  		type="numeric" 	required="no">
    	<cfargument name="Ecodigo"  		type="numeric" 	required="no">
        <cfargument name="Conexion" 		type="numeric" 	required="no">
    
    	<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
    
    	<cfquery name="rsIncidenciaE" datasource="#Arguments.Conexion#">
			select EIlote, CIid, EIdescripcion, Ecodigo, Tcodigo, EIfecha, EIfechaaplic, EIestado, Mcodigo, SNcodigo, Usucodigo, Ulocalizacion, BMUsucodigo, ts_rversion
            from EIncidencias
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
            <cfif isdefined('Arguments.EIlote')>
			  and EIlote = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.EIlote#">
			</cfif>
            <cfif isdefined('Arguments.Tcodigo')>
			  and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#trim(Arguments.Tcodigo)#">
			</cfif>
            <cfif isdefined('Arguments.EIestado')>
			  and EIestado = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.EIestado#">
			</cfif>
        </cfquery>
        <cfreturn rsIncidenciaE>
    </cffunction>
    
    <cffunction name="fnGetLote" access="public" returntype="numeric">
        <cfargument name="Conexion" type="string" required="no">
    
    	<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
    
    	<cfquery name="rsLote" datasource="#Arguments.Conexion#">
            select coalesce(max(EIlote),0)+1 as Lote
            from EIncidencias
        </cfquery>
        <cfreturn rsLote.Lote>
    </cffunction>
    
    <cffunction name="fnAltaEIncidenciaMasiva" access="public" returntype="numeric">
    	<cfargument name="EIlote" 		type="numeric" 	required="no">
        <cfargument name="CIid" 		type="numeric" 	required="no">
        <cfargument name="Ecodigo" 		type="numeric" 	required="no">
        <cfargument name="Tcodigo" 		type="string" 	required="no" default="">
        <cfargument name="EIfecha" 		type="date" 	required="no">
        <cfargument name="EIfechaaplic" type="date" 	required="no">
        <cfargument name="EIestado" 	type="numeric" 	required="no" default="0">
        <cfargument name="Mcodigo" 		type="numeric" 	required="no">
        <cfargument name="SNcodigo" 	type="numeric" 	required="no">
        <cfargument name="Usucodigo" 	type="numeric" 	required="no">
        <cfargument name="Ulocalizacion" type="string" 	required="no" default="">
        <cfargument name="EIdescripcion" type="string" 	required="no" default="">
    	<cfargument name="Conexion" 	type="numeric" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.EIlote')>
        	<cfset Arguments.EIlote = fnGetLote(Arguments.Conexion)>
        </cfif>
        <cfif not isdefined('Arguments.CIid')>
        	<cfset Arguments.CIid = "">
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.EIfecha')>
        	<cfset Arguments.EIfecha = "">
        </cfif>
        <cfif not isdefined('Arguments.EIfechaaplic')>
        	<cfset Arguments.EIfechaaplic = "">
        </cfif>
        <cfif not isdefined('Arguments.Mcodigo')>
        	<cfset Arguments.Mcodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.SNcodigo')>
        	<cfset Arguments.SNcodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <cfif not isdefined('Arguments.BMUsucodigo')>
        	<cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
       
        
    	<cfquery datasource="#Arguments.Conexion#">
            insert into EIncidencias(EIlote, CIid, Ecodigo, Tcodigo, EIfecha, EIfechaaplic, EIestado, Mcodigo, SNcodigo, Usucodigo, Ulocalizacion, BMUsucodigo, EIdescripcion)
            values(
            	<cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.EIlote#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CIid#" voidnull>,
                <cfqueryparam cfsqltype="cf_sql_integer" 			value="#Arguments.Ecodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.Tcodigo#" voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.EIfecha#" voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.EIfechaaplic#" voidnull>,
                <cfqueryparam cfsqltype="cf_sql_integer" 			value="#Arguments.EIestado#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Mcodigo#" voidnull>,
                <cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Arguments.SNcodigo#" voidnull>,
                <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.Usucodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.Ulocalizacion#" voidnull>,
                <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.BMUsucodigo#">,
                <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.EIdescripcion#" voidnull> 
            )
        </cfquery>
        <cfreturn Arguments.EIlote>
    </cffunction>
    
    <cffunction name="fnCambioEIncidenciaMasiva" access="public" returntype="numeric">
    	<cfargument name="EIlote" 		type="numeric" 	required="yes">
        <cfargument name="CIid" 		type="numeric" 	required="no">
        <cfargument name="Ecodigo" 		type="numeric" 	required="no">
        <cfargument name="Tcodigo" 		type="string" 	required="no" default="">
        <cfargument name="EIfecha" 		type="date" 	required="no">
        <cfargument name="EIfechaaplic" type="date" 	required="no">
        <cfargument name="EIestado" 	type="numeric" 	required="no" default="0">
        <cfargument name="Mcodigo" 		type="numeric" 	required="no">
        <cfargument name="SNcodigo" 	type="numeric" 	required="no">
        <cfargument name="Usucodigo" 	type="numeric" 	required="no">
        <cfargument name="Ulocalizacion" type="string" 	required="no" default="">
        <cfargument name="EIdescripcion" type="string" 	required="no" default="">
    	<cfargument name="Conexion" 	type="numeric" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.CIid')>
        	<cfset Arguments.CIid = "">
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
        <cfif not isdefined('Arguments.EIfecha')>
        	<cfset Arguments.EIfecha = "">
        </cfif>
        <cfif not isdefined('Arguments.EIfechaaplic')>
        	<cfset Arguments.EIfechaaplic = "">
        </cfif>
        <cfif not isdefined('Arguments.Mcodigo')>
        	<cfset Arguments.Mcodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.SNcodigo')>
        	<cfset Arguments.SNcodigo = "">
        </cfif>
        <cfif not isdefined('Arguments.Usucodigo')>
        	<cfset Arguments.Usucodigo = session.Usucodigo>
        </cfif>
        <cfif not isdefined('Arguments.BMUsucodigo')>
        	<cfset Arguments.BMUsucodigo = session.Usucodigo>
        </cfif>
       
    	<cfquery datasource="#Arguments.Conexion#">
        	update EIncidencias set
            	CIid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.CIid#" voidnull>,
                Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 			value="#Arguments.Ecodigo#">,
                Tcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.Tcodigo#" voidnull>,
                EIfecha = <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.EIfecha#" voidnull>,
                EIfechaaplic = <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" 	value="#Arguments.EIfechaaplic#" voidnull>,
                EIestado = <cfqueryparam cfsqltype="cf_sql_integer" 			value="#Arguments.EIestado#">,
                Mcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 		value="#Arguments.Mcodigo#" voidnull>,
                SNcodigo = <cf_jdbcquery_param cfsqltype="cf_sql_integer" 		value="#Arguments.SNcodigo#" voidnull>,
                Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.Usucodigo#">,
                Ulocalizacion = <cf_jdbcquery_param cfsqltype="cf_sql_char" 		value="#Arguments.Ulocalizacion#" voidnull>,
                BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.BMUsucodigo#">,
                EIdescripcion = <cf_jdbcquery_param cfsqltype="cf_sql_varchar" 		value="#Arguments.EIdescripcion#" voidnull>
      		where EIlote = <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.EIlote#">
        </cfquery>
        <cfreturn Arguments.EIlote>
    </cffunction>
    
    <cffunction name="fnBajaEIncidenciaMasiva" access="public">
    	<cfargument name="EIlote" 		type="numeric" 	required="yes">
        <cfargument name="Ecodigo" 		type="numeric" 	required="no">
    	<cfargument name="Conexion" 	type="numeric" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
       
    	<cfquery datasource="#Arguments.Conexion#">
        	delete from EIncidencias
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 			value="#Arguments.Ecodigo#">
              and EIlote = <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.EIlote#">
        </cfquery>
        <cfreturn Arguments.EIlote>
    </cffunction>
    
    <cffunction name="fnAplicarEIncidenciaMasiva" access="public" returntype="numeric">
    	<cfargument name="EIlote" 		type="numeric" 	required="yes">
        <cfargument name="Ecodigo" 		type="numeric" 	required="no">
    	<cfargument name="Conexion" 	type="numeric" 	required="no">
        
        <cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        <cfif not isdefined('Arguments.Ecodigo')>
        	<cfset Arguments.Ecodigo = session.Ecodigo>
        </cfif>
       
    	<cfquery datasource="#Arguments.Conexion#">
        	update EIncidencias set EIestado = 1 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" 			value="#Arguments.Ecodigo#">
              and EIlote = <cfqueryparam cfsqltype="cf_sql_numeric" 			value="#Arguments.EIlote#">
        </cfquery>
        <cfreturn Arguments.EIlote>
    </cffunction>
    
    <cffunction access="public" name="fnCambioDIncidenciaMasivaMonto" returntype="numeric">
		<cfargument name="Iid" 		required="true" 	type="numeric">
		<cfargument name="iValor" 	required="true" 	type="numeric">
		<cfargument name="Imonto" 	required="false"	type="numeric" default="0">		
        <cfargument name="Conexion" required="false"	type="string">	
        
		<cfif not isdefined('Arguments.Conexion')>
        	<cfset Arguments.Conexion = session.dsn>
        </cfif>
        
        <cfquery datasource="#Arguments.Conexion#">
            update Incidencias set 
              	Ivalor = <cfqueryparam cfsqltype="cf_sql_money" value="#Arguments.iValor#">,
              	Imonto = <cfqueryparam cfsqltype="cf_sql_numeric" scale="2" value="#Arguments.Imonto#">
            where Iid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Iid#">
        </cfquery>
		<cfinvoke method="updateCMControlSemanal" Iid="#Arguments.Iid#">
        <cfreturn Arguments.Iid>
	</cffunction>
</cfcomponent>