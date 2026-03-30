<!---

 --->
 <!--- VARIABLES DE TRADUCCION --->
 <cfinvoke key="BTN_formular" default="Formular" returnvariable="BTN_formular" component="sif.Componentes.Translate" method="Translate"/>
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
<cfset LvarInclude="">
<cfset LvarIDR="">
<cfset LvarID="">
<cfset LvarReadOnly=false>
<cfset LvarIniciales=false>

<cfparam name="pagenum" default="1">
<cfif isdefined('form.pagenum1') and len(trim(form.pagenum1))>
	<cfset pagenum = form.pagenum1>
</cfif>
<cfif isdefined('url.pagenum1') and len(trim(url.pagenum1))>
	<cfset pagenum = url.pagenum1>
</cfif>

<cfif not isdefined ('form.MIGMid') and isdefined ('url.MIGMid') and trim(url.MIGMid) >
	<cfset form.MIGMid=url.MIGMid>
</cfif>


<cfif modo NEQ 'ALTA'>
 <cfset LvarInclude="Formular,Calcular">
 <!--- <cfset LvarInclude="Formular,Calcular,Lista">
 <cfelse>
 	 <cfset LvarInclude="Lista">--->
</cfif>
<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsMetricas">
		select
				MIGMid,
				MIGMcodigo,
				MIGMnombre,
				MIGRecodigo,
				MIGMdescripcion,
				MIGMnpresentacion,
				MIGMsequencia,
				Ucodigo,
				Dactiva,
				MIGMperiodicidad,
				MIGMcalculo
		from MIGMetricas
		where MIGMid= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGMid#">
	</cfquery>

	<cfquery datasource="#Session.DSN#" name="rsResultados">
		select count(MIGMid) as cantidad
		from F_Resultados
		where MIGMid= #form.MIGMid#
	</cfquery>

	<cfquery datasource="#Session.DSN#" name="rsResumen">
		select count(MIGMid) as cantidad
		from F_Resumen
		where MIGMid= #form.MIGMid#
	</cfquery>

	<cfquery name="rsRoles" datasource="asp">	<!---consulta si hay permiso para borrar datos calculados--->
		select Ecodigo, b.SScodigo, b.SRcodigo, Usucodigo, b.SRdescripcion
		from  SRoles b left outer join UsuarioRol a
		on b.SScodigo=a.SScodigo
			and b.SRcodigo=a.SRcodigo
			and a.Ecodigo=#session.ecodigosdc#
			and a.Usucodigo=#session.Usucodigo#
		where b.SScodigo = 'IND'
		  and b.SRinterno = 0
		  and b.SRcodigo = '03'
	</cfquery>
	<cfset BorrarDatosCalculados = false>
	<cfif rsRoles.recordCount gt 0  and len(trim(rsRoles.Usucodigo)) gt 0>
		<cfset BorrarDatosCalculados = true>
	</cfif>

	<cfset LvarIDR=rsMetricas.MIGRecodigo>
	<cfset LvarID=rsMetricas.Ucodigo>
	<cfset LvarIniciales=true>
	<cfset LvarReadOnly=true>
</cfif>

<cfif modo NEQ 'ALTA' and BorrarDatosCalculados>
 <cfset LvarInclude= listAppend(LvarInclude,'Borrar_Calculados',',')>
</cfif>


