<cf_template>
	<cf_templatearea name="title">
		Catálogo de Actividades
	</cf_templatearea>
	<cf_templatearea name="body">
		<cf_web_portlet titulo="Catálogo de Actividades">
	 		<cfinclude template="../../portlets/pNavegacion.cfm">
			<table width="99%" align="center" border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td valign="top" width="50%"> 
						
						<cfquery name="rsLista" datasource="#session.DSN#">
							select a.CTAcodigo, a.CTAdescripcion, b.CTCAdescripcion, case a.CTAhvisita when 1 then '<img src=../../imagenes/checked.gif>' else '<img src=../../imagenes/unchecked.gif>' end as CTAhvisita
							from CTActividades a
							
							inner join CTClaseActividad b
							on a.Ecodigo=b.Ecodigo
							and a.CTCAcodigo=b.CTCAcodigo
							
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							order by b.CTCAdescripcion
						</cfquery>
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsLista#"/>
							<cfinvokeargument name="desplegar" value="CTADescripcion, CTAhvisita"/>
							<cfinvokeargument name="etiquetas" value="Descripción, Genera Hoja de Visita"/>
							<cfinvokeargument name="formatos" value="S,S"/>
							<cfinvokeargument name="align" value="left, center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="irA" value="Actividades.cfm"/>
							<cfinvokeargument name="cortes" value="CTCAdescripcion"/>
						</cfinvoke>				
					</td>
					
					<td valign="top" width="50%"><cfinclude template="formActividades.cfm"></td>
				</tr>
			</table>
		</cf_web_portlet>
	</cf_templatearea>	
</cf_template>