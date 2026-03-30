<cfparam name="form.tab" default="1">
<cfset pagina1 = ''>
<cfset pagina = ''>
<cfif isdefined("form._pagenum")>
	<cfset pagina = "&PageNum_lista=#form._pagenum#">
</cfif>
<cfif isdefined("form._pagenum1")>
	<cfset pagina1 = "&PageNum_lista1=#form._pagenum1#">
</cfif>


<cfset params = '' >
<cfif isdefined("form.pageNum_lista")>
	<cfset params = params & '&pageNum_lista=#form.pageNum_lista#' >
</cfif>
<cfif isdefined("form.fPCcodigo")>
	<cfset params =params & '&fPCcodigo=#form.fPCcodigo#' >
</cfif>
<cfif isdefined("form.fPCnombre")>
	<cfset params =params & '&fPCnombre=#form.fPCnombre#' >
</cfif>
<cfif isdefined("form.fPCdescripcion")>
	<cfset params = params & '&fPCdescripcion=#form.fPCdescripcion#' >
</cfif>
<cfif isdefined("form.PPGuardar") or isdefined("form.PPModificar") >
	<cfif not len(trim(form.PPpregunta))>
		<cfthrow message="Error. Debe especificar la pregunta.">
	</cfif>
	
	<cfif not len(trim(form.PPnumero))>
		<cfquery name="datanumero" datasource="sifcontrol">
			select coalesce(max(PPnumero),1) as numero
			from PortalPregunta
			where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		</cfquery>
		<cfset form.PPnumero = datanumero.numero >
	</cfif>
</cfif> 

<cfif isdefined("form.PCAgregar")>
	<cftransaction>
	<cfquery name="validar" datasource="sifcontrol">
		select PCid 
		from PortalCuestionario
		where PCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.PCcodigo)#">
	</cfquery>
	<cfif validar.recordcount gt 0>
		<cfthrow message="El c&oacute;digo de cuestionario que desea agregar ya esta asociado a otro cuestionario.">
	</cfif>
	
	<cfquery name="data" datasource="sifcontrol">
		insert into PortalCuestionario( PCcodigo, 
										PCnombre, 
										PCdescripcion, 
										PCtipo, 
										PCinactivo, 
										BMfecha,
										BMUsucodigo 
										<cfif isdefined("session.menues.SScodigo") and ucase(session.menues.SScodigo) neq 'SYS'>
											,CEcodigo
											,EcodigoSDC
											,Ecodigo
										</cfif> )
		values( <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.PCcodigo)#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCnombre#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PCtipo#">,
				0,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				<cfif isdefined("session.menues.SScodigo") and ucase(session.menues.SScodigo) neq 'SYS'>
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
					,<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfif> )
			<cf_dbidentity1 datasource="sifcontrol">
		</cfquery>	
		<cf_dbidentity2 datasource="sifcontrol" name="data">
	</cftransaction>
	<cfset form.PCid = data.identity >
	<cfset ira = "cuestionario-tabs.cfm?tab=#form.tab#&PCid=#form.PCid##pagina#" >

<cfelseif isdefined("form.PCModificar")>
	<cfquery name="validar" datasource="sifcontrol">
		select PCid 
		from PortalCuestionario
		where PCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.PCcodigo)#">
		and PCid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
	</cfquery>
	<cfif validar.recordcount gt 0>
		<cfthrow message="El c&oacute;digo del cuestionario que desea modificar ya esta asociado a otro cuestionario.">
	</cfif>

	<cfquery name="data" datasource="sifcontrol">
		update PortalCuestionario 
		set PCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.PCcodigo)#">,
			PCnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCnombre#">,
			PCdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCdescripcion#">,
			PCtipo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PCtipo#">
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		<cfif isdefined("session.menues.SScodigo") and ucase(session.menues.SScodigo) neq 'SYS'>
			and CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			and EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfif>
	</cfquery>
	<cfset ira = "cuestionario-tabs.cfm?tab=#form.tab#&PCid=#form.PCid##pagina#" >

