
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_ElCodigoDeCuestionarioQueDeseaAgregarYaEstaAsociadoAOtroCuestionario" default="El c&oacute;digo de cuestionario que desea agregar ya est&aacute; asociado a otro cuestionario." returnvariable="MSG_ElCodigoDeCuestionarioQueDeseaAgregarYaEstaAsociadoAOtroCuestionario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="MSG_ElCodigoDelCuestionarioQueDeseaModificarYaEstaAsociadoAOtroCuestionario" default="El c&oacute;digo del cuestionario que desea modificar ya esta asociado a otro cuestionario." returnvariable="MSG_ElCodigoDelCuestionarioQueDeseaModificarYaEstaAsociadoAOtroCuestionario"/>

<cfset pagina = ''>
<cfset pagina1 = ''>
<cfif isdefined("form._pagenum")>
	<cfset pagina = "&PageNum_lista=#form._pagenum#">
</cfif>            
<cfif isdefined("form._pagenum1")>
	<cfset pagina1 = "&PageNum_lista1=#form._pagenum1#">
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
<!---*************************--->
<cfif isdefined("form.PCAgregar")>
	<cftransaction>
	<cfquery name="validar" datasource="sifcontrol">
		select PCid 
		from PortalCuestionario
		where PCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.PCcodigo)#">
	</cfquery>
	<cfif validar.recordcount gt 0>
		<cfthrow message="#MSG_ElCodigoDeCuestionarioQueDeseaAgregarYaEstaAsociadoAOtroCuestionario#">
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
		<cf_dbidentity2 datasource="sifcontrol" name="data" returnvariable="LvarID">
	</cftransaction>
<!---Agregar la parte generica cuando se da de alta a un cuestionario--->
	<cfquery datasource="sifcontrol" >
		insert into PortalCuestionarioParte( PCid, PPparte, PCPdescripcion, PCPinstrucciones, PCPmaxpreguntas, BMfecha, BMUsucodigo )
		values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="01">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Primera Parte General">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="Complete lo indicado">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="0">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#"> )
		</cfquery>
	<cfset form.PCid = data.identity >
	<cfset ira = "cuestionario.cfm?PCid=#form.PCid##pagina#&tab=3&PPparte=01" >

<cfelseif isdefined("form.PCModificar")>
	<cfquery name="validar" datasource="sifcontrol">
		select PCid 
		from PortalCuestionario
		where PCcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.PCcodigo)#">
		and PCid != <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
	</cfquery>
	<cfif validar.recordcount gt 0>
		<cfthrow message="#MSG_ElCodigoDelCuestionarioQueDeseaModificarYaEstaAsociadoAOtroCuestionario#">
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
			<!--- and EcodigoSDC = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> --->
		</cfif>
	</cfquery>
	<cfset ira = "cuestionario.cfm?PCid=#form.PCid##pagina#" >

<cfelseif isdefined("form.PCEliminar")>
	<!--- 
		Marcel pidio que al borra un cuestionario se borren las partes, preguntas y respuestas.
		No estoy convencido de hacer esto porque en minisif hay tablas que referencian al 
		cuestionario, es cierto que no son referencias por base de datos porque son bases de datos
		diferentes, pero la informacion podria quedar  inconsistente.
	--->
	
	<cfquery name="data" datasource="sifcontrol">
		delete from PortalRespuesta  
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
	</cfquery>
	
	<cfquery name="data" datasource="sifcontrol">
		delete from PortalPregunta    
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
	</cfquery>
	
	<cfquery name="data" datasource="sifcontrol">
		delete from PortalCuestionarioParte  
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
	</cfquery>
	
	<cfquery name="data" datasource="sifcontrol">
		delete from PortalCuestionario   
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
	</cfquery>
	<cflocation url="cuestionario-lista.cfm">	

