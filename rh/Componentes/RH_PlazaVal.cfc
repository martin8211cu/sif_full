
<cfcomponent>
	<cffunction name="validarPlazaLT" access="public" output="true" returntype="string"  hint="Validación de Cumplimiento de Plaza en la Linea del Tiempo">
		<cfargument name="RHAlinea" type="numeric" required="yes" hint="Código de Acción de Personal">
		<cfargument name="Ecodigo" type="numeric" required="no" default="#Session.Ecodigo#" hint="Empresa">
		<cfargument name="conexion" type="string" required="no" default="#Session.DSN#" hint="cache">
		<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
		<cfset error = "">
		<cfset LvarEmpresa = Arguments.Ecodigo>

		<!--- Validacion de que el rango de tiempo establecido en la accion este contenida en la linea del tiempo de la plaza --->
		<cfquery name="rsAccionCfg" datasource="#Arguments.conexion#">
			select a.RHAlinea, a.DEid, a.RHTid, a.Ecodigo, a.Tcodigo, a.RVid, a.RHJid, 
				   a.EcodigoRef, a.TcodigoRef, a.RHCconcurso, a.RHAid, a.RHMPid, a.RHCPlinea, 
				   a.Dcodigo, a.Ocodigo, a.RHPid, a.RHPcodigo, a.DLfvigencia, coalesce(a.DLffin, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) as DLffin, a.DLsalario, 
				   a.DLobs, a.Usucodigo, a.Ulocalizacion, a.RHAporc, a.RHAporcsal, a.RHAidtramite, 
				   a.RHAvdisf, a.RHAvcomp, a.IEid, a.TEid, a.Mcodigo, a.Indicador_de_Negociado,
				   c.RHLTPid, r.RHTcomportam
			from RHAcciones a
				inner join RHPlazas b
					on b.RHPid = a.RHPid
				inner join RHLineaTiempoPlaza c
					on c.RHPPid = b.RHPPid
					and c.CFidautorizado = b.CFid
					and a.DLfvigencia >= c.RHLTPfdesde
					and coalesce(a.DLffin, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#CreateDate(6100, 01, 01)#">) <= c.RHLTPfhasta
					and c.RHMPestadoplaza = 'A'
				inner join RHTipoAccion r
					on r.RHTid = a.RHTid
			where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
		</cfquery>
	
		<cfif rsAccionCfg.recordCount EQ 0>
			<cfset error = "La plaza se encuentra inactiva o congelada o no está presupuestada para el tiempo que se está estableciendo en la acción de personal">
			<cfreturn error>
		</cfif>
		<cfif Len(Trim(rsAccionCfg.EcodigoRef))>
			<cfset LvarEmpresa = rsAccionCfg.EcodigoRef>
		</cfif>
		
		<!--- 
			Validacion de que todos los componentes salariales dentro de la accion se encuentren dentro de lo presupuestado en la linea del tiempo de la plaza
			Esto se cumple unicamente si la acción no es de tipo CESE
		 --->
		<cfif rsAccionCfg.RHTcomportam NEQ 2>
			<cfquery name="rsComponentes" datasource="#Arguments.conexion#">
				select rtrim(c.CScodigo) #LvarCNCT# ' - ' #LvarCNCT# c.CSdescripcion as Comp,a.CSid
				from RHDAcciones a
					inner join ComponentesSalariales c
						on c.CSid = a.CSid
				where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
				and not exists (
					select 1
					from RHCLTPlaza x
					where x.RHLTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccionCfg.RHLTPid#">
					and x.CSid = a.CSid
					and x.Monto >= a.RHDAmontores
				)
			</cfquery>
			
			<cfif rsComponentes.recordCount>
				<cfset error = "Los siguientes componentes salariales no están presupuestados para la plaza o sobrepasan el monto asignado para ellos: " & ValueList(rsComponentes.Comp, ',')>
				<cfreturn error>
			</cfif>
		</cfif>
		
		<!--- Averiguar si usa estructura salarial --->
		<cfquery name="rsEstructura" datasource="#Arguments.conexion#">
			select CSusatabla
			from ComponentesSalariales
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
			and CSsalariobase = 1
		</cfquery>
		<cfset usaEstructuraSalarial = (rsEstructura.CSusatabla EQ 1)>

		<!--- Si usa estructura salarial y el salario es negociado validar que los montos de los componentes enten dentro del rango configurado --->
		<cfif usaEstructuraSalarial and rsAccionCfg.Indicador_de_Negociado EQ 1>
			<!--- Siempre y cuando no sea una acción de cese --->
			<cfif rsAccionCfg.RHTcomportam NEQ 2>
				<cfquery name="rsComponentes2" datasource="#Arguments.conexion#">
					select rtrim(c.CScodigo) #LvarCNCT# ' - ' #LvarCNCT# c.CSdescripcion as Comp
					from RHDAcciones a
						inner join ComponentesSalariales c
							on c.CSid = a.CSid
					where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RHAlinea#">
					and exists (
						select 1
						from ComponentesSalariales s
							inner join RHMetodosCalculo t
								on t.CSid = s.CSid
								and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsAccionCfg.DLfvigencia#"> between t.RHMCfecharige and t.RHMCfechahasta
								and t.RHMCestadometodo = 1
								and (t.RHMCcomportamiento = 1 or t.RHMCcomportamiento = 3)
							inner join RHMontosCategoria u
								on u.RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccionCfg.RHCPlinea#">
								and u.CSid = s.CSid
								and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsAccionCfg.DLfvigencia#"> between u.RHVTfrige and u.RHVTfhasta
								and not a.RHDAmontores between u.RHMCmontomin and u.RHMCmontomax
						where s.CSid = a.CSid
						and s.CSusatabla = 1
					)
				</cfquery>
				<cfif rsComponentes.recordCount>
					<cfset error = "El monto de los siguientes componentes salariales no se encuentra dentro del rango de negociación permitido: " & ValueList(rsComponentes2.Comp, ',') & ". Revisar los montos mínimos y máximos permitidos en la escala salarial vigente utilizada.">
					<cfreturn error>
				</cfif>
			</cfif>
			
		</cfif>
		
		<cfreturn error>
	</cffunction>

</cfcomponent>
