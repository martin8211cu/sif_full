
<cfinvoke component="sif.Componentes.translate" method="Translate" key = "Visible1" default = "none" returnvariable="Visible1" xmlfile = "/sif/TagsSIF/sifdireccion.xml">
<cfinvoke component="sif.Componentes.translate" method="Translate" key = "Visible2" default = "none" returnvariable="Visible2" xmlfile = "/sif/TagsSIF/sifdireccion.xml">
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select
		Edescripcion,
		ETelefono1,
		ETelefono2,
		EDireccion1,
		EDireccion2,
		EDireccion3,
		EIdentificacion,
		Calle,
		NumExt,
		NumInt,
		Colonia,
		Referencia,
		Localidad,
		Delegacion,
		DirecFisc,
		Estado,
		Pais,
		CodPostal
	from Empresas
	where Ecodigo = #form.Ecodigos#
</cfquery>
<script type="text/javascript">
	function mostrarOcultar(obj){
			document.getElementById("trCalle").style.display = (obj.checked) ? 'table-row' : 'none';
			document.getElementById("trNumeros").style.display = (obj.checked) ? 'table-row' : 'none';
			document.getElementById("trColonia").style.display = (obj.checked) ? 'table-row' : 'none';
			document.getElementById("trLocalidad").style.display = (obj.checked) ? 'table-row' : 'none';
			document.getElementById("trReferencia").style.display = (obj.checked) ? 'table-row' : 'none';
			document.getElementById("trDelegacion").style.display = (obj.checked) ? 'table-row' : 'none';
			document.getElementById("trEstado").style.display = (obj.checked) ? 'table-row' : 'none';
			document.getElementById("trPais").style.display = (obj.checked) ? 'table-row' : 'none';
			document.getElementById("trCodPost").style.display = (obj.checked) ? 'table-row' : 'none';
			document.getElementById("trDireccion1").style.display = (obj.checked) ? 'none' : 'table-row';
			document.getElementById("trDireccion2").style.display = (obj.checked) ? 'none' : 'table-row';
			document.getElementById("trDireccion3").style.display = (obj.checked) ? 'none' : 'table-row';
		}