<cfelseif isdefined("form.PPGuardar")>
	<cftransaction>
	<cfquery name="data" datasource="sifcontrol">
		insert into PortalPregunta(PCid, PPparte, PPnumero, PPpregunta, PPtipo,PPorientacion, PPvalor, PPrespuesta, BMfecha, BMUsucodigo, PPorden,PPmantener)
		values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPparte#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPnumero#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PPpregunta#">,
				<cfqueryparam cfsqltype="cf_sql_char" value="#form.PPtipo#">,
                <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPorientacion#">,
				<cfif len(trim(form.PPvalor))><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.PPvalor,',','','all')#"><cfelse>0</cfif>,
				<cfif listcontains('V,O', form.PPtipo,',')><cfif len(trim(form.PPrespuesta))><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.PPrespuesta)#"><cfelse>null</cfif><cfelse>null</cfif>,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">, 
				<cfif isdefined("form.PPorden") and len(trim(form.PPorden))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPorden#"><cfelse>null</cfif>,
				<cfif isdefined("form.PPmantener")>1<cfelse>0</cfif> )
		<cf_dbidentity1 datasource="sifcontrol">
	</cfquery>	
	<cf_dbidentity2 datasource="sifcontrol" name="data" returnvariable="x">
	</cftransaction>
	<cfquery name="rs" datasource="#session.dsn#">
		select * from PortalPregunta where PPid=#x#
	</cfquery>
	
	<!---Actualización del número de preguntas en la parte--->
	<cfquery name="contador" datasource="#session.dsn#">
		select count(1) as cantidad from PortalPregunta where PPparte=#form.PPparte# and PCid=#form.PCid#
	</cfquery>
	<cfquery name="acContador" datasource="#session.dsn#">
		update PortalCuestionarioParte set PCPmaxpreguntas=#contador.cantidad# where PPparte=#form.PPparte# and PCid=#form.PCid#
	</cfquery>
	<!------>
	<cfset form.PPid = data.identity >
	<cfset var_OPRira = "">
	<cfloop from="1" to="#form.filas_total#" index="i">
		<cfif isdefined("form.PRvalor_#i#") and len(trim(form['PRvalor_#i#'])) >
			<cfset var_OPRira = Evaluate("form.PRira_#i#")>
			<cfquery datasource="sifcontrol">
				insert into PortalRespuesta( PCid, PPid, PRtexto, PRvalor, PRira, BMfecha, BMUsucodigo, PRorden)
				values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">,
						<cfif isdefined("form.PRtexto_#i#") and len(trim(form['PRtexto_#i#']))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['PRtexto_#i#']#">,
						<cfelse>
							'',
						</cfif>		
						<cfif len(trim(form['PRvalor_#i#']))><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form['PRvalor_#i#'],',','','all')#"><cfelse>null</cfif>,
						<cfif isdefined("var_OPRira") and len(trim(var_OPRira))><cfqueryparam cfsqltype="cf_sql_numeric" value="#var_OPRira#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfif isdefined("form.PRorden_#i#") and len(trim(form['PRorden_#i#']))><cfqueryparam cfsqltype="cf_sql_integer" value="#form['PRorden_#i#']#"><cfelse>null</cfif>
						)
			</cfquery>
		</cfif>	
		<cfset var_OPRira = "">
	</cfloop>
	
	<cfset ira = "cuestionario.cfm?PCid=#form.PCid#&PPid=#form.PPid#&PPparte=#form.PPparte##pagina#&tab=3" >

