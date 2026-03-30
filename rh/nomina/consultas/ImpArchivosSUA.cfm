<cf_templateheader title="Reportes Importaci&oacute;n Archivos SUA">
	<cf_web_portlet_start titulo="Reportes Importaci&oacute;n Archivos SUA">
	<br>


	<cfquery name="rsRegistro" datasource="#session.dsn#">
		select <cf_dbfunction name="to_char" args="Pvalor" len="11"> as Pvalor from RHParametros where Ecodigo = #session.Ecodigo# and Pcodigo = 300
	</cfquery>

	<cfset RegistroPatronal1 = #rsRegistro.Pvalor#>

	<cfoutput>
	<form name="form1" action="ImpArchivosSUA-form.cfm" method="post" onsubmit="return validar(this);">
		<table width="60%" cellpadding="2" cellspacing="0" border="0" align="center">
			<tr><td align="right"></td><tr>
			<td align="right"><strong>Fecha Desde:</strong></td>
			<td>
				<cfset FechaDesde = DateFormat(Now(),'dd/mm/yyyy')>
				<cf_sifcalendario form="form1" value="#FechaDesde#" name="FechaDesde" tabindex="1">
			</td>
			<td align="right"><strong>Fecha Hasta:</strong></td>
			<td>
				<cfset FechaHasta = DateFormat(Now(),'dd/mm/yyyy')>
				<cf_sifcalendario form="form1" value="#FechaHasta#" name="FechaHasta" tabindex="1">
			</td>
			<tr>
				<td nowrap align="right"><strong><cf_translate  key="LB_Archivo">Archivo</cf_translate>:&nbsp;</strong></td>
				<td>

					<cfoutput>

						<select name="ArchivoSUA" onchange="javascript: Archivo();">
							<option value="" >-- Seleccione una opci&oacute;n --</option>
							<option value="1" > <cf_translate key="CMB_ArchivosSUA"> Importaci&oacute;n Datos Afiliatorios</cf_translate></option>
							<option value="2" > <cf_translate key="CMB_ArchivosSUA"> Importaci&oacute;n Trabajadores</cf_translate></option>
							<option value="3" > <cf_translate key="CMB_ArchivosSUA"> Importaci&oacute;n de Movimientos</cf_translate></option>
							<option value="4" > <cf_translate key="CMB_ArchivosSUA"> Importaci&oacute;n Datos de Incapacidades</cf_translate>
                            </option>
							<option value="5" > <cf_translate key="CMB_ArchivosSUA"> Importaci&oacute;n Movimientos de Cr&eacute;dito</cf_translate>			                </option>
                            <!--- <option value="6" > <cf_translate key="CMB_ArchivosSUA"> Importaci&oacute;n de Movimientos Bimestrales</cf_translate>
                            </option> --->

						</select>
					</cfoutput>
				</td>


				<td nowrap align="right"><strong>Registro Patronal:&nbsp;</strong></td>
				<td>

					<cfif RegistroPatronal1 eq "">
						<cfquery name="rsRegistro" datasource="#session.dsn#">
							select distinct o.Onumpatronal, o.Ocodigo, o.Oficodigo from oficinas o where o.Ecodigo =
							#session.Ecodigo# and o.Onumpatronal is not null
						</cfquery>
						<cfoutput>
							<select name="RegPat" onchange="Archivo();">
								<option value="" >-- Seleccione una opci&oacute;n --</option>
								<cfloop query="rsRegistro">
								 	<option value="#Onumpatronal#" ><cf_translate key="CMB_RegistrPatronalOficina">#Onumpatronal#</cf_translate></option>
								</cfloop>
							</select>

							<input type="hidden" name="rePatOfi" value="1"> <!--- Esta variable me sirve para validar si el registro patronal es por oficina --->
						</cfoutput>
						<cfelse>
							<cfoutput>
								<select name="RegPat" >
									 <option value="#RegistroPatronal1#" ><cf_translate key="CMB_RegistroPatronalEmpresa">#RegistroPatronal1#</cf_translate></option>
								</select>
								<input type="hidden" name="rePatOfi" value="0">
							</cfoutput>
					</cfif>

				</td>

				<td align="center" colspan="2"><input type="submit" name="Generar" tabindex="1" value="Generar"/></td>
			</tr>
			<tr> <td valign="top"> </td></tr>
        </table>
  	 </form>
    </cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>

<cfoutput>
<script language="javascript1" type="text/javascript">

	//Paso los valores para que no se pierdan en un refresh
	function Archivo (LvarFecha)

		{
			form1.ArchivoSUA.value = document.form1.ArchivoSUA.value;

			form1.RegPat.value = document.form1.RegPat.value

			form1.rePatOfi.value = document.form1.rePatOfi.value

		}

	function fnFechaYYYYMMDD (LvarFecha)
		{
			return LvarFecha.substr(6,4)+LvarFecha.substr(3,2)+LvarFecha.substr(0,2);
		}


	function validar(formulario)
	{
			var error_input;
			var error_msg = '';

		if (fnFechaYYYYMMDD(document.form1.FechaDesde.value) > fnFechaYYYYMMDD(document.form1.FechaHasta.value)
		& fnFechaYYYYMMDD(document.form1.FechaHasta.value) != '')
		{
			alert ("La Fecha Hasta no puede ser menor a la Fecha Desde");
			return false;
		}
		else if(form1.ArchivoSUA.value  == '')
		{
			alert ("Debe elegir un tipo de reporte");
			return false;
		}
		else if(form1.RegPat.value == '')
		{
			alert ("Debe elegir un Registro Patronal");
			return false;
		}
		else if(form1.FechaDesde.value == '')
		{
			alert ("Debe seleccionar un fecha Desde");
			return false;
		}
		else if(form1.FechaHasta.value == '')
		{
			alert ("Debe seleccionar un fecha Hasta");
			return false;
		}
		else
		{
			return true;
		}

	}

</script>
</cfoutput>