<cfoutput>
	<cfif isdefined('rsMetricas.MIGMcodigo') and len(trim(rsMetricas.MIGMcodigo))>
		<table cellpadding="0" cellspacing="" border="0" width="100%">
			<tr><td align="center" style=" height:20; background-color:F3F3F3; color:666666"><cfoutput><strong>#rsMetricas.MIGMcodigo# - #rsMetricas.MIGMnombre#</strong></cfoutput></td></tr>
		</table>
	</cfif>
	<cfparam name="url.tab" default="1">
	<cfparam name="form.tab" default="#url.tab#">
	<cfparam name="tabChoice" default="#form.tab#">
	<cf_tabs width="100%">
		<cf_tab text="General" selected="#tabChoice eq 1#">
			<cfinclude template="tabMetricaGeneral.cfm">
		</cf_tab>
		<cfif MODO EQ 'CAMBIO'>
		<cf_tab text="Filtros M&eacute;trica" selected="#tabChoice eq 2#">
			<br>&nbsp;&nbsp;&nbsp;C&oacute;digo M&eacute;trica: #rsMetricas.MIGMcodigo#
			<cfinclude template="tabFiltroMetricaEspecial.cfm">
		</cf_tab>
		<cf_tab text="Filtros Derivadas" selected="#tabChoice eq 3#">
			<br>&nbsp;&nbsp;&nbsp;C&oacute;digo M&eacute;trica: #rsMetricas.MIGMcodigo#
			<cfinclude template="tabFiltroMetricasVariables.cfm">
		</cf_tab>
		</cfif>
	</cf_tabs>

	<center><input type="button" name="irLista" value="Volver a la lista" onclick="javascript: document.location.href= '/cfmx/mig/catalogos/Metricas.cfm?PageNum_lista1=#pagenum#'"/></center>

	<!--- Validaciones por medio de JavaScript --->
	<script type="text/javascript">
		<!--
		function tab_set_current (n){
			<cfif isdefined('form.MIGMid')and len(trim(form.MIGMid))>
				document.location.href='Metricas.cfm?o='+escape(n)+'&tab='+escape(n)+'&sel=1'+'&MIGMid=#form.MIGMid#&MODO=CAMBIO&pagenum1=#pagenum#';
			<cfelse>
				document.location.href='Metricas.cfm?o='+escape(n)+'&tab='+escape(n)+'&sel=1'+'&MODO=ALTA&pagenum1=#pagenum#';
			</cfif>
		}
		//-->
	</script>

</cfoutput>


