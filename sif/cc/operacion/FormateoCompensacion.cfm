
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset MSG_DigFecDocto = t.Translate('MSG_DigFecDocto','Hay una mezcla de Tipos de Documento incorrecta')>
<cfset LB_TpoNet = t.Translate('LB_TpoNet','Tipo de Compensaci&oacute;n')>
<cfset MSG_NetDoctos = t.Translate('MSG_NetDoctos','Compensaci&oacute;n de Documentos de CxC y CxP (Sin Anticipos de Efectivo)')>
<cfset MSG_AplAntCXC = t.Translate('MSG_AplAntCXC','Aplicación de Anticipos de CxC')>
<cfset MSG_AplAntCXP = t.Translate('MSG_AplAntCXP','Aplicación de Anticipos de CxP')>
<cfset MSG_NetAnt = t.Translate('MSG_NetAnt','Compensaci&oacute;n de Anticipos de CxC y CxP (Sin Documentos a Aplicar)')>
<cfset MSG_NetNImpl = t.Translate('MSG_NetNImpl','Tipo de Compensaci&oacute;n no se ha implementado)')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_Socio = t.Translate('LB_Socio','Socio')>
<cfset Oficina 		= t.Translate('Oficina','Oficina','/sif/generales.xml')>
<cfset LB_Transaccion = t.Translate('LB_Transaccion','Transacci&oacute;n','/sif/generales.xml')>
<cfset LB_Moneda = t.Translate('LB_Moneda','Moneda','/sif/generales.xml')>
<cfset LB_Diferencia = t.Translate('LB_Diferencia','Diferencia')>
<cfset LB_Monto = t.Translate('LB_Monto','Monto','/sif/generales.xml')>
<cfset LB_Obs = t.Translate('LB_Obs','Observaciones')>
<cfset MSG_Aplicar = t.Translate('MSG_Aplicar','Desea Aplicar la Compensaci\u00F3n de Documentos?')>
<cfset MSG_DocSD = t.Translate('MSG_DocSD','El Documento no tiene detalles.')>
<cfset MSG_DocNoB = t.Translate('MSG_DocNoB','El Documento no est&aacute; balanceado.')>

<cfif isdefined("url.Fecha_F")  and LEN(TRIM(url.Fecha_F)) and not isdefined('form.Fecha_F')>
	<cfset form.Fecha_F= url.Fecha_F>
</cfif>
<cfif isdefined("url.DocCompensacion_F") and LEN(TRIM(url.DocCompensacion_F)) and not isdefined('form.DocCompensacion_F')>
	<cfset form.DocCompensacion_F= url.DocCompensacion_F>
</cfif>
<cfif isdefined("url.SNcodigo_F") and len(trim(url.SNcodigo_F)) and not isdefined('form.SNcodigo_F')>
	<cfset form.SNcodigo_F=url.SNcodigo_F>
</cfif>

<cfset regresar = "">
<cfif isdefined("form.Fecha_F")  and LEN(TRIM(form.Fecha_F))>
	<cfset regresar = regresar & "Fecha_F=#form.Fecha_F#">
</cfif>
<cfif isdefined("form.DocCompensacion_F") and LEN(TRIM(form.DocCompensacion_F))>
	<cfset regresar = regresar & "&DocCompensacion_F=#form.DocCompensacion_F#">
</cfif>
<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
	<cfset regresar = regresar & "&SNcodigo_F=#form.SNcodigo_F#">
</cfif>


<!--- Establezco el modoComp --->
<cfset modoComp = "ALTA">
<cfif isdefined("form.idDocCompensacion") and len(trim(form.idDocCompensacion)) and not isdefined("form.BtnNuevo")>
	<cfset modoComp = "CAMBIO">
</cfif>

