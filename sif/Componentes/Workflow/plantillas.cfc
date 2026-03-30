<cfcomponent>
	<cffunction name="CrearPkg" returntype="WfPackage" access="public">
		<cfargument name="PackageBaseName"	type="string"	required="yes">
		<cfargument name="CFdestino"		type="boolean"	default="false">

		<cftransaction>
			<cfinvoke component="WfPackage" method="findByName" returnvariable="WfPackage">
				<cfinvokeargument name="name" value="#Arguments.PackageBaseName#/#session.Ecodigo#">
			</cfinvoke>
			<cfif WfPackage.RecordCount is 0>
				<cfset WfPackage.Name			= Arguments.PackageBaseName &  '/'  & session.Ecodigo>
				<cfset WfPackage.Description	= Arguments.PackageBaseName & ' - ' & session.Enombre>
				<cfset WfPackage.Ecodigo		= session.Ecodigo>
				<cfif Arguments.CFdestino>
					<cfset WfPackage.CFdestino	= 1>
				</cfif>
				<cfset WfPackage.update()>
			</cfif>
		</cftransaction>
		<cfreturn WfPackage>
	</cffunction>

	<cffunction name="ListarPlantillas" returntype="array" access="public">
		<cfset lista_de_tramites = 'RH,Acciones de Personal;RHPP,Planilla Presupuestaria;CM,Solicitudes de Compras;TESSP,Solicitudes de Pago Tesorería;TPRES,Traslados de Presupuesto;CN,Contratos'>
		<!--- DMIG,Aprobación de Datos;MMIG,Aprobación de Métricas;IMIG,Aprobación de Indicador --->
		<cfif session.sitio.host is 'websdc' or find('.dev.soin.net', session.sitio.host)>
			<cfset lista_de_tramites = 'GEN,Trámites Abiertos, para uso interno de SOIN;' & lista_de_tramites>
		</cfif>
		<cfreturn ListToArray(lista_de_tramites,';')>
	</cffunction>


	<cffunction name="CrearGen" returntype="numeric" access="public">
		<cfset Pkg = CrearPkg('GEN')>
		<cftransaction>
			<cfinvoke component="WfProcess" method="init" returnvariable="new_process" />
			<cfset new_process.PackageId = Pkg.PackageId>
			<cfset new_process.Description = 'Nuevo trámite General'>
			<cfset new_process.DetailURL = ''>
			<cfset new_process.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="inicio" />
			<cfset inicio.Name = 'Inicio'>
			<cfset inicio.Description = 'Inicio'>
			<cfset inicio.IsStart = true>
			<cfset inicio.ProcessId = new_process.ProcessId>
			<cfset inicio.ReadOnly = true>
			<cfset inicio.SymbolData = 'x=64,y=64'>
			<cfset inicio.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="VoBo" />
			<cfset VoBo.Name = 'VoBo'>
			<cfset VoBo.Description = 'VoBo'>
			<cfset VoBo.ProcessId = new_process.ProcessId>
			<cfset VoBo.SymbolData = 'x=256,y=64'>
			<cfset VoBo.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="rechazado" />
			<cfset rechazado.Name = 'Rechazado'>
			<cfset rechazado.Description = 'Rechazado'>
			<cfset rechazado.IsFinish = true>
			<cfset rechazado.ProcessId = new_process.ProcessId>
			<cfset rechazado.ReadOnly = true>
			<cfset rechazado.SymbolData = 'x=576,y=88'>
			<cfset rechazado.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="aprobado" />
			<cfset aprobado.Name = 'Aprobado'>
			<cfset aprobado.Description = 'Aprobado'>
			<cfset aprobado.IsFinish = true>
			<cfset aprobado.ProcessId = new_process.ProcessId>
			<cfset aprobado.ReadOnly = true>
			<cfset aprobado.SymbolData = 'x=576,y=32'>
			<cfset aprobado.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = inicio.ActivityId>
			<cfset transicion_1.ToActivity   = VoBo.ActivityId>
			<cfset transicion_1.Name         = 'Comenzar'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = aprobado.ActivityId>
			<cfset transicion_1.Name         = 'ACEPTAR'>
			<cfset transicion_1.update()>

		</cftransaction>
		<cfreturn new_process.ProcessId>
	</cffunction>

	<cffunction name="CrearRH" returntype="numeric" access="public">
		<cfset Pkg = CrearPkg('RH',true)>
		<cftransaction>
			<cfinvoke component="WfProcess" method="init" returnvariable="new_process" />
			<cfset new_process.PackageId = Pkg.PackageId>
			<cfset new_process.Description = 'Nuevo trámite de Recursos Humanos'>
			<cfset new_process.DetailURL = '/rh/nomina/operacion/tramites/ConsultaAcciones.cfm?DEid=##DEid##&RHAlinea=##RHAlinea##&Cambio=&tipo=1'>
			<cfset new_process.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="inicio" />
			<cfset inicio.Name = 'Inicio'>
			<cfset inicio.Description = 'Inicio'>
			<cfset inicio.IsStart = true>
			<cfset inicio.ProcessId = new_process.ProcessId>
			<cfset inicio.ReadOnly = true>
			<cfset inicio.SymbolData = 'x=64,y=64'>
			<cfset inicio.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="VoBo" />
			<cfset VoBo.Name = 'VoBo'>
			<cfset VoBo.Description = 'VoBo'>
			<cfset VoBo.ProcessId = new_process.ProcessId>
			<cfset VoBo.SymbolData = 'x=256,y=64'>
			<cfset VoBo.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="rechazado" />
			<cfset rechazado.Name = 'Rechazado'>
			<cfset rechazado.Description = 'Rechazado'>
			<cfset rechazado.IsFinish = true>
			<cfset rechazado.ProcessId = new_process.ProcessId>
			<cfset rechazado.ReadOnly = true>
			<cfset rechazado.SymbolData = 'x=576,y=88'>
			<cfset rechazado.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="aprobado" />
			<cfset aprobado.Name = 'Aprobado'>
			<cfset aprobado.Description = 'Aprobado'>
			<cfset aprobado.IsFinish = true>
			<cfset aprobado.ProcessId = new_process.ProcessId>
			<cfset aprobado.ReadOnly = true>
			<cfset aprobado.SymbolData = 'x=576,y=32'>
			<cfset aprobado.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = inicio.ActivityId>
			<cfset transicion_1.ToActivity   = VoBo.ActivityId>
			<cfset transicion_1.Name         = 'Comenzar'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = aprobado.ActivityId>
			<cfset transicion_1.Name         = 'ACEPTAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = rechazado.ActivityId>
			<cfset transicion_1.Name         = 'RECHAZAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('DEid', 'Número de empleado')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Empleado', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Ecodigo', 'Código de Empresa')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Empresa', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('DEnombre', 'Nombre de empleado')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('Nombre', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('RHAlinea', 'Número de acción')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Acción', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Usucodigo', 'Usuario que inicia trámite')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Usuario(id)', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfApplication" method="init" returnvariable="application_1" />
			<cfset application_1.setName ('AplicaAccion', 'Ejecuta la aplicación de una acción')>
			<cfset application_1.Type = 'CFC'>
			<cfset application_1.Location = 'rh.Componentes.RH_AplicaAccion'>
			<cfset application_1.Documentation = 'Ejecuta un llamado al procedimiento de la acción'>
			<cfset application_1.Command = 'AplicaAccion'>
			<cfset application_1.update()>
			<cfset application_1.addFormalParameter(1, 'Ecodigo', 'Empresa', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(2, 'RHAlinea', 'Número de acción', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(3, 'Usucodigo', 'Usuario que invoca', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(4, 'Ulocalizacion', 'Usuario que invoca', 'STRING', 'IN')>

			<cfinvoke component="WfInvocation" method="init" returnvariable="invocation_1" />
			<cfset invocation_1.ActivityId = aprobado.ActivityId>
			<cfset invocation_1.ProcessId = new_process.ProcessId>
			<cfset invocation_1.ApplicationName = application_1.ApplicationName>
			<cfset invocation_1.update()>

			<cfset invocation_1.addActualParameter('Ecodigo', 'NUMERIC', '', 'Ecodigo')>
			<cfset invocation_1.addActualParameter('RHAlinea', 'NUMERIC', '', 'RHAlinea')>
			<cfset invocation_1.addActualParameter('Usucodigo', 'NUMERIC', '', 'Usucodigo')>
			<cfset invocation_1.addActualParameter('Ulocalizacion', 'NUMERIC', '00')>
		</cftransaction>
		<cfreturn new_process.ProcessId>
	</cffunction>

	<cffunction name="CrearCM" returntype="numeric" access="public">
		<cfset Pkg = CrearPkg('CM')>
		<cftransaction>
			<cfinvoke component="WfProcess" method="init" returnvariable="new_process" />
			<cfset new_process.PackageId = Pkg.PackageId>
			<cfset new_process.Description = 'Nuevo trámite de Compras'>
			<cfset new_process.DetailURL = '/sif/cm/operacion/TramiteSolicitud.cfm?Ecodigo=##Ecodigo##&ESidsolicitud=##ESidsolicitud##'>
			<cfset new_process.DoneURL   = '/sif/cm/operacion/TramiteSolicitudTerminado.cfm?Ecodigo=##Ecodigo##&ESidsolicitud=##ESidsolicitud##'>
			<cfset new_process.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="inicio" />
			<cfset inicio.Name = 'Inicio'>
			<cfset inicio.Description = 'Inicio'>
			<cfset inicio.IsStart = true>
			<cfset inicio.ProcessId = new_process.ProcessId>
			<cfset inicio.ReadOnly = true>
			<cfset inicio.SymbolData = 'x=64,y=64'>
			<cfset inicio.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="VoBo" />
			<cfset VoBo.Name = 'VoBo'>
			<cfset VoBo.Description = 'VoBo'>
			<cfset VoBo.ProcessId = new_process.ProcessId>
			<cfset VoBo.SymbolData = 'x=256,y=64'>
			<cfset VoBo.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="rechazado" />
			<cfset rechazado.Name = 'Rechazado'>
			<cfset rechazado.Description = 'Rechazado'>
			<cfset rechazado.IsFinish = true>
			<cfset rechazado.ProcessId = new_process.ProcessId>
			<cfset rechazado.ReadOnly = true>
			<cfset rechazado.SymbolData = 'x=576,y=88'>
			<cfset rechazado.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="aprobado" />
			<cfset aprobado.Name = 'Aprobado'>
			<cfset aprobado.Description = 'Aprobado'>
			<cfset aprobado.IsFinish = true>
			<cfset aprobado.ProcessId = new_process.ProcessId>
			<cfset aprobado.ReadOnly = true>
			<cfset aprobado.SymbolData = 'x=576,y=32'>
			<cfset aprobado.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = inicio.ActivityId>
			<cfset transicion_1.ToActivity   = VoBo.ActivityId>
			<cfset transicion_1.Name         = 'Comenzar'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = aprobado.ActivityId>
			<cfset transicion_1.Name         = 'ACEPTAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = rechazado.ActivityId>
			<cfset transicion_1.Name         = 'RECHAZAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('ESidsolicitud', 'Número de solicitud')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('ID Solicitud', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Ecodigo', 'Código de Empresa')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Empresa', true)>
			<cfset datafield_1.update()>

            <cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('EcodigoExtra', 'Empresa Admin')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Empresa Admin', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Descripcion', 'Descripcion')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('Descripcion', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Proveedor', 'Proveedor')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('Proveedor', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Total', 'Total de la solicitud')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('Total', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfApplication" method="init" returnvariable="application_1" />
			<cfset application_1.ProcessId = new_process.ProcessId>
			<cfset application_1.setName ('CM_AplicaSolicitud', 'Ejecuta la aplicación de una solicitud de compra')>
			<cfset application_1.Type = 'CFC'>
			<cfset application_1.Location = 'sif.Componentes.CM_AplicaSolicitud'>
			<cfset application_1.Documentation = 'Aplica una solicitud de Compra'>
			<cfset application_1.Command = 'CM_AplicaSolicitud_WorkFlow'>
			<cfset application_1.update()>
			<cfset application_1.addFormalParameter(1, 'Ecodigo', 'Empresa', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(2, 'ESidsolicitud', 'Número de acción', 'NUMERIC', 'IN')>
            <cfset application_1.addFormalParameter(3, 'EcodigoExtra', 'Empresa Administradora', 'NUMERIC', 'IN')>

			<cfinvoke component="WfInvocation" method="init" returnvariable="invocation_1" />
			<cfset invocation_1.ActivityId = aprobado.ActivityId>
			<cfset invocation_1.ProcessId = new_process.ProcessId>
			<cfset invocation_1.ApplicationName = application_1.ApplicationName>
			<cfset invocation_1.update()>

			<cfset invocation_1.addActualParameter('Ecodigo', 'NUMERIC', '', 'Ecodigo')>
			<cfset invocation_1.addActualParameter('ESidsolicitud', 'NUMERIC', '', 'ESidsolicitud')>
            <cfset invocation_1.addActualParameter('EcodigoExtra', 'NUMERIC', '', 'EcodigoExtra')>

			<cfinvoke component="WfApplication" method="init" returnvariable="application_2" />
			<cfset application_2.ProcessId = new_process.ProcessId>
			<cfset application_2.setName ('CM_RechazaSolicitud', 'Ejecuta el rechazo de una solicitud de compra')>
			<cfset application_2.Type = 'CFC'>
			<cfset application_2.Location = 'sif.Componentes.CM_AplicaSolicitud'>
			<cfset application_2.Documentation = 'Rechaza una solicitud de Compra'>
			<cfset application_2.Command = 'CM_RechazaSolicitud'>
			<cfset application_2.update()>
			<cfset application_2.addFormalParameter(1, 'Ecodigo', 'Empresa', 'NUMERIC', 'IN')>
			<cfset application_2.addFormalParameter(2, 'ESidsolicitud', 'Número de acción', 'NUMERIC', 'IN')>

			<cfinvoke component="WfInvocation" method="init" returnvariable="invocation_1" />
			<cfset invocation_1.ActivityId = rechazado.ActivityId>
			<cfset invocation_1.ProcessId = new_process.ProcessId>
			<cfset invocation_1.ApplicationName = application_2.ApplicationName>
			<cfset invocation_1.update()>

			<cfset invocation_1.addActualParameter('Ecodigo', 'NUMERIC', '', 'Ecodigo')>
			<cfset invocation_1.addActualParameter('ESidsolicitud', 'NUMERIC', '', 'ESidsolicitud')>

		</cftransaction>
		<cfreturn new_process.ProcessId>
	</cffunction>

	<cffunction name="CrearCN" returntype="numeric" access="public">
		<cfset Pkg = CrearPkg('CN')>
		<cftransaction>
			<cfinvoke component="WfProcess" method="init" returnvariable="new_process" />
			<cfset new_process.PackageId = Pkg.PackageId>
			<cfset new_process.DetailURL = '/sif/cm/operacion/ContratoSolicitud.cfm?Ecodigo=##Ecodigo##&ECid=##ECId##'>
			<cfset new_process.Description = 'Nuevo trámite de Contratos'>
			<cfset new_process.DetailURL = ''>
			<cfset new_process.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="inicio" />
			<cfset inicio.Name = 'Inicio'>
			<cfset inicio.Description = 'Inicio'>
			<cfset inicio.IsStart = true>
			<cfset inicio.ProcessId = new_process.ProcessId>
			<cfset inicio.ReadOnly = true>
			<cfset inicio.SymbolData = 'x=64,y=64'>
			<cfset inicio.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="VoBo" />
			<cfset VoBo.Name = 'VoBo'>
			<cfset VoBo.Description = 'VoBo'>
			<cfset VoBo.ProcessId = new_process.ProcessId>
			<cfset VoBo.SymbolData = 'x=256,y=64'>
			<cfset VoBo.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="rechazado" />
			<cfset rechazado.Name = 'Rechazado'>
			<cfset rechazado.Description = 'Rechazado'>
			<cfset rechazado.IsFinish = true>
			<cfset rechazado.ProcessId = new_process.ProcessId>
			<cfset rechazado.ReadOnly = true>
			<cfset rechazado.SymbolData = 'x=576,y=88'>
			<cfset rechazado.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="aprobado" />
			<cfset aprobado.Name = 'Aprobado'>
			<cfset aprobado.Description = 'Aprobado'>
			<cfset aprobado.IsFinish = true>
			<cfset aprobado.ProcessId = new_process.ProcessId>
			<cfset aprobado.ReadOnly = true>
			<cfset aprobado.SymbolData = 'x=576,y=32'>
			<cfset aprobado.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = inicio.ActivityId>
			<cfset transicion_1.ToActivity   = VoBo.ActivityId>
			<cfset transicion_1.Name         = 'Comenzar'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = aprobado.ActivityId>
			<cfset transicion_1.Name         = 'ACEPTAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = rechazado.ActivityId>
			<cfset transicion_1.Name         = 'RECHAZAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('ECId', 'Número de solicitud')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('ID Contrato', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Ecodigo', 'Código de Empresa')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Empresa', true)>
			<cfset datafield_1.update()>

            <cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('ECestado', 'Estatus')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Estatus', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Descripcion', 'Descripcion')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('Descripcion', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfApplication" method="init" returnvariable="application_1" />
			<cfset application_1.ProcessId = new_process.ProcessId>
			<cfset application_1.setName ('Contrato', 'Ejecuta la Actualización del contrato')>
			<cfset application_1.Type = 'CFC'>
			<cfset application_1.Location = 'sif.Componentes.Contrato'>
			<cfset application_1.Documentation = 'Actualiza el status de un contrato'>
			<cfset application_1.Command = 'setEstado'>
			<cfset application_1.update()>
			<cfset application_1.addFormalParameter(1, 'Ecodigo', 'Empresa', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(2, 'ECId', 'Número de Contrato', 'NUMERIC', 'IN')>
            <cfset application_1.addFormalParameter(3, 'ECestado', 'Nuevo Estatus', 'NUMERIC', 'IN')>

			<cfinvoke component="WfInvocation" method="init" returnvariable="invocation_1" />
			<cfset invocation_1.ActivityId = aprobado.ActivityId>
			<cfset invocation_1.ProcessId = new_process.ProcessId>
			<cfset invocation_1.ApplicationName = application_1.ApplicationName>
			<cfset invocation_1.update()>

			<cfset invocation_1.addActualParameter('Ecodigo', 'NUMERIC', '', 'Ecodigo')>
			<cfset invocation_1.addActualParameter('ECId', 'NUMERIC', '', 'ECId')>
            <cfset invocation_1.addActualParameter('ECestado', 'NUMERIC', 2, 'ECestado')>

			<cfinvoke component="WfApplication" method="init" returnvariable="application_2" />
			<cfset application_2.ProcessId = new_process.ProcessId>
			<cfset application_2.setName ('Contrato', 'Ejecuta el rechazo de un contrato')>
			<cfset application_2.Type = 'CFC'>
			<cfset application_2.Location = 'sif.Componentes.Contrato'>
			<cfset application_2.Documentation = 'Rechaza un contrato'>
			<cfset application_2.Command = 'setEstado'>
			<cfset application_2.update()>
			<cfset application_1.addFormalParameter(1, 'Ecodigo', 'Empresa', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(2, 'ECId', 'Número de Contrato', 'NUMERIC', 'IN')>
            <cfset application_1.addFormalParameter(3, 'ECestado', 'Nuevo Estatus', 'NUMERIC', 'IN')>

			<cfinvoke component="WfInvocation" method="init" returnvariable="invocation_1" />
			<cfset invocation_1.ActivityId = rechazado.ActivityId>
			<cfset invocation_1.ProcessId = new_process.ProcessId>
			<cfset invocation_1.ApplicationName = application_2.ApplicationName>
			<cfset invocation_1.update()>

			<cfset invocation_1.addActualParameter('Ecodigo', 'NUMERIC', '', 'Ecodigo')>
			<cfset invocation_1.addActualParameter('ECId', 'NUMERIC', '', 'ECId')>
            <cfset invocation_1.addActualParameter('ECestado', 'NUMERIC', 3, 'ECestado')>

		</cftransaction>
		<cfreturn new_process.ProcessId>
	</cffunction>

	<cffunction name="CrearRHPP" returntype="numeric" access="public">
		<cfset Pkg = CrearPkg('RHPP')>
		<cftransaction>
			<cfinvoke component="WfProcess" method="init" returnvariable="new_process" />
			<cfset new_process.PackageId = Pkg.PackageId>
			<cfset new_process.Description = 'Nuevo trámite de Planilla Presupuestaria'>
			<cfset new_process.DetailURL = ''>
			<cfset new_process.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="inicio" />
			<cfset inicio.Name = 'Inicio'>
			<cfset inicio.Description = 'Inicio'>
			<cfset inicio.IsStart = true>
			<cfset inicio.ProcessId = new_process.ProcessId>
			<cfset inicio.ReadOnly = true>
			<cfset inicio.SymbolData = 'x=64,y=64'>
			<cfset inicio.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="VoBo" />
			<cfset VoBo.Name = 'VoBo'>
			<cfset VoBo.Description = 'VoBo'>
			<cfset VoBo.ProcessId = new_process.ProcessId>
			<cfset VoBo.SymbolData = 'x=256,y=64'>
			<cfset VoBo.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="rechazado" />
			<cfset rechazado.Name = 'Rechazado'>
			<cfset rechazado.Description = 'Rechazado'>
			<cfset rechazado.IsFinish = true>
			<cfset rechazado.ProcessId = new_process.ProcessId>
			<cfset rechazado.ReadOnly = true>
			<cfset rechazado.SymbolData = 'x=576,y=88'>
			<cfset rechazado.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="aprobado" />
			<cfset aprobado.Name = 'Aprobado'>
			<cfset aprobado.Description = 'Aprobado'>
			<cfset aprobado.IsFinish = true>
			<cfset aprobado.ProcessId = new_process.ProcessId>
			<cfset aprobado.ReadOnly = true>
			<cfset aprobado.SymbolData = 'x=576,y=32'>
			<cfset aprobado.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = inicio.ActivityId>
			<cfset transicion_1.ToActivity   = VoBo.ActivityId>
			<cfset transicion_1.Name         = 'Comenzar'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = aprobado.ActivityId>
			<cfset transicion_1.Name         = 'ACEPTAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = rechazado.ActivityId>
			<cfset transicion_1.Name         = 'RECHAZAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('RHMPid', 'Número del Movimiento')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Movimiento', true)>
			<cfset datafield_1.update()>

			<!---
			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('RHPPid', 'ID de Plaza Presupuestaria')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Plaza Presupuestaria', true)>
			<cfset datafield_1.update()>
			--->

			<!---
			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('RHPPcodigo', 'Código de Plaza Presupuestaria')>
			<cfset datafield_1.setType   ('STRING', 10)>
			<cfset datafield_1.setLabel  ('Código de Plaza Presupuestaria', true)>
			<cfset datafield_1.update()>
			--->

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Ecodigo', 'Código de Empresa')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Empresa', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Usucodigo', 'Usuario que inicia trámite')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Usuario(id)', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfApplication" method="init" returnvariable="application_1" />
			<cfset application_1.setName ('AplicaMovimientoPlaza', 'Ejecuta la aplicación de un Movimiento de Plaza')>
			<cfset application_1.Type = 'CFC'>
			<cfset application_1.Location = 'rh.Componentes.RH_AplicaMovimientoPlaza'>
			<cfset application_1.Documentation = 'Aplica el Movimiento (Invoca el Componente)'>
			<cfset application_1.Command = 'AplicaMovimientoPlaza'>
			<cfset application_1.update()>
			<cfset application_1.addFormalParameter(1, 'Ecodigo', 'Empresa', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(2, 'RHMPid', 'Número de Movimiento', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(3, 'Usucodigo', 'Usuario que invoca', 'NUMERIC', 'IN')>

			<cfinvoke component="WfInvocation" method="init" returnvariable="invocation_1" />
			<cfset invocation_1.ActivityId = aprobado.ActivityId>
			<cfset invocation_1.ProcessId = new_process.ProcessId>
			<cfset invocation_1.ApplicationName = application_1.ApplicationName>
			<cfset invocation_1.update()>

			<cfset invocation_1.addActualParameter('Ecodigo', 'NUMERIC', '', 'Ecodigo')>
			<cfset invocation_1.addActualParameter('RHMPid', 'NUMERIC', '', 'RHMPid')>
			<cfset invocation_1.addActualParameter('Usucodigo', 'NUMERIC', '', 'Usucodigo')>
		</cftransaction>
		<cfreturn new_process.ProcessId>
	</cffunction>

	<cffunction name="CrearTESSP" returntype="numeric" access="public">
		<cfset Pkg = CrearPkg('TESSP')>
		<cftransaction>
			<cfinvoke component="WfProcess" method="init" returnvariable="new_process" />
			<cfset new_process.PackageId = Pkg.PackageId>
			<cfset new_process.Description = 'Nuevo trámite de Solicitud de Pago'>
			<cfset new_process.DetailURL = '/sif/tesoreria/Solicitudes/TramiteSolicitudP.cfm?Ecodigo=##Ecodigo##&TESSPid=##TESSPid##&TipoSol=##TipoSol##'>
			<cfset new_process.DoneURL   = '/sif/tesoreria/Solicitudes/TramiteSolicitudPTerminado.cfm?Ecodigo=##Ecodigo##&TESSPid=##TESSPid##&TipoSol=##TipoSol##'>
			<cfset new_process.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="inicio" />
			<cfset inicio.Name = 'Inicio'>
			<cfset inicio.Description = 'Inicio'>
			<cfset inicio.IsStart = true>
			<cfset inicio.ProcessId = new_process.ProcessId>
			<cfset inicio.ReadOnly = true>
			<cfset inicio.SymbolData = 'x=64,y=64'>
			<cfset inicio.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="VoBo" />
			<cfset VoBo.Name = 'VoBo'>
			<cfset VoBo.Description = 'VoBo'>
			<cfset VoBo.ProcessId = new_process.ProcessId>
			<cfset VoBo.SymbolData = 'x=256,y=64'>
			<cfset VoBo.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="rechazado" />
			<cfset rechazado.Name = 'Rechazado'>
			<cfset rechazado.Description = 'Rechazado'>
			<cfset rechazado.IsFinish = true>
			<cfset rechazado.ProcessId = new_process.ProcessId>
			<cfset rechazado.ReadOnly = true>
			<cfset rechazado.SymbolData = 'x=576,y=88'>
			<cfset rechazado.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="aprobado" />
			<cfset aprobado.Name = 'Aprobado'>
			<cfset aprobado.Description = 'Aprobado'>
			<cfset aprobado.IsFinish = true>
			<cfset aprobado.ProcessId = new_process.ProcessId>
			<cfset aprobado.ReadOnly = true>
			<cfset aprobado.SymbolData = 'x=576,y=32'>
			<cfset aprobado.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = inicio.ActivityId>
			<cfset transicion_1.ToActivity   = VoBo.ActivityId>
			<cfset transicion_1.Name         = 'Comenzar'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = aprobado.ActivityId>
			<cfset transicion_1.Name         = 'ACEPTAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId      = new_process.ProcessId>
			<cfset transicion_1.FromActivity   = VoBo.ActivityId>
			<cfset transicion_1.ToActivity     = rechazado.ActivityId>
			<cfset transicion_1.Name           = 'RECHAZAR'>
			<cfset transicion_1.AskForComments = true>
			<cfset transicion_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('TESSPid', 'Número de Solicitud de Pago')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('ID Solicitud Pago', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('SPid', 'Número_de_solicitud')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('ID Solicitud', true)>
			<cfset datafield_1.update()>


			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('TipoSol', 'Tipo_de_solicitud')>
			<cfset datafield_1.setType   ('STRING', 20)>
			<cfset datafield_1.setLabel  ('Tipo Solicitud', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('fechaPagoDMY', 'Fecha_Pago')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('Fecha_Pago', true)>
			<cfset datafield_1.update()>


			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('PRES_Origen', 'PRES_Origen')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('PRES_Origen', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('PRES_Documento', 'PRES_Documento')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('PRES_Documento', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('PRES_Referencia', 'PRES_Referencia')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('PRES_Referencia', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('TESOPid', 'Número de Orden Pago')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('ID Orden Pago', true)>
			<cfset datafield_1.update()>


			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Ecodigo', 'Código de Empresa')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Empresa', true)>
			<cfset datafield_1.update()>


			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('TESSPmsgRechazo', 'Motivo de Rechazo')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('Rechazo', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfApplication" method="init" returnvariable="application_1" />
			<cfset application_1.setName ('AprobarSP', 'Ejecuta la aplicación de una solicitud de Pago')>
			<cfset application_1.Type = 'CFC'>
			<cfset application_1.Location = 'sif.tesoreria.Componentes.TESaplicacion'>
			<cfset application_1.Documentation = 'Aplica una Solicitud de Pago'>
			<cfset application_1.Command = 'sbAprobarSP_Workflow'>
			<cfset application_1.update()>
		    <cfset application_1.addFormalParameter(1, 'SPid'        	 , 'Número_de_solicitud'	, 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(2, 'fechaPagoDMY' 	 , 'Fecha_Pago'				, 'STRING' , 'IN')>
			<cfset application_1.addFormalParameter(3, 'PRES_Origen' 	 , 'PRES_Origen'				, 'STRING' , 'IN')>
			<cfset application_1.addFormalParameter(4, 'PRES_Documento'  , 'PRES_Documento'			, 'STRING' , 'IN')>
			<cfset application_1.addFormalParameter(5, 'PRES_Referencia' , 'PRES_Referencia'			, 'STRING' , 'IN')>

			<cfinvoke component="WfInvocation" method="init" returnvariable="invocation_1" />
			<cfset invocation_1.ActivityId = aprobado.ActivityId>
			<cfset invocation_1.ProcessId = new_process.ProcessId>
			<cfset invocation_1.ApplicationName = application_1.ApplicationName>
			<cfset invocation_1.update()>

			<cfset invocation_1.addActualParameter('SPid'				, 'NUMERIC', '', 'TESSPid')>
			<cfset invocation_1.addActualParameter('fechaPagoDMY' 	, 'STRING' , '', 'fechaPagoDMY')>
			<cfset invocation_1.addActualParameter('PRES_Origen' 		, 'STRING' , '', 'PRES_Origen')>
			<cfset invocation_1.addActualParameter('PRES_Documento' 	, 'STRING' , '', 'PRES_Documento')>
			<cfset invocation_1.addActualParameter('PRES_Referencia' , 'STRING' , '', 'PRES_Referencia')>

			<cfinvoke component="WfApplication" method="init" returnvariable="application_2" />
			<cfset application_2.ProcessId = new_process.ProcessId>
			<cfset application_2.setName ('AnularSP', 'Ejecuta el rechazo de una solicitud de Pago')>
			<cfset application_2.Type = 'CFC'>
			<cfset application_2.Location = 'sif.tesoreria.Componentes.TESaplicacion'>
			<cfset application_2.Documentation = 'Rechaza una solicitud de Pago'>
			<cfset application_2.Command = 'sbAnularSP'>
			<cfset application_2.update()>
				<cfset application_2.addFormalParameter(1, 'TESSPid'			, 'Numero Solicitud Pago', 'NUMERIC', 'IN')>
				<cfset application_2.addFormalParameter(2, 'Ecodigo'			, 'Empresa'					 , 'NUMERIC', 'IN')>
				<cfset application_2.addFormalParameter(3, 'TESSPmsgRechazo', 'Motivo Rechazo'		 , 'STRING', 'IN')>

			<cfinvoke component="WfInvocation" method="init" returnvariable="invocation_1" />
			<cfset invocation_1.ActivityId = rechazado.ActivityId>
			<cfset invocation_1.ProcessId = new_process.ProcessId>
			<cfset invocation_1.ApplicationName = application_2.ApplicationName>
			<cfset invocation_1.update()>

			<cfset invocation_1.addActualParameter('TESSPid'			, 'NUMERIC', '', 'TESSPid')>
    		<cfset invocation_1.addActualParameter('Ecodigo'			, 'NUMERIC', '', 'Ecodigo')>
    		<cfset invocation_1.addActualParameter('TESSPmsgRechazo' , 'STRING', '', 'TESSPmsgRechazo')>
		</cftransaction>
		<cfreturn new_process.ProcessId>
	</cffunction>

	<!---Traslados de presupuesto --->
		<cffunction name="CrearTPRES" returntype="numeric" access="public">
		<cfset Pkg = CrearPkg('TPRES', true)>
		<cftransaction>
			<cfinvoke component="WfProcess" method="init" returnvariable="new_process" />
			<cfset new_process.PackageId = Pkg.PackageId>
			<cfset new_process.Description = 'Nuevo Trámite para Traslados de Presupuesto'>
			<cfset new_process.DetailURL = '/sif/presupuesto/traslados/WfConsultar.cfm?Ecodigo=##Ecodigo##&CPDEid=##CPDEid##'>
			<cfset new_process.DoneURL   = '/sif/Presupuesto/traslados/WfFinalizar.cfm?Ecodigo=##Ecodigo##&CPDEid=##CPDEid##'>
			<cfset new_process.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="inicio" />
			<cfset inicio.Name = 'Inicio'>
			<cfset inicio.Description = 'Inicio'>
			<cfset inicio.IsStart = true>
			<cfset inicio.ProcessId = new_process.ProcessId>
			<cfset inicio.ReadOnly = true>
			<cfset inicio.SymbolData = 'x=64,y=64'>
			<cfset inicio.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="VoBo" />
			<cfset VoBo.Name = 'VoBo'>
			<cfset VoBo.Description = 'VoBo'>
			<cfset VoBo.ProcessId = new_process.ProcessId>
			<cfset VoBo.SymbolData = 'x=256,y=64'>
			<cfset VoBo.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="rechazado" />
			<cfset rechazado.Name = 'Rechazado'>
			<cfset rechazado.Description = 'Rechazado'>
			<cfset rechazado.IsFinish = true>
			<cfset rechazado.ProcessId = new_process.ProcessId>
			<cfset rechazado.ReadOnly = true>
			<cfset rechazado.SymbolData = 'x=576,y=88'>
			<cfset rechazado.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="aprobado" />
			<cfset aprobado.Name = 'Aprobado'>
			<cfset aprobado.Description = 'Aprobado'>
			<cfset aprobado.IsFinish = true>
			<cfset aprobado.ProcessId = new_process.ProcessId>
			<cfset aprobado.ReadOnly = true>
			<cfset aprobado.SymbolData = 'x=576,y=32'>
			<cfset aprobado.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = inicio.ActivityId>
			<cfset transicion_1.ToActivity   = VoBo.ActivityId>
			<cfset transicion_1.Name         = 'Comenzar'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = aprobado.ActivityId>
			<cfset transicion_1.Name         = 'ACEPTAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId      = new_process.ProcessId>
			<cfset transicion_1.FromActivity   = VoBo.ActivityId>
			<cfset transicion_1.ToActivity     = rechazado.ActivityId>
			<cfset transicion_1.AskForComments = true>
			<cfset transicion_1.Name           = 'RECHAZAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('CPDEid', 'Número Traslado-Presup')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('ID Tras-Presup', true)>
			<cfset datafield_1.update()>

<!---			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('SPid', 'Número_de_solicitud')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('ID Solicitud', true)>
			<cfset datafield_1.update()>


			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('TipoSol', 'Tipo_de_solicitud')>
			<cfset datafield_1.setType   ('STRING', 20)>
			<cfset datafield_1.setLabel  ('Tipo Solicitud', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('fechaPagoDMY', 'Fecha_Pago')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('Fecha_Pago', true)>
			<cfset datafield_1.update()>


			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('PRES_Origen', 'PRES_Origen')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('PRES_Origen', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('PRES_Documento', 'PRES_Documento')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('PRES_Documento', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('PRES_Referencia', 'PRES_Referencia')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('PRES_Referencia', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('TESOPid', 'Número de Orden Pago')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('ID Orden Pago', true)>
			<cfset datafield_1.update()>
--->

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Ecodigo', 'Código de Empresa')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Empresa', true)>
			<cfset datafield_1.update()>


			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('CPDEmsgRechazo', 'Motivo de Rechazo')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('Rechazo', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfApplication" method="init" returnvariable="application_1" />
			<cfset application_1.setName ('AprobarTraslado', 'Ejecuta la aplicación de un Traslado-Presupuesto')>
			<cfset application_1.Type = 'CFC'>
			<cfset application_1.Location = 'sif.presupuesto.Componentes.PRES_Traslados'>
			<cfset application_1.Documentation = 'Aplica un Traslado-Presupuesto'>
			<cfset application_1.Command = 'AprobarTraslado'>
			<cfset application_1.update()>
		   <cfset application_1.addFormalParameter(1, 'CPDEid' , 'Número_de_Traslado_Pres'	, 'NUMERIC', 'IN')>


			<cfinvoke component="WfInvocation" method="init" returnvariable="invocation_1" />
			<cfset invocation_1.ActivityId = aprobado.ActivityId>
			<cfset invocation_1.ProcessId = new_process.ProcessId>
			<cfset invocation_1.ApplicationName = application_1.ApplicationName>
			<cfset invocation_1.update()>
			<cfset invocation_1.addActualParameter('CPDEid'	, 'NUMERIC', '', 'CPDEid')>

			<cfinvoke component="WfApplication" method="init" returnvariable="application_2" />
			<cfset application_2.ProcessId = new_process.ProcessId>
			<cfset application_2.setName ('RechazarTraslado', 'Ejecuta el rechazo del traslado-Presupuesto')>
			<cfset application_2.Type = 'CFC'>
			<cfset application_2.Location = 'sif.presupuesto.Componentes.PRES_Traslados'>
			<cfset application_2.Documentation = 'Rechaza un Traslado-Presupuesto'>
			<cfset application_2.Command = 'RechazarTraslado'>
			<cfset application_2.update()>
				<cfset application_2.addFormalParameter(1, 'CPDEid'			, 'Numero Traslado-Presupuesto', 'NUMERIC', 'IN')>
				<cfset application_2.addFormalParameter(2, 'Ecodigo'			, 'Empresa'								 , 'NUMERIC', 'IN')>
				<cfset application_2.addFormalParameter(3, 'CPDEmsgRechazo' , 'Motivo Rechazo'		 			 , 'STRING', 'IN')>

			<cfinvoke component="WfInvocation" method="init" returnvariable="invocation_1" />
			<cfset invocation_1.ActivityId = rechazado.ActivityId>
			<cfset invocation_1.ProcessId = new_process.ProcessId>
			<cfset invocation_1.ApplicationName = application_2.ApplicationName>
			<cfset invocation_1.update()>

			<cfset invocation_1.addActualParameter('CPDEid'				, 'NUMERIC', '', 'CPDEid')>
    		<cfset invocation_1.addActualParameter('Ecodigo'			, 'NUMERIC', '', 'Ecodigo')>
    		<cfset invocation_1.addActualParameter('CPDEmsgRechazo'  , 'STRING', '', 'CPDEmsgRechazo')>
		</cftransaction>
		<cfreturn new_process.ProcessId>
	</cffunction>
	<!--- --->


	<cffunction name="CrearDMIG" returntype="numeric" access="public">
		<cfset Pkg = CrearPkg('DMIG')>

		<cftransaction>
			<cfinvoke component="WfProcess" method="init" returnvariable="new_process" />
			<cfset new_process.PackageId = Pkg.PackageId>
			<cfset new_process.Description = 'Nuevo Trámite de Aprobación de Dato'>
			<cfset new_process.DetailURL = '/mig/catalogos/FDatos.cfm?DEid=##DEid##&ID_Datos=##ID_Datos##&MIGMid=##MIGMid##&Cambio=&tipo=1'>
			<cfset new_process.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="inicio" />
			<cfset inicio.Name = 'Inicio'>
			<cfset inicio.Description = 'Inicio'>
			<cfset inicio.IsStart = true>
			<cfset inicio.ProcessId = new_process.ProcessId>
			<cfset inicio.ReadOnly = true>
			<cfset inicio.SymbolData = 'x=64,y=64'>
			<cfset inicio.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="VoBo" />
			<cfset VoBo.Name = 'VoBo'>
			<cfset VoBo.Description = 'VoBo'>
			<cfset VoBo.ProcessId = new_process.ProcessId>
			<cfset VoBo.SymbolData = 'x=256,y=64'>
			<cfset VoBo.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="rechazado" />
			<cfset rechazado.Name = 'Rechazado'>
			<cfset rechazado.Description = 'Rechazado'>
			<cfset rechazado.IsFinish = true>
			<cfset rechazado.ProcessId = new_process.ProcessId>
			<cfset rechazado.ReadOnly = true>
			<cfset rechazado.SymbolData = 'x=576,y=88'>
			<cfset rechazado.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="aprobado" />
			<cfset aprobado.Name = 'Aprobado'>
			<cfset aprobado.Description = 'Aprobado'>
			<cfset aprobado.IsFinish = true>
			<cfset aprobado.ProcessId = new_process.ProcessId>
			<cfset aprobado.ReadOnly = true>
			<cfset aprobado.SymbolData = 'x=576,y=32'>
			<cfset aprobado.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = inicio.ActivityId>
			<cfset transicion_1.ToActivity   = VoBo.ActivityId>
			<cfset transicion_1.Name         = 'Comenzar'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = aprobado.ActivityId>
			<cfset transicion_1.Name         = 'ACEPTAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = rechazado.ActivityId>
			<cfset transicion_1.Name         = 'RECHAZAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('DEid', 'Número de empleado')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Empleado', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Ecodigo', 'Código de Empresa')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Empresa', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('DEnombre', 'Nombre de empleado')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('Nombre', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('MIGMid', 'ID Metrica')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Metrica', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('ID_Datos', 'ID Dato Variable')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Dato', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('ProcessInstanceId', 'ID del proceso')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Dato', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Usucodigo', 'Usuario que inicia trámite')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Usuario(id)', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfApplication" method="init" returnvariable="application_1" />
			<cfset application_1.setName ('ApruebaDatos', 'Ejecuta la aprobacion de los Datos')>
			<cfset application_1.Type = 'CFC'>
			<cfset application_1.Location = 'mig.Componentes.FDatos'>
			<cfset application_1.Documentation = 'Ejecuta un llamado al procedimiento que aprueba los datos'>
			<cfset application_1.Command = 'ApruebaDatos'>
			<cfset application_1.update()>
			<cfset application_1.addFormalParameter(1, 'Ecodigo', 'Empresa', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(2, 'ID_Datos', 'Número de dato', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(2, 'ProcessInstanceId', 'Número de dato', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(3, 'MIGMid', 'Número de metrica', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(4, 'Usucodigo', 'Usuario que invoca', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(5, 'Ulocalizacion', 'Usuario que invoca', 'STRING', 'IN')>

			<cfinvoke component="WfInvocation" method="init" returnvariable="invocation_1" />
			<cfset invocation_1.ActivityId = aprobado.ActivityId>
			<cfset invocation_1.ProcessId = new_process.ProcessId>
			<cfset invocation_1.ApplicationName = application_1.ApplicationName>
			<cfset invocation_1.update()>

			<cfset invocation_1.addActualParameter('Ecodigo', 'NUMERIC', '', 'Ecodigo')>
			<cfset invocation_1.addActualParameter('ID_Datos', 'NUMERIC', '', 'ID_Datos')>
			<cfset invocation_1.addActualParameter('ProcessInstanceId', 'NUMERIC', '', 'ProcessInstanceId')>
			<cfset invocation_1.addActualParameter('MIGMid', 'NUMERIC', '', 'MIGMid')>
			<cfset invocation_1.addActualParameter('Usucodigo', 'NUMERIC', '', 'Usucodigo')>
			<cfset invocation_1.addActualParameter('Ulocalizacion', 'NUMERIC', '00')>

			<cfinvoke component="WfApplication" method="init" returnvariable="application_2" />
			<cfset application_2.setName ('RechazaDatos', 'Ejecuta la rexhazo de los Datos')>
			<cfset application_2.Type = 'CFC'>
			<cfset application_2.Location = 'mig.Componentes.FDatos'>
			<cfset application_2.Documentation = 'Ejecuta un llamado al procedimiento que rechazo de los datos'>
			<cfset application_2.Command = 'RechazaDatos'>
			<cfset application_2.update()>
			<cfset application_2.addFormalParameter(1, 'Ecodigo', 'Empresa', 'NUMERIC', 'IN')>
			<cfset application_2.addFormalParameter(2, 'ID_Datos', 'Número de dato', 'NUMERIC', 'IN')>
			<cfset application_2.addFormalParameter(2, 'ProcessInstanceId', 'Número de proceso', 'NUMERIC', 'IN')>
			<cfset application_2.addFormalParameter(3, 'MIGMid', 'Número de metrica', 'NUMERIC', 'IN')>
			<cfset application_2.addFormalParameter(4, 'Usucodigo', 'Usuario que invoca', 'NUMERIC', 'IN')>
			<cfset application_2.addFormalParameter(5, 'Ulocalizacion', 'Usuario que invoca', 'STRING', 'IN')>

			<cfinvoke component="WfInvocation" method="init" returnvariable="invocation_2" />
			<cfset invocation_2.ActivityId = rechazado.ActivityId>
			<cfset invocation_2.ProcessId = new_process.ProcessId>
			<cfset invocation_2.ApplicationName = application_2.ApplicationName>
			<cfset invocation_2.update()>

			<cfset invocation_2.addActualParameter('Ecodigo', 'NUMERIC', '', 'Ecodigo')>
			<cfset invocation_2.addActualParameter('ID_Datos', 'NUMERIC', '', 'ID_Datos')>
			<cfset invocation_2.addActualParameter('ProcessInstanceId', 'NUMERIC', '', 'ProcessInstanceId')>
			<cfset invocation_2.addActualParameter('MIGMid', 'NUMERIC', '', 'MIGMid')>
			<cfset invocation_2.addActualParameter('Usucodigo', 'NUMERIC', '', 'Usucodigo')>
			<cfset invocation_2.addActualParameter('Ulocalizacion', 'NUMERIC', '00')>

		</cftransaction>

		<cfreturn new_process.ProcessId>
	</cffunction>


	<cffunction name="CrearMMIG" returntype="numeric" access="public">
		<cfset Pkg = CrearPkg('MMIG')>
		<cftransaction>
			<cfinvoke component="WfProcess" method="init" returnvariable="new_process" />
			<cfset new_process.PackageId = Pkg.PackageId>
			<cfset new_process.Description = 'Nuevo Trámite de Aprobación de Métrica'>
			<cfset new_process.DetailURL = '/mig/catalogos/Metricas.cfm?DEid=##DEid##&MIGMid=##MIGMid##&Cambio=&tipo=1'><!---/rh/nomina/operacion/tramites/ConsultaAcciones.cfm?DEid=##DEid##&RHAlinea=##RHAlinea##&Cambio=&tipo=1--->
			<cfset new_process.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="inicio" />
			<cfset inicio.Name = 'Inicio'>
			<cfset inicio.Description = 'Inicio'>
			<cfset inicio.IsStart = true>
			<cfset inicio.ProcessId = new_process.ProcessId>
			<cfset inicio.ReadOnly = true>
			<cfset inicio.SymbolData = 'x=64,y=64'>
			<cfset inicio.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="VoBo" />
			<cfset VoBo.Name = 'VoBo'>
			<cfset VoBo.Description = 'VoBo'>
			<cfset VoBo.ProcessId = new_process.ProcessId>
			<cfset VoBo.SymbolData = 'x=256,y=64'>
			<cfset VoBo.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="rechazado" />
			<cfset rechazado.Name = 'Rechazado'>
			<cfset rechazado.Description = 'Rechazado'>
			<cfset rechazado.IsFinish = true>
			<cfset rechazado.ProcessId = new_process.ProcessId>
			<cfset rechazado.ReadOnly = true>
			<cfset rechazado.SymbolData = 'x=576,y=88'>
			<cfset rechazado.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="aprobado" />
			<cfset aprobado.Name = 'Aprobado'>
			<cfset aprobado.Description = 'Aprobado'>
			<cfset aprobado.IsFinish = true>
			<cfset aprobado.ProcessId = new_process.ProcessId>
			<cfset aprobado.ReadOnly = true>
			<cfset aprobado.SymbolData = 'x=576,y=32'>
			<cfset aprobado.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = inicio.ActivityId>
			<cfset transicion_1.ToActivity   = VoBo.ActivityId>
			<cfset transicion_1.Name         = 'Comenzar'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = aprobado.ActivityId>
			<cfset transicion_1.Name         = 'ACEPTAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = rechazado.ActivityId>
			<cfset transicion_1.Name         = 'RECHAZAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('DEid', 'Número de empleado')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Empleado', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Ecodigo', 'Código de Empresa')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Empresa', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('DEnombre', 'Nombre de empleado')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('Nombre', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('MIGMid', 'ID Metrica')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Metrica', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Usucodigo', 'Usuario que inicia trámite')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Usuario(id)', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfApplication" method="init" returnvariable="application_1" />
			<cfset application_1.setName ('ApruebaMetrica', 'Ejecuta la aprobacion de una métrica')>
			<cfset application_1.Type = 'CFC'>
			<cfset application_1.Location = 'Componentes.Metricas'>
			<cfset application_1.Documentation = 'Ejecuta un llamado al procedimiento que aprueba una métrica'>
			<cfset application_1.Command = 'ApruebaMetrica'>
			<cfset application_1.update()>
			<cfset application_1.addFormalParameter(1, 'Ecodigo', 'Empresa', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(2, 'MIGMid', 'Número de metrica', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(3, 'Usucodigo', 'Usuario que invoca', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(4, 'Ulocalizacion', 'Usuario que invoca', 'STRING', 'IN')>

			<cfinvoke component="WfInvocation" method="init" returnvariable="invocation_1" />
			<cfset invocation_1.ActivityId = aprobado.ActivityId>
			<cfset invocation_1.ProcessId = new_process.ProcessId>
			<cfset invocation_1.ApplicationName = application_1.ApplicationName>
			<cfset invocation_1.update()>

			<cfset invocation_1.addActualParameter('Ecodigo', 'NUMERIC', '', 'Ecodigo')>
			<cfset invocation_1.addActualParameter('MIGMid', 'NUMERIC', '', 'MIGMid')>
			<cfset invocation_1.addActualParameter('Usucodigo', 'NUMERIC', '', 'Usucodigo')>
			<cfset invocation_1.addActualParameter('Ulocalizacion', 'NUMERIC', '00')>
		</cftransaction>
		<cfreturn new_process.ProcessId>
	</cffunction>

	<cffunction name="CrearIMIG" returntype="numeric" access="public">
		<cfset Pkg = CrearPkg('IMIG')>
		<cftransaction>
			<cfinvoke component="WfProcess" method="init" returnvariable="new_process" />
			<cfset new_process.PackageId = Pkg.PackageId>
			<cfset new_process.Description = 'Nuevo Trámite de Aprobación de Indicador'>
			<cfset new_process.DetailURL = '/mig/catalogos/Indicadores.cfm?DEid=##DEid##&MIGMid=##MIGMid##&Cambio=&tipo=1'><!---/rh/nomina/operacion/tramites/ConsultaAcciones.cfm?DEid=##DEid##&RHAlinea=##RHAlinea##&Cambio=&tipo=1--->
			<cfset new_process.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="inicio" />
			<cfset inicio.Name = 'Inicio'>
			<cfset inicio.Description = 'Inicio'>
			<cfset inicio.IsStart = true>
			<cfset inicio.ProcessId = new_process.ProcessId>
			<cfset inicio.ReadOnly = true>
			<cfset inicio.SymbolData = 'x=64,y=64'>
			<cfset inicio.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="VoBo" />
			<cfset VoBo.Name = 'VoBo'>
			<cfset VoBo.Description = 'VoBo'>
			<cfset VoBo.ProcessId = new_process.ProcessId>
			<cfset VoBo.SymbolData = 'x=256,y=64'>
			<cfset VoBo.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="rechazado" />
			<cfset rechazado.Name = 'Rechazado'>
			<cfset rechazado.Description = 'Rechazado'>
			<cfset rechazado.IsFinish = true>
			<cfset rechazado.ProcessId = new_process.ProcessId>
			<cfset rechazado.ReadOnly = true>
			<cfset rechazado.SymbolData = 'x=576,y=88'>
			<cfset rechazado.update()>

			<cfinvoke component="WfActivity" method="init" returnvariable="aprobado" />
			<cfset aprobado.Name = 'Aprobado'>
			<cfset aprobado.Description = 'Aprobado'>
			<cfset aprobado.IsFinish = true>
			<cfset aprobado.ProcessId = new_process.ProcessId>
			<cfset aprobado.ReadOnly = true>
			<cfset aprobado.SymbolData = 'x=576,y=32'>
			<cfset aprobado.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = inicio.ActivityId>
			<cfset transicion_1.ToActivity   = VoBo.ActivityId>
			<cfset transicion_1.Name         = 'Comenzar'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = aprobado.ActivityId>
			<cfset transicion_1.Name         = 'ACEPTAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfTransition" method="init" returnvariable="transicion_1" />
			<cfset transicion_1.ProcessId    = new_process.ProcessId>
			<cfset transicion_1.FromActivity = VoBo.ActivityId>
			<cfset transicion_1.ToActivity   = rechazado.ActivityId>
			<cfset transicion_1.Name         = 'RECHAZAR'>
			<cfset transicion_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('DEid', 'Número de empleado')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Empleado', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Ecodigo', 'Código de Empresa')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Empresa', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('DEnombre', 'Nombre de empleado')>
			<cfset datafield_1.setType   ('STRING', 40)>
			<cfset datafield_1.setLabel  ('Nombre', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('MIGMid', 'ID Indicador')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Indicador', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfDataField" method="init" returnvariable="datafield_1" />
			<cfset datafield_1.ProcessId   = new_process.ProcessId>
			<cfset datafield_1.setName   ('Usucodigo', 'Usuario que inicia trámite')>
			<cfset datafield_1.setType   ('NUMERIC', 18)>
			<cfset datafield_1.setLabel  ('Usuario(id)', true)>
			<cfset datafield_1.update()>

			<cfinvoke component="WfApplication" method="init" returnvariable="application_1" />
			<cfset application_1.setName ('ApruebaIndicador', 'Ejecuta la Aprobación del Indicador')>
			<cfset application_1.Type = 'CFC'>
			<cfset application_1.Location = 'Componentes.Indicadores'>
			<cfset application_1.Documentation = 'Ejecuta un llamado al procedimiento que aprueba al indicador'>
			<cfset application_1.Command = 'ApruebaIndicador'>
			<cfset application_1.update()>
			<cfset application_1.addFormalParameter(1, 'Ecodigo', 'Empresa', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(2, 'MIGMid', 'Número de indicador', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(3, 'Usucodigo', 'Usuario que invoca', 'NUMERIC', 'IN')>
			<cfset application_1.addFormalParameter(4, 'Ulocalizacion', 'Usuario que invoca', 'STRING', 'IN')>

			<cfinvoke component="WfInvocation" method="init" returnvariable="invocation_1" />
			<cfset invocation_1.ActivityId = aprobado.ActivityId>
			<cfset invocation_1.ProcessId = new_process.ProcessId>
			<cfset invocation_1.ApplicationName = application_1.ApplicationName>
			<cfset invocation_1.update()>

			<cfset invocation_1.addActualParameter('Ecodigo', 'NUMERIC', '', 'Ecodigo')>
			<cfset invocation_1.addActualParameter('MIGMid', 'NUMERIC', '', 'MIGMid')>
			<cfset invocation_1.addActualParameter('Usucodigo', 'NUMERIC', '', 'Usucodigo')>
			<cfset invocation_1.addActualParameter('Ulocalizacion', 'NUMERIC', '00')>
		</cftransaction>
		<cfreturn new_process.ProcessId>
	</cffunction>

</cfcomponent>