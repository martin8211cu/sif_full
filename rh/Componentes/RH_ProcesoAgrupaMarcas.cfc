<cfcomponent>
	<!--- VARIABLES DE TRADUCCIÓN --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Error_antes_de_agrupar_marcas"
		Default="Error antes de agrupar marcas"
		returnvariable="MSG_Error_antes_de_agrupar_marcas"
		XmlFile="/rh/Componentes/RH_ProcesoAgrupaMarcas.xml"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_No_se_encontro_el_parametro_de_cantidad_de_horas_para_diferencias_Entrada_Salida_para_el_proceso_de_agrupamiento"
		Default="No se encontró el parámetro de cantidad de horas para diferencias Entrada \ Salida para el proceso de agrupamiento"	
		returnvariable="MSG_No_se_encontro_el_parametro_de_cantidad_de_horas_para_diferencias_Entrada_Salida_para_el_proceso_de_agrupamiento"
		XmlFile="/rh/Componentes/RH_ProcesoAgrupaMarcas.xml"/>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="MSG_Proceso_Cancelado"
		Default="Proceso Cancelado"	
		returnvariable="MSG_Proceso_Cancelado"
		XmlFile="/rh/Componentes/RH_ProcesoAgrupaMarcas.xml"/>
	<!--- FUNCIÓN PRINCIPAL DE AGRUPAMIENTO DE MARCAS --->
	<cffunction name="RH_ProcesoAgrupaMarcas" access="public" output="true">
		<cfargument name="Ecodigo" type="numeric" required="false">
		<cfargument name="Conexion" type="string" required="false">
		<cfargument name="Usucodigo" type="numeric" required="false">
		<cfargument name="Debug" type="boolean" default="false">
		<!---Este argumento se crea para mandar al componente de RH_ProcesoGeneraMarcas el Usucodigo del autorizador de modo que no se detenga
		el proceso en la validación, cuando el proceso viene de registro de marcas de autogestion. Modulo nuevo del ITCR                  --->
		<cfargument name="Usucodigo2" type="numeric" default="false">
	
		<cfset var Lvar_FechaMaxAgrupa = "">
		<cfset var Lvar_DEid = 0>
	
		<!--- DEFINE ARGUMENTOS ECODIGO, CONEXION, USUCODIGO. CUANDO NO VIENEN. --->
		<cfif (not isdefined("Arguments.Ecodigo")) and (isdefined("Session.Ecodigo"))>
			<cfset Arguments.Ecodigo = Session.Ecodigo>
		</cfif>
		<cfif (not isdefined("Arguments.Conexion")) and (isdefined("Session.Dsn"))>
			<cfset Arguments.Conexion = Session.Dsn>
		</cfif>
		<cfif (not isdefined("Arguments.Usucodigo")) and (isdefined("Session.Usucodigo"))>
			<cfset Arguments.Usucodigo = Session.Usucodigo>
		</cfif>
		<!--- DETERMINA CANTIDAD DE HORAS DE DIFERENCIA ENTRE GRUPOS --->
		<cfquery name="rsHorasDiff" datasource="#Arguments.Conexion#">
			select Pvalor as HorasDiff
			from RHParametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and Pcodigo = 610
		</cfquery>

		<!--- DETERMINA LA FECHA DE MAXIMA DE AGRUPAMIENTO DE MARCAS --->
		<cf_dbfunction name="to_number" args="Pvalor" returnvariable="Lvar_to_number_Pvalor" >
		<cf_dbfunction name="dateaddx" args="hh|-#Lvar_to_number_Pvalor#|#now()#" returnvariable="Lvar_dateaddx_to_number_Pvalor" delimiters="|">
		<cfquery name="rsFechaMaxAgrupa" datasource="#Arguments.Conexion#">
			select (#PreserveSingleQuotes(Lvar_dateaddx_to_number_Pvalor)#) as FechaMaxAgrupa
			from RHParametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and Pcodigo = 610
		</cfquery>
		<cfif isdefined("rsFechaMaxAgrupa.FechaMaxAgrupa") and len(trim(rsFechaMaxAgrupa.FechaMaxAgrupa)) gt 0 and rsFechaMaxAgrupa.FechaMaxAgrupa gt 0>
			<cfset Lvar_FechaMaxAgrupa = rsFechaMaxAgrupa.FechaMaxAgrupa>
		<cfelse>
			<cfthrow message="#MSG_Error_antes_de_agrupar_marcas#. #MSG_No_se_encontro_el_parametro_de_cantidad_de_horas_para_diferencias_Entrada_Salida_para_el_proceso_de_agrupamiento#. #MSG_Proceso_Cancelado#!">
		</cfif>
		<!--- DETERMINA LOS EMPLEADOS POR PROCESAR --->
		<cfquery name="rsEmpleados" datasource="#Arguments.Conexion#">
			select DEid
			from RHControlMarcas a
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and grupomarcas is null		<!---Marcas no agrupadas	---->
				and numlote is null 		<!---Marcas no procesadas	---->
				and registroaut = 1			<!---Marcas autorizadas		---->		
			
			<cfif isdefined("Arguments.Usucodigo2") and len(trim(Arguments.Usucodigo2)) GT 0 and Arguments.Usucodigo2 GT 0>
				and exists (
					select 1 from RHCMEmpleadosGrupo b
						inner join RHCMAutorizadoresGrupo c
						on c.Ecodigo = b.Ecodigo
						and c.Usucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo2#">
					where b.DEid = a.DEid
					  and b.Ecodigo = a.Ecodigo
				)
			</cfif>
			<cfif isdefined("Arguments.Usucodigo") and len(trim(Arguments.Usucodigo)) GT 0 and Arguments.Usucodigo GT 0 and not isdefined('arguments.Usucodigo2')>
				and exists (
					select 1 from RHCMEmpleadosGrupo b
						inner join RHCMAutorizadoresGrupo c
						on c.Ecodigo = b.Ecodigo
						and c.Usucodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Usucodigo#">
					where b.DEid = a.DEid
					  and b.Ecodigo = a.Ecodigo
				)
			</cfif>
			group by DEid
		</cfquery>

		<cfloop query="rsEmpleados">
			<cfset Lvar_DEid = rsEmpleados.DEid>
			<!--- AGRUPA LAS MARCAS DEL EMPLEADO --->
			<cfinvoke method="Agrupar" Ecodigo="#Arguments.Ecodigo#" Conexion="#Arguments.Conexion#" Debug="#Arguments.Debug#"
				DEid="#Lvar_DEid#" FechaMaxAgrupa="#Lvar_FechaMaxAgrupa#" HorasDiff="#rsHorasDiff.HorasDiff#">
		</cfloop>
			
		<!--- DESAUTORIZA TODAS LAS MARCAS NO AGRUPADAS --->
		<cfquery datasource="#Arguments.Conexion#">
			update RHControlMarcas
			set registroaut = 0
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			and fechahoramarca <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Lvar_FechaMaxAgrupa#">
			and grupomarcas is null
			and numlote is null
			and registroaut = 1
		</cfquery>

		<!--- PROCESA MARCAS AGRUPADAS. SI SE TRATA DEL PROCESO CORRIENDO DESDE LA OPCIÓN DEL SUPERVISOR 
			EL MISMO DEBE CORRER SOLO PARA LOS GRUPOS ASOCIADOS AL USUARIO DEL SUPERVISROR, SI SE TRATA 
			DE LA TAREA PARA TODOS LOS GRUPOS --->
		<cfinvoke component="rh.Componentes.RH_ProcesoGeneraMarcas" method="RH_ProcesoGeneraMarcas">
			<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#" >
			<cfinvokeargument name="Conexion" value="#Arguments.Conexion#"> 
			<cfif isdefined("Arguments.Usucodigo") and len(trim(Arguments.Usucodigo)) gt 0 and not isdefined('Arguments.Usucodigo2')>
				<cfinvokeargument name="Usucodigo" value="#Arguments.Usucodigo#">
			</cfif>
			<cfif isdefined("Arguments.Usucodigo2") and len(trim(Arguments.Usucodigo2)) gt 0>
				<cfinvokeargument name="Usucodigo" value="#Arguments.Usucodigo2#">
			</cfif>
			<cfinvokeargument name="fechaFin" value="#Lvar_FechaMaxAgrupa#">
		</cfinvoke>
	</cffunction>
	<!--- FUNCIÓN PARA AGRUPAR MARCAS DE FORMA RECURSIVA CUANDO NO HAY MAS MARCAS QUE AGRUPAR ROMPE LA RECURSIVIDAD --->
	<cffunction name="Agrupar" access="private" output="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="Conexion" type="string" required="true">
		<cfargument name="Debug" type="boolean" default="false">
		<cfargument name="DEid" type="numeric" required="true">
		<cfargument name="FechaMaxAgrupa" type="date" required="true">
		<cfargument name="HorasDiff" type="numeric" required="true">
		
		<!--- CADA INVOCACIÓN A AGRUPAR PARTE DEL PUNTO DE QUE EL GRUPO ES INVÁLIDO --->
		<cfset var Lvar = StructNew()>
		
		<cfset Lvar.ValidGroup = false>
		<cfset Lvar.FechaSalida = "">
		<cfset Lvar.FechaEntrada = "">
		<cfset Lvar.RHCMidList = "">
		
		<cfset Lvar.RHCMid = 0>
		<cfset Lvar.DEid = 0>
		<cfset Lvar.tipomarca = "">
		<cfset Lvar.fechahoramarca = "">
		
		<cfset Lvar.RHCMidEntrada = 0>
		<cfset Lvar.RHCMidEntradaAnterior = 0>
		<cfset Lvar.FechaEntradaAnterior = "">
		<cfset Lvar.TipoMarcaAnterior = "">
		
		<cfset Lvar.RecordCount = 0>
		<cfset Lvar.CurrentRow = 0>
			
		<!---
		<cfdump var="#Lvar#" label="lvar">
		<cfdump var="#arguments#"  label="arguments">
		--->
		
		<!---AVERIGUAR SI SE DEBE VALIDAR SI EL EMPLEADO DEBE ESTAR NOMBRADO PARA LA FECHA DE LA MARCA
		ISVALIDDEID( ARGUMENTS.ECODIGO, ARGUMENTS.CONEXION, ARGUMENTS.DEID, ARGUMENTS.FECHAMAXAGRUPA )--->
		<!---
			OBTENER TODAS LAS MARCAS DEL EMPLEADO:
				- MARCAS NO AGRUPADAS
				- MARCAS NO PROCESADAS
				- MARCAS AUTORIZADAS
		--->
		<!--- AGRUPA MARCAS POR CRITERIO DE PREAGRUPAMIENTO DE IMPORTACIÓN --->
		<cfquery datasource="#session.DSN#">
			update RHControlMarcas
			   set grupomarcas = (select min(RHCMid) from RHControlMarcas subqt where subqt.grupomarcasimp = RHControlMarcas.grupomarcasimp)
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and fechahoramarca <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaMaxAgrupa#">
				and grupomarcasimp is not null
				and grupomarcas is null
				and numlote is null
				and registroaut = 1
		</cfquery>
		
		<!---	<cfquery name="rs" datasource="#session.dsn#">
				select * from RHControlMarcas
				where Ecodigo=#session.Ecodigo#
				and DEid=#form.DEid#
				and grupomarcas = (select min(RHCMid) from RHControlMarcas subqt where subqt.grupomarcasimp = RHControlMarcas.grupomarcasimp)
				and registroaut=1
			</cfquery>--->
			
		<!--- DETERMINA TODAS LAS MARCAS POR AGRUPAR DEL EMPLEADO --->
		<cfquery name="rsMarcas" datasource="#Arguments.Conexion#">
			select a.RHCMid,
					a.DEid,
					a.tipomarca,
					a.fechahoramarca
			from RHControlMarcas a
				inner join RHJornadas b
				on b.RHJid = a.RHJid
				and b.RHJjsemanal = 0 /*verifique las marcas por dia*/
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
				and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
				and a.fechahoramarca <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Arguments.FechaMaxAgrupa#">
				and a.grupomarcas is null
				and a.numlote is null
				and a.registroaut = 1
			order by a.fechahoramarca desc
		</cfquery>

		<!--- <cfdump var="#rsMarcas#"> --->
		
		<cfset Lvar.RecordCount = rsMarcas.RecordCount>
		<cfloop query="rsMarcas">
			<!--- SE LIMPIAN VARIABLES --->
			<cfset Lvar.RHCMid = 0>
			<cfset Lvar.DEid = 0>
			<cfset Lvar.tipomarca = "">
			<cfset Lvar.fechahoramarca = "">
			<!--- SE ASIGNAN VARIABLES --->
			<cfset Lvar.RHCMid = rsMarcas.RHCMid>
			<cfset Lvar.DEid = rsMarcas.DEid>
			<cfset Lvar.tipomarca = rsMarcas.tipomarca>
			<cfset Lvar.fechahoramarca = rsMarcas.fechahoramarca>
			<cfset Lvar.CurrentRow = rsMarcas.CurrentRow>
			<!---<cfset arguments.Debug = true>--->
			<cfif Arguments.Debug>
				<hr>
				<cfdump var="#rsMarcas.RHCMid#"><br>
				<cfdump var="#rsMarcas.DEid#"><br>
				<cfdump var="#rsMarcas.tipomarca#"><br>
				<cfdump var="#rsMarcas.fechahoramarca#"><br>
				
				<cfdump var="#Lvar.RHCMid#"><br>
				<cfdump var="#Lvar.DEid#"><br>
				<cfdump var="#Lvar.tipomarca#"><br>
				<cfdump var="#Lvar.fechahoramarca#"><br>
				
				<cftry>
					<cfdump var="#DateDiff("s",Lvar.fechahoramarca,Lvar.FechaEntradaAnterior)#"><br>
					<cfdump var="#Arguments.HorasDiff*3600#"><br>
					<cfdump var="#(DateDiff("s",Lvar.fechahoramarca,Lvar.FechaEntradaAnterior) GT Arguments.HorasDiff*3600)#"><br>
				<cfcatch>
				</cfcatch>
				</cftry>
			</cfif>
			<!--- FECHA SALIDA --->
			<cfif (len(trim(Lvar.FechaSalida)) EQ 0) and (ucase(trim(Lvar.tipomarca)) EQ "S")>
				<cfset Lvar.FechaSalida = Lvar.fechahoramarca>
			</cfif>
			<!--- VALIDA ENTRADAS SALIDAS INTERCALADAS --->
			<cfif (len(trim(Lvar.FechaSalida)) GT 0) and (Left(Lvar.tipomarca,1) EQ Left(Lvar.TipoMarcaAnterior,1))>
				<cfbreak>
			</cfif>
			<!--- FECHA ENTRADA EN LA ANTERIOR MARCA DE SALIDA --->
			<cfif (len(trim(Lvar.FechaSalida)) GT 0) 
					and (len(trim(Lvar.FechaEntrada)) EQ 0) 
					and (ucase(trim(Lvar.tipomarca)) EQ "S") 
					and (len(trim(Lvar.FechaEntradaAnterior)) GT 0)
					and (len(trim(Lvar.RHCMidList)) GT 0)
					and (len(trim(Lvar.RHCMidEntrada)) GT 0)
					and (DateDiff("s",Lvar.fechahoramarca,Lvar.FechaEntradaAnterior) GT Arguments.HorasDiff*3600)>
				<cfset Lvar.FechaEntrada = Lvar.FechaEntradaAnterior>
				<cfset Lvar.RHCMidEntrada = Lvar.RHCMidEntradaAnterior>
				<cfset Lvar.ValidGroup = true>
				<cfbreak>
			</cfif>
			<!--- FECHA ENTRADA EN LA ÚLTIMA ENTRADA --->
			<cfif (len(trim(Lvar.FechaSalida)) GT 0) 
					and (len(trim(Lvar.FechaEntrada)) EQ 0) 
					and (ucase(trim(Lvar.tipomarca)) EQ "E") 
					and (len(trim(Lvar.RHCMidList)) GT 0)
					and (len(trim(Lvar.RHCMidEntrada)) GT 0)
					and (Lvar.RecordCount eq Lvar.CurrentRow)>
				<cfset Lvar.RHCMidList = ListAppend(Lvar.RHCMidList,Lvar.RHCMid)>
				<cfset Lvar.FechaEntrada = Lvar.fechahoramarca>
				<cfset Lvar.RHCMidEntrada = Lvar.RHCMid>
				<cfset Lvar.ValidGroup = true>
				<cfbreak>
			</cfif>
			<!--- LISTA DE IDS POR AGRUPAR --->
			<cfif (len(trim(Lvar.FechaSalida)) GT 0)>
				<cfset Lvar.RHCMidList = ListAppend(Lvar.RHCMidList,Lvar.RHCMid)>
			</cfif>
			<!--- FECHA ENTRADA ANTERIOR --->
			<cfif (ucase(trim(Lvar.tipomarca)) EQ "E")>
				<cfset Lvar.FechaEntradaAnterior = Lvar.fechahoramarca>
				<cfset Lvar.RHCMidEntradaAnterior = Lvar.RHCMid>
			</cfif>
			<cfset Lvar.TipoMarcaAnterior = Lvar.tipomarca>
		</cfloop>
	<!---	<cfset arguments.Debug = true>--->
	
		<cfif Arguments.Debug>
			<cfdump var="#Lvar.FechaEntrada#"><br>
			<cfdump var="#Lvar.FechaSalida#"><br>
			<cfdump var="#Lvar.RHCMidList#"><br>
			<cfdump var="#rsMarcas#"><br>
			<cfabort>
		</cfif>
		<cfif (Lvar.ValidGroup)>
			<cfquery datasource="#Arguments.Conexion#">
				update RHControlMarcas
				set grupomarcas = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar.RHCMidEntrada#">
				where RHCMid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar.RHCMidList#" list="true">)
			</cfquery>
			<cfinvoke method="Agrupar" Ecodigo="#Arguments.Ecodigo#" Conexion="#Arguments.Conexion#" Debug="#Arguments.Debug#"
				DEid="#Arguments.DEid#" FechaMaxAgrupa="#Lvar.FechaEntrada#" HorasDiff="#Arguments.HorasDiff#">
		<!--- <cfelse>
			<cfdump var="#Lvar#"> --->
		</cfif>
	</cffunction>
	<!--- FUNCIÓN PARA VALIDAR QUE UN EMPLEADO ESTÁ ACTIVO EN UNA FECHA INDICADA --->
	<cffunction name="isValidDEid" access="private" output="true">
		<cfargument name="Ecodigo" type="numeric" required="true">
		<cfargument name="Conexion" type="string" required="true">
		<cfargument name="DEid" type="numeric" required="true">
		<cfargument name="FechaValidez" type="date" required="true">
		<cfset var rsDEid = QueryNew("DEid")>
		<cfquery name="rs" datasource="#Arguments.Conexion#">
			select 1
			from LineaTiempo
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
			  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.DEid#">
			  and <cfqueryparam cfsqltype="cf_sql_date" value="#Arguments.FechaValidez#">
					between LTdesde and LThasta
		</cfquery>
		<cfreturn (rs.recordcount GT 0)>
	</cffunction>
</cfcomponent>
