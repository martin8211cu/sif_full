<cfcomponent>
<!--- 
	DESCRIPCION
	  Este componente tiene la implementación del Workflow Engine para los trámites de Recursos Humanos.
	  Ningún método de aquí se debe invocar directamente, sino que deben realizarse a través
	  del componenete "Operations.cfc" en este mismo directorio
	
	LIMITACIONES
	  NO HAY UN MANEJO ADECUADO DE LAS TRANSACCIONES HACIA LOS CFC QUE SE INVOCAN,
	  	DEBIDO A LAS LIMITACIONES DEL LENGUAJE Y DEL TIEMPO DE DESARROLLO. VER NOTAS
		EN EL METODO wfinvoke. -- danim 06/09/2004
	  (actualizar esta seccion con las nuevas funcionalidades ya incorporadas)
	  Se pasó solamente lo que se utiliza en RH, lo demás se va pasando conforme se requiera.
	  Esto significa las siguientes restricciones:
		- WfApplication.Type: implementado 'PROCEDURE','CFC', faltan 'WEBSERVICE','APPLICATION','SUBFLOW'
		- WfParticipant.ParticipantType: implementado HUMAN como un login (Usucodigo), 
		  faltan GROUP, ROLE, ORGUNIT y posiblemente una manera de discriminar el tipo de HUMAN (Usucodigo,DEid,etc)
		- No envía emails a los empleados, solamente al responsable y al que inició el trámite
		- Transiciones automáticas (autoTransition), todavía no se ha necesitado por no haber
		  stored procedures intermedios (no al final del proceso), o tareas que solamente envíen el email.
		- Los responsables de una actividad están fijados al momento de iniciar el WfxProcess (Trámite)
		- Solamente maneja Data Items de tipo String, no maneja text,image,integer,date/time
		- Los emails que envía están diseñados (contenido) para Acciones de RH
