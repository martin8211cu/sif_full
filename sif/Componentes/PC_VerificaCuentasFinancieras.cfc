<cfcomponent>
	<cfset LvarERRs = "">
	<cffunction name="VerificaINTARC" access="public" returntype="string" output="false">
		<!--- RESULTADO es 'OK', o cualquier otra cosa es ERROR --->
		<cfargument name="Efecha" 			type="date" 	required="yes">
		<cfargument name="MaxErrors" 		type="numeric"	default="20">
		<cfargument name="TypeError" 		type="string"	default="html">
		<cfargument name="datasource" 		type="string"	default="">
		<cfargument name="NoVerificarObras"	type="boolean" 	default="no">
		<cfargument name="Verificar_CFid"	type="numeric" 	default="-1">
				
		<cfif Arguments.datasource EQ "">
			<cfset Arguments.datasource = session.dsn>
		</cfif>
		
		<cfquery datasource="#Arguments.datasource#">
			update #request.intarc#
			   set CFcuenta =
						(
							select min(cf.CFcuenta) 
							  from CFinanciera cf
							 where cf.Ccuenta = #request.intarc#.Ccuenta
						)
			 where #request.intarc#.CFcuenta IS NULL
		</cfquery>

		<cfif Arguments.Verificar_CFid NEQ -1>
			<cfquery name="rsEmp" datasource="#Arguments.datasource#">
				select distinct cf.Ecodigo, e.Edescripcion
				  from #request.intarc# i
					inner join CFinanciera cf 	
					   on cf.CFcuenta = i.CFcuenta
					inner join Empresas e
					   on e.Ecodigo = cf.Ecodigo
			</cfquery>

			<cfquery name="rsOfi" datasource="#Arguments.datasource#">
				select distinct o.Ocodigo, o.Oficodigo, o.Odescripcion
				  from #request.intarc# i
					inner join CFinanciera cf 	
					   on cf.CFcuenta = i.CFcuenta
					inner join Oficinas o
					   on o.Ecodigo = cf.Ecodigo
					  and o.Ocodigo = i.Ocodigo
			</cfquery>

			<cfquery name="rsSQL" datasource="#Arguments.datasource#">
				select cf.Ecodigo, cf.CFcodigo, cf.CFdescripcion, cf.Ocodigo
				  from CFuncional cf		
				 where o.CFid = #Arguments.Verificar_CFid#
			</cfquery>

			<cfif rsSQL.Ecodigo EQ "">
				<cfset LvarERRs = "<1><2>VerificaINTARC<3>No existe el Centro Funcional CFid=[#Arguments.Verificar_CFid#]<4>">
			<cfelseif rsEmp.RecordCount GT 1>
				<cfset LvarERRs = "<1><2>VerificaINTARC<3>No se permite verificar Máscaras por Centro Funcional de un conjunto de Cuentas Intercompany<4>">
			<cfelseif rsSQL.Ecodigo NEQ rsEmp.Ecodigo>
				<cfset LvarERRs = "<1><2>VerificaINTARC<3>El Centro Funcional '#trim(rsSQL.CFcodigo)#-#rsSQL.CFdescripcion#' CFid=[#Arguments.Verificar_CFid#] no pertenece a la Empresa='#rsEmp.Edescripcion#'<4>">
			<cfelseif rsOfi.RecordCount GT 1>
				<cfset LvarERRs = "<1><2>VerificaINTARC<3>No se permite verificar Máscaras por Centro Funcional de un conjunto de Cuentas con más de una Oficina<4>">
			<cfelseif rsSQL.Ocodigo NEQ rsOfi.Ocodigo>
				<cfset LvarERRs = "<1><2>VerificaINTARC<3>El Centro Funcional '#trim(rsSQL.CFcodigo)#-#rsSQL.CFdescripcion#' CFid=[#Arguments.Verificar_CFid#] no pertenece a la Oficina='#rsOfi.Oficodigo#-#rsOfi.Odescripcion#'<4>">
			</cfif>

			<cfif LvarERRs NEQ "">
				<cfreturn fnArmaRetorno(Arguments.typeError, 2, "", false)>
			</cfif>
		</cfif>

		<cfreturn VerificacionCtasMasiva(request.intarc, Arguments.Efecha, Arguments.MaxErrors, Arguments.TypeError, 2, true, Arguments.datasource, Arguments.NoVerificarObras, Arguments.Verificar_CFid)>
	</cffunction>

	<cffunction name="VerificaCFcuenta" access="public" returntype="string" output="false">
		<!--- RESULTADO es 'OK', o cualquier otra cosa es ERROR --->
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">
		<cfargument name="CFcuenta" 		type="numeric" 	required="yes">
		<cfargument name="Ocodigo" 			type="numeric" 	required="yes">
		<cfargument name="Efecha" 			type="date" 	required="yes">
		<cfargument name="TypeError" 		type="string"	default="html">
		<cfargument name="datasource" 		type="string"	default="">
		<cfargument name="NoVerificarObras"	type="boolean" 	default="no">
		<cfargument name="Verificar_CFid"	type="numeric" 	default="-1">
		
		<cfif Arguments.datasource EQ "">
			<cfset Arguments.datasource = session.dsn>
		</cfif>
		
		<cfif lcase(arguments.TypeError) EQ "table">
			<cfset LvarTypeCtas = 0>
		<cfelse>
			<cfset LvarTypeCtas = 1>
		</cfif>
					
		<cfquery name="rsEmp" datasource="#Arguments.datasource#">
			select e.Ecodigo, e.Edescripcion, cf.CFcuenta, cf.Ecodigo as CF_Ecodigo, cf.CFformato
			  from Empresas e
				 left join CFinanciera cf 	
				   on cf.CFcuenta	= #Arguments.CFcuenta#
			 where e.Ecodigo = #Arguments.Ecodigo#
		</cfquery>
		<cfquery name="rsOfi" datasource="#Arguments.datasource#">
			select o.Ocodigo, o.Oficodigo, o.Odescripcion
			  from Oficinas o
			 where o.Ecodigo = #Arguments.Ecodigo#
			   and o.Ocodigo = #Arguments.Ocodigo#
		</cfquery>

		<cfset LvarERRs = "">
		<cfif rsEmp.Ecodigo EQ "">
			<cfset LvarERRs = "<1>#rtrim(rsEmp.CFformato)#<2>VerificaCFcuenta<3>No existe la Empresa Ecodigo=[#Arguments.Ecodigo#]">
		<cfelseif rsEmp.CF_Ecodigo EQ "">
			<cfset LvarERRs = "<1>#rtrim(rsEmp.CFformato)#<2>VerificaCFcuenta<3>No existe la Cuenta Financiera CFcuenta=[#Arguments.CFcuenta#]<4>">
		<cfelseif rsEmp.CF_Ecodigo NEQ rsEmp.Ecodigo>
			<cfset LvarERRs = "<1>#rtrim(rsEmp.CFformato)#<2>VerificaCFcuenta<3>La Cuenta Financiera CFcuenta=[#Arguments.CFcuenta#] no pertenece a la Empresa='#rsEmp.Edescripcion#'<4>">
		<cfelseif Arguments.Ocodigo NEQ -1 AND rsOfi.recordCount EQ 0>
			<cfset LvarERRs = "<1>#rtrim(rsEmp.CFformato)#<2>VerificaCFcuenta<3>La Oficina Ocodigo=[#Arguments.Ocodigo#] no pertenece a la Empresa='#rsEmp.Edescripcion#'<4>">
		</cfif>
		
		<cfif Arguments.Verificar_CFid NEQ -1>
			<cfquery name="rsSQL" datasource="#Arguments.datasource#">
				select cf.Ecodigo, cf.CFcodigo, cf.CFdescripcion, cf.Ocodigo
				  from CFuncional cf		
				 where cf.CFid = #Arguments.Verificar_CFid#
			</cfquery>

			<cfif rsSQL.Ecodigo EQ "">
				<cfset LvarERRs = "<1>#rtrim(rsEmp.CFformato)#<2>VerificaCFcuenta<3>No existe el Centro Funcional CFid=[#Arguments.Verificar_CFid#]<4>">
			<cfelseif rsSQL.Ecodigo NEQ rsEmp.Ecodigo>
				<cfset LvarERRs = "<1>#rtrim(rsEmp.CFformato)#<2>VerificaCFcuenta<3>El Centro Funcional '#trim(rsSQL.CFcodigo)#-#rsSQL.CFdescripcion#' CFid=[#Arguments.Verificar_CFid#] no pertenece a la Empresa='#rsEmp.Edescripcion#'<4>">
			<cfelseif Arguments.Ocodigo NEQ -1 AND Arguments.Ocodigo NEQ rsSQL.Ocodigo>
				<cfset LvarERRs = "<1>#rtrim(rsEmp.CFformato)#<2>VerificaCFcuenta<3>El Centro Funcional '#trim(rsSQL.CFcodigo)#-#rsSQL.CFdescripcion#' CFid=[#Arguments.Verificar_CFid#] no pertenece a la Oficina='#rsOfi.Oficodigo#-#rsOfi.Odescripcion#'<4>">
			<cfelse>
				<!--- OJO: Utiliza el Ocodigo del Centro Funcional --->
				<cfset LvarERRs = VerificacionCtasMasiva("(select #Arguments.CFcuenta# as CFcuenta, #rsSQL.Ocodigo# as Ocodigo from dual)", Arguments.Efecha, Arguments.MaxErrors, Arguments.typeError, LvarTypeCtas, false, Arguments.datasource, Arguments.NoVerificarObras, Arguments.Verificar_CFid)>
			</cfif>
			<cfif LvarERRs NEQ "">
				<cfset LvarERRs = fnArmaRetorno(Arguments.typeError, LvarTypeCtas, "", false)>
			<cfelse>
				<cfset LvarERRs = VerificacionCtasMasiva("(select #Arguments.CFcuenta# as CFcuenta, #rsSQL.Ocodigo# as Ocodigo from dual)", Arguments.Efecha, Arguments.MaxErrors, Arguments.typeError, LvarTypeCtas, false, Arguments.datasource, Arguments.NoVerificarObras, Arguments.Verificar_CFid)>
			</cfif>
		<cfelse>
			<cfif LvarERRs NEQ "">
				<cfset LvarERRs = fnArmaRetorno(Arguments.typeError, LvarTypeCtas, "", false)>
			<cfelse>
				<cfset LvarERRs = VerificacionCtasMasiva("(select #Arguments.CFcuenta# as CFcuenta, #Arguments.Ocodigo# as Ocodigo from dual)", Arguments.Efecha, Arguments.MaxErrors, Arguments.typeError, LvarTypeCtas, false, Arguments.datasource, Arguments.NoVerificarObras, Arguments.Verificar_CFid)>
			</cfif>
		</cfif>

		<cfreturn LvarERRs>
	</cffunction>
	
	<cffunction name="VerificaCFformato" access="public" returntype="string" output="false">
		<!--- RESULTADO es 'OK', o cualquier otra cosa es ERROR --->
		<cfargument name="Ecodigo" 			type="numeric" 	required="yes">
		<cfargument name="CFformato" 		type="string" 	required="yes">
		<cfargument name="Ocodigo" 			type="numeric" 	required="yes">
		<cfargument name="Efecha" 			type="date" 	required="yes">
		<cfargument name="TypeError" 		type="string"	default="html">
		<cfargument name="datasource" 		type="string"	default="">
		<cfargument name="NoVerificarPres"	type="boolean" 	default="true">
		<cfargument name="NoVerificarObras"	type="boolean" 	default="false">
		<cfargument name="Verificar_CFid"	type="numeric" 	default="-1">
		
		<cfif Arguments.datasource EQ "">
			<cfset Arguments.datasource = session.dsn>
		</cfif>
		
		<cfset Arguments.TypeError = lcase(Arguments.TypeError)>
		<cfif NOT listFind("html,js",Arguments.TypeError)>
			<cf_errorCode	code = "51254" msg = "El atributo TypeError solo puede ser: html,js">
		</cfif>

		<cfinvoke 	 component="sif.Componentes.PC_GeneraCuentaFinanciera"
					 method="fnVerificaCFformato"
					 returnvariable="LvarERRs">
			<cfinvokeargument name="Lprm_Ecodigo" 				value="#arguments.Ecodigo#"/>
			<cfinvokeargument name="Lprm_CFformato"				value="#trim(Arguments.CFformato)#"/>
			<cfinvokeargument name="Lprm_Fecha" 				value="#arguments.Efecha#"/>
			<cfinvokeargument name="Lprm_Ocodigo" 				value="#arguments.Ocodigo#"/>

			<cfinvokeargument name="Lprm_VerificarExistencia"	value="false"/>
			<cfinvokeargument name="Lprm_NoVerificarPres"		value="#arguments.NoVerificarPres#"/>
			<cfinvokeargument name="Lprm_NoVerificarObras" 		value="#arguments.NoVerificarObras#"/>
			<cfinvokeargument name="Lprm_Verificar_CFid" 		value="#arguments.Verificar_CFid#"/>

			<cfinvokeargument name="Lprm_DSN"	 				value="#arguments.datasource#"/>
		</cfinvoke>
		
		<cfif LvarERRs EQ "NEW" or LvarERRs EQ "OLD">
			<cfreturn "OK">
		<cfelseif Arguments.TypeError EQ "js">
			<cfreturn fnJSStringFormat(LvarERRs)>
		<cfelse>
			<cfreturn LvarERRs>
		</cfif>
	</cffunction>
	
	<cffunction name="VerificacionCtasMasiva" access="private" returntype="string">
		<!--- RESULTADO es 'OK', o cualquier otra cosa es ERROR --->
		<cfargument name="Tabla" 			type="string"	required="yes">
		<cfargument name="Efecha" 			type="date" 	required="yes">
		<cfargument name="MaxErrors" 		type="numeric"	required="yes">
		<cfargument name="TypeError" 		type="string"	required="yes">
		<cfargument name="TypeCtas" 		type="numeric"	required="yes">	<!--- 0 = 1 cta parcial, 1 = una cta, 2 = N ctas --->
		<cfargument name="unErrorXCuenta" 	type="boolean"	required="yes">
		<cfargument name="datasource" 		type="string"	required="yes">
		<cfargument name="NoVerificarObras"	type="boolean" 	required="yes">
		<cfargument name="Verificar_CFid"	type="numeric" 	required="yes">
		
		<cfset var LvarFecha = createODBCdate(Arguments.Efecha)>

		<cfset Arguments.TypeError = lcase(Arguments.TypeError)>
		<cfif NOT listFind("html,htmlbr,table,js",Arguments.TypeError)>
			<cf_errorCode	code = "51255" msg = "El atributo TypeError solo puede ser: html,htmlBR,table,js">
		</cfif>
		
		<cfif Arguments.TypeError NEQ "table" AND Arguments.TypeCtas EQ 2 AND (Arguments.MaxErrors EQ 0 OR Arguments.MaxErrors GT 20)>
			<cf_errorCode	code = "51256" msg = "El atributo MaxErrors debe ser menor que 20 cuando no es TypeError='table'">
		</cfif>
		
		<cfset LvarIdx = 0>
		<cfset LvarERRs = "">
		<cfset LvarCtas = "">
		<cfset LvarCFcuentaAnt = "">

		<!--- VERIFICACION DE CONTROL DE VIGENCIA Y OFICINA --->

		<!--- Cambio en la validación.  Se presentaron problemas en la consulta para la versión 15.0.1 de Sybase --->
		<cfquery name="rsSQL" datasource="#Arguments.datasource#">
			select  coalesce(ctas.CFcuenta, -1) as CFcuenta, ctas.Ocodigo as Ocodigo, '** N/A **' as CFformato, <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as CPVid, <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as Ecodigo,  1 as Orden
			from #Arguments.Tabla# ctas
			where ctas.CFcuenta is null
	
			union 

			select  ctas.CFcuenta as CFcuenta, ctas.Ocodigo as Ocodigo, cf.CFformato as CFformato, <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as CPVid, <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as Ecodigo, 2 as Orden
			from #Arguments.Tabla# ctas
				inner join CFinanciera cf
				on cf.CFcuenta = ctas.CFcuenta
			where ctas.CFcuenta is not null
			  and not exists(
			  		select 1
					from CPVigencia v
					where v.Ecodigo	= cf.Ecodigo
					  and v.Cmayor	= cf.Cmayor
					  and #dateformat(Lvarfecha,"YYYYMM")# between v.CPVdesdeAnoMes and v.CPVhastaAnoMes
					  )
					  
			union

			select  ctas.CFcuenta as CFcuenta, ctas.Ocodigo as Ocodigo, cf.CFformato as CFformato, -1 as CPVid, <CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as Ecodigo,  3 as Orden
			from #Arguments.Tabla# ctas
				inner join CFinanciera cf
				on cf.CFcuenta = ctas.CFcuenta
			where ctas.CFcuenta is not null
			  and not exists(
			  		select 1
					from Oficinas o
					where o.Ecodigo	= cf.Ecodigo
					  and o.Ocodigo	= ctas.Ocodigo
					)			
			order by CFcuenta, Orden
		</cfquery>
		
		<cfset LvarCFcuenta = "*">
		<cfloop query="rsSQL">
			<cfif LvarCFcuenta NEQ rsSQL.CFcuenta & "," & rsSQL.Ocodigo>
				<cfif Arguments.UnErrorXCuenta>
					<cfset LvarCtas = listAppend(LvarCtas, rsSQL.CFcuenta)>
				</cfif>

				<cfset LvarCFcuenta = rsSQL.CFcuenta & "," & rsSQL.Ocodigo>

				<cfset LvarIdx = LvarIdx + 1>
				<cfif Arguments.MaxErrors NEQ 0 AND LvarIdx GT Arguments.MaxErrors>
					<cfreturn fnArmaRetorno(Arguments.typeError, Arguments.TypeCtas, rsSQL.CFformato, true)>
				</cfif>

				<cfif LvarCFcuentaAnt EQ rsSQL.CFcuenta OR Arguments.TypeCtas EQ 1>
					<cfset LvarCFformato = "">
				<cfelse>
					<cfset LvarCFformato = rsSQL.CFformato>
				</cfif>
				<cfset LvarCFcuentaAnt = rsSQL.CFcuenta>
				<cfset LvarERRs = LvarERRs & "<1>#trim(LvarCFformato)#<2>Control de Vigencia<3>">
				
				<cfif rsSQL.CFformato EQ "** N/A **">
					<cfset LvarERRs = LvarERRs & "No existe la Cuenta CFcuenta=[#rsSQL.CFcuenta#]<4>">
				<cfelseif rsSQL.CPVid EQ "">
					<cfset LvarERRs = LvarERRs & "Cuenta no está vigente para el #dateFormat(LvarFecha,"dd/mm/yyyy")#<4>">
				<cfelseif rsSQL.Ecodigo EQ "">
					<cfset LvarERRs = LvarERRs & "La Oficina Ocodigo=[#rsSQL.Ocodigo#] no pertenece a la Empresa de la Cuenta<4>">
				</cfif>
			</cfif>
		</cfloop>
		<cfif LvarERRs NEQ "" AND Arguments.UnErrorXCuenta AND Arguments.TypeCtas NEQ 2>
			<cfreturn fnArmaRetorno(Arguments.typeError, Arguments.TypeCtas, rsSQL.CFformato, false)>
		</cfif>

		<!--- VERIFICACION DE CONTROL DE OBRAS --->
		<cfif NOT Arguments.NoVerificarObras>
			<cfquery name="rsSQL" datasource="#Arguments.datasource#">
				select 	  CFcuenta, CFformato, Oficodigo
						, EC_CFformato
						, OBPcodigo
						, OBOcodigo, 	OBOestado
						, Oficinas, 	Etapas,		Activas
				  from (
						select cf.CFcuenta, cf.CFformato, ofi.Oficodigo
							, coalesce(ec.CFformato,'*') as EC_CFformato
							, p.OBPcodigo
							, o.OBOcodigo, o.OBOestado
							, count (case when e.Ocodigo = ctas.Ocodigo then 1 end) Oficinas
							, count (case when e.Ocodigo = ctas.Ocodigo AND e.OBEestado='1' then 1 end) Etapas
							, count (case when e.Ocodigo = ctas.Ocodigo AND e.OBEestado='1' AND ec.OBECestado='1' then 1 end) Activas
						  from #Arguments.Tabla# ctas
							inner join CFinanciera cf 
								inner join OBctasMayor om
								   on om.Ecodigo			= cf.Ecodigo
								  and om.Cmayor				= cf.Cmayor
								  and om.OBCcontrolCuentas	= 1
							   on cf.CFcuenta = ctas.CFcuenta
							inner join Oficinas ofi
							   on ofi.Ecodigo = cf.Ecodigo
							  and ofi.Ocodigo = ctas.Ocodigo
							 left join OBetapaCuentas ec
								inner join OBetapa e
									inner join OBobra o
										inner join OBproyecto p
										   on p.OBPid = o.OBPid
									   on o.OBOid = e.OBOid
									  and o.OBOestado <> '0'
								   on e.OBEid = ec.OBEid
							   on ec.Ecodigo	= cf.Ecodigo
							  and ec.CFformato	= cf.CFformato
							  and ec.OBECestado	<> '0'
							group by  cf.CFcuenta, cf.CFformato, ofi.Oficodigo
									, coalesce(ec.CFformato,'*')
									, p.OBPcodigo
									, o.OBOcodigo, o.OBOestado
						) rsSQL
					 where EC_CFformato = '*'
						OR OBOestado 	<> '1'
						OR Oficinas		= 0
						OR Etapas		= 0
						OR Activas		= 0
					 order by EC_CFformato
			</cfquery>
	
			<cfset LvarCFcuenta = "*">
			<cfloop query="rsSQL">
				<cfif LvarCFcuenta NEQ rsSQL.CFcuenta>
					<cfif Arguments.UnErrorXCuenta>
						<cfset LvarCtas = listAppend(LvarCtas, rsSQL.CFcuenta)>
					</cfif>

					<cfset LvarCFcuenta = rsSQL.CFcuenta>
	
					<cfset LvarIdx = LvarIdx + 1>
					<cfif Arguments.MaxErrors NEQ 0 AND LvarIdx GT Arguments.MaxErrors>
						<cfreturn fnArmaRetorno(Arguments.typeError, Arguments.TypeCtas, rsSQL.CFformato, true)>
					</cfif>
		
					<cfif LvarCFcuentaAnt EQ rsSQL.CFcuenta OR Arguments.TypeCtas EQ 1>
						<cfset LvarCFformato = "">
					<cfelse>
						<cfset LvarCFformato = rsSQL.CFformato>
					</cfif>
					<cfset LvarCFcuentaAnt = rsSQL.CFcuenta>
					<cfset LvarERRs = LvarERRs & "<1>#trim(LvarCFformato)#<2>Control de Obras<3>">
					
					<cfif rsSQL.EC_CFformato EQ "*">
						<cfset LvarERRs = LvarERRs & "Cuenta no ha sido registrada o generada en Obras<4>">
					<cfelseif rsSQL.OBOestado EQ "3">
						<cfset LvarERRs = LvarERRs & "Proyecto='#trim(rsSQL.OBPcodigo)#', Obra='#trim(rsSQL.OBOcodigo)#', Obra liquidada<4>">
					<cfelseif rsSQL.OBOestado NEQ "1">
						<cfset LvarERRs = LvarERRs & "Proyecto='#trim(rsSQL.OBPcodigo)#', Obra='#trim(rsSQL.OBOcodigo)#', Obra inactiva<4>">
					<cfelseif rsSQL.Oficinas EQ 0>
						<cfset LvarERRs = LvarERRs & "Proyecto='#trim(rsSQL.OBPcodigo)#', Obra='#trim(rsSQL.OBOcodigo)#', Cuenta no asignada a Oficina='#trim(rsSQL.Oficodigo)#'<4>">
					<cfelseif rsSQL.Etapas EQ 0>
						<cfset LvarERRs = LvarERRs & "Proyecto='#trim(rsSQL.OBPcodigo)#', Obra='#trim(rsSQL.OBOcodigo)#', Etapas inactivas para Oficina='#trim(rsSQL.Oficodigo)#'<4>">
					<cfelseif rsSQL.Activas EQ 0>
						<cfset LvarERRs = LvarERRs & "Proyecto='#trim(rsSQL.OBPcodigo)#', Obra='#trim(rsSQL.OBOcodigo)#', Cuenta inactiva<4>">
					</cfif>
				</cfif>
			</cfloop>
			<cfif LvarERRs NEQ "" AND Arguments.UnErrorXCuenta AND Arguments.TypeCtas NEQ 2>
				<cfreturn fnArmaRetorno(Arguments.typeError, Arguments.TypeCtas, rsSQL.CFformato, false)>
			</cfif>
		</cfif>

		<!--- VERIFICACION DE CONTROL DE CUENTAS INACTIVAS --->
		<cfquery name="rsSQL" datasource="#Arguments.datasource#">
			<!--- Cuentas Financieras --->
			SELECT 'F' as tipo, cf.CFcuenta, cf.CFformato, ci.CFformato as FormatoI, i.CFIdesde as desde, i.CFIhasta as hasta
			  from #Arguments.Tabla# ctas
				inner join CFinanciera cf
					inner join PCDCatalogoCuentaF cubo
						inner join CFInactivas i
							inner join CFinanciera ci
							   on ci.CFcuenta = i.CFcuenta
						   on  i.CFcuenta = cubo.CFcuentaniv
						  and <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFecha#"> between i.CFIdesde and i.CFIhasta			
					   on cubo.CFcuenta = cf.CFcuenta
				   on cf.CFcuenta = ctas.CFcuenta
			   and NOT <CF_whereInList column="ctas.CFcuenta" valueList="#LvarCtas#">
			UNION
			<!--- Cuentas Contables --->
			Select 'C' as tipo, cf.CFcuenta, cf.CFformato, ci.Cformato as FormatoI, i.CCIdesde as desde, i.CCIhasta as hasta
			  from #Arguments.Tabla# ctas
				inner join CFinanciera cf
					inner join CContables cc
						inner join PCDCatalogoCuenta cubo
							inner join CCInactivas i
								inner join CContables ci
								   on ci.Ccuenta = i.Ccuenta
					 		   on i.Ccuenta = cubo.Ccuentaniv
							  and <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFecha#"> between i.CCIdesde and i.CCIhasta
						   on cubo.Ccuenta = cc.Ccuenta
					   on cc.Ccuenta = cf.Ccuenta
				   on cf.CFcuenta = ctas.CFcuenta
			   and NOT <CF_whereInList column="ctas.CFcuenta" valueList="#LvarCtas#">
			UNION
			<!--- Cuentas de Presupuesto --->
			Select 'P' as tipo, cf.CFcuenta, cf.CFformato, ci.CPformato as FormatoI, i.CPIdesde as desde, i.CPIhasta as hasta
			  from #Arguments.Tabla# ctas
				inner join CFinanciera cf
					inner join CPresupuesto cp
						inner join PCDCatalogoCuentaP cubo
							inner join CPInactivas i
								inner join CPresupuesto ci
								   on ci.CPcuenta = i.CPcuenta
							   on i.CPcuenta = cubo.CPcuentaniv
							  and <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFecha#"> between i.CPIdesde and i.CPIhasta
						   on cubo.CPcuenta = cp.CPcuenta
					   on cp.CPcuenta = cf.CPcuenta
				   on cf.CFcuenta	= ctas.CFcuenta
			   and NOT <CF_whereInList column="ctas.CFcuenta" valueList="#LvarCtas#">
			 ORDER BY 3
		</cfquery>

		<cfset LvarCFcuenta = "*">
		<cfloop query="rsSQL">
			<cfif LvarCFcuenta NEQ rsSQL.CFcuenta>
				<cfif Arguments.UnErrorXCuenta>
					<cfset LvarCtas = listAppend(LvarCtas, rsSQL.CFcuenta)>
				</cfif>

				<cfset LvarCFcuenta = rsSQL.CFcuenta>

				<cfset LvarIdx = LvarIdx + 1>
				<cfif Arguments.MaxErrors NEQ 0 AND LvarIdx GT Arguments.MaxErrors>
					<cfreturn fnArmaRetorno(Arguments.typeError, Arguments.TypeCtas, rsSQL.CFformato, true)>
				</cfif>
	
				<cfif LvarCFcuentaAnt EQ rsSQL.CFcuenta OR Arguments.TypeCtas EQ 1>
					<cfset LvarCFformato = "">
				<cfelse>
					<cfset LvarCFformato = rsSQL.CFformato>
				</cfif>
				<cfset LvarCFcuentaAnt = rsSQL.CFcuenta>
				<cfset LvarERRs = LvarERRs & "<1>#trim(LvarCFformato)#<2>Control de Cuentas Inactivas<3>">

				<cfif rsSQL.Tipo EQ "F">
					<cfset LvarERRs = LvarERRs & "Cuenta Financiera ">
					<cfif rsSQL.CFformato NEQ rsSQL.FormatoI>
						<cfset LvarERRs = LvarERRs & "'#trim(rsSQL.FormatoI)#' ">
					</cfif>
				<cfelseif rsSQL.Tipo EQ "C">
					<cfset LvarERRs = LvarERRs & "Cuenta Contable ">
					<cfif rsSQL.CFformato NEQ rsSQL.FormatoI>
						<cfset LvarERRs = LvarERRs & "'#trim(rsSQL.FormatoI)#' ">
					</cfif>
				<cfelse>
					<cfset LvarERRs = LvarERRs & "Cuenta de Presupuesto ">
					<cfif rsSQL.CFformato NEQ rsSQL.FormatoI>
						<cfset LvarERRs = LvarERRs & "'#trim(rsSQL.FormatoI)#' ">
					</cfif>
				</cfif>
				<cfset LvarERRs = LvarERRs & "Inactiva del #dateFormat(rsSQL.desde,"dd/mm/yy")# al #dateFormat(rsSQL.hasta,"dd/mm/yy")#<4>">
			</cfif>
		</cfloop>
		<cfif LvarERRs NEQ "" AND Arguments.UnErrorXCuenta AND Arguments.TypeCtas NEQ 2>
			<cfreturn fnArmaRetorno(Arguments.typeError, Arguments.TypeCtas, rsSQL.CFformato, false)>
		</cfif>
		
		<!--- VERIFICACION DE CONTROL DE PLAN DE CUENTAS --->
		<cfquery name="rsSQL" datasource="#Arguments.datasource#">
			Select cf.CFcuenta, cf.CFformato, ofi.Oficodigo
					, cubo.PCDCniv
					, dc.PCDvalor	, dc.PCDdescripcion, dc.PCDactivo
					, ec.PCEcodigo	, ec.PCEdescripcion, ec.PCEactivo
			  from #Arguments.Tabla# ctas
				inner join CFinanciera cf
					inner join PCDCatalogoCuentaF cubo
						inner join PCDCatalogo dc
							inner join PCECatalogo ec
								 on ec.PCEcatid = dc.PCEcatid
							on dc.PCDcatid = cubo.PCDcatid
						on cubo.CFcuenta = cf.CFcuenta
					 on cf.CFcuenta = ctas.CFcuenta
				inner join Oficinas ofi						 
				   on ofi.Ecodigo	= cf.Ecodigo
				  and ofi.Ocodigo	= ctas.Ocodigo
			where (
					  ec.PCEactivo = 0
				   OR dc.PCDactivo = 0
				   OR (
							ec.PCEempresa = 1
						and ec.PCEoficina = 1
						and not exists
							(
								select 1 
								  from PCDCatalogoValOficina vo
								 where vo.PCDcatid = cubo.PCDcatid
								   and vo.Ecodigo  = ofi.Ecodigo
								   and vo.Ocodigo  = ofi.Ocodigo
							)
					   )
				   )
			   and NOT <CF_whereInList column="ctas.CFcuenta" valueList="#LvarCtas#">
			 order by cf.CFformato
		</cfquery>			

		<cfset LvarCFcuenta = "*">
		<cfloop query="rsSQL">
			<cfif LvarCFcuenta NEQ rsSQL.CFcuenta>
				<cfif Arguments.UnErrorXCuenta>
					<cfset LvarCtas = listAppend(LvarCtas, rsSQL.CFcuenta)>
				</cfif>

				<cfset LvarCFcuenta = rsSQL.CFcuenta>

				<cfset LvarIdx = LvarIdx + 1>
				<cfif Arguments.MaxErrors NEQ 0 AND LvarIdx GT Arguments.MaxErrors>
					<cfreturn fnArmaRetorno(Arguments.typeError, Arguments.TypeCtas, rsSQL.CFformato, true)>
				</cfif>
	
				<cfif LvarCFcuentaAnt EQ rsSQL.CFcuenta OR Arguments.TypeCtas EQ 1>
					<cfset LvarCFformato = "">
				<cfelse>
					<cfset LvarCFformato = rsSQL.CFformato>
				</cfif>
				<cfset LvarCFcuentaAnt = rsSQL.CFcuenta>
				<cfset LvarERRs = LvarERRs & "<1>#trim(LvarCFformato)#<2>Control de Plan de Cuentas<3>">

				<cfset LvarERRs = LvarERRs & "Nivel=#trim(rsSQL.PCDCniv)#, Valor='#trim(rsSQL.PCDvalor)#-#trim(rsSQL.PCDdescripcion)#', Catálogo='#trim(rsSQL.PCEcodigo)#-#trim(rsSQL.PCEdescripcion)#', ">

				<cfif rsSQL.PCEactivo EQ "0">
					<cfset LvarERRs = LvarERRs & "Catálogo Inactivo<4>">
				<cfelseif rsSQL.PCDactivo EQ "0">
					<cfset LvarERRs = LvarERRs & "Valor Inactivo<4>">
				<cfelse>
					<cfset LvarERRs = LvarERRs & "Valor no asignado a Oficina='#trim(rsSQL.Oficodigo)#'<4>">
				</cfif>
			</cfif>
		</cfloop>
		<cfif LvarERRs NEQ "" AND Arguments.UnErrorXCuenta AND Arguments.TypeCtas NEQ 2>
			<cfreturn fnArmaRetorno(Arguments.typeError, Arguments.TypeCtas, rsSQL.CFformato, false)>
		</cfif>
		
		<!--- VERIFICACION DE CONTROL DE REGLAS FINANCIERAS --->
		<cfquery name="rsSQL" datasource="#Arguments.datasource#" maxrows="20"> 
			SELECT distinct 'I' as Tipo, cf.CFcuenta, cf.CFformato, ofi.Oficodigo
			  from #Arguments.Tabla# ctas
				inner join CFinanciera cf
				   on cf.CFcuenta	= ctas.CFcuenta
				inner join Oficinas ofi
				   on ofi.Ecodigo		= cf.Ecodigo
				  and ofi.Ocodigo		= ctas.Ocodigo
			 where exists
				(	
					select 1 
					  from PCReglas R
					 where R.PCRref is null
					   and R.PCRvalida  = 1
					   and R.Cmayor 	= cf.Cmayor
					   and R.Ecodigo 	= cf.Ecodigo
					   <!---
					   and R.PCEMid 	= 		#Lvar_MascaraID#
					   --->
                       and <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFecha#"> between R.PCRdesde and R.PCRhasta
					   and not exists
							(
								select 1 
								  from PCReglas  RI
								 where RI.PCRref is null
								   and RI.PCRvalida 	= 1
								   and RI.Cmayor 		= cf.Cmayor
								   and RI.Ecodigo 		= cf.Ecodigo
								   <!---
								   and RI.PCEMid 			=		#Lvar_MascaraID#
								   --->
								   and <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFecha#"> between RI.PCRdesde and RI.PCRhasta
									and	<cf_dbfunction name="like" args="cf.CFformato,RI.PCRregla">
									and <cf_dbfunction name="like" args="ofi.Oficodigo;coalesce(RI.OficodigoM, '%')" delimiters=";">
								   and not exists 
										(
											select 1 
											  from PCReglas EC
											 where EC.PCRref		= RI.PCRid
											   and EC.PCRvalida		= 0
											   and <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFecha#"> between EC.PCRdesde and EC.PCRhasta 
												and	<cf_dbfunction name="like" args="cf.CFformato,EC.PCRregla">
												and <cf_dbfunction name="like" args="ofi.Oficodigo;coalesce(EC.OficodigoM, '%')" delimiters=";">
										)
							)
				)
			   and NOT <CF_whereInList column="ctas.CFcuenta" valueList="#LvarCtas#">
			UNION
			select distinct 'E' as Tipo, cf.CFcuenta, cf.CFformato, ofi.Oficodigo
			  from #Arguments.Tabla# ctas
				inner join CFinanciera cf
				   on cf.CFcuenta = ctas.CFcuenta
				inner join Oficinas ofi
				   on ofi.Ecodigo = cf.Ecodigo
				  and ofi.Ocodigo = ctas.Ocodigo
			 where exists
				(
					select 1 
					  from PCReglas  RE
					 where RE.PCRref 		is null
					   and RE.PCRvalida		= 0
					   and RE.Cmayor		= cf.Cmayor
					   and RE.Ecodigo		= cf.Ecodigo
					   <!---
					   and RE.PCEMid 			= 		#Lvar_MascaraID#
					   --->
					   and <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFecha#"> between RE.PCRdesde and RE.PCRhasta
						and	<cf_dbfunction name="like" args="cf.CFformato,RE.PCRregla">
						and <cf_dbfunction name="like" args="ofi.Oficodigo;coalesce(RE.OficodigoM, '%')" delimiters=";">
					   and not exists 
							(
								select 1 
								  from PCReglas EC
								 where EC.PCRref 		= RE.PCRid
								   and EC.PCRvalida		= 1
								   and <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#LvarFecha#"> between EC.PCRdesde and EC.PCRhasta 
									and	<cf_dbfunction name="like" args="cf.CFformato,EC.PCRregla">
							      and <cf_dbfunction name="like" args="ofi.Oficodigo;coalesce(EC.OficodigoM, '%')" delimiters=";">
							)
				)
			   and NOT <CF_whereInList column="ctas.CFcuenta" valueList="#LvarCtas#">
			 ORDER BY CFformato, Tipo desc
		</cfquery>

		<cfset LvarCFcuenta = "*">
		<cfloop query="rsSQL">
			<cfif LvarCFcuenta NEQ rsSQL.CFcuenta>
				<cfif Arguments.UnErrorXCuenta>
					<cfset LvarCtas = listAppend(LvarCtas, rsSQL.CFcuenta)>
				</cfif>

				<cfset LvarCFcuenta = rsSQL.CFcuenta>

				<cfset LvarIdx = LvarIdx + 1>
				<cfif Arguments.MaxErrors NEQ 0 AND LvarIdx GT Arguments.MaxErrors>
					<cfreturn fnArmaRetorno(Arguments.typeError, Arguments.TypeCtas, rsSQL.CFformato, true)>
				</cfif>
	
				<cfif LvarCFcuentaAnt EQ rsSQL.CFcuenta OR Arguments.TypeCtas EQ 1>
					<cfset LvarCFformato = "">
				<cfelse>
					<cfset LvarCFformato = rsSQL.CFformato>
				</cfif>
				<cfset LvarCFcuentaAnt = rsSQL.CFcuenta>
				<cfset LvarERRs = LvarERRs & "<1>#trim(LvarCFformato)#<2>Control de Reglas Financieras (Oficina='#trim(rsSQL.Oficodigo)#')<3>">

				<cfif rsSQL.Tipo EQ "I">
					<cfset LvarERRs = LvarERRs & "No cumple Regla de Inclusión<4>">
				<cfelse>
					<cfset LvarERRs = LvarERRs & "Rechazada por Regla de Exclusión<4>">
				</cfif>
			</cfif>
		</cfloop>
		<cfif LvarERRs NEQ "" AND Arguments.UnErrorXCuenta AND Arguments.TypeCtas NEQ 2>
			<cfreturn fnArmaRetorno(Arguments.typeError, Arguments.TypeCtas, rsSQL.CFformato, false)>
		</cfif>
		
		<!--- VERIFICACION DE CONTROL DE MASCARAS DE CENTRO FUNCIONAL --->
		<cfif Arguments.Verificar_CFid NEQ "-1">
			<cfquery name="rsCF" datasource="#Arguments.datasource#" >
				select 	CFcodigo, 			CFdescripcion,
						CFcuentac, 			CFcuentaaf,
						CFcuentainversion, 	CFcuentainventario,
						CFcuentaingreso, 	CFcuentagastoretaf,
						CFcuentaingresoretaf
				  from CFuncional
				 where CFid = #Arguments.Verificar_CFid#
			</cfquery>
			<cfquery name="rsSQL" datasource="#Arguments.datasource#" maxrows="20"> 
				SELECT cf.CFcuenta, cf.CFformato
				  from #Arguments.Tabla# ctas
					inner join CFinanciera cf
					   on cf.CFcuenta	= ctas.CFcuenta
				 where not exists
					(	
						select 1
						  from dual
						 where cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentac)#'
							OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentaaf)#'
							OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentainversion)#'
							OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentainventario)#'
							OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentaingreso)#'
							OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentagastoretaf)#'
							OR cf.CFformato like '#fnComodinToMascara(rsCF.CFcuentaingresoretaf)#'
					)
				 ORDER BY cf.CFformato
			</cfquery>

			<cfset LvarCFcuenta = "*">
			<cfloop query="rsSQL">
				<cfif LvarCFcuenta NEQ rsSQL.CFcuenta>
					<cfif Arguments.UnErrorXCuenta>
						<cfset LvarCtas = listAppend(LvarCtas, rsSQL.CFcuenta)>
					</cfif>
	
					<cfset LvarCFcuenta = rsSQL.CFcuenta>
			
					<cfset LvarIdx = LvarIdx + 1>
					<cfif Arguments.MaxErrors NEQ 0 AND LvarIdx GT Arguments.MaxErrors>
						<cfreturn fnArmaRetorno(Arguments.typeError, Arguments.TypeCtas, rsSQL.CFformato, true)>
					</cfif>
		
					<cfif LvarCFcuentaAnt EQ rsSQL.CFcuenta OR Arguments.TypeCtas EQ 1>
						<cfset LvarCFformato = "">
					<cfelse>
						<cfset LvarCFformato = rsSQL.CFformato>
					</cfif>
					<cfset LvarCFcuentaAnt = rsSQL.CFcuenta>
					<cfset LvarERRs = LvarERRs & "<1>#trim(LvarCFformato)#<2>Control de Centro Funcional<3>">
	
					<cfset LvarERRs = LvarERRs & "La cuenta no corresponde a las máscara del Centro Funcional='#trim(rsCF.CFcodigo)#'<4>">
				</cfif>
			</cfloop>
			<cfif LvarERRs NEQ "" AND Arguments.UnErrorXCuenta AND Arguments.TypeCtas NEQ 2>
				<cfreturn fnArmaRetorno(Arguments.typeError, Arguments.TypeCtas, rsSQL.CFformato, false)>
			</cfif>
		</cfif>

		<cfif len(LvarERRs)>
			<cfreturn fnArmaRetorno(Arguments.typeError, Arguments.TypeCtas, rsSQL.CFformato, false)>
		<cfelse>
			<cfreturn "OK">
		</cfif>		
	</cffunction>

	<cffunction name="fnComodinToMascara" access="private" output="false">
		<cfargument name="Comodin" type="string" required="yes">
	
		<cfset var LvarComodines = "?,*,!">
	
		<cfset var LvarMascara = Arguments.Comodin>
		<cfloop index="LvarChar" list="#LvarComodines#">
			<cfset LvarMascara = replace(LvarMascara,mid(LvarChar,1,1),"_","ALL")>
		</cfloop>
	
		<cfreturn LvarMascara>
	</cffunction>
	
	<cffunction name="fnArmaRetorno" access="private" output="false">
		<cfargument name="TypeError" 	type="string" 	required="yes">
		<cfargument name="TypeCtas" 	type="string" 	required="yes">
		<cfargument name="CFformato" 	type="string" 	required="yes">
		<cfargument name="MoreErrors" 	type="boolean" 	required="yes">
		
		<cfif Arguments.TypeCtas EQ 1>
			<cfif trim(Arguments.CFformato) EQ "">
				<cfset LvarTitulo = "VERIFICACION DE CUENTA FINANCIERA">
			<cfelse>
				<cfset LvarTitulo = "VERIFICACION DE CUENTA '#trim(Arguments.CFformato)#'">
			</cfif>
			<cfset LvarERRs = replace(LvarERRs,"<1>#trim(Arguments.CFformato)#<2>","<1>","ALL")>
			<cfset LvarERRs = replace(LvarERRs,"<1><2>","<1>","ALL")>
		<cfelseif Arguments.TypeCtas EQ 2>
			<cfset LvarTitulo = "VERIFICACION DE CUENTAS FINANCIERAS">
		</cfif>
		<cfif Arguments.typeError EQ "html">
			<cfif Arguments.TypeCtas NEQ 0>
				<cfset LvarERRs = "#LvarTitulo#:#chr(10)#" & LvarERRs>
			</cfif>
			<cfset LvarERRs = replace(LvarERRs,"<1><2>","<1>- ","ALL")>
			<cfset LvarERRs = fnReplaceSeparator (LvarERRs,"  ","#chr(10)#    - ",": ","#chr(10)#")>
			<cfset LvarERRs = replace(LvarERRs,"á","&aacute;","ALL")>
			<cfset LvarERRs = replace(LvarERRs,"ó","&oacute;","ALL")>
			<cfset LvarERRs = replace(LvarERRs,"é","&eacute;","ALL")>
			<cfset LvarERRs = replace(LvarERRs,"í","&iacute;","ALL")>
			<cfset LvarERRs = replace(LvarERRs,"ú","&uacute;","ALL")>

			<cfif Arguments.MoreErrors>
				<cfreturn LvarERRs & "EXISTEN MAS CUENTAS CON ERROR...">
			<cfelse>
				<cfreturn LvarERRs>
			</cfif>
		<cfelseif Arguments.typeError EQ "htmlbr">
			<cfif Arguments.TypeCtas NEQ 0>
				<cfset LvarERRs = "<P>#LvarTitulo#:<BR>" & LvarERRs>
			</cfif>
			<cfset LvarERRs = replace(LvarERRs,"<1><2>","<1>- ","ALL")>
			<cfset LvarERRs = fnReplaceSeparator (LvarERRs,"&nbsp;&nbsp;","<BR>&nbsp;&nbsp;&nbsp;&nbsp;- ",": ","<BR>")>
			<cfset LvarERRs = replace(LvarERRs,"á","&aacute;","ALL")>
			<cfset LvarERRs = replace(LvarERRs,"ó","&oacute;","ALL")>
			<cfset LvarERRs = replace(LvarERRs,"é","&eacute;","ALL")>
			<cfset LvarERRs = replace(LvarERRs,"í","&iacute;","ALL")>
			<cfset LvarERRs = replace(LvarERRs,"ú","&uacute;","ALL")>

			<cfif Arguments.MoreErrors>
				<cfreturn LvarERRs & "EXISTEN MAS CUENTAS CON ERROR...</P>">
			<cfelse>
				<cfreturn LvarERRs & "</P>">
			</cfif>
		<cfelseif Arguments.typeError EQ "table">
			<cfif Arguments.TypeCtas EQ 1>
				<cfset LvarERRs = 	"<table border='0'><tr><td colspan='3' align='center'><strong>#LvarTitulo#</strong></td></tr>" &
									"<tr><td align='center'><strong>TIPO CONTROL</strong>&nbsp;&nbsp;</td><td align='center'><strong>ERROR</strong></td></tr>"  & 
									LvarERRs>
			<cfelseif Arguments.TypeCtas EQ 2>
				<cfset LvarERRs = 	"<table border='0'><tr><td colspan='3' align='center'><strong>#LvarTitulo#</strong></td></tr>" &
									"<tr><td align='center'><strong>CUENTA</strong>&nbsp;&nbsp;</td><td align='center'><strong>TIPO CONTROL</strong>&nbsp;&nbsp;</td><td align='center'><strong>ERROR</strong></td></tr>"  & 
									LvarERRs>
			</cfif>
			<cfset LvarERRs = fnReplaceSeparator (LvarERRs,"<tr><td>","&nbsp;&nbsp;</td><td>","&nbsp;&nbsp;</td><td>","&nbsp;&nbsp;</td></tr>")>

			<cfif Arguments.MoreErrors>
				<cfset LvarERRs = LvarERRs & "<tr><td colspan='3'>&nbsp;</td></tr><tr><td colspan='3'>EXISTEN MAS CUENTAS CON ERROR...</td></tr>">
			</cfif>
			<cfif Arguments.TypeCtas NEQ 0>
				<cfset LvarERRs = LvarERRs & "</table>">
			</cfif>
			<cfreturn LvarERRs>
		<cfelse>
			<cfif Arguments.TypeCtas NEQ 0>
				<cfset LvarERRs = "#LvarTitulo#:\n" & LvarERRs>
			</cfif>
			<cfset LvarERRs = replace(LvarERRs,"<1><2>","<1>- ","ALL")>
			<cfset LvarERRs = fnReplaceSeparator (LvarERRs,"  ","\n    - ",": ","\n")>
			<cfif Arguments.MoreErrors>
				<cfreturn LvarERRs & "EXISTEN MAS CUENTAS CON ERROR...">
			<cfelse>
				<cfreturn LvarERRs>
			</cfif>
		</cfif>
	</cffunction>

	<cffunction name="fnReplaceSeparator" output="false" returntype="string" access="private">
		<cfargument name="Line" 		type="string" required="yes">
		<cfargument name="Separator_1" 	type="string" required="yes">
		<cfargument name="Separator_2" 	type="string" required="yes">
		<cfargument name="Separator_3" 	type="string" required="yes">
		<cfargument name="Separator_4" 	type="string" required="yes">

		<cfreturn replace(replace(replace(replace(Arguments.Line,"<1>",Arguments.Separator_1,"ALL"),"<2>",Arguments.Separator_2,"ALL"),"<3>",Arguments.Separator_3,"ALL"),"<4>",Arguments.Separator_4,"ALL")>
	</cffunction>	

	<cffunction name="fnJSStringFormat" output="false" returntype="string" access="private">
		<cfargument name="hilera" type="string" required="yes">
		
		<cfset LvarHilera = JSStringFormat(Arguments.hilera)>
	
		<cfset LvarHilera = replace(LvarHilera,"&aacute;","á","ALL")>
		<cfset LvarHilera = replace(LvarHilera,"&eacute;","é","ALL")>
		<cfset LvarHilera = replace(LvarHilera,"&iacute;","í","ALL")>
		<cfset LvarHilera = replace(LvarHilera,"&oacute;","ó","ALL")>
		<cfset LvarHilera = replace(LvarHilera,"&uacute;","ú","ALL")>
		<cfreturn LvarHilera>
	</cffunction>
</cfcomponent>



