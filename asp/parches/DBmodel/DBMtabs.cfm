<cf_templateheader title="Descripción de tablas"> 
<cfset titulo = 'Modelo de Base de Datos'>			
<cf_web_portlet_start border="true" titulo="#titulo#" skin="#Session.Preferences.Skin#">	
<cfquery name="rsEsq" datasource="asp">
	select *  from DBMsch
</cfquery>
<cfparam name="form.esq" default="#rsEsq.IDsch#">
<cfoutput>
<form name="form1" action="DBMtabs.cfm" method="post">
<table width="100%">
	<tr>
		<td>
			Esquema:
	
			<select name="esq" id="esq">
			<cfif isdefined("rsEsq") and rsEsq.recordcount gt 0>
				<cfloop query="rsEsq">
						<option value="#rsEsq.IDsch#" <cfif isdefined ('form.esq') and form.esq eq rsESQ.IDsch>selected="selected"</cfif>>#rsEsq.sch#</option>
				</cfloop>
			</cfif>
			</select>

			<input type="submit" name="filtro" id="filtro" value="Filtrar" />
		</td>
	</tr>
	<tr>
		<td>
			<cfif isdefined ('form.esq') and form.esq gt 0>
				<cfset filtrar= 'IDsch=#form.esq#'>
			<cfelse>
				<cfset filtrar=''>
			</cfif>
			<cfinvoke component="sif.Componentes.pListas" method="pLista" 
					conexion="asp"
					tabla="DBMtab"
					columnas="IDtab,tab,des,rul,IDsch, upper(tab) as Utab"
					filtro="#filtrar# order by upper(tab)"
					desplegar="tab,des,rul"
					etiquetas="Tabla,Descripción,Regla"
					formatos="S,S,S"
					align="left,left,left"
					ira="DBMtabsDet.cfm"
					showEmptyListMsg="yes"
					keys="IDtab"
					maxRows="25"
					incluyeform="no"
					formName="form1"
					PageIndex="1"
					mostrar_filtro="yes"
					filtrar_automatico="yes"
					filtrar_por="tab,des,rul"
			/>
			
		</td>
	</tr>
</table>
</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
