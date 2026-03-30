<cf_templateheader title="Reportes Importaci&oacute;n Archivos IDSE">
<cf_web_portlet_start titulo="Reportes Importaci&oacute;n Archivos IDSE">
<br>
<cfoutput>
	<cfquery name="rsRegistro" datasource="#session.dsn#">
		select <cf_dbfunction name="to_char" args="Pvalor" len="11"> as Pvalor from RHParametros where Ecodigo = #session.Ecodigo# and Pcodigo = 300
	</cfquery>
	<cfset RegistroPatronal1 = #rsRegistro.Pvalor#>
	<form name="form1" action="ImpArchivoIDSE-form.cfm" method="post" onsubmit="return validar(this);">
		<table width="65%" cellpadding="2" cellspacing="0" border="0" align="center">
			<tr>
				<td align="right">
				</td>
			<tr>
				<td align="right">
					<strong>
						Fecha Desde:
					</strong>
				</td>
				<td>
					<cfset FechaDesde = DateFormat(Now(),'dd/mm/yyyy')>
					<cf_sifcalendario form="form1" value="#FechaDesde#" name="FechaDesde" tabindex="1">
				</td>
				<td align="right">
					<strong>
						Fecha Hasta:
					</strong>
				</td>
				<td>
					<cfset FechaHasta = DateFormat(Now(),'dd/mm/yyyy')>
					<cf_sifcalendario form="form1" value="#FechaHasta#" name="FechaHasta" tabindex="1">
				</td>
			<tr>
			<tr>
				<td nowrap align="right">
					<strong>
						Registro Patronal:&nbsp;
					</strong>
				</td>
				<td>
					<cfif RegistroPatronal1 eq "">
						<cfquery name="rsRegistro" datasource="#session.dsn#">
										select o.Ocodigo, o.Oficodigo, o.Onumpatronal from oficinas o where o.Ecodigo = #session.Ecodigo# and o.Onumpatronal is not null
									</cfquery>
						<cfoutput>
							<select name="RegPat" onchange="Archivo();">
								<option value="" >
									-- Seleccione una opci&oacute;n --
								</option>
								<cfloop query="rsRegistro">
									<option value="#Onumpatronal#" >
										<cf_translate key="CMB_RegistrPatronalOficina">
											#Onumpatronal#
										</cf_translate>
									</option>
								</cfloop>
							</select>
							<input type="hidden" name="rePatOfi" value="1">
							<!--- Esta variable me sirve para validar si el registro patronal es por oficina --->
						</cfoutput>
					<cfelse>
						<cfoutput>
							<select name="RegPat" >
								<option value="#RegistroPatronal1#" >
									<cf_translate key="CMB_RegistroPatronalEmpresa">
										#RegistroPatronal1#
									</cf_translate>
								</option>
							</select>
							<input type="hidden" name="rePatOfi" value="0">
						</cfoutput>
					</cfif>
				</td>
				<td nowrap align="right">
					<strong>
						<cf_translate  key="LB_Archivo">
							Archivo
						</cf_translate>
						:&nbsp;
					</strong>
				</td>
				<td>
					<cfoutput>
						<select name="ArchivoIDSE" id="ArchivoIDSE" onchange="javascript: Archivo();">
							<option value="" >
								-- Seleccione una opci&oacute;n --
							</option>
							<option value="1" >
								Importaci&oacute;n Movimientos Reingreso
							</option>
							<option value="2" >
								Importaci&oacute;n Modificaci&oacute;n Salarial
							</option>
							<option value="3" >
								Importaci&oacute;n Movimientos Bajas
							</option>
							<!--- <option value="2" >
								Importaci&oacute;n Movimientos Ausentismos
							</option>
							<option value="3" >
								Importaci&oacute;n Movimientos Incapacidades
							</option> --->
						</select>
					</cfoutput>
				</td>
				<!---
					fuente:
						0 indefinido
						1 Automatico (Proceso interno que afecte SDI) ej. Accion de Nombramiento (Comportamiento = 1)
						2 Manual (SDI Bimestral)
						3 SDI por Aniversario
						4 Accion de Aumento (comportamiento = 6)
				 --->
				<td id="tipoCambioS" name="tipoCambioS">
					<select name="tipoCambioS" id="tipoCambioS">
						<option value="3">MSA - Aniversario</option>
						<option value="4">MSF - Fija</option>
						<option value="2">MSV - Variable</option>
					</select>
				</td>
			</tr>
			<td align="center" colspan="4">
				<input type="submit" name="Generar" tabindex="1"value="Generar"/>
			</td>
			</tr>
			<tr>
				<td valign="top">
				</td>
			</tr>
		</table>
	</form>
</cfoutput>
<cf_web_portlet_end>
<cf_templatefooter>
<cfoutput>
<script language="javascript1" type="text/javascript">
	Archivo();
	function Archivo (LvarFecha)
	{
		var tipoRep = document.getElementById("ArchivoIDSE");
		var optSel  = tipoRep.options[tipoRep.selectedIndex].value;
		if(optSel != 2)
		{
	    	document.getElementById('tipoCambioS').style.display = 'none';
		}
		else
		{
			document.getElementById('tipoCambioS').style.display = 'block';
		}
		form1.ArchivoSUA.value = document.form1.ArchivoSUA.value;
	}

	function fnFechaYYYYMMDD (LvarFecha)
		{
			return LvarFecha.substr(6,4)+LvarFecha.substr(3,2)+LvarFecha.substr(0,2);
		}

	function validar(formulario)
	{
		var error_input;
		var error_msg = '';

		if(document.form1.FechaDesde.value != '' &&
			document.form1.FechaHasta.value != '' &&
			document.form1.RegPat.value != "" &&
			document.form1.ArchivoIDSE.value != ""){

			//if (fnFechaYYYYMMDD(document.form1.FechaDesde.value) > fnFechaYYYYMMDD(document.form1.FechaHasta.value)
//				& fnFechaYYYYMMDD(document.form1.FechaHasta.value) != '')
//			{
			if (fnFechaYYYYMMDD(document.form1.FechaDesde.value) > fnFechaYYYYMMDD(document.form1.FechaHasta.value))
			{
				alert ("La Fecha Hasta no puede ser menor a la Fecha Desde");
				return false;
			}
			else
			{
				return true;
			}
		}else{
			alert("Es necesario llenar todos los campos del formulario");
			return false;
		}

	}

</script>
</cfoutput>