<!--- Obtiene Las Transacciones --->
<cfquery name="rsTransacciones" datasource="#session.dsn#">
	SELECT CCTcodigo,
       CCTdescripcion
	FROM CCTransacciones
	WHERE Ecodigo = #session.Ecodigo#
	  AND CCTCompensacion = 1
	  AND UPPER(CCTcodigo) = 'CO'
	ORDER BY 1
</cfquery>

<!--- Obtiene Las Oficinas --->
<cfquery name="rsOficinas" datasource="#session.dsn#">
	SELECT Ocodigo,
       Odescripcion
	FROM Oficinas
	WHERE Ecodigo = #session.Ecodigo#
	ORDER BY 1
</cfquery>

<!--- Obtiene los datos del Documento de Compensacion cuando el modoComp es Cambio --->
<cfif (modoComp neq "ALTA")>
	<cfquery name="rsDocCompensacion" datasource="#session.dsn#">
		SELECT a.idDocCompensacion,
		       a.Mcodigo,
		       a.CCTcodigo,
		       a.DocCompensacion,
		       a.Observaciones,
		       a.SNcodigo,
		       d.SNid,
		       a.Dmonto,
		       a.Ocodigo,
		       a.Dfechadoc,
		       a.ts_rversion,
		       b.Mnombre,
		       c.CCTdescripcion,
		       d.SNnombre,
		       a.TipoCompensacionDocs
		FROM DocCompensacion a
		INNER JOIN Monedas b ON a.Mcodigo = b.Mcodigo
		AND a.Ecodigo = b.Ecodigo
		LEFT OUTER JOIN CCTransacciones c ON a.CCTcodigo = c.CCTcodigo
		AND a.Ecodigo = c.Ecodigo
		LEFT OUTER JOIN SNegocios d ON a.SNcodigo = d.SNcodigo
		AND a.Ecodigo = d.Ecodigo
		WHERE a.idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
		  AND a.Ecodigo = #session.Ecodigo#
	</cfquery>

	<cfquery name="rsTieneDetalles" datasource="#session.dsn#">
		SELECT COALESCE((SELECT COUNT(1)
	                   FROM DocCompensacionDCxC b
	                   WHERE b.idDocCompensacion = DocCompensacion.idDocCompensacion ) ,0)
					+ COALESCE((SELECT COUNT(1)
                                FROM DocCompensacionDCxP b
                                WHERE b.idDocCompensacion = DocCompensacion.idDocCompensacion ) ,0) AS cantidad,
			       COALESCE((SELECT SUM(a.Dmonto * CASE WHEN b.CCTtipo = 'D' THEN 1 ELSE -1 END)
                   FROM DocCompensacionDCxC a, CCTransacciones b
                   WHERE a.idDocCompensacion = DocCompensacion.idDocCompensacion
                     AND b.CCTcodigo = a.CCTcodigo
                     AND b.Ecodigo = a.Ecodigo ) , 0.00)
					+ COALESCE((SELECT SUM(a.Dmonto * CASE WHEN b.CPTtipo = 'D' THEN 1 ELSE -1 END)
                   FROM DocCompensacionDCxP a, EDocumentosCP d, CPTransacciones b
                   WHERE a.idDocCompensacion = DocCompensacion.idDocCompensacion
                     AND d.IDdocumento = a.idDocumento
                     AND b.Ecodigo = d.Ecodigo
                     AND b.CPTcodigo = d.CPTcodigo ) , 0.00) AS saldo
		FROM DocCompensacion
		WHERE Ecodigo = #session.Ecodigo#
		  AND idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.idDocCompensacion#">
	</cfquery>

	<cfset LvarTipoCompMSG = "">
	<cfset LvarTipoCompDocs = rsDocCompensacion.TipoCompensacionDocs>
	<cfif LvarTipoCompDocs EQ 0>
		<cfset LvarTipoCompDocs = createobject("component","sif.Componentes.CC_AplicaCompensacionDocs").DeterminarTipoCompensacionDocs (form.idDocCompensacion)>
		<cfif LvarTipoCompDocs EQ -1>
			<cfset LvarTipoCompMSG = "#MSG_DigFecDocto#">
		</cfif>
	<cfelse>
		<cfset LvarTipoCompMSG = createobject("component","sif.Componentes.CC_AplicaCompensacionDocs").VerificarTipoCompensacionDocs(form.idDocCompensacion)>
	</cfif>
