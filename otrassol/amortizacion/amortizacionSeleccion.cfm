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
	 and CPTestimacion = 0
</cfquery>
<cfif isdefined('form.SNNUMERO') and LEN(TRIM(form.SNNUMERO))>
	<cfquery name="rsSocio" datasource="#session.DSN#">
		select *
		from SNegocios
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and SNnumero = <cfqueryparam cfsqltype="cf_sql_char" value="#form.SNnumero#">
	</cfquery>
</cfif>

<form name="form1" method="get" action="amortizacionForm.cfm">
	<table width="100%" border="0" cellpadding="1" cellspacing="1" align="center">
		<tr>
			<td align="right"><strong>Socio:</strong> </td>
			<td align="left">
				<cfif isdefined('form.SNnumero') and LEN(TRIM(form.SNnumero))>
					<cf_sifsociosnegocios2 tabindex="1" SNcodigo="fSNcodigo" SNnombre="fSNnombre" SNnumero="fSNnumero" idquery="#form.SNcodigo#">
				<cfelse>
					<cf_sifsociosnegocios2 tabindex="1" SNcodigo="fSNcodigo" SNnombre="fSNnombre" SNnumero="fSNnumero">
				</cfif>
			</td>
		</tr>  
		<tr>
			<td align="right"><strong>Fecha desde:</strong></td>
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
			<td align="right"><strong>Fecha hasta: </strong></td>    
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
			<td align="right"><strong>Tipo de Transacci&oacute;n: </strong></td>
			<td>
				<cfoutput>
					<select name="CPTcodigo"  tabindex="1">
						<option value="">Todos</option>
						<cfloop query="rsCPTransacciones">
							<option value="#Trim(CPTcodigo)#" <cfif isdefined('form.CPTcodigo') and CPTcodigo EQ TRIM(form.CPTcodigo)>selected</cfif>>
								#CPTdescripcion#</option>
						</cfloop>
					</select>
				</cfoutput>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>Documento:</strong></td>
			<td>
				<cfoutput>
					<input name="Documento"  tabindex="1" id="Documento" type="text" size="40" value="<cfif isdefined('form.Documento')>#form.Documento#</cfif>"  >
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

<script language="javascript" type="text/javascript">
	function funcConsultar(){ 
		var f = document.form1;
		if ((f.fSNcodigo.value == '') && (f.fechaIni.value == '') && (f.fechaFin.value == '') 
		&& (f.CPTcodigo.value == '') && (f.Documento.value == '')){		
				alert('Debe indicar al menos un criterio.');
				return false;
		}
		if (datediff(f.fechaIni.value, f.fechaFin.value) < 0){	
			alert ('La Fecha Hasta debe ser mayor a la Fecha Desde');
			return false;
		} 
	}
	
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


