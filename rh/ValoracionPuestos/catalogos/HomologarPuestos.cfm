
<cfsilent>
 <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Homologacion_de_Puestos"
	Default="Homologaci&oacute;n de puestos"
	returnvariable="LB_Homologacion_de_Puestos"/>
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
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Codigo"
	Default="C&oacute;digo"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Codigo"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Descripcion"
	Default="Descripci&oacute;n"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_Descripcion"/>
</cfsilent>

<cfquery name="rsTitulo" datasource="#session.DSN#">
    select 
    {fn concat(upper(rtrim(RHPcodigo)),{fn concat(' ',RHPdescpuesto)})} as titulo
    from RHPuestos 
    where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      and RHPcodigo=<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">
</cfquery>

<cf_templateheader title="#LB_Homologacion_de_Puestos#&nbsp;&nbsp;( #rsTitulo.titulo# )">
	<cfinclude template="/rh/Utiles/params.cfm">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr>
		    <td valign="top">

				
			<cf_web_portlet_start titulo="#LB_Homologacion_de_Puestos#&nbsp;&nbsp;( #rsTitulo.titulo# )">
				<cfif isdefined("url.RHPcodigoH") and not isdefined("form.RHPcodigoH")>
					<cfset form.RHPcodigoH = url.RHPcodigoH >
				</cfif>
				<cfif isdefined("url.modo") and not isdefined("form.modo")>
					<cfset form.modo = url.modo >
				</cfif>
				
				<cfinclude template="/rh/portlets/pNavegacion.cfm">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr>
						<td valign="top" width="50%">
							<form style="margin:0" name="filtro" method="post">
								<table border="0" width="100%" class="titulolistas">
								  <tr > 
									<td><cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></td>
									<td colspan="3"><cf_translate key="LB_Decripcion" XmlFile="/rh/generales.xml">Descripci&oacute;n</cf_translate></td>
								  </tr>
								  <tr nowrap="nowrap"> 
									<td><input type="text" name="fRHPcodigoH" tabindex="1" value="<cfif isdefined("form.fRHPcodigoH") and len(trim(form.fRHPcodigoH)) gt 0 ><cfoutput>#form.fRHPcodigoH#</cfoutput></cfif>" size="5" maxlength="5" onFocus="javascript:this.select();"></td>
									<td><input type="text" name="fRHPdescpuestoH" tabindex="1" value="<cfif isdefined("form.fRHPdescpuestoH") and len(trim(form.fRHPdescpuestoH)) gt 0 ><cfoutput>#form.fRHPdescpuestoH#</cfoutput></cfif>" size="45" maxlength="45" onFocus="javascript:this.select();" ></td>
									<td  align="right">
										<input type="submit" name="Filtrar" tabindex="1" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
										<input type="button" name="Limpiar" tabindex="1" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onClick="javascript:limpiar();">
									</td>
								  </tr>
								</table>
							  </form>
                            <cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_Eliminar_Registro"
							Default="Eliminar Registro"
							returnvariable="LB_Eliminar_Registro"/>	 
                            
                            
                            <cfquery name="rsLista" datasource="#session.DSN#">					
							select 	
                            a.RHPcodigo,
                            a.RHPcodigoH, 
                            case when len(b.RHPdescpuesto) > 60 
                            then {fn concat(substring(b.RHPdescpuesto,1,57),'...')}
	                        else b.RHPdescpuesto end as RHPdescpuestoH,
                            {fn concat('<a href=javascript:Eliminar(''', {fn concat(ltrim(rtrim(a.RHPcodigoH)),''');><img src=/cfmx/rh/imagenes/delete.small.png border=0></a>')})} as Eliminar 
        					from RHPuestosH a , RHPuestos b

							where  a.RHPcodigoH= b.RHPcodigo 
                            and a.Ecodigo= b.Ecodigo 
                            and a.Ecodigo = #Session.Ecodigo# 
                            and a.RHPcodigo = '#form.RHPcodigo#'	              
							<cfif isdefined("form.fRHPcodigoH") and len(trim(form.fRHPcodigoH)) gt 0 >
                                and a.RHPcodigoH like '%#ucase(form.fRHPcodigoH)#%'
                            </cfif>
                            <cfif isdefined("form.fRHPdescpuestoH") and len(trim(form.fRHPdescpuestoH)) gt 0 >
                                and upper(b.RHPdescpuesto) like '%#ucase(form.fRHPdescpuestoH)#%' 
                            </cfif>
                            order by a.RHPcodigoH
                            
						</cfquery>
						<cfinvoke 
						component="rh.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="RHPcodigoH,RHPdescpuestoH,Eliminar"/>
							<cfinvokeargument name="etiquetas" value="#LB_Codigo#, #LB_Descripcion#,&nbsp;"/>
							<cfinvokeargument name="formatos" value="V,V,V"/>
							<cfinvokeargument name="align" value="left,left,left"/>
							<cfinvokeargument name="ajustar" value="S,S,S"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="showLink" value="false"/>
						</cfinvoke>

						</td>
						 <td width="50%" valign="top"><cfinclude template="formHomologarPuestos.cfm"></td><!--- --->
					</tr>
				</table>
		        <cf_web_portlet_end>
	                <script type="text/javascript" language="javascript1.2">
				function limpiar(){
					document.filtro.fRHPcodigoH.value = '';
					document.filtro.fRHPdescpuestoH.value = '';
				}
	                </script>
		    </td>	
		</tr>
	</table>	
<cf_templatefooter>