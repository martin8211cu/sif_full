<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="MSG_Debe_seleccionar_la_accion_que_desea_anular_antes_de_continuar"
	Default="Debe seleccionar la acción que desea anular antes de continuar"
	returnvariable="vMensaje"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Siguiente"
	xmlfile="/rh/generales.xml"
	Default="Siguiente"
	returnvariable="vSiguiente"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="BTN_Anterior"
	xmlfile="/rh/generales.xml"
	Default="Anterior"
	returnvariable="vAnterior"/>

<cfquery name="rsDatosEmpleado" datasource="#Session.DSN#">
	select {fn concat({fn concat({fn concat({ fn concat( a.DEnombre, ' ') }, a.DEapellido1)}, ' ')}, a.DEapellido2) } as NombreEmp,
		   a.NTIcodigo, a.DEidentificacion, b.NTIdescripcion
	from DatosEmpleado a

	inner join NTipoIdentificacion b
	on a.NTIcodigo = b.NTIcodigo

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
</cfquery>

<cfif isdefined("Form.RHSPEid") and Len(Trim(RHSPEid))>
	<cfquery name="rsDatosAccion" datasource="#Session.DSN#">
		select RHSPEid,
			   {fn concat({fn concat( rtrim(b.RHTcodigo), ' - ' )}, b.RHTdesc)} as TipoAccion,
			   c.DLobs,
			   a.RHSPEfdesde as Fdesde,
			   a.RHSPEfhasta as Fhasta
			   0 as modificaLT
		from RHSaldoPagosExceso a

		inner join RHTipoAccion b
		on a.RHTid = b.RHTid
		and a.Ecodigo = b.Ecodigo

		inner join DLaboralesEmpleado c
		on a.DLlinea = c.DLlinea
		and a.DEid = c.DEid
		and a.Ecodigo = c.Ecodigo

		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.DEid#">
		and a.RHSPEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHSPEid#">
        and a.RHSPEanulado = 0
	</cfquery>
</cfif>


<script language="javascript" type="text/javascript">

	function doConlisAcciones(DEid) {
		if (DEid != "") {
			var width = 600;
			var height = 550;
			var top = (screen.height - height) / 2;
			var left = (screen.width - width) / 2;
			var params = '?f=form1&DEid='+DEid+'&p1=RHSPEid&p2=Fdesde&p3=Fhasta&p4=Descripcion&p5=Observacion&p6=modificaLT';
			var nuevo = window.open('/cfmx/rh/nomina/anulacion/ConlisAcciones.cfm'+params,'ListaAcciones','menu=no,scrollbars=yes,top='+top+',left='+left+',width='+width+',height='+height);
			nuevo.focus();
		} else {
			alert('Debe escoger un empleado primero');
		}
	}

	function goPrevious(f) {
		f.paso.value = "1";
		f.submit();
	}

	function goNext(f) {
		if (f.RHSPEid.value != "") {
			f.paso.value = "3";
			f.submit();
		} else {
			alert('<cfoutput>#vMensaje#</cfoutput>');
		}
	}

</script>

<cfoutput>
	<form name="form1" method="post" action="AnulaAcciones.cfm">
		<input type="hidden" name="paso" value="2">
		<input type="hidden" name="DEid" value="#Form.DEid#">
		<table width="95%" border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr>
			<td align="center" valign="top">&nbsp;</td>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
			<td align="center" valign="top">
				<table width="95%" border="0" cellspacing="0" cellpadding="2">
				  <tr>
					<td colspan="4" nowrap>
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td width="1%"><img src="/cfmx/rh/imagenes/num2.gif" border="0"></td>
							<td align="left"><strong style="font-family:'Times New Roman', Times, serif; font-size:14pt; font-variant:small-caps; font-weight:bolder; padding-left:20px"><cf_translate key="LB_Seleccionar_Accion"  xmlfile="/rh/generales.xml">Seleccionar Acci&oacute;n</cf_translate></strong></td>
						  </tr>
						</table>
					</td>
				  </tr>
				  <tr>
				    <td align="right" nowrap class="fileLabel" style="border-top: 1px solid gray; border-bottom: 1px solid gray; "><cf_translate key="LB_Empleado" xmlfile="/rh/generales.xml">Empleado</cf_translate>:</td>
				    <td valign="middle" style="border-top: 1px solid gray; border-bottom: 1px solid gray; " nowrap>#rsDatosEmpleado.NombreEmp#</td>
				    <td align="right" class="fileLabel" style="border-top: 1px solid gray; border-bottom: 1px solid gray; " nowrap><cf_translate key="LB_Identificacion" xmlfile="/rh/generales.xml">Identificaci&oacute;n</cf_translate>:</td>
				    <td valign="middle" style="border-top: 1px solid gray; border-bottom: 1px solid gray; " nowrap>#rsDatosEmpleado.DEidentificacion#</td>
			      </tr>
				  <tr>
				    <td colspan="4" nowrap>&nbsp;</td>
			      </tr>
				  <tr>
					<td colspan="4" class="tituloListas" nowrap>
						<cf_translate key="LB_Seleccione_la_accion_que_desea_anular">Seleccione la acci&oacute;n que desea anular</cf_translate></td>
				  </tr>
				  <tr>
				    <td colspan="4" nowrap>&nbsp;</td>
			      </tr>
				  <tr>
					<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Accion" xmlfile="/rh/generales.xml">Acci&oacute;n</cf_translate>:</td>
					<td valign="middle" nowrap>
						<input type="hidden" name="RHSPEid" value="<cfif isdefined('rsDatosAccion')>#rsDatosAccion.RHSPEid#</cfif>">
						<input type="text" name="Descripcion" size="50" value="<cfif isdefined('rsDatosAccion')>#rsDatosAccion.TipoAccion#</cfif>" readonly>
						<a href="javascript: doConlisAcciones(#Form.DEid#);" onMouseOver="javascript: window.status=''; return true;" onMouseOut="javascript: window.status=''; return true;" tabindex="-1"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Acciones" name="imagen" width="18" height="14" border="0" align="absmiddle"></a>
					</td>
			        <td align="right" class="fileLabel" nowrap>&nbsp;</td>
			        <td valign="middle" nowrap>&nbsp;</td>
		          </tr>
				  <tr>
			        <td align="right" class="fileLabel" nowrap><cf_translate key="LB_Fecha_Rige">Fecha Rige</cf_translate>:</td>
			        <td valign="middle" nowrap>
						<input type="text" name="Fdesde" size="10" style="border: none; " value="<cfif isdefined('rsDatosAccion')>#LSDateFormat(rsDatosAccion.Fdesde,'dd/mm/yyyy')#</cfif>" readonly>
					</td>
			        <td align="right" class="fileLabel" nowrap><cf_translate key="LB_Fecha_Vence">Fecha Vence</cf_translate>:</td>
			        <td valign="middle" nowrap>
						<input type="text" name="Fhasta" size="10" style="border: none; "  value="<cfif isdefined('rsDatosAccion')>#LSDateFormat(rsDatosAccion.Fhasta,'dd/mm/yyyy')#</cfif>"readonly>
					</td>
		          </tr>
				  <tr>
					<td align="right" nowrap class="fileLabel"><cf_translate key="LB_Observacion">Observaci&oacute;n</cf_translate>:</td>
					<td colspan="3" nowrap>
						<input type="text" name="Observacion" value="<cfif isdefined('rsDatosAccion')>#rsDatosAccion.DLobs#</cfif>" style="width: 100%; border: none; " readonly>
					</td>
				  </tr>
				  <tr>
					<td colspan="4" nowrap>&nbsp;</td>
				  </tr>
				  <tr>
					<td colspan="4" align="center" nowrap>
						<input type="button" name="Anterior" value="<< #vAnterior#" onClick="javascript: goPrevious(this.form);">
						<input type="button" name="Siguiente" value="#vSiguiente# >>" onClick="javascript: goNext(this.form);">
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
</cfoutput>