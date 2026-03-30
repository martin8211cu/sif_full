<cfif isdefined("url.id_inst") and not isdefined("form.id_inst")>
	<cfset form.id_inst = url.id_inst >
</cfif>
<cfif isdefined("url.id_grupo") and not isdefined("form.id_grupo")>
	<cfset form.id_grupo = url.id_grupo >
</cfif>

<cf_templatecss>

	<table width="100%" border="0" cellspacing="3" cellpadding="0">
	<tr>
		<td colspan="3" valign="top">
			<cfinclude template="/home/menu/pNavegacion.cfm">
		</td>
	</tr>
	<tr> 
		<td valign="top" width="40%">
			<cfquery name="rsLista" datasource="#session.tramites.dsn#">
				select id_inst, id_grupo, codigo_grupo, nombre_grupo, 3 as tab
				from TPGrupo
				where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_inst#">
				order by codigo_grupo
			</cfquery>

			<cfinvoke 
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="codigo_grupo, nombre_grupo"/>
				<cfinvokeargument name="etiquetas" value="C&oacute;digo,Nombre"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="instituciones.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="id_grupo"/>
				<cfinvokeargument name="formname" value="listag"/>
			</cfinvoke>
		</td>
		<td valign="top"><cfinclude template="grupo-form.cfm"></td>
	</tr>
	<tr> 
		<td colspan="3">&nbsp;</td>
	</tr> 
	</table>
