<cfif not isdefined("Form.modo") and isdefined("url.modo")>
	<cfset form.modo=url.modo>
</cfif>
<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfif not isdefined("Form.modo") and not isdefined ('URL.Nuevo') and not isdefined ('form.Nuevo')>
	<cfset form.modo=url.modo>
</cfif>


<cfset LvarIDSg="">
<cfset LvarIDSg2="">
<cfset LvarIDSg3="">
<cfset LvarIDLin="">
<cfset LvarIDLin2="">
<cfset LvarIDLin3="">
<cfset LvarIDLin4="">
<cfset LvarUnidades="">
<cfset LvarIniciales1=false>
<cfset LvarIniciales2=false>
<cfset LvarIniciales3=false>
<cfset LvarIniciales4=false>
<cfset LvarIniciales5=false>
<cfset LvarIniciales6=false>
<cfset LvarIniciales7=false>
<cfset LvarIniciales=false>


<cfif not isdefined ('form.MIGProid') and isdefined ('url.MIGProid') and trim(url.MIGProid) >
	<cfset form.MIGProid=url.MIGProid>
</cfif>

<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsProductos">
		select
				Dactiva,
				MIGProid,
				MIGProesproducto,<!--- P, S--- Producto o Servicio--->
				id_unidad_medida,<!--- Tabla de Unidades SIF--->
				MIGProSegid,
				MIGProSegid2,
				MIGProSegid3,
				MIGProLinid,
				MIGProLinid2,
				MIGProLinid3,
				MIGProLinid4,
				MIGProlinea5,
				MIGPronombre,
				MIGProcodigo,
				MIGProesnuevo,<!--- 0 - 1 Producto nuevo=1 o viejo=0--->
				MIGProplanta<!--- Texto Ingresado por el usuario--->
		from MIGProductos
		where MIGProid= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGProid#">
	</cfquery>

	<cfquery name="Valida" datasource="#Session.DSN#">
		select a.MIGMid, b.MIGMcodigo
		from MIGFiltrosmetricas a
			left join MIGMetricas b
				on a.MIGMid=b.MIGMid
				and a.Ecodigo=b.Ecodigo
		where a.MIGMdetalleid=<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.MIGProid#" >
		and a.MIGMtipodetalle='P'
		and  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
	</cfquery>
<cfif rsProductos.MIGProSegid GT 0>
	<cfset LvarIDSg=rsProductos.MIGProSegid>
	<cfset LvarIniciales1=true>
</cfif>
<cfif rsProductos.MIGProSegid2 GT 0>
	<cfset LvarIDSg2=rsProductos.MIGProSegid2>
	<cfset LvarIniciales2=true>
</cfif>
<cfif rsProductos.MIGProSegid3 GT 0>
	<cfset LvarIDSg3=rsProductos.MIGProSegid3>
	<cfset LvarIniciales3=true>
</cfif>
<cfset LvarIDLin=rsProductos.MIGProLinid>
<cfif rsProductos.MIGProLinid2 GT 0>
	<cfset LvarIDLin2=rsProductos.MIGProLinid2>
	<cfset LvarIniciales4=true>
</cfif>
<cfif rsProductos.MIGProLinid3 GT 0>
	<cfset LvarIDLin3=rsProductos.MIGProLinid3>
		<cfset LvarIniciales5=true>
</cfif>
<cfif rsProductos.MIGProLinid4 GT 0>
	<cfset LvarIDLin4=rsProductos.MIGProLinid4>
		<cfset LvarIniciales6=true>
</cfif>
<cfif rsProductos.id_unidad_medida NEQ "">
	<cfset LvarUnidades=trim(rsProductos.id_unidad_medida)>
		<cfset LvarIniciales7=true>
</cfif>
	<cfset LvarIniciales=true>

