<cfif isdefined("url.FCVtipo") and len(url.FCVtipo) and not isdefined("form.FCVtipo")><cfset form.FCVtipo = url.FCVtipo></cfif>
<cfif isdefined("url.FCPPid") and len(url.FCPPid) and not isdefined("form.FCPPid")><cfset form.FCPPid = url.FCPPid></cfif>

<!--- Obtiene la Moneda de la Empresa --->
<cfquery name="qry_monedaEmpresa" datasource="#session.dsn#">
	select e.Mcodigo, m.Mnombre
	from Empresas e, Monedas m
	where e.Ecodigo = #Session.Ecodigo#
	  and m.Ecodigo = e.Ecodigo
	  and m.Mcodigo = e.Mcodigo
</cfquery>
<cfif find(",",qry_monedaEmpresa.Mnombre) GT 0>
	<cfset LvarMnombreEmpresa = trim(mid(qry_monedaEmpresa.Mnombre,find(",",qry_monedaEmpresa.Mnombre)+1,100))>
<cfelse>	
	<cfset LvarMnombreEmpresa = qry_monedaEmpresa.Mnombre>
</cfif>
<cfset LvarMnombreEmpresa = replace(qry_monedaEmpresa.Mnombre,",","")>

<cfinclude template="qry_lista.cfm">

<cfif isdefined("request.CFaprobacion_MesesAnt")>
	<cfset LvarCFM = "aprobacion_MesesAnt.cfm">
<cfelse>
	<cfset LvarCFM = "aprobacion.cfm">
</cfif>

<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="PListaRet">
 	<cfinvokeargument name="query" value="#qry_lista#">
	<cfinvokeargument name="cortes" value="Vtipo, PDescripcion">
	<cfinvokeargument name="desplegar" value="CVdescripcion, mensaje"/>
	<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, "/>
	<cfinvokeargument name="formatos" value="S, S"/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="#LvarCFM#"/>
	<cfinvokeargument name="keys" value="CVid"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="maxrows" value="10"/>
	<cfinvokeargument name="width" value="70%"/>
</cfinvoke>	
<cfif isdefined("form.mensaje")>
<div align="center" style="color:#FF0000">
La Version escogida no se ha completado de Formular<BR><BR>
</div>
</cfif>
<br>
<cfif qry_lista.recordCount GT 0>
<div align="center" style="color:#0000FF ">
Escoja la Version que desea Aprobar<BR><BR>
<cfelse>
<div align="center" style="color: #990000">
No existen versiones para Aprobar<BR><BR>
</cfif>
</div>

