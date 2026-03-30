<!---
	Eduardo Gonzalez Sarabia
	26/06/2019
	Compensacion de Documentos entre CXP y CXC.
	Esta basado en el Neteo de Documentos.
 --->
<cfset TipoCompensacion = 1>

<cfif isdefined("url.Fecha_F") and len(trim(url.Fecha_F)) GT 0>
	<cfset form.Fecha_F = url.Fecha_F>
</cfif>
<cfif isdefined("url.DocCompensacion_F") and len(trim(url.DocCompensacion_F)) GT 0>
	<cfset form.DocCompensacion_F = url.DocCompensacion_F>
</cfif>
<cfif isdefined("url.SNcodigo_F") and len(trim(url.SNcodigo_F))>
	<cfset form.SNcodigo_F = url.SNcodigo_F>
</cfif>

<cfset params = "">
<cfif isdefined("form.Fecha_F")  and LEN(TRIM(form.Fecha_F))>
	<cfset params = params & "Fecha_F=#form.Fecha_F#">
</cfif>
<cfif isdefined("form.DocCompensacion_F") and LEN(TRIM(form.DocCompensacion_F))>
	<cfset params = params & "&DocCompensacion_F=#form.DocCompensacion_F#">
</cfif>
<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
	<cfset params = params & "&SNcodigo_F=#form.SNcodigo_F#">
</cfif>


<cfif isdefined("form.Fecha_F") and len(trim(form.Fecha_F))>
	<cfset form.Fecha_F = LSParseDateTime(form.Fecha_F)>
</cfif>

<!--- Pasa Parámetros a Navegación --->

<cfset navegacion = "">
<cfif isdefined("form.Fecha_F")  and LEN(TRIM(form.Fecha_F))>
	<cfset navegacion = navegacion & "&Fecha_F=#LSDateFormat(form.Fecha_F,'dd/mm/yyyy')#">
</cfif>
<cfif isdefined("form.DocCompensacion_F") and LEN(TRIM(form.DocCompensacion_F))>
	<cfset navegacion = navegacion & "&DocCompensacion_F=#form.DocCompensacion_F#">
</cfif>
<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
	<cfset navegacion = navegacion & "&SNcodigo_F=#form.SNcodigo_F#">
</cfif>
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Fecha = t.Translate('LB_Fecha','Fecha','/sif/generales.xml')>
<cfset LB_SocioNegocio = t.Translate('LB_SocioNegocio','Socio de Negocio','/sif/generales.xml')>
<cfset LB_SelTodos = t.Translate('LB_SelTodos','Seleccionar Todos')>
<cfset MSG_AplDoc = t.Translate('MSG_Aplicar','Desea Aplicar la Compensaci\u00F3n de Documentos?')>
<cfset MSG_SelDoc = t.Translate('MSG_SelDoc','Debe seleccionar al menos un documento')>
<cfset LB_Diferencia = t.Translate('LB_Diferencia','Diferencia')>
<cfset LB_btnFiltrar = t.Translate('LB_btnFiltrar','Filtrar','/sif/generales.xml')>
<cfset BTN_Nuevo 	 = t.Translate('BTN_Nuevo','Nuevo','/sif/generales.xml')>
<cfset TIT_CompDocs = t.Translate('TIT_CompDocs','Compensaci&oacute;n de Documentos de CXP y CXC')>