<cfelseif isdefined("form.PPModificar")>
	
    <cfquery datasource="sifcontrol">
		update PortalPregunta
		set PPparte=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPparte#">, 
			PPnumero=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPnumero#">, 
			PPpregunta=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PPpregunta#">, 
			PPtipo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.PPtipo#">, 
			PPvalor=<cfif len(trim(form.PPvalor))><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.PPvalor,',','','all')#"><cfelse>0</cfif>,
			PPrespuesta =<cfif listcontains('V,O', form.PPtipo,',')><cfif len(trim(form.PPrespuesta))><cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.PPrespuesta)#"><cfelse>null</cfif><cfelse>null</cfif>,
			PPorden     =<cfif isdefined ("form.PPorden") and len(trim(form.PPorden))><cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPorden#"><cfelse>null</cfif>,
			PPmantener = <cfif isdefined("form.PPmantener")>1<cfelse>0</cfif>,
            PPorientacion = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PPorientacion#">
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
	</cfquery>
	<cfset var_OPRira = "">
	<!--- <cf_dump var="#form#"> --->
	<cfloop from="1" to="#form.filas_total#" index="i">
		<cfif isdefined("form.PRid_#i#") and len(trim(form['PRid_#i#']))>
				<cfif isdefined("form.PRira_#i#") and len(trim(form['PRira_#i#']))>
					<cfset var_OPRira = Evaluate("form.PRira_#i#")>
				<cfelse>
					<cfset var_OPRira ="">
				</cfif>
				<cfquery datasource="sifcontrol">
					update PortalRespuesta 
					set 
						<cfif isdefined("form.PRtexto_#i#") and len(trim(form['PRtexto_#i#']))>
							PRtexto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form['PRtexto_#i#']#">, 
						<cfelse>
							PRtexto = '', 
						</cfif>
						PRvalor = <cfif len(trim(form['PRvalor_#i#']))><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form['PRvalor_#i#'],',','','all')#"><cfelse>null</cfif>,
						PRira = <cfif isdefined("var_OPRira") and len(trim(var_OPRira))><cfqueryparam cfsqltype="cf_sql_numeric" value="#var_OPRira#"><cfelse>null</cfif>,
						PRorden=<cfif isdefined("form.PRorden_#i#") and len(trim(form['PRorden_#i#']))><cfqueryparam cfsqltype="cf_sql_integer" value="#form['PRorden_#i#']#"><cfelse>null</cfif>
					where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
					  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
					  and PRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['PRid_#i#']#">					  
				</cfquery>
			<!--- <cfelse>
				<cfquery datasource="sifcontrol">
					delete from PortalRespuesta 
					where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
					  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">
					  and PRid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form['PRid_#i#']#">
				</cfquery>
			</cfif> --->
		<cfelseif isdefined("form.PRvalor_#i#") and len(trim(form['PRvalor_#i#'])) >
			<cfquery datasource="sifcontrol">
				insert into PortalRespuesta( PCid, PPid, PRtexto, PRvalor, PRira, BMfecha, BMUsucodigo, PRorden)
				values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPid#">,
						<cfif isdefined("form.PRtexto_#i#") and len(trim(form['PRtexto_#i#']))>
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form['PRtexto_#i#']#">,
						<cfelse>
							'',
						</cfif>	
						<cfif len(trim(form['PRvalor_#i#']))><cfqueryparam cfsqltype="cf_sql_float" value="#replace(form['PRvalor_#i#'],',','','all')#"><cfelse>null</cfif>,
						<cfif isdefined("form.PRira_#i#") and len(trim(form['PRira_#i#']))><cfqueryparam cfsqltype="cf_sql_numeric" value="#form['PRira_#i#']#"><cfelse>null</cfif>,
						<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
						<cfif isdefined("form.PRorden_#i#") and len(trim(form['PRorden_#i#']))><cfqueryparam cfsqltype="cf_sql_integer" value="#form['PRorden_#i#']#"><cfelse>null</cfif>
						)
			</cfquery>
		</cfif>								
	</cfloop>
	<cfset ira = "cuestionario.cfm?PCid=#form.PCid#&PPid=#form.PPid#&PPparte=#form.PPparte##pagina#&tab=3" >

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
	<cfset ira = "cuestionario.cfm?PCid=#form.PCid#&PPparte=#form.PPparte##pagina1#&tab=2" >

<cfelseif isdefined("form.PCPModificar")>
	<cfquery datasource="sifcontrol">
		update PortalCuestionarioParte
		set	PCPdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCPdescripcion#">,
			PCPinstrucciones = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCPinstrucciones#">,
			PCPmaxpreguntas = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.PCPmaxpreguntas#">
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		  and PPparte =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPparte#">
	</cfquery>
	<cfset ira = "cuestionario.cfm?PCid=#form.PCid#&PPparte=#form.PPparte##pagina1#&tab=2" >

