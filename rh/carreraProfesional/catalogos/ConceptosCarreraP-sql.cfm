<cfset params = ''>
<cfif isdefined('form.Nuevo')><cfset params = params & '&Nuevo=Nuevo'></cfif>
<cfif not isdefined("Form.Nuevo")>
<cftransaction>
	<cftry>
		<cfif isdefined("Form.Alta")>
			<cfquery name="InsertConceptosCarrera" datasource="#Session.DSN#">			
				insert into ConceptosCarreraP 
					(Ecodigo, CCPcodigo, CCPdescripcion,<!---  CIid, ---> TCCPid, CCPplazofijo,CCPacumulable, CCPporcsueldo, 
						CCPfactorpunto, CCPmaxpuntos, CCPpagoCada, UECPid, CCPequivalenciapunto, CCPvalor, 
						CCPpuntofraccionable, CCPpuestosEspecificos,CCPcategoriasEspecificas,CCPprioridad, CCPpagoXdia, CCPaprobacion, BMUsucodigo, BMfechaalta)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCPcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCPdescripcion#">, 
					<!--- <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">, --->
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.TCCPid#">,
					<cfif isdefined("Form.CCPplazofijo")>1<cfelse>0</cfif>,
					<cfif isdefined("Form.CCPacumulable")>1<cfelse>0</cfif>,
					<cfif not isdefined("Form.CCPporcsueldo")>
						0,
						<cfqueryparam cfsqltype="cf_sql_money" value="#form.CCPfactorpunto#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CCPmaxpuntos#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CCPpagoCada#">,
						<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.UECPid#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.CCPequivalenciapunto,',','')#">,
					<cfelse>
					1,1,null,1,10,1,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#Replace(form.CCPvalor,',','')#">,
					<cfif isdefined("Form.CCPpuntofraccionable")>1<cfelse>0</cfif>,
					<cfif isdefined("Form.CCPpuestosEspecificos")>1<cfelse>0</cfif>,
					<cfif isdefined("Form.CCPcategoriasEspecificas")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CCPprioridad#">,
					<cfif isdefined("Form.CCPpagoXdia")>1<cfelse>0</cfif>,
					<cfif isdefined("Form.CCPaprobacion")>1<cfelse>0</cfif>,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
				<cf_dbidentity1 datasource="#session.DSN#">
			</cfquery>				
			<cf_dbidentity2 datasource="#session.DSN#" name="InsertConceptosCarrera">
			<!--- VERIFICA SI SE APLICA PARA PUESTOS ESPECIFICOS, Y LLENA LA TABLA DE PuestosxConceptoCP, SI ES PARA TODOS LOS
				PUESTOS SE BUSCAN EN LA TABLA Y SI HAY SE ELIMINAN --->
			<cfif isdefined("Form.CCPpuestosEspecificos") and isdefined('form.PuestoIdList')>
				<cfloop list="#form.PuestoIDlist#" index="i">
					<cfquery name="insertaPuestos" datasource="#session.DSN#">
						insert into PuestosxConceptoCP (Ecodigo, CCPid, RHPcodigo, BMUsucodigo, BMfechaalta)
						values(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#InsertConceptosCarrera.identity#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#i#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)
					</cfquery>
				</cfloop>
			</cfif>
			<!--- VERIFICA SI SE APLICA PARA CATEGORÍAS ESPECIFICAS, Y LLENA LA TABLA DE ConceptosCPCategoria --->
			<cfif isdefined("Form.CCPcategoriasEspecificas") and isdefined('form.CatIdList')>
				<cfloop list="#form.CatIDlist#" index="i">
					<cfquery name="insertaCat" datasource="#session.DSN#">
						insert into ConceptosCPCategoria (CCPid, RHCid, BMUsucodigo, BMfecha)
						values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#InsertConceptosCarrera.identity#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#i#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)
					</cfquery>
				</cfloop>
			</cfif>
			<cfset modo="ALTA">
			<cfset params = 'modo='& modo>
		<cfelseif isdefined("Form.Baja")>
			<!--- ELIMINA  LAS CATEGORIAS A LAS CUALES SE APLICA EL CONCEPTO EN CASO QUE LOS TENGA --->		
			<cfquery name="deletePuestos" datasource="#session.DSN#">
				delete from ConceptosCPCategoria where CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CCPid#">
			</cfquery>
			<!--- ELIMINA  LOS PUESTOS A LOS CUALES SE APLICA EL CONCEPTO EN CASO QUE LOS TENGA --->		
			<cfquery name="deletePuestos" datasource="#session.DSN#">
				delete from PuestosxConceptoCP where CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CCPid#">
			</cfquery>
			<cfquery name="ABC_ConceptosCarrera" datasource="#Session.DSN#">
				delete from ConceptosCarreraP where CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CCPid#">
			</cfquery>
			<cfset modo="BAJA">
			<cfset params = 'modo='& modo>
		<cfelseif isdefined("Form.Cambio")>
			<cf_dbtimestamp
				datasource="#Session.DSN#"
				table="ConceptosCarreraP"
				redirect="ConceptosCarreraP-form.cfm"
				timestamp="#form.ts_rversion#"
				field1="CCPid,numeric,#Form.CCPid#">
			<cfquery name="UpdateConceptosP" datasource="#session.DSN#">
				update ConceptosCarreraP
				set CCPcodigo 	   	= <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCPcodigo#">, 
					CCPdescripcion 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCPdescripcion#">, 
					<!--- CIid 			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CIid#">,  --->
					TCCPid 			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.TCCPid#">, 
					CCPplazofijo 	= <cfif isdefined("Form.CCPplazofijo")>1<cfelse>0</cfif>, 
					CCPporcsueldo 	= <cfif isdefined("Form.CCPporcsueldo")>1<cfelse>0</cfif>, 
					CCPvalor 		= <cfqueryparam cfsqltype="cf_sql_numeric" scale="4" value="#Replace(form.CCPvalor,',','')#">,
					CCPacumulable 	= <cfif isdefined("Form.CCPacumulable")>1<cfelse>0</cfif>, 
					CCPpuntofraccionable = <cfif isdefined("Form.CCPpuntofraccionable")>1<cfelse>0</cfif>,
					CCPpuestosEspecificos = <cfif isdefined("Form.CCPpuestosEspecificos")>1<cfelse>0</cfif>,
					CCPcategoriasEspecificas = <cfif isdefined("Form.CCPcategoriasEspecificas")>1<cfelse>0</cfif>,
					<cfif not isdefined("Form.CCPporcsueldo")>
						CCPfactorpunto  = <cfqueryparam cfsqltype="cf_sql_money" value="#Replace(form.CCPfactorpunto,',','')#">, 
						CCPmaxpuntos 	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Replace(Form.CCPmaxpuntos,',','')#">,
						CCPpagoCada 	= <cfif isdefined("Form.CCPacumulable")><cfqueryparam cfsqltype="cf_sql_integer" value="#Replace(Form.CCPpagoCada,',','')#"><cfelse>1</cfif>,
						UECPid 			= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.UECPid#">,
						CCPequivalenciapunto = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.CCPequivalenciapunto,',','')#">,
					<cfelse>
						CCPpagoCada = 1,
					</cfif>
					CCPprioridad  = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.CCPprioridad#">,
					CCPpagoXdia   = <cfif isdefined("Form.CCPpagoXdia")>1<cfelse>0</cfif>,
					CCPaprobacion = <cfif isdefined("Form.CCPaprobacion")>1<cfelse>0</cfif>,
					BMUsucodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					BMfechaalta   = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CCPid#">
			</cfquery>
			<!--- VERIFICA SI SE APLICA PARA PUESTOS ESPECIFICOS, Y LLENA LA TABLA DE PuestosxConceptoCP, SI ES PARA TODOS LOS
				PUESTOS SE BUSCAN EN LA TABLA Y SI HAY SE ELIMINAN --->
			<cfquery name="deletePuestos" datasource="#session.DSN#">
				delete from PuestosxConceptoCP where CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CCPid#">
			</cfquery>
			<cfif isdefined("Form.CCPpuestosEspecificos") and isdefined('form.PuestoIdList')>
				<cfloop list="#form.PuestoIDlist#" index="i">
					<cfquery name="insertaPuestos" datasource="#session.DSN#">
						insert into PuestosxConceptoCP (Ecodigo, CCPid, RHPcodigo, BMUsucodigo, BMfechaalta)
						values(
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CCPid#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#i#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)
					</cfquery>
				</cfloop>
			</cfif>
			<!--- VERIFICA SI SE APLICA PARA CATEGORIAS ESPECIFICAS, Y LLENA LA TABLA DE ConceptosCPCategoria, SI ES PARA TODOS LOS
				PUESTOS SE BUSCAN EN LA TABLA Y SI HAY SE ELIMINAN --->
			<cfquery name="deletePuestos" datasource="#session.DSN#">
				delete from ConceptosCPCategoria where CCPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CCPid#">
			</cfquery>
			<cfif isdefined("Form.CCPcategoriasEspecificas") and isdefined('form.CatIdList')>
				<cfloop list="#form.CatIDlist#" index="i">
					<cfquery name="insertaCat" datasource="#session.DSN#">
						insert into ConceptosCPCategoria (CCPid, RHCid, BMUsucodigo, BMfecha)
						values(
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CCPid#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#i#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
							<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
						)
					</cfquery>
				</cfloop>
			</cfif>
 			<cfset modo="CAMBIO">	
			<cfset params = 'modo='& modo & '&CCPid=' & form.CCPid> 			  				  
		</cfif>			
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
	</cftransaction>
</cfif>
<cfoutput>
	<cfif isdefined("Form.filtro_CCPcodigo") and Len(Trim(Form.filtro_CCPcodigo)) NEQ 0>
		<cfset params = params  & '&filtro_CCPcodigo=' & form.filtro_CCPcodigo> 
	</cfif>
	<cfif isdefined("Form.filtro_CCPdescripcion") and Len(Trim(Form.filtro_CCPdescripcion)) NEQ 0>
		<cfset params = params  & '&filtro_CCPdescripcion=' & form.filtro_CCPdescripcion> 
	</cfif>
	<cfif isdefined("Form.Pagina") and Len(Trim(Form.Pagina)) gt 0>
		<cfset params = params  & '&Pagina=' & form.Pagina> 
	</cfif>
	<cflocation url="ConceptosCarreraP.cfm?#params#">
</cfoutput>
