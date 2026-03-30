<form name="formRepDonacRecibEntidad" method="post" action="DonacionesRecibEntidadPlan.cfm" style="margin: 0" onSubmit="return validar(this);">
<table width="100%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro">
  <tr>
    <td width="52%"><strong>Entidad</strong></td>
    <td width="21%"><strong>Fecha de Inicio</strong></td>
    <td width="19%"><strong>Fecha Final</strong></td>
    <td width="8%" rowspan="2"><input name="btnConsultar" type="submit" id="btnConsultar" value="Consultar"></td>
  </tr>
  <tr>
    <td>
		<cfif isdefined('form.CRMEid_filtro') and form.CRMEid_filtro NEQ '' and isdefined('form.CRMnombre_filtro') and form.CRMnombre_filtro NEQ ''>
			<cfquery name="filtro_rsEnt" datasource="#session.DSN#">
				select 	CRMEid = #form.CRMEid_filtro#,
						CRMEnombre = '#form.CRMnombre_filtro#',
						CRMEapellido1 = '',
						CRMEapellido2 = ''				
			</cfquery>
			<cfif isdefined('filtro_rsEnt') and filtro_rsEnt.recordCount GT 0>
				<cf_crmEntidad 
					crmeid="CRMEid_filtro" 
					crmnombre="CRMnombre_filtro" 
					conexion="#session.DSN#" 
					form="formRepDonacRecibEntidad"
					Pdona="S"
					size="50"
					query="#filtro_rsEnt#">				
			</cfif>
		<cfelse>
			<cf_crmEntidad 
				crmeid="CRMEid_filtro" 
				crmnombre="CRMnombre_filtro" 
				conexion="#session.DSN#" 
				form="formRepDonacRecibEntidad"
				Pdona="S"
				size="50">			
		</cfif>	
	</td>
    <td>
		<cfif isdefined('form.fechaini_filtro') and form.fechaini_filtro NEQ "">
			<cf_sifcalendario form="formRepDonacRecibEntidad" name="fechaini_filtro" value="#form.fechaini_filtro#">
		<cfelse>
			<cf_sifcalendario form="formRepDonacRecibEntidad" name="fechaini_filtro">
		</cfif>	
	</td>
    <td>
		<cfif isdefined('form.fechafin_filtro') and form.fechafin_filtro NEQ "">
			<cf_sifcalendario form="formRepDonacRecibEntidad" name="fechafin_filtro" value="#form.fechafin_filtro#">
		<cfelse>
			<cf_sifcalendario form="formRepDonacRecibEntidad" name="fechafin_filtro">
		</cfif>	
	</td>
  </tr> 
</table>
</form>

<!--- Javascript --->
<SCRIPT language="JavaScript" type="text/javascript" SRC="../../js/crmUtiles.js"></SCRIPT>
<SCRIPT SRC="../../../js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	function validar(f){
		if (f.obj.fechaini_filtro.value != '' && f.obj.fechafin_filtro.value != ''){
			if(comparaFechas(f.obj.fechaini_filtro.value,f.obj.fechafin_filtro.value,2)){
				alert('Error, la fecha de inicio es mayor que la fecha final');
				
				return false;
			}
		}
		
		return true;
	}
	
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formRepDonacRecibEntidad");

	objForm.CRMEid_filtro.required = true;
	objForm.CRMEid_filtro.description="Entidad";
</script>