<!--- Creado  por Rodolfo Jiménez Jara.
		Fecha: 11-2-2006.
		Motivo: Relacion de Docuentos de CxP
--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','SIF - Cuentas por Pagar')>
<cfset TIT_RelDoctos	= t.Translate('TIT_RelDoctos','Relación de Documentos')>
<cfset LB_DatosRep 		= t.Translate('LB_DatosRep','Datos del Reporte')>
<cfset LB_Socio_Ini = t.Translate('LB_Socio_Ini','Socio de Negocios Inicial')>
<cfset LB_Socio_Fin = t.Translate('LB_Socio_Fin','Socio de Negocios Final')>
<cfset LB_Desde		= t.Translate('LB_Desde','Desde','/sif/generales.xml')>
<cfset LB_Hasta		= t.Translate('LB_Hasta','Hasta','/sif/generales.xml')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset CMB_Enero 	= t.Translate('CMB_Enero','Enero','/sif/generales.xml')>
<cfset CMB_Febrero 	= t.Translate('CMB_Febrero','Febrero','/sif/generales.xml')>
<cfset CMB_Marzo 	= t.Translate('CMB_Marzo','Marzo','/sif/generales.xml')>
<cfset CMB_Abril 	= t.Translate('CMB_Abril','Abril','/sif/generales.xml')>
<cfset CMB_Mayo 	= t.Translate('CMB_Mayo','Mayo','/sif/generales.xml')>
<cfset CMB_Junio 	= t.Translate('CMB_Junio','Junio','/sif/generales.xml')>
<cfset CMB_Julio 	= t.Translate('CMB_Julio','Julio','/sif/generales.xml')>
<cfset CMB_Agosto 	= t.Translate('CMB_Agosto','Agosto','/sif/generales.xml')>
<cfset CMB_Septiembre = t.Translate('CMB_Septiembre','Septiembre','/sif/generales.xml')>
<cfset CMB_Octubre = t.Translate('CMB_Octubre','Octubre','/sif/generales.xml')>
<cfset CMB_Noviembre = t.Translate('CMB_Noviembre','Noviembre','/sif/generales.xml')>
<cfset CMB_Diciembre = t.Translate('CMB_Diciembre','Diciembre','/sif/generales.xml')>
<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Todas = t.Translate('LB_Todas','Todas','/sif/generales.xml')>

<cf_templateheader title="#LB_TituloH#">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_RelDoctos#'>
  <cfinclude template="../../cg/consultas/Funciones.cfm">
  <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
  <cfset periodo="#get_val(30).Pvalor#">
  <cfset mes="#get_val(40).Pvalor#">

<!--- Unicamente usuarios de los documentos registrados y aplicados (Eduardo González 27-03-2018)--->
<cfquery name="rsUsuarios" datasource="#Session.DSN#">
	SELECT DISTINCT *
	FROM
	  (SELECT EDusuario,
	          EDusuario AS EDusuarioDESC
	   FROM EDocumentosCxP
	   WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	     AND CPTcodigo IN
	       (SELECT CPTcodigo
	        FROM CPTransacciones
	        WHERE coalesce(CPTpago, 0) != 1)
	   UNION ALL
	   SELECT EDusuario,
	          EDusuario AS EDusuarioDESC
	   FROM HEDocumentosCP
	   WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	     AND CPTcodigo IN
	       (SELECT CPTcodigo
	        FROM CPTransacciones
	        WHERE coalesce(CPTpago, 0) != 1) )Tbl
	ORDER BY Tbl.EDusuario ASC
</cfquery>

<!--- Unicamente las transacciones de los documentos registrados y aplicados (Eduardo González 27-03-2018)--->
<cfquery name="rsTransacciones" datasource="#Session.DSN#">
	SELECT DISTINCT *
	FROM
	  (SELECT b.CPTcodigo,
	          b.CPTdescripcion
	   FROM EDocumentosCxP a
	   INNER JOIN CPTransacciones b ON a.Ecodigo = b.Ecodigo
	   AND a.CPTcodigo = b.CPTcodigo
	   WHERE a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	     AND COALESCE(b.CPTpago, 0) != 1
	   UNION ALL
	   SELECT b.CPTcodigo,
	          b.CPTdescripcion
	   FROM HEDocumentosCP a
	   INNER JOIN CPTransacciones b ON a.Ecodigo = b.Ecodigo
	   AND a.CPTcodigo = b.CPTcodigo
	   WHERE a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	     AND COALESCE(b.CPTpago, 0) != 1) tbl
	ORDER BY tbl.CPTdescripcion ASC