<cfelseif isdefined("form.PCEliminar")>
	<!--- 
		Marcel pidio que al borra un cuestionario se borren las partes, preguntas y respuestas.
		No estoy convencido de hacer esto porque en minisif hay tablas que referencian al 
		cuestionario, es cierto que no son referencias por base de datos porque son bases de datos
		diferentes, pero la informacion podria quedar  inconsistente.
	--->
	<cfquery name="data" datasource="sifcontrol">
		delete from PortalCuestionario 
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
	</cfquery>
	<cfset ira = "cuestionario-lista.cfm" >

<cfelseif isdefined("form.PPGuardar")>
	<cftransaction>
	<cfquery name="data" datasource="sifcontrol">
		insert into PortalPregunta(PCid, PPparte, PPnumero, PPpregunta, PPtipo, PPvalor, PPrespuesta, BMfecha, BMUsucodigo, PPorden, PPmantener)
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPparte#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPnumero#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PPpregunta#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.PPtipo#">,
				<cfif len(trim(form.PPvalor))><cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.PPvalor,',','','all')#"><cfelse>0</cfif>,
				<cfif listcontains('V,O', form.PPtipo,',')><cfif len(trim(form.PPrespuesta))><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.PPrespuesta)#"><cfelse>null</cfif><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
				<cfif isdefined("form.PPorden") and len(trim(form.PPorden))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPorden#"><cfelse>null</cfif>,
				<cfif isdefined("form.PPmantener")>1<cfelse>0</cfif> )
		<cf_dbidentity1 datasource="sifcontrol">
	</cfquery>	
	<cf_dbidentity2 datasource="sifcontrol" name="data">
	</cftransaction>
	<cfset form.PPid = data.identity >
	<cfloop from="1" to="#form.filas_total#" index="i">
		<cfif isdefined("form.PRtexto_#i#") and len(trim(form['PRtexto_#i#']))>
			<cfquery datasource="sifcontrol">
				insert into PortalRespuesta( PCid, PPid, PRtexto, PRvalor, PRira, BMfecha, BMUsucodigo, PRorden)
				values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['PRtexto_#i#']#">,
						<cfif len(trim(form['PRvalor_#i#']))><cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form['PRvalor_#i#'],',','','all')#"><cfelse>null</cfif>,
						<cfif isdefined("form.PRira_#i#") and len(trim(form['PRira_#i#']))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form['PRira_#i#']#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfif isdefined("form.PRorden_#i#") and len(trim(form['PRorden_#i#']))><cfqueryparam cfsqltype="cf_sql_integer" value="#form['PRorden_#i#']#"><cfelse>null</cfif>
						)
			</cfquery>
		</cfif>
	</cfloop>
	
	<cfset ira = "cuestionario-tabs.cfm?tab=#form.tab#&PCid=#form.PCid#&PPid=#form.PPid##pagina#" >

