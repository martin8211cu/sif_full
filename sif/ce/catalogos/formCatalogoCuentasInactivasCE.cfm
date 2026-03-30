<cfinvoke key="LB_cuenta" default="cuenta" returnvariable="LB_cuenta" component="sif.Componentes.Translate" method="Translate" xmlfile="formCatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" component="sif.Componentes.Translate" method="Translate" xmlfile="formCatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_Clasificacion" default="Clasificación" returnvariable="LB_Clasificacion" component="sif.Componentes.Translate" method="Translate" xmlfile="formCatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" component="sif.Componentes.Translate" method="Translate" xmlfile="formCatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_Cuentas" default="Cuentas" returnvariable="LB_Cuentas" component="sif.Componentes.Translate" method="Translate" xmlfile="formCatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_AgregarMas" default="Agregar la cuenta seleccionada." returnvariable="LB_AgregarMas" component="sif.Componentes.Translate" method="Translate" xmlfile="formCatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_AgregarMenos" default="Agrega la cuenta seleccionada y las subcuentas asociadas a esta." returnvariable="LB_AgregarMenos" component="sif.Componentes.Translate" method="Translate" xmlfile="formCatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_PermiteMas" default="Permite eliminar solo esta cuenta." returnvariable="LB_PermiteMas" component="sif.Componentes.Translate" method="Translate" xmlfile="formCatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_PermiteMenos" default="Permite eliminar la cuenta y subcuentas asociadas a esta." returnvariable="LB_PermiteMenos" component="sif.Componentes.Translate" method="Translate" xmlfile="formCatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_Eliminar" default="Eliminar" returnvariable="LB_Eliminar" component="sif.Componentes.Translate" method="Translate" xmlfile="formCatalogoCuentasInactivasCE.xml"/>
<cfinvoke key="LB_Regresar" default="Regresar" returnvariable="LB_Regresar" component="sif.Componentes.Translate" method="Translate" xmlfile="formCatalogoCuentasInactivasCE.xml"/>


<cfif isdefined("Form.Cambio") or isdefined("form.btnRegresar") or isdefined("form.BotonSel")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfset array_cuenta = ArrayNew(1)>
<cfif modo neq 'ALTA'>
	<cfquery datasource="#Session.DSN#" name="rs">
		SELECT
		      Ccuenta,
		      Cformato,
		      Cdescripcion
	   FROM
	          CEInactivas
	   WHERE
	          Ccuenta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccuenta#">
	</cfquery>
	<cfset ArrayAppend(array_cuenta, "#rs.Ccuenta#")>
	<cfset ArrayAppend(array_cuenta, "#rs.Cformato#")>
	<cfset ArrayAppend(array_cuenta, "#rs.Cdescripcion#")>
</cfif>

	<cfset LvarAction   = 'SQLCatalogoCuentasInactivasCE.cfm'>
	<cfset LvarRegresa = ''>

<cfoutput>
	<form action="#LvarAction#" method="post" name="form1">
		<table align="left" cellpadding="0" cellspacing="2">
			<tr valign="baseline">
				<td nowrap align="right"><cf_translate key=LB_Nombre>#LB_Cuenta#</cf_translate>:&nbsp;</td>
				<td style="vertical-align:bottom">
					<cf_conlis
			          title="#LB_Cuentas#"
			          campos = "Ccuenta, Cformato, Cdescripcion"
			          desplegables = "U,S,S"
			          modificables = "N,N"
			          size = "25,25,60"
			          valuesarray="#array_cuenta#"
			          tabla="CContables a"
			          columnas="Ccuenta, Cformato, Cdescripcion "
	    	          filtro="NOT EXISTS(Select Cformato,b.Ecodigo from CEInactivas b where b.Ecodigo = a.Ecodigo and a.Cformato = b.Cformato)
							and a.Ecodigo = #Session.Ecodigo#"
			          desplegar="Cformato,Cdescripcion"
			          etiquetas="#LB_cuenta#,#LB_Descripcion#,#LB_Clasificacion#"
			          formatos="S,S"
			          align="left,left,left"
			          cortes=""
			          asignar="Ccuenta,Cformato,Cdescripcion"
			          asignarformatos="S,S,S"
			          Funcion=""
			          MaxRowsQuery="1000">
				</td>
				<cfif MODO EQ "ALTA">
					<td><input type="submit" value="+" class="btnNormal" style="font-family: Verdana; font-size: 11px; font-weight: bold;" title="#LB_AgregarMas#" id="Subcuenta_cuenta" onclick="return funMapearCuentas(this.id)" name="Cuenta_cuenta"></td>
				    <td><input type="submit" value="*" class="btnNormal" style="font-family: Verdana; font-size: 11px; font-weight: bold;;" title="#LB_AgregarMenos#" id="Subcuenta_subcuenta" onclick="return funMapearCuentas(this.id)" name="Cuenta_subcuenta"></td>
				</cfif>
				<cfif MODO NEQ "ALTA">
					<td><input type="radio" name="valm" id="cuenta" value="cuenta" title="#LB_PermiteMas#"><label >+</label></td>
					<td><input type="radio" name="valm" id="subcuenta" value="subcuenta" title="#LB_PermiteMenos#"><label style="vertical-align: middle;">*</label></td>
				</cfif>
			</tr>

			<tr valign="baseline">

				<td colspan="2" align="center">
					<cfif MODO NEQ "ALTA">
						<br>
						<input type="submit" value="#LB_Eliminar#" class="btnEliminar"  id="Elimina_cuenta" onclick="return funcBaja()" name="Elimina_cuenta">
						<input type="submit" name="#LB_Regresar#" value="Regresar" class="btnAnterior" onclick="Regresar()">
						<input type="hidden" name="tipoME" id="tipoME" value="">
					</cfif>
				</td>
			</tr>

		</table>
	</form>
</cfoutput>

<cf_qforms form="form1">
<script language="javascript" type="text/javascript">
	function funMapearCuentas(id){
		if(document.getElementById('Cformato').value == ""){
			alert('Seleccione una cuenta.');
			return false;
		}
	}
	function funcBaja(){
		var regresa = false;
		for(a=0;a<document.getElementsByName("valm").length;a++){
			if(document.getElementsByName("valm")[a].checked){
				document.getElementById("tipoME").value=document.getElementsByName("valm")[a].value
				regresa=true;
			}
		}
		if(regresa == false){
			alert('Elija (+) solo esta cuenta o (*) esta cuanta y subcuentas asociadas');
		}
		if(regresa==true){
			if (confirm('¿Est\u00e1 seguro de eliminar esta cuenta?' )){
			    regresa=true;
	        }
	        else{
			    regresa= false;
		    }
		}

		return regresa;
	}
	function Regresar(){
		<cfset modo="ALTA">
   }

</script>
