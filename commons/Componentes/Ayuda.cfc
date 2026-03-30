
<cfcomponent output="true" >
	<cffunction name="getHelp" access="remote" returnformat="plain">
		<cfargument name="SScodigo" type="string" default="#session.monitoreo.SScodigo#">
		<cfargument name="SMcodigo" type="string" default="#session.monitoreo.SMcodigo#">
		<cfargument name="SPcodigo" type="string" default="#session.monitoreo.SPcodigo#">
		<cfargument name="parrafo"  type="numeric" default="1">
		<cfargument name="tab"  type="numeric" default="1">
		<cfargument name="altura"  type="numeric" default="400">
		<cfargument name="idAyuda"  type="numeric" default="-1">

		<cfquery name="rsIndiceAyuda" datasource="asp">
			SELECT e.AyudaCabId, e.AyudaCabTitulo, e.SScodigo, e.SMcodigo, e.SPcodigo,
					s.SSdescripcion, m.SMdescripcion, p.SPdescripcion
			  FROM AyudaCabecera e
			  inner join SSistemas s
			  	on s.SScodigo = e.SScodigo
			  inner join SModulos m
			  	on m.SMcodigo = e.SMcodigo
			  left join SProcesos p
			  	on p.SPcodigo = e.SPcodigo
			   WHERE e.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value='#trim(arguments.SScodigo)#'>
				order by e.SScodigo, e.SMcodigo
		</cfquery>

		<cfquery name="rsLinkAyuda" datasource="asp">
			SELECT e.AyudaCabId, e.AyudaCabTitulo, e.SScodigo, e.SMcodigo, e.SPcodigo,
					d.AyudaDetalleId, d.AyudaDetalleTitulo, d.AyudaDetallePos, d.AyudaDetalleText
			  FROM AyudaCabecera e
			  inner join AyudaDetalle d
			  	on e.AyudaCabId = d.AyudaCabId
			  <cfif arguments.idAyuda neq -1>
			  	where e.AyudaCabId = #arguments.idAyuda#
			  <cfelse>
				  WHERE SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value='#trim(arguments.SScodigo)#'>
				  	and SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value='#trim(arguments.SMcodigo)#'>
				  	<cfif arguments.SPcodigo neq "">
					  	and SPcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value='#trim(arguments.SPcodigo)#'>
							   </cfif>
				</cfif>
				order by d.AyudaDetallePos, d.AyudaDetalleTitulo
		</cfquery>

		<cfset idAyuda = rsLinkAyuda.AyudaCabId>

		<cfif rsLinkAyuda.recordCount gt 0>
			<cfquery name="rsRelacionado" datasource="asp">
				select t2.AyudaCabId, t2.AyudaCabTitulo, t2.SScodigo, t2.SMcodigo, t2.SPcodigo
				from AyudaOD t1
				inner join AyudaCabecera t2 on t1.AyudaCabIdR = t2.AyudaCabId
				where AyudaCabIdL =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#idAyuda#">
				UNION ALL
				select t2.AyudaCabId, t2.AyudaCabTitulo, t2.SScodigo, t2.SMcodigo, t2.SPcodigo
				from AyudaOD t1
				inner join AyudaCabecera t2 on t1.AyudaCabIdL = t2.AyudaCabId
				where AyudaCabIdR =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#idAyuda#">
			</cfquery>
		</cfif>
		<cfsavecontent variable="result">
			<cfoutput>
				<div class="col-xs-1"> <!-- required for floating -->
				  <!-- Nav tabs -->
				  <ul class="nav nav-tabs tabs-left sideways"><!-- 'tabs-right' for right tabs -->
				    <li <cfif arguments.tab eq 1>class="active"</cfif>><a href="##main" data-toggle="tab">Ayuda</a></li>
				    <li <cfif arguments.tab eq 2>class="active"</cfif>><a href="##more" data-toggle="tab">Relacionado</a></li>
				    <!--- <li <cfif arguments.tab eq 3>class="active"</cfif>><a href="##index" data-toggle="tab" >Indice</a></li> --->
				  </ul>
				</div>
				<div class="col-xs-11">
				    <!-- Tab panes -->
				    <div class="tab-content">
				      <div class="tab-pane <cfif arguments.tab eq 1>active</cfif>" id="main">
				      	<cfif rsLinkAyuda.recordCount gt 0>
					        <div class="row"><b>#rsLinkAyuda.AyudaCabTitulo#</b></div>
					        <hr>
							<div id="helpContent" style="height:#arguments.altura#px; overflow-y: scroll;">
								<div class="row">
									<div id="myCarousel" class="carousel slide" data-ride="carousel" data-interval="false">
										<!-- Indicators -->
										<cfset slideIndex = 0>
									    <ol class="carousel-indicators">
										  <cfloop query="rsLinkAyuda">
											  <li data-target="##myCarousel" data-slide-to="#slideIndex#" class="<cfif slideIndex eq 0>active</cfif>"></li>
										  	  <cfset slideIndex += 1>
										  </cfloop>
									    </ol>
										<!-- Wrapper for slides -->
										<div class="carousel-inner" role="listbox">
											<cfset isFirst = true>
											<cfloop query="rsLinkAyuda">
												<div class="item <cfif isFirst>active</cfif>">
													<div class="row">#rsLinkAyuda.AyudaDetalleTitulo#</div>
					       							<hr>
													#rsLinkAyuda.AyudaDetalleText#
													<!--- <div class="carousel-caption">
														<h3>#rsLinkAyuda.AyudaDetalleTitulo#</h3>
													</div> --->
												</div>
												<cfset isFirst = false>
											</cfloop>
										</div>
										<!-- Left and right controls -->
										<div>
										<a class="left carousel-control" href="##myCarousel" role="button" data-slide="prev">
										<span class="fa fa-arrow-left" aria-hidden="true"></span>
										<span class="sr-only">Anterior</span>
										</a>
										<a class="right carousel-control" href="##myCarousel" role="button" data-slide="next">
										<span class="fa fa-arrow-right" aria-hidden="true"></span>
										<span class="sr-only">Siguiente</span>
										</a>
										</div>
									</div>
								</div>
							</div>
							<cfelse>
								<div class="row">No se encontro contenido de ayuda</div>
							</cfif>
							<hr>
					  </div>
				      <div class="tab-pane <cfif arguments.tab eq 2>active</cfif>" id="more">
				      	<div class="row">Relacionado con #rsLinkAyuda.AyudaCabTitulo#</div>
					    <hr>
				      	<div id="helpContent" style="height:#arguments.altura#px; overflow-y: scroll;">
							<div class="row">
						    <cfif rsLinkAyuda.recordCount gt 0>
								<cfif rsRelacionado.recordCount gt 0>
									<div class="list-group">
										<cfloop query="rsRelacionado">
											<a href="##" class="list-group-item" onclick="showHelp(#rsRelacionado.AyudaCabId#)">
												#rsRelacionado.AyudaCabTitulo#
											</a>
										</cfloop>
									</div>
								<cfelse>
									<div class="row">No se encontraron temas ralacionados</div>
								</cfif>
							<cfelse>
								<div class="row">No se encontraron temas ralacionados</div>
							</cfif>
							</div>
					  	</div>
					  </div>
				      <div class="tab-pane <cfif arguments.tab eq 3>active</cfif>" id="index">
					      <div class="row">Indice General</div>
					      <hr>
					      <div id="helpContent" style="height:#arguments.altura#px; overflow-y: scroll;">
							<div class="row" align="left">
					      	<cfif rsIndiceAyuda.recordCount gt 0>
						      	<cfoutput>
							      	<ul class="list-group">
									<cfloop query="rsIndiceAyuda" group="SScodigo">
										<li class="list-group-item">#rsIndiceAyuda.SScodigo# - #rsIndiceAyuda.SSdescripcion#
											<ul class="list-group">
											<cfloop query="rsIndiceAyuda" group="SMcodigo">
												<li class="list-group-item"><a href="##">#rsIndiceAyuda.SMdescripcion#</a></li>
													<cfquery dbtype="query" name="rsProcesos">
														select AyudaCabId, AyudaCabTitulo,SPcodigo from rsIndiceAyuda
														where SScodigo = '#rsIndiceAyuda.SScodigo#'
														 and SMcodigo = '#rsIndiceAyuda.SMcodigo#'
														 and SPcodigo IS NOT NULL
													</cfquery>
													<cfif rsProcesos.recordCount gt 0>
														<ul class="list-group">
														<cfloop query="rsIndiceAyuda" group="SPcodigo">
															<li class="list-group-item"><a href="##">#rsIndiceAyuda.SPdescripcion#</a></li>
														</cfloop>
														</ul>
													</cfif>
												</li>
											</cfloop>
											</ul>
										</li>
									</cfloop>
									</ul>
								</cfoutput>
							<cfelse>
							  	<div class="row">No se encontraron temas ralacionados</div>
							</cfif>
							</div>
						  </div>
					  </div>
				    </div>
				</div>

			</cfoutput>
		</cfsavecontent>
		<cfreturn result>
	</cffunction>
</cfcomponent>