<cf_templateheader title="#TIT_CompDocs#">
	<cf_web_portlet_start titulo="#TIT_CompDocs#">
		<cfoutput>
			<table width="95%" align="center"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td>
						<form action="compensacionDocsCC.cfm" method="post" name="formUno">
							<table width="100%"border="0" cellspacing="0" cellpadding="0" class="tituloListas">
								<tr>
									<td width="13%" nowrap align="right"><strong>#LB_Documento#&nbsp;:&nbsp;</strong></td>
									<td width="21%" >
										<input name="DocCompensacion_F" type="text" tabindex="1"
											value="<cfif isdefined("form.DocCompensacion_F")>#form.DocCompensacion_F#</cfif>">
									</td>
									<td width="8%" nowrap align="right"><strong>#LB_Fecha#&nbsp;:&nbsp;</strong></td>
									<td width="17%" >
										<cfif isdefined("form.Fecha_F") and len(trim(form.Fecha_F))>
											<cf_sifcalendario name="Fecha_F" form="formUno" tabindex="1"
												value="#LSDateFormat(Form.Fecha_F,'dd/mm/yyyy')#">
										<cfelse>
											<cf_sifcalendario name="Fecha_F" form="formUno"  tabindex="1">
										</cfif>
									</td>
									<td width="19%" nowrap align="right"><strong>#LB_SocioNegocio#&nbsp;:&nbsp;</strong></td>
									<td width="12%" >
										<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
											<cf_sifsociosnegocios2 form="formUno" SNcodigo="SNcodigo_F" tabindex="1"
												SNumero="SNumero_F" SNdescripcion="SNdescripcion_F" idquery="#form.SNcodigo_F#">
										<cfelse>
											<cf_sifsociosnegocios2 form="formUno" SNcodigo="SNcodigo_F" tabindex="1"
												SNumero="SNumero_F" SNdescripcion="SNdescripcion_F">
										</cfif>
									</td>
									<td width="3%" nowrap align="right">&nbsp;</td>
									<td width="7%" nowrap align="right">
										<input name="butFiltro" type="submit" value="#LB_btnFiltrar#" tabindex="1">
									</td>
								</tr>
								<tr>
				                	<td class="tituloListas" align="rigth">
				                    	<input type="checkbox" name="chkall" value="T" onClick="javascript: funcChequeaTodos();">
				                    </td>
				                	<td align="left"> <strong>#LB_SelTodos#</strong></td>
				                </tr>
							</table>
						</form>
					</td>
				</tr>
				<tr>
					<td>
						<cfquery name="rsLista" datasource="#session.dsn#">
							SELECT a.idDocCompensacion,
							       a.Mcodigo,
							       a.CCTcodigo,
							       a.DocCompensacion,
							       a.Observaciones,
							       a.SNcodigo,
							       CASE
							           WHEN (
							                   (SELECT count(1)
							                    FROM DocCompensacionDCxP
							                    WHERE idDocCompensacion = a.idDocCompensacion) = 0
							                 AND
							                   (SELECT count(1)
							                    FROM DocCompensacionDCxC
							                    WHERE idDocCompensacion = a.idDocCompensacion) = 0)
							                    THEN <cf_jdbcquery_param cfsqltype="cf_sql_money" value="null">
							           ELSE coalesce(a.Dmonto, 0)
							       END AS Dmonto,
							       b.Mnombre,
							       c.CCTdescripcion,
							       d.SNnombre,
							       a.Dfechadoc,
							       a.TipoCompensacion
							FROM DocCompensacion a
							INNER JOIN Monedas b ON a.Mcodigo = b.Mcodigo
							AND a.Ecodigo = b.Ecodigo
							LEFT OUTER JOIN CCTransacciones c ON a.CCTcodigo = c.CCTcodigo
							AND a.Ecodigo = c.Ecodigo
							LEFT OUTER JOIN SNegocios d ON a.SNcodigo = d.SNcodigo
							AND a.Ecodigo = d.Ecodigo
							WHERE a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  AND a.TipoCompensacion = #TipoCompensacion#
							  AND a.Aplicado = 0 <cfif isdefined("form.Fecha_F")
							  AND len(trim(form.Fecha_F))>
							  AND a.Dfechadoc >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.Fecha_F#"> </cfif>
							  <cfif isdefined("form.DocCompensacion_F")
								  AND len(trim(form.DocCompensacion_F))>
								  AND upper(rtrim(a.DocCompensacion)) LIKE '%#Ucase(Trim(form.DocCompensacion_F))#%'
							  </cfif>
							  <cfif isdefined("form.SNcodigo_F")
								  AND len(trim(form.SNcodigo_F))>
								  AND a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNcodigo_F#">
							  </cfif>
							  <!--- AND exists
							    (SELECT 1
							     FROM DocCompensacionDCxP l
							     WHERE l.idDocCompensacion = a.idDocCompensacion)
							  AND exists
							    (SELECT 1
							     FROM DocCompensacionDCxC l
							     WHERE l.idDocCompensacion = a.idDocCompensacion)
							ORDER BY a.Mcodigo,
							         a.Dfechadoc,
							         a.DocCompensacion --->
						</cfquery>
						<cfset NumprodArea = #rsLista.recordCount# >
						<form name="form1" method="post" action="compensacionDocsCC-form.cfm">

						<cfif isdefined("form.Fecha_F")  and LEN(TRIM(form.Fecha_F))>
							<input name="Fecha_F" type="hidden" value="#LSDateFormat(form.Fecha_F,'dd/mm/yyyy')#" tabindex="-1">
						</cfif>
						<cfif isdefined("form.DocCompensacion_F") and LEN(TRIM(form.DocCompensacion_F))>
							<input name="DocCompensacion_F" type="hidden" value="#form.DocCompensacion_F#" tabindex="-1">
						</cfif>
						<cfif isdefined("form.SNcodigo_F") and len(trim(form.SNcodigo_F))>
							<input name="SNcodigo_F" type="hidden" value="#form.SNcodigo_F#" tabindex="-1">
						</cfif>
						<cfinvoke
							component="sif.Componentes.pListas"
							method="pListaQuery"
							returnvariable="pLista"
							query="#rsLista#"
							cortes="Mnombre"
							desplegar="DocCompensacion, Dfechadoc, SNnombre, Dmonto"
							etiquetas="#LB_Documento#, #LB_Fecha#,#LB_SocioNegocio#, #LB_Diferencia#"
							formatos="S, D, V, M"
							align="left, left, left, rigth"
							irA="compensacionDocsCC-form.cfm"
							incluyeForm="no"
							formName="form1"
							botones="Aplicar,Nuevo"
							navegacion="#navegacion#"
					        showEmptyListMsg="yes"
					        maxrows="25"
					        EmptyListMsg="<br>--- No hay Compensaciones Registradas ---<br>&nbsp;"
					        checkboxes="S"
							lineaRoja="Dmonto EQ ''"
					        keys="idDocCompensacion,DocCompensacion,Dfechadoc, SNnombre, Dmonto"
							usaAJAX="no"/>
						</form>
					</td>
				</tr>
			</table>
		</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>