</cfif>
<cfoutput>
	<form method="post" name="form1" action="ProductosSQL.cfm" onSubmit="return validar(this);">
	<table align="center">
		<tr valign="baseline">
			<td nowrap align="right">C&oacute;digo Producto:</td>
			<td align="left">
				<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsProductos.MIGProcodigo)#
					<input type="hidden" name="MIGProid" id="MIGProid" value="#rsProductos.MIGProid#">
				<cfelse>
					<input type="text" name="MIGProcodigo" id='MIGProcodigo' maxlength="20" value="" size="32" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
			<td align="right">Segmento 1:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Segmentos"
						tabla="MIGProSegmentos a"
						columnas="a.MIGProSegid as SgID,a.MIGProSegcodigo as SgCod, a.MIGProSegdescripcion as SgDesp"
						campos = "SgID, SgCod,SgDesp"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						filtro="a.Ecodigo=#session.Ecodigo#"
						desplegar="SgCod, SgDesp"
						etiquetas="Codigo,Nombre"
						formatos="S,S"
						align="left,left"
						traerInicial="#LvarIniciales1#"
						traerFiltro="MIGProSegid=#LvarIDSg#"
						filtrar_por="MIGProSegcodigo,MIGProSegdescripcion"
						tabindex="1"
						fparams="SgID"
						/>
			</td>
		</tr>
		<tr>
			<td nowrap align="right">Nombre Producto:</td>
			<td align="left"><input type="text" name="MIGPronombre" id='MIGPronombre' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsProductos.MIGPronombre)#</cfif>" size="32" tabindex="1" onFocus="javascript: this.select();"></td>
			<td align="right">Segmento 2:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Segmentos"
						tabla="MIGProSegmentos b"
						columnas="b.MIGProSegid as SgID2,b.MIGProSegcodigo as SgCod2, b.MIGProSegdescripcion as SgDesp2"
						campos = "SgID2, SgCod2,SgDesp2"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						filtro="b.Ecodigo=#session.Ecodigo#"
						desplegar="SgCod2, SgDesp2"
						etiquetas="Codigo,Nombre"
						formatos="S,S"
						align="left,left"
						traerInicial="#LvarIniciales2#"
						traerFiltro="MIGProSegid=#LvarIDSg2#"
						filtrar_por="MIGProSegcodigo,MIGProSegdescripcion"
						tabindex="1"
						fparams="SgID2"
						/>
			</td>
		</tr>
		<tr>
			<td align="right">Primera L&iacute;nea de Negocio:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Líneas"
						tabla="MIGProLineas d"
						columnas="d.MIGProLinid as LID,d.MIGProLincodigo as LCod, d.MIGProLindescripcion as Ldes"
						campos = "LID, LCod,Ldes"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						filtro="d.Ecodigo=#session.Ecodigo#"
						desplegar="LCod, Ldes"
						etiquetas="Codigo,Nombre"
						formatos="S,S"
						align="left,left"
						traerInicial="#LvarIniciales#"
						traerFiltro="MIGProLinid=#LvarIDLin#"
						filtrar_por="MIGProLincodigo,MIGProLindescripcion"
						tabindex="1"
						fparams="LID"
						/>
			</td>
			<td align="right">Segmento 3:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Segmentos"
						tabla="MIGProSegmentos c"
						columnas="c.MIGProSegid as SgID3,c.MIGProSegcodigo as SgCod3, c.MIGProSegdescripcion as SgDesp3"
						campos = "SgID3, SgCod3,SgDesp3"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						filtro="c.Ecodigo=#session.Ecodigo#"
						desplegar="SgCod3, SgDesp3"
						etiquetas="Codigo,Nombre"
						formatos="S,S"
						align="left,left"
						traerInicial="#LvarIniciales3#"
						traerFiltro="MIGProSegid=#LvarIDSg3#"
						filtrar_por="MIGProSegcodigo,MIGProSegdescripcion"
						tabindex="1"
						fparams="SgID3"
						/>
			</td>
		</tr>
		<tr>

			<td align="right">Segunda L&iacute;nea de Negocio:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Líneas"
						tabla="MIGProLineas e"
						columnas="e.MIGProLinid as LID2,e.MIGProLincodigo as LCod2, e.MIGProLindescripcion as Ldes2"
						campos = "LID2, LCod2,Ldes2"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						filtro="e.Ecodigo=#session.Ecodigo#"
						desplegar="LCod2, Ldes2"
						etiquetas="Codigo,Nombre"
						formatos="S,S"
						align="left,left"
						traerInicial="#LvarIniciales4#"
						traerFiltro="MIGProLinid=#LvarIDLin2#"
						filtrar_por="MIGProLincodigo,MIGProLindescripcion"
						tabindex="1"
						fparams="LID2"
						/>
			</td>
			<td align="right">Unidades:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Unidades"

						tabla="Unidades"
						columnas="Ecodigo, Ucodigo, Udescripcion"
						campos = "Ecodigo, Ucodigo, Udescripcion"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						filtro="Ecodigo=#session.Ecodigo#"
						desplegar="Ucodigo, Udescripcion"
						etiquetas="Codigo,Descripci&oacute;n"
						formatos="S,S"
						align="left,left"
						traerInicial="#LvarIniciales7#"
						traerFiltro="Ucodigo='#LvarUnidades#'"
						filtrar_por="Ucodigo,Udescripcion"
						tabindex="1"
						fparams="Ucodigo,Ecodigo"
						/>
			</td>
		</tr>
		<tr>
			<td align="right">Tercera L&iacute;nea de Negocio:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Líneas"
						tabla="MIGProLineas f"
						columnas="f.MIGProLinid as LID3,f.MIGProLincodigo as LCod3, f.MIGProLindescripcion as Ldes3"
						campos = "LID3, LCod3,Ldes3"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						filtro="f.Ecodigo=#session.Ecodigo#"
						desplegar="LCod3, Ldes3"
						etiquetas="Codigo,Nombre"
						formatos="S,S"
						align="left,left"
						traerInicial="#LvarIniciales5#"
						traerFiltro="f.MIGProLinid=#LvarIDLin3#"
						filtrar_por="MIGProLincodigo,MIGProLindescripcion"
						tabindex="1"
						fparams="LID3"
						/>
			</td>
			<td nowrap="nowrap" align="right">Planta Producci&oacute;n:</td>
			<td nowrap="nowrap" align="left"><input type="text" name="MIGProplanta" id='MIGProplanta' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsProductos.MIGProplanta)#</cfif>" size="50" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<tr>
			<td align="right">Cuarta L&iacute;nea de Negocio:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Líneas"
						tabla="MIGProLineas g"
						columnas="g.MIGProLinid as LID4,g.MIGProLincodigo as LCod4, g.MIGProLindescripcion as Ldes4"
						campos = "LID4, LCod4,Ldes4"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						filtro="g.Ecodigo=#session.Ecodigo#"
						desplegar="LCod4, Ldes4"
						etiquetas="Codigo,Nombre"
						formatos="S,S"
						align="left,left"
						traerInicial="#LvarIniciales6#"
						traerFiltro="MIGProLinid=#LvarIDLin4#"
						filtrar_por="MIGProLincodigo,MIGProLindescripcion"
						tabindex="1"
						fparams="LID4"
						/>
			</td>
			<td align="right" nowrap="nowrap">Estado:</td>
			<td align="left" nowrap="nowrap">
				<select name="Dactiva" id="Dactiva" <cfif modo EQ 'CAMBIO' and Valida.recordCount GT 0>disabled="disabled" </cfif>>
					<option value="">-&nbsp;-&nbsp;-</option>
					<option value="0"<cfif modo EQ 'CAMBIO'and rsProductos.Dactiva EQ 0>selected="selected"</cfif>>Inactiva </option>
					<option value="1"<cfif modo EQ 'CAMBIO'and rsProductos.Dactiva EQ 1>selected="selected"</cfif>>Activa</option>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right">Quinta L&iacute;nea de Negocio:</td>
			<td align="left" nowrap="nowrap" ><input type="text" name="MIGProlinea5" id='MIGProlinea5' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsProductos.MIGProlinea5)#</cfif>" size="50" tabindex="1" onFocus="javascript: this.select();"></td>
		</tr>
		<tr>
			<td align="left">
				<fieldset>
					<legend>
						<strong>Tipos</strong>
							<table>
								<tr>
									<td align="right" nowrap="nowrap" > Producto:<input name="MIGProesproducto" type="radio" value="P" id="MIGProesproducto" <cfif modo NEQ 'ALTA' and rsProductos.MIGProesproducto EQ "P">checked="checked"<cfelse>checked="checked"</cfif>/>Sevicio:<input name="MIGProesproducto" type="radio" value="S" id="MIGProesproducto" <cfif modo NEQ 'ALTA' and rsProductos.MIGProesproducto EQ "S">checked="checked"</cfif> /></td>
								</tr>
							</table>
					</legend>
				</fieldset>
			 </td>
			 <td align="left">
				<fieldset>
					<legend>
						<strong>Producto Existente</strong>
							<table align="left">
								<tr>
									<td align="right" nowrap="nowrap" >Producto Existente:<input name="MIGProesnuevo" type="radio" value="0" id="MIGProesnuevo" <cfif modo NEQ 'ALTA' and rsProductos.MIGProesnuevo EQ 0>checked="checked"<cfelse>checked="checked"</cfif>/> Producto Nuevo:<input name="MIGProesnuevo" type="radio" value="1" id="MIGProesnuevo" <cfif modo NEQ 'ALTA' and rsProductos.MIGProesnuevo EQ 1>checked="checked"</cfif>/></td>
								</tr>
							</table>
					</legend>
				</fieldset>
			 </td>
		</tr>

		<tr><td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td></tr>
		<tr>
			<td colspan="6" align="center" nowrap><cf_botones modo="#modo#" include="Lista" tabindex="1"></td>
		</tr>

	</table>
	</form>
</cfoutput>

<!---ValidacionesFormulario--->

<script type="text/javascript">
function validar(formulario)	{
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('Lista',document.form1) && !btnSelected('Importar',document.form1)){
		var error_input;
		var error_msg = '';
	<cfif modo EQ 'ALTA'>
		Codigo = document.form1.MIGProcodigo.value;
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
		if (Codigo.length==0){
			error_msg += "\n - El código no puede quedar en blanco.";
			error_input = formulario.MIGProcodigo;
		}
	</cfif>
		desp = document.form1.MIGPronombre.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		if (desp.length==0){
			error_msg += "\n - El nombre del Producto no puede quedar en blanco.";
			error_input = formulario.MIGPronombre;
		}

		if (formulario.LID.value == "") {
			error_msg += "\n - La Primera Línea de Negocio no puede quedar en blanco.";
			error_input = formulario.LID;
		}
		if (formulario.Dactiva.value == "") {
			error_msg += "\n - El Estado del Producto no puede quedar en blanco.";
			error_input = formulario.Dactiva;
		}

		var validos = /^[a-zA-Z0-9_\_\[]+$/i;
		if (!validos.test(formulario.MIGProcodigo.value)){
			error_msg += "\n - El código no puede contener caracteres especiales.";
			error_input = formulario.MIGProcodigo;
		}

		//no números en el primer caracter del dato codigo
		var firts = parseInt(formulario.MIGProcodigo.value.charAt(0));
		if (!isNaN(firts)){
			error_msg += "\n - El código no puede iniciar con numeros.";
			error_input = formulario.MIGProcodigo;
		}

	// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>




