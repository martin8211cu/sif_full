<!---
	Vistas
	1: Vista del Vendedor en el Registro del Cliente
	2: Vista del Facturador y Agente en Modo Consulta
	3: Vista del DSO en el Registro del Agente

--->
<cfparam	name="Attributes.id"				type="string"	default="">						<!--- Id de Cuenta --->
<cfparam	name="Attributes.idpersona"			type="string"	default="">						<!--- Id de la Persona que posee el contrato --->
<cfparam	name="Attributes.idcontrato"		type="string"	default="">						<!--- Id de un contrato seleccionado dentro de la cuenta --->
<cfparam	name="Attributes.filtroAgente"		type="string"	default="">						<!--- Nombre del campo que contiene el Id de Agente por el cual se van a filtrar los paquetes y sobres --->
<cfparam 	name="Attributes.form" 				type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.alignEtiquetas" 	type="string"	default="right">				<!--- alineación de etiquetas --->
<cfparam 	name="Attributes.cobrable" 			type="boolean"	default="true">					<!--- para indicar si es un registro de cuentas cobrables --->
<cfparam 	name="Attributes.paso" 				type="integer"	default="0">					<!--- paso para la creación de cuentas --->
<cfparam 	name="Attributes.vista" 			type="integer"	default="1">					<!--- para definir el conjunto de condiciones para el pintado de la venta de servicios --->
<cfparam 	name="Attributes.porfila" 			type="boolean"	default="false">				<!--- para pintar los campos en una sola columna vertical --->
<cfparam 	name="Attributes.Ecodigo" 			type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 			type="string"	default="#Session.DSN#">		<!--- cache de conexión --->
<cfparam 	name="Attributes.readOnly" 			type="boolean"	default="false">				<!--- propiedad read Only para el tag, en este caso es obligatorio el query--->
<cfparam 	name="Attributes.sufijo" 			type="string"	default="">						<!--- Indice por si el tag necesita ser pintado varias veces en una pantalla--->
<cfparam 	name="Attributes.mens" 				type="string"	default="">						<!--- Mensaje que se desea pintar en el tag--->

<cfparam 	name="Attributes.RefId" 			type="string"	default="-1">					<!--- Referecia de Pquien / AGid / CTid para localizacion--->
<cfparam 	name="Attributes.Ltipo" 			type="string"	default="P">					<!--- Uso de Localidad, P=persona, A=Agente, C=Cuenta--->

<cfset ExisteCuenta = (isdefined("Attributes.id") and Len(Trim(Attributes.id)) and isdefined("Attributes.idpersona") and Len(Trim(Attributes.idpersona)))>
<cfset ExisteContrato = (ExisteCuenta and isdefined("Attributes.idcontrato") and Len(Trim(Attributes.idcontrato)))>
<cfset rsAllContratos = QueryNew('undefined')>


<cfset mens = ArrayNew(1)>													<!--- Arreglo de mensajes de error o exito --->
<cfset a = ArraySet(mens, 1,12, "")>
<cfset mens[1] = "Se activaron con éxito los servicios.">

<cfif len(trim(Attributes.mens))>
	<cfoutput><center><label style="color:##FF0000">#mens[1]#</label></center></cfoutput>
</cfif>

<cfif ExisteCuenta>
	<cfquery name="rsCuenta" datasource="#Attributes.Conexion#">
		select a.CTid, a.Pquien, a.CUECUE, a.ECidEstado, a.CTapertura, a.CTdesde, a.CThasta, a.CTcobrable, 
			   a.CTrefComision, a.CCclaseCuenta, a.GCcodigo, a.CTmodificacion, a.CTpagaImpuestos, a.Habilitado, 
			   a.CTobservaciones, a.CTtipoUso, a.CTcomision, a.BMUsucodigo, a.ts_rversion
		from ISBcuenta a
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
		and a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idpersona#">
	</cfquery>

	<cfif rsCuenta.CTtipoUso EQ 'A'>
		<cfquery name="rsDatosAgente" datasource="#Session.DSN#">
			select b.CUECUE
			from ISBagente a
				inner join ISBcuenta b
					on b.CTid = a.CTidFactura
			where a.Pquien = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Pquien#">
			and a.CTidAcceso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CTid#">
		</cfquery>
		<cfif rsDatosAgente.recordCount GT 0>
			<cfset LvarFacturacionCUECUE = rsDatosAgente.CUECUE>
		</cfif>
	</cfif>
	
</cfif>

<cfif ExisteContrato>
	<cfquery name="rsContrato" datasource="#Attributes.Conexion#">
		select a.Contratoid, a.CTid, a.CTidFactura, a.PQcodigo, a.Vid, a.VPNid, a.CTcondicion, a.CNsubestado, 
			   a.CNsuscriptor, a.CNnumero, a.CNapertura, a.CNconsultar, a.BMUsucodigo, a.ts_rversion
		from ISBproducto a
		where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.id#">
		and a.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.idcontrato#">
	</cfquery>
</cfif>

<cfswitch expression="#Attributes.paso#">
	
	<!--- Configuración de Servicios --->
	<cfcase value="0">
		<cfinclude template="cuenta-seleccion.cfm">
	</cfcase>
	
	<!--- Consultar de Servicios --->
	<cfcase value="1">
		<cfinclude template="cuenta-servicios.cfm">
	</cfcase>

	<!--- Mecanismo de Envío --->
	<cfcase value="2">
		<cfinclude template="cuenta-envio.cfm">
	</cfcase>
	
	<!--- Forma de Cobro --->
	<cfcase value="3">
		<cfinclude template="cuenta-cobro.cfm">
	</cfcase>

	<!--- Depósito de Garantía --->	
	<cfcase value="4">
		<cfinclude template="cuenta-garantia.cfm">
	</cfcase>
	
	<!--- Comprobar Información --->
	<cfcase value="5">
		<cfinclude template="cuenta-resumen.cfm">
	</cfcase>
	
	<!--- Activar Servicio--->
	<cfcase value="6">
		<cfinclude template="cuenta-resumen.cfm">
	</cfcase>

	<!--- Imprimir Información --->
	<cfcase value="7">
		<cfinclude template="cuenta-imprimir.cfm">
	</cfcase>

	<cfdefaultcase>
		&nbsp;
	</cfdefaultcase>

</cfswitch>
<br />