<cfoutput>
<script language="JavaScript1.2">
	function funcNuevo() {
	    document.form1.action = 'compensacionDocsCC-form.cfm';
	    document.form1.submit();
	}

	function funcAplicar() {
	    var result = false;
	    var checkIs = getMarcados();
	    if (checkIs !== "") {
	        if (confirm('#MSG_AplDoc#')) {
	            eval("document.form1.action = 'AplicaCompensacionMasiva.cfm?TipoCompensacion=<cfoutput>#TipoCompensacion#</cfoutput>';");
	            document.form1.submit();
	        } else {
	            result = false;
	        }
	    } else {
	        alert("#MSG_SelDoc#");
	        result = false;
	    }
	    return result;
	}

	function getMarcados() {
	    var f = document.form1;
	    var m = "";
	    if (f.chk != null) {
	        if (f.chk.value) {
	            if (f.chk.checked) {
	                m = f.chk.value;
	            }
	        } else {
	            for (var i = 0; i < f.chk.length; i++) {
	                if (f.chk[i].checked) {
	                    if (m.length == 0)
	                        m = f.chk[i].value;
	                    else
	                        m += ',' + f.chk[i].value;
	                }
	            }
	        }
	    }
	    return m;
	}

	function funcChequeaTodos() {
	    var c = document.formUno.chkall;
	    if (document.form1.chk) {
	        if (document.form1.chk.value) {
	            if (!document.form1.chk.disabled) {
	                document.form1.chk.checked = c.checked;
	            }
	        } else {
	            for (var counter = 0; counter < document.form1.chk.length; counter++) {
	                var valores = document.form1.chk[counter].value.split("|");
	                var Dmonto = parseFloat(valores[4]);

	                if (Dmonto != 0) {
	                    document.form1.chk[counter].disabled = true;
	                }
	                if (Dmonto == null) {
	                    document.form1.chk[counter].disabled = true;
	                }

	                if (!document.form1.chk[counter].disabled) {
	                    document.form1.chk[counter].checked = c.checked;
	                }
	            }
	        }
	    }
	}

	function funcChequea() {
	    var c = document.formUno.chkall;
	    var checked = true;

	    if (document.form1.chk) {
	        if (document.form1.chk.value) {
	            if (!document.form1.chk.disabled) {
	                if (!document.form1.chk.checked) {
	                    checked = false;
	                }
	            }
	        } else {
	            for (var counter = 0; counter < document.form1.chk.length; counter++) {
	                var valores = document.form1.chk[counter].value.split("|");
	                var Dmonto = parseFloat(valores[4]);
	                if (Dmonto != 0) {
	                    document.form1.chk[counter].disabled = true;
	                }
	                if (Dmonto == null) {
	                    document.form1.chk[counter].disabled = true;
	                }
	                if (!document.form1.chk[counter].disabled) {
	                    if (!document.form1.chk[counter].checked) {
	                        checked = false;
	                    }
	                }
	            }
	        }
	    }
	    document.formUno.chkall.checked = checked;
	}
	if (document.form1.chk) {
	    for (var counter = 0; counter < document.form1.chk.length; counter++) {
	        var valores = document.form1.chk[counter].value.split("|");
	        var Dmonto = parseFloat(valores[4]);
	        if (Dmonto != 0) {
	            document.form1.chk[counter].disabled = true;
	        }
	        if (Dmonto == null) {
	            document.form1.chk[counter].disabled = true;
	        }
	    }
	}
</script>
</cfoutput>