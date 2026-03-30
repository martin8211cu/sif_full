<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Title" Default="Importar Catalogos" returnvariable="LB_Title"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Archivo" Default="Selecciones un archivo para importar:" returnvariable="LB_Archivo"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Method" Default="M&eacute;todo:" returnvariable="LB_Method"/>

<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Msg1" Default="Actualizar Existentes y Agregar Nuevos" returnvariable="LB_Msg1"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Msg2" Default="Solo Actualizar Existentes" returnvariable="LB_Msg2"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Msg3" Default="Solo Agregar Nuevos" returnvariable="LB_Msg3"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Msg4" Default="Reemplazar todo" returnvariable="LB_Msg4"/>

<cfif !isdefined('form.FILETOUPLOAD')>

	<div align="center" style="height:100%;vertical-align:middle;" valign="middle">
	<br/>
		<form action="widgets-import.cfm" onsubmit="return validate(this);" method="post" enctype="multipart/form-data">
			<cfoutput>#LB_Archivo#</cfoutput> 
			<input type="file" name="fileToUpload" id="fileToUpload" accept="text/plain, .txt"required>
			<cfoutput>#LB_Method#</cfoutput> 
			<select name="method" required>
				<option value="full"><cfoutput>#LB_Msg1#</cfoutput></option>
				<option value="update"><cfoutput>#LB_Msg2#</cfoutput></option>
				<option value="add"><cfoutput>#LB_Msg3#</cfoutput></option>
				<!---<option value="replace"><cfoutput>#LB_Msg4#</cfoutput></option> --->
			</select>
			<br/>
			<input type="submit" value="Upload" name="submit">
		</form>
	</div>

	<script>
	function validate(form) {
		var methodMsg = "";
		switch (document.getElementsByName('method')[0].value){
			case "full": 	methodMsg = "<cfoutput>#LB_Msg1#</cfoutput>"; 	break;
			case "update": 	methodMsg = "<cfoutput>#LB_Msg2#</cfoutput>";	break;
			case "add": 	methodMsg = "<cfoutput>#LB_Msg3#</cfoutput>";	break;
			<!---case "replace": methodMsg = "<cfoutput>#LB_Msg4#</cfoutput>";	break; --->
		}
		return confirm("Esta seguro de que quiere ["+methodMsg+"]?");
	}
	</script>