<cfelse>
	<cfset LvarTipoCompMSG = "">
	<cfset LvarTipoCompDocs = createobject("component","sif.Componentes.CC_AplicaCompensacionDocs").DeterminarTipoCompensacionDocs (-1)>
</cfif>

<cfoutput>
	<form action="compensacionDocsCC-sql.cfm" name="formComp1" method="post">
		<cfif isdefined("form.Fecha_F")  and LEN(TRIM(form.Fecha_F))>
			<input name="Fecha_F" type="hidden" value="#form.Fecha_F#" tabindex="-1">
		</cfif>
		<cfif isdefined("form.DocCompensacion_F") and LEN(TRIM(form.DocCompensacion_F))>
			<input name="DocCompensacion_F" type="hidden" value="#form.DocCompensacion_F#" tabindex="-1">
		</cfif>
		<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
			<input name="SNcodigo_F" type="hidden" value="#form.SNcodigo_F#" tabindex="-1">
		</cfif>
		<table width="1%" align="center"  border="0" cellspacing="2" cellpadding="0">
			<tr><td colspan="4">&nbsp;</td></tr>
			<cfif LvarTipoCompDocs NEQ 0>
		  	<tr>
				<td valign="top" nowrap align="right"><strong><cfoutput>#LB_TpoNet#&nbsp;:&nbsp;</cfoutput></strong></td>
				<td colspan="3">
					<cfif modoComp EQ "ALTA" OR rsTieneDetalles.cantidad EQ 0 OR LvarTipoCompMSG NEQ "">
						<cfif LvarTipoCompDocs EQ -1>
							<strong><font color="##FF0000">#LvarTipoCompMSG#</font></strong>
							<BR>
						</cfif>
					<select name="tipoCompDocs">
						<option value="1" <cfif LvarTipoCompDocs EQ 1>selected</cfif>>#MSG_NetDoctos#</option>
						<option value="2" <cfif LvarTipoCompDocs EQ 2>selected</cfif>>#MSG_AplAntCXC#</option>
						<option value="3" <cfif LvarTipoCompDocs EQ 3>selected</cfif>>#MSG_AplAntCXP#</option>
						<option value="4" <cfif LvarTipoCompDocs EQ 4>selected</cfif>>#MSG_NetAnt#</option>
					</select>
						<cfif LvarTipoCompMSG NEQ "" AND LvarTipoCompDocs NEQ -1>
							<BR>
							<strong><font color="##FF0000">#LvarTipoCompMSG#</font></strong>
						</cfif>
					<cfelse>
						<input type="hidden" name="tipoCompDocs" id="tipoCompDocs" value="#rsDocCompensacion.TipoCompensacionDocs#">
						<cfif LvarTipoCompMSG NEQ "">
							<strong><font color="##FF0000">#LvarTipoCompMSG#</font></strong>
						<cfelseif LvarTipoCompDocs EQ 1>
							<strong>#MSG_NetDoctos#</strong>
						<cfelseif LvarTipoCompDocs EQ 2>
							<strong>#MSG_AplAntCXC#</strong>
						<cfelseif LvarTipoCompDocs EQ 3>
							<strong>#MSG_AplAntCXP#</strong>
						<cfelseif LvarTipoCompDocs EQ 4>
							<strong>#MSG_NetAnt#</strong>
						<cfelse>
							<cfthrow message="#MSG_NetNImpl#">
						</cfif>
					</cfif>
				</td>
			</tr>
			</cfif>
			<tr>
				<td valign="top" nowrap align="right"><strong>#LB_Documento#&nbsp;:&nbsp;</strong></td>
				<td>
					<input name="DocCompensacion" type="text" size="20" tabindex="1"
					 maxlength="20" <cfif isDefined("rsDocCompensacion.DocCompensacion")> value="#Trim(rsDocCompensacion.DocCompensacion)#" </cfif>>
				</td>
				<td valign="top" nowrap align="right"><strong>#LB_Fecha#&nbsp;:&nbsp;</strong></td>
				<td>
					<cfif (modoComp neq "ALTA")>
						<cfset Lvar_fecha = rsDocCompensacion.Dfechadoc>
					<cfelse>
						<cfset Lvar_fecha = Now()>
					</cfif>
					<cf_sifcalendario form="formComp1" name="Dfechadoc" tabindex="1"
						value="#DateFormat(Lvar_fecha,'dd/mm/yyyy')#" >
				</td>
		  	</tr>
		  	<tr>
				<td valign="top" nowrap align="right"><strong>#LB_Socio#&nbsp;:&nbsp;</strong></td>
				<td>
					<cfif isdefined("rsDocCompensacion.SNcodigo")>
						<cf_sifsociosnegocios2 form="formComp1" idquery="#rsDocCompensacion.SNcodigo#" size="43"  tabindex="1">
					<cfelse>
						<cf_sifsociosnegocios2 form="formComp1" size="43"  tabindex="1">
					</cfif>
				</td>
				<td valign="top" nowrap align="right"><p><strong>#Oficina#&nbsp;:&nbsp;</strong></p>    </td>
				<td>
					<select name="Ocodigo"  tabindex="1">
						<option value="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--seleccione una opci&oacute;n--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
						<cfloop query="rsOficinas">
							<option value="#rsOficinas.Ocodigo#" <cfif (isDefined("rsDocCompensacion.Ocodigo") AND rsOficinas.Ocodigo EQ rsDocCompensacion.Ocodigo)>selected</cfif>>#rsOficinas.Odescripcion#</option>
						</cfloop>
					</select>
				</td>
		  	</tr>
		  	<tr>
				<td valign="top" nowrap align="right"><p><strong>#LB_Transaccion#&nbsp;:&nbsp;</strong></p>    </td>
				<td>
					<select name="CCTcodigo"  tabindex="1">
						<option value="">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;--seleccione una opci&oacute;n--&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</option>
						<cfloop query="rsTransacciones">
							<option value="#rsTransacciones.CCTcodigo#" <cfif (isDefined("rsDocCompensacion.CCTcodigo") AND rsTransacciones.CCTcodigo EQ rsDocCompensacion.CCTcodigo)>selected</cfif>>#rsTransacciones.CCTdescripcion#</option>
						</cfloop>
					</select>
				</td>
				<td valign="top" nowrap align="right"><p><strong>#LB_Moneda#&nbsp;:&nbsp;</strong></p>    </td>
				<td>
					<cfif isdefined("rsDocCompensacion.Mcodigo") and rsTieneDetalles.cantidad GT 0>
						<!---  No se modifica en modoComp cambio cuando tiene detalles porque todas las transacciones de cxc y cxp dependen de esta moneda --->
						<input type="hidden" name="Mcodigo" value="#rsDocCompensacion.Mcodigo#" tabindex="-1">
						#rsDocCompensacion.Mnombre#
					<cfelseif isdefined("rsDocCompensacion.Mcodigo")>
						<cf_sifmonedas form="formComp1" query="#rsDocCompensacion#"  tabindex="1">
					<cfelse>
						<cf_sifmonedas form="formComp1"  tabindex="1">
					</cfif>
				</td>
		  	</tr>
		  	<tr>
				<td valign="top" nowrap align="right"><strong><cfif TipoCompensacion eq 1>#LB_Diferencia#<cfelse>#LB_Monto#</cfif> : </strong></td>
				<td colspan="3">
					<cfif isDefined('rsDocCompensacion.Dmonto') and len(trim(rsDocCompensacion.Dmonto))>
						<cfset Lvar_monto = rsDocCompensacion.Dmonto>
					<cfelse>
						<cfset Lvar_monto = 0.00>
					</cfif>
					<cf_monto name="Dmonto" value="#Lvar_monto#" modificable="false"  tabindex="1">
				</td>
		  	</tr>
		  	<tr>
				<td valign="top" nowrap align="right"><strong>#LB_Obs#&nbsp;:&nbsp;</strong></td>
				<td colspan="3">
					<textarea name="Observaciones" cols="85" rows="3"  tabindex="1"><cfif isDefined("rsDocCompensacion.Observaciones")>#Trim(rsDocCompensacion.Observaciones)#</cfif></textarea>
				</td>
		  	</tr>
		  	<tr>
				<td colspan="2">&nbsp;</td>
		  	</tr>
		</table>

		<!--- Validación para poner el botón de Aplicar --->
		<cfset Aplicar =  "">
		<cfif modoComp neq "ALTA"
			and rsTieneDetalles.cantidad GT 0
			and (TipoCompensacion eq 1 and rsTieneDetalles.saldo eq 0 or TipoCompensacion neq 1)
			and LvarTipoCompMSG EQ "">
			<cfset Aplicar =  "Aplicar">
            <cfoutput>
			<script language="javascript" type="text/javascript">
				<!--//
				function funcAplicarcompensacion(){
					var result = true;
					if (confirm('#MSG_Aplicar#'))
						document.formComp1.action = "AplicaCompensacionMasiva.cfm";
					else
						result = false;
					return result;
				}
				//-->
			</script>
			</cfoutput>
		<cfelseif modoComp neq "ALTA"
			and rsTieneDetalles.cantidad EQ 0>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td style="color:##FF0000" scope="col" align="center">#MSG_DocSD#</td>
				  </tr>
				</table>
		<cfelseif modoComp neq "ALTA"
			and (TipoCompensacion eq 1 and rsTieneDetalles.saldo NEQ 0)>
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td style="color:##FF0000" scope="col" align="center">#MSG_DocNoB#</td>
				  </tr>
				</table>
		<cfelseif modoComp neq "ALTA"
			and LvarTipoCompMSG NEQ "">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				  <tr>
					<td style="color:##FF0000" scope="col" align="center">#LvarTipoCompMSG#</td>
				  </tr>
				</table>
		</cfif>
		<cf_botones formname="formComp1" sufijo="compensacion" modo="#modoComp#" include="#Aplicar#" regresar="compensacionDocsCC.cfm?#regresar#" tabindex="1">

		<cfif (modoComp neq "ALTA")>
			<input type="hidden" name="idDocCompensacion" value="#rsDocCompensacion.idDocCompensacion#">
			<cfinvoke
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts"
				arTimeStamp="#rsDocCompensacion.ts_rversion#"/>
			<input type="hidden" name="timestampComp" value="#ts#">
		</cfif>
		<input type="hidden" name="TipoCompensacion" value="#TipoCompensacion#">
	</form>


	<cf_qforms form="formComp1" >
	    <cf_qformsRequiredField name="DocCompensacion" description="#LB_Documento#">
		<cf_qformsRequiredField name="SNcodigo" description="#LB_Socio#">
		<cf_qformsRequiredField name="Dfechadoc" description="#LB_Fecha#">
		<cf_qformsRequiredField name="Ocodigo" description="#Oficina#">
		<cf_qformsRequiredField name="CCTcodigo" description="#LB_Transaccion#">
		<cf_qformsRequiredField name="Mcodigo" description="#LB_Moneda#">
		<cf_qformsRequiredField name="Dmonto" description="#LB_Monto#">
	</cf_qforms>
</cfoutput>