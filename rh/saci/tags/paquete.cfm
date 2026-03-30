<cfparam	name="Attributes.id"				type="string"	default="">						<!--- Id de Paquete --->

<cfparam	name="Attributes.agente"			type="string"	default="">						<!--- Nombre del campo que contiene el Id de Agente por el cual se van a filtrar los paquetes ofrecidos --->
<cfparam 	name="Attributes.form" 				type="string"	default="form1">				<!--- nombre del formulario --->
<cfparam 	name="Attributes.sizeDes" 			type="string"	default="40">					<!--- Largo de los Inputs --->
<cfparam 	name="Attributes.sizeCod" 			type="string"	default="5">					<!--- Largo de los Inputs --->
<cfparam 	name="Attributes.readOnly" 			type="boolean"	default="false">				<!--- Propiedad para hacer los campos del tag readOnly --->
<cfparam 	name="Attributes.permInterfaz"		type="integer"	default="0">					<!--- Permite o no mostrar solo los paquetes que no son de interfaz, solo recibe 0,1 --->
<cfparam 	name="Attributes.sufijo" 			type="string"	default="">						<!--- sufijo a agregar en todos los campos, se usa en caso de que se use varias veces el mismo tag en la misma pantalla --->
<cfparam 	name="Attributes.funcion" 			type="string"	default="">						<!--- funcion a invocar despues de seleccionar en el conlis --->
<cfparam 	name="Attributes.Ecodigo" 			type="string"	default="#Session.Ecodigo#">	<!--- código de empresa --->
<cfparam 	name="Attributes.Conexion" 			type="string"	default="#Session.DSN#">		<!--- cache de conexion --->
<cfparam 	name="Attributes.idCambioPaquete" 	type="string"	default="">						<!--- id de Paquete Fuente, si viene este paquete, deben filtrarse los paquetes a los cuales puede cambiar --->
<cfparam 	name="Attributes.filtroPaqInterfaz" type="string"	default="">						<!--- Filtro para el campo de PQinterfaz, si no viene, no se filtra por ese campo, si viene un valor únicamente se aceptara 0 o 1 --->
<cfparam 	name="Attributes.PQutilizadoagente" type="boolean"	default="false">						<!--- Filtro para mostrar paquetes que cumplan solo con PQutilizadoagente = 1 en true o todos si entra en false --->
<cfparam 	name="Attributes.ShowCodigo" 		type="string"	default="true">					<!--- Despleagar o no el codigo del paquete--->


<cfif Attributes.readOnly and Len(Trim(Attributes.id)) EQ 0>
	<cfthrow message="Para utilizar el atributo readOnly el atributo de id es requerido.">
</cfif>

<cfset ExistePaquete = (isdefined("Attributes.id") and Len(Trim(Attributes.id)))>

<cfquery name="rsServiciosDisponibles" datasource="#Attributes.Conexion#">
	select TScodigo
	from ISBservicioTipo
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
	order by TScodigo
</cfquery>

<cfif ExistePaquete>
	<cfquery name="rsPaquete" datasource="#Attributes.Conexion#">
		select distinct a.PQcodigo, a.Miso4217, a.MRidMayorista, a.PQnombre, a.PQdescripcion, a.PQinicio, a.PQcierre, 
				  a.PQcomisionTipo, a.PQcomisionPctj, a.PQcomisionMnto, a.PQtoleranciaGarantia, a.PQtarifaBasica, 
				  a.PQcompromiso, a.PQhorasBasica, a.PQprecioExc, a.Habilitado, a.PQroaming, a.PQtelefono,
				  coalesce(a.PQmailQuota, 0) as PQmailQuota, a.PQinterfaz, a.BMUsucodigo, a.ts_rversion, 
			   (select sum(SVcantidad) from ISBservicio x where x.PQcodigo = a.PQcodigo and x.TScodigo = 'MAIL' and x.Habilitado = 1) as CantidadCorreos,
			   (select coalesce(sum(SVcantidad),0) from ISBservicio x where x.PQcodigo = a.PQcodigo and x.TScodigo = 'CABM' and x.Habilitado = 1) as CantidadCable
			   <cfloop query="rsServiciosDisponibles">
			   , coalesce((select sum(x.SVcantidad) from ISBservicio x where x.PQcodigo = a.PQcodigo and x.TScodigo = '#Trim(rsServiciosDisponibles.TScodigo)#' and x.Habilitado = 1), 0) as Cantidad_#Trim(rsServiciosDisponibles.TScodigo)#
			   , coalesce((select sum(x.SVminimo) from ISBservicio x where x.PQcodigo = a.PQcodigo and x.TScodigo = '#Trim(rsServiciosDisponibles.TScodigo)#' and x.Habilitado = 1), 0) as CantidadMin_#Trim(rsServiciosDisponibles.TScodigo)#
			   </cfloop>
		from ISBpaquete a
			inner join ISBservicio s
				on s.PQcodigo=a.PQcodigo		
		where a.PQcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Attributes.id#">
		and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Attributes.Ecodigo#">
		and a.Habilitado = 1
	</cfquery>
