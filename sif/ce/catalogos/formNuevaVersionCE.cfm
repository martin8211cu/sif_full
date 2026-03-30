<cfinvoke key="LB_Clave" default="Clave" returnvariable="LB_Clave" component="sif.Componentes.Translate" method="Translate" xmlfile="formNuevaVersionCE.xml"/>
<cfinvoke key="LB_Nombre" default="Nombre de Agrupador" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate" xmlfile="formNuevaVersionCE.xml"/>
<cfinvoke key="LB_Version" default="Versi&oacute;n" returnvariable="LB_Version" component="sif.Componentes.Translate" method="Translate" xmlfile="formNuevaVersionCE.xml"/>
<cfinvoke key="LB_Solo" default="Solo para esta empresa" returnvariable="LB_Solo" component="sif.Componentes.Translate" method="Translate" xmlfile="formNuevaVersionCE.xml"/>
<cfinvoke key="LB_Deshabilitar" default="Deshabilitar agrupador" returnvariable="LB_Deshabilitar" component="sif.Componentes.Translate" method="Translate" xmlfile="formNuevaVersionCE.xml"/>
<cfinvoke key="LB_CopiarC" default="Copiar cuentas" returnvariable="LB_CopiarC" component="sif.Componentes.Translate" method="Translate" xmlfile="formNuevaVersionCE.xml"/>
<cfinvoke key="LB_CopiarM" default="Copiar mapeo" returnvariable="LB_CopiarM" component="sif.Componentes.Translate" method="Translate" xmlfile="formNuevaVersionCE.xml"/>
<cfinvoke key="LB_Regresar" default="Regresar" returnvariable="LB_Regresar" component="sif.Componentes.Translate" method="Translate" xmlfile="formNuevaVersionCE.xml"/>


<cfif isdefined("form.modoR")>
	<cfset modo="CAMBIO">
	<cfelse>
	<cfset modo="ALTA">
</cfif>
<cfif IsDefined("Form.Error")>
	<cfif #form.Error# eq 1>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<cfif #modo# neq 'ALTA'>
	<cfquery datasource="#Session.DSN#" name="rs">
		select
			CAgrupador,
			Descripcion,
			Version,
			Ecodigo,
			Status
		from CEAgrupadorCuentasSAT
		where CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">
	</cfquery>
</cfif>

<cfset LvarAction   = 'SQLNuevaVersion.cfm'>
<cfset LvarRegresar  = 'AgrupadorCuentasSATCE.cfm'>
<cfoutput>
	<form action="#LvarAction#" method="post" name="form1">
		<table align="center" cellpadding="0" cellspacing="2">
			<tr valign="baseline">
				<td nowrap align="right"><strong>#LB_Clave#:</strong>&nbsp;</td>
				<td>
					<input type="text" name="CAgrupador" id="CAgrupador" value="<cfif MODO NEQ "ALTA">#rs.CAgrupador#</cfif>"  size="12" maxlength="4" tabindex="1" <cfif MODO NEQ "ALTA">disabled = true</cfif>>
				</td>
			</tr>
			<tr valign="baseline">
				<td nowrap align="right"><strong>#LB_Nombre#:</strong>&nbsp;</td>
				<td>
					<input type="text" name="Nombre_Agrupador" id="Nombre_Agrupador" value="<cfif MODO NEQ "ALTA">#rs.Descripcion#</cfif>"  size="47" maxlength="200" tabindex="1">
				</td>
			</tr>
			<tr valign="baseline">
				<td nowrap align="right"><strong>#LB_Version#:</strong>&nbsp;</td>
				<td>
                    <input type="text" name="Version" id="Version" value="<cfif MODO NEQ "ALTA">#rs.Version#</cfif>"  size="12" maxlength="25" tabindex="1">
				</td>
			</tr>
			<tr>
				<td align="right"><input type="checkbox" name="Empresa" <cfif MODO NEQ "ALTA"><cfif #rs.Ecodigo# neq ''>checked="true"></cfif></cfif></td>
				<td>#LB_Solo#</td>
			</tr>
			<tr valign="baseline">
				<td nowrap align="right"><input type="checkbox" name="Estado" id="Estado" <cfif MODO NEQ "ALTA"><cfif #rs.Status# neq 'Activo'>checked="true"</cfif></cfif>></td>
				<td >#LB_Deshabilitar#&nbsp;</td>
			</tr>
			<tr valign="baseline">
				<td nowrap align="right"><input type="checkbox" name="Cuentas"  id="Cuentas" <cfif MODO EQ "ALTA">checked="true"</cfif> onclick="funcCheck()"></td>
				<td >#LB_CopiarC#&nbsp;</td>
			</tr>
			<tr valign="baseline">
				<td nowrap align="right"><input type="checkbox" name="Mapeo" id="Mapeo" onclick="funcCheck()"></td>
				<td >#LB_CopiarM#&nbsp;</td>
			</tr>
			<tr valign="baseline">
				<td colspan="2" align="center">
					<input type="hidden" name="CAgrupadorEx" value="#form.CAgrupador#">
					<input type="hidden" name="modo2" value="1">

					<cfif #modo# eq 'ALTA'>
						<cf_botones modo="#modo#" form="form1"  tabindex="1" include="Regresar">
						<cfelse>
						<input type="submit" name="Regresar" value="#LB_Regresar#" class="btnAnterior" onclick="funcRegresar()" >
					</cfif>


				</td>
			</tr>

		</table>
	</form>
</cfoutput>

   <cfif IsDefined("Form.Error")>
	   <cfif #form.Error# eq 1>
		   <script language="javascript" type="text/javascript">
		         alert('El agrupador ya se encuentra registrado.');
		   </script>
	   </cfif>
	</cfif>
<script language="javascript" type="text/javascript">
	function funcRegresar(){
		document.form1.action='<cfoutput>#LvarRegresar#</cfoutput>';
		document.form1.submit();
		return false
	}
	function funcAlta(){

		if(document.getElementById('CAgrupador').value != ""){
	    	if(document.getElementById('Nombre_Agrupador').value != ""){
	    		if(document.getElementById('Version').value != ""){

			     }else{
				    alert('El Campo Version es requerido')
		            return false
		     	}

			}else{
				alert("El Campo Nombre de Agrupador es requerido")
		        return false
			}

		}else{
			alert("El Campo Clave es requerido")
		    return false
		}

	}

	function funcCheck(){
		var calCheck = document.getElementById('Cuentas').checked
		if(calCheck == false){
			document.getElementById('Mapeo').checked = false;
		}

	}

</script>