<!---<cfoutput>
<table border="0" cellpadding="0" cellspacing="0">
<tr valign="baseline"><td>
			<form method="post" name="form1" action="MetricasSQL.cfm" onSubmit="return validar(this);">
	<table border="0">
		<tr valign="baseline">
			<td nowrap align="right">Codigo M&eacute;trica:</td>
			<td align="left">
			<input type="hidden" name="modo" id="modo" value="<cfoutput>#modo#</cfoutput>">
				<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsMetricas.MIGMcodigo)#
					<input type="hidden" name="MIGMid" id="MIGMid" value="#rsMetricas.MIGMid#">
				<cfelse>
					<input type="text" name="MIGMcodigo" id='MIGMcodigo' maxlength="40" value="" size="32" tabindex="1" onFocus="javascript: this.select();">
				</cfif>
			</td>
			<td nowrap align="right">Secuencia M&eacute;trica:</td>
			<td align="left">
				<cfif modo NEQ 'ALTA' and rsMetricas.MIGMsequencia GT 0>
					<cf_inputNumber name="MIGMsequencia"  value="#rsMetricas.MIGMsequencia#" enteros="15" decimales="0" negativos="false" comas="no">
				<cfelse>
					<cf_inputNumber name="MIGMsequencia"  value="" enteros="15" decimales="0" negativos="false" comas="no">
				</cfif>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Nombre M&eacute;trica:</td>
			<td align="left"><input type="text" name="MIGMnombre" id='MIGMnombre' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsMetricas.MIGMnombre)#</cfif>" size="60" tabindex="1" onFocus="javascript: this.select();"></td>
			<td align="right">Responsable:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Responsables"
						campos = "MIGReid, MIGRcodigo,MIGRenombre"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						tabla="MIGResponsables"
						columnas="MIGReid, MIGRcodigo,MIGRenombre"
						filtro="Ecodigo=#session.Ecodigo#"
						desplegar="MIGRcodigo, MIGRenombre"
						etiquetas="Codigo,Nombre"
						formatos="S,S"
						align="left,left"
						traerInicial="#LvarIniciales#"
						traerFiltro="MIGReid='#LvarIDR#'"
						filtrar_por="MIGRcodigo,MIGRenombre"
						tabindex="1"
						Size="0,20,60"
						fparams="MIGReid"
						/>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Presentaci&oacute;n M&eacute;trica:</td>
			<td align="left"><input type="text" name="MIGMnpresentacion" id='MIGMnpresentacion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsMetricas.MIGMnpresentacion)#</cfif>" size="60" tabindex="1" onFocus="javascript: this.select();"></td>
			<td align="right">Unidades:</td>
			<td align="left" nowrap="nowrap" >
				<cf_conlis title="Lista de Unidades"
						campos = "Ecodigo, Ucodigo, Udescripcion"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						tabla="Unidades"
						columnas="Ecodigo, Ucodigo, Udescripcion"
						filtro="Ecodigo=#session.Ecodigo#"
						desplegar="Ucodigo, Udescripcion"
						etiquetas="Codigo,Descripci&oacute;n"
						formatos="S,S"
						Size="0,20,60"
						align="left,left"
						readonly="#LvarReadOnly#"
						traerInicial="#LvarIniciales#"
						traerFiltro="Ucodigo='#LvarID#' and Ecodigo=#session.Ecodigo#"
						filtrar_por="Ucodigo,Udescripcion"
						tabindex="1"
						fparams="Ucodigo,Ecodigo"
						/>
			</td>
		</tr>
		<tr valign="baseline">
			<td nowrap align="right">Descripci&oacute;n M&eacute;trica:</td>
			<td align="left"><input type="text" name="MIGMdescripcion" id='MIGMdescripcion' maxlength="100" value="<cfif modo NEQ 'ALTA'>#htmlEditFormat(rsMetricas.MIGMdescripcion)#</cfif>" size="60" tabindex="1" onFocus="javascript: this.select();"></td>
			<td align="right">Periocidad:</td>
			 <td width="17%">
				 <select name="periocidad" id="periocidad" <cfif modo NEQ 'ALTA'> disabled="disabled"</cfif> >
				 	<option value="D" <cfif modo NEQ "ALTA" and rsMetricas.MIGMperiodicidad EQ "D">selected</cfif> ><cf_translate  key="perio0">Diario</cf_translate></option>
					<option value="W" <cfif modo NEQ "ALTA" and rsMetricas.MIGMperiodicidad EQ "W">selected</cfif> ><cf_translate  key="perio0">Semanal</cf_translate></option>
					<option value="M" <cfif modo NEQ "ALTA" and rsMetricas.MIGMperiodicidad EQ "M">selected</cfif>><cf_translate  key="perio1">Mensual</cf_translate></option>
					<option value="T" <cfif modo NEQ "ALTA" and rsMetricas.MIGMperiodicidad EQ "T">selected</cfif>><cf_translate  key="perio2">Trimestral</cf_translate></option>
					<option value="S" <cfif modo NEQ "ALTA" and rsMetricas.MIGMperiodicidad EQ "S">selected</cfif>><cf_translate  key="perio3">Semestral</cf_translate></option>
					<option value="A" <cfif modo NEQ "ALTA" and rsMetricas.MIGMperiodicidad EQ "A">selected</cfif>><cf_translate  key="perio4">Anual</cf_translate></option>
				  </select>
			  </td>
		</tr>


		<tr><td colspan="2">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</td>
			<td align="right" nowrap="nowrap">Estado:</td>
			<td align="left" nowrap="nowrap" colspan="2">
				<select name="Dactiva" id="Dactiva">
					<option value="">-&nbsp;-&nbsp;-</option>
					<option value="0"<cfif modo EQ 'CAMBIO'and rsMetricas.Dactiva EQ 0>selected="selected"</cfif>>Inactiva </option>
					<option value="1"<cfif modo EQ 'CAMBIO'and rsMetricas.Dactiva EQ 1>selected="selected"</cfif>>Activa</option>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="4" align="center" nowrap><cf_botones modo="#modo#" include="#LvarInclude#"></td>
		</tr>

		</table>
	</form>
	</td></tr>
	<cfif modo EQ "CAMBIO" >
	<tr valign="baseline">
		<td nowrap align="center">
			<table cellpadding="0" cellspacing="0" border="0" align="center">
			<tr valign="baseline">
				<td nowrap><strong>Agrupar por:</strong></td>
				<td nowrap>&nbsp;&nbsp;&nbsp;</td>
			</tr>
			<tr valign="baseline">
				<td nowrap align="center">

					<cfinclude template="MetricasFiltros.cfm">

				</td>
			</tr>
			</table>
		</td></tr>
	</cfif>
	</table>

