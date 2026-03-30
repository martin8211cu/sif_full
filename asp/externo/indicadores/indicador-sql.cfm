<cfset parametros = '?form=form1' >
<cfif isdefined("form.fSScodigo") and len(trim(form.fSScodigo))>
	<cfset parametros = parametros & "&fSScodigo=#form.fSScodigo#">
</cfif>
<cfif isdefined("form.fSMcodigo") and len(trim(form.fSMcodigo))>
	<cfset parametros = parametros & "&fSMcodigo=#form.fSMcodigo#">
</cfif>

<cfif isdefined("form.btnAgregar") or isdefined("form.btnModificar")>
	<!--- ==================================================== --->
	<!--- Valida la existencia del archivo de formato estatico --->
	<cfif isdefined("form.btnModificar") or isdefined("form.btnAgregar")>
		<cfinclude template="validaUrl.cfm">
		<cfif isdefined("form.calculo")>
			<!--- valida que sea un componente --->
			<cfset extension = mid(form.calculo,len(form.calculo)-2, len(form.calculo)) >
			<cfif Ucase(extension) neq 'CFC'>
				<cfthrow message="El script de C&aacute;lculo #form.calculo# debe ser un componente.">
			</cfif>
		
			<cfset LvarOK = validarUrl( trim(form.calculo) ) >
			<cfif not LvarOK ><cfthrow message="No existe el script de C&aacute;lculo: #LvarSPhomeuri#"></cfif>
		</cfif>
		<cfif isdefined("form.cfm_detalle") and len(form.cfm_detalle)>
			<cfset LvarOK = validarUrl( trim(form.cfm_detalle) ) >
			<cfif not LvarOK ><cfthrow message="No existe el archivo CFM Detalle: #LvarSPhomeuri#"></cfif>
		</cfif>
	</cfif>
	<!--- ==================================================== --->
	<cfset LvarPosicion = form.posicion >
	<cfif len(trim(form.posicion)) eq 0>
		<cfquery name="dataPos" datasource="asp">
			select coalesce(max(posicion),0) as posicion
			from Indicador
		</cfquery>
		<cfset LvarPosicion = dataPos.posicion + 10 >
	</cfif>
	
	<cfif isdefined("form.btnAgregar")>
		<cfquery datasource="asp">
			insert into Indicador(
				indicador, nombre_indicador, SScodigo, SMcodigo, 
				es_corporativo, es_graficable, es_default, es_diario, 
				publicado, fecha_publicacion, limite_rojo_sup, limite_amarillo_sup, limite_amarillo_inf, limite_rojo_inferior, 
				formato, calculo, descripcion_funcional, posicion, cfm_detalle, 
				filtro_tiempo, filtro_of, filtro_depto, filtro_cf, 
				observaciones, BMUsucodigo, BMfecha,
				unidad_medida, desc_valor, desc_total, desc_peso_valor, desc_peso_total, uso_valor, uso_total )
			values ( 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.indicador)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nombre_indicador)#">,	
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SScodigo)#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SMcodigo)#">,
						
						<cfif isdefined("form.es_corporativo")>1<cfelse>0</cfif>,
						<cfif isdefined("form.es_graficable")>1<cfelse>0</cfif>,
						<cfif isdefined("form.es_default")>1<cfelse>0</cfif>,
						<cfif isdefined("form.es_diario")>1<cfelse>0</cfif>,
						
						<cfif isdefined("form.publicado")>1<cfelse>0</cfif>,
						<cfif isdefined("form.publicado")><cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.limite_rojo_sup,',','','all')#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.limite_amarillo_sup,',','','all')#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.limite_amarillo_inf,',','','all')#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.limite_rojo_inferior,',','','all')#">,
						
						<cfqueryparam cfsqltype="cf_sql_char" value="#form.formato#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.calculo#">,
						<cfif len(trim(form.descripcion_funcional)) ><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descripcion_funcional#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#replace(LvarPosicion,',','','all')#">,
						<cfif len(trim(form.cfm_detalle))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cfm_detalle#"><cfelse>null</cfif>,
						
						<cfif len(trim(form.filtro_tiempo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.filtro_tiempo#"><cfelse>null</cfif>,
						<cfif len(trim(form.filtro_of))><cfqueryparam cfsqltype="cf_sql_char" value="#form.filtro_of#"><cfelse>null</cfif>,
						<cfif len(trim(form.filtro_depto))><cfqueryparam cfsqltype="cf_sql_char" value="#form.filtro_depto#"><cfelse>null</cfif>,
						<cfif len(trim(form.filtro_cf))><cfqueryparam cfsqltype="cf_sql_char" value="#form.filtro_cf#"><cfelse>null</cfif>,
						
						<cfif len(trim(form.observaciones)) ><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.observaciones#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.unidad_medida#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desc_valor#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desc_total#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desc_peso_valor#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desc_peso_total#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.uso_valor#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.uso_total#">
				   )
		</cfquery>
	<cfelseif isdefined("form.btnModificar")>
		<cftransaction>
			<cfif trim(form.indicador) neq trim(form._indicador) >
				<!--- inserta el indicador con el nuevo codigo --->
				<cfquery datasource="asp">
					insert into Indicador( indicador, nombre_indicador, SScodigo, SMcodigo, es_corporativo, es_graficable, es_default, es_diario, publicado, fecha_publicacion, limite_rojo_sup, limite_amarillo_sup, limite_amarillo_inf, limite_rojo_inferior, formato, calculo, descripcion_funcional, posicion, cfm_detalle, filtro_tiempo, filtro_of, filtro_depto, filtro_cf, observaciones, BMUsucodigo, BMfecha )
					values ( 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.indicador)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nombre_indicador)#">,	
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SScodigo)#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SMcodigo)#">,
								<cfif isdefined("form.es_corporativo")>1<cfelse>0</cfif>,
								<cfif isdefined("form.es_graficable")>1<cfelse>0</cfif>,
								<cfif isdefined("form.es_default")>1<cfelse>0</cfif>,
								<cfif isdefined("form.es_diario")>1<cfelse>0</cfif>,
								<cfif isdefined("form.publicado")>1<cfelse>0</cfif>,
								<cfif isdefined("form.publicado")><cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"><cfelse>null</cfif>,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.limite_rojo_sup,',','','all')#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.limite_amarillo_sup,',','','all')#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.limite_amarillo_inf,',','','all')#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.limite_rojo_inferior,',','','all')#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.formato#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.calculo#">,
								<cfif len(trim(form.descripcion_funcional)) ><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descripcion_funcional#"><cfelse>null</cfif>,
								<cfqueryparam cfsqltype="cf_sql_integer" value="#replace(LvarPosicion,',','','all')#">,
								<cfif len(trim(form.cfm_detalle))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cfm_detalle#"><cfelse>null</cfif>,
								<cfif len(trim(form.filtro_tiempo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.filtro_tiempo#"><cfelse>null</cfif>,
								<cfif len(trim(form.filtro_of))><cfqueryparam cfsqltype="cf_sql_char" value="#form.filtro_of#"><cfelse>null</cfif>,
								<cfif len(trim(form.filtro_depto))><cfqueryparam cfsqltype="cf_sql_char" value="#form.filtro_depto#"><cfelse>null</cfif>,
								<cfif len(trim(form.filtro_cf))><cfqueryparam cfsqltype="cf_sql_char" value="#form.filtro_cf#"><cfelse>null</cfif>,
								<cfif len(trim(form.observaciones)) ><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.observaciones#"><cfelse>null</cfif>,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
								<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						   )
				</cfquery>
				<!--- inserta los uausrios asociados al viejo codigo de indicador --->
				<cfquery datasource="asp">
					insert INTO IndicadorUsuario(Ecodigo, Usucodigo,indicador, posicion, BMfecha, BMUsucodigo)
					select Ecodigo, Usucodigo, '#trim(form.indicador)#', posicion, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">, #session.Usucodigo#
					from IndicadorUsuario
					where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form._indicador)#">
				</cfquery>
				
				<!--- borra los datos viejos --->
				<cfquery datasource="asp">
					delete from IndicadorUsuario
					where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form._indicador#">
				</cfquery>
				<cfquery datasource="asp">
					delete from Indicador
					where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form._indicador#">
				</cfquery>
			<cfelse>
				<cfquery datasource="asp">
					update Indicador
					set indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.indicador)#">,
						nombre_indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.nombre_indicador)#">,	
						SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SScodigo)#">,
						SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.SMcodigo)#">,
						es_corporativo = <cfif isdefined("form.es_corporativo")>1<cfelse>0</cfif>,
						es_graficable = <cfif isdefined("form.es_graficable")>1<cfelse>0</cfif>,
						es_default = <cfif isdefined("form.es_default")>1<cfelse>0</cfif>,
						es_diario =	<cfif isdefined("form.es_diario")>1<cfelse>0</cfif>,
						limite_rojo_sup = <cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.limite_rojo_sup,',','','all')#">,
						limite_amarillo_sup = <cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.limite_amarillo_sup,',','','all')#">,
						limite_amarillo_inf = <cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.limite_amarillo_inf,',','','all')#">,
						limite_rojo_inferior = <cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.limite_rojo_inferior,',','','all')#">,
						formato = <cfqueryparam cfsqltype="cf_sql_char" value="#form.formato#">,
						calculo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.calculo#">,
						descripcion_funcional = <cfif len(trim(form.descripcion_funcional)) ><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.descripcion_funcional#"><cfelse>null</cfif>,
						posicion = <cfqueryparam cfsqltype="cf_sql_integer" value="#replace(LvarPosicion,',','','all')#">,
						cfm_detalle = <cfif len(trim(form.cfm_detalle))><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.cfm_detalle#"><cfelse>null</cfif>,
						observaciones = <cfif len(trim(form.observaciones)) ><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.observaciones#"><cfelse>null</cfif>,
						publicado = <cfif isdefined("form.publicado")>1<cfelse>0</cfif>,
						filtro_tiempo = <cfif len(trim(form.filtro_tiempo))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.filtro_tiempo#"><cfelse>null</cfif>,
						filtro_of = <cfif len(trim(form.filtro_of))><cfqueryparam cfsqltype="cf_sql_char" value="#form.filtro_of#"><cfelse>null</cfif>,
						filtro_depto = <cfif len(trim(form.filtro_depto))><cfqueryparam cfsqltype="cf_sql_char" value="#form.filtro_depto#"><cfelse>null</cfif>,
						filtro_cf = <cfif len(trim(form.filtro_cf))><cfqueryparam cfsqltype="cf_sql_char" value="#form.filtro_cf#"><cfelse>null</cfif>,
						<cfif isdefined("form.publicado")> fecha_publicacion = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,</cfif>

						
						unidad_medida=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.unidad_medida#">,
						desc_valor=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desc_valor#">,
						desc_total=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desc_total#">,
						desc_peso_valor=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desc_peso_valor#">,
						desc_peso_total=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.desc_peso_total#">,
						uso_valor=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.uso_valor#">,
						uso_total=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.uso_total#">
					where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form._indicador)#">
				</cfquery>
			</cfif>
		</cftransaction>
	
		<cfset parametros = parametros & "&indicador=#form.indicador#" >

	</cfif>

<cfelseif isdefined("form.btnEliminar") >
	<cfquery datasource="asp">
		delete from IndicadorUsuario
		where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form._indicador)#">
	</cfquery>
	<cfquery datasource="asp">
		delete from Indicador
		where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form._indicador)#">
	</cfquery>
	<cfset parametros = parametros & "&indicador=#form.indicador#" >
</cfif>

<!--- resecuenciar --->
<cfif isdefined("form.btnAgregar") or isdefined("form.btnModificar") or isdefined("form.btnEliminar")>
	<cfquery name="dataOrden" datasource="asp">
		select indicador, posicion
		from Indicador
		order by posicion
	</cfquery>
	
	<cfset orden = 10 >
	<cfloop query="dataOrden">
		<cfif dataOrden.posicion neq orden>
			<cfquery datasource="asp">
				update Indicador
				set posicion = <cfqueryparam cfsqltype="cf_sql_integer" value="#orden#">
				where indicador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(dataOrden.indicador)#">
			</cfquery>
		</cfif>
		<cfset orden = orden + 10 >
	</cfloop>
</cfif>

<cfoutput>
<cflocation url="indicador.cfm#parametros#">
</cfoutput>