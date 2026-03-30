<!---
	Creado por Gustavo Fonseca H.
		Fecha: 23-12-2005.
		Motivo: Nueva consulta de documentos para CxP.
 --->

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
<!---Consultas para pintar el formulario--->
<!---Categorias--->
<cfquery name="rsCPTransacciones" datasource="#Session.DSN#">
	 select CPTcodigo, CPTdescripcion
	 from CPTransacciones
	 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif isdefined('form.SNNUMERO') and LEN(TRIM(form.SNNUMERO))>
	<cfquery name="rsSocio" datasource="#session.DSN#">
		select *
		from SNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
	</cfquery>
</cfif>

<cfset LB_Socio = t.Translate('LB_Socio','Socio')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha hasta','/sif/generales.xml')>
<cfset Lbl_TpoTrans   = t.Translate('Lbl_TpoTrans','Tipo de Transaccion')>
<cfset LB_DocSaldo 	= t.Translate('LB_DocSaldo','Documentos con Saldo')>
<cfset LB_Documento = t.Translate('LB_Documento','Documento')>
<cfset LB_Todos = t.Translate('LB_Todos','Todos','/sif/generales.xml')>
<cfset LB_Timbre = t.Translate('LB_Timbre','Timbre')>
<cfset LB_TimbreS = t.Translate('LB_TimbreS','Sin Timbre Fiscal')>
<cfset LB_TimbreC = t.Translate('LB_TimbreC','Con Timbre Fiscal')>
<cfset LB_TimbreA = t.Translate('LB_TimbreA','Todos')>


<form name="form1" method="get" action="RFacturasCP2-reporte.cfm">
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
					<!--- <cf_sifcalendario name="fechaIni" value="#LSDateFormat(form.fechaIni,'dd/mm/yyyy')#"> --->
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
					<!--- <cf_sifcalendario name="fechaFin" value="#LSDateFormat(form.fechaFin,'dd/mm/yyyy')#"> --->
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
		<tr>
			<td align="right"><input type="checkbox" name="chk_DocSaldo" <cfif isdefined('form.chk_DocSaldo')>checked</cfif>   value="1" tabindex="5">&nbsp;</td>
			<td colspan="1" align="left">
				<strong><cfoutput>#LB_DocSaldo#</cfoutput></strong>
			</td>
		</tr>
		<tr>
			<td align="right"><strong><cfoutput>#LB_Timbre#: </cfoutput></strong></td>
			<td>
				<cfoutput>
					<select name="FTimbre"  tabindex="6">
						<option value="0" <cfif isdefined('form.FTimbre') and form.FTimbre EQ 0>selected</cfif>>#LB_TimbreA#</option>
						<option value="1" <cfif isdefined('form.FTimbre') and form.FTimbre EQ 1>selected</cfif>>#LB_TimbreS#</option>
						<option value="2" <cfif isdefined('form.FTimbre') and form.FTimbre EQ 2>selected</cfif>>#LB_TimbreC#</option>
					</select>
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td align="right"><strong><cfoutput>#LB_Documento#:</cfoutput></strong></td>
			<td>
				<cfoutput>
					<input name="Documento"  tabindex="7" id="Documento" type="text" size="40" value="<cfif isdefined('form.Documento')>#form.Documento#</cfif>"  >
				</cfoutput>
			</td>
		</tr>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td align="center" colspan="2">
				<cf_botones values="Consultar,Limpiar"  tabindex="1">
			</td>
		</tr>

	</table>
</form>

<cfset MSG_IndCrit = t.Translate('MSG_IndCrit','Debe indicar al menos un criterio.')>
<cfset MSG_FecMayor = t.Translate('MSG_FecMayor','La Fecha Hasta debe ser mayor a la Fecha Desde')>

<script language="javascript" type="text/javascript">
	<cfoutput>
	function funcConsultar(){
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
		f.Documento.value = '';
		return false;
	}
	document.form1.fSNnumero.focus();
</script>


