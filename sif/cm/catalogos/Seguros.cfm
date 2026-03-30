<cf_templateheader title="	Compras - Cat&aacute;logos - Seguros">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Seguros'>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="3" valign="top">
			<cfinclude template="../../portlets/pNavegacionAD.cfm">
		</td>
	</tr>
	<tr>
		<td valign="top" width="46%">
			<cfquery name="rsSeguros" datasource="#Session.DSN#">
				select 	CMSid, CMSdescripcion, ESporcadic, ESporcmult
				from   CMSeguros   
				where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
			</cfquery>
			
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsSeguros#"/>
				<cfinvokeargument name="desplegar" value="CMSdescripcion, ESporcadic, ESporcmult"/>
				<cfinvokeargument name="etiquetas" value="Descripción, % Adicional, % Multip."/>
				<cfinvokeargument name="formatos" value="V,V,V"/>
				<cfinvokeargument name="align" value="left,right,right"/>
				<cfinvokeargument name="ajustar" value="N,N,N"/>
				<cfinvokeargument name="irA" value="Seguros.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="CMSid"/>
			 </cfinvoke>
		</td>
		<td width="1%">&nbsp;</td>
		<td valign="top" width="53%" align="center">
			<cfinclude template="formSeguros.cfm">
		</td>
	</tr>
</table>
		<cf_web_portlet_end>
	<cf_templatefooter>

			


