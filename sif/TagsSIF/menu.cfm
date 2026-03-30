<cfsilent>

	<cfparam name="Attributes.SScodigo"><!--- Sistema --->
	<cfparam name="Attributes.SMcodigo"><!--- Módulo --->
	<cfparam name="Attributes.Size" default="200"><!--- Ancho En Pixeles de la tabla --->
	<cfparam name="Attributes.ExcluirColumna" default=""><!--- Excluye la opcion e hijos si su columna es este numero --->
	<cfparam name="session.fnmenuCG_OP" default="#structNew()#">
	<cfparam name="session.fnmenuCG_OP.#Attributes.SScodigo#" default="#structNew()#">
	<cfparam name="session.fnmenuCG_OP.#Attributes.SScodigo#.#Attributes.SMcodigo#" default="0">
	<cf_dbfunction name="string_part" args='mn.SMNpath,1,15' returnvariable='LvarSMNpath'>
	<cf_dbfunction name="OP_concat" returnvariable="_CAT">					
	<cfif Attributes.ExcluirColumna NEQ "" and isnumeric(Attributes.ExcluirColumna)>
		<cfquery name="rsSMNpath" datasource="asp">						  
			select (rtrim(a.SMNpath) #_CAT# '%') as SMNpath
			  from SMenues a
				inner join SMenues mn
					on	a.SScodigo=mn.SScodigo 
					and a.SMcodigo=mn.SMcodigo 
					and a.SMNcolumna = #Attributes.ExcluirColumna# 
		</cfquery>							
	</cfif>
	
	<cfquery name="rsOpcionesMenu" datasource="asp">
		select  
				case coalesce(mn.opcionprin,0) when 0 then 0 else 1 end as procesoPrincipal,
				case coalesce(mn.siempreabierto,0) when 0 then 0 else 1 end as menuAbierto,
				mn.SMNtitulo as Menu, 
				case mn.SMNnivel when 1 
					then mn.SMNcodigo 
					else mn.SMNcodigoPadre 
				end as MenuID,
				' ' as Proceso, 
				' ' as ProcesoLink,
				SMNorden as ordenPath,
				#LvarSMNpath# as SMNpath,
				-1 as SPorden
			from SMenues mn
		where mn.SScodigo = '#Attributes.SScodigo#'
		  and mn.SMcodigo = '#Attributes.SMcodigo#'
		  and mn.SMNnivel = 1
		  and mn.SPcodigo is null
		  
		  <cfif Attributes.ExcluirColumna NEQ "" and isnumeric(Attributes.ExcluirColumna)>
				and (
					select count(1) 
					  from SMenues 
					  where SScodigo=mn.SScodigo 
						and SMcodigo=mn.SMcodigo 
						and SMNcolumna = #Attributes.ExcluirColumna# 
						and rtrim(mn.SMNpath) LIKE '#rsSMNpath.SMNpath#') = 0				
		  </cfif>
	union
		select
			case coalesce(mn.opcionprin,0) when 0 then 0 else 1 end as procesoPrincipal,
			case coalesce(mn.siempreabierto,0) when 0 then 0 else 1 end as menuAbierto,
			mn.SMNtitulo as Menu, 
			case mn.SMNnivel when 1 
				then mn.SMNcodigo 
				else mn.SMNcodigoPadre 
			end as MenuID,
			sp.SPdescripcion as Proceso, 
			sp.SPhomeuri as ProcesoLink,
			(
				select SMNorden from SMenues 
				 where SScodigo=mn.SScodigo and SMcodigo=mn.SMcodigo and SMNnivel > 0 and SPcodigo is null
				   and <cf_dbfunction name="Like" args="rtrim(mn.SMNpath);rtrim(SMNpath #_CAT# '%')" delimiters=";">
			) as ordenPath,
			#LvarSMNpath# as SMNpath,
			mn.SMNorden as SPorden
		from vUsuarioProcesos up
			inner join SProcesos sp
				 on sp.SScodigo = up.SScodigo
				and sp.SMcodigo = up.SMcodigo
				and sp.SPcodigo = up.SPcodigo
			inner join SMenues mn
				on  mn.SScodigo = up.SScodigo
				and mn.SMcodigo = up.SMcodigo
				and mn.SPcodigo = up.SPcodigo
				and mn.SMNnivel = 2
				and mn.SPcodigo is not null
		where up.Usucodigo = #Session.Usucodigo#
		  and up.Ecodigo = #Session.EcodigoSDC#
		  and up.SScodigo = '#Attributes.SScodigo#'
		  and up.SMcodigo = '#Attributes.SMcodigo#'
		  
		  <cfif Attributes.ExcluirColumna NEQ "" and isnumeric(Attributes.ExcluirColumna)>
				and (select count(1) 
					from SMenues 
						where SScodigo=mn.SScodigo 
						and SMcodigo=mn.SMcodigo 
						and SMNcolumna = #Attributes.ExcluirColumna# 
						and rtrim(mn.SMNpath) LIKE '#rsSMNpath.SMNpath#') = 0 
			</cfif>
		order by ordenPath, SMNpath, SPorden
	</cfquery>
	
	<cfquery name="rsModulo" datasource="asp">
		select * 
		from SModulos mn
		where mn.SScodigo = '#ucase(Attributes.SScodigo)#'
			and mn.SMcodigo = '#ucase(Attributes.SMcodigo)#'
	</cfquery>
	<cfquery name="Opciones" dbtype="query">
		select *
		 from rsOpcionesMenu
		where SPORDEN  = -1
	</cfquery>
</cfsilent>
<cfoutput>
	<cfif not isdefined('request.MenuLeft')>
		<!--- No se incluye este css para estandarizar los estilos en los menus de los modulos --->
		<!--- <link href="/cfmx/commons/css/menuleft.css" rel="stylesheet" type="text/css" /> --->
		<cfset request.MenuLeft = true>
	</cfif>
	<!--- Se agregaron los estilos de bootstrap --->
	<div class="accordion panel-group navegacionLeft" id="leftMenu" style="padding: 0px 5px;">
		<cfloop query="Opciones">
			<cfquery name="SubOpciones" dbtype="query">
				select *
				 from rsOpcionesMenu
				where SPorden <> -1
				  and MenuId = #Opciones.MenuId#
			</cfquery>
			<div class="accordion-group panel panel-default navMenu">
				<div class="panel-heading">
					<h5 class="panel-title">
						<a class="accordion-toggle" data-toggle="collapse" data-parent="##leftMenu" href="##collapse#Opciones.MenuID#">
							<div class="accordion-heading">
							<i class="icon-th"></i> #Opciones.MENU#
							</div>
						</a>
					</h5>
				</div>				
				<div id="collapse#Opciones.MenuID#" class="accordion-body panel-collapse collapse" style="height: 0px; ">
					<div class="accordion-inner panel-body">
						<ul class="SubMenuLeft list-group">
							<cfloop query="SubOpciones">
								<li class="Menu-SubOpciones list-group-item" onclick="location.href='/cfmx#SubOpciones.ProcesoLink#'">#SubOpciones.Proceso#</li>
							</cfloop>
						</ul>
					</div>
				</div>
			</div>
		</cfloop>
	</div>
</cfoutput>