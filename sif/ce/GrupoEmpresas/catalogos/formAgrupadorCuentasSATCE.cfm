<cfinvoke key="LB_Clave" default="Clave" returnvariable="LB_Clave" component="sif.Componentes.Translate" method="Translate" xmlfile="formAgrupadorCuentasSATCE.xml"/>
<cfinvoke key="LB_Nombre" default="Nombre de Agrupador" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate" xmlfile="formAgrupadorCuentasSATCE.xml"/>
<cfinvoke key="LB_Version" default="Versi&oacute;n" returnvariable="LB_Version" component="sif.Componentes.Translate" method="Translate" xmlfile="formAgrupadorCuentasSATCE.xml"/>
<cfinvoke key="LB_Empresa" default="Solo para esta empresa" returnvariable="LB_Empresa" component="sif.Componentes.Translate" method="Translate" xmlfile="formAgrupadorCuentasSATCE.xml"/>
<cfinvoke key="LB_Estado" default="Deshabilitar agrupador" returnvariable="LB_Estado" component="sif.Componentes.Translate" method="Translate" xmlfile="formAgrupadorCuentasSATCE.xml"/>

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
<cfif isdefined("Form.modo2")>
	<cfset modo="ALTA">
</cfif>

<cfset rscveGpoEmpresa = -1>
<cfif modo neq 'ALTA'>
	<cfquery datasource="#Session.DSN#" name="rs">
		select
			CAgrupador,
			Descripcion,
			Version,
			ace.Ecodigo,
			Status,
			mge.GEid, age.GEnombre GrupoEmpresa
		from CEAgrupadorCuentasSAT ace
		left join CEMapeoGE mge
			on ace.CAgrupador = mge.Id_Agrupador
		left join AnexoGEmpresa age
			on mge.GEid = age.GEid
		where CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CAgrupador#">
	</cfquery>
	<cfset rscveGpoEmpresa = rs.GEid>
</cfif>


	<cfset LvarAction   = 'SQLAgrupadorCuentasSATCE.cfm'>
	<cfset LvarCuentas  = 'listaCatalogoCuentasSATCE.cfm'>
	<cfset LvarImporta  = 'AgrupadorCuentasSATCEImportacion.cfm'>
	<cfset LvarXML  = 'PrepararXMLCE.cfm'>
	<cfset LvarNuevaVer  = 'NuevaVersionCE.cfm'>

<cfoutput>
	<form action="#LvarAction#" method="post" name="form1">
		<table align="center" cellpadding="0" cellspacing="2">
			<tr valign="baseline">
				<td nowrap align="right"><strong>#LB_Clave#:</strong>&nbsp;</td>
				<td>
					<input type="text" name="CAgrupador" id="CAgrupador" value="<cfif MODO NEQ "ALTA">#rs.CAgrupador#</cfif>" onkeypress="return isNumber(event)" size="12" maxlength="4" tabindex="1" readonly="true" class="cajasinbordeb">
				</td>
			</tr>
			<tr valign="baseline">
				<td nowrap align="right"><strong>#LB_Nombre#:</strong>&nbsp;</td>
				<td>
					<input type="text" name="Nombre_Agrupador" id="Nombre_Agrupador" value="<cfif MODO NEQ "ALTA">#rs.Descripcion#</cfif>"  size="47" maxlength="200" tabindex="1" readonly="true" class="cajasinbordeb">
				</td>
			</tr>
			<tr valign="baseline">
				<td nowrap align="right"><strong>#LB_Version#:</strong>&nbsp;</td>
				<td>
                    <input type="text" name="Version" id="Version" value="<cfif MODO NEQ "ALTA">#rs.Version#</cfif>"  size="12" maxlength="25" tabindex="1" readonly="true" class="cajasinbordeb">
				</td>
			</tr>
			<tr>
				<td nowrap align="right"><strong>Grupo de Empresa:</strong>&nbsp;</td>
				<td>
					<cfset rsGpoEmpresaPar = ObtenerDato(1330)>
					<cfquery name="rsGpoEmpresa" datasource="#Session.DSN#">
					        select a.GEid, a.GEnombre as Edescripcion
					        from AnexoGEmpresa a
					        where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
					</cfquery>

					<select name="gpoEmpresaid" id="gpoEmpresaid">
 					    <option value=""> -- Seleccione --</option>
					  <cfloop query="rsGpoEmpresa">
					    <option value="#rsGpoEmpresa.GEid#" <cfif rsGpoEmpresa.GEid EQ rscveGpoEmpresa>selected</cfif>>#trim(rsGpoEmpresa.Edescripcion)# </option>
					  </cfloop>
					</select>
				</td>
			</tr>
			<tr valign="baseline">
				<td colspan="2">
					<!--- <input type="hidden" name="CAgrupador" value="<cfif MODO NEQ "ALTA">#rs.CAgrupador#</cfif>"> --->
					<cfif modo NEQ 'ALTA'>
						<cfset varInclude = "">
						<cfset varExclude = "Nuevo">
						<cfif rscveGpoEmpresa NEQ "">
							<cfset varInclude = "Cuentas,Preparar_XML">
							<cfset varExclude = "#varExclude#,CAMBIO">
						</cfif>
						<cf_botones modo="#modo#" form="form1" exclude="#varExclude#" include="#varInclude#" tabindex="1">
					</cfif>
				</td>
			</tr>

		</table>
	</form>
</cfoutput>

   <cfif IsDefined("Form.Error")>
		<cfif #form.Error# eq 1>
		   <script language="javascript" type="text/javascript">
		         alert('El agrupador no puede ser eliminado porque tiene cuentas asignadas.');
		   </script>
	   </cfif>
	   <cfif #form.Error# eq 2>
		   <script language="javascript" type="text/javascript">
		         alert('El agrupador ya se encuentra registrado.');
		   </script>
	   </cfif>
	</cfif>

<cf_qforms form="form1">
<script language="javascript" type="text/javascript">
	function funcCambio(){
		return funcAlta();
	}

	function isNumber(evt) {
	    evt = (evt) ? evt : window.event;
	    var charCode = (evt.which) ? evt.which : evt.keyCode;
	    if (charCode > 31 && (charCode < 48 || charCode > 57)) {
	        return false;
	    }
	    return true;
	}

	function funcAlta(){
		var caid = document.getElementByname('CAgrupador').value;
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
	function funcBaja(){
		if (confirm('¿Esta seguro de eliminar la configuracion de este Agrupador?' )){
			return true;
		}
		else{
			return false;
		}

	}

	function funcCuentas(){
		document.form1.action='<cfoutput>#LvarCuentas#</cfoutput>';
		document.form1.submit();
	}
	function funcImportar(){
		document.form1.action='<cfoutput>#LvarImporta#</cfoutput>';
		document.form1.submit();
	}

	function funcNueva_Ver(){
	  document.form1.action='<cfoutput>#LvarNuevaVer#</cfoutput>';
	  document.form1.submit();
	  res = true;
	}

	function funcPreparar_XML(){
		var res;
		var fEstado = document.getElementById('Estado');
		if(fEstado){
			if(document.getElementById('Estado').checked == true ){
				alert('Esta acci\u00f3n no puede ejecutarse ya que el agrupador se encuentra deshabilitado')
				res = false;
			}else{
				document.form1.action='<cfoutput>#LvarXML#</cfoutput>';
			    document.form1.submit();
				res = true;
			}
		}else{
			document.form1.action='<cfoutput>#LvarXML#</cfoutput>';
		    document.form1.submit();
			res = true;
		}

		return res;

	}

</script>


