<!--- PARAMS --->
<cfparam name="form.CPPid" default="">
<cfparam name="form.CtaPres" default="">
<cfparam name="form.mesDesde" default="">
<cfparam name="form.mesHasta" default="12">
<cfparam name="form.soloDiferencias" default="1">
<cfif isdefined("url.CtaPres")>
	<cfset form.CtaPres=url.CtaPres>
</cfif>
<cfif isdefined("url.CPPid")>
	<cfset form.CPPid=url.CPPid>
</cfif>
<cfif isdefined("url.mesDesde")>
	<cfset form.mesDesde=url.mesDesde>
</cfif>
<cfif isdefined("url.mesHasta")>
	<!--- <cfdump var="#url.mesHasta#"> --->
	<cfset form.mesHasta=url.mesHasta>
</cfif>
<cfif isdefined("url.soloDiferencias")>
	<cfset form.soloDiferencias=url.soloDiferencias>
</cfif>

<!--- QUERYS --->
<!--- QUERY MODULOS --->
<cfquery name="rsModulos" datasource="#Session.DSN#">
	select Oorigen, Odescripcion from Origenes
</cfquery>

<cf_templateheader title="Conciliaci&oacute;n NAPs vs Saldos">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
	<cf_web_portlet_start titulo="Conciliaci&oacute;n NAPs vs Saldos">
		<form name="form1" style="margin:0;" method="post" action="rptConciliacion-print.cfm" onSubmit="return sbSubmit();">
			<table width="100%" align="center" cellpadding="0" cellspacing="0" border="0" class="areaFiltro">
				<tr><td>&nbsp;</td></tr>
				<!--- FILA UNO --->
				<tr>
					<!--- PERIODO --->
					<td nowrap align="right">
						<strong>Per&iacute;odo presupuestal:</strong>&nbsp;
					</td>
					<td colspan="3">						
						<cf_cboCPPid incluirTodos="true" value="#form.CPPid#" CPPestado="1,2">
						<!--- <cfset session.CPPid2 = form.CPPid> --->
					</td>
				</tr>   
			
				<!--- FILA DOS --->
				<tr>
					<!--- CUENTA --->
					<td align="right">
						<strong>Cuenta:</strong>&nbsp;
					</td>

					<td colspan="3">
						<cf_CuentaPresupuesto name="CtaPres" value="#form.CtaPres#" size="50">
					</td>		
				</tr>  
				<!--- FILA TRES --->
				<tr>
					<!--- MES DESDE --->
					<td nowrap align="right" width="220">
						<strong>Mes desde:</strong>&nbsp;
					</td>
					<td width="50">
						<cf_meses name="mesDesde" value="#form.mesDesde#"> 
					</td>
					<!--- MES HASTA --->
					<td nowrap align="right" width="60">
						<strong>Mes hasta:</strong>&nbsp;
					</td>
					<td width="220">
						<cf_meses name="mesHasta" value="#form.mesHasta#"> 
					</td>
				</tr>
				<tr>
					<!--- MES DESDE --->
					<td nowrap align="right">
						<strong>Solo mostrar diferencias:</strong>&nbsp;
					</td>
					<td>
						<cfif isdefined("form.soloDiferencias") AND #form.soloDiferencias# EQ "1">
							<input type="checkbox" name="soloDiferencias" id="soloDiferencias" value="1" checked/>
						<cfelse>
							<input type="checkbox" name="soloDiferencias" id="soloDiferencias" value="1"/>
						</cfif>
						
					</td>
				</tr>
				<tr>
					<td colspan="4 " align="center">
						<input name="btnFiltrar" type="button" onclick="validateData()" value="Imprimir">
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</form>		
	<cf_web_portlet_end>
<cf_templatefooter>


<script>
	function validateData()
	{
		var periodo = document.getElementById("CPPid")
		if(periodo.value == '-1'){
			alert('Favor de seleccionar un periodo presupuestal')
			periodo.focus()
		}else{
			document.form1.submit();
		}
	}
</script>