--->

	<cffunction name="Datatype2cfsqltype" access="package" returntype="string" output="false">
		<cfargument name="Datatype" type="string" required="yes">
		
		<cfswitch expression="#Arguments.Datatype#" >
			<cfcase value="STRING,XML">
				<cfreturn "cf_sql_varchar">
			</cfcase>
			<cfcase value="NUMERIC">
				<cfreturn "cf_sql_numeric">
			</cfcase>
			<cfcase value="FILE">
				<cfreturn "cf_sql_blob">
			</cfcase>
			<cfdefaultcase>
				<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_invalido"
				Default="inválido"
				returnvariable="MSG_invalido"/>

				<cf_errorCode	code = "51398"
								msg  = "Datatype @errorDat_1@: @errorDat_2@"
								errorDat_1="#MSG_invalido#"
								errorDat_2="#Arguments.Datatype#"
				>
			</cfdefaultcase>
		</cfswitch>
	</cffunction>
	
	<cffunction name="callApplicationByType" access="public" returntype="query" output="false">
		<cfargument name="activityInstanceId" type="numeric" required="yes">
		<cfargument name="application" type="WfApplication" required="yes">
		<cfargument name="WfxArguments" type="query" required="yes">
		<cfif Trim(Arguments.application.Type) eq 'PROCEDURE'>
			<cfset ret = this.callStoredProcedure( Arguments.activityInstanceId, Arguments.application, WfxArguments ) >
		<cfelseif Trim(Arguments.application.Type) eq 'CFC'>
			<cfset ret = this.callColdfusionComponent( Arguments.activityInstanceId, Arguments.application, WfxArguments ) >
		<cfelse>
			<!--- incluido WEBSERVICE --->
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_TipoDeAplicacionNoImplementado"
			Default="Tipo de aplicacion no implementado"
			returnvariable="MSG_TipoDeAplicacionNoImplementado"/>
			
			<cf_errorCode	code = "51399"
							msg  = "@errorDat_1@: @errorDat_2@"
							errorDat_1="#MSG_TipoDeAplicacionNoImplementado#"
							errorDat_2="#Arguments.application.Type#"
			>
		</cfif>
		<cfreturn ret>
	</cffunction>

	<!---
		Invoca un procedimiento almacenado en sybase
		Location: Datasource
		Command:  Nombre del procedimiento almacenado
	--->
	<cffunction name="callStoredProcedure" access="package" returntype="query" output="false">
		<cfargument name="activityInstanceId" type="numeric" required="yes">
		<cfargument name="application" type="WfApplication" required="yes">
		<cfargument name="WfxArguments" type="query" required="yes">

		<cfset DataSource = Replace(application.Location, 'java:comp/env/jdbc/', '')>

		<cfquery name="return_values" datasource="#DataSource#">
			execute #application.Command#
			<cfloop query="WfxArguments">
				@#WfxArguments.Name# = 
				<cfqueryparam cfsqltype="#This.Datatype2cfsqltype(WfxArguments.Datatype)#" value="#WfxArguments.ValueIn#">
				<cfif CurrentRow neq WfxArguments.RecordCount>,</cfif>
			</cfloop>
		</cfquery>
		<cfif IsDefined("return_values")>
			<cfreturn return_values>
		<cfelse>
			<cfreturn QueryNew("status")>
		</cfif>
	</cffunction>

	<!---
		Invoca un componente de coldfusion
		Location: Nombre del Componente
		Command:  Metodo por invocar
	--->
	<cffunction name="callColdfusionComponent" access="package" returntype="query" output="false">
		<cfargument name="activityInstanceId" type="numeric" required="yes">
		<cfargument name="application" type="WfApplication" required="yes">
		<cfargument name="WfxArguments" type="query" required="yes">
		
		<cfinvoke component="#application.Location#" method="#application.Command#" returnvariable="return_values">
			<cfloop query="WfxArguments">
				<cfinvokeargument name="#WfxArguments.ParameterName#" value="#WfxArguments.ValueIn#" >
			</cfloop>
		</cfinvoke>
		<cfif IsDefined("return_values") and IsQuery(return_values)>
			<cfreturn return_values>
		<cfelse>
			<cfreturn QueryNew("status")>
		</cfif>
	</cffunction>

	<cffunction name="wfinvoke" access="package" output="true" >
		<cfargument name="ProcessInstanceId" type="numeric" required="yes">
		<cfargument name="ActivityInstanceId" type="numeric" required="yes">
		<cfargument name="ApplicationName" type="string" required="yes">
	
		<!--- lee configuracion de aplicación --->
		<cfinvoke component="WfApplication" method="findById" returnvariable="wfinvoke_wfApplication"
			ApplicationName = "#Arguments.ApplicationName#">
		</cfinvoke>
		<cfif wfinvoke_wfApplication.RecordCount lte 0 >
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_NoSeEncontroLaDefinicionDeLaAplicacion"
			Default="No se encontr&oacute; la definici&oacute;n de la aplicaci&oacute;n"
			returnvariable="MSG_NoSeEncontroLaDefinicionDeLaAplicacion"/>
			<cf_errorCode	code = "51400"
							msg  = "@errorDat_1@. [WfApplication:@errorDat_2@]"
							errorDat_1="#MSG_NoSeEncontroLaDefinicionDeLaAplicacion#"
							errorDat_2="#arguments.ApplicationName#"
			>
		</cfif>
		
		<!--- lee configuracion de actividad --->
		<cfquery name="wfxActivity" datasource="#session.DSN#">
			select ActivityInstanceId, ActivityId,
				 ProcessInstanceId,
				 State, StartTime, FinishTime, WaitingTime, WorkingTime, UpdateTime 
			from WfxActivity 
			where ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.activityInstanceId#">
		</cfquery>
		<cfif wfxActivity.RecordCount lte 0 >
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_NoSeEncontroLaDefinicionDeLaActividad"
			Default="No se encontr&oacute; la definici&oacute;n de la actividad"
			returnvariable="MSG_NoSeEncontroLaDefinicionDeLaActividad"/>
			<cf_errorCode	code = "51401"
							msg  = "@errorDat_1@. [WfxActivity: @errorDat_2@]"
							errorDat_1="#MSG_NoSeEncontroLaDefinicionDeLaActividad#"
							errorDat_2="#arguments.activityInstanceId#"
			>
		</cfif>
		
		<!--- lee configuracion de invocacion --->
		<cfquery name="wfInvocation" datasource="#session.DSN#">
			select ActivityId, ApplicationName, Execution
			from WfInvocation 
			where ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#wfxActivity.activityId#" >
			  and ApplicationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ApplicationName#" >
		</cfquery>		
		<cfif wfInvocation.RecordCount lte 0 >
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_NoSeEncontroLaDefinicionDeLaInvocacion"
			Default="No se encontr&oacute; la definici&oacute;n de la invocaci&oacute;n"
			returnvariable="MSG_NoSeEncontroLaDefinicionDeLaInvocacion"/>
			<cf_errorCode	code = "51402"
							msg  = "@errorDat_1@. [WfInvocation: @errorDat_2@ , @errorDat_3@]"
							errorDat_1="#MSG_NoSeEncontroLaDefinicionDeLaInvocacion#"
							errorDat_2="#wfxActivity.ActivityId#"
							errorDat_3="#arguments.ApplicationName#"
			>
		</cfif>
		
		<!--- la funcion find de WfxInvocation se partio, los argumentos ya no se obtienen ahi, sin desde esta parte de codigo
			  Esto porque se requieren dos resulsets y la funcion solo me puede devolver uno 	
		--->
		<cfquery name="wfxInvocation" datasource="#session.DSN#">
			select FinishTime
			from WfxInvocation 
			where ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.activityInstanceId#" >
			  and ApplicationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ApplicationName#" >
		</cfquery>
		<cfif Len(wfxInvocation.FinishTime) gt 0>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_LaInvocacionYaSeHabiaRealizado"
			Default="La invocaci&oacute;n ya se habia realizado"
			returnvariable="MSG_LaInvocacionYaSeHabiaRealizado"/>

			<cf_errorCode	code = "51403"
							msg  = "@errorDat_1@. [WfxInvocation: @errorDat_2@, @errorDat_3@ ]"
							errorDat_1="#MSG_LaInvocacionYaSeHabiaRealizado#"
							errorDat_2="#arguments.activityInstanceId#"
							errorDat_3="#arguments.ApplicationName#"
			>
		</cfif>

		<cfif wfxInvocation.RecordCount eq 0>
			<!--- Prepara la invocacion 
				Este query hace la consulta sobre WfFormalParameter, WfActualParameter, WfxDataField, y
				su resultado se inserta en WfxArgument
			--->
			<cfquery name="insert" datasource="#session.DSN#">
				insert INTO WfxInvocation( ActivityInstanceId, ApplicationName, StartTime, FinishTime, ErrorNumber, ErrorMessage, ProcessInstanceId)
				values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.activityInstanceId#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ApplicationName#">, 
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">, null, null, null,
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ProcessInstanceId#">)
			</cfquery>
			
			<cfquery name="insert" datasource="#session.DSN#">
				select
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.activityInstanceId#"> as ActivityInstanceId,
					a.ApplicationName, 
					a.ParameterName, b.ParameterNumber, b.ParameterMode,
					coalesce(c.Value, a.Value) as ValueIn, <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">  as ValueOut
				from WfActualParameter a
					join WfFormalParameter b
						on  a.ApplicationName = b.ApplicationName
						and a.ParameterName = b.ParameterName
					left join WfxDataField c
						on  a.DataFieldName = c.DataFieldName
						and c.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ProcessInstanceId#"> 
				where a.ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#wfxActivity.activityId#">
				  and a.ApplicationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ApplicationName#">
			</cfquery>
			
			<cfquery name="insert" datasource="#session.DSN#">
				insert INTO WfxArgument (ActivityInstanceId, ApplicationName,
					ParameterName, ParameterNumber, ParameterMode,
					ValueIn, ValueOut)
				select
					<cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#arguments.activityInstanceId#"> as ActivityInstanceId,
					a.ApplicationName, 
					a.ParameterName, b.ParameterNumber, b.ParameterMode,
					coalesce(c.Value, a.Value) as ValueIn, <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="null">  as ValueOut
				from WfActualParameter a
					join WfFormalParameter b
						on  a.ApplicationName = b.ApplicationName
						and a.ParameterName = b.ParameterName
					left join WfxDataField c
						on  a.DataFieldName = c.DataFieldName
						and c.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ProcessInstanceId#"> 
				where a.ActivityId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#wfxActivity.activityId#">
				  and a.ApplicationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.ApplicationName#">
			</cfquery>
		</cfif>
		
		<cfquery name="WfxArguments" datasource="#session.dsn#">
			select xa.ParameterName, xa.ValueIn, fp.Datatype
			from WfxArgument xa
				join WfFormalParameter fp
					on  fp.ApplicationName = xa.ApplicationName
					and fp.ParameterName   = xa.ParameterName
			where xa.ApplicationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicationName#">
			  and xa.ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.activityInstanceId#">
			  and xa.ParameterMode in ('IN', 'INOUT')
			order by xa.ParameterNumber
		</cfquery>
		
		<cfif wfinvoke_wfApplication.TxMode Is 'REQUIRED'>
			<!--- si se invoca en linea --->
			<cfset ret = this.callApplicationByType( Arguments.activityInstanceId, wfinvoke_wfApplication, WfxArguments ) >
		<cfelseif wfinvoke_wfApplication.TxMode Is 'REQUIRES_NEW'>
			<cfset my_password = Rand() * 10000000>
			<cflock name="application.invocationremote.hashes" timeout="5">
				<cfparam name="application.Workflow_InvocationRemote_Hashes" default="">
				<cfset application.Workflow_InvocationRemote_Hashes = ListAppend(application.Workflow_InvocationRemote_Hashes, my_password)>
			</cflock>
			
			<cfhttp url="http://#session.sitio.host#/cfmx/sif/tr/anonimo/InvocationRemote.cfm"
				method="post">
				<cfhttpparam type="formfield" name="Acceso" value="#my_password#">
				<cfhttpparam type="formfield" name="seleccionar_EcodigoSDC" value="#session.EcodigoSDC#" >
				<!--- al poner el seleccionar_EcodigoSDC, el dsn esta casi que sobrando, pero ahi va de todos modos --->
				<cfhttpparam type="formfield" name="dsn" value="#session.dsn#">
				<cfhttpparam type="formfield" name="ActivityInstanceId" value="#Arguments.ActivityInstanceId#">
				<cfhttpparam type="formfield" name="AppName"     value="#wfinvoke_wfApplication.ApplicationName#" >
				<cfhttpparam type="formfield" name="AppCommand"  value="#wfinvoke_wfApplication.Command#" >
				<cfhttpparam type="formfield" name="AppLocation" value="#wfinvoke_wfApplication.Location#" >
				<cfhttpparam type="formfield" name="AppType"     value="#wfinvoke_wfApplication.Type#" >
				<cfhttpparam type="formfield" name="argc"        value="#WfxArguments.RecordCount#">
				
				<cfloop query="WfxArguments">
					<cfhttpparam type="formfield" name="arg#WfxArguments.CurrentRow#n" value="#WfxArguments.ParameterName#">
					<cfhttpparam type="formfield" name="arg#WfxArguments.CurrentRow#d" value="#WfxArguments.Datatype#">
					<cfhttpparam type="formfield" name="arg#WfxArguments.CurrentRow#v" value="#WfxArguments.ValueIn#">
				</cfloop>
			</cfhttp>
			<cfset ret = cfhttp.FileContent>
			<cfset ret = Trim(StripCR(ret))>
			<cfif ret neq 'ok'>
				<cf_errorCode	code = "51404"
								msg  = "Status:@errorDat_1@ Error:'@errorDat_2@'"
								errorDat_1="#cfhttp.StatusCode#"
								errorDat_2="#ListFirst(ret)#"
								errorDat_3="#ListRest(ret)#"
				>
			</cfif>
		<cfelse>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_InvalidoPara"
			Default="inv&aacute;lido para"
			returnvariable="MSG_InvalidoPara"/>

			<cf_errorCode	code = "51405"
							msg  = "TxMode @errorDat_1@ @errorDat_2@: @errorDat_3@"
							errorDat_1="#MSG_InvalidoPara#"
							errorDat_2="#wfinvoke_wfApplication.ApplicationName#"
							errorDat_3="#wfinvoke_wfApplication.TxMode#"
			>
		</cfif>


		<cfquery datasource="#session.dsn#">
			update WfxInvocation
			set FinishTime = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			where ActivityInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.activityInstanceId#">
			  and ApplicationName = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.applicationName#">
		</cfquery>
		
		<cfreturn true>

		<!---
		  // guardar resultado
		  if (ret != null) {
			for (Iterator i = wfxInvocation.arguments.iterator(); i.hasNext(); ) {
			  WfxArgument arg = (WfxArgument) i.next();
			  if ("OUT".equals(arg.ParameterMode) || "INOUT".equals(arg.ParameterMode)) {
				Object value = ret.get(arg.name);
				if (value != null) {
				  arg.valueOut = value.toString();
				}
			  }
			}
		  }
		  wfxInvocation.store(con);
		--->
		
	</cffunction>
</cfcomponent>