<cfelseif isdefined("form.PCPEliminar")>
	<cfquery datasource="sifcontrol">
		delete from PortalCuestionarioParte
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		  and PPparte =	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PPparte#">
	</cfquery>
	<cfset ira = "cuestionario.cfm?PCid=#form.PCid#&tab=2" >

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
		
	<!---Actualización del número de preguntas en la parte--->
	<cfquery name="contador" datasource="#session.dsn#">
		select count(1) as cantidad from PortalPregunta where PPparte=#form.PPparte# and PCid=#form.PCid#
	</cfquery>
	<cfquery name="acContador" datasource="#session.dsn#">
		update PortalCuestionarioParte set PCPmaxpreguntas=#contador.cantidad# where PPparte=#form.PPparte# and PCid=#form.PCid#
	</cfquery>
	<!------>

	<cfset ira = "cuestionario.cfm?PCid=#form.PCid##pagina#&PPparte=#form.PPparte##pagina#&tab=3"  >

<cfelseif isdefined("PCReplicar")>
	
	
	
<!--- ********************************************PROCESO PARA REPLICA DE CUESTIONARIOS ************************************************************************--->
	<cftransaction>
		<cf_dbfunction name="op_concat" returnvariable="LvarCNCT">
	<!--- INSERTA EL CUESTIONARIO --->
		<cfquery name="rsVal" datasource="sifcontrol">
			select <cf_dbfunction name="length"	args="ltrim(rtrim(PCcodigo))"> as leng
			from PortalCuestionario
			where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
		</cfquery>
		<cfset Lvarlen=#rsVal.leng#+3>
		<cfif Lvarlen gte 10>
			<cfthrow message="Se alcanzo el tope máximo de códigos de Cuestionario">
		</cfif>
		<cfquery name="data" datasource="sifcontrol">
			insert into PortalCuestionario (PCcodigo,PCnombre,PCdescripcion,PCtipo, 
										PCinactivo, 
										BMfecha,
										BMUsucodigo 
										,CEcodigo
										,EcodigoSDC
										,Ecodigo)
			select ltrim(rtrim(PCcodigo))#LvarCNCT#' '#LvarCNCT#'RP', 
				   PCnombre #LvarCNCT#' '#LvarCNCT#'Replica',
				   PCdescripcion,
				   PCtipo, PCinactivo, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					,CEcodigo,EcodigoSDC,Ecodigo	
			from PortalCuestionario
			where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
			<cf_dbidentity1 datasource="sifcontrol">
		</cfquery>	
		<cf_dbidentity2 datasource="sifcontrol" name="data">
	</cftransaction>
	<cfset Lvar_PCidReplica =  data.identity >
	<!--- INSERTA LAS PARTES--->
	<cfquery name="rsInsertaParte" datasource="sifcontrol">
		insert into PortalCuestionarioParte( PCid, PPparte, PCPdescripcion, PCPinstrucciones, PCPmaxpreguntas, BMfecha, BMUsucodigo )
		select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_PCidReplica#">, 
				PPparte, PCPdescripcion, PCPinstrucciones, PCPmaxpreguntas,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		from PortalCuestionarioParte
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
	</cfquery>
	<!--- INSERTA LAS PREGUNTAS DE LAS PARTES DEL CUESTIONARIO --->
	<cfquery name="rsPartes" datasource="sifcontrol">
		select *
		from PortalCuestionarioParte
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
	</cfquery>

	<cfoutput query="rsPartes">
		<cfquery name="rsPreguntas" datasource="sifcontrol">
			select *
			from PortalPregunta
			where PCid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#form.PCid#">
			  and PPparte = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPartes.PPparte#">
		</cfquery>
		<cfloop query="rsPreguntas">
			<cftransaction>
				<cfquery name="rsInsertPreg" datasource="sifcontrol">
					insert into PortalPregunta(PCid, PPparte, PPnumero, PPpregunta, PPtipo,PPorientacion, 
					PPvalor, PPrespuesta, BMfecha, BMUsucodigo, PPorden,PPmantener)
					values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_PCidReplica#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreguntas.PPparte#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreguntas.PPnumero#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPreguntas.PPpregunta#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsPreguntas.PPtipo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreguntas.PPorientacion#">,
							<cfqueryparam cfsqltype="cf_sql_decimal" value="#rsPreguntas.PPvalor#" scale="2">,
							<cfif isdefined("rsPreguntas.PPrespuesta") and len(trim(rsPreguntas.PPrespuesta))>
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPreguntas.PPrespuesta#">,
							<cfelse>
								'',
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfif isdefined("rsPreguntas.PPorden") and len(trim(rsPreguntas.PPorden))>
								<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreguntas.PPorden#">,
							<cfelse>
								null,
							</cfif>	
							<cfqueryparam cfsqltype="cf_sql_bit" value="#rsPreguntas.PPmantener#">)
					<cf_dbidentity1 datasource="sifcontrol">
				</cfquery>
				<cf_dbidentity2 datasource="sifcontrol" name="rsInsertPreg">
			</cftransaction>
			<cfset Lvar_PPid =  rsInsertPreg.identity >
			<!--- INSERTA LAS RESPUESTAS DE LAS PREGUNTAS --->
			<cfquery datasource="sifcontrol">
				insert into PortalRespuesta( PCid, PPid, PRtexto, PRvalor, PRira, BMfecha, BMUsucodigo, PRorden)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_PCidReplica#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_PPid#">,
					 PRtexto, PRvalor, PRira, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					PRorden
				from PortalRespuesta
				where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCid#">
				  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPreguntas.PPid#">
			</cfquery>
		</cfloop>
	</cfoutput>
	<cfset ira = "cuestionario.cfm?PCid="& #Lvar_PCidReplica#>
