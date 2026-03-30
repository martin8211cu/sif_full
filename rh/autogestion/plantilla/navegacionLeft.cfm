
<!--- se hace invocación para verificar si el usuario es empleado --->
<cfinvoke 
    component="home.Componentes.Seguridad" 
    returnvariable="datosemp"
    method="getUsuarioByCod" tabla="DatosEmpleado" 
    Usucodigo="#session.Usucodigo#" Ecodigo="#session.EcodigoSDC#"
 />
<cfset DEid = datosemp.llave>

<cfset session.monitoreo.forzar = true>

<cfset nuevosRolesA = createObject("component", "asp.Componentes.Roles").getRolesNuevoUsuario('AUTO')>
<cfset tDB = createObject("component","sif.Componentes.TranslateDB")>
<cfset nuevosRoles = nuevosRolesA[1]>
 
 
<cfset t=createObject("component","sif.Componentes.Translate")>
<cfset LB_Menu = t.Translate('LB_Menu','Menú','/home/menu/sistema.xml')>
<cfset LB_Autogestion = t.Translate('LB_Autogestion','Autogestión')>
<cfset LB_Capacitacion_y_Desarrollo = t.Translate('LB_Capacitacion_y_Desarrollo','Capacitación y desarrollo')>
<cfset LB_Noticias_Y_Avisos = t.Translate('LB_Noticias_Y_Avisos','Noticias y avisos')>
<cfset LB_Calendario = t.Translate('LB_Calendario','Calendario')>
<cfset LB_Sitios_de_Interes = t.Translate('LB_Sitios_de_Interes','Sitios de interés')>
<cfset LB_Gestion_del_Talento = t.Translate('LB_Gestion_del_Talento','Gestión de talento')>
<cfset MENU_Administracion = t.Translate('MENU_Administracion','Administración')>
<cfset MENU_ControlActivos = t.Translate('MENU_ControlActivos','Control de activos')>
<cfset MENU_ControlAsistencia = t.Translate('MENU_ControlAsistencia','Control de asistencia')>
<cfset MENU_ControlMarcas = t.Translate('MENU_ControlMarcas','Control de marcas')>
<cfset MENU_Incidencias = t.Translate('MENU_Incidencias','Incidencias')>
<cfset MENU_Tramites = t.Translate('MENU_Tramites','Trámites')>
<cfset MENU_Otros = t.Translate('MENU_Otros','Otros')>

<cfset listaMenues = obtenerMenu()>
<cfset list1 = " ,.,á,é,í,ó,ú,>,<,ñ,(,)">
<cfset list2 = "_,_,a,e,i,o,u,,n,_,_">
<cfset var_menu = "">


<cffunction name="obtenerMenu" hint="Devuelve un query con la lista de menues a mostrar, segun el panel que lo invoque">
    <cfoutput>
        <cfset nuevosRolesA = createObject("component", "asp.Componentes.Roles").getRolesNuevoUsuario('AUTO')>
        <cfset nuevosRoles = nuevosRolesA[1]>
        <cfquery name="rslistaMenu" datasource="asp">
        select  a.SPorden,
                a.SPcodigo,
                a.SPdescripcion as name,
                a.SPhomeuri as dir, 
                c.SMNtitulo,
                c.SMNcodigo,
                b.SMNcodigoPadre,
                b.SMNorden,
                b.SMNcolumna, 
                c.SMNorden as ordenMostrar
                from SProcesos a
                inner join SMenues b
                    on  rtrim(ltrim(a.SScodigo)) = rtrim(ltrim(b.SScodigo))
                    and rtrim(ltrim(a.SMcodigo)) = rtrim(ltrim(b.SMcodigo))
                    and rtrim(ltrim(a.SPcodigo)) = rtrim(ltrim(b.SPcodigo))
                    
                inner join SMenues c    
                    on  c.SMNcodigo = b.SMNcodigoPadre
                    and c.SMNtitulo in ('Administración','Incidencias','Control de Marcas','Trámites','Control Activos','Otros','Control de Asistencia','Gestión del Talento')
                where a.SScodigo = 'RH'
                 and a.SMcodigo = 'AUTO'
                 and a.SPmenu = 0
                and  b.SMNcodigoPadre is not null
                and (
                            <!---- por grupo de procesos----->
                            a.SPcodigo  in (
                                            select b.SPcodigo from SProcesosRol a
                                               inner join SProcesos b
                                                on a.SPcodigo = b.SPcodigo
                                                and b.SPmenu = 0
                                                where SRcodigo in (
                                                                    select SRcodigo
                                                                    from UsuarioRol
                                                                    where Usucodigo = #session.Usucodigo#
                                                                        and SScodigo = 'RH'
                                                                        and Ecodigo = #session.EcodigoSdc#
                                                                    )
                            )
                            
                            or
                            
                            <!---- por proceso asignado ----->
                            a.SPcodigo  in (
                                            select a.SPcodigo
                                            from SProcesos a
                                                inner join UsuarioProceso b
                                                    on a.SScodigo   = b.SScodigo
                                                    and a.SMcodigo  = b.SMcodigo
                                                    and a.SPcodigo  = b.SPcodigo
                                                    and b.Ecodigo=#session.EcodigoSdc#                  
                                                    and b.Usucodigo =#session.Usucodigo#                                
                                            where a.SScodigo = 'RH'
                                            and a.SMcodigo = 'AUTO'
                                            and a.SPanonimo=0
                                            and a.SPpublico=0
                                            and a.SPinterno=0   
                                        )
                    )               


                order by  c.SMNorden, b.SMNorden, c.SMNtitulo
        </cfquery> 

        <cfset newRow = QueryAddRow(rslistaMenu, 1)>
        <cfset temp = QuerySetCell(rslistaMenu, "SMNtitulo", "sitiosInteres", rslistaMenu.recordcount)> 
        <cfset newRow = QueryAddRow(rslistaMenu, 1)>
        <cfset temp = QuerySetCell(rslistaMenu, "SMNtitulo", "CapacitacionDesarrollo", rslistaMenu.recordcount)> 
       
    </cfoutput>
    <cfreturn rslistaMenu>
