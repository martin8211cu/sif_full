<cf_template template="#session.sitio.template#">
	<!---<script  language="JavaScript" src="/cfmx/rh/js/DHTMLMenu/stm31.js"></script>--->

	<cf_templatearea name="title">
		<cf_translate key="LB_ListaDeConcursosAbiertos">Lista de Concursos Abiertos</cf_translate>
	</cf_templatearea>
	
	<cf_templatearea name="body">

<cf_templatecss>
<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>

<script language="JavaScript" type="text/JavaScript">
<!--
function MM_reloadPage(init) {  //reloads the window if Nav4 resized
  if (init==true) with (navigator) {if ((appName=="Netscape")&&(parseInt(appVersion)==4)) {
    document.MM_pgW=innerWidth; document.MM_pgH=innerHeight; onresize=MM_reloadPage; }}
  else if (innerWidth!=document.MM_pgW || innerHeight!=document.MM_pgH) location.reload();
}
 
MM_reloadPage(true);
//-->
</script>

	<cfinclude template="/rh/Utiles/params.cfm">
	<cfset Session.Params.ModoDespliegue = 1>
	<cfset Session.cache_empresarial = 0>
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ConcursosAbiertos"
		Default="Concursos Abiertos"
		returnvariable="LB_ConcursosAbiertos"/>
   <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_SeleccioneUnaEmpresa"
	Default="Seleccione una empresa."
	returnvariable="MSG_SeleccioneUnaEmpresa"/> 

	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
			<td valign="top">
				<cfset filtro = "">
				<cfset navegacion = "&btnFiltrar=Filtrar" >
				<script language="JavaScript1.2" type="text/javascript">
					function filtrar( form ){
						form.action = '';
						form.submit();
					}
					
					function limpiar(){
						document.filtro.fRHCconcurso.value = '';
						document.filtro.fRHCcodigo.value   = '';
						document.filtro.fRHPcodigo.value   = '';
					}
					function Regresa() {
						location.href = '/cfmx/rh/autogestion/plantilla/menu.cfm';
					}
				</script>
							  
				<!--- Guardan los valores que se filtraron con el fin de mostrarlos en los filtros --->
				<cfif isdefined("url.btnFiltrar") and not isdefined("form.btnFiltrar") >
					<cfset form.btnFiltrar = url.btnFiltrar >
				</cfif>
				<cfif isdefined("url.fRHCconcurso") and not isdefined("form.fRHCconcurso") >
					<cfset form.fRHCconcurso = url.fRHCconcurso >
				</cfif>
				<cfif isdefined("url.fRHCcodigo") and not isdefined("form.fRHCcodigo") >
					<cfset form.fRHCcodigo = url.fEfecfRHCcodigoha >
				</cfif>
                <cfif isdefined("url.fRHEmpresa") and not isdefined("form.fRHEmpresa") >
					<cfset form.fRHEmpresa = url.fRHEmpresa >
				</cfif>
					
			</td>	
		</tr>
		<tr> 
			<cfset regresar = "/cfmx/rh/indexAdm.cfm">
			<cfset navBarItems = ArrayNew(1)>
			<cfset navBarLinks = ArrayNew(1)>
			<cfset navBarStatusText = ArrayNew(1)>			 
			<cfset navBarItems[1] = "Concursos Abiertos">
			<cfset navBarLinks[1] = "/cfmx/plantillas/autogestion/index.cfm">
			<cfset navBarStatusText[1] = "/cfmx/plantillas/autogestion/index.cfm">
			<td colspan="5" ><cfinclude template="/rh/portlets/pNavegacion.cfm"></td>
		</tr>
	</table>	
	<!--- Variables de Traduccion --->	
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_ListaDeConcursosAbiertos"
		Default="Lista de Concursos Abiertos"
		returnvariable="LB_ListaDeConcursosAbiertos"/>

	<cf_web_portlet_start border="true" titulo="#LB_ListaDeConcursosAbiertos#" skin="#Session.Preferences.Skin#">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="5">
					<form style="margin: 0; " name="filtro" method="post" action="listaconcursoabiertos.cfm">
						<table width="100%" cellpadding="2" cellspacing="0" class="areaFiltro">
							<tr>
								<td valign="middle"><strong><cf_translate key="LB_NoSolicitud">N&ordm;. Solicitud</cf_translate>:&nbsp;</strong> 
									<input name="fRHCconcurso" type="text" size="6" maxlength="5" 
									align="middle" onFocus="this.select();" 
									onKeyUp="javascript: if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}};"
									value="<cfif isdefined("form.fRHCconcurso")><cfoutput>#form.fRHCconcurso#</cfoutput></cfif>">
								</td>
								<td valign="middle" align="left"><strong>&nbsp;<cf_translate key="LB_CodigoDeConcurso">Código de Concurso</cf_translate>: &nbsp;&nbsp;</strong>
									<input name="fRHCcodigo" type="text" size="6" maxlength="5" align="middle" onFocus="this.select();" 
									value="<cfif isdefined("form.fRHCcodigo")><cfoutput>#form.fRHCcodigo#</cfoutput></cfif>">
								</td>
								<td align="left" valign="middle" colspan="2"><strong><cf_translate key="LB_CodigoDePuesto">Código de puesto</cf_translate>: &nbsp;&nbsp;</strong>
									<input name="fRHPcodigo" type="text" size="10" maxlength="10" onFocus="this.select();" 
									value="<cfif isdefined("form.fRHPcodigo")><cfoutput>#form.fRHPcodigo#</cfoutput></cfif>">
								</td>
                                <td align="left" valign="middle" colspan="2"><strong><cf_translate key="LB_Empresa">Empresa</cf_translate>: &nbsp;&nbsp;</strong>			
                                	<cf_translatedata tabla="Empresas" col="a.Edescripcion" name="get" returnvariable="LvarEdescripcion"/>
                                    <cfquery name="rsEmpresasConcurso" datasource="#session.DSN#">	
                                            select #LvarEdescripcion# as Edescripcion, a.Ecodigo
                                            from Empresas a
                                              where a.cliente_empresarial = (select b.cliente_empresarial 
                                                                                    from Empresas b 
                                                                                     where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">) 
                                        </cfquery>
                                        <select name="fRHEmpresa">
                                          <option value=""><cfoutput>#MSG_SeleccioneUnaEmpresa#</cfoutput></option>                                              <cfoutput query="rsEmpresasConcurso">
                                          <option value="#Ecodigo#" <cfif isdefined('form.fRHEmpresa') and form.fRHEmpresa eq rsEmpresasConcurso.Ecodigo>selected</cfif> >#Edescripcion#</option>
                                          </cfoutput>
                                        </select>  
                				</td>
								<td colspan="4" align="center">
									<!--- Variables de Traduccion --->
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Filtrar"
										Default="Filtrar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Filtrar"/>
									<cfinvoke component="sif.Componentes.Translate"
										method="Translate"
										Key="BTN_Limpiar"
										Default="Limpiar"
										XmlFile="/rh/generales.xml"
										returnvariable="BTN_Limpiar"/>
									<cfoutput>
									<input type="submit" name="btnFiltrar" value="#BTN_Filtrar#">
									<input type="button" name="btnLimpiar" value="#BTN_Limpiar#" onClick="javascript:limpiar();">
									</cfoutput>
									<input name="RHCcodigo" type="hidden" 
									value="<cfif isdefined("form.RHCcodigo")and (form.RHCcodigo GT 0)><cfoutput>#form.RHCcodigo#</cfoutput></cfif>">
									<input name="RHCconcurso" type="hidden" 
									value="<cfif isdefined("form.RHCconcurso")and (form.RHCconcurso GT 0)><cfoutput>#form.RHCconcurso#</cfoutput></cfif>">
									<input name="pasoante" type="hidden" value="0">
								</td>
							</tr>
						</table>
					</form>
				</td>
			</tr>
			<tr>
				<td>
                <cfif not isdefined('form.fRHEmpresa') > 
                <cfquery name="rsConcursosExternos" datasource="#session.DSN#">
                    select  RHCconcurso 
                      from RHConcursos 
                      where
                          Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
                     union
                      select  RHCconcurso 
                      from RHEmpresasCorpConcurso 
                      where
                          Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
                   </cfquery>              
                <cfelseif  (isdefined('form.fRHEmpresa') and len(trim(#form.fRHEmpresa#)) gt 0 and form.fRHEmpresa neq session.Ecodigo)>
                  <cfquery name="rsConcursosExternos" datasource="#session.DSN#">
                    select  RHCconcurso 
                      from RHEmpresasCorpConcurso 
                      where
                          Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">  
                   </cfquery>   
               <cfelseif isdefined('form.fRHEmpresa')  and len(trim(#form.fRHEmpresa#)) gt 0>
                  <cfquery name="rsConcursosExternos" datasource="#session.DSN#">
                    select  RHCconcurso 
                      from RHEmpresasCorpConcurso 
                      where
                          Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">  
                   </cfquery>
               <cfelseif isdefined('form.fRHEmpresa')  and len(trim(#form.fRHEmpresa#)) eq 0>
                  <cfquery name="rsConcursosExternos" datasource="#session.DSN#">
                    select  RHCconcurso 
                      from RHConcursos 
                      where
                          Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
                     union
                      select  RHCconcurso 
                      from RHEmpresasCorpConcurso 
                      where
                          Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#"> 
                   </cfquery>
                </cfif>   
                <cfif isdefined('rsConcursosExternos') and   rsConcursosExternos.recordcount gt 0>            
				   <cfset cursos = ''>
                    <cfloop query="rsConcursosExternos"> 
                          <cfif rsConcursosExternos.currentrow eq rsConcursosExternos.recordcount>
                              <cfset cursos = cursos & RHCconcurso>
                          <cfelse>
                              <cfset cursos = cursos & RHCconcurso & ','>
                          </cfif>                  
                    </cfloop>   
                </cfif>                                                                        
				<cfset fecha=now()>
                <cf_dbfunction name="to_date00" args="a.horafin" returnvariable="horaFin00">
                
				<cfset checked = "<img src=''/cfmx/rh/imagenes/checked.gif'' border=''0''>">
				<cfset unchecked = "<img src=''/cfmx/rh/imagenes/unchecked.gif'' border=''0''>">
                	<cf_translatedata tabla="Empresas" col="e.Edescripcion" name="get" returnvariable="LvarEdescripcion"/>
					<cfquery name="rsListaConcursos" datasource="#session.DSN#">
						select a.RHCconcurso, 
							{fn concat(<cf_dbfunction name="to_char" args="a.RHCconcurso">,{fn concat(' - ',a.RHCcodigo)})} as concurso,
							   a.RHPcodigo, coalesce(b.RHPcodigoext,b.RHPcodigo) as RHPcodigoext,b.RHPdescpuesto, 1 as paso ,a.horafin,
							   case when <cf_dbfunction name="date_part"   args="hh, #fecha#"> > 12 then 
									<cf_dbfunction name="date_part"   args="hh, #fecha#"> - 12
								when <cf_dbfunction name="date_part"   args="hh, #fecha#"> = 0 then 
									12 
								else 						
									<cf_dbfunction name="date_part"   args="hh, #fecha#"> 
							end as hactual,
							 <cf_dbfunction name="date_part"   args="mi,  #fecha#"> as mactual,
							  case when <cf_dbfunction name="date_part"   args="hh, #fecha#"> < 12 then 'AM' else 'PM' end as tactual,
							   	<cf_dbfunction name="date_part"	args="HH,#fecha#"> as hora
                                
                                
                                 , a.horafin, a.RHCfcierre,
                                 #LvarEdescripcion# as Edescripcion
                                 ,case coalesce(a.RHCexterno,0) when 1 then'#checked#' else '#unchecked#' end  as Externo
                                 
						from RHConcursos a 
                          inner join RHPuestos b
						  on a.RHPcodigo = b.RHPcodigo and
							 a.Ecodigo   = b.Ecodigo
                          inner join Empresas e
                            on a.Ecodigo = e.Ecodigo                                   
						where 1= 1					
                        <cfif isdefined('form.fRHEmpresa') and len(trim(#form.fRHEmpresa#)) gt 0 and session.Ecodigo eq form.fRHEmpresa>
                           and a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
                        <cfelseif (not isdefined('form.fRHEmpresa')) or (isdefined('form.fRHEmpresa') and len(trim(#form.fRHEmpresa#)) eq 0)>                                
                           <cfif isdefined('cursos') >
                           		and  a.RHCconcurso  in (#cursos#)  
                           </cfif>
						<cfelseif  isdefined('form.fRHEmpresa') and len(trim(#form.fRHEmpresa#)) gt 0 and  session.Ecodigo neq form.fRHEmpresa>
                            <cfif isdefined('cursos') and len(trim(#cursos#)) gt 0>  
                              and  a.RHCconcurso  in (#cursos#)  
                           <cfelse>
                              and a.RHCconcurso = (select aa.RHCconcurso from  RHEmpresasCorpConcurso aa  inner join 
                              RHConcursos bb on aa.RHCconcurso = bb.RHCconcurso
                               where bb.Ecodigo= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fRHEmpresa#">
                               and aa.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">)
                           </cfif>                                                                             
                        </cfif>
						<cfif isdefined("form.fRHCconcurso") and len(trim(form.fRHCconcurso)) gt 0>
							and a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.fRHCconcurso#">
						</cfif>
						<cfif isdefined("form.fRHCcodigo") and len(trim(form.fRHCcodigo)) gt 0>
							and upper(a.RHCcodigo) like '%#Ucase(trim(form.fRHCcodigo))#%'
						</cfif>
							and  RHCestado = 50
						 <cfif isdefined("form.fRHPcodigo") and len(trim(form.fRHPcodigo)) gt 0> 
								and upper(b.RHPcodigoext) like '%#Ucase(trim(form.fRHPcodigo))#%'
						</cfif>                          
						
 							and (a.horafin > <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">)

						order by a.RHCconcurso, RHCdescripcion
					</cfquery> 
		
					<!--- Variables de Traduccion --->
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_NoSolicitudConcurso"
						Default="N&ordm;. Solicitud - Concurso"
						returnvariable="LB_NoSolicitudConcurso"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_CodigoDePuesto"
						Default="Código de Puesto"
						returnvariable="LB_CodigoDePuesto"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Descripcion"
						Default="Descripción"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_Descripcion"/>
                    <cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Empresa"
						Default="Empresa"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_Empresa"/>

                    <cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_Externo"
						Default="Externo"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_Externo"/>
                        
					 <cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsListaConcursos#"/>
							<cfinvokeargument name="desplegar" value="concurso,  RHPcodigoext, RHPdescpuesto,Edescripcion,externo"/>
							<cfinvokeargument name="etiquetas" 
								value="#LB_NoSolicitudConcurso#, #LB_CodigoDePuesto#, #LB_Descripcion#,#LB_Empresa#,#LB_Externo#"/>
							<cfinvokeargument name="formatos" value="S, S, S, S, V"/>
							<cfinvokeargument name="align" value="left, left, left, left, center"/>
							<cfinvokeargument name="ajustar" value="S"/>
							<cfinvokeargument name="debug" value="N"/>
							<cfinvokeargument name="keys" value="RHCconcurso"/> 
							<cfinvokeargument name="showEmptyListMsg" value= "1"/>
							<cfinvokeargument name="irA" value= "concursoabierto.cfm"/>
					</cfinvoke>
				</td>
			</tr>
			<tr><td colspan="4">&nbsp;</td></tr>
			<tr>
				<td align="center">
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Regresar"
						Default="Regresar"
						XmlFile="/rh/generales.xml"
						returnvariable="BTN_Regresar"/>
					<cfoutput>
					<input type="button"  name="Regresar" value="#BTN_Regresar#" onClick="javascript: Regresa();" tabindex="1">
					</cfoutput>
				</td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end> 
<cf_templatefooter>