</cfif>

<cfset array = ArrayNew(1)>
<cfif ExistePaquete>
<!--- pinta el conlis con valores del registro seleccionado --->
<!--- Arreglo que guarda los datos del registro que fue seleccionado del conlis para que no se pierda su valor al hacer submit --->
	<!---<cfset temp = ArraySet(array, 1,8+rsServiciosDisponibles.recordCount*2, "")>--->
	<cfset array[1] = rsPaquete.PQcodigo>
	<cfset array[2] = rsPaquete.PQdescripcion>
	<cfset array[3] = LSNumberFormat(rsPaquete.PQtarifaBasica,',9.00')>
	<cfset array[4] = LSNumberFormat(rsPaquete.PQhorasBasica,',9.00')>
	<cfset array[5] = LSNumberFormat(rsPaquete.PQprecioExc,',9.00')>
	<cfset array[6] = LSNumberFormat(rsPaquete.PQmailQuota,',9.00')>
	<cfset array[7] = rsPaquete.PQtelefono>
	<cfset array[8] = rsPaquete.CantidadCorreos>
	<cfset array[9] = rsPaquete.CantidadCable>
	<cfloop query="rsServiciosDisponibles">
		<cfset array[ArrayLen(array)+1] = Evaluate('rsPaquete.Cantidad_'&Trim(rsServiciosDisponibles.TScodigo))>
		<cfset array[ArrayLen(array)+1] = Evaluate('rsPaquete.CantidadMin_'&Trim(rsServiciosDisponibles.TScodigo))>
	</cfloop>
	<cfset temp = ArrayLen(array)>
</cfif>

<cfif Attributes.readOnly>
	<cfoutput>
	<input name="PQcodigo#Attributes.sufijo#" type="hidden" value="#array[1]#" />
	<input name="PQnombre#Attributes.sufijo#" type="hidden" value="#array[2]#" />
	<input name="vPQtarifaBasica#Attributes.sufijo#" type="hidden" value="#array[3]#" />
	<input name="vPQhorasBasica#Attributes.sufijo#" type="hidden" value="#array[4]#" />
	<input name="vPQprecioExc#Attributes.sufijo#" type="hidden" value="#array[5]#" />
	<input name="vPQmailQuota#Attributes.sufijo#" type="hidden" value="#array[6]#" />
	<input name="vPQtelefono#Attributes.sufijo#" type="hidden" value="#array[7]#" />
	<input name="vCantidadCorreos#Attributes.sufijo#" type="hidden" value="#array[8]#" />
	<input name="vCantidadCable#Attributes.sufijo#" type="hidden" value="#array[9]#" />	
	<cfloop query="rsServiciosDisponibles">
		<input name="vCantidad_#Trim(rsServiciosDisponibles.TScodigo)##Attributes.sufijo#" type="hidden" value="#Evaluate('rsPaquete.Cantidad_'&Trim(rsServiciosDisponibles.TScodigo))#" />
		<input name="vCantidadM_#Trim(rsServiciosDisponibles.TScodigo)##Attributes.sufijo#" type="hidden" value="#Evaluate('rsPaquete.CantidadMin_'&Trim(rsServiciosDisponibles.TScodigo))#" />	
	</cfloop>
		#trim(array[2])#
	</cfoutput>	