</cfoutput>--->

<!---ValidacionesFormulario--->

<script type="text/javascript">


	var popUpWinSN=0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWinSN) {
			if(!popUpWinSN.closed) popUpWinSN.close();
		}
		popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onfocus = closePopUp;
	}
	function closePopUp(){
		if(popUpWinSN) {
			if(!popUpWinSN.closed) popUpWinSN.close();
			popUpWinSN=null;
		}
	}
	function doCalculosFiltros(recalcular) {
		var params ="";
		<cfif modo NEQ 'ALTA'>
			<cfoutput>
			params = "?MIGMid=#form.MIGMid#";
			if(recalcular){
				params = params + "&recalcular=true";
			}
			</cfoutput>
			popUpWindow("MetricasCalculaFiltros.cfm"+params,250,200,500,250);
		<cfelse>
			alert('Imposible calculo, primero debe guardar la metrica')
		</cfif>
	}
	function replaceAll( text, busca, reemplaza ){
	   while (text.toString().indexOf(busca) != -1){
		   text = text.toString().replace(busca,reemplaza);
	   }
	   return text;

	}

	function validar(formulario)	{
		if (btnSelected('Borrar_Calculados',document.form1)){
			if( confirm('Esta seguro que desea borrar los datos calculados para esta Metrica?') ){
				return(true);
			}
			return(false);
		}
		if (btnSelected('Recalcular',document.form1)){
			if(confirm('Desea realizar el recalculo de esta Metrica?') ){
				doCalculosFiltros(true);
				return(false);
			}
			return(false);
		}
		if (btnSelected('Calcular',document.form1)){
				doCalculosFiltros(false);
				return(false);
		}
		if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('Importar',document.form1) && !btnSelected('Lista',document.form1) && !btnSelected('Formular',document.form1) && !btnSelected('Calcular',document.form1)    ){
			var error_input;
			var error_msg = '';
		<cfif modo EQ 'ALTA'>
			Codigo = document.form1.MIGMcodigo.value;
			document.form1.MIGMcodigo.value=replaceAll(Codigo,"*","_");
			Codigo = document.form1.MIGMcodigo.value;
			document.form1.MIGMcodigo.value=replaceAll(Codigo,"/","_");
			Codigo = document.form1.MIGMcodigo.value;
			document.form1.MIGMcodigo.value=replaceAll(Codigo,"-","_");
			Codigo = document.form1.MIGMcodigo.value;
			document.form1.MIGMcodigo.value=replaceAll(Codigo,"+","_");
			Codigo = document.form1.MIGMcodigo.value;
			Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
			if (Codigo.length==0){
				error_msg += "\n - El código no puede quedar en blanco.";
				error_input = formulario.MIGMcodigo;
			}
		</cfif>
				desp = document.form1.MIGMnombre.value;
				desp = desp.replace(/(^\s*)|(\s*$)/g,"");
			if (desp.length==0){
				error_msg += "\n - El nombre no puede quedar en blanco.";
				error_input = formulario.MIGMnombre;
			}
			if (formulario.MIGReid.value == "") {
				error_msg += "\n - El campo Responsable no puede quedar en blanco.";
				error_input = formulario.MIGReid;
			}
			if (formulario.Ucodigo.value == "") {
				error_msg += "\n - Las Unidades no puede quedar en blanco.";
				error_input = formulario.Ucodigo;
			}
			if (formulario.Dactiva.value == "") {
				error_msg += "\n - El Estado no puede quedar en blanco.";
				error_input = formulario.Dactiva;
			}



			// Validacion terminada
			if (error_msg.length != "") {
				alert("Por favor revise los siguiente datos:"+error_msg);
				return false;
			}

		}

	}
</script>




