
		
<cfquery datasource="#session.dsn#" name="lista_1">
	select EEid
	from RHEncuestadora
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
</cfquery>
<cfquery datasource="sifpublica" name="lista">
	select EEid,EEnombre,Ppais
	from EncuestaEmpresa
	<cfif lista_1.RecordCount>
	where EEid not in ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#lista_1.EEid#" list="yes"> )
	</cfif>
</cfquery>

<cf_template>
<cf_templatearea name="title">
	Selecci&oacute;n de encuestadoras
</cf_templatearea>
<cf_templatearea name="body">

<cfinclude template="/home/menu/pNavegacion.cfm">
<cf_web_portlet_start titulo="Seleccionar encuestadora" width="450">

		<cfif lista.RecordCount>

<table width="450" border="0" cellspacing="6" align="center">
	<tr><td colspan="4">Las siguientes empresas están registradas como empresas encuestadoras, y usted no las está utilizando actualmente.
	
	<br>
Haga clic en la empresa cuyas encuestas desee utilizar.<br>
<br>
<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
				query="#lista#"
				desplegar="EEnombre,Ppais"
				etiquetas="Empresa Encuestadora,País"
				formatos="S,S"
				align="left,left"
				ira="EmpresaOrganizacion.cfm"
				form_method="get"
				keys="EEid"
			/>
	</td></tr>
  <tr>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
    <td valign="top">&nbsp;</td>
  </tr>
</table>
<cfelse><br>
<br>

	No hay más empresas disponibles
<br>
<br>
</cfif>
<br>
<form action="RHEncuestadora.cfm" method="get"><input type="submit" value="&lt;&lt; Regresar"></form>
<br>
<cf_web_portlet_end>

</cf_templatearea>
</cf_template>


