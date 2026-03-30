<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 01 de junio del 2005
	Motivo:	Nueva opción para Módulo de Tesorería, 
			Rechazo de Solicitudes de Pago en Tesorería
----------->

<cfparam name="form.TESSPid" default="">

<cfquery name="rsSQL" datasource="#session.dsn#">
	Select t.TESid
	  from Tesoreria t
	 where t.EcodigoAdm	= #session.Ecodigo#
	   and t.TESid 		= #session.Tesoreria.TESid#
</cfquery>
<cfif rsSQL.recordCount EQ 0>
	<cf_errorCode	code = "50753" msg = "La empresa no es administradora de esta Tesorería">
</cfif>

<cfset LvarCambioTesoreria = true>
<cfinclude template="../Solicitudes/solicitudesAprobar_form.cfm">


