<cfinvoke key="LB_Cuenta" default="Cuenta" returnvariable="LB_Cuenta" component="sif.Componentes.Translate" method="Translate" xmlfile="formCatalogoCuentasSATCE.xml"/>
<cfinvoke key="LB_Nombre" default="Nombre" returnvariable="LB_Nombre" component="sif.Componentes.Translate" method="Translate" xmlfile="formCatalogoCuentasSATCE.xml"/>
<cfinvoke key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo" component="sif.Componentes.Translate" method="Translate" xmlfile="formCatalogoCuentasSATCE.xml"/>

<cfquery name="valOrden" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200081 AND Mcodigo = 'CE' AND Ecodigo = #Session.Ecodigo#
</cfquery>
<cfif isdefined("Form.Cambio")>
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

<cfif modo neq 'ALTA'>
	<cfquery datasource="#Session.DSN#" name="rs">
		select CCuentaSAT, CAgrupador,Ltrim(Rtrim(NombreCuenta)) NombreCuenta,
			   Clasificacion,
			Ecodigo
		from CECuentasSAT
		where CCuentaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">
			and ltrim(rtrim(CAgrupador)) = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">
	</cfquery>
</cfif>

<cfquery name="rsTipo" datasource="#Session.DSN#">
	select upper(Descripcion) Descripcion from CEClasificacionCuentasSAT
</cfquery>

	<cfset LvarAction   = 'SQLCatalogoCuentasSATCE.cfm'>
	<cfset LvarImporta  = 'CatalogoBancosCEImportacion.cfm'>
	<cfset LvarRegresar = 'listaCatalogoCuentasSATCE.cfm'>
<cfoutput>
	<table align="left" cellpadding="0" cellspacing="2" width="100%">
	<tr>
		<td>
			<form action="#LvarAction#" method="post" name="form1" id="form1">
				<cfquery name="rsGEid" datasource="#Session.DSN#">
					select CAgrupador, Descripcion, Version,
						mge.GEid, age.GEnombre GrupoEmpresa
					from CEAgrupadorCuentasSAT ace
					left join CEMapeoGE mge
						on ace.Id_Agrupador = mge.Id_Agrupador
					left join AnexoGEmpresa age
						on mge.GEid = age.GEid
					where 1=1 and (ace.Ecodigo is null or ace.Ecodigo = #Session.Ecodigo#)
						and ace.CAgrupador = #form.CAgrupador#
				</cfquery>
				<!--- <cf_dump var="#rsGEid#"> --->
				<table width="100%" align="left" cellpadding="0" cellspacing="2" border="0" >
					<tr valign="baseline">
						<td nowrap align="right">
							<strong>
								#LB_Cuenta#:
							</strong>
							&nbsp;
						</td>
						<td>
							<input type="text" name="CCuentaSAT" id="CCuentaSAT" value="<cfif MODO NEQ 'ALTA'>#trim(rs.CCuentaSAT)#</cfif>" size="12" maxlength="10" tabindex="1"
							<cfif MODO NEQ "ALTA">
								readonly="true" class="cajasinbordeb"
							</cfif>
							>
						</td>
					</tr>
					<tr>
						<td nowrap align="right">
							<strong>
								#LB_Nombre#:
							</strong>
							&nbsp;
						</td>
						<td>
							<input type="text" name="NombreCuenta" id="NombreCuenta" value="<cfif MODO NEQ 'ALTA'>#trim(rs.NombreCuenta)#</cfif>" size="50" maxlength="200" tabindex="1">
						</td>
					</tr>
					<tr valign="baseline">
						<td nowrap align="right">
							<strong>
								#LB_Tipo#:
							</strong>
							&nbsp;
						</td>
						<td>
							<select name="Clasificacion" id="Clasificacion">
								<option value="Escoger">
									-- Escoger uno --
								</option>

								<cfloop query="rsTipo">
									<option value="#rsTipo.Descripcion#"
									<cfif MODO NEQ "ALTA">
										<cfif '#trim(UCase(rs.Clasificacion))#' eq '#trim(Ucase(rsTipo.Descripcion))#'>
											selected
										</cfif>
									</cfif>
									>#rsTipo.Descripcion#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
					</tr>
					<tr valign="baseline">
						<td colspan="2">
							<input type="hidden" name="CAgrupador" id="CAgrupador" value="<cfif MODO NEQ "ALTA">
							#rs.CAgrupador#</cfif>">
							<input type="hidden" name="CCuentaSATUP" id="CCuentaSATUP" value="<cfif MODO NEQ "ALTA">
							#rs.CCuentaSAT#</cfif>">
							<cfif isdefined("form.CAgrupador") >
								<cfif MODO EQ "ALTA">
									<input type="hidden" name="CAgrupador" id="CAgrupador" value="#form.CAgrupador#">
								</cfif>
							</cfif>
							<cfif modo NEQ 'ALTA'>
								<cf_botones modo="#modo#" form="form1" exclude="Cambio,Nuevo" include="Regresar" tabindex="1">
							<cfelse>
								<cf_botones modo="#modo#" form="form1" include="Regresar" tabindex="1" >
							</cfif>
							<br>
							<br>
						</td>
					</tr>
				</table>
				<input type="hidden" name="EGEid" id="EGEid" value="<cfoutput>#rsGEid.GEid#</cfoutput>">
			</form>
		</td>
	</tr>
	<tr>
		<td>
			<cfif modo NEQ 'ALTA'>
				<table align="left" cellpadding="0" cellspacing="2"  width="100%">
					<tr valign="baseline">
						<td>
							<cfinclude template="formMapeoCuentasCE.cfm">
						</td>
					</tr>
					<tr valign="baseline">
						<td>
							<cfinclude template="listaMapeoCuentasCE.cfm">
						</td>
					</tr>
				</table>
			</cfif>
		</td>
	</tr>
	</table>
</cfoutput>





<cf_qforms form="form1">

   <cfif IsDefined("Form.Error")>
		<cfif #form.Error# eq 1>
		   <script language="javascript" type="text/javascript">
		         alert('El agrupador no puede ser eliminado porque tiene cuentas asignadas');
		   </script>
	     </cfif>
	     <cfif #form.Error# eq 2>
		   <script language="javascript" type="text/javascript">
		         alert('Esta cuenta ya se encuentra registrada');
		   </script>
	     </cfif>
	</cfif>
<script language="javascript" type="text/javascript">
	function funcCambio(){
		return funcAlta();
	}

	function funcAlta(){
		if(document.getElementById('CCuentaSAT').value != ""){
	    	if(document.getElementById('NombreCuenta').value != ""){
	    		if(document.getElementById('Clasificacion').value != "Escoger"){

				     return true;

			     }else{
				    alert('Selecciona una clasificaci\u00f3n')
		            return false
		     	}

			}else{
				alert("El Campo Nombre es requerido")
		        return false
			}

		}else{
			alert("El Campo Clave es requerido")
		    return false
		}

	}
	function funcBaja(){
		if (confirm('¿Esta seguro de eliminar toda la configuracion de esta cuenta?' )){
			return true;
		}
		else{
			return false;
		}

	}


	function funcImportar(){
		document.form1.action='<cfoutput>#LvarImporta#</cfoutput>';
		document.form1.submit();
	}


	function funcRegresar(){
		document.form1.action='<cfoutput>#LvarRegresar#</cfoutput>';
		document.form1.submit();
	}

</script>