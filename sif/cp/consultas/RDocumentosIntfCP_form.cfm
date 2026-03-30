<cfif isdefined("url.FechaIni") and not isdefined("form.FechaIni")>
	<cfset form.FechaIni = url.FechaIni>
</cfif>

<cfif isdefined("url.FechaFin") and not isdefined("form.FechaFin")>
	<cfset form.FechaFin = url.FechaFin>
</cfif>

<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>

<cfif isdefined("url.CPTcodigo") and not isdefined("form.CPTcodigo")>
	<cfset form.CPTcodigo = url.CPTcodigo>
</cfif>


 <script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
 <script language="JavaScript" src="../../js/fechas.js"></script>
 
 <cfinclude  template="RDocumentosIntfCP_sql.cfm">
 
<cfset LB_Socio = t.Translate('LB_Socio','Socio')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha hasta','/sif/generales.xml')>
<cfset Lbl_TpoTrans   = t.Translate('Lbl_TpoTrans','Tipo de Transacci&oacuten')>
<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>

<form name="form1" method="get" action="RDocumentosIntfCP_reporte.cfm">
	<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
		<tr>
			<td align="right"><strong><cfoutput>#LB_Socio#:</cfoutput></strong> </td>
			<td align="left">
				<cfif isdefined('form.SNnumero') and LEN(TRIM(form.SNnumero))>
					<cf_sifsociosnegocios2 Proveedores="SI" tabindex="1" SNcodigo="fSNcodigo" SNnombre="fSNnombre" SNnumero="fSNnumero" idquery="#form.SNcodigo#">
				<cfelse>
					<cf_sifsociosnegocios2 Proveedores="SI" tabindex="1" SNcodigo="fSNcodigo" SNnombre="fSNnombre" SNnumero="fSNnumero">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><strong><cfoutput>#LB_Fecha_Desde#:</cfoutput></strong></td>
			<td>

				<cfif isdefined('form.fechaIni') and LEN(TRIM(form.fechaIni))>
					<cf_sifcalendario name="fechaIni" value="#form.fechaIni#" tabindex="2">
				<cfelse>
					<cfset LvarFecha = createdate(year(now()),month(now()),1)>
					<cf_sifcalendario form="form1" value="#DateFormat(LvarFecha, 'dd/mm/yyyy')#" name="fechaIni" tabindex="2">
				</cfif>

			</td>
		</tr>
		<tr>
			<td align="right"><strong><cfoutput>#LB_Fecha_Hasta#: </cfoutput></strong></td>
			<td>
				<cfif isdefined('form.fechaFin') and LEN(TRIM(form.fechaFin))>
					<cf_sifcalendario name="fechaFin" value="#form.fechaFin#" tabindex="3">
				<cfelse>
					<cf_sifcalendario form="form1" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="fechaFin" tabindex="3">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><strong><cfoutput>#Lbl_TpoTrans#: </cfoutput></strong></td>
			<td>
				<cfoutput>
					<select name="CPTcodigo"  tabindex="4">
						<option value="">#LB_Todos#</option>
						<cfloop query="rsCPTransacciones">
							<option value="#Trim(CPTcodigo)#" <cfif isdefined('form.CPTcodigo') and CPTcodigo EQ TRIM(form.CPTcodigo)>selected</cfif>>
								#CPTdescripcion#</option>
						</cfloop>
					</select>
				</cfoutput>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="center" colspan="2">
				<cf_botones values="Excel,Consultar,Limpiar"  tabindex="1">
			</td>
		</tr>

	</table>
</form>

<cfset MSG_IndCrit = t.Translate('MSG_IndCrit','Debe indicar al menos un criterio.')>
<cfset MSG_FecMayor = t.Translate('MSG_FecMayor','La Fecha Hasta debe ser mayor a la Fecha Desde')>

<script language="javascript" type="text/javascript">
	<cfoutput>
	function funcExcel(){
		document.form1.action            = "RDocumentosIntfCP_Excel.cfm";
		document.form1.submit();
	}

	function funcConsultar(){
		document.form1.action            = "RDocumentosIntfCP_reporte.cfm";
		var f = document.form1;
		if ((f.fSNcodigo.value == '') && (f.fechaIni.value == '') && (f.fechaFin.value == '')
		&& (f.CPTcodigo.value == '') && (f.Documento.value == '')){
				alert('#MSG_IndCrit#');
				return false;
		}
		if (datediff(f.fechaIni.value, f.fechaFin.value) < 0){
			alert ('#MSG_FecMayor#');
			return false;
		}
	}
	</cfoutput>
	function funcLimpiar(){
		var f = document.form1;
		f.fSNnumero.value = '';
		f.fSNcodigo.value = '';
		f.fSNnombre.value = '';
		f.fechaIni.value = '';
		f.fechaFin.value = '';
		f.CPTcodigo.value = '';
		return false;
	}
	document.form1.fSNnumero.focus();
</script>