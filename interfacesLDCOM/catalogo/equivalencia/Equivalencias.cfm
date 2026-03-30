<cf_templateheader title="Equivalencias">
	<cf_web_portlet_start titulo="Equivalencias">
		<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
		<cfinclude template="/sif/portlets/pNavegacion.cfm">
	
		<cfquery name="SelSistema" datasource="sifinterfaces">			
			select SIScodigo, SISnombre from SIFLD_SistemaExterno            				
			order by SIScodigo
		</cfquery>
					
		<cfquery name="SelCatalogo" datasource="sifinterfaces">			
			select CATcodigo, CATnombre from SIFLD_Catalogo
			order by CATcodigo
		</cfquery>
		
		<cfparam name="form.filtro_SIScodigo" default="#SelSistema.SIScodigo#">
		<cfparam name="form.filtro_CATcodigo" default="#SelCatalogo.CATcodigo#">
		<cfparam name="form.fSistema"         default="#SelSistema.SIScodigo#">
		<cfparam name="form.fCatalogo"        default="#SelCatalogo.CATcodigo#">
					
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
		<cfif isdefined('url.fSistema') and form.fSistema EQ "">
			<cfset form.fSistema = url.fSistema>
		</cfif>
		<cfif isdefined('url.fCatalogo') and form.fCatalogo EQ "">
			<cfset form.fCatalogo = url.fCatalogo>
		</cfif>
		<cfif isdefined('url.filtro_SISCodigo') and form.filtro_SISCodigo EQ "">
			<cfset form.filtro_SISCodigo = url.filtro_SISCodigo>
		</cfif>
		<cfif isdefined('url.filtro_CATcodigo') and form.filtro_CATcodigo EQ "">
			<cfset form.filtro_CATcodigo = url.filtro_CATcodigo>
		</cfif>
		<cfif isdefined('url.EQUid') and not isdefined('form.EQUid')>
			<cfset form.EQUid = url.EQUid>
		</cfif>			
		<cfif isdefined('url.EQUempOrigen') and not isdefined('form.EQUempOrigen')>
			<cfset form.EQUempOrigen = url.EQUempOrigen>
		</cfif>
		<cfif isdefined('url.EQUcodigoOrigen') and not isdefined('form.EQUcodigoOrigen')>
			<cfset form.EQUcodigoOrigen = url.EQUcodigoOrigen>
		</cfif>
		<cfif isdefined('url.EQUempSIF') and not isdefined('form.EQUempSIF')>
			<cfset form.EQUempSIF = url.EQUempSIF>
		</cfif>				
		<cfif isdefined('url.EQUcodigoSIF') and not isdefined('form.EQUcodigoSIF')>
			<cfset form.EQUcodigoSIF = url.EQUcodigoSIF>
		</cfif>
		
		<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
		<cfparam name="form.Pagina" default="1">
		<cfparam name="form.MaxRows" default="15">

		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<cfset ffiltro = "">
						
			<tr class="tituloListas">
				<form name="filtroTipo" action="Equivalencias.cfm" method="post" style="margin:0;">

				<td height="30" width="28%" align="right">Sistema:&nbsp;</td>
				<td align="left">
					<select name="fSistema" onchange="this.form.submit()">
						<cfoutput query="SelSistema">
							<option value="#HTMLEditFormat(selsistema.siscodigo)#" <cfif trim(form.fsistema) eq trim(selsistema.siscodigo)>selected</cfif> >#HTMLEditFormat(selsistema.sisnombre)#</option>
						</cfoutput>
					</select>
				</td>
				
				<td height="30" width="28%" align="right">Concepto:&nbsp;</td>
				<td align="left">
					<select name="fCatalogo" onchange="this.form.submit()">
						<cfoutput query="SelCatalogo">
							<option value="#HTMLEditFormat(selcatalogo.catcodigo)#" <cfif trim(form.fcatalogo) eq trim(selcatalogo.catcodigo)>selected</cfif> >#HTMLEditFormat(selcatalogo.catnombre)#</option>
						</cfoutput>
					</select>
				</td>
				
			</tr>
			<cfset navegacion = "">
			<tr valign="top"> 
				<td colspan="4" valign="top" width="50%"> 
					<cfif len(trim(form.fsistema)) NEQ 0 >
						<cfset ffiltro = ffiltro & " and SIScodigo = '" & trim(form.fsistema) & "'">
						<cfset navegacion = navegacion & "&fsistema=#trim(form.fsistema)#">
					</cfif>

					<cfif len(trim(form.fcatalogo)) NEQ 0 >
						<cfset ffiltro = ffiltro & " and CATcodigo = '" & trim(form.fcatalogo) & "'">
						<cfset navegacion = navegacion & "&fcatalogo=#trim(form.fcatalogo)#">
					</cfif>
					
					<cfset f_nuevo = false>

					<cfset campos_extra = '' >
					<cfif isdefined("form.Pagina")>
						<cfset campos_extra = ",'#form.Pagina#' as pagenum_lista" >
					</cfif>	

					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" conexion="sifinterfaces"
					 returnvariable="pListaRet">
						<cfinvokeargument name="tabla" value="SIFLD_Equivalencia e join asp..Empresa m on m.Ecodigo = e.EQUempSIF"/>
						<cfinvokeargument name="columnas" value="e.EQUid, e.SIScodigo, e.CATcodigo, e.EQUempOrigen, e.EQUcodigoOrigen, e.EQUempSIF, e.EQUcodigoSIF, m.Enombre
															#preservesinglequotes(campos_extra)#"/>
						 <cfinvokeargument name="desplegar" value="EQUempOrigen, equcodigoorigen, Enombre, equcodigosif"/>
						 <cfinvokeargument name="etiquetas" value="Empresa Origen, Codigo Origen, Empresa SIF, Codigo SIF"/>
						<cfinvokeargument name="formatos" value="S,S,S,S"/>
						<cfinvokeargument name="filtro" value="1=1 #ffiltro# order by SIScodigo, CATcodigo"/>
						<cfinvokeargument name="align" value="left, left, left, left"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" value="Equivalencias.cfm"/>
						<cfinvokeargument name="keys" value="EQUid"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="debug" value="N"/>
						<cfinvokeargument name="mostrar_filtro" value="true"/>
						<cfinvokeargument name="filtrar_automatico" value="true"/>
						<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>							
						<cfinvokeargument name="incluyeForm" value="false"/>
						<cfinvokeargument name="formName" value="filtroTipo"/>
						<cfinvokeargument name="filtro_nuevo" value="#f_nuevo#"/>
					  </cfinvoke>  
				</td></form>
				<td width="50%" valign="top" ><cfinclude template="formEquivalencias.cfm"></td>
			</tr>
			<tr><td colspan="2">&nbsp;</td></tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>