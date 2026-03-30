<cf_templateheader title="Talonarios">
	<cfinclude template="../../portlets/pNavegacionFA.cfm">
		<cf_web_portlet_start titulo="Cat&aacute;logo de Talonarios">
		<cfparam name="LvarPagina" default="Talonarios.cfm">
		<cfparam name="LvarSQLPagina" default="SQLTalonarios.cfm">
		  	<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
			  	<td valign="top" width="30%">
					<cfinvoke component="sif.Componentes.pListas" method="pListaRH" returnvariable="pListaRet">
						<cfinvokeargument name="tabla" 		value="Talonarios"/>
						<cfinvokeargument name="columnas" 	value="convert(varchar,Tid) as Tid, case isnull(substring(Tdescripcion,30,1),'') when '' then Tdescripcion else substring(Tdescripcion,1,26) + '...' end Tdescripcion, RIserie"/>
						<cfinvokeargument name="desplegar" 	value="Tdescripcion,	RIserie"/>
						<cfinvokeargument name="etiquetas" 	value="Descripción, Serie"/>
						<cfinvokeargument name="formatos" 	value="S,S"/>
						<cfinvokeargument name="filtro" 	value="Ecodigo = #Session.Ecodigo#"/>
						<cfinvokeargument name="align" 		value="left, left"/>
						<cfinvokeargument name="ajustar" 	value="N"/>
						<cfinvokeargument name="checkboxes" value="N"/>
						<cfinvokeargument name="irA" 		value="Talonarios.cfm"/>
					</cfinvoke>
				</td>
				<td>
					<cfinclude template="formTalonarios.cfm">
				</td>
			  </tr>
			</table>
 		<cf_web_portlet_end>
<cf_templatefooter>