function validarDGenerales(form){
		if (form.SNDirFisc.checked){
			socios_validateForm(form,'Calle','','R','NumExt','','R','Colonia','','R','Delegacion','','R','Estado','','R','Pais','','R','CodPostal','','R');
			}
	return document.MM_returnValue
}
</script>
<cfoutput>
	<cfif rsEmpresa.DirecFisc eq 1>
		<cfset Visible1 = 'table-row'>
		<cfset Visible2 = 'none'>
	<cfelse>
		<cfset Visible1 = 'none'>
		<cfset Visible2 = 'table-row'>
	</cfif>
	<table cellpadding="0" cellspacing="2" border="0">
		<form name="form2" action="DatosEmpresas_SQL.cfm" method="post" onSubmit="return validarDGenerales(this);">
			<input name="Ecodigo" type="hidden" value="#form.Ecodigos#" />
			<tr>
				<td colspan="2" align="center" style="font-size:20px;">
					#rsEmpresa.Edescripcion#
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td align="Right"><input name="SNDirFisc" type="checkbox" tabindex="1" id="SNDirFisc" <cfif rsEmpresa.DirecFisc eq 1>checked</cfif> onclick = "mostrarOcultar(this)" ></td>
				<td>Direcci&oacute;n Fiscal</td>
			</tr>
			<tr id="trCalle" style="Display:#Visible1#">
				<td align="right">Calle:&nbsp;</td>
				<td>
					<input type="text" name="Calle" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.Calle))>#rsEmpresa.Calle#</cfif>" maxlength="50" size="55"  />
				</td>
			</tr>
			<tr id="trNumeros" style="Display:#Visible1#">
				<td align="right">Num Ext:&nbsp;</td>
				<td>
					<input type="text" name="NumExt" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.NumExt))>#rsEmpresa.NumExt#</cfif>" maxlength="30" size="20" />
					Num Int:
					<input type="text" name="NumInt" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.NumInt))>#rsEmpresa.NumInt#</cfif>" maxlength="30" size="20" />
				</td>
			</tr>
			<tr id="trColonia" style="Display:#Visible1#">
				<td align="right">Colonia:&nbsp;</td>
				<td>
					<input type="text" name="Colonia" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.Colonia))>#rsEmpresa.Colonia#</cfif>" maxlength="50" size="55"  />
				</td>
			</tr>
			<tr id="trReferencia" style="Display:#Visible1#">
				<td align="right">Referencia:&nbsp;</td>
				<td>
					<input type="text" name="Referencia" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.Referencia))>#rsEmpresa.Referencia#</cfif>" maxlength="50" size="55"  />
				</td>
			</tr>
			<tr id="trLocalidad" style="Display:#Visible1#">
				<td align="right">Localidad:&nbsp;</td>
				<td>
					<input type="text" name="Localidad" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.Localidad))>#rsEmpresa.Localidad#</cfif>" maxlength="50" size="55"  />
				</td>
			</tr>
			<tr id="trDelegacion" style="Display:#Visible1#">
				<td align="right">Delegacion:&nbsp;</td>
				<td>
					<input type="text" name="Delegacion" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.Delegacion))>#rsEmpresa.Delegacion#</cfif>" maxlength="50" size="55"  />
				</td>
			</tr>
			<tr id="trEstado" style="Display:#Visible1#">
				<td align="right">Estado:&nbsp;</td>
				<td>
					<input type="text" name="Estado" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.Estado))>#rsEmpresa.Estado#</cfif>" maxlength="50" size="55"  />
				</td>
			</tr>
			<tr id="trPais" style="Display:#Visible1#">
				<td align="right">Pais:&nbsp;</td>
				<td>
					<input type="text" name="Pais" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.Pais))>#rsEmpresa.Pais#</cfif>" maxlength="50" size="55"  />
				</td>
			</tr>
			<tr id="trCodPost" style="Display:#Visible1#">
				<td align="right">Codigo Postal:&nbsp;</td>
				<td>
					<input type="text" name="CodPostal" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.CodPostal))>#rsEmpresa.CodPostal#</cfif>" maxlength="50" size="55"  />
				</td>
			</tr>
			<tr>
				<td align="right">Tel&eacute;fono 1:&nbsp;</td>
				<td>
					<input type="text" name="ETelefono1" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.ETelefono1))>#rsEmpresa.ETelefono1#</cfif>" maxlength="256" size="70"  />
				</td>
			</tr>
			<tr>
				<td align="right">Tel&eacute;fono 2:&nbsp;</td>
				<td>
					<input type="text" name="ETelefono2" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.ETelefono2))>#rsEmpresa.ETelefono2#</cfif>" maxlength="256" size="70" />
				</td>
			</tr>
			<tr id="trDireccion1" style="Display:#Visible2#">
				<td align="right">Direcci&oacute;n 1:&nbsp;</td>
				<td>
					<input type="text" name="EDireccion1" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.EDireccion1))>#rsEmpresa.EDireccion1#</cfif>" maxlength="256" size="70" />
				</td>
			</tr>
			<tr id="trDireccion2" style="Display:#Visible2#">
				<td align="right">Direcci&oacute;n 2:&nbsp;</td>
				<td>
					<input type="text" name="EDireccion2" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.EDireccion2))>#rsEmpresa.EDireccion2#</cfif>" maxlength="256" size="70" />
				</td>
			</tr>
			<tr id="trDireccion3" style="Display:#Visible2#">
				<td align="right">Direcci&oacute;n 3:&nbsp;</td>
				<td>
					<input type="text" name="EDireccion3" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.EDireccion3))>#rsEmpresa.EDireccion3#</cfif>" maxlength="256" size="70" />
				</td>
			</tr>
			<tr>
				<td align="right">Identificaci&oacute;n:&nbsp;</td>
				<td>
					<input type="text" name="EIdentificacion" value="<cfif isdefined("rsEmpresa") and len(trim(rsEmpresa.EIdentificacion))>#rsEmpresa.EIdentificacion#</cfif>" maxlength="256" size="70" />
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
			<tr>
				<td colspan="2"><cf_botones values='Modificar'></td>
			</tr>
		</form>
	</table>
</cfoutput>