<cfelse>
	<cfset camposAdic = "">
	<cfset despAdic = "">
	<cfset modAdic = "">
	<cfset sizeAdic = "">
	<cfset colsAdic = "">
	<cfset asigAdic = "">
	<cfset asigFAdic = "">
	<cfset filtroAdic = "">
	<cfloop query="rsServiciosDisponibles">
		<cfset camposAdic = camposAdic & ", vCantidad_#Trim(rsServiciosDisponibles.TScodigo)##Attributes.sufijo#">
		<cfset camposAdic = camposAdic & ", vCantidadM_#Trim(rsServiciosDisponibles.TScodigo)##Attributes.sufijo#">
		<cfset despAdic = despAdic & ",N,N">
		<cfset modAdic = modAdic & ",N,N">
		<cfset sizeAdic = sizeAdic & ",0,0">
		<cfset colsAdic = colsAdic & ", coalesce((select sum(x.SVcantidad) from ISBservicio x where x.PQcodigo = b.PQcodigo and x.TScodigo = '#Trim(rsServiciosDisponibles.TScodigo)#' and x.Habilitado = 1), 0) as vCantidad_#Trim(rsServiciosDisponibles.TScodigo)##Attributes.sufijo#">
		<cfset colsAdic = colsAdic & ", coalesce((select sum(x.SVminimo) from ISBservicio x where x.PQcodigo = b.PQcodigo and x.TScodigo = '#Trim(rsServiciosDisponibles.TScodigo)#' and x.Habilitado = 1), 0) as vCantidadM_#Trim(rsServiciosDisponibles.TScodigo)##Attributes.sufijo#">	
		<cfset asigAdic = asigAdic & ", vCantidad_#Trim(rsServiciosDisponibles.TScodigo)##Attributes.sufijo#">
		<cfset asigAdic = asigAdic & ", vCantidadM_#Trim(rsServiciosDisponibles.TScodigo)##Attributes.sufijo#">
		<cfset asigFAdic = asigFAdic & ",S,S">
	</cfloop>
	<cfif isdefined("Attributes.filtroPaqInterfaz") and Len(Trim(Attributes.filtroPaqInterfaz))>
		<cfset filtroAdic = " and b.PQinterfaz = #Attributes.filtroPaqInterfaz#">
	</cfif>
	<cfif isdefined("Attributes.idCambioPaquete") and Len(Trim(Attributes.idCambioPaquete))>
		<cfset filtroAdic = " and exists (select 1 from ISBpaqueteCambio x where x.PQcodDesde = '#Attributes.idCambioPaquete#' and x.PQcodHacia = b.PQcodigo)">
	</cfif>

	
	<!--- Paquetes que puede vender un agente --->
	<cfif Len(Trim(Attributes.agente))>
		<cfset LvarTabla = "ISBagenteOferta a 
								inner join ISBpaquete b
									on b.PQcodigo = a.PQcodigo
									and b.Ecodigo = #Attributes.Ecodigo#
									and b.Habilitado = 1
									and b.PQinterfaz = #Attributes.permInterfaz#
									#preserveSingleQuotes(filtroAdic)#
								inner join ISBservicio s
									on s.PQcodigo=b.PQcodigo">
									
									

		<cfset LvarFiltro = "a.AGid = $#Attributes.agente#,numeric$
							 	and a.Habilitado = 1">

	<!--- Muestra todos los paquetes existentes --->
	<cfelse>
		<cfset LvarTabla = "ISBpaquete b
								inner join ISBservicio s
									on s.PQcodigo=b.PQcodigo">

		<cfset LvarFiltro = "b.Ecodigo = #Attributes.Ecodigo#
							 	and b.Habilitado = 1
								and b.PQinterfaz  = #Attributes.permInterfaz#
							 	#preserveSingleQuotes(filtroAdic)#">

	</cfif>
	

	<!------
		Modificacion para soportar el artibuto PQutilizadoagente y ademas poder mostrar en la lista el paquete por default de parametros
	------->
	<cfif Attributes.PQutilizadoagente>
		<cfset LvarFiltro = "( (#LvarFiltro# and b.PQutilizadoagente = 1) or (#LvarFiltro# 
			and b.PQcodigo = (select min(Pvalor) from ISBparametros where Ecodigo = #Attributes.Ecodigo# and Pcodigo = 100)
		))">
	</cfif>
	<!---Mostrar o cultar el codigo del paquete--->
	<cfset scod= "S">
	<cfset sdes= "N">
	<cfif not Attributes.ShowCodigo>
		<cfset scod= "N">
		<cfset sdes= "S">
	</cfif>
	<cf_conlis 
		title="Paquete"
		campos = "PQcodigo#Attributes.sufijo#, PQnombre#Attributes.sufijo#, vPQtarifaBasica#Attributes.sufijo#, vPQhorasBasica#Attributes.sufijo#, vPQprecioExc#Attributes.sufijo#, vPQmailQuota#Attributes.sufijo#, vPQtelefono#Attributes.sufijo#, vCantidadCorreos#Attributes.sufijo#, vCantidadCable#Attributes.sufijo#  #preserveSingleQuotes(camposAdic)#" 
		desplegables = "#scod#,S,N,N,N,N,N,N,N#despAdic#" 
		modificables = "S,#sdes#,N,N,N,N,N,N,N#modAdic#"
		size = "#Attributes.sizeCod#,#Attributes.sizeDes#,0,0,0,0,0,0,0#sizeAdic#"
		tabla = "#preserveSingleQuotes(LvarTabla)#"
		columnas = "distinct b.PQcodigo as PQcodigo#Attributes.sufijo#, 
					b.PQdescripcion as PQnombre#Attributes.sufijo#, 
					b.PQtarifaBasica as vPQtarifaBasica#Attributes.sufijo#, 
					b.PQhorasBasica as vPQhorasBasica#Attributes.sufijo#, 
					b.PQprecioExc as vPQprecioExc#Attributes.sufijo#, 
					coalesce(b.PQmailQuota, 0) as vPQmailQuota#Attributes.sufijo#, 
					b.PQtelefono as vPQtelefono#Attributes.sufijo#, 
					(select sum(SVcantidad) from ISBservicio x where x.PQcodigo = b.PQcodigo and x.TScodigo = 'MAIL' and x.Habilitado = 1) as vCantidadCorreos#Attributes.sufijo#,
					(select coalesce(sum(SVcantidad),0) from ISBservicio x where x.PQcodigo = b.PQcodigo and x.TScodigo = 'CABM' and x.Habilitado = 1) as vCantidadCable#Attributes.sufijo#
					#preserveSingleQuotes(colsAdic)#"
		filtro = "#preserveSingleQuotes(LvarFiltro)#"
		filtrar_por = "b.PQcodigo, b.PQdescripcion"
		desplegar = "PQcodigo#Attributes.sufijo#, PQnombre#Attributes.sufijo#"
		etiquetas = "C&oacute;digo, Paquete"
		formatos = "S,S"
		align = "left, left"
		asignar = "PQcodigo#Attributes.sufijo#, PQnombre#Attributes.sufijo#, vPQtarifaBasica#Attributes.sufijo#, vPQhorasBasica#Attributes.sufijo#, vPQprecioExc#Attributes.sufijo#, vPQmailQuota#Attributes.sufijo#, vPQtelefono#Attributes.sufijo#, vCantidadCorreos#Attributes.sufijo#, vCantidadCable#Attributes.sufijo#  #preserveSingleQuotes(asigAdic)#"
		asignarformatos = "S,S,N,N,N,I,N,N,I#asigFAdic#"
		funcion = "#Attributes.funcion#"
		Form = "#Attributes.form#"
		Conexion = "#Attributes.Conexion#"
		valuesArray = "#array#"
		closeOnExit = "true"
		tabindex = "1"
	>

</cfif>