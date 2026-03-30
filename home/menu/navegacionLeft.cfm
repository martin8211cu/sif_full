<cfset tDB = createObject("component","sif.Componentes.TranslateDB")>
<cfset request.continuarNavegacionLeft=true>
<style type="text/css">
	i{
		cursor: pointer;
	}
</style>
<div id="accordion" class="panel-group navegacionLeft">
    <cfif !isDefined("url.s") and isdefined("session.monitoreo.SMcodigo") and session.monitoreo.SMcodigo eq 'AUTO'>
        <cfinclude template="/rh/autogestion/plantilla/navegacionLeft.cfm">
    <cfelseif findnocase('menu/sistema.cfm',cgi.script_name) and isdefined("url.s")>
        <!---- encabezado del panel---->
        <div class="panel-heading sistema hidden-xs"></div>
        <div class="panel-heading sistema">
            <cfquery datasource="asp" name="rsSystemName">
                select SScodigo,SSlogo,SSdescripcion, ts_rversion as SStimestamp
                from SSistemas where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
            </cfquery>
            <h4><cfoutput>#tdb.translate(Trim(url.s),rsSystemName.SSdescripcion,101)#</cfoutput></h4>
        </div>
        <cfset PintaFavoritosLeftNav()>
         <div class="panel-heading sistema hidden-xs">
         </div>
        <div class="panel-heading logo text-center hidden-xs">
            <cfoutput>
            <!--- <cfset snapshot = "snapshot/" & rsSystemName.SScodigo& ".cfm">
                    <cfif not FileExists( ExpandPath( snapshot))>
                        <cfset snapshot = "">
                    </cfif>
                    <cfif Len(Trim(snapshot)) EQ 0>
                        <cfif isbinary(rsSystemName.SSlogo)>
                            <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="tsurl">
                                <cfinvokeargument name="arTimeStamp" value="#rsSystemName.SStimestamp#"/>
                            </cfinvoke>
                            <img src="../public/logo_sistema.cfm?s=#URLEncodedFormat(rsSystemName.SScodigo)#&amp;ts=#tsurl#" border="0" width="100em" height="110em">
                        <cfelse>
                            <img src="../public/imagen.cfm?f=/home/menu/imagenes/sistema_default.jpg" border="0" width="245" height="155">
                        </cfif>
                    <cfelse>
                        <cftry>
                            <cfinclude template="#snapshot#">
                            <cfcatch>#rsSystemName.SSdescripcion#<cfset snapshot=""></cfcatch>
                        </cftry>
                    </cfif> --->
            </cfoutput>
        </div>
    <cfelse>

  <cfset t=createObject("component","sif.Componentes.Translate")>
        <cfset LB_Menu = t.Translate('LB_Menu','Menú','/home/menu/sistema.xml')>
        <cfif !isDefined("url.s") and isDefined("session.monitoreo.SScodigo")>
            <cfset url.s=session.monitoreo.SScodigo>
        </cfif>
        <cfquery name="rsContents" datasource="asp">
            select
              rtrim(m.SScodigo) as SScodigo,
              rtrim(m.SMcodigo) as SMcodigo,
              m.SMdescripcion,
              m.SMhomeuri,s.SSdescripcion,m.SGcodigo
            from SSistemas s, SModulos m
            where s.SScodigo  = '#session.monitoreo.SScodigo#'
              and s.SScodigo = m.SScodigo
              and m.SMmenu = 1
              and exists (
                select 1
                from vUsuarioProcesos up
                where up.Usucodigo = #Session.Usucodigo#
                  and up.Ecodigo   = #Session.EcodigoSDC#
                  and up.SScodigo  = '#session.monitoreo.SScodigo#'
                  and up.SScodigo = m.SScodigo
                  and up.SScodigo = s.SScodigo
                  and up.SMcodigo = m.SMcodigo)
            order by coalesce(m.SMorden, 9999), upper( m.SMdescripcion )
        </cfquery>

        <cfif rsContents.RecordCount EQ 1>
            <cfset session.menues.Modulo1 = true>
        </cfif>

        <cfquery name="empresa" datasource="asp">
            select Enombre
            from Empresa
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
        </cfquery>

        <cfquery name="sistema" datasource="asp">
            select SScodigo,SSlogo,SSdescripcion, ts_rversion as SStimestamp
            from SSistemas
            where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.monitoreo.SScodigo#">
        </cfquery>

        <!--- ver sif_login02.css <cfhtmlhead text='<link href="/cfmx/home/menu/menu.css" rel="stylesheet" type="text/css">'> --->
        <cfset request.PNAVEGACION_SHOWN = 1>

		<!--- Menu dinamicamente --->

		<cfset listaGModulo =''>
		<cfset listModulo =''>
		<cfset LvarMenuNoColapsar=''>

		<!---- encabezado del panel---->
        <div class="panel-heading iconNav iconShowNavegation"><i class="fa fa-bars fa-2x"></i>&nbsp;&nbsp;&nbsp;<h4><cfoutput>#LB_Menu#</cfoutput></h4></div>
        <div class="panel-heading modulo">
            <cfquery datasource="asp" name="rsSystemName">
                select SScodigo,SSlogo,SSdescripcion, ts_rversion as SStimestamp
                from SSistemas where SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.s#">
            </cfquery>
            <h4><cfoutput>#tdb.translate(Trim(url.s),rsSystemName.SSdescripcion,101)#</cfoutput></h4>
        </div>

	<!--- Obtenemos los grupos modulos  --->
	<cfquery name="rsGmodulos" datasource="asp" >
		select SGcodigo, SGdescripcion, sg.SScodigo
			from SGModulos sg
			inner join SSistemas s
				on sg.SScodigo = s.SScodigo
			where sg.SScodigo = '#url.s#'
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
			order by SMdescripcion
		</cfquery>
	</cfif>