<cfelseif isdefined("ReplicaC")>
	<cfquery name="rsConocimientos" datasource="#session.DSN#">
		select RHCcodigo,RHCdescripcion
		from RHConocimientos
		where Ecodigo = 28
		  and RHCinactivo = 0
	</cfquery>
<!--- 	<cfquery name="rsCue" datasource="sifcontrol">
		select PCid 
		from PortalCuestionario
		where PCid = 1000000000000734	
	</cfquery>
	<cfoutput query="rsCue">
		<cfquery datasource="sifcontrol">
			delete from PortalRespuesta
			where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCue.PCid#">
		</cfquery>
		<cfquery datasource="sifcontrol">
			delete from PortalPregunta
			where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCue.PCid#">
		</cfquery>
		<cfquery datasource="sifcontrol">
			delete from PortalCuestionarioParte
			where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCue.PCid#">
		</cfquery>
		<cfquery datasource="sifcontrol">
			delete from PortalCuestionario
			where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCue.PCid#">
		</cfquery>
	</cfoutput> --->
 	<cfquery name="rsMachote" datasource="sifcontrol">
		select PCid
		from PortalCuestionario
		where PCcodigo = 'C0112'
	</cfquery>
	<cfset Lvar_Machote = rsMachote.PCid>
	<!--- PROCESO PARA REPLICA DE CUESTIONARIOS --->
	<cfoutput query="rsConocimientos">
	<cftransaction>
		<cfset Lvar_Codigo = rsConocimientos.RHCcodigo>
		<cfset Lvar_Desc = rsConocimientos.RHCdescripcion>
		
		<!--- INSERTA EL CUESTIONARIO --->
		<cfquery name="data" datasource="sifcontrol">
			insert into PortalCuestionario (PCcodigo,PCnombre,PCdescripcion,PCtipo, 
										PCinactivo, 
										BMfecha,
										BMUsucodigo 
										,CEcodigo
										,EcodigoSDC
										,Ecodigo)
			select <cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_Codigo#">, 
				   <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_Desc#">,
				   <cfqueryparam cfsqltype="cf_sql_longvarchar" value="#Lvar_Desc#">,
				   PCtipo, PCinactivo, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
					,CEcodigo,EcodigoSDC,Ecodigo	
			from PortalCuestionario
			where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Machote#">
			<cf_dbidentity1 datasource="sifcontrol">
		</cfquery>	
		<cf_dbidentity2 datasource="sifcontrol" name="data">
	</cftransaction>
	<cfset Lvar_PCidReplica =  data.identity >
	<!--- INSERTA LAS PARTES--->
	<cfquery name="rsInsertaParte" datasource="sifcontrol">
		insert into PortalCuestionarioParte( PCid, PPparte, PCPdescripcion, PCPinstrucciones, PCPmaxpreguntas, BMfecha, BMUsucodigo )
		select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_PCidReplica#">, 
				PPparte, PCPdescripcion, PCPinstrucciones, PCPmaxpreguntas,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		from PortalCuestionarioParte
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Machote#">
	</cfquery>
	<!--- INSERTA LAS PREGUNTAS DE LAS PARTES DEL CUESTIONARIO --->
	<cfquery name="rsPartes" datasource="sifcontrol">
		select *
		from PortalCuestionarioParte
		where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Machote#">
	</cfquery>

	<cfloop query="rsPartes">
		<cfquery name="rsPreguntas" datasource="sifcontrol">
			select *
			from PortalPregunta
			where PCid = <cfqueryparam cfsqltype="cf_sql_numeric"  value="#Lvar_Machote#">
			  and PPparte = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsPartes.PPparte#">
		</cfquery>
		<cfloop query="rsPreguntas">
			<cftransaction>
				<cfquery name="rsInsertPreg" datasource="sifcontrol">
					insert into PortalPregunta(PCid, PPparte, PPnumero, PPpregunta, PPtipo,PPorientacion, 
					PPvalor, PPrespuesta, BMfecha, BMUsucodigo, PPorden,PPmantener)
					values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_PCidReplica#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreguntas.PPparte#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreguntas.PPnumero#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_Desc#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#rsPreguntas.PPtipo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreguntas.PPorientacion#">,
							<cfqueryparam cfsqltype="cf_sql_decimal" value="#rsPreguntas.PPvalor#" scale="2">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPreguntas.PPrespuesta#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsPreguntas.PPorden#">,
							<cfqueryparam cfsqltype="cf_sql_bit" value="#rsPreguntas.PPmantener#">)
					<cf_dbidentity1 datasource="sifcontrol">
				</cfquery>
				<cf_dbidentity2 datasource="sifcontrol" name="rsInsertPreg">
			</cftransaction>
			<cfset Lvar_PPid =  rsInsertPreg.identity >
			<!--- INSERTA LAS RESPUESTAS DE LAS PREGUNTAS --->
			<cfquery datasource="sifcontrol">
				insert into PortalRespuesta( PCid, PPid, PRtexto, PRvalor, PRira, BMfecha, BMUsucodigo, PRorden)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_PCidReplica#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_PPid#">,
					 PRtexto, PRvalor, PRira, 
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
					PRorden
				from PortalRespuesta
				where PCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Machote#">
				  and PPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPreguntas.PPid#">
			</cfquery>
		</cfloop>
	</cfloop>
	</cfoutput>
	<cfset ira = "cuestionario-lista.cfm">
