<cfcomponent>
	<cffunction name="init" access="public">
		<cfreturn this >
	</cffunction>
	<cffunction name="CalculaPuntos" access="public" returntype="numeric">
		<cfargument name="datasource" type="string" required="yes">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="DEid" type="numeric" required="yes">
		<!--- BUSCA LOS CONCEPTOS DE CARRERA QUE SON ACUMULABLES Y SUMA LA CANTIDAD DE PUNTOS --->
		<cfquery name="rsAcum" datasource="#session.DSN#">
			select coalesce(sum(CCPvalor*CCPequivalenciapunto),0) as total
			from LineaTiempoCP a
			inner join ConceptosCarreraP b
				on b.CCPid = a.CCPid
			where DEid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			  and CCPacumulable= 1
		</cfquery>
		<!--- BUSCA LOS CONCEPTOS DE CARRERA QUE NO SON ACUMULABLES Y SUMA LA CANTIDAD DE PUNTOS --->
		<cfquery name="rsNoAcum" datasource="#session.DSN#">
			select coalesce(sum(CCPvalor*CCPequivalenciapunto),0) as total
			from LineaTiempoCP a
			inner join ConceptosCarreraP b
				on b.CCPid = a.CCPid
			where a.DEid   =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			  and a.LTdesde = (select max(c.LTdesde) from LineaTiempoCP c where c.DEid = a.DEid and c.CCPid = a.CCPid)
			  and b.CCPacumulable = 0
		</cfquery>
		<cfreturn rsAcum.Total + rsNoAcum.Total>
	</cffunction>
	
	<cffunction name="CargaHistoricos" access="public" returntype="string">
		<cfargument name="datasource" type="string" required="yes">
		<cfargument name="RHACPlinea" type="numeric" required="yes">
		<!--- SE PASAN A LOS HISTORICOS --->
		<cfquery name="InsertHistorico" datasource="#arguments.datasource#">
			insert into HRHAccionesCarreraP(RHACPlinea, RHACPfdesde, RHACPfhasta, DEid, RHACPObserv, Ecodigo, BMUsucodigo, BMfechaalta)
			select RHACPlinea, RHACPfdesde, RHACPfhasta, DEid, RHACPObserv, Ecodigo, BMUsucodigo, BMfechaalta
			from RHAccionesCarreraP
			where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
		</cfquery>
		<cfquery name="InsertDHistorico" datasource="#arguments.datasource#">
			insert into HDRHAccionesCarreraP(DRHACPlinea, RHACPlinea, CCPid, CIid, valor, BMUsucodigo, BMfechaalta)
			select DRHACPlinea, RHACPlinea, CCPid, CIid, valor, BMUsucodigo, BMfechaalta
			from DRHAccionesCarreraP
			where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
		</cfquery>
		<!--- SE ELIMINAN LOS DATOS DE LA ACCION--->
		<cfquery name="deleteAccion" datasource="#arguments.datasource#">
			delete from DRHAccionesCarreraP
			where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
		</cfquery>
		<cfquery name="deleteAccion" datasource="#arguments.datasource#">
			delete from RHAccionesCarreraP
			where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
		</cfquery>
	</cffunction>
	
	<!--- GRABA LOS CAMBIOS EN LA LINEA DEL TIEMPO --->
	<cffunction name="GrabaLineaTiempo" access="public" returntype="string">
		<cfargument name="datasource" type="string" required="yes">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="DEid" type="numeric" required="yes">
		<cfargument name="CCPid" type="numeric" required="yes">
		<cfargument name="RHPcodigo" type="string" required="yes">
		<cfargument name="Fdesde" type="date" required="yes">
		<cfargument name="Fhasta" type="date" required="yes">		
		<cfargument name="valor" type="numeric" required="yes">
		
		<cfquery name="rsVerificaLineaCP" datasource="#arguments.datasource#">
			select 1
			from LineaTiempoCP
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
			  and CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCPid#">
		</cfquery>
		<cfquery name="rsDatosC" datasource="#arguments.datasource#">
			select CCPplazofijo,CCPacumulable,CCPequivalenciapunto
			from ConceptosCarreraP
			where CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCPid#"> 
		</cfquery>
		<cfset Lvar_Puntos = arguments.valor * rsDatosC.CCPequivalenciapunto>
		<cfset Lvar_Acumulable = rsDatosC.CCPacumulable>
		<cfset Lvar_PlazoFijo  = rsDatosC.CCPplazofijo>
		<cfif rsVerificaLineaCP.RecordCount>
			<!--- SI YA EXISTE EL CONCEPTO DE PAGO TIENE QUE VERIFICAR EL COMPORTAMIENTO PARA VER QUE PROCEDIMIENTO DEBE SEGUIR. --->
			<!--- BUSCAR LA PARAMETRIZACION DEL CONCEPTO DE PAGO --->
			<cfif not Lvar_Acumulable and Lvar_PlazoFijo>
				<!--- BUSCA LOS TRASLAPES DENTRO DE LA LINEA DE TIEMPO Y LOS ELIMINA --->
				<cfquery name="deleteLT" datasource="#arguments.datasource#">
					delete from LineaTiempoCP
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					  and CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCPid#">
					  and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fdesde#"> between LTdesde and LThasta
				</cfquery>
				<cfquery name="deleteLT" datasource="#arguments.datasource#">
					delete from LineaTiempoCP
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					  and CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCPid#">
					  and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fhasta#"> between LTdesde and LThasta
				</cfquery>
				<cfquery name="deleteLT" datasource="#arguments.datasource#">
					delete from LineaTiempoCP
					where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					  and CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCPid#">
					  and LTdesde between <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fdesde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fhasta#">
					  and LThasta between <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fdesde#"> and <cfqueryparam cfsqltype="cf_sql_date" value="#arguments.fhasta#">
				</cfquery>
			<cfelse>
				<cfquery name="rsLineaAct" datasource="#arguments.datasource#">
					select LTCPid, LTdesde, LThasta
					from LineaTiempoCP
					where LTCPid = (select max(LTCPid)
									from LineaTiempoCP
									where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
									  and CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCPid#">)
					  and DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
					  and CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCPid#">
				</cfquery>
				<cfset Lvar_FdesdeUltL = rsLineaAct.LTdesde>
				<cfset Lvar_FhastaUltL = rsLineaAct.LThasta>
				<cfset Lvar_LCTidUltL = rsLineaAct.LTCPid>
				<cfif arguments.fdesde LTE Lvar_FdesdeUltL>
					<!--- SOBREESCRIBE LA LINEA DE TIEMPO ACTUAL --->
					<!--- ELIMINA LA LINEA DE TIEMPO ACTUAL --->
					<cfquery name="deleteLT" datasource="#arguments.datasource#">
						delete from LineaTiempoCP
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
						  and CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCPid#">
						  and LTCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_LCTidUltL#">
					</cfquery>
					<!--- INSERTA EL NUEVO CORTE --->
				<cfelseif arguments.fdesde GTE Lvar_FdesdeUltL>
					<!--- HACE UN CORTE EN LA LINEA DE TIEMPO --->
					<cfset Lvar_Corte = DateAdd('d',-1,arguments.fdesde)>
					<cfquery name="UpdaLTCP" datasource="#session.DSN#">
						update LineaTiempoCP
						set LThasta =  <cfqueryparam cfsqltype="cf_sql_date" value="#Lvar_Corte#">
						where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.DEid#">
						  and CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.CCPid#">
						  and LTCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_LCTidUltL#">
					</cfquery>
				</cfif>
			</cfif>
		</cfif>
		<cfif not Lvar_PlazoFijo>
			<cfset Lvar_Fhasta = CreateDate(6100,01,01)>
		<cfelse>
			<cfset Lvar_Fhasta = arguments.fhasta>
		</cfif>
		<cfinvoke component="CPAplicaAccion" method="CalculaPuntos" returnvariable="TotalPuntos" datasource="#arguments.datasource#" ecodigo="#arguments.Ecodigo#"
				deid="#arguments.DEid#" >
		<cfset Lvar_TotalPuntos = TotalPuntos + Lvar_Puntos>
		<!--- SIEMPRE INSERTA EL REGISTRO EN LA LINEA DE TIEMPO --->
		<cfquery name="InsertLTCP" datasource="#arguments.datasource#">
			insert into LineaTiempoCP(DEid,CCPid,RHPcodigo,LTdesde,LThasta,LTvalor,LTpuntosTotales,BMUsucodigo,BMfechaalta)
			values(
					<cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.CCPid#">,
					<cfqueryparam cfsqltype="cf_sql_varchar"   value="#arguments.RHPcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_date" 	   value="#arguments.fdesde#">,
					<cfqueryparam cfsqltype="cf_sql_date" 	   value="#Lvar_Fhasta#">,
					<cfqueryparam cfsqltype="cf_sql_numeric"   value="#arguments.valor#">,
					<cfqueryparam cfsqltype="cf_sql_numeric"   value="#Lvar_TotalPuntos#">,
					<cfqueryparam cfsqltype="cf_sql_numeric"   value="#session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
			)
		</cfquery>
	</cffunction>
	
	<!--- FUNCION PARA APLICAR LAS ACCIONES DE CARRERA PROFESIONAL --->
	<cffunction name="AplicaAccion" access="public" returntype="string">
		<cfargument name="datasource" type="string" required="yes">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="RHACPlinea" type="numeric" required="yes">
		<cfargument name="Usucodigo" type="numeric" required="yes">
		
		
		
		<cfquery name="rsLineasAccion" datasource="#arguments.datasource#">
			select DEid,CCPid,RHACPfdesde,RHACPfhasta,coalesce(b.valor,0) as valor
			from RHAccionesCarreraP a
			inner join DRHAccionesCarreraP b
				on b.RHACPlinea = a.RHACPlinea
			where a.RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
		</cfquery>
		<!--- PARA CADA UNA DE LAS LINEA DE LA ACCION (CONCEPTOS DE CARRERA) SE MANDA A MODIFICAR EN LA LINEA DEL TIEMPO --->
		<cfloop query="rsLineasAccion">
			<cfquery name="rsDatos" datasource="#arguments.datasource#">
				select RHPcodigo
				from LineaTiempo 
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLineasAccion.DEid#">
				  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#"> between LTdesde and LThasta
			</cfquery>
			<cfinvoke component="CPAplicaAccion" method="GrabaLineaTiempo" returnvariable="GrabaLinea" datasource="#arguments.datasource#" ecodigo="#arguments.Ecodigo#"
				deid="#rsLineasAccion.DEid#" ccpid="#rsLineasAccion.CCPid#" rhpcodigo="#rsDatos.RHPcodigo#"
				fdesde="#rsLineasAccion.RHACPfdesde#"fhasta="#rsLineasAccion.RHACPfdesde#" valor="#rsLineasAccion.valor#">
		</cfloop>
		<!--- CONFECCIONA LA ACCIÓN DE CARRERA PROFESIONAL --->
		<cfinvoke component="CPAplicaAccion" method="GeneraAccion" returnvariable="Accion" datasource="#arguments.datasource#" Ecodigo="#arguments.Ecodigo#"
			rhacplinea="#arguments.RHACPlinea#">
		<cfinvoke component="CPAplicaAccion" method="CargaHistoricos" returnvariable="Historico" datasource="#arguments.datasource#"
			rhacplinea="#arguments.RHACPlinea#">
		
	</cffunction>
	<!--- FUNCION PARA GENERAR LA ACCION DE PERSONAL --->
		<!--- GRABA LOS CAMBIOS EN LA LINEA DEL TIEMPO --->
	<cffunction name="GeneraAccion" access="public" returntype="string">
		<cfargument name="datasource" type="string" required="yes">
		<cfargument name="Ecodigo" type="numeric" required="yes">
		<cfargument name="RHACPlinea" type="numeric" required="yes">
	
		<!--- VERIFICAR LA DEFINICION DE LA ACCION DE PERSONAL NECESARIA --->
		<cfinvoke component="rh.Componentes.RHParametros" method="get" datasource="#session.DSN#" ecodigo="#session.Ecodigo#" pvalor="2039" default="" returnvariable="RHTid"/>

		<cfif Not Len(RHTid)>
			<cf_throw message="No se han definido el tipo de Acción para el Proceso de Asignación de Carrera Profesional. Proceso Cancelado." errorcode="2039">
		</cfif>
		<cfquery name="rsDatos" datasource="#arguments.datasource#">
			Select a.DEid,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#RHTid#"> as RHTid,
				 b.Tcodigo,b.RVid,b.RHJid,b.Dcodigo,b.Ocodigo,b.RHPid,a.RHACPfdesde,a.RHACPfhasta,b.LTsalario,
				b.LTporcsal,b.LTporcplaza,b.RHPcodigo, RHCPlinea
			from RHAccionesCarreraP a
			inner join LineaTiempo b
				on b.DEid = a.DEid
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#"> 
			  and a.RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHACPlinea#"> 
			  and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between LTdesde and LThasta 
		</cfquery>
		<!---Insertado en la tabla RHAcciones---->
		<cfquery name="rsAccionEnc" datasource="#arguments.datasource#">
			insert into RHAcciones(DEid, RHTid, Ecodigo, Tcodigo, RVid, RHJid, Dcodigo, Ocodigo, RHPid, 
						RHPcodigo, DLfvigencia, DLsalario, RHAporc, RHAporcsal, RHCPlinea, Usucodigo)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.DEid#">,					
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHTid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.Tcodigo#">,		
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RVid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHJid#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Dcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsDatos.Ocodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHPid#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#rsDatos.RHPcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsDatos.RHACPfdesde#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#rsDatos.LTsalario#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.LTporcplaza#">,
					<cfqueryparam cfsqltype="cf_sql_float" value="#rsDatos.LTporcsal#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.RHCPlinea#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
		<cf_dbidentity2 datasource="#session.DSN#" name="rsAccionEnc">
		<!--- Insertar el componente salarial --->
		<cfquery name="insComponente" datasource="#Session.DSN#">
			 insert into RHDAcciones (RHAlinea, CSid, RHDAtabla, RHDAunidad, RHDAmontobase, RHDAmontores, Usucodigo, Ulocalizacion, BMUsucodigo) 
			select <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccionEnc.identity#">, 
					c.CSid, c.DLTtabla, 
				   coalesce(c.DLTunidades, 1.00), 
				   case 
						when d.RHMCcomportamiento is not null and d.RHMCcomportamiento = 2 then round(coalesce(c.DLTmonto, 0.00) / coalesce(c.DLTunidades, 1.00), 2) * 100
						else round(coalesce(c.DLTmonto, 0.00) / coalesce(c.DLTunidades, 1.00), 2)
				   end as DLTmontobase,
				   coalesce(c.DLTmonto, 0.00), 
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
				   '00',
				   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
			from RHAccionesCarreraP a
				inner join LineaTiempo b
					on b.DEid = a.DEid
					and a.RHACPfdesde between b.LTdesde and b.LThasta
				inner join DLineaTiempo c
					on c.LTid = b.LTid
				left outer join RHMetodosCalculo d
					on d.CSid = c.CSid
					and a.RHACPfdesde between d.RHMCfecharige and d.RHMCfechahasta
					and d.RHMCestadometodo = 1
			where a.RHACPlinea =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.RHACPlinea#">
			and not exists (
				select 1
				from RHDAcciones x
				where x.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccionEnc.identity#">
				and x.CSid = c.CSid
			)
		</cfquery>
		<cfquery name="consulta" datasource="#session.DSN#">
			select b.*
			from RHAcciones a
			inner join RHDAcciones b
				on b.RHAlinea = a.RHAlinea
			where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccionEnc.identity#">
		</cfquery>
	</cffunction>
</cfcomponent>