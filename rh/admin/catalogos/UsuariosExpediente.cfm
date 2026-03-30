<cfset modo = "ALTA">
<cfif isdefined("Form.Usucodigo")>
	<cfset modo = "CAMBIO">
</cfif>

<table width="98%" cellpadding="0" cellspacing="0" style="padding-left: 5px; padding-right: 5px;">
	<tr>
		<td width="50%" valign="top">
			<!--- Lista de Usuarios que tienen permisos --->
			<cfquery name="rsUsuariosExpediente" datasource="#Session.DSN#">
				select distinct Usucodigo
				from UsuariosTipoExpediente
				where TEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TEid#">
			</cfquery>
			
			<cfset filtro = "">
			<cfif rsUsuariosExpediente.recordCount GT 0>
				<cfset filtro = filtro & " and b.Usucodigo in (#ValueList(rsUsuariosExpediente.Usucodigo, ',')#)">
			<cfelse>
				<cfset filtro = filtro & " and b.Usucodigo = 0">
			</cfif>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_Usuario"
				Default="Usuario"
				XmlFile="/rh/generales.xml"
				returnvariable="LB_Usuario"/>

			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="Usuario b, DatosPersonales c"/>
				<cfinvokeargument name="columnas" value="b.Usucodigo, 
														{fn concat(c.Pnombre,
														{fn concat(' ', 
														{fn concat(c.Papellido1,
														{fn concat(' ',c.Papellido2)})})})} as Nombre,
														'#Form.TEid#' as TEid"/>
				<cfinvokeargument name="desplegar" value="Nombre"/>
				<cfinvokeargument name="etiquetas" value="#LB_Usuario#"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="filtro" value="b.CEcodigo = #Session.CEcodigo#
													   and b.Uestado = 1 
													   and b.Utemporal = 0
													   and b.datos_personales = c.datos_personales 
													   #filtro#
													   order by c.Papellido1, c.Papellido2, c.Pnombre"/>
				<cfinvokeargument name="align" value="left"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="checkboxes" value="N"/>				
				<cfinvokeargument name="irA" value="#GetFileFromPath(GetTemplatePath())#"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="formName" value="listaUsuario"/>
				<cfinvokeargument name="maxRows" value="15"/>
				<cfinvokeargument name="navegacion" value="TEid=#Form.TEid#"/>
				<cfinvokeargument name="conexion" value="asp"/>
			</cfinvoke>
		</td>
		
		<td width="50%" valign="top">
			<cfinclude template="form-UsuariosExpediente.cfm">
		</td>
		
	</tr>
</table>