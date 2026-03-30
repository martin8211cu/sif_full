<cfparam name="session.WfPackageBaseName" type="string">
<cfparam name="form.Plantilla" type="string" default="">

<cfif Len(session.WfPackageBaseName)>
	<cfset form.Plantilla = session.WfPackageBaseName>
</cfif>

<cfif Len(form.Plantilla)>
	<cfinvoke component="sif.Componentes.Workflow.plantillas" method="Crear#form.Plantilla#" returnvariable="ProcessId" />
	<cflocation url="process.cfm?ProcessId=#ProcessId#">
<cfelse>
	<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_EspecifiqueElTipoDeTramiteQueDeseaCrear"
			Default="Especifique el tipo de trámite que desea crear"
			returnvariable="MSG_EspecifiqueElTipoDeTramiteQueDeseaCrear"/>
	<cfthrow message="#MSG_EspecifiqueElTipoDeTramiteQueDeseaCrear#">
</cfif>

