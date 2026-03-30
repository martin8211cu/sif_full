<cfsetting enablecfoutputonly="yes">
<cfquery name="header__rsEmpresasU" datasource="asp" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
	select distinct Ecodigo
	from vUsuarioProcesos up
	where up.Usucodigo = #Session.Usucodigo#
</cfquery>
<cfset LvarEmpresasUsuario = "">
<cfif header__rsEmpresasU.recordcount>
	<cfset LvarEmpresasUsuario=valueList(header__rsEmpresasU.Ecodigo)>
</cfif>
<cf_translatedata name="get" tabla="Empresa" conexion="asp" col="e.Enombre" returnvariable="LvarEnombre">
<cfquery name="header__rsEmpresas" datasource="asp" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
	select
		 #LvarEnombre# as Enombre
		, e.Ecodigo
		, e.Ereferencia as Ereferencia
		, upper( e.Enombre ) as Enombre_upper
		, ((select min(c.Ccache)
			from Caches c
			where c.Cid = e.Cid
		)) as Ccache
		, e.ts_rversion as ts_rversion
	from Empresa e
	where e.Ecodigo   in (#LvarEmpresasUsuario#)
	  and e.CEcodigo   = #Session.CEcodigo#
	<cfif Len(session.sitio.Ecodigo) and session.sitio.Ecodigo neq 0>
	  and e.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.sitio.Ecodigo#">
	<cfelse>
	  order by Enombre
	</cfif>
</cfquery>
<cfset tDB=createObject("component","sif.Componentes.TranslateDB")>
<cf_translatedata name="get" tabla="Empresa" conexion="asp" col="e.Enombre" returnvariable="LvarEnombre">
<cfquery name="rsNombreEmpresa" datasource="asp" >
		select #LvarEnombre# as Enombre
		from Empresa e
		where e.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		<cfif Len(session.sitio.Ecodigo) and session.sitio.Ecodigo neq 0>
		  and e.Ecodigo   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.sitio.Ecodigo#">
		<cfelseif isdefined("session.EcodigoSDC") and session.EcodigoSDC neq 0>
			and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.EcodigoSDC#">
		</cfif>
</cfquery>
<cfif rsNombreEmpresa.RecordCount gt 0>
	<cfset session.Enombre=rsNombreEmpresa.Enombre>
</cfif>

<cfset Lvarlogeado=true>
<cfif !(IsDefined('session.Usucodigo') And Len(session.Usucodigo) and Session.Usucodigo NEQ 0)>
	<cfset Lvarlogeado=false>
</cfif>
<cfsetting enablecfoutputonly="no">

<cfhtmlhead text='
		<script type="text/javascript">
		function changeEnterprise(e) {
		 document.getElementById("seleccionar_EcodigoSDC").value=e;
		 document.header__formempresas.submit();
		}
		</script>'>

	<cfset header__rsContents_count = 0>
		<!---- navegacion bootstrap--------------------->


	<div class="row">
		<cfif Lvarlogeado>
			<div class="col col-sm-2 header-col">
				<cfif header__rsEmpresas.recordcount>
					<cfloop query="header__rsEmpresas">
						<cfif Ecodigo EQ session.EcodigoSDC>
							<div class="logoEmp">
								<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="tsurl" arTimeStamp="#ts_rversion#"> </cfinvoke>
								<cfoutput>
									<a href="/cfmx/home/">
										<img src="/cfmx/home/public/logo_empresa.cfm?EcodigoSDC=#session.EcodigoSDC#&amp;ts=#tsurl#" class="iconoEmpresa"  alt="logo" border="0" height="55" width="160">
									</a>
								</cfoutput>
							</div>
							<cfbreak>
						</cfif>
					</cfloop>

					<!--- drilldrop de empresas que el usuario puede seleccionar----->
					<!--- <cfif IsDefined('session.Usucodigo') And Len(session.Usucodigo) and Session.Usucodigo NEQ 0>
						<div class="dropdown">
							<cfoutput>
								<cfif header__rsEmpresas.RecordCount gt 1>
									<button class="btn btn-default dropdown-toggle" type="button" id="dd-menu" data-toggle="dropdown">
										#session.Enombre# <span class="caret"></span>
									</button>
									<ul class="dropdown-menu" role="menu">
										<cfloop query="header__rsEmpresas">
											<cfif header__rsEmpresas.Ecodigo neq session.EcodigoSDC>
												<li role="presentation">
													<a href="javascript:changeEnterprise(#Ecodigo#)" role="menuitem" tabindex="-1">#HTMLEditFormat( REReplace( Enombre, '<[^>]+>', '', 'all') )#</a>
												</li>
											</cfif>
										</cfloop>
										<form style="display:inline;" name="header__formempresas" id="header__formempresas" action="/cfmx/home/menu/index.cfm">
											<input type="hidden" name="seleccionar_EcodigoSDC" id="seleccionar_EcodigoSDC">
										</form>
									</ul>
								<cfelse>
									<button class="btn btn-default noneHover" type="button">
										#session.Enombre#
									</button>
								</cfif>
							</cfoutput>
						</div>
					</cfif> --->
				</cfif>
			</div>
		</cfif>
		<div class="col <cfif Lvarlogeado>col-sm-10<cfelse>col-sm-12</cfif> header-col">
			<nav class="navbar navbar-default" role="navigation">
			  <!-- Brand and toggle get grouped for better mobile display  -->

			  	<div class="navbar-header">
			  		<a class="navbar-brand visible-xs visible-sm" href="/cfmx/home/">ERP | Soluciones Integrales S.A.</a>
					<button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
						<span class="sr-only">Toggle navigation</span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
						<span class="icon-bar"></span>
					</button>
				</div><!--- fin de div de navegacion izquierda---->


			  <!-- Collect the nav links, forms, and other content for toggling -->
			  <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">

			  	<cfset LvarSistema = ''>
			  	<cfif !findnocase("/home/menu/empresa.cfm",cgi.script_name)>
				  	<cfif isdefined("session.monitoreo.SScodigo")>
				  		<cfset LvarSistema = session.monitoreo.SScodigo>
				  	</cfif>
				  	<cfif isdefined("url.s")>
				  		<cfset LvarSistema = url.s>
				  	</cfif>
			  	</cfif>

			  	<cfset LvarContentPrintHeader=''>
				<cfif IsDefined('session.Usucodigo') And Len(session.Usucodigo) and Session.Usucodigo NEQ 0>
					<cfset Obtieneheader__rsContents()>
					<cfsavecontent variable="LvarContentPrintHeader">
						<cfoutput query="header__rsContents" group="SScodigo">
							<cfset header__rsContents_count = header__rsContents_count + 1>
							<cfif header__rsContents_count lte 4>
								<li>
									<a href="/cfmx/home/menu/sistema.cfm?s=#URLEncodedFormat( Trim (SScodigo) )#" class="hidden-sm itemSystem">
										<div class="opciones_menu <cfif LvarSistema eq SScodigo>opcion_activa</cfif>">
											<h1>#tDB.Translate(SScodigo,SSdescripcion,101)#</h1>
										</div>
									</a>
								</li>
							</cfif>
						</cfoutput>
					</cfsavecontent>
				</cfif>

				<ul class="nav navbar-nav">
					<li>
					  	<a href="/cfmx/home/" class="hidden-sm itemSystem">
							<div class="opciones_menu <cfif findnocase('/menu/empresa.cfm',cgi.script_name)>opcion_activa</cfif>">
								<h1><cf_translate key="LB_Inicio" xmlFile="/rh/generales.xml">INICIO</cf_translate></h1>
							</div>
					  	</a>
				  	</li>
					<!---botones de los sistemas--->
					<cfif !findnocase('/menu/empresa.cfm',cgi.script_name) >
						<cfoutput>#LvarContentPrintHeader#</cfoutput>
					</cfif>
					<!--- fin de botones de los sistemas---->
				</ul>

				<!---- opciones del usuario------>
				<ul class="nav navbar-nav navbar-right headerUsuario">
					<li>
						<cfif header__rsEmpresas.recordcount>
							<!--- drilldrop de empresas que el usuario puede seleccionar----->
							<cfif IsDefined('session.Usucodigo') And Len(session.Usucodigo) and Session.Usucodigo NEQ 0>
									<a <cfif header__rsEmpresas.RecordCount gt 1>data-toggle="dropdown" class="dropdown-toggle text-center"</cfif> href="#">
										<div class="headerIconMenu">
											<h4>
												<cfoutput>#session.Enombre#</cfoutput>
												<cfif header__rsEmpresas.RecordCount gt 1><i class="fa fa-retweet"></i></cfif>
											</h4>
										</div>
									</a>
									<cfoutput>
										<cfif header__rsEmpresas.RecordCount gt 1>
											<ul class="dropdown-menu" role="menu">
												<cfloop query="header__rsEmpresas">
													<cfif header__rsEmpresas.Ecodigo neq session.EcodigoSDC>
														<li role="presentation">
															<a href="javascript:changeEnterprise(#Ecodigo#)" role="menuitem" tabindex="-1">#HTMLEditFormat( REReplace( Enombre, '<[^>]+>', '', 'all') )#</a>
														</li>
													</cfif>
												</cfloop>
												<form style="display:inline;" name="header__formempresas" id="header__formempresas" action="/cfmx/home/menu/index.cfm">
													<input type="hidden" name="seleccionar_EcodigoSDC" id="seleccionar_EcodigoSDC">
												</form>
											</ul>
										</cfif>
									</cfoutput>
								<!--- <div class="dropdown">
									<cfoutput>
										<cfif header__rsEmpresas.RecordCount gt 1>
											<button class="btn btn-default dropdown-toggle" type="button" id="dd-menu" data-toggle="dropdown">
												#session.Enombre# <span class="caret"></span>
											</button>

										<cfelse>
											<button class="btn btn-default noneHover" type="button">
												#session.Enombre#
											</button>
										</cfif>
									</cfoutput>
								</div> --->
							</cfif>
						</cfif>
					</li>

					<!----- notificaciones---->
					<cfinvoke component="commons.Componentes.Notifier" method="get" returnvariable="Notifications">
						<cfinvokeargument name="dsn" value="#session.dsn#">
						<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#">
					</cfinvoke>
						<cfquery datasource="#session.dsn#" name="rsInfoHSa" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
							select  max(llave) as llave
							from UsuarioReferencia
							where STabla ='DatosEmpleado'
								and Usucodigo = #session.Usucodigo#
						</cfquery>
						<cfset condicionHe=0>
						<cfset condicionDeidLLave=0>
						<cfif len(trim(rsInfoHSa.llave))>
							<cfset condicionDeidLLave=rsInfoHSa.llave>
							<cfquery datasource="#session.dsn#" name="rsInfoHSa" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
								select ts_rversion
								from RHImagenEmpleado
								where DEid=#condicionDeidLLave#
							</cfquery>
							<cfif rsInfoHSa.recordcount>
								<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="condicionHe" arTimeStamp="#rsInfoHSa.ts_rversion#">
							</cfif>
						</cfif>

						<li>
							<a data-toggle="dropdown" class="dropdown-toggle text-center" href="#">
								<!---- imagen del empleado ---->
								<!--- OPARRALES No mostraba correctamente la imagen 2018-05-22
									  <img src="/cfmx/home/public/foto_Empleado.cfm?<cfoutput>DEid=#condicionDeidLLave#&ts=#condicionHe#</cfoutput>" class="imgUsuario"  alt="logo" border="0" width="49" height="50">
								 --->
								<!---
								<cfset form.DEid = condicionDeidLLave>
								 --->
								<cfoutput>
								<cf_sifleerimagen autosize="false" border="false" tabla="RHImagenEmpleado"
									campo="foto" condicion="DEid = #condicionDeidLLave#" conexion="#Session.DSN#"
									width="49" height="50" clases="img-circle">
									<!--- campo="foto" condicion="DEid = #form.DEid#" conexion="#Session.DSN#" --->
								</cfoutput>
								<!--- OPARRALES Fin cambio imagen --->

									<cfif Notifications.recordcount>
										<cfquery dbtype="query" name="cantidadNotificaciones">
											select distinct ProcessInstanceId, NotifyId from Notifications
										</cfquery>
										<span class="nav-counter badge-important anim-swing"><cfoutput>#cantidadNotificaciones.recordcount#</cfoutput></span>
									</cfif>
								<cfif isDefined("session.datos_personales")>
									<!----- nombre del usuario---->
									<cfoutput>#session.datos_personales.nombre# #session.datos_personales.Apellido1# #mid(session.datos_personales.Apellido2,1,1)#.</cfoutput>
								</cfif>
							</a>

							<ul class="dropdown-navbar dropdown-menu">
								<cfif Notifications.recordcount>
									<ul class="list-group">
										<cfoutput query="Notifications">
											<cfif NotifyID eq 0>
												<a href="#NotifyUrl#">
											<cfelse>
												<a href="##" onclick="viewNotify(#NotifyID#,'#NotifyUrl#');">
											</cfif>
							                <li class="list-group-item Notifications-list">
							                  <span class="badge"><img width="30px" src="/cfmx/home/public/foto_Empleado.cfm?Usucodigo=#trim(NotifyUsucodigoRef)#"></span>
							                  <p>Fecha: #dateformat(Notifyfecha,"dd/mm/yyyy")# #timeformat(Notifyfecha,"H:mm:ss")#<br>#NotifyAsunto#</p>
							                </li>
							                </a>
							            </cfoutput>
							        </ul>
							    </cfif>
							    <!--- preferencias---->
							    <cfif Lvarlogeado>
									<li>
										<a href="/cfmx/home/menu/micuenta/" class="menuConfiguracionUsuario"><div class="headerIconMenu"><i class="fa fa-gear"></i><cf_translate key="LB_Preferencias" XmlFile="/sif/plantillas.xml">Preferencias</cf_translate></div></a>
								 	</li>
							 	</cfif>
							 	<!------ salir----->
								<li>
									<a href="/cfmx/home/public/logout.cfm" ><div class="headerIconMenu logoutIcon"><i class="fa fa-sign-out"></i><cf_translate key="LB_Salir" XmlFile="/sif/plantillas.xml">Salir</cf_translate></div></a>
							 	</li>
							</ul>
						</li>
					</ul>
				<!---- fin de opciones del usuario---->

			  </div>
			</nav>
			<div class="linea_color"></div>
			<cfif Lvarlogeado>
				<cfinclude template="/home/menu/pNavegacion.cfm">
			</cfif>
		</div>
	</div>


	<!------------ fin navegacion bootstrap----------------->

<script>
	function viewNotify(NotifyId, url){
		$.ajax({
		    url : "/cfmx/commons/Componentes/Notifier.cfc?method=updateNotifyUser",
		    type: "POST",
		    data: {
		    	NotifyId: NotifyId
		    },
		    success: function(result){
		    	window.location = url;
		    },
		    error: function (request, error) {
		        alert("No se puedo mostrar la notificacion");
		    }
		});
	}
</script>


<cffunction name="Obtieneheader__rsContents">
	<cfquery name="header__rsContents" datasource="asp" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
		select
			rtrim(s.SScodigo) as SScodigo
		  , s.SSdescripcion
		  , s.SSlogo
		  , s.ts_rversion SStimestamp
		from SSistemas s
		where s.SSmenu = 1
		and (
			select count(1)
			from vUsuarioProcesos up
			where up.SScodigo = s.SScodigo
			   and up.Usucodigo = #Session.Usucodigo#
			   and up.Ecodigo = #Session.EcodigoSDC#
			) > 0
		order by s.SSorden, s.SSdescripcion
	</cfquery>
</cffunction>