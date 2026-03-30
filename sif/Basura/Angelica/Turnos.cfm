<cf_template template="#session.sitio.template#">
	<cf_templatearea name="title">
			Turnos
	</cf_templatearea>
<cf_templatearea name="body">
<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Turnos por Oficina'>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="3" valign="top">
			<cfinclude template="../../portlets/pNavegacionAD.cfm">
		</td>
	</tr>
	<tr>
		<td valign="top" width="50%">
			<cfquery name="rsTurnos" datasource="#Session.DSN#">
				select 	Codigo_turno,Tdescripcion
				from   Turnos   
				where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value = "#session.ecodigo#" >
			</cfquery>
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsTurnos#"/>
				<cfinvokeargument name="desplegar" value="Codigo_turno,Tdescripcion"/>
				<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
				<cfinvokeargument name="formatos" value="V,V"/>
				<cfinvokeargument name="align" value="left,left"/>
				<cfinvokeargument name="ajustar" value="N,N"/>
				<cfinvokeargument name="irA" value="Aduanas.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="Turno_id"/>
			 </cfinvoke>
		</td>
		<td valign="top" width="50%" align="center">
			<cfinclude template="formTurnos.cfm">
		</td>
	</tr>
</table>
		</cf_web_portlet>
	</cf_templatearea>
</cf_template>

			


