<cfparam	name="Attributes.numero"				type="string"		default="">							<!--- Numero Visible del Sobre --->
<cfparam	name="Attributes.agente"				type="string"		default="">							<!--- Nombre del campo que contiene el Id de Agente por el cual se van a filtrar los sobres ofrecidos --->
<cfparam 	name="Attributes.form" 					type="string"		default="form1">					<!--- nombre del formulario --->
<cfparam 	name="Attributes.size" 					type="string"		default="20">						<!--- tamaño del campo --->
<cfparam 	name="Attributes.sufijo" 				type="string"		default="">							<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.funcion" 				type="string"		default="">							<!--- funcion a invocar despues de seleccionar en el conlis --->
<cfparam 	name="Attributes.responsable" 			type="string"		default="0">						<!--- Indica donde esta el sobre --->
<cfparam 	name="Attributes.mostrarNoAsignados"	type="boolean"		default="false">					<!--- Indica si se van a mostrar solamente los sobres que todavia no se han asignado a un login --->
<cfparam 	name="Attributes.Ecodigo" 				type="string"		default="#Session.Ecodigo#">		<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 				type="string"		default="#Session.DSN#">			<!--- cache de conexion --->
<cfparam 	name="Attributes.readOnly" 				type="boolean"		default="false">						<!--- propiedad read Only para el tag--->
<cfset ExisteSobre = (isdefined("Attributes.numero") and Len(Trim(Attributes.numero)))>

<cfif ExisteSobre>
	<cfquery name="rsSobre" datasource="#Attributes.Conexion#">
		select a.Snumero, 
			   a.Sestado, 
			   a.Sdonde, 
			   a.SpwdAcceso, 
			   a.SpwdCorreo, 
			   a.LGnumero, 
			   a.AGid, 
			   a.Ecodigo, 
			   a.BMUsucodigo, 
			   a.ts_rversion
		from ISBsobres a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
		and a.Snumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Attributes.numero#">
	</cfquery>
	<cfset ExisteSobre = (rsSobre.recordCount GT 0)>
</cfif>

<cfset array = ArrayNew(1)>
<cfif ExisteSobre>
<!--- pinta el conlis con valores del registro seleccionado --->
<!--- Arreglo que guarda los datos del registro que fue seleccionado del conlis para que no se pierda su valor al hacer submit --->
	<cfset temp = ArraySet(array, 1, 1, "")>
	<cfset array[1] = rsSobre.Snumero>
</cfif>

<cfset filtro = "">
<cfif Len(Trim(Attributes.agente))>
	<cfset filtro = filtro & " and a.AGid = $#Attributes.agente#,numeric$">
</cfif>
<cfif Attributes.mostrarNoAsignados>
	<cfif ExisteSobre>
		<!--- Este filtro para que cuando venga el sobre aunque este asignado sí me aparezca en el conlis para poder volverlo a seleccionar --->
		<cfset filtro = filtro & " and (a.Snumero = #Attributes.numero# or a.LGnumero is null)">
	<cfelse>
		<cfset filtro = filtro & " and a.LGnumero is null">
	</cfif>
</cfif>
<cfif Attributes.responsable is '0'>
	<!--- está en la empresa: Racsa corresponde al agente 199
		El valor "0" normalmente no está en Sdonde, ya que los sobres
		desde el momento en que se crean y entran por la interfaz, vienen
		asignados a un agente.
	--->
	<cfset filtro = filtro & " and ( a.Sdonde = '0' or a.Sdonde = '1' and a.AGid = 199 ) ">
<cfelse>
	<cfset filtro = filtro & " and a.Sdonde = '#Attributes.responsable#' ">
</cfif>

<!--- 
	Unicamente se muestran los sobres que están inactivos
	Los sobres activos y nulos no se muestran
--->
<cfif Attributes.readOnly>
		<cfif ExisteSobre><cfoutput>#rsSobre.Snumero#</cfoutput></cfif>
<cfelse>
	<cf_conlis 
		title="Sobres de Acceso"
		campos = "Snumero#Attributes.sufijo#" 
		desplegables = "S" 
		modificables = "S"
		size = "#Attributes.size#"
		tabla="ISBsobres a"
		columnas="a.Snumero as Snumero#Attributes.sufijo#"
		desplegar="Snumero#Attributes.sufijo#"
		filtro="a.Ecodigo = #Attributes.Ecodigo#
				and a.Sestado = '0'
				#preservesinglequotes(filtro)#
				order by a.Snumero"
		filtrar_por="Snumero"
		etiquetas="No. Sobre"
		formatos="S"
		align="left"
		asignar="Snumero#Attributes.sufijo#"
		asignarformatos="S"
		funcion="#Attributes.funcion#"
		Form="#Attributes.form#"
		Conexion="#Attributes.Conexion#"
		valuesArray="#array#"
		closeOnExit="true"
		tabindex="1"
	>
</cfif>