<!--- Pintando --->
	<cfloop list="#listaGModulo#" index="valor">
		<cfquery datasource="asp" name="rsIconNom">
			select SGcodigo, SGdescripcion, sg.SScodigo, IconFonts
				from SGModulos sg
				inner join SSistemas s
					on sg.SScodigo = s.SScodigo
				where sg.SGcodigo = #valor#
		</cfquery>
		<!----- consulta por el menu activo----->
	     <cfif !len(LvarMenuNoColapsar)>
	         <cfquery name="rsCheckMenuActivo1" dbtype="query">
	             select 1 from rsmodulosDesc
	             where SMcodigo ='#trim(session.monitoreo.SMcodigo)#'
	             and SGcodigo =  #valor#
	         </cfquery>
	         <cfif rsCheckMenuActivo1.recordcount>
	             <cfset LvarMenuNoColapsar = valor>
	         </cfif>
	     </cfif>

		<div class="panel panel-default navMenu">
	        <div class="panel-heading">
		        <h4 class="panel-title">
		       	<a data-toggle="collapse" data-parent="#accordion" href="#LeftNavigationCollapse<cfoutput>#valor#</cfoutput>">
					<cfinvoke component="sif.Componentes.TranslateDB"
						method="Translate"
						VSvalor="#trim(rsIconNom.SScodigo)#.#trim(rsIconNom.SGcodigo)#"
						Default="#rsIconNom.SGdescripcion#"
						VSgrupo="106"
						returnvariable="LB_NomGruMod"
					/>
				<span><cfoutput>#LB_NomGruMod#</cfoutput></span>
				</a>
		        </h4>
	        </div>
     		<div id="LeftNavigationCollapse<cfoutput>#valor#</cfoutput>" class="panel-collapse collapse<cfif LvarMenuNoColapsar eq valor> in</cfif>">
	            <div class="panel-body">
	                <ul class="list-group">
	                <cfoutput query="rsmodulosDesc">
		                <cfif rsmodulosDesc.SGcodigo EQ #valor#>
		                    <cfif Len(Trim(rsmodulosDesc.SMhomeuri))>
		                        <cfset uri = '/cfmx/home/menu/pagina.cfm?s=' & URLEncodedFormat(rsmodulosDesc.SScodigo) & '&m=' & URLEncodedFormat(rsmodulosDesc.SMcodigo)>
							<cfelse>
		                        <cfset uri = '/cfmx/home/menu/modulo.cfm?s=' & URLEncodedFormat(rsmodulosDesc.SScodigo) & '&m=' & URLEncodedFormat(rsmodulosDesc.SMcodigo)>
		                    </cfif>
		                    <a href="#uri#">
			                    <li class="list-group-item<cfif isDefined("session.monitoreo.SMcodigo")
			                    	and ucase(trim(session.monitoreo.SMcodigo)) eq ucase(trim(rsmodulosDesc.SMcodigo))> selected</cfif>">
				                    #tDB.translate(Trim(SScodigo)&'.'&Trim(SMcodigo),SMdescripcion,102)#
								</li>
							</a>
		                </cfif>
					</cfoutput>
	                </ul>
	            </div>
        	</div>
         </div>
	</cfloop>

	<cfset PintaFavoritosLeftNav()>

	<div class="panel-heading sistema hidden-xs"></div>
    <div class="panel-heading logo text-center hidden-xs">
        <cfoutput>
            <cfset snapshot = "snapshot/" & sistema.SScodigo& ".cfm">
                <cfif not FileExists( ExpandPath( snapshot))>
                    <cfset snapshot = "">
                </cfif>
                <cfif Len(Trim(snapshot)) EQ 0>
                    <!--- <cfif isbinary(sistema.SSlogo)>
                        <cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="tsurl">
                            <cfinvokeargument name="arTimeStamp" value="#sistema.SStimestamp#"/>
                        </cfinvoke>
                        <img src="/cfmx/home/public/logo_sistema.cfm?s=#URLEncodedFormat(sistema.SScodigo)#&amp;ts=#tsurl#" border="0" width="140px" height="140px">
                    <cfelse>
                        <img src="/cfmx/home/public/imagen.cfm?f=/home/menu/imagenes/sistema_default.jpg" border="0" width="140px" height="140px">
                    </cfif> --->
                <cfelse>
                    <cftry>
                        <cfinclude template="#snapshot#">
                        <cfcatch>#sistema.SSdescripcion#<cfset snapshot=""></cfcatch>
                    </cftry>
                </cfif>
        </cfoutput>
    </div>
