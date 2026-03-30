<!--- <cfdump var="#form#">
<cfdump var="#url#">
 --->

<cfparam name="form.SNCcodigoLista" default=" ">
<cfif isdefined("url.modoC") and len(trim(url.modoC)) and not isdefined("form.modoC")>
	<cfparam name="form.modoC" default="#Url.modoC#"> 
	<cfset form.modoC = url.modoC>
</cfif>

<cfif isdefined("url.id_direccion") and len(trim(url.id_direccion)) and not isdefined("form.id_direccion")>
	<cfset form.id_direccion = url.id_direccion>
</cfif>

<cfif isdefined('url.SNCcodigo') and LEN(TRIM(url.SNCcodigo)) and not isdefined('form.SNCcodigo')>
	<cfset form.SNCcodigo = url.SNCcodigo>
</cfif>
<cfif isdefined("url.SNCcodigoLista") and not isdefined("form.SNCcodigoLista")>
	<cfset form.SNCcodigoLista = url.SNCcodigoLista>
</cfif>

<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	
	<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->		
	<cfif isdefined("url.Pagina3") and len(trim(url.Pagina3))>
		<cfset form.Pagina3 = url.Pagina3>
	</cfif>		
	<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
	<cfif isdefined("url.PageNum_Lista3") and len(trim(url.PageNum_Lista3))>
		<cfset form.Pagina3 = url.PageNum_Lista3>
	</cfif>	
	<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
	<cfif isdefined("form.PageNum3") and len(trim(form.PageNum3))>
		<cfset form.Pagina3 = form.PageNum3>
	</cfif>

	<table width="95%" border="0" cellspacing="0" cellpadding="0">
	  <tr> 
		<td colspan="2" valign="top">
			<cfinclude template="../../portlets/pNavegacionAD.cfm">
		</td>
	  </tr>
	
	  <tr> 
		<td valign="top" width="50%"> 
		<cfset navegacion = 'SNcodigo=#form.SNcodigo#&tab=8&tabs=4&id_direccion=#form.id_direccion#'>
		<cfif isdefined('form.Pagina3')>
			<cfset navegacion = navegacion &'&Pagina3=#form.Pagina3#'>
		</cfif>
		<cfif isdefined('form.SNCcodigoLista')><cfset navegacion = navegacion & '&SNCcodigoLista=' & form.SNCcodigoLista></cfif>
		<cfinvoke component="sif.Componentes.pListas" method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" 				value="SNDContactos"/>
			<cfinvokeargument name="columnas" 			value="SNcodigo, SNCcodigo as SNCcodigoLista, SNCnombre, SNCtelefono"/>
			<cfinvokeargument name="desplegar" 			value="SNCnombre, SNCtelefono"/>
			<cfinvokeargument name="etiquetas" 			value="Nombre del Contacto, Teléfono" />
			<cfinvokeargument name="formatos" 			value=""/>
			<cfinvokeargument name="filtro" 			value="Ecodigo=#session.Ecodigo# 
															and SNcodigo=#Form.SNcodigo# 
															order by SNCnombre"/>
			<cfinvokeargument name="align" 				value="left, left"/>
			<cfinvokeargument name="ajustar" 			value="N"/>
			<cfinvokeargument name="checkboxes" 		value="N"/>
			<cfinvokeargument name="formname" 			value="listaContactosxDireccion"/>
			<cfinvokeargument name="irA" 				value="SociosDirecciones_form.cfm?tab=8&tabs=4&modoC=CAMBIO&id_direccion=#form.id_direccion#&SNCcodigoLista=#form.SNCcodigoLista#"/> 
			<cfinvokeargument name="PageIndex"			value="3"/>
			<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
			<cfinvokeargument name="maxrows" 			value="10"/>
			<cfinvokeargument name="navegacion"			value="#navegacion#"/>
			<cfinvokeargument name="keys" 				value="SNCcodigoLista,SNcodigo"/>
		  </cfinvoke> </td>
		<td><cfinclude template="FormContactosxDireccion.cfm"> &nbsp;</td>
	  </tr>
	  <tr> 
		<td>&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	</table>
<cfelse>
	<table align="center">
		<tr>
			<td>Primero&nbsp;debe&nbsp;ingresar&nbsp;los&nbsp;<strong>Datos&nbsp;Generales</strong>&nbsp;del&nbsp;Socio&nbsp;de&nbsp;Negocios</td>
		</tr>
	</table>
</cfif>