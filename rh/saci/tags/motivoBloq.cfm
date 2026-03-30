<cfparam	name="Attributes.id"			type="string"	default="">						<!--- Id de Pais --->
<cfparam 	name="Attributes.form" 			type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.sufijo" 		type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.Ecodigo" 		type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 		type="string"	default="#Session.DSN#">		<!--- cache de conexion --->
<cfparam 	name="Attributes.readOnly" 		type="boolean"	default="false">				<!--- solo de lectura, es obligatorio el id --->
<cfparam 	name="Attributes.sinCompromiso" type="integer"	default="-1">					<!--- Indica si se muestran los motivos sin compromiso --->
<cfparam 	name="Attributes.conCompromiso" type="integer"	default="-1">					<!--- Indica si se muestran los motivos con compromiso --->
<cfparam 	name="Attributes.BloqueablePorPantalla" type="integer"	default="-1">					<!--- filtra por MBbloqueable si es <> -1 --->

<cfset ExisteMotivo = (isdefined("Attributes.id") and Len(Trim(Attributes.id)))>

<cfif Attributes.readOnly and not ExisteMotivo>
	<cfthrow message="Error: para utilizar el atributo de readOnly se requiere enviar el atributo id para el motivo del bloqueo">
</cfif>

<cfif Attributes.readOnly>
	<cfquery name="rsReadOnly" datasource="#Attributes.Conexion#">
		Select MBmotivo
			,MBdescripcion 
			, MBconCompromiso
			, MBsinCompromiso			
		from ISBmotivoBloqueo 
		where MBmotivo=<cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.id#"> 
			and Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#"> 
			<cfif Attributes.sinCompromiso neq "-1">
				and MBsinCompromiso = <cfqueryparam cfsqltype="cf_sql_bit" value="#Attributes.sinCompromiso#"> 
			</cfif>
			<cfif Attributes.conCompromiso neq "-1">
				and MBconCompromiso = <cfqueryparam cfsqltype="cf_sql_bit" value="#Attributes.conCompromiso#"> 
			</cfif>
			<cfif Attributes.BloqueablePorPantalla neq "-1">
				and MBbloqueable = <cfqueryparam cfsqltype="cf_sql_bit" value="#Attributes.BloqueablePorPantalla#"> 
			</cfif>
		order by MBdescripcion		
	</cfquery>
	<cfoutput>
		<cfif isdefined("rsReadOnly") and Len(Trim(rsReadOnly.Ppais))>
			#rsReadOnly.MBdescripcion#
		<cfelse>
			&lt;No Especificado&gt;
		</cfif>
	</cfoutput>
<cfelse>
	<cfquery name="rsMotivos" datasource="#Attributes.Conexion#">
		Select MBmotivo,MBdescripcion 
		from ISBmotivoBloqueo 
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			<cfif Attributes.sinCompromiso neq "-1">
				and MBsinCompromiso = <cfqueryparam cfsqltype="cf_sql_bit" value="#Attributes.sinCompromiso#"> 
			</cfif>
			<cfif Attributes.conCompromiso neq "-1">
				and MBconCompromiso = <cfqueryparam cfsqltype="cf_sql_bit" value="#Attributes.conCompromiso#"> 
			</cfif>
			<cfif Attributes.BloqueablePorPantalla neq "-1">
				and MBbloqueable = <cfqueryparam cfsqltype="cf_sql_bit" value="#Attributes.BloqueablePorPantalla#"> 
			</cfif>
		order by MBdescripcion	
	</cfquery>

	<cfoutput>
		<select name="MBmotivo#Attributes.sufijo#" tabindex="1">
			<cfloop query="rsMotivos">
		  		<option value="#rsMotivos.MBmotivo#"<cfif Len(Trim(Attributes.id)) and trim(rsMotivos.MBmotivo) eq trim(Attributes.id)> selected</cfif>>#rsMotivos.MBdescripcion#</option>
			</cfloop>
		</select>
	</cfoutput>
</cfif>