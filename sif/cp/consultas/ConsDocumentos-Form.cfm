 <cfif isdefined("url.FechaIni") and not isdefined("form.FechaIni")>
	<cfset form.FechaIni = url.FechaIni>
</cfif>
<cfif isdefined("url.FechaFin") and not isdefined("form.FechaFin")>
	<cfset form.FechaFin = url.FechaFin>
</cfif>

<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfset form.SNcodigo = url.SNcodigo>
</cfif>

<cfif isdefined("url.CCTcodigo") and not isdefined("form.CCTcodigo")>
	<cfset form.CCTcodigo = url.CCTcodigo>
</cfif>

<cfif isdefined("url.Documento") and not isdefined("form.Documento")>
	<cfset form.Documento= url.Documento>
</cfif>

 <script language="JavaScript1.2" src="/cfmx/sif/js/utilesMonto.js"></script>
 <script language="JavaScript" src="../../js/fechas.js"></script>

<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset Lbl_DesdeSN 	= t.Translate('Lbl_DesdeSN','Desde Socio Negocio')>
<cfset Lbl_HastaSN 	= t.Translate('Lbl_HastaSN','Hasta Socio Negocio')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha hasta','/sif/generales.xml')>
<cfset Lbl_TipoDoc 	= t.Translate('Lbl_TipoDoc','Tipo Documento')>
<cfset LB_Todos 	= t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset Lbl_Cesion 	= t.Translate('Lbl_Cesion','Cesión')>
<cfset Lbl_Multa 	= t.Translate('Lbl_Multa','Multa')>
<cfset Lbl_Embargo 	= t.Translate('Lbl_Embargo','Embargo')>
<cfset Msg_IndSN 	= t.Translate('Msg_IndSN','Debe indicar al menos un Socio de Negocio.')>
<cfset Msg_ValFec 	= t.Translate('Msg_ValFec','La Fecha Hasta debe ser mayor a la Fecha Desde.')>

<form name="form1" method="post" action="ConsDocumentos-reporte.cfm">
<cfoutput>
	<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
		<tr>
			<td align="right"><strong>#Lbl_DesdeSN#:</strong> </td>
			<td align="left">
				<cfif isdefined('form.SNnumero') and LEN(TRIM(form.SNnumero))>
					<cf_sifsociosnegocios2 Proveedores="SI" tabindex="1" SNcodigo="fSNcodigo" SNnombre="fSNnombre" SNnumero="fSNnumero" idquery="#form.SNcodigo#">
				<cfelse>
					<cf_sifsociosnegocios2 Proveedores="SI" tabindex="1" SNcodigo="fSNcodigo" SNnombre="fSNnombre" SNnumero="fSNnumero">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>#Lbl_HastaSN#:</strong> </td>
			<td align="left">
				<cfif isdefined('form.SNnumero2') and LEN(TRIM(form.SNnumero2))>
					<cf_sifsociosnegocios2 Proveedores="SI" tabindex="1" SNcodigo="fSNcodigo2" SNnombre="fSNnombre2" SNnumero="fSNnumero2" idquery="#form.SNcodigo2#">
				<cfelse>
					<cf_sifsociosnegocios2 Proveedores="SI" tabindex="1" SNcodigo="fSNcodigo2" SNnombre="fSNnombre2" SNnumero="fSNnumero2">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_Fecha_Desde#:</strong></td>
			<td>

				<cfif isdefined('form.fechaIni') and LEN(TRIM(form.fechaIni))>
					<!--- <cf_sifcalendario name="fechaIni" value="#LSDateFormat(form.fechaIni,'dd/mm/yyyy')#"> --->
					<cf_sifcalendario name="fechaIni" value="#form.fechaIni#">
				<cfelse>
					<cfset LvarFecha = createdate(year(now()),month(now()),1)>
					<cf_sifcalendario form="form1" value="#DateFormat(LvarFecha, 'dd/mm/yyyy')#" name="fechaIni" tabindex="1">
				</cfif>

			</td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_Fecha_Hasta#: </strong></td>
			<td>
				<cfif isdefined('form.fechaFin') and LEN(TRIM(form.fechaFin))>
					<!--- <cf_sifcalendario name="fechaFin" value="#LSDateFormat(form.fechaFin,'dd/mm/yyyy')#"> --->
					<cf_sifcalendario name="fechaFin" value="#form.fechaFin#">
				<cfelse>
					<cf_sifcalendario form="form1" value="#DateFormat(Now(),'dd/mm/yyyy')#" name="fechaFin" tabindex="1">
				</cfif>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>#Lbl_TipoDoc#: </strong></td>
			<td>
			    <select name="TipoDoc"  tabindex="1">
						<option value="">#LB_Todos#</option>
						<option value="C">#Lbl_Cesion#</option>
						<option value="M">#Lbl_Multa#</option>
						<option value="E">#Lbl_Embargo#</option>
				</select>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="center" colspan="2">
				<cf_botones values="Consultar,Limpiar"  tabindex="1">
			</td>
		</tr>
	</table>
</cfoutput>
</form>
<cfoutput>
<script language="javascript" type="text/javascript">
	function funcConsultar(){
	var f = document.form1;
	   	if ((f.fSNcodigo.value == '') && (f.fSNcodigo2.value == ''))
		{		alert('#Msg_IndSN#');
				return false;
		}
		if (datediff(f.fechaIni.value, f.fechaFin.value) < 0){
			alert ('#Msg_ValFec#');
			return false;
		}
	}
</script>
</cfoutput>

