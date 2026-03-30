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
<cfif isdefined("url.ESVid") and not isdefined("form.ESVid")>
	<cfset form.ESVid = url.ESVid >
</cfif>			
<cfif isdefined("url.btnNuevo") and not isdefined("form.btnNuevo")>
	<cfset form.btnNuevo = url.btnNuevo >
</cfif>				
<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="15">	
		
<cf_templateheader title="	Inventarios">				
	<cfinclude template="../../portlets/pNavegacionIV.cfm">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Vendedores'>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr> 
				<td>
					<cfif isdefined('form.ESVid') and form.ESVid NEQ '' or isdefined('form.btnNuevo')>
						<cfinclude template="formVendedores.cfm">
					<cfelse>
						<cf_dbfunction name="concat" args="ESVnombre,' ',ESVapellido1,' ',ESVapellido2" returnvariable="LvarESVnombre">
						<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
							<cfinvokeargument name="tabla" 				value="ESVendedores"/>
							<cfinvokeargument name="columnas" 			value="ESVid           
										 , ESVidentificacion
										 , ESVcodigo    
										 ,#LvarESVnombre# as nombreVend"/>
							<cfinvokeargument name="desplegar" 			value="ESVcodigo,ESVidentificacion,nombreVend"/>
							<cfinvokeargument name="etiquetas" 			value="C&oacute;digo,Identificaci&oacute;n,Nombre"/>
							<cfinvokeargument name="formatos" 			value="S,S,S"/>
							<cfinvokeargument name="filtro" 			value="Ecodigo = #Session.Ecodigo#"/>
							<cfinvokeargument name="align" 				value="left,left,left"/>
							<cfinvokeargument name="ajustar" 			value="N,N,N"/>
							<cfinvokeargument name="checkboxes" 		value="N"/>
							<cfinvokeargument name="irA" 				value="vendedores.cfm"/>
							<cfinvokeargument name="keys" 				value="ESVid"/>
							<cfinvokeargument name="maxRows" 			value="#form.MaxRows#"/>	
							<cfinvokeargument name="filtrar_automatico" value="true"/>
							<cfinvokeargument name="mostrar_filtro" 	value="true"/>									
							<cfinvokeargument name="botones" 			value="Nuevo"/>																				
							<cfinvokeargument name="filtrar_por" 		value="ESVcodigo,ESVidentificacion,#LvarESVnombre#"/>																		
							<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
						</cfinvoke>										
					</cfif>
				</td>
			</tr>						
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>