
<!---Devuelve una estructura query con los servicios activos, los reprogramables y los permitidos por el paquete--->
<cfinvoke component="saci.comp.ISBservicioTipo" method="ComparaServicios" returnvariable="rsServ">
	<cfinvokeargument name="cuentaid" value="#form.CTid#">
	<cfinvokeargument name="contratoid" value="#form.Contratoid#">
	<cfinvokeargument name="showServMinimos" value="false">
</cfinvoke>

<cfquery name="rsLogs" datasource="#session.DSN#">
	select LGnumero, LGlogin 
	from ISBlogin
	where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
	and Habilitado=1
</cfquery>


<cfquery datasource="#session.dsn#" name="LGserids_padre">
			select LGserids
			from ISBlogin 
			  where Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
				and LGserids is not null
				and LGserids != ''
				and LGprincipal = 1
			order by LGnumero
</cfquery>
<!---Busco el codigo del paquete y si necesita telefono para conecxion--->
<cfquery name="rsPaqueteTelf" datasource="#session.DSN#">
	select pq.PQcodigo,pq.PQtelefono
	from ISBproducto pro
		  inner join ISBpaquete pq
		  on pro.PQcodigo = pq.PQcodigo
	where pro.Contratoid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Contratoid#">
</cfquery>


<cfset lista = "">  

<cfloop query="rsServ">
	<cfset Activos = rsServ.ServActivos + rsServ.ServReprogramar>
	<cfif rsServ.ServPermitidos GT Activos>
		<cfset lista = lista &','&rsServ.TScodigo>  
	</cfif>
</cfloop>

<cfoutput>
	<form name="form1" method="post" style="margin: 0;" action="gestion-agregar-servicios-apply.cfm" onsubmit="javascript: return validar(this);">
		<cfinclude template="gestion-hiddens.cfm">
		
			<cfif listLen(lista)>
				<table width="100%" border="0" cellspacing="0" cellpadding="2">	  	
					<tr><td colspan="2">
								Elija el servicio que desea agregar, puede asociar el servicio a un nuevo login o elegir alg&uacute;n 
									login existente en el paquete actual.
					</td></tr>
					<tr><td colspan="2" align="center">
						<table  width="100%" border="0" cellpadding="2" cellspacing="0">
							<tr>
								<td align="right"><label><cf_traducir key="servicio">Servicio</cf_traducir></label></td>
								<td>
								<table border="0" cellspacing="0" cellpadding="0">
								<td width="30%">
									<select name="TScodigo" id="TScodigo" tabindex="1"   onchange="javascript: MuestraTelefono()">
										<cfloop index="TScod" list="#lista#" delimiters=",">
											<cfif #TScod# neq "CABM"> <!---no se debe mostrar el tipo CABM en el combo--->
												<option value="#TScod#">#TScod#</option>
											</cfif>
										</cfloop>
									</select>
								</td>
								<td align="left"><label><cf_traducir key="Inte_Login Principal">Inte Login Principal </cf_traducir></label></td>
								<td>
									<cfif isdefined('LGserids_padre') and Len(LGserids_padre.LGserids)>
										&nbsp;#LGserids_padre.LGserids#
									<cfelse>
										&nbsp;'No se encontr&oacute; Inte'
									</cfif>
								</td>
								</table>
								</td>
							</tr>
							<tr>
								<td align="right"><label><cf_traducir key="login">Login</cf_traducir></label></td>
								<td>
									<table border="0" cellspacing="0" cellpadding="0">	  	
										<tr><td>
											<select name="LGnumero" id="LGnumero" tabindex="1" onchange="javascript: pideLogin()">
												<option value="">-- Nuevo --</option>
												<cfloop query="rsLogs">
													<option value="#rsLogs.LGnumero#">#rsLogs.LGlogin#</option>
												</cfloop>
											</select>
											</td>
											<td id="TDlog" style="display:none">
											<cf_login
												idpersona = "#form.cli#"
												loginid = ""
												value = ""
												form = "form1"
												sufijo = "2"
												Ecodigo = "#session.Ecodigo#"
												Conexion = "#session.DSN#">
										</td></tr>
									</table>
								</td>
							</tr>	
							<tr id="TRtelf">  
								<td align="right"><label><cf_traducir key="tel">Tel&eacute;fono</cf_traducir></label></td>
								<td>
									<cf_campoNumerico name="LGtelefono" decimales="-1" size="18" maxlength="15" value="" tabindex="1">	
								</td>
							</tr>
							<tr>
								<td align="right"><label><cf_traducir key="sobre">Sobre</cf_traducir></label></td>
								<td>
									<cf_sobre
										form = "form1"
										agente = ""
										sufijo = ""
										responsable = "0"
										mostrarNoAsignados = "true"
										Ecodigo = "#session.Ecodigo#"
										Conexion = "#session.DSN#"
										size="18"
									>
								</td>
							</tr>
						</table>
					</td></tr>
					
					<tr><td align="center" colspan="2">
						<cf_botones names="Agregar" values="Agregar">
					</td></tr>
				</table>
			
			<cfelse>
				<table width="100%" border="0" cellspacing="0" cellpadding="2">	  	
					<tr><td align="center">
							<strong>--- No existen servicios por agregar ---</strong>
					</td></tr>
				</table>
			</cfif>
	</form>
	<script language="javascript" type="text/javascript">
		MuestraTelefono();
		function validar(formulario){
			var error_input;
			var error_msg = '';
			if (document.form1.LGnumero.value =="" && document.form1.Login2.value =="") {
				error_msg += "\n - Debe Elegir un login existente o generar uno nuevo.";
			}
			else{
				if (document.form1.LGnumero.value =="" && document.getElementById("img_login_ok2").style.display == 'none')
				error_msg += "\n - Debe validar el login antes de continuar.";
			}
			
			if (document.form1.LGnumero.value =="" && document.form1.Snumero.value =="") {
				error_msg += "\n - Debe elegir un sobre para el nuevo login.";
			}
			
			
			if (document.form1.TScodigo.value == "ACCS")
			{
				if (#rsPaqueteTelf.PQtelefono# == 1)
				{
					var LongTel = document.form1.LGtelefono.value;
			
					if (document.form1.LGtelefono.value =="" 
			    		|| document.form1.LGtelefono.value =="0" 
						|| LongTel.length < 7) 
					{
						error_msg += "\n - Debe digitar un teléfono válido.";
					}
				}
			}
						
			<!--- Validacion terminada --->
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				if (error_input && error_input.focus) error_input.focus();
				return false;
			}
			return true;
		}
		function pideLogin(){
			if(document.form1.LGnumero){
				if (document.form1.LGnumero.value == ""){
					document.getElementById("TDlog").style.display = "";
				}
				else{
					document.getElementById("TDlog").style.display = "none";
				}
			}
		}

		function MuestraTelefono()
		{
			if (document.form1.TScodigo.value == "ACCS")
			{
				if (#rsPaqueteTelf.PQtelefono# == 1)
					document.getElementById("TRtelf").style.display = "";
				else
					document.getElementById("TRtelf").style.display = "none";
			}
			else
			{
				document.getElementById("TRtelf").style.display = "none";
			}
		}
			


		pideLogin();
	</script>
</cfoutput>