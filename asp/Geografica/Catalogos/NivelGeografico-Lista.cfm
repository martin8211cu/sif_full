<cfparam name="irA" default="">
<cfparam name="BtnsMostrar" default="">
<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td valign="top">
			<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetlistadoNiveles" returnvariable="rsListadoNiveles">
				<cfinvokeargument name="Conexion" value="asp">
				<cfif isdefined('form.Ppais') and len(trim(form.Ppais))>
					<cfinvokeargument name="Ppais" 	  value="#form.Ppais#">
				</cfif>
				<cfif isdefined('form.Pnombre') and len(trim(form.Pnombre))>
					<cfinvokeargument name="Pnombre"  value="#form.Pnombre#">
				</cfif>
			</cfinvoke>
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" 
				query="#rsListadoNiveles#" 
				conexion="#session.dsn#"
				desplegar="Ppais,Pnombre,cantidad"
				etiquetas="Código País,Descripción,Cantidad de Niveles"
				formatos="S,S,U"
				mostrar_filtro="true"
				align="left,left,left"
				checkboxes="N"
				ira="#irA#"
				botones="#BtnsMostrar#"
				keys="Ppais">
			</cfinvoke>
		</td>
	</tr>
</table>