</cfif>

<!---Eliminar una pregunta con el boton de X--->
<cfif isdefined ('form.BorrarDet')>
	<cfquery name="eli" datasource="#session.dsn#">
		delete from PortalRespuesta where PCid=#form.PCid# and PRid=#form.BorrarDet#
	</cfquery>
		<cfset ira = "cuestionario.cfm?PCid=#form.PCid#&PPid=#form.PPid#&PPparte=#form.PPparte##pagina#&tab=3">
</cfif>

<cfset navegacion = '' >
<cfif isdefined('form.pageNum_lista') and len(trim(form.pageNum_lista)) >
	<cfset navegacion = navegacion & '&pageNum_lista=#form.pageNum_lista#' >
</cfif>
<cfif isdefined('form.fPCcodigo') and len(trim(form.fPCcodigo)) >
	<cfset navegacion = navegacion & '&fPCcodigo=#form.fPCcodigo#' >
</cfif>
<cfif isdefined("form.fPCnombre")  and len(trim(form.fPCnombre))  >
	<cfset navegacion = navegacion & '&fPCnombre=#form.fPCnombre#' >
</cfif>
<cfif isdefined("form.fPCdescripcion")  and len(trim(form.fPCdescripcion))  >
	<cfset navegacion = navegacion & '&fPCdescripcion=#form.fPCdescripcion#' >
</cfif>


<cflocation url="#ira##navegacion#">