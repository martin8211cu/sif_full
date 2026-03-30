<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery name="rsLista" datasource="#session.dsn#">
	SELECT 	convert(varchar,a.DEid) as DEid, 
			convert(varchar,a.AFAid) as AFAid, 
			case 
				when (datalength(a.AFAdescripcion) > 30) then substring(a.AFAdescripcion,1,27) #_Cat# '...' 
				else a.AFAdescripcion 
			end as descripcion,
			convert(varchar(100), a.AFAdescripcion) as AFAdescripcion, 
			a.AFMid,
			b.AFMcodigo,
			b.AFMdescripcion,
			a.AFMMid,
			c.AFMMcodigo,
			c.AFMMdescripcion,
			AFAserie,
			AFAplaca,
			AFAmonto,
			ACmascara,
			case when AFAplaca is null then AFAid else 0 end as checked
	FROM AFAdquisicion a, AFMarcas b, AFMModelos c, ACategoria d
	WHERE a.AFMid = b.AFMid 
			and a.Ecodigo = b.Ecodigo 
			
			and a.AFMMid = c.AFMMid 
			and a.Ecodigo = c.Ecodigo 
			
			and a.ACcodigo = d.ACcodigo
			and a.Ecodigo = d.Ecodigo
			
			and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and a.AFAstatus = 10
</cfquery>
<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>
<!--- iframe para ejecutar validación especial de la placa --->
<iframe frameborder="0" name="fr" height="0" width="0" src="adquisicion-valplacas.cfm"></iframe>
<!--- Invocación de JavaScript --->
<script language="JavaScript1.2" type="text/javascript" src="../../js/utilesMonto.js"></script>
<table width="95%" align="center" border="0" cellspacing="0">
	<cfoutput>
	<tr>
		<td nowrap colspan="4">
			<table width="100%" align="center" border="0" cellspacing="0">
				<tr>
					<td nowrap class="tituloListas">Descripci&oacute;n</td>
					<td nowrap class="tituloListas">
						<table width="100%" border="0" cellspacing="0">
			  				<tr>
								<td nowrap class="tituloListas" width="50%">Marca</td>
								<td nowrap class="tituloListas" width="50%">Modelo</td>
			  				</tr>
						</table>
					</td>
					<td nowrap class="tituloListas">Placa</td>
					<td nowrap class="tituloListas">&nbsp;</td>
	 			  <td nowrap class="tituloListas">&nbsp;</td>
				</tr>
	  
	  			<form action="vales_aprobacion_sql.cfm" method="post" name="form1">
					<input name="AFAid" type="hidden" value="">
					<input name="DEid" type="hidden" value="#form.DEid#">
					<input name="aprobacion" type="hidden" value="aprobacion">
					<tr>
						<td nowrap>
							<input name="AFAdescripcion" type="text" size="47" maxlength="100" value="" tabindex="100">
						</td>
						<td nowrap>
							<cf_sifMarcaMod nameMar="AFMcodigo" 
											descMar="AFMdescripcion"
											keyMar="AFMid"
											tabindexMar="101"
											nameMod="AFMMcodigo"
											descMod="AFMMdescripcion"
											keyMod="AFMMid"
											tabindexMod="102"
											size="30"
											orientacion="H" >
						</td>
						<td nowrap>
							<input type="text" name="AFAplaca" size="15" maxlength="20" style="text-transform:uppercase" onBlur="javascript:ValidarPlaca(document.form1.AFAplaca.value);">
							<input type="text" name="AFAplaca_text" size="20" disabled readonly="true" class="cajasinbordeb">
						</td>
						<td nowrap>
							<input name="btncambiar" id="btncambiar" type="submit" value="Modificar" tabindex="104" disabled="true">
							<input name="btnlimpiar" id="btnlimpiar" type="reset" value="Limpiar" tabindex="104" onClick="javascript:deshabilitar();">
						</td>
		  			<td nowrap><img src="../../imagenes/findsmall.gif" alt="Ver Ficha" width="16" height="16" onClick="fnVer();"></td>
					</tr>
	  			</form>		
			</table>
		</td>
	</tr>
	</cfoutput>
	  
	<tr>
		<td nowrap colspan="4">
			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
				<cfinvokeargument name="query" value="#rsLista#"/>
				<cfinvokeargument name="desplegar" value="descripcion, AFMdescripcion, AFMMdescripcion, AFAserie, AFAplaca, ACmascara, AFAmonto"/>
				<cfinvokeargument name="etiquetas" value="Descripción, Marca, Modelo, Serie, Placa, Mascara, Monto"/>
				<cfinvokeargument name="formatos" value="S, S, S, S, S, S, M"/>
				<cfinvokeargument name="align" value="left, left, left, left, left, left, right"/>
				<cfinvokeargument name="ajustar" value="N"/>
				<cfinvokeargument name="irA" value="vales_aprobacion_sql.cfm"/>
				<cfinvokeargument name="checkBoxes" value="S"/>
				<cfinvokeargument name="botones" value="Rechazar, Aprobar"/>
				<cfinvokeargument name="funcion" value="fngo"/>
				<cfinvokeargument name="fparams" value="AFAid, AFAdescripcion, AFMid, AFMcodigo, AFMdescripcion, AFMMid, AFMMcodigo, AFMMdescripcion, AFAplaca, ACmascara"/>
				<cfinvokeargument name="formname" value="lista"/>
				<cfinvokeargument name="keys" value="AFAid"/>
				<cfinvokeargument name="inactivecol" value="checked"/>
				<cfinvokeargument name="showLink" value="true"/>
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
			</cfinvoke>
			<p style="text-transform:uppercase; color:#FF0000" align="center">Debe asignar placa al activo antes de Aprobar.</p>
		</td>
	</tr>
