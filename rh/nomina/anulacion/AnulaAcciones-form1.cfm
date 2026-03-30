<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Debe_seleccionar_el_empleado_antes_de_continuar"
	Default="Debe seleccionar el empleado antes de continuar"
	returnvariable="vMensaje"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Siguiente"
	xmlfile="/rh/generales.xml"	
	Default="Siguiente"
	returnvariable="vSiguiente"/>

<script language="javascript" type="text/javascript">
	function goNext(f) {
		if (f.DEid.value != "") {
			f.paso.value = "2";
			f.submit();
		} else {
			alert('<cfoutput>#vMensaje#</cfoutput>');
		}
	}
</script>

<form name="form1" method="post" action="AnulaAcciones.cfm">
	<input type="hidden" name="paso" value="2">
	<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
	  <tr>
	    <td align="center" valign="top">&nbsp;</td>
	    <td>&nbsp;</td>
      </tr>
	  <tr>
		<td align="center" valign="top">
			<table width="95%" border="0" cellspacing="0" cellpadding="2">
			  <tr>
				<td colspan="2" nowrap>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td width="1%"><img src="/cfmx/rh/imagenes/num1.gif" border="0"></td>
						<td align="left"><strong style="font-family:'Times New Roman', Times, serif; font-size:14pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cf_translate key="LB_Seleccionar_Empleado" xmlfile="/rh/generales.xml">Seleccionar Empleado</cf_translate></strong></td>
					  </tr>
					</table>
				</td>
			  </tr>
			  <tr>
				<td colspan="2" class="tituloListas" nowrap>
					<cf_translate key="LB_Seleccione_el_empleado_con_el_cual_desea_trabajar">Seleccione el empleado con el cual desea trabajar</cf_translate> 
				</td>
			  </tr>
			  <tr>
			    <td colspan="4" nowrap>&nbsp;</td>
		      </tr>
			  <tr>
				<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Empleado" xmlfile="/rh/generales.xml">Empleado</cf_translate>:</td>
				<td valign="top" nowrap>
					<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid))>
						<cfquery name="rsDatosEmpleado" datasource="#Session.DSN#">
							select a.DEid, 
								   {fn concat({fn concat({fn concat({ fn concat( a.DEnombre, ' ') }, a.DEapellido1)}, ' ')}, a.DEapellido2) } as NombreEmp,
								   a.NTIcodigo, a.DEidentificacion, b.NTIdescripcion, a.DEtarjeta
							from DatosEmpleado a
							
							inner join NTipoIdentificacion b
							on a.NTIcodigo = b.NTIcodigo
							
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
							  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
							
						</cfquery>
						<cf_rhempleado size="60" query="#rsDatosEmpleado#">
					<cfelse>
						<cf_rhempleado size="60" >
					</cfif>
				</td>
			  </tr>
			  <tr>
				<td colspan="2" nowrap>&nbsp;</td>
			  </tr>
			  <tr>
			    <td colspan="2" align="center" nowrap>
					<input  type="button" name="Siguiente" value="<cfoutput>#vSiguiente#</cfoutput> >>" onClick="javascript: goNext(this.form);">
				</td>
		      </tr>
			</table>
		</td>
		<td width="200" align="center" valign="top" style="padding-right: 10px; padding-left: 10px; ">
			<cfinclude template="frame-Progreso.cfm">
		</td>
	  </tr>
	  <tr>
	    <td align="center" valign="top">&nbsp;</td>
	    <td>&nbsp;</td>
      </tr>
	</table>
</form>
