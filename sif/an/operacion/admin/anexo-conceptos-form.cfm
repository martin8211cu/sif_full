<!--- Configuración de Parámetros --->
<cfset modo="ALTA">
<cfif not isdefined("Form.modo") and isdefined("url.modo")>
	<cfset modo=url.modo>
</cfif>
<cfif not isdefined("Form.Cconcepto") and isdefined("url.Cconcepto")>
	<cfset Form.Cconcepto=url.Cconcepto>
</cfif>
<cfif isdefined("url.AnexoId") and not isdefined("form.AnexoId")>
	<cfset form.AnexoId = url.AnexoId>
</cfif>
<cfif isdefined("url.AnexoCelId") and not isdefined("form.AnexoCelId")>
	<cfset form.AnexoCelId = url.AnexoCelId>
</cfif>
<script language="javascript" src="../../js/utilesMonto.js"></script>

<!--- Consultas --->
<cfquery name="rsEmpresa" datasource="#Session.DSN#">
 	select * from Empresa
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#"> 
	order by Enombre
</cfquery>

<cfquery name="rsConcepto" datasource="#Session.DSN#">
	select *
	from ConceptoContableE
	order by Cdescripcion
</cfquery>

<form method="post" name="form2" action="anexo-conceptos-sql.cfm" onSubmit="return fnValidar()">
	<cfoutput>
	<table align="center" width="100%" cellpadding="0" cellspacing="0">
		<tr valign="baseline"> 
			<td width="31%" align="right" nowrap>Empresa:</td>
			<td width="69%">
				<select name="Ecodigo" id="Ecodigo" onChange="javascript:fnCambiarConcepto();">
					<cfloop query="rsEmpresa">
						<cfif isDefined("form.Ecodigo") and len(trim(form.Ecodigo)) and form.Ecodigo eq #rsEmpresa.Ecodigo#>
							<option value="#rsEmpresa.Ereferencia#" selected>#rsEmpresa.Enombre#</option>
						<cfelse>
							<option value="#rsEmpresa.Ereferencia#">#rsEmpresa.Enombre#</option>
						</cfif>						
					</cfloop>
				</select>
			</td>
		</tr>
		<tr valign="baseline"> 
			<td nowrap align="right">Concepto:</td>
			<td>
				<select name="Cconcepto" id="Cconcepto">
				</select>
			</td>
		</tr>
		<tr>
			<td nowrap align="right">&nbsp;</td>
			<td><cf_botones modo=#modo#></td>
			<input type="hidden" name="modo" value="#modo#">
			<input type="hidden" name="AnexoId" value="#form.AnexoId#">
			<input type="hidden" name="AnexoCelId" value="#form.AnexoCelId#">
		</tr>
	</table>
	</cfoutput>
</form>

<script language="javascript" type="text/javascript">
	function fnCambiarConcepto()
	{
		var oConcepto = document.form2.Cconcepto;		
		var oEmpresa = document.form2.Ecodigo.value;
		var cont = 0;
		oConcepto.length=0;
		<cfoutput query="rsConcepto">
			if (#trim(rsConcepto.Ecodigo)# == oEmpresa) {
				oConcepto.length=cont+1;
				oConcepto.options[cont].value='#Trim(rsConcepto.Cconcepto)#';
				oConcepto.options[cont].text='#Trim(rsConcepto.Cdescripcion)#';
				cont++;
			}
		</cfoutput>
	}
	
	function fnValidar() {
		var concepto = document.form2.Cconcepto.value;
		if (concepto != '') {
			return true;
		} else {
			alert('Debe de digitar un concepto.');
			return false;
		}
	}
	
	function funcLimpiar() {
		var oConcepto = document.form2.Cconcepto;
		oConcepto.length=0;
	}	
</script>

<script language="javascript" type="text/javascript">
	fnCambiarConcepto();
</script>