</cffunction>

    <!---- encabezado del panel---->
    <div class="panel-heading iconNav iconShowNavegation"><i class="fa fa-bars fa-2x"></i>&nbsp;&nbsp;&nbsp;<h4><cfoutput>#LB_Menu#</cfoutput></h4></div>
    <div class="panel-heading modulo">
        <a href="/cfmx/rh/autogestion/plantilla/menu.cfm"><h4><cfoutput>#LB_Autogestion#</cfoutput></h4></a>
    </div>
    <!----- fin del encabezado del panel----->

    <cfquery name="rs" dbtype="query">  
        select distinct SMNtitulo, SMNcodigo 
        from listaMenues 
        where SMNtitulo not in ('sitiosInteres','CapacitacionDesarrollo')
        order by ordenMostrar
    </cfquery>

    <cfset listElement=valueList(rs.SMNtitulo)>
    <cfset listCodeElement=valueList(rs.SMNcodigo)>
 
    <!---- se guardan los item en un array para ser procesados--->
    <cfset cortes=0>
    <cfset LvarItemSelected=false> 
    <cfset LvarMenuNoColapsar=''> 

    <cfloop list="#listElement#" index="i">   
        <div class="panel panel-default navMenu">     
            <cfquery name="rs" dbtype="query">  
                select * from listaMenues where SMNtitulo = '#i#'
            </cfquery> 

            <!----- consulta por el menu activo-----> 
            <cfif !len(LvarMenuNoColapsar)>
                <cfquery name="rsCheckMenuActivo" dbtype="query">  
                    select 1 from listaMenues where SMNtitulo = '#i#' and SPcodigo ='#trim(session.monitoreo.SPcodigo)#'
                </cfquery>  
                <cfif rsCheckMenuActivo.recordcount or trim(session.monitoreo.SPcodigo) eq 'AUTO'>
                    <cfset LvarMenuNoColapsar = i>
                </cfif>
            </cfif>

            <cfif rs.recordcount> 
                <cfif i neq 'sitiosInteres' and  i neq 'CapacitacionDesarrollo'>

                        <cfset nombreTitle=MENU_Administracion>
                        <cfif i eq 'Control de Asistencia'>
                            <cfset nombreTitle=MENU_ControlAsistencia>
                        <cfelseif i eq 'Control de Marcas'>
                            <cfset nombreTitle=MENU_ControlMarcas>
                        <cfelseif i eq 'Incidencias'>
                            <cfset nombreTitle=MENU_Incidencias>
                        <cfelseif i eq 'Trámites'>
                            <cfset nombreTitle=MENU_Tramites>
                        <cfelseif i eq 'Otros'>
                            <cfset nombreTitle=MENU_Otros>
                        <cfelseif i eq 'Control Activos'>
                            <cfset nombreTitle=MENU_ControlActivos>
                        <cfelseif i eq 'Gestión del Talento'>
                            <cfset nombreTitle=LB_Gestion_del_Talento>
                        </cfif> 

                        <cfset nombreTitle  = tdb.translate(listgetat(listCodeElement,listFindNoCase(listElement,i)),nombreTitle,105)>
                        
                        <div class="panel-heading">
                            <h4 class="panel-title"> 
                                <a data-toggle="collapse" data-parent="#accordion" href="#LeftNavigationCollapse<cfoutput>#listgetat(listCodeElement,listFindNoCase(listElement,i))#</cfoutput>"><cfoutput>#nombreTitle#</cfoutput></a>
                            </h4>
                        </div>                    

                        <div id="LeftNavigationCollapse<cfoutput>#listgetat(listCodeElement,listFindNoCase(listElement,i))#</cfoutput>" class="panel-collapse collapse<cfif LvarMenuNoColapsar eq i> in</cfif>">
                            <div class="panel-body">
                                <ul class="list-group">

                                    <cfloop query="rs"> 
                                       <cfset var_menu = trim(rs.name)>
                                       <cfset var_menu = 'MENU_' & ReplaceList(trim(var_menu),list1,list2)>
                                       <cfset evaluate(" #var_menu# = tDB.translate('RH.AUTO.#rs.SPCODIGO#','#trim(rs.name)#',103) ")>
                                       <cfoutput><a href="/cfmx#rs.dir#" style=" font-size:11px; cursor:pointer"><li class="list-group-item<cfif isDefined("session.monitoreo.SPcodigo") and ucase(trim(session.monitoreo.SPcodigo)) eq ucase(trim(rs.SPCODIGO))> selected</cfif>"><cfoutput>#Evaluate(var_menu)#</cfoutput></li></a></cfoutput>
                                    </cfloop>

                                </ul>
                            </div>
                        </div>
                             
                </cfif><!----- cierre de sitios de interes, capacitacion y demás modulos----->       
            </cfif> 
        </div>
    </cfloop>
 
    <div class="panel-heading sistema navMenu">
    </div>
    <div class="panel-heading logo navMenu">
    </div>    