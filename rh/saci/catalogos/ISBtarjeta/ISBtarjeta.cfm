<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cf_web_portlet_start titulo="Mantenimiento de Instrumento de Pago">
	
	<table border="0" width="100%" cellpadding="2" cellspacing="0">
	  <tr>
	  	<td valign="top" width="50%">
			<cfinvoke component="sif.Componentes.pListas" method="pLista"
				tabla="ISBtarjeta"
				columnas="MTid,MTnombre"
				filtro="1=1 order by MTnombre"
				desplegar="MTnombre"
				etiquetas="Nombre"
				formatos="S"
				align="left"
				ira="#CurrentPage#"
				form_method="get"
				keys="MTid"
				mostrar_filtro="yes"
				filtrar_automatico="yes"
				maxRows="0"
			/>
		</td>
	  	<td>
			<cfinclude template="ISBtarjeta-form.cfm">
		</td>
	  </tr>
	</table>
	
	<cf_web_portlet_end>
<cf_templatefooter>