</cfquery>

<form name="form1" method="get" action="RelacionDocumentos-SQL.cfm">
<table width="100%" cellpadding="2" cellspacing="0">
	<tr>
		<td valign="top">
		<fieldset><legend><cfoutput>#LB_DatosRep#</cfoutput></legend>
			<table  width="100%" cellpadding="2" cellspacing="0" border="0">
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
                	<cfoutput>
					<td>&nbsp;</td>
					<td nowrap align="left" width="10%"><strong>#LB_Socio_Ini#:&nbsp;</strong></td>
					<td nowrap align="left" width="10%"><strong>#LB_Socio_Fin#:&nbsp;</strong></td>
					<td colspan="3">&nbsp;</td>
                	</cfoutput>
				</tr>
				<tr>
					<td>&nbsp;</td>
					<td align="left"><cf_sifsociosnegocios2 Proveedores="SI"></td>
					 <td align="left"><cf_sifsociosnegocios2 Proveedores="SI" form ="form1" frame="frsocios2" SNcodigo="SNcodigob2" SNnombre="SNnombreb2" SNnumero="SNnumerob2"></td>
					<td colspan="3">&nbsp;</td>
				</tr>
				<tr>
                	<cfoutput>
					<td>&nbsp;</td>
					<td align="left"><strong>#LB_Desde#:&nbsp;</strong></td>
					<td align="left"><strong>#LB_Hasta#:&nbsp;</strong></td>
					<td align="left">&nbsp;</td>
					<td colspan="2">&nbsp;</td>
                	</cfoutput>
				</tr>
				<tr>
				  <td>&nbsp;</td>
				  <td align="left" nowrap="nowrap"><select name="periodo">
                    <option value="<cfoutput>#periodo-2#</cfoutput>"><cfoutput>#periodo-2#</cfoutput></option>
                    <option value="<cfoutput>#periodo-1#</cfoutput>"><cfoutput>#periodo-1#</cfoutput></option>
                    <option value="<cfoutput>#periodo#</cfoutput>" selected><cfoutput>#periodo#</cfoutput></option>
                    <option value="<cfoutput>#periodo+1#</cfoutput>"><cfoutput>#periodo+1#</cfoutput></option>
                    <option value="<cfoutput>#periodo+2#</cfoutput>"><cfoutput>#periodo+2#</cfoutput></option>
                  </select>
                	<cfoutput>
				    <select name="mes" size="1">
                      <option value="1" <cfif mes EQ 1>selected</cfif>>#CMB_Enero#</option>
                      <option value="2" <cfif mes EQ 2>selected</cfif>>#CMB_Febrero#</option>
                      <option value="3" <cfif mes EQ 3>selected</cfif>>#CMB_Marzo#</option>
                      <option value="4" <cfif mes EQ 4>selected</cfif>>#CMB_Abril#</option>
                      <option value="5" <cfif mes EQ 5>selected</cfif>>#CMB_Mayo#</option>
                      <option value="6" <cfif mes EQ 6>selected</cfif>>#CMB_Junio#</option>
                      <option value="7" <cfif mes EQ 7>selected</cfif>>#CMB_Julio#</option>
                      <option value="8" <cfif mes EQ 8>selected</cfif>>#CMB_Agosto#</option>
                      <option value="9" <cfif mes EQ 9>selected</cfif>>#CMB_Septiembre#</option>
                      <option value="10" <cfif mes EQ 10>selected</cfif>>#CMB_Octubre#</option>
                      <option value="11" <cfif mes EQ 11>selected</cfif>>#CMB_Noviembre#</option>
                      <option value="12" <cfif mes EQ 12>selected</cfif>>#CMB_Diciembre#</option>
                    </select>
                	</cfoutput>
                  </td>
				  <td align="left" nowrap="nowrap"><select name="periodo2">
                    <option value="<cfoutput>#periodo-2#</cfoutput>"><cfoutput>#periodo-2#</cfoutput></option>
                    <option value="<cfoutput>#periodo-1#</cfoutput>"><cfoutput>#periodo-1#</cfoutput></option>
                    <option value="<cfoutput>#periodo#</cfoutput>" selected><cfoutput>#periodo#</cfoutput></option>
                    <option value="<cfoutput>#periodo+1#</cfoutput>"><cfoutput>#periodo+1#</cfoutput></option>
                    <option value="<cfoutput>#periodo+2#</cfoutput>"><cfoutput>#periodo+2#</cfoutput></option>
                  	</select>
                	<cfoutput>
				    <select name="mes2" size="1">
                      <option value="1" <cfif mes EQ 1>selected</cfif>>#CMB_Enero#</option>
                      <option value="2" <cfif mes EQ 2>selected</cfif>>#CMB_Febrero#</option>
                      <option value="3" <cfif mes EQ 3>selected</cfif>>#CMB_Marzo#</option>
                      <option value="4" <cfif mes EQ 4>selected</cfif>>#CMB_Abril#</option>
                      <option value="5" <cfif mes EQ 5>selected</cfif>>#CMB_Mayo#</option>
                      <option value="6" <cfif mes EQ 6>selected</cfif>>#CMB_Junio#</option>
                      <option value="7" <cfif mes EQ 7>selected</cfif>>#CMB_Julio#</option>
                      <option value="8" <cfif mes EQ 8>selected</cfif>>#CMB_Agosto#</option>
                      <option value="9" <cfif mes EQ 9>selected</cfif>>#CMB_Septiembre#</option>
                      <option value="10" <cfif mes EQ 10>selected</cfif>>#CMB_Octubre#</option>
                      <option value="11" <cfif mes EQ 11>selected</cfif>>#CMB_Noviembre#</option>
                      <option value="12" <cfif mes EQ 12>selected</cfif>>#CMB_Diciembre#</option>
                    </select>
                	</cfoutput>
                  </td>
				  <td align="left">&nbsp;</td>
				  <td colspan="2">&nbsp;</td>
			    </tr>
			    <tr>
                	<cfoutput>
					<td>&nbsp;</td>
					<td align="left"><strong>Transacci&oacute;n:&nbsp;</strong></td>
					<td align="left"><strong>Usuario:&nbsp;</strong></td>
					<td align="left">&nbsp;</td>
					<td colspan="2">&nbsp;</td>
                	</cfoutput>
				</tr>
				<tr>
                	<cfoutput>
					<td>&nbsp;</td>
					<td nowrap align="left">
                    	<select name="Transaccion" tabindex="1">
						<option value="-1"><cfoutput>#LB_Todas#</cfoutput></option>
							<cfloop query="#rsTransacciones#">
								<option value="#rsTransacciones.CPTcodigo#">#rsTransacciones.CPTdescripcion#</option>
							</cfloop>
                        </select>
                    </td>
					<td nowrap align="left">
                    	<select name="Usuario" tabindex="1">
						<option value="-1"><cfoutput>#LB_Todos#</cfoutput></option>
							<cfloop query="#rsUsuarios#">
								<option value="#rsUsuarios.EDusuario#">#rsUsuarios.EDusuarioDESC#</option>
							</cfloop>
                        </select>
                    </td>
					<td align="left">&nbsp;</td>
					<td colspan="2">&nbsp;</td>
                	</cfoutput>
				</tr>
				<tr>
				  <td>&nbsp;</td>
				  <td align="left"><strong><cfoutput>#LB_Formato#&nbsp;</cfoutput></strong></td>
				  <td align="left">&nbsp;</td>
				  <td>&nbsp;</td>
				  <td>&nbsp;</td>
			    </tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="2" align="left"><div align="left">
					  <select name="Formato" id="Formato" tabindex="1">
					    <option value="pdf">PDF</option>
				      </select>
				  </div></td>
					<td>&nbsp;</td>
				    <td>&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">&nbsp;</td>
				</tr>
				<tr>
					<td colspan="6">
					<cf_botones values="Generar" names="Generar">
					</td>
				</tr>
			</table>
			</fieldset>
		</td>
	</tr>
</table>
</form>

<cf_web_portlet_end>
<cf_templatefooter>