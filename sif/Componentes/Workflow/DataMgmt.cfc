<cfcomponent>
<!--- 
	DESCRIPCION
	  Este componente tiene la implementación del Workflow Engine para los trámites de Recursos Humanos.
	  Ningún método de aquí se debe invocar directamente, sino que deben realizarse a través
	  del componenete "Operations.cfc" en este mismo directorio
	
	LIMITACIONES
	  Se pasó solamente lo que se utiliza en RH, lo demás se va pasando conforme se requiera.
	  Esto significa las siguientes restricciones:
		- WfApplication.Type: implementado 'PROCEDURE', faltan 'WEBSERVICE','APPLICATION','SUBFLOW'
		- WfParticipant.ParticipantType: implementado HUMAN como un login (Usucodigo), 
		  faltan GROUP, ROLE, ORGUNIT y posiblemente una manera de discriminar el tipo de HUMAN (Usucodigo,DEid,etc)
		- No envía emails a los empleados, solamente al responsable y al que inició el trámite
		- Transiciones automáticas (autoTransition), todavía no se ha necesitado por no haber
		  stored procedures intermedios (no al final del proceso), o tareas que solamente envíen el email.
		- Los responsables de una actividad están fijados al momento de iniciar el WfxProcess (Trámite)
		- Solamente maneja Data Items de tipo String, no maneja text,image,integer,date/time
		- Los emails que envía están diseñados (contenido) para Acciones de RH
--->

	<cffunction name="setDataItem" access="package" output="false" >
		<cfargument name="processInstanceId" type="numeric" required="yes">
		<cfargument name="name" type="string" required="yes">
		<cfargument name="stringValue" type="string" required="yes">

		<cfquery name="WfxDataField" datasource="#session.DSN#">
			select b.DataFieldName, a.ProcessId
			from WfxProcess a, WfDataField b
			where a.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.processInstanceId#">
			  and a.ProcessId = b.ProcessId
			  and upper(b.DataFieldName) =<cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(arguments.name)#"> 
<!---			  upper(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">)
--->		</cfquery>
		<cfif WfxDataField.RecordCount Is 0 >
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_NoExisteEl"
			Default="No existe el"
			returnvariable="MSG_NoExisteEl"/>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ParaEl"
			Default="para el"
			returnvariable="MSG_ParaEl"/>
	
			<cf_errorCode	code = "51396"
							msg  = "@errorDat_1@ Item @errorDat_2@ @errorDat_3@ ProcessInstanceId @errorDat_4@ "
							errorDat_1="#MSG_NoExisteEl#"
							errorDat_2="#Arguments.name#"
							errorDat_3="#MSG_ParaEl#"
							errorDat_4="#Arguments.ProcessInstanceId#"
			>
		</cfif>
		<cfquery datasource="#session.dsn#" name="existe_wfxdatafield">
			select count(1) as hay
			from WfxDataField
			where ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.processInstanceId#">
			  and upper(DataFieldName) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(arguments.name)#"> 
<!---			  upper(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">)
--->		</cfquery>
		<cfif existe_wfxdatafield.hay>
			<cfquery datasource="#session.DSN#" name="updateWfxDataField">
				update WfxDataField
				set Value = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.stringValue#" null="#Len(Arguments.stringValue) Is 0#">,
					TextValue = null,
					BinaryValue = null
				where ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.processInstanceId#">
				  and upper(DataFieldName) = upper(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">)
			</cfquery>
		<cfelse>
			<cfquery name="insertWfxDataField" datasource="#session.DSN#">
				insert INTO WfxDataField (ProcessInstanceId, DataFieldName, ProcessId, Value)
				select <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#Arguments.processInstanceId#">,
					 DataFieldName, 
					 <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#WfxDataField.ProcessId#">,
					 <cf_jdbcquery_param cfsqltype="cf_sql_varchar" value="#arguments.stringValue#" null="#Len(Arguments.stringValue) Is 0#">
				from WfDataField
				where ProcessId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#WfxDataField.ProcessId#">
				  and upper(DataFieldName) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UCase(arguments.name)#"> 
<!---				  upper(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">)
--->			</cfquery>
		</cfif>
	</cffunction>

	<cffunction name="getDataItem" access="package" output="false" returntype="string">
		<cfargument name="processInstanceId" type="numeric" required="yes">
		<cfargument name="name" type="string" required="yes">

		<cfquery name="WfxDataField" datasource="#session.DSN#">
			select c.Value
			from WfxDataField c
			where c.ProcessInstanceId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.processInstanceId#">
			  and upper(c.DataFieldName) = upper(<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.name#">)
		</cfquery>
		<cfif WfxDataField.RecordCount Is 0 >
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_NoExisteEl"
			Default="No existe el"
			returnvariable="MSG_NoExisteEl"/>
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_ParaEl"
			Default="para el"
			returnvariable="MSG_ParaEl"/>

			<cf_errorCode	code = "51397"
							msg  = "@errorDat_1@ Data Item @errorDat_2@ @errorDat_3@ ProcessInstanceId @errorDat_4@ "
							errorDat_1="#MSG_NoExisteEl#"
							errorDat_2="#Arguments.name#"
							errorDat_3="#MSG_ParaEl#"
							errorDat_4="#Arguments.ProcessInstanceId#"
			>
		</cfif>
		<cfreturn WfxDataField.Value>
	</cffunction>	
</cfcomponent>

