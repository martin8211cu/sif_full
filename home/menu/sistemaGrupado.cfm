<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_GruModNoEncont = t.Translate('LB_GruModNoEncont','Grupo de modulo no encontrado','/home/menu/GrpModulos.xml')>
<style>
	i.IconFontGroup1 {font-size:4em; color: #fff;}
</style>
<!--- Actualizado 28/07/2015 --->
<cfset listaGModulo =''>
<cfset listModulo =''>
<cfset listNomModulo =''>
<cfset listaModuloIcon='icon-contabilidad-general,icon-estimacion-financiamiento-egresos,icon-activos-fijos'>

	<!--- Obtenemos los grupos modulos  --->
	<cfquery name="rsGmodulos" datasource="asp" >
		select SGcodigo, SGdescripcion, sg.SScodigo,sg.SGorden
			from SGModulos sg
			inner join SSistemas s
				on sg.SScodigo = s.SScodigo
			where sg.SScodigo = '#url.s#'
			order by sg.SGorden
	</cfquery>

		<!----- verifica que el usuario tenga los grupo de modulos ---->
		<cfoutput query="rsGmodulos">
			<cfquery  dbtype="query" name="rsValidaModulo">
				select distinct SGcodigo
					from rsContents
					where SGcodigo = #rsGmodulos.SGcodigo#
			</cfquery>
			<cftry>
				<cfif rsValidaModulo.RecordCount GT 0>
					<cfset listaGModulo=ListAppend(listaGModulo,rsGmodulos.SGcodigo)>
				</cfif>
			<cfcatch type="any">
				<cf_dump var="#rsValidaModulo#"/>
			</cfcatch>
			</cftry>
		</cfoutput> <!--Fin del iteracion --->


	<!--- Obtenemos los modulos de cortes habilitados--->
	<cfloop list="#listaGModulo#" index="valor">
		<cfquery datasource="asp" name="rsmodulos">
			select SMcodigo
				from SModulos sm
					inner join SSistemas m
						on sm.SScodigo = m.SScodigo
				where sm.SScodigo = '#url.s#'
				and sm.SGcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#valor#">
		</cfquery>
		<cfoutput query="rsmodulos">
			<cfset listModulo=ListAppend(listModulo,"'"&rsmodulos.SMcodigo&"'")>
		</cfoutput>
	</cfloop>

<!----- Valida los modulos ---->
	<cfset lismodulosSE = Trim(reReplace(listModulo," ","","All")) >
	<cfif lismodulosSE neq "">
		<cfquery name="rsmodulosDesc" dbtype="query">
			select *
			from rsContents
			where SMcodigo in (#preservesinglequotes(lismodulosSE)#)
			order by SMorden,SMdescripcion
		</cfquery>
	</cfif>

<!--- Contador para manejar los row --->
<cfset LvarCon=1>

<!--- Pinto los modulos --->
<div class="row">
	<cfloop list="#listaGModulo#" index="valor">
		<cfset LvarFilas="#(LvarCon MOD 3)#">
		<cfquery datasource="asp" name="rsIconNom">
			select SGcodigo, SGcodigo, SGdescripcion, sg.SScodigo, IconFonts
				from SGModulos sg
				inner join SSistemas s
					on sg.SScodigo = s.SScodigo
				where sg.SGcodigo = #valor#
		</cfquery>
		<cfif #LvarFilas# eq 0>
		<div class="row">
		</cfif>
			<div class="ModuloFather <cfif ListLen(listaGModulo) GT 2> col-lg-4 col-md-4 col-sm-4 col-xs-12 <cfelse>col-lg-6 col-md-6 col-sm-6 col-xs-12  </cfif> ">
				<div class="Modulo">
					<div class="row">
						<div class="ModuloGroup-label">
							<cfif rsIconNom.RecordCount GT 0>
								<cfinvoke component="sif.Componentes.TranslateDB"
									method="Translate"
									VSvalor="#trim(rsIconNom.SScodigo)#.#trim(rsIconNom.SGcodigo)#"
									Default="#rsIconNom.SGdescripcion#"
									VSgrupo="106"
									returnvariable="translated_GrpModulo"
								/>
								<i class="<cfif rsIconNom.IconFonts neq ""> <cfoutput>#rsIconNom.IconFonts# </cfoutput> IconFontGroup1 <cfelse> fa fa-folder-o fa-5x IconFontGroup1</cfif>"></i>
								<!--- Traduccion de grupo de modulos --->
								<cfset LB_NomGruMod = t.Translate('LB_NomGruMod','#rsIconNom.SGdescripcion#','/home/menu/sistema.xml')>
								<span><cfoutput>#translated_GrpModulo#</cfoutput></span>
							<cfelse>
								<i class="fa fa-folder-o IconFontGroup1"></i>
								<span><cfoutput>#LB_GruModNoEncont#</cfoutput></span>
							</cfif>
						</div>
					</div>
					<div class="row">
						<div class="ModuloGroup">
							<ul>
							<cfoutput query = "rsmodulosDesc">
								<cfif rsmodulosDesc.SGcodigo EQ #valor#>
								<!---Traducción del modulo--->
									<cfinvoke component="sif.Componentes.TranslateDB"
									method="Translate"
									VSvalor="#Trim(rsmodulosDesc.SScodigo)#.#Trim(rsmodulosDesc.SMcodigo)#"
									Default="#rsmodulosDesc.SMdescripcion#"
									VSgrupo="102"
									returnvariable="translated_Opcion"/>

										<cfif Len(Trim(rsmodulosDesc.SMhomeuri))>
											<cfset uri = '/cfmx/home/menu/pagina.cfm?s=' & URLEncodedFormat(rsmodulosDesc.SScodigo) & '&m=' & URLEncodedFormat(rsmodulosDesc.SMcodigo)>
										<cfelse>
											<cfset uri = '/cfmx/home/menu/modulo.cfm?s=' & URLEncodedFormat(rsmodulosDesc.SScodigo) & '&m=' & URLEncodedFormat(rsmodulosDesc.SMcodigo)>
										</cfif>
										<li>
											<a href="#uri#">
											<span>#translated_Opcion#</span>
											</a>
										</li>
										<!---Descripcion del modulo--->
										<cfset DescricionModulo = rsmodulosDesc.SMhablada>
										<cfset snapshot = "snapshot/" & rsmodulosDesc.SScodigo & "_" & rsmodulosDesc.SMcodigo & ".cfm">
										<cfif not FileExists( ExpandPath( snapshot))>
											<cfset snapshot = "">
										</cfif>
										<cfif len(trim(snapshot)) eq 0>
											<a class="menutitulo plantillaMenutitulo" href="#uri#"></a>
										<cfelse>
											<cftry>
												<cfinclude template="#snapshot#">
												<cfcatch>#translated_Opcion#</cfcatch>
											</cftry>
										</cfif>
								</cfif>
							</cfoutput>
							</ul>
						</div>
					</div>
				</div>
			</div>
		<cfif #LvarFilas# eq 0>
		</div>
		</cfif>
		<cfset LvarCon+=1>
	</cfloop>
</div><!--- Fin Pintado de modulos --->