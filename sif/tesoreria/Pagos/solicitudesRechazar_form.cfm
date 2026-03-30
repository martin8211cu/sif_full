<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 01 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Rechazo de Solicitudes de Pago en Tesorería
----------->

<cfinvoke key="MSG_TesDeOtraEmpresa" default="La empresa no es administradora de esta Tesorería"	returnvariable="MSG_TesDeOtraEmpresa"	method="Translate" component="sif.Componentes.Translate"  xmlfile="/sif/tesoreria\solicitudes\Pagos\solicitudesAprobar.xml"/> 

<cfparam name="form.TESSPid" default="">

<cfquery name="rsSQL" datasource="#session.dsn#">
	Select t.TESid
	  from Tesoreria t
	 where t.EcodigoAdm	= #session.Ecodigo#
	   and t.TESid 		= #session.Tesoreria.TESid#
</cfquery>
<cfif rsSQL.recordCount EQ 0>
	<cf_errorCode	code = "50753" msg = "MSG_TesDeOtraEmpresa">
</cfif>

<cfset LvarRechazoTesoreria = true>
<cfinclude template="../Solicitudes/solicitudesAprobar_form.cfm">