<cfelseif isdefined("form.PPModificar")>
	<cfquery datasource="sifcontrol">
		update PortalPregunta
		set PPparte=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPparte#">, 
			PPnumero=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPnumero#">, 
			PPpregunta=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PPpregunta#">, 
			PPtipo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.PPtipo#">, 
			PPvalor=<cfif len(trim(form.PPvalor))><cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form.PPvalor,',','','all')#"><cfelse>0</cfif>,
			PPrespuesta=<cfif listcontains('V,O', form.PPtipo,',')><cfif len(trim(form.PPrespuesta))><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.PPrespuesta)#"><cfelse>null</cfif><cfelse>null</cfif>,
			PPorden=<cfif isdefined ("form.PPorden") and len(trim(form.PPorden))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPorden#"><cfelse>null</cfif>,
			PPmantener = <cfif isdefined("form.PPmantener")>1<cfelse>0</cfif>
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
	</cfquery>
	
	<cfloop from="1" to="#form.filas_total#" index="i">
		<cfif isdefined("form.PRid_#i#") and len(trim(form['PRid_#i#']))>
			<cfif isdefined("form.PRtexto_#i#") and len(trim(form['PRtexto_#i#']))>
				<cfquery datasource="sifcontrol">
					update PortalRespuesta 
					set PRtexto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['PRtexto_#i#']#">, 
						PRvalor = <cfif len(trim(form['PRvalor_#i#']))><cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form['PRvalor_#i#'],',','','all')#"><cfelse>null</cfif>,
						PRira = <cfif isdefined("form.PRira_#i#") and len(trim(form['PRira_#i#']))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form['PRira_#i#']#"><cfelse>null</cfif>,
						PRorden=<cfif isdefined("form.PRorden_#i#") and len(trim(form['PRorden_#i#']))><cfqueryparam cfsqltype="cf_sql_integer" value="#form['PRorden_#i#']#"><cfelse>null</cfif>
					where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
					  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
					  and PRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['PRid_#i#']#">					  
				</cfquery>
			<cfelse>
				<cfquery datasource="sifcontrol">
					delete from PortalRespuesta 
					where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
					  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
					  and PRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['PRid_#i#']#">
				</cfquery>
			</cfif>
		<cfelseif isdefined("form.PRtexto_#i#") and len(trim(form['PRtexto_#i#']))>
			<cfquery datasource="sifcontrol">
				insert into PortalRespuesta( PCid, PPid, PRtexto, PRvalor, PRira, BMfecha, BMUsucodigo, PRorden)
				values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['PRtexto_#i#']#">,
						<cfif len(trim(form['PRvalor_#i#']))><cfqueryparam cfsqltype="cf_sql_numeric" value="#replace(form['PRvalor_#i#'],',','','all')#"><cfelse>null</cfif>,
						<cfif isdefined("form.PRira_#i#") and len(trim(form['PRira_#i#']))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form['PRira_#i#']#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfif isdefined("form.PRorden_#i#") and len(trim(form['PRorden_#i#']))><cfqueryparam cfsqltype="cf_sql_integer" value="#form['PRorden_#i#']#"><cfelse>null</cfif>
						)
			</cfquery>
		</cfif>								
	</cfloop>
	
	<cfset ira = "cuestionario-tabs.cfm?tab=#form.tab#&PCid=#form.PCid#&PPid=#form.PPid##pagina#" >

<cfelseif isdefined("form.PCPGuardar")>
	<cfquery datasource="sifcontrol">
		insert into PortalCuestionarioParte( PCid, PPparte, PCPdescripcion, PCPinstrucciones, PCPmaxpreguntas, BMfecha, BMUsucodigo )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPparte#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCPdescripcion#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCPinstrucciones#">,
				<cfif len(trim(form.PCPmaxpreguntas))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.PCPmaxpreguntas#"><cfelse>0</cfif>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
	</cfquery>
	<cfset ira = "cuestionario-tabs.cfm?PCid=#form.PCid#&PPparte=#form.PPparte##pagina1#" >

<cfelseif isdefined("form.PCPModificar")>
	<cfquery datasource="sifcontrol">
		update PortalCuestionarioParte
		set	PCPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCPdescripcion#">,
			PCPinstrucciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCPinstrucciones#">,
			PCPmaxpreguntas = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PCPmaxpreguntas#">
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		  and PPparte =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPparte#">
	</cfquery>
	<cfset ira = "cuestionario-tabs.cfm?tab=#form.tab#&PCid=#form.PCid#&PPparte=#form.PPparte##pagina1#" >

<cfelseif isdefined("form.PCPEliminar")>
	<cfquery datasource="sifcontrol">
		delete from PortalCuestionarioParte
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		  and PPparte =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPparte#">
	</cfquery>
	<cfset ira = "cuestionario-tabs.cfm?tab=#form.tab#&PCid=#form.PCid#&PPparte=#form.PPparte##pagina1#" >

<cfelseif isdefined("form.PPEliminar")>
	<cfquery datasource="sifcontrol">
		delete from PortalRespuestaU
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
	</cfquery>
	<cfquery datasource="sifcontrol">
		delete from PortalPreguntaU
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
	</cfquery>	
	<cfquery datasource="sifcontrol">
		delete from PortalRespuesta
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
	</cfquery>
	<cfquery datasource="sifcontrol">
		delete from PortalPregunta
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
	</cfquery>
	<cfset ira = "cuestionario-tabs.cfm?tab=#form.tab#&PCid=#form.PCid##pagina#" >
</cfif>
<cflocation url="#ira##params#">