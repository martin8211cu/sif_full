<cfcomponent>
	
	<cffunction name="RHInconsistencias" access="public" output="true" returntype="any">
		
			<cfargument 	name="Ecodigo"  		required="false" 	default="#session.Ecodigo#"	type="numeric">	<!--- Nombre del Ecodigo --->
			<cfargument 	name="Conexion"  		required="false" 	default="#session.DSN#" 	type="string">	<!--- Nombre del session --->
			<cfargument 	name="form" 			required="false" 	default="form1" 			type="String"> 	<!--- Nombre del form --->
			<cfargument 	name="RHIid" 			required="false"	default="" 					type="string"> 	<!--- id --->
			<cfargument 	name="RHIdescripcion" 	required="false" 	default="RHIdescripcion" 	type="string"> 	<!---  --->
			<cfargument 	name="index" 			required="false"	default=""					type="string"> 	<!--- Index del campo editable --->
			<cfargument 	name="funcion" 			required="false"	default=""					type="string"> 	<!--- funcion  on change--->
			<cfargument 	name="tabindex"			required="false"	default="-1"					type="numeric"> 	<!--- funcion  on change--->
			
			
			<!--- <cfquery name="rsAutoriza" datasource="#Arguments.Conexion#">
					Select Pvalor
					from RHParametros
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
						and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="510">
			</cfquery>
			 --->	
			 <!---<cfif rsAutoriza.Pvalor EQ 1> Pregunta si la empresa desea manejar detalle de inconsistencias --->
				
					<!--- Lista --->
					<!--- Variables de Traduccion --->
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="CMB_OmisionDeMarcaDeEntrada"
						Default="Omisión de Marca de Entrada"
						returnvariable="CMB_OmisionDeMarcaDeEntrada"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="CMB_OmisionDeMarcaDeSalida"
						Default="Omisión de Marca de Salida"
						returnvariable="CMB_OmisionDeMarcaDeSalida"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="CMB_DiaExtra"
						Default="Día Extra"
						returnvariable="CMB_DiaExtra"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="CMB_DiaLibre"
						Default="Día Libre"
						returnvariable="CMB_DiaLibre"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="CMB_LlegadaAnticipada"
						Default="Llegada Anticipada"
						returnvariable="CMB_LlegadaAnticipada"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="CMB_LlegadaTardia"
						Default="Llegada Tardía"
						returnvariable="CMB_LlegadaTardia"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="CMB_SalidaAnticipada"
						Default="Salida Anticipada"
						returnvariable="CMB_SalidaAnticipada"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="CMB_SalidaTarde"
						Default="Salida Tarde"
						returnvariable="CMB_SalidaTarde"/>

					<cfset idList= '1,2,3,4,5,6,7,8'>
					<cfset incosList=
							'#CMB_OmisionDeMarcaDeEntrada#,
							#CMB_OmisionDeMarcaDeSalida#,
							#CMB_DiaExtra#,
							#CMB_DiaLibre#,
							#CMB_LlegadaAnticipada#,
							#CMB_LlegadaTardia#,
							#CMB_SalidaAnticipada#,
							#CMB_SalidaTarde#'>	
					
					<!--- Lista --->
					<cfset RHIid_c="RHIid"& trim(Arguments.index)> 
					<cfif isdefined("Arguments.funcion") and len(trim(Arguments.funcion)) GT 0>
						<cfset funcionI ='javascript: '& trim(Arguments.funcion) &';'>
					</cfif>
					<select id="<cfoutput>#RHIid_c#</cfoutput>" name="<cfoutput>#RHIid_c#</cfoutput>" <cfif isdefined("funcionI")>onchange="<cfoutput>#funcionI#</cfoutput>"</cfif> tabindex="#Arguments.tabindex#">
						<option value=""></option>
						<cfloop From = "1" To = "#ListLen(idList)#" index="i">
							<cfset id= i-1>
							<option <cfif isdefined("Arguments.RHIid") and len(trim(Arguments.RHIid))neq 0 > <cfif listGetAt(idList, i) EQ toString(val(trim(Arguments.RHIid))+1)>selected</cfif> </cfif> value="<cfoutput>#id#</cfoutput>"><cfoutput>#listGetAt(incosList, i)#</cfoutput></option>
						</cfloop>
					</select>
					
			<!--- </cfif> --->
	</cffunction>
</cfcomponent>