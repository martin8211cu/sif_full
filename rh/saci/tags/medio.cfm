<cfparam	name="Attributes.id"				type="string"	default="">					<!--- Id de referencia del medio --->
<cfparam 	name="Attributes.form" 				type="string"	default="form1">			<!--- nombre del formulario --->
<cfparam 	name="Attributes.sufijo" 			type="string"	default="">					<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.funcion" 			type="string"	default="">					<!--- funcion a invocar despues de seleccionar en el conlis --->
<cfparam 	name="Attributes.MDbloqueado"		type="integer"	default="-1">				<!--- Estado del medio 1.Bloqueado, 0.Desbloqueado, -1.Todos --->
<cfparam 	name="Attributes.Ecodigo" 			type="string"	default="#Session.Ecodigo#"><!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 			type="string"	default="#Session.DSN#">	<!--- cache de conexión --->
<cfparam 	name="Attributes.readOnly" 			type="boolean"	default="false">			<!--- se usa para indicar si se muestra en modo consulta --->

<cfset ExisteMedio = (isdefined("Attributes.id") and Len(Trim(Attributes.id)))>

<cfif ExisteMedio>
	<cfquery name="rsMedio" datasource="#Attributes.Conexion#">
		Select MDref
			, EMid
			, MDbloqueado
			, Habilitado
			, MDlimite
			, MBmotivo
			, case MDbloqueado
				when 1 then 'SI'
				when 0 then 'NO'
			end descMDbloqueado			
		from ISBmedio
		where MDref=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Attributes.id#">	
	</cfquery>
	<cfset ExisteMedio = (rsMedio.recordCount GT 0)>
</cfif>

<table width="100%" cellpadding="2" cellspacing="0" border="0">
	<tr><td>
		
		<cfset array = ArrayNew(1)>
		
		<cfif ExisteMedio>
			<cfset temp = ArraySet(array, 1,7, "")>
			<cfset array[1] = rsMedio.Habilitado>			
			<cfset array[2] = rsMedio.MDbloqueado>			
			<cfset array[3] = rsMedio.MDref>	
			<cfset array[4] = rsMedio.MDlimite>		
			<cfset array[5] = rsMedio.MBmotivo>					
			<cfset array[6] = rsMedio.descMDbloqueado>								
			<cfset array[7] = rsMedio.EMid>	
		</cfif>
		
		<cfquery name="rsHabil" datasource="#Attributes.Conexion#">
				select -1 as value, '--Todas--' as description
			union 						
				select 1 as value, 'SI' as description				
			union 						
				select 0 as value, 'NO' as description				
				
				order by value
		</cfquery>		
		<cfset filtro = "">
		<cfif Attributes.MDbloqueado NEQ -1>
			<cfif Attributes.MDbloqueado EQ 1>
				<cfset filtro = " and a.MDbloqueado=1">
			<cfelseif Attributes.MDbloqueado EQ 0>
				<cfset filtro = " and a.MDbloqueado=0">
			</cfif>
		</cfif>
		
		<cf_conlis 
			title="Medios"
			campos = "Habilitado,MDbloqueado,MDref,MDlimite,MBmotivo,descMDbloqueado,EMid" 
			desplegables = "N,N,S,N,N,N,N" 
			modificables = "N,N,S,N,N,N,N"
			size = "0,0,30,0,0,0,0"
			tabla = "ISBmedio a"
			columnas = "a.Habilitado
				,a.MDbloqueado
				,a.MDref
				,a.MDlimite
				,a.MBmotivo
				, case a.MDbloqueado
					when 1 then 'SI'
					when 0 then 'NO'
				end descMDbloqueado
				,EMid" 
			desplegar = "MDref"
			filtro = "1=1 #filtro#"
			rsdescMDbloqueado = "#rsHabil#"
			filtrar_por_array = "#ListToArray('a.MDref|a.MDlimite|descMDbloqueado','|')#"
			etiquetas = "Telefono"
			formatos = "S"
			align = "left"
			asignar = "Habilitado,MDbloqueado,MDref,MDlimite,MBmotivo,EMid"
			asignarformatos = "I,I,S,I,S,I"
			Form = "#Attributes.form#"
			Conexion = "#Attributes.Conexion#"
			funcion = "#Attributes.funcion#"
			valuesArray="#array#"
			closeOnExit="true"
			tabindex="1"
			permiteNuevo="true"
		>
	</td></tr>
</table>