<cfelse>
	<cfset execImport = false>
	<cftry>
		<cfscript>
			myfile = FileRead("#form.FILETOUPLOAD#"); 
			record=deserializeJSON(myfile);
			execImport = true;
		</cfscript>
	<cfcatch>
		<cfthrow message = "Archivo da&ntilde;ado, no se puede cargar.">
	</cfcatch>
	</cftry>

	<cfif execImport>
		<cfset dictionary = structNew()>

		<cftransaction>

		<!--- Eliminar todos los widgets --->
		<!---
		<cfif form.Method eq 'replace' >
			<cfquery datasource="asp" name="rsValidaCodigo">
				delete from WidgetParametros;
				delete from Widget;
			</cfquery>
		</cfif>
		--->

		<!--- Itera sobre cada widget exportado --->
		<cfloop array="#record#" index="i" item="i">
			<cfset w = record[i]>
			<cfset newWidID = 0>

			<!--- Busca si el widget ya existe --->
			<cfquery datasource="asp" name="rsValidaCodigo">
				select WidID,WidCodigo,WidParentId from Widget where WidCodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#w.WIDCodigo#">
			</cfquery>

			<!--- Si tiene un padre, busca su id equivalente en el diccionario--->
			<cfset WidParentId = ''>
			<cfif w.WidParentId neq ''>
			<cfset WidParentId = dictionary[w.WidParentId]>
			</cfif>

			<cfif rsValidaCodigo.recordCount eq 0 && (form.Method eq 'full' || form.Method eq 'add')> <!--- Proceso para insercion de nuevo Widget --->
			<cfquery datasource="asp" name="q_Insert">
				INSERT INTO Widget(
					WidCodigo
					, WidTitulo
					, WidDescripcion
					, SScodigo
					, SMcodigo
					, WidPosicion
					, WidSize
					, WidTipo
					, WidMostrarTitulo
					, WidMostrarOpciones
					, WidSistema
					, WidActivo
					, WidDeveloper
					<cfif WidParentId neq ''> , WidParentId </cfif>
				)values(
				<!--- WidCodigo ---> 				      <cfqueryparam cfsqltype="cf_sql_varchar" value="#w.WidCodigo#">
				<!---  WidTitulo --->				    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#w.WidTitulo#">
				<!---  WidDescripcion --->			, <cfqueryparam cfsqltype="cf_sql_char" value="#w.WIDDescripcion#">
				<!---  SScodigo --->				    <cfif isdefined("w.SScodigo") and trim(w.SScodigo) NEQ "">
															, <cfqueryparam cfsqltype="cf_sql_char" value="#w.SScodigo#">
														<cfelse>
															, null
														</cfif>
				<!---  SMcodigo --->				    <cfif isdefined("w.SMcodigo") and w.SMcodigo NEQ "">
															, <cfqueryparam cfsqltype="cf_sql_char" value="#w.SMcodigo#">
														<cfelse>
															, null
														</cfif>
				<!---  WidPosicion --->				, <cfqueryparam cfsqltype="cf_sql_char" value="#w.WidPosicion#">
				<!---  WidSize --->					, <cfqueryparam cfsqltype="cf_sql_char" value="#w.WidSize#">
				<!---  WidTipo --->					, <cfqueryparam cfsqltype="cf_sql_char" value="#w.WidTipo#">
				<!---  WidMostrarTitulo --->			, <cfqueryparam cfsqltype="cf_sql_bit" value="#w.WidMostrarTitulo#">
				<!---  WidMostrarOpciones --->		, <cfqueryparam cfsqltype="cf_sql_bit" value="#w.WidMostrarOpciones#">
				<!---  WidSistema --->				, <cfqueryparam cfsqltype="cf_sql_bit" value="#w.WidSistema#">
				<!---  WidActivo --->					, <cfqueryparam cfsqltype="cf_sql_bit" value="#w.WidActivo#">
				<!---  WidDeveloper --->			  	, <cfqueryparam cfsqltype="cf_sql_char" value="#w.WidDeveloper#">
														<cfif WidParentId neq ''>
				<!---  WidParentId --->			      	, <cfqueryparam cfsqltype="cf_sql_integer" value="#WidParentId#">
														</cfif>
				
				);
				<cf_dbidentity1 datasource="asp">
			</cfquery>
			<cf_dbidentity2 datasource="asp" name="q_Insert" returnvariable="newWidID">
			<cfset dictionary[w.WidID] = newWidID>
			
			<cfelse><!--- Si ya existe el widget y el metodo implica actualizacion, actualiza el widget--->

			<cfif form.Method eq 'full' || form.Method eq 'update'>
				<cfquery datasource ="asp">
				UPDATE Widget
				SET
					SScodigo                	= <cfif isdefined("w.SScodigo") and trim(w.SScodigo) NEQ "">
													<cfqueryparam cfsqltype="cf_sql_char" value="#w.SScodigo#">
												<cfelse>
													null
												</cfif>
					, SMcodigo                	= <cfif isdefined("w.SMcodigo") and w.SMcodigo NEQ "">
													<cfqueryparam cfsqltype="cf_sql_char" value="#w.SMcodigo#">
												<cfelse>
													null
												</cfif>
					, WidTitulo               	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#w.WidTitulo#">
					, WidDescripcion          	= <cfqueryparam cfsqltype="cf_sql_char" value="#w.WidDescripcion#">
					, WidPosicion             	= <cfqueryparam cfsqltype="cf_sql_char" value="#w.WidPosicion#">
					, WidSize                 	= <cfqueryparam cfsqltype="cf_sql_char" value="#w.WidSize#">
					, WidTipo                	= <cfqueryparam cfsqltype="cf_sql_char" value="#w.WidTipo#">
					, WidMostrarTitulo 			= <cfqueryparam cfsqltype="cf_sql_bit" value="#w.WidMostrarTitulo#">
					, WidMostrarOpciones 		= <cfqueryparam cfsqltype="cf_sql_bit" value="#w.WidMostrarOpciones#">
					, WidSistema 				= <cfqueryparam cfsqltype="cf_sql_bit" value="#w.WidSistema#">
					, WidActivo 				= <cfqueryparam cfsqltype="cf_sql_bit" value="#w.WidActivo#">
					, WidDeveloper 				= <cfqueryparam cfsqltype="cf_sql_char" value="#w.WidDeveloper#">
				WHERE WidCodigo =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#w.WidCodigo#">
				</cfquery>
				<cfset newWidID = rsValidaCodigo.WidID>
				<cfset dictionary[w.WidID] = newWidID>
			</cfif>
			</cfif>

			<!--- Si el widget contiene parametros, itera sobre cada uno--->
			<cfloop array="#w.Params#" index="i" item="i">
			<cfset p = w.Params[i]>
			<!--- Busca si ya existe el parametro (Pcodigo) para el widget (newWidgetID) en cuestion --->
			<cfquery datasource="asp" name="rsValidaParams">
				select WidIDParam,WidID,Pcodigo from WidgetParametros 
				where WidID = <cfqueryparam cfsqltype="cf_sql_integer" value="#newWidID#" >
					and Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p.Pcodigo#" >
			</cfquery>

			<cfif rsValidaParams.recordCount eq 0 && (form.Method eq 'full' || form.Method eq 'add')> <!--- Proceso para insercion de nuevo Parametro --->
				<cfquery datasource="asp">
				insert into WidgetParametros (WidID,PCodigo,Pvalor,Pdescripcion,Ecodigo) values (
					<cfqueryparam cfsqltype="cf_sql_Integer" value="#newWidID#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#p.PCodigo#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#p.Pvalor#">
					, <cfqueryparam cfsqltype="cf_sql_varchar" value="#p.Pdescripcion#">
					, <cfqueryparam cfsqltype="cf_sql_Integer" value="#p.Ecodigo#">
				);
				</cfquery>
			<cfelse> <!--- Si ya existe el Paramtro y el metodo implica actualizacion, actualiza el parametro--->
				<cfif form.Method eq 'full' || form.Method eq 'update'>
				<cfquery datasource="asp">
					update WidgetParametros set
						WidID             = <cfqueryparam cfsqltype="cf_sql_Integer" value="#newWidID#">
					, PCodigo           = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p.PCodigo#">
					, PValor            = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p.Pvalor#">
					, Pdescripcion      = <cfqueryparam cfsqltype="cf_sql_varchar" value="#p.Pdescripcion#">
					, Ecodigo           = <cfqueryparam cfsqltype="cf_sql_Integer" value="#p.Ecodigo#">
					where WidIDParam = #rsValidaParams.WidIDParam#
				</cfquery>
				</cfif>
			</cfif>

			</cfloop >
		
		</cfloop>
		</cftransaction>
	</cfif>

	<script>
		window.location.replace("widgets.cfm")
	</script>
	
</cfif>
