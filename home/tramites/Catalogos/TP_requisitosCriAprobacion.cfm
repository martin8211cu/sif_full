<cfif isdefined('url.id_requisito') and not isdefined('form.id_requisito')>
	<cfparam name="form.id_requisito" default="#url.id_requisito#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined('form.id_requisito') and len(trim(form.id_requisito))>
	<cfset modo = 'CAMBIO'>	
</cfif>

<cfset navegacion = "">
<cfif isdefined('form.id_requisito') and len(trim(form.id_requisito))>
	<cfset navegacion = #navegacion# & "id_requisito=" & #form.id_requisito#>
</cfif>


<cfinvoke component="home.tramites.componentes.cierre" method="datos_fijos"
	returnvariable="datos_fijos"></cfinvoke>

<cfquery name="lista" datasource="#session.tramites.dsn#">
select a.id_criterio, a.valor, 
	b.nombre_campo,
	a.campo_fijo,
	a.operador,
	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.id_requisito#"> as id_requisito,
	8 as tab
from  TPCriterioAprobacion  a
left join DDTipoCampo b
	on b.id_campo = a.id_campo
where  id_requisito = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.id_requisito#">
</cfquery> 

<cfloop query="lista">
	<cfif (Len(Trim(lista.nombre_campo)) EQ 0) and (Len(Trim(lista.campo_fijo)) NEQ 0)>
		<cfquery dbtype="query" name="buscar_una_descripcion">
			select nombre from datos_fijos where codigo = '#lista.campo_fijo#'
		</cfquery>
		<cfset QuerySetCell(lista, 'nombre_campo', buscar_una_descripcion.nombre, lista.CurrentRow)>
	</cfif>
</cfloop>


<cfoutput>
<!--- "TP_requisitosCriAprobacion-Form.cfm" --->
	
<table width="100%" border="0" align="left" cellpadding="0">
	<tr>
		<td  align="Top" style="elevation:higher" ><!--- form --->
            <cfinclude template="TP_requisitosCriAprobacionAND-Form.cfm">
		</td>
	</tr>
	<tr>	
		<td width="50%" rowspan="3" align="top" valign="top">
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#lista#"/>
				<cfinvokeargument name="desplegar" value="nombre_campo, operador,valor"/>
				<cfinvokeargument name="etiquetas" value="Campo,Operador,Valor"/>
				<cfinvokeargument name="formatos" value="V, V,V"/>
				<cfinvokeargument name="align" value="left, left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="keys" value="id_criterio"/>
				<cfinvokeargument name="showemptylistmsg" value="true"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="maxrows" value="17"/>
				
	  </cfinvoke>	  </td>
		<td width="50%"  rowspan="2" align="top" valign="top"><!--- form --->
			 <cfinclude template="TP_requisitosCriAprobacion-Form.cfm">	  </td>
	</tr>
</table> 
</cfoutput>
