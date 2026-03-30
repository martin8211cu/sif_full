
<cf_templateheader title="Parametros Módulo Integración">
	<cf_web_portlet_start titulo="Parametros Módulo Integración">
		<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
	    
        <cfquery name="SelSistema" datasource="sifinterfaces">			
			select SIScodigo, SISnombre from SIFLD_SistemaExterno            				
			order by SIScodigo
		</cfquery>
        
        <cfparam name="form.filtro_SIScodigo" default="#SelSistema.SIScodigo#">
		<cfparam name="form.fSistema"         default="#SelSistema.SIScodigo#">
            
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->
		<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
			<cfset form.Pagina = url.Pagina>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
		<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
			<cfset form.Pagina = url.PageNum_Lista>
		</cfif>
		<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
		<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
			<cfset form.Pagina = form.PageNum>
		</cfif>
        <cfif isdefined('url.modo')>
			<cfset form.modo = url.modo>
		</cfif>
		<cfif isdefined('url.fSistema')>
			<cfset form.fSistema = url.fSistema>
		</cfif>
        <cfif isdefined('url.filtro_SISCodigo') and form.filtro_SISCodigo EQ "">
			<cfset form.filtro_SISCodigo = url.filtro_SISCodigo>
		</cfif>
        <cfif isdefined('url.SIScodigo') and not isdefined('form.SIScodigo')>
			<cfset form.SIScodigo = url.SIScodigo>
		</cfif>
		<cfif isdefined('url.Pcodigo') and not isdefined('form.Pcodigo')>
			<cfset form.Pcodigo = url.Pcodigo>
		</cfif>			
		<cfif isdefined('url.Sucursal') and not isdefined('form.Sucursal')>
			<cfset form.Sucrusal = url.Sucursal>
		</cfif>
		<cfif isdefined('url.Criterio') and not isdefined('form.Criterio')>
			<cfset form.Criterio = url.Criterio>
		</cfif>
				
		<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
		<cfparam name="form.Pagina" default="1">
		<cfparam name="form.MaxRows" default="15">

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<cfset ffiltro = " and Ecodigo = #session.Ecodigo#">
			<form name="filtroTipo" action="Parametros.cfm" method="post" style="margin:0;">			

            <tr class="tituloListas">
				<td height="30" width="10%" align="left">Sistema:&nbsp;</td>
				<td width="90%" align="left">
					<select name="fSistema" onchange="this.form.submit()">
						<cfoutput query="SelSistema">
							<option value="#HTMLEditFormat(selsistema.SIScodigo)#" <cfif trim(form.fSistema) eq trim(selsistema.SIScodigo)>selected</cfif> >#HTMLEditFormat(selsistema.sisnombre)#</option>
						</cfoutput>
                        <option value="0" <cfif trim(form.fSistema) EQ "0">selected</cfif>>-No definido-</option>
					</select>
				</td>
			</tr>
                        
			<cfset navegacion = "">
			<tr valign="top"> 
				<td colspan="2" valign="top" width="50%"> 
                	
                    <cfif len(trim(form.fSistema)) NEQ 0 >
						<cfset ffiltro = ffiltro & " and SIScodigo = '" & trim(form.fSistema) & "'">
						<cfset navegacion = navegacion & "&fSistema=#trim(form.fSistema)#">
					</cfif>
                    <!---
					<cfif isdefined("form.Pcodigo") and len(trim(form.Pcodigo)) NEQ 0 >
						<cfset navegacion = navegacion & "&Pcodigo=#trim(form.Pcodigo)#">
					</cfif>

					<cfif isdefined("form.Sucursal") and len(trim(form.Sucursal)) NEQ 0 >
						<cfset navegacion = navegacion & "&Sucursal=#trim(form.Sucursal)#">
					</cfif>
					
                    <cfif isdefined("form.Criterio") and len(trim(form.Criterio)) NEQ 0 >
						<cfset navegacion = navegacion & "&Criterio=#trim(form.Criterio)#">
					</cfif>
                    
                    <cfif isdefined("form.Pvalor") and len(trim(form.Pvalor)) NEQ 0 >
						<cfset navegacion = navegacion & "&Pvalor=#trim(form.Pvalor)#">
					</cfif>
                    --->
					<cfset f_nuevo = false>
					<cfset campos_extra = '' >
                    <cfif isdefined("form.Pagina")>
						<cfset campos_extra = ",'#form.Pagina#' as pagenum_lista" >
					</cfif>	
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" conexion="sifinterfaces"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="SIFLD_Parametros"/>
						<cfinvokeargument name="columnas" value="Ecodigo, SIScodigo, Sucursal, Criterio, Pcodigo, Pvalor, Pdescripcion #preservesinglequotes(campos_extra)#"/>
						 <cfinvokeargument name="desplegar" value="Pcodigo, Sucursal, Criterio, Pvalor, Pdescripcion"/>
						 <cfinvokeargument name="etiquetas" value="Parametro, Sucursal, Criterio, Valor, Descripcion"/>
						<cfinvokeargument name="formatos" value="S,S,S,S,S"/>
						<cfinvokeargument name="filtro" value="1=1 #ffiltro# order by Pcodigo, Sucursal, Criterio"/>
						<cfinvokeargument name="align" value="left, left, left, left, left"/>
						<cfinvokeargument name="ajustar" value="S"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="Parametros.cfm"/>
						<cfinvokeargument name="keys" value="Sucursal,Criterio,Pcodigo"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="debug" value="N"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>							
						<cfinvokeargument name="incluyeForm" value="false"/>
						<cfinvokeargument name="formName" value="filtroTipo"/>
						<cfinvokeargument name="filtro_nuevo" value="#f_nuevo#"/>
					  </cfinvoke>  
				</td>
            </form>
				<td width="50%" valign="top" ><cfinclude template="formParametros.cfm"></td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>