</table>
	
<cf_qforms>
	
<!--- Validaciones c/ Qforms --->
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	//AFAdescripcion
	objForm.AFAdescripcion.required = true;
	objForm.AFAdescripcion.description = "Descripción";
	//AFMid
	objForm.AFMcodigo.required = true;
	objForm.AFMcodigo.description="Marca";
	//AFMMid
	objForm.AFMMcodigo.required = true;
	objForm.AFMMcodigo.description="Modelo";
	//AFAplaca
	objForm.AFAplaca.trim();
	objForm.AFAplaca.toUpperCase();
	objForm.AFAplaca.required = true;
	objForm.AFAplaca.validate=true;
	objForm.AFAplaca.description="Placa";
	// crea el objeto Mask	
	oStringMask = new Mask("");
	oStringMask.attach(objForm.AFAplaca.obj,oStringMask.mask,"string","ValidarPlaca(document.form1.AFAplaca.value);");

	// Funciones 
	function fngo(AFAid, AFAdescripcion, AFMid, AFMcodigo, AFMdescripcion, AFMMid, AFMMcodigo, AFMMdescripcion, AFAplaca, ACmascara) {
		document.form1.AFAid.value = AFAid;
		document.form1.AFAdescripcion.value = AFAdescripcion;
		document.form1.AFMid.value = AFMid;
		document.form1.AFMcodigo.value = AFMcodigo;
		document.form1.AFMdescripcion.value = AFMdescripcion;
		document.form1.AFMMid.value = AFMMid;
		document.form1.AFMMcodigo.value = AFMMcodigo;
		document.form1.AFMMdescripcion.value = AFMMdescripcion;
		document.form1.AFAplaca.value = AFAplaca;
		habilitar();
		CambiarMascara(ACmascara,AFAplaca);
		document.form1.AFAdescripcion.focus();
	}
		function algunoMarcado() {
		if (document.lista.chk) {
			if (document.lista.chk.value) {
				return (document.lista.chk.checked);
			} else {
				for (var i=0; i<document.lista.chk.length; i++) {
					if (document.lista.chk[i].checked) return true;
				}
			}
		}
		return false;
	}
	
	function funcRechazar() {
		if (algunoMarcado()){
			if (confirm('¿Desea rechazar los registros seleccionados?')) {
				document.lista.DEID.value = "<cfoutput>#form.DEid#</cfoutput>";	
				return true;
			}
		}
		else
			alert("Debe seleccionar al menos un registro para procesar!");
		return false;
	}
	
	
	function funcAprobar() {
		if (algunoMarcado()){
			if (confirm('¿Desea aprobar los registros seleccionados?')) {
				document.lista.DEID.value = "<cfoutput>#form.DEid#</cfoutput>";	
				return true;
			}
		}
		else
			alert("Debe seleccionar al menos un registro para procesar!");
		return false;
	}
	
	function CambiarMascara(mascara,valor){
		objForm.AFAplaca.obj.value="";
		objForm.AFAplaca_text.obj.value="";

		if (mascara.length > 0) {
			var strErrorMsg="El valor de la placa no concuerda con el formato "+mascara;

			oStringMask.mask = mascara.replace(/X/g,"#");
			
			objForm.AFAplaca.obj.disabled=false;
			objForm.AFAplaca_text.obj.value=mascara.replace(/X/g,"#");
			return true;
		}
		objForm.AFAplaca.obj.disabled=true;
		objForm.AFAplaca.obj.value=valor;
	}
	
	function ValidarPlaca(placa) {
		document.all["fr"].src="adquisicion-valplacas.cfm?name=AFAplaca&placa="+placa;
	}
	
	function fnVer(){
		if (document.form1.AFAid.value!=""){
			document.form1.action = "vales_aprobacion.cfm";
			document.form1.submit();
		}
		else
			alert("Debe seleccionar un item de la lista de abajo para ver su ficha!");
	}
	
	function habilitar() {
		document.form1.btncambiar.disabled = false;
		document.form1.AFAdescripcion.disabled = false;
		document.form1.AFMcodigo.disabled = false;
		document.form1.AFMMcodigo.disabled = false;
		document.form1.AFAplaca.disabled = false;
	}
	
	function deshabilitar() {
		document.form1.btncambiar.disabled = true;
		document.form1.AFAdescripcion.disabled = true;
		document.form1.AFMcodigo.disabled = true;
		document.form1.AFMMcodigo.disabled = true;
		document.form1.AFAplaca.disabled = true;
	}
	
	deshabilitar();
	//-->
</script>
