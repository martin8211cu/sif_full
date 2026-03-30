<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 10-3-2006.
		Motivo: Se corrige el orden de los alias en el ON de los INNER JOIN.
 --->
<cfif isdefined('url.Ecodigodest') and not isdefined('form.Ecodigodest')>
	<cfset form.Ecodigodest = url.Ecodigodest>
</cfif>
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
<cfquery name="rsLista" datasource="#Session.DSN#">								
	select b.Edescripcion,c.CFdescripcion as cxp,d.CFdescripcion as cxc, a.Ecodigodest, e.Edescripcion as Edestino
	from CIntercompany a
		inner join Empresas b	
			on b.Ecodigo = a.Ecodigo
		
		inner join CFinanciera c
			on c.Ecodigo = a.Ecodigo
			and c.CFcuenta =a.CFcuentacxp
	
		inner join CFinanciera d
			on d.Ecodigo = a.Ecodigo
			and d.CFcuenta = a.CFcuentacxc
		
		inner join Empresas e
			on e.Ecodigo = a.Ecodigodest
	
	where a.Ecodigo = #session.Ecodigo#
	order by Edestino
</cfquery>
<!--- VALORES POR DEFECTO DE LAS VARIBLES REQUERIDAS PORQUE SIEMPRE SE USAN EN EL FORM PARA ENVIARLAS AL SQL --->
<cfparam name="form.Pagina" default="1">
<cfparam name="form.MaxRows" default="15">

<cf_templateheader title="Contabilidad General">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Cuentas Intercompañía">
		<cfinclude template="../../portlets/pNavegacionCG.cfm">
			<table width="100%" border="0" cellpadding="0" cellspacing="0">
			  <tr> 
				<td width="46%" valign="top"> 
					<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
						<cfinvokeargument name="query" 				value="#rsLista#"/>
						<cfinvokeargument name="desplegar" 			value="Edestino,cxp,cxc"/>
						<cfinvokeargument name="etiquetas" 			value="Empresa destino, Cuenta por cobrar, Cuenta por pagar"/>
						<cfinvokeargument name="formatos" 			value="V,V,V"/>
						<cfinvokeargument name="align" 				value="left,left,left"/>
						<cfinvokeargument name="ajustar" 			value="N,N,N"/>
						<cfinvokeargument name="irA" 				value="CtasInterCia.cfm"/>
						<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
						<cfinvokeargument name="keys" 				value="Ecodigodest"/>
						<cfinvokeargument name="maxRows" 			value="#form.MaxRows#"/>
					 </cfinvoke>
					</td>
					<td width="53%" valign="top">
						<cfinclude template="formCtasInterCia.cfm">
					</td>
			 	</tr>
			</table>            	
		<cf_web_portlet_end>
	<cf_templatefooter>