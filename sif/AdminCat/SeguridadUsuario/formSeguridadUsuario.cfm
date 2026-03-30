
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Perfil" Default= "Perfil a Asignar" XmlFile="formSeguridadUsuario.xml" returnvariable="LB_Perfil"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Usuario" Default= "Usuario" XmlFile="formSeguridadUsuario.xml" returnvariable="LB_Usuario"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_SeleccionarPerfil" Default= "---Seleccionar Perfil de Seguridad---" XmlFile="formSeguridadUsuario.xml" returnvariable="LB_SeleccionarPerfil"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_PerfilAsignado" Default= "Perfil Asignado" XmlFile="formSeguridadUsuario.xml" returnvariable="LB_PerfilAsignado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_NoRegistros" Default= "No se encontrarón registros con este criterio de búsqueda!" XmlFile="formSeguridadUsuario.xml" returnvariable="LB_NoRegistros"/>


<cf_dbfunction name="OP_concat" returnvariable="_Cat">


<cfif isdefined("url.ADSPid") and Len(Trim(url.ADSPid))>
	<cfparam name="Form.ADSPid" default="#url.ADSPid#">
</cfif>
<cfif isdefined("form.ADSPid") and Len(Trim(form.ADSPid))>
	<cfparam name="Form.ADSPid" default="#form.ADSPid#">
</cfif>
<cfif isdefined("url.Usucodigo") and Len(Trim(url.Usucodigo))>
	<cfparam name="Form.Usucodigo" default="#url.Usucodigo#">
</cfif>
<cfif isdefined("form.Usucodigo") and Len(Trim(form.Usucodigo))>
	<cfparam name="Form.Usucodigo" default="#form.Usucodigo#">
</cfif>
<cfif isdefined("url.ADSPcodigo") and Len(Trim(url.ADSPcodigo))>
	<cfparam name="Form.ADSPcodigo" default="#url.ADSPcodigo#">
</cfif>

<cfif isdefined("form.ADSPcodigo") and Len(Trim(form.ADSPcodigo))>
	<cfparam name="Form.ADSPcodigo" default="#form.ADSPcodigo#">
</cfif>

<cfif isdefined("url.ADSPdescripcion") and Len(Trim(url.ADSPdescripcion))>
	<cfparam name="Form.ADSPdescripcion" default="#url.ADSPdescripcion#">
</cfif>
<cfif isdefined("form.ADSPdescripcion") and Len(Trim(form.ADSPdescripcion))>
	<cfparam name="Form.ADSPdescripcion" default="#form.ADSPdescripcion#">
</cfif>



<cfif isdefined("url.modo") and url.modo EQ "CAMBIO">
	<cfset modo = "CAMBIO">
<cfelseif (isdefined("Form.ADSPid") and len(trim(Form.ADSPid))) or (isdefined("Form.Usucodigo") and len(trim(Form.Usucodigo)))>
	<cfset modo = "CAMBIO">
<cfelse>
	<cfset modo = "ALTA">
</cfif>


<cfquery name="rsPerfiles" datasource="#Session.DSN#">
    select * from ADSEPerfil
    where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
    order by ADSPdescripcion
</cfquery>

<cfif modo neq "ALTA" and isdefined("Form.Usucodigo")>
        <cfquery name="rsPerfil" datasource="#Session.DSN#">
            select a.*,b.ADSPdescripcion,SMdescripcion,SPdescripcion,SPhomeuri,e.Usulogin,g.CMCcodigo,h.CMScodigo,i.Usucodigo,l.DEnombre,m.CCHresponsable,
				case when g.CMCcodigo is not null and SPcodigo = 'CACMC'
						then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
   	                 when h.CMScodigo is not null and SPcodigo = 'CACOSO'
						then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
	  				 when i.Usucodigo is not null and SPcodigo = 'SEG_SP'
						then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
	  				 when j.Usucodigo is not null and SPcodigo = 'SEG_OP'
						then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
	  				 when k.Usucodigo is not null and SPcodigo = 'TES_SGE'
						then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
	  				 when SPcodigo = 'OP_SPU'
						then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
	  				 when l.DEnombre is not null and SPcodigo = 'GE_0100'<!--- or SPcodigo = 'CCH_REG' or SPcodigo = 'CCH_RES' --->
						then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
	 				 when m.CCHresponsable is not null and (SPcodigo = 'CCH_REG' or SPcodigo = 'CCH_RES')
						then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
					 when o.Aid is not null and SPcodigo = 'CAIAL'
						then '<img src=''/cfmx/sif/imagenes/checked.gif'' border=''0''>'
	  				 else '-'
                end as Configurado
                from ADSUsuarioPerfil a
                    inner join ADSEPerfil b
                        on a.ADSPid = b.ADSPid
                    inner join ADSDPerfil c
                        on b.ADSPid = c.ADSPid
                    inner join ADSPerfilProceso d
                        on c.ADSPPid = d.ADSPPid
                    inner join Usuario e
						inner join DatosPersonales f
	                    on f.datos_personales = e.datos_personales
                    on e.Usucodigo = a.Usucodigo
                    left join DatosEmpleado l
                        on f.Pnombre = l.DEnombre and f.Papellido1 = l.DEapellido1 and f.Papellido2 = l.DEapellido2
                    left join CCHica m
                        on m.Ecodigo = a.Ecodigo and m.CCHresponsable = l.DEid
                    left join CMCompradores g
                        on g.Ecodigo = a.Ecodigo and g.Usucodigo = a.Usucodigo
                    left join CMSolicitantes h
                        on h.Ecodigo = a.Ecodigo and h.Usucodigo = a.Usucodigo
                    left join TESusuarioSP i
                        on i.Ecodigo = a.Ecodigo and i.Usucodigo = a.Usucodigo
                    left join TESusuarioOP j
                        on j.Usucodigo = a.Usucodigo
                    left join TESusuarioGE k
                        on k.Ecodigo = a.Ecodigo and k.Usucodigo = a.Usucodigo
					left join CPSeguridadUsuario n
						on n.Ecodigo = a.Ecodigo and n.Usucodigo = a.Usucodigo
					left join AResponsables o
						on o.Ecodigo = a.Ecodigo and o.Usucodigo = a.Usucodigo
                where a.Ecodigo=#session.Ecodigo#
          <cfif isdefined("Form.ADSPid") and Form.ADSPid NEQ "">
            and a.ADSPid = #Form.ADSPid#
          </cfif>
          <cfif isdefined("Form.Usucodigo") and Form.Usucodigo NEQ "">
            and a.Usucodigo = #Form.Usucodigo#
          </cfif>
          	and e.Uestado = 1
			and e.Utemporal = 0
          	group by ADSUsuId,a.ADSPid,a.Ecodigo,a.Usucodigo,b.ADSPdescripcion,SMdescripcion,SPdescripcion,SPhomeuri,
			e.Usulogin, g.CMCcodigo,h.CMScodigo,i.Usucodigo,SPcodigo,j.Usucodigo,k.Usucodigo,l.DEnombre,m.CCHresponsable,
			o.Aid
			order by SMdescripcion, SPdescripcion
        </cfquery>

        <cfif rsPerfil.recordcount GT 0>

            <cfquery name="rsUsuario" datasource="#Session.DSN#">
                select b.*,a.Usulogin from Usuario a
                    inner join DatosPersonales b
                        on a.datos_personales = b.datos_personales
                where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPerfil.Usucodigo#">
            </cfquery>
		<cfelse>

        	<cf_errorCode	code = "80014" msg = "#LB_NoRegistros#">

        </cfif>

    <cfelseif modo neq "ALTA" and isdefined("Form.ADSPid")>
        <cfquery name="rsPerfil" datasource="#Session.DSN#">
            select a.*,b.ADSPdescripcion, Usulogin,Pnombre #_cat#' '#_cat# Papellido1#_cat#' '#_cat# Papellido2 as Nombre
            from ADSUsuarioPerfil a
                inner join ADSEPerfil b
                    on a.ADSPid = b.ADSPid
                inner join Usuario e
                    on e.Usucodigo = a.Usucodigo
                inner join DatosPersonales f
                    on f.datos_personales = e.datos_personales
            where a.Ecodigo=#session.Ecodigo#
            and a.ADSPid = #Form.ADSPid#
            order by Usucodigo
        </cfquery>

    </cfif>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
			<form action="SQLSeguridadUsu.cfm" method="post" name="form1">
				<table valign="top" align="center" cellpadding="2" cellspacing="0" border="0" width="100%" style="padding-left: 10px;">

            		<td align="right"><strong><cfoutput>#LB_Usuario#:</cfoutput></strong></td>
            		<td align="left">
                        <cf_dbfunction name="concat" args="dp.Pnombre, ' ',dp.Papellido1,' ',dp.Papellido2" returnvariable="Lvarnombre">
                        <cf_conlis
                        campos="Usucodigo,Usulogin,nombre"
                        desplegables="N,S,S"
                        modificables="N,S,N"
                        size="0,10,40"
                        title="Lista de Usuarios"
                        tabla="Usuario u
                        inner join DatosPersonales dp
                        on dp.datos_personales=u.datos_personales"
                        columnas="u.Usucodigo,u.Usulogin as Usulogin,
                        #Lvarnombre# as nombre"
                        filtro="u.Utemporal = 0
                        and u.Uestado=1
                        and u.CEcodigo=#session.CEcodigo#
                        order by u.Usulogin"
                        desplegar="Usulogin,nombre"
                        filtrar_por="u.Usulogin| dp.Papellido1 #_Cat# ' ' #_Cat# dp.Papellido2 #_Cat# ' ' #_Cat# dp.Pnombre"
                        filtrar_por_delimiters="|"
                        etiquetas="Login,Usuario"
                        formatos="S,S"
                        align="left,left"
                        asignar="Usucodigo,Usulogin,nombre"
                        asignarformatos="S, S, S"
                        showEmptyListMsg="true"
                        EmptyListMsg="-- No se encontraron usuarios--"
                        tabindex="1"
                        conexion="asp">
				</td>
			</td>
		</tr>

    	<tr>
            <td align="right"><strong><cfoutput>#LB_Perfil#:</cfoutput></strong></td>
            <td align="left">
                <table>
                    <select name="ADSPid">
                        <option value=""><cfoutput>#LB_SeleccionarPerfil#</cfoutput></option>
                    <cfoutput query="rsPerfiles">
                   		<!---<cfif modo EQ "ALTA">--->
                          	<option value="#rsPerfiles.ADSPid#">#rsPerfiles.ADSPdescripcion#</option>
                       <!--- <cfelse>
                        	<option value="#rsPerfiles.ADSPid#" <cfif rsPerfiles.ADSPid EQ rsPerfil.ADSPid>selected></cfif>
                            #rsPerfiles.ADSPdescripcion#</option>
                          </cfif>--->
                    </cfoutput>
                    </select>

                </table>

                <tr>
                    <td colspan="5" align="center" nowrap>
                        <cf_botones exclude= "Limpiar,Alta" include= "Guardar,Filtrar,Finalizar">
                    </td>
                </tr>
             </td>
		</tr>
		</form>
        <cfif modo neq "ALTA" and isdefined("Form.Usucodigo")>

            <td align="left"><strong><cfoutput>#LB_Usuario#:</cfoutput></strong><cfoutput>#rsUsuario.Usulogin#</cfoutput></td>
            <td align="left"><strong><cfoutput>#LB_PerfilAsignado#:</cfoutput> </strong><cfoutput>#rsPerfil.ADSPdescripcion#</cfoutput></td>
            <cfif isdefined("session.ConfUsu")>
    			<cfset StructDelete(session, "ConfUsu")>
        	</cfif>
                       <cfinvoke component="sif.Componentes.pListas" method="pListaQuery">
                           <cfinvokeargument name="query" value="#rsPerfil#"/>
                           <cfinvokeargument name="desplegar" value="SMdescripcion, SPdescripcion,Configurado"/>
                           <cfinvokeargument name="etiquetas" value="Módulo, Opción, Configurado "/>
                           <cfinvokeargument name="formatos" value="S,S,S"/>
                           <cfinvokeargument name="align" value="left,left,center"/>
                           <cfinvokeargument name="ajustar" value="S,S,S"/>
                           <cfinvokeargument name="irA" value="Accesos.cfm"/>
                           <cfinvokeargument name="showEmptyListMsg" value="true"/>
                           <cfinvokeargument name="PageIndex" value="1"/>
                           <cfinvokeargument name="keys" value="ADSPid,SPhomeuri,Usucodigo"/>
      				</cfinvoke>
     			<cfset ConfUsu = StructNew()>
                <cfset ConfUsu.Ecodigo = #session.Ecodigo#>
                <cfset ConfUsu.IdUsu = #rsPerfil.Usucodigo#>
                <cfset ConfUsu.IdPerfil = #rsPerfil.ADSPid#>
                <cfset ConfUsu.IdProceso = #session.menues.SPcodigo#>
                <cfset session.ConfUsu = ConfUsu>
                <cfset ConfUsu.Usulogin = #rsUsuario.Usulogin#>

		<cfelseif modo neq "ALTA" and isdefined("Form.ADSPid")>

               <cfinvoke component="sif.Componentes.pListas"	method="pListaQuery">
                <cfinvokeargument name="query" value="#rsPerfil#"/>
                <cfinvokeargument name="desplegar" value="Usulogin, Nombre,ADSPdescripcion"/>
                <cfinvokeargument name="etiquetas" value="Login, Nombre, Perfil Asignado"/>
                <cfinvokeargument name="formatos" value="S,S,S"/>
                <cfinvokeargument name="align" value="left,left,left"/>
                <cfinvokeargument name="ajustar" value="S,S,S"/>
                <cfinvokeargument name="irA" value="SeguridadUsuario.cfm"/>
                <cfinvokeargument name="showEmptyListMsg" value="true"/>
                <cfinvokeargument name="PageIndex" value="1"/>
                <cfinvokeargument name="keys" value="ADSPid,Usucodigo"/>
              </cfinvoke>
	   </cfif>

 </table>