<!--- Fin menu dinamico --->
    </cfif>
</div>


<cffunction name="PintaFavoritosLeftNav">
	<div class="panel panel-default navMenu">
	    <div class="panel-heading">
	        <h4 class="panel-title">
	            <a data-toggle="collapse" data-parent="#accordion" href="#listaFavoritosCollapse"  class="collapsed"><i class="fa fa-star"></i> <cf_translate key="LB_Favoritos" xmlFile="/rh/generales.xml">Favoritos</cf_translate></a>
	        </h4>
	    </div>
	    <div  class="panel-collapse collapse" id="listaFavoritosCollapse">
	        <div class="panel-body">
	            <ul class="list-group" id="listaFavoritos"></ul>
	        </div>
	        <cfoutput>
	            <cfif !FindNoCase('/menu/modulo.cfm', cgi.script_name) and !FindNoCase('/menu/sistema.cfm', cgi.script_name)>
	                <center><button type="button" id="NavLeftAddFavorite" class="btn btn-primary btn-xs"><i  class="fa fa-plus-square-o"></i> Agregar este proceso</button></center>
	            </cfif>
	        </cfoutput>
	    </div>
	</div>

	<script src="/cfmx/jquery/librerias/navFavoritos.js"></script>
	<script type="text/javascript">
	    $(document).ready(function(){
	        <cfoutput>
	        window.favoritos.setCurrentURL('#session.monitoreo.SScodigo#.#session.monitoreo.SMcodigo#.#session.monitoreo.SPcodigo#');
	        </cfoutput>
	        window.favoritos.loadFavorites();
	    });
	</script>
</cffunction>