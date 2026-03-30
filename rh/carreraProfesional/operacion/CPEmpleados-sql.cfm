<cfinvoke key="MSG_LaAccionNoTieneConceptosDePagoParaAgregar" default="La Acción no tiene conceptos para agregar"	 returnvariable="MSG_LaAccionNoTieneConceptosDePagoParaAgregar" component="sif.Componentes.Translate" method="Translate"/>
<cfset param = ''>
<cfif not isdefined('form.btnNuevo')>
	<cftransaction>
		<cfif isdefined('form.btnAgregar')>
			<!--- INSERTA EL ENCABEZADO DE LA ACCIÓN DE CARRERA PROFESIONAL --->
			<cfquery name="ABCAccionCP" datasource="#session.DSN#">
				insert into RHAccionesCarreraP (RHACPfdesde, RHACPfhasta, DEid, RHACPObserv, Ecodigo, BMUsucodigo, BMfechaalta, RHACPreferencia, RHACPestado)
					values (
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(Form.fdesde)#">, 
							<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(CreateDate(6100,01,01))#">,  
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">, 
							<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.referencia#">,
							0)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="ABCAccionCP">
			<cfset param = '?RHACPlinea=' & ABCAccionCP.identity>
		<cfelseif isdefined('form.btnGuardar')or isdefined('form.btnAplicar')>
			<!--- MODIFICA EL ENCABEZADO DE LA ACCIÓN DE CARRERA PROFESIONAL --->
			<!--- MODIFICA DATOS DEL ENCABEZADO --->
			<cfquery name="UpdateACP" datasource="#session.DSN#">
				update RHAccionesCarreraP
				set RHACPObserv = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">,
					RHACPreferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.referencia#">,
					BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					BMfechaalta		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
			</cfquery>
			<cfquery name="deleteConceptos" datasource="#session.DSN#">
				delete from DRHAccionesCarreraP
				where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
			</cfquery>
			<!--- VERIFICA QUE SI HAY NUEVOS CONCEPTOS DE PAGO --->
			<cfif isdefined("form.ConceptoidList") and len(trim(form.ConceptoidList))>
				<cfset arreglo = listtoarray(form.ConceptoidList)>	
				<cfset arreglo_valor  = listtoarray(form.valores)>	
				<cfloop from="1" to ="#arraylen(arreglo)#" index="i">
					<cfset arreglo2 = listtoarray(arreglo[i],'|')>	
					<cfset Lvar_Valor = arreglo2[2]>
					<cfif isdefined('form.Valores')>
						<cfset Lvar_Valor = ListGetAt(form.Valores,i)>
					</cfif>
					<!--- VERIFICA SI EL CONCEPTO DE PAGO TIENE QUE SER APROBADO --->
					<cfset Lvar_Aprobacion = 0>
					<cfquery name="rsAprobar" datasource="#session.DSN#">
						select 1 from ConceptosCarreraP where CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo2[1]#"> and CCPaprobacion = 1
					</cfquery>
					<cfif rsAprobar.RecordCount GT 0><cfset Lvar_Aprobacion = 1></cfif>
					<cfquery name="InsertLineasACP" datasource="#Session.DSN#">			
						insert into DRHAccionesCarreraP (RHACPlinea,CCPid,valor,BMfechaalta,BMUsucodigo,Mcodigo)
						values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo2[1]#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Valor#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfif len(trim(arreglo2[3])) and arreglo2[3] NEQ -1>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#arreglo2[3]#">
							<cfelse>
								null
							</cfif>			
						)	 
					</cfquery>			
				</cfloop>
				<cfif isdefined('form.btnAplicar') and Lvar_Aprobacion EQ 0>
					
					<!--- LLAMA EL COMPONENTE PARA APLICAR LA ACCION --->
					<cfinvoke component="rh.carreraProfesional.Componentes.CPAplicaAccion" method="AplicaAccion"
						datasource="#session.dsn#"
						ecodigo = "#Session.Ecodigo#"
						rhacplinea = "#Form.RHACPlinea#"
						usucodigo = "#Session.Usucodigo#"/>
					<!----Actualiza estado de la accion a 40 = "Aplicada"---->
					<cfquery datasource="#session.DSN#">
						update RHAccionesCarreraP
							set RHACPestado = 40,
								RHACPObserv = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">,
								BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								BMfechaalta		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
					</cfquery>
				<cfelse>
					<!----Actualiza estado de la accion a 30 = "Pendiente de Aplicar"---->
					<cfquery datasource="#session.DSN#">
						update RHAccionesCarreraP
							set RHACPestado = 30,
								RHACPObserv = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">,
								BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
								BMfechaalta		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
					</cfquery>
				</cfif>
			</cfif>	
			<cfset param = '?RHACPlinea=' & form.RHACPlinea>	
		<cfelseif isdefined('form.btnEliminar')>
			<!--- SE ELIMINA LA ACCION --->
			<!--- PRIMERO SE ELIMINAN LAS LINEA DE LA ACCION --->
			<cfquery name="deleteConceptos" datasource="#session.DSN#">
				delete from DRHAccionesCarreraP
				where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
			</cfquery>
			<cfquery name="deleteConceptos" datasource="#session.DSN#">
				delete from RHAccionesCarreraP
				where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
			</cfquery>
		<cfelseif isdefined('form.btnRechazar')>
			<!----Actualiza estado de la accion a 30 = "Pendiente de Aplicar"---->
			<cfquery datasource="#session.DSN#">
				update RHAccionesCarreraP
					set RHACPestado = 20,
						RHACPObserv = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">,
						BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
						BMfechaalta		= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where RHACPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHACPlinea#">
			</cfquery>
		</cfif>
	</cftransaction>
</cfif>
<cfif isdefined('btnLista') or isdefined('form.btnEliminar') or isdefined('form.btnAplicar')>
	<cflocation url="CPEmpleados-lista.cfm">
<cfelse>
	<cflocation url="CPEmpleados.cfm#param#">
</cfif>