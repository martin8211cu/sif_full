<cfinclude template="aprobacion-params.cfm">
<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>

	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		
		<cfif isdefined("Form.CTid") and Len(Trim(Form.CTid))>
			<cfif Form.paso EQ 4>
				<!--- Datos del deposito de Garantia para cada contrato(paquete) asociado a la cuenta--->
				<cfquery name="rsGarant" datasource="#Session.DSN#">
					select b.Gid, b.EFid, b.Miso4217, b.Gtipo, b.Gref, b.Gmonto, b.Ginicio, b.Gvence, b.Gcustodio, b.Gestado, b.Gobs,
						   c.PQcodigo, c.PQnombre, a.Contratoid,
						   0 as montoPaga, '' as moneda, 1 as tipoCambio
					from ISBproducto a
						inner join ISBgarantia b
							on b.Contratoid = a.Contratoid
						inner join ISBpaquete c
							on c.PQcodigo = a.PQcodigo
					where a.CTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CTid#">
						and a.CTcondicion = '0'
				</cfquery>
				<cfif rsGarant.RecordCount GT 0>
					<!--- Averiguar el monto a pagar para cada contrato(paquete) asociado a la cuenta --->
					<cfloop query="rsGarant">
						<cfinvoke component="saci.comp.WSinvoke" method="Get_DepositoGarantia"
							returnvariable="retGarantia"
							PQcodigo="#rsGarant.PQcodigo#"
							Contratoid="#rsGarant.Contratoid#"/>
						<cfset rsGarant.montoPaga = retGarantia.monto>
						<cfset rsGarant.moneda = retGarantia.moneda>
						<cfset rsGarant.tipoCambio = retGarantia.tipoCambio>
					</cfloop>
				</cfif>
			</cfif>
		</cfif>
		
		<br />
		<cfoutput>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr>
				<td valign="top" style="padding-right: 5px;">
					<cfquery name="rsAgenteCuenta" datasource="#session.DSN#">
						select distinct e.AGid 
						from ISBcuenta a
							inner join ISBproducto c
								on  c.CTid = a.CTid
								and c.CTcondicion = '0'	
							inner join ISBvendedor e
								on e.Vid = c.Vid
						where a.CTid = <cfqueryparam value="#form.CTid#" cfsqltype="cf_sql_numeric"> 
					</cfquery>
					
					<form name="form1" method="post" style="margin: 0;" action="aprobacion-apply.cfm" onsubmit="javascript: return validar(this);">
						<input type="hidden" name="Pquien" value="<cfif isdefined("form.Pquien") and Len(Trim(form.Pquien))>#form.Pquien#</cfif>" />
						<input type="hidden" name="AGid" value="<cfif isdefined("rsAgenteCuenta") and Len(Trim(rsAgenteCuenta.AGid))>#rsAgenteCuenta.AGid#</cfif>" />
						<input type="hidden" name="btnRechazar" value="0"/>
						<input type="hidden" name="btnAprobar" value="0"/>						

						<cfinclude template="aprobacion-hiddens.cfm">
						<table width="100%" border="0" cellspacing="0" cellpadding="0">
						  <tr>
							<td>
								<cf_cuenta 
									id = "#Form.CTid#"
									idpersona = "#Form.Pquien#"
									idcontrato = "#form.Contratoid#"
									form = "form1"
									Ecodigo = "#Session.Ecodigo#"
									Conexion = "#Session.DSN#"
									paso = "#Form.paso#"
									vista = "2"
								>
							</td>
						  </tr>
						  <tr>
							<td align="center">
								<cfif form.paso neq 1 and form.paso neq 5>
									<cf_botones names="Guardar" values="Guardar" tabindex="1">
								</cfif>
							</td>
						  </tr>
						</table>
					</form>
				</td>
				<td valign="top" width="210">
					<cfset params_anotaciones = "?CTid=#form.CTid#&Contratoid=#form.Contratoid#&AGid=#form.AGid#">
					<cfinclude template="aprobacion-menu.cfm">
				</td>
			  </tr>
			</table>
			
			<script language="javascript" type="text/javascript">
				function validar(formulario) {
					var error_input;
					var error_msg = '';
					
					if (document.form1.botonSel.value == "Guardar"){	
			
						<cfif Form.paso EQ '1'>
							if (!validarLogines()) {
								error_msg += "\n - Debe validar todos los logines antes de continuar.";
							}
						</cfif>
	
						<cfif Form.paso EQ '3'>
				
							if(document.form1.CTcobro2.checked){
								
								if(document.form1.NumTarjeta.value ==""){
									error_msg += "\n - El Número de Tarjeta es requerido.";
									error_input = document.getElementById("NumTarjeta");
								}
								if(document.form1.MesTarjeta.value ==""){
									error_msg += "\n - El Mes es requerido.";
									error_input = document.getElementById("MesTarjeta");
								}
								if(document.form1.AnoTarjeta.value ==""){
									error_msg += "\n - El Año es requerido.";
									error_input = document.getElementById("AnoTarjeta");
								}
								if(document.form1.MTid.value ==""){
									error_msg += "\n - El Tipo Tarjeta es requerido.";
									error_input = document.getElementById("MTid");
								}
								if(document.form1.VerificaTarjeta.value ==""){
									error_msg += "\n - Los Dígitos de Verificación son requeridos.";
									error_input = document.getElementById("MTid");
								}
								if(document.form1.Ppais.value ==""){
									error_msg += "\n - El País es requerido.";
									error_input = document.getElementById("Ppais");
								}
								if(document.form1.NombreTarjeta.value ==""){
									error_msg += "\n - El Nombre es requerido.";
									error_input = document.getElementById("NombreTarjeta");
								}
								if(document.form1.Apellido1Tarjeta.value ==""){
									error_msg += "\n - El Apellido 1 es requerido.";
									error_input = document.getElementById("Apellido1Tarjeta");
								}
								if(document.form1.Apellido2Tarjeta.value ==""){
									error_msg += "\n - El Apellido 2 es requerido.";
									error_input = document.getElementById("Apellido2Tarjeta");
								}
								if(document.form1.CedulaTarjeta.value ==""){
									error_msg += "\n - La Cédula es requerida.";
									error_input = document.getElementById("CedulaTarjeta");
								} 	
							}
							if(document.form1.CTcobro3.checked){
								
								if(document.form1.CuentaTipo.value ==""){
									error_msg += "\n - El Tipo de Cuenta es requerido.";
									error_input = document.getElementById("CuentaTipo");
								}
								if(document.form1.NumCuenta.value ==""){
									error_msg += "\n - El Número de Cuenta es requerido.";
									error_input = document.getElementById("NumCuenta");
								}
								if(document.form1.EFid.value ==""){
									error_msg += "\n - El Banco es requerido.";
									error_input = document.getElementById("EFid");
								}
								if(document.form1.CedulaCuenta.value ==""){
									error_msg += "\n - La Cédula es requerida.";
									error_input = document.getElementById("CedulaCuenta");
								}					
								if(document.form1.NombreCuenta.value ==""){
									error_msg += "\n - El Nombre es requerido.";
									error_input = document.getElementById("NombreCuenta");
								}
								if(document.form1.Apellido1Cuenta.value ==""){
									error_msg += "\n - El Apellido 1 es requerido.";
									error_input = document.getElementById("Apellido1Cuenta");
								}
								if(document.form1.Apellido2Cuenta.value ==""){
									error_msg += "\n - El Apellido 2 es requerido.";
									error_input = document.getElementById("Apellido2Cuenta");
								}
								
							}
						</cfif>
						
						<cfif Form.paso EQ '4'>
							//toma la fecha actual.
							var d,fecha,hoy = "";		d = new Date();		hoy += (d.getUTCMonth() + 1) + "/";		hoy += d.getUTCDate() + "/";	hoy += d.getUTCFullYear();
							
							<cfloop query="rsGarant">
								if(document.form1.Gtipo_#rsGarant.Gid#.value == '3' || document.form1.Gtipo_#rsGarant.Gid#.value == '9' || document.form1.Gtipo_#rsGarant.Gid#.value == '10'){
									if(document.form1.Gmonto_#rsGarant.Gid#.value == 0){
										error_msg += "\n - El Monto para el producto #rsGarant.PQnombre# es requerido.";
										error_input = document.getElementById("Gmonto_#rsGarant.Gid#");
									}
									if(document.form1.Gmonto_#rsGarant.Gid#.value <  #rsGarant.montoPaga#){
										error_msg += "\n - El Monto para el producto #rsGarant.PQnombre# debe ser mayor al monto a pagar.";
										error_input = document.getElementById("Gmonto_#rsGarant.Gid#");
									}
									if(document.form1.EFid_#rsGarant.Gid#.value ==""){
										error_msg += "\n - El Banco para el producto #rsGarant.PQnombre# es requerido.";
										error_input = document.getElementById("EFid_#rsGarant.Gid#");
									}
									if(document.form1.Gref_#rsGarant.Gid#.value ==""){
										error_msg += "\n - La Referencia para el producto #rsGarant.PQnombre# es requerida.";
										error_input = document.getElementById("Gref_#rsGarant.Gid#");
									}
									if(document.form1.Ginicio_#rsGarant.Gid#.value ==""){
										error_msg += "\n - La Fecha para el producto #rsGarant.PQnombre# es requerida.";
										error_input = document.getElementById("Ginicio_#rsGarant.Gid#");
									}
									else{
										var f=document.form1.Ginicio_#rsGarant.Gid#.value; //mascara de fecha actual dd/mm/yyyy
										fecha = f.charAt(3)+f.charAt(4) +'/'+ f.charAt(0)+f.charAt(1) +'/'+ f.charAt(6)+f.charAt(7)+f.charAt(8)+f.charAt(9);//mascara nueva mm/dd/yyyy
										if( Date.parse(hoy) < Date.parse(fecha)){
											error_msg += "\n - La Fecha para el producto #rsGarant.PQnombre# debe ser menor a la fecha de hoy.";
											error_input = document.getElementById("Ginicio_#rsGarant.Gid#");
										}
									}
								}
							</cfloop>
						</cfif>
					}
					// Validacion terminada
					if (error_msg.length != "") {
						alert("Por favor revise los siguiente datos:"+error_msg);
						if (error_input && error_input.focus) error_input.focus();
						return false;
					}
					return true;
				}
			</script>
		
		</cfoutput>
	<cf_web_portlet_end> 

<cf_templatefooter>
