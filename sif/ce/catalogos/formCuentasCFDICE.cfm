<cfinvoke key="LB_Generales" default="Cuentas con CFDI" returnvariable="LB_Generales" component="sif.Componentes.Translate" method="Translate" xmlfile="formCuentasCFDICE.xml"/>
<cfinvoke key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" component="sif.Componentes.Translate" method="Translate" xmlfile="formCuentasCFDICE.xml"/>
<cfinvoke key="LB_Descripcion" default="Descripcion" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" xmlfile="formCuentasCFDICE.xml"/>
<cfinvoke key="LB_Cuentas" default="Cuentas" returnvariable="LB_Cuentas" component="sif.Componentes.Translate" method="Translate" xmlfile="formCuentasCFDICE.xml"/>
<cfinvoke key="LB_Eliminar" default="Eliminar" returnvariable="LB_Eliminar" component="sif.Componentes.Translate" method="Translate" xmlfile="formCuentasCFDICE.xml"/>


<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
</cfif>

<cfset IRA   = 'ParametrosCE.cfm'>

<cfoutput>
	<form action="SQLCuentasCFDICE.cfm" method="post" name="form2">
		<table width="100%" frame="below" rules="none" border="3" >
			<tr><td nowrap style="padding-left : 10px; padding-top:6px;"><strong>#LB_Generales#</strong></td></tr>
		</table>
		<table align="Left" cellpadding="0" cellspacing="2">
			<br>
			<tr>
				<td width="50%">
					<cfif modo EQ "ALTA">
							<cf_cuentasanexo
							auxiliares="S"
							movimiento="N"
							conlis="S"
							ccuenta="Ccuenta"
							cdescripcion="Cdescripcion2"
							cformato="Cformato"
							conexion="#Session.DSN#"
							form="form2"
							frame="frCuentac"
							comodin="?" tabindex="7">
						<cfelse>
							<cfquery name="rsCformato" datasource="#Session.DSN#">
								select Ccuenta, Descripcion as cdescripcion, CFormato from CECuentasCFDI
								where Ccuenta in (-100#Form.Cfcuenta#)
							</cfquery>
							<cf_cuentasanexo
							auxiliares="S"
							movimientos="N"
							conlis="S"
							ccuenta="Ccuenta"
							cdescripcion="Cdescripcion2"
							cformato="Cformato"
							conexion="#Session.DSN#"
							form="form2"
							frame="frCuentac"
							query="#rsCformato#"
							comodin="?" tabindex="7">
						</cfif>
			          <cfif #modo# eq "ALTA">
				          <input type="submit" name="Guardar" value="#LB_Guardar#" class="btnGuardar" onclick="return funcAltaCuenta()">
					  </cfif>
					  <cfif #modo# eq "CAMBIO">
						  <input type="submit" name="Eliminar" value="#LB_Eliminar#" class="btnEliminar" onclick="return funcEliminarCuenta()">
					  </cfif>

				</td>
			</tr>
			<tr>
				<td width="50%">
					<cfinvoke component="sif.Componentes.pListas" method="pLista" returnvariable="pListaRet"
						tabla				= "CECuentasCFDI"
						columnas  			= "Ccuenta,CFormato,Descripcion"
						desplegar			= "CFormato,Descripcion"
						etiquetas			= "#LB_Cuenta#, #LB_Descripcion#"
						formatos			= "S,S"
						filtro				= "Ecodigo = #session.ecodigo#"
						align 				= "Left, Left"
						ajustar				= "N"
						checkboxes			= "N"
						incluyeform			= "true"
						formname			= "form2"
						navegacion			= ""
						mostrar_filtro		= "true"
						filtrar_automatico	= "true"
						showLink			= "true"
						showemptylistmsg	= "true"
						key					= "Ccuenta"
						MaxRows				= "15"
						irA					= ""
						/>
				</td>
				</tr>


		</table>
	</form>
</cfoutput>

<script language="javascript" type="text/javascript">

	function funcAltaCuenta(){
		var res;
		if(document.getElementById('CFcuenta').value != ""){

			res = true;
		}else{
			alert('Debe seleccionar una cuenta')
			 res = false;
		}
		return res;

	}

	function funcEliminarCuenta(){
		var res;
		res = confirm("�Deseas eliminar este registro?");
		return res;
	}

</script>


