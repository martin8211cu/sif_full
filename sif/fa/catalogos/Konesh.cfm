
<cfset p = createObject("component", "sif.Componentes.Parametros")>
<!---  Datos de Conexi�n  con  el  PAC Konesh  --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH 		= t.Translate('LB_TituloH','SIF - Konesh')>
<cfset TIT_ReptK	= t.Translate('','Parametros de Conexion Konesh')>
<cfset LB_Url		= t.Translate('LB_Url','URL')>
<cfset LB_Cta		= t.Translate('LB_Cta','Cuenta')>
<cfset LB_User		= t.Translate('LB_User','Usuario')>
<cfset LB_Pass		= t.Translate('LB_Pass','Password')>
<cfset LB_tkn		= t.Translate('LB_tkn','Token')>
<cfset BTN_Agregar   = t.Translate('BTN_Agregar','Agregar')>


<!---<cfset useFactus = p.Get(
	Pcodigo = "4410",
	mcodigo = "FA",
	pdescripcion = "Usar Factus como servicio de Timbrado"
)>
<cfset URLv_factus = p.Get(
	Pcodigo = "4411",
	mcodigo = "FA",
	pdescripcion = "Url base"
)>
<cfset tkn_factus = p.Get(
	Pcodigo = "4412",
	mcodigo = "FA",
	pdescripcion = "APIKey Factus"
)>--->
<cfset URLv = p.Get(
	Pcodigo = "440",
	mcodigo = "FA",
	pdescripcion = "Url Konesk"
)>
<cfset Cta = p.Get(
	Pcodigo = "442",
	mcodigo = "FA",
	pdescripcion = "Cuenta Konesh"
)>
<cfset usuario = p.Get(
	Pcodigo = "443",
	mcodigo = "FA",
	pdescripcion = "Usuario Konesh"
)>
<cfset pass = p.Get(
	Pcodigo = "444",
	mcodigo = "FA",
	pdescripcion = "Contraseña Konesh"
)>
<cfset tkn = p.Get(
	Pcodigo = "445",
	mcodigo = "FA",
	pdescripcion = "Token Konesh"
)>

<cfset modo = "CAMBIO">

<cf_templateheader title="#LB_TituloH#">
<cfinclude template="../../portlets/pNavegacionCC.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#TIT_ReptK#'>
  <cfinclude template="../../cg/consultas/Funciones.cfm">
  <script language="JavaScript1.2" type="text/javascript" src="../../js/sinbotones.js"></script>
  <cfset periodo="#get_val(50).Pvalor#">
  <cfset mes="#get_val(60).Pvalor#">
<form name="form1" method="get" action="SQLRegistroKonesh.cfm" onsubmit="return validaOption();">
	<div class="row">
		&nbsp;
	</div>
	<div class="row">
		<div class="col-md-5">
			<div class="form-group">
				<!---<label for="servicioTimbre">Servicio de Timbrado</label>
				<select class="form-control" name="servicioTimbre" id="servicioTimbre">
					<option value="">Por defecto</option>
					<option value="FACTUS" <cfif useFactus eq "FACTUS"> selected</cfif>>FACTUS</option>
				</select>--->
				<div class="is">
					<div class="form-group">
						<cfoutput>
							<label for="Urlv">#LB_Url#</label>
							<input class="form-control" id="Urlv" name="Urlv" type="text" title="Solo Letras y Numeros" value="#URLv#" size="80" maxlength="100" />
						</cfoutput>
					</div>
					<div class="form-group">
						<cfoutput>
							<label for="Cuenta">#LB_Cta#</label>
							<input class="form-control" id="Cuenta" name="Cuenta" type="text" title="Solo Letras y Numeros" value="#Trim(Cta)#" size="15" maxlength="15" />
						</cfoutput>
					</div>
					<div class="form-group">
						<cfoutput>
							<label for="usuario">#LB_User#</label>
							<input class="form-control" id="usuario" name="usuario" type="text" title="Solo Letras y Numeros" value="#usuario#" size="15" maxlength="15" />
						</cfoutput>
					</div>
					<div class="form-group">
						<cfoutput>
							<label for="pass">#LB_Pass#</label>
							<input class="form-control" id="pass" name="pass" type="password" title="Solo Letras y Numeros" value="#pass#" size="15" maxlength="15" />
						</cfoutput>
					</div>
					<div class="form-group">
						<cfoutput>
							<label for="tkn">#LB_tkn#</label>
							<input class="form-control" id="tkn" name="tkn" type="text" title="Solo Letras y Numeros" value="#tkn#" size="15" maxlength="15" />
						</cfoutput>
					</div>
				</div>
				<!---<div class="isFACTUS">
					<div class="form-group">
						<cfoutput>
							<label for="Urlv_factus">#LB_Url#</label>
							<input class="form-control" id="Urlv_factus" name="Urlv_factus" type="text" title="Solo Letras y Numeros" value="#URLv_factus#" size="80" maxlength="100" />
						</cfoutput>
					</div>
					<div class="form-group">
						<cfoutput>
							<label for="tkn_factus">#LB_tkn#</label>
							<input class="form-control" id="tkn_factus" name="tkn_factus" type="password" title="Solo Letras y Numeros" value="#tkn_factus#" size="15" maxlength="50" />
						</cfoutput>
					</div>
				</div>--->	
			</div>
		</div>
	</div>
	<div class="row">
		
	</div>
	<div class="row">
		<div align="center">
			<cfif modo EQ "ALTA">
			<cfoutput>
				<input name="Agregar" class="btnGuardar"  tabindex="1" type="submit" value="#BTN_Agregar#" >
			</cfoutput>
			<cfelse>
				<input name="Modificar" class="btnGuardar"  tabindex="1" type="submit" value="Modificar">
				<!--- <input name="Borrar" class="btnEliminar"  tabindex="1" type="submit" value="Eliminar"> --->
			</cfif>
		</div>
	</div>
</form>
<script>

	function validaOption(){
	mensa = "";
		if (document.form1.servicioTimbre.value == "") {
			if(document.form1.Urlv.value == ""){
				mensa = "\n- Es necesario indicar el URL";
			}

			if(document.form1.Cuenta.value == ""){
				mensa =mensa + "\n- Es necesario indicar la Cuenta";
			}

			if(document.form1.usuario.value == ""){
				mensa =mensa + "\n- Es necesario indicar el Usuario";
			}

			if(document.form1.pass.value == ""){
				mensa =mensa + "\n- Es necesario indicar el Password";
			}

			if(document.form1.tkn.value == ""){
				mensa =mensa + "\n- Es necesario indicar el Token";
			}

			if(mensa != ""){
				alert("Se presentaron los siguientes errores: \n" + mensa);
				return false;
			}
		} else {
			if(document.form1.Urlv_factus.value == ""){
				mensa = "\n- Es necesario indicar el URL";
			}

			if(document.form1.tkn_factus.value == ""){
				mensa =mensa + "\n- Es necesario indicar el Token";
			}

			if(mensa != ""){
				alert("Se presentaron los siguientes errores: \n" + mensa);
				return false;
			}
		}

	}
</script>

<!---<script>
	$('[class^=is]').hide();

	<cfoutput>
		var theDiv = $(".is#useFactus#");

		theDiv.show();
	</cfoutput>

	$("#servicioTimbre").change(function(){          
		var value = $("#servicioTimbre option:selected").val();
		var theDiv = $(".is" + value);

		theDiv.slideDown();
		theDiv.siblings('[class^=is]').slideUp();
	});
</script>--->


<cf_web_portlet_end>
<cf_templatefooter>