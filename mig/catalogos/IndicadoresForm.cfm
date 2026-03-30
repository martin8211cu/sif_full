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


<cfset LvarIDR="">
<cfset LvarIDFijaMeta="">
<cfset LvarID="">
<cfset LvarUnidades="">
<cfset LvarIDP="">
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

<script language="javascript" src="../../js/utilesMonto.js"></script>

<cfif modo EQ "CAMBIO" >

	<cfquery datasource="#Session.DSN#" name="rsIndicadores">
		select
				MIGMid,
				MIGMcodigo,
				Ucodigo,
				MIGMnombre,
				MIGMtipotolerancia,
				MIGMtoleranciainferior,
				MIGMnpresentacion,
				MIGMtoleranciasuperior,
				MIGPerid,
				MIGRecodigo,
				MIGReidduenno,
				MIGMperiodicidad,
				MIGMdescripcion,
				MIGMsequencia,
				MIGMtipotolerancia,
				MIGReidFija,
				MIGMtendenciapositiva,
				Dactiva,
				MIGMcalculo
		from MIGMetricas
		where MIGMid= <cfqueryparam cfsqltype="cf_sql_integer" value="#form.MIGMid#">
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

	<cfset LvarID=rsIndicadores.MIGReidduenno>
	<cfset LvarIDFijaMeta=rsIndicadores.MIGReidFija>
	<cfset LvarIDR=rsIndicadores.MIGRecodigo>
	<cfset LvarIDP=rsIndicadores.MIGPerid>
	<cfset LvarUnidades=rsIndicadores.Ucodigo>
	<cfset LvarIniciales=true>

</cfif>
<cfif modo NEQ 'ALTA'>
	<cfset LvarInclude="Formular,Calcular">
 	<!---<cfset LvarInclude="Formular,Calcular,Lista">--->
 <cfelse>
 	<!---<cfset LvarInclude="Lista">--->
	<cfset LvarInclude="">
</cfif>

<cfif modo NEQ 'ALTA' and BorrarDatosCalculados>
 <cfset LvarInclude= listAppend(LvarInclude,'Borrar_Calculados',',')>
</cfif>

<cfoutput>
	<cfparam name="url.tab" default="1">
	<cfparam name="form.tab" default="#url.tab#">
	<cfparam name="tabChoice" default="#form.tab#">
	<cf_tabs width="100%">
		<cf_tab text="General" selected="#tabChoice eq 1#">
			<cfinclude template="tabIndicadorGeneral.cfm">
		</cf_tab>
		<cfif MODO EQ 'CAMBIO'>
		<cf_tab text="Asignar a" selected="#tabChoice eq 2#">
			<br>&nbsp;&nbsp;&nbsp;C&oacute;digo Indicador: #rsIndicadores.MIGMcodigo#
			<cfinclude template="tabFiltroIndicador.cfm">
		</cf_tab>
		<cf_tab text="Filtros Metricas" selected="#tabChoice eq 3#">
			<br>&nbsp;&nbsp;&nbsp;C&oacute;digo Indicador: #rsIndicadores.MIGMcodigo# = #rsIndicadores.MIGMcalculo#
<!---			<br>&nbsp;&nbsp;&nbsp;F&oacute;rmula Indicador: #rsIndicadores.MIGMcalculo# --->
			<cfinclude template="tabFiltroMetricas.cfm">
		</cf_tab>
		<cf_tab text="Informaci&oacute;n Adicional" selected="#tabChoice eq 4#">
			<br>&nbsp;&nbsp;&nbsp;C&oacute;digo Indicador: #rsIndicadores.MIGMcodigo#
			<cfinclude template="tabAccionesIndicador.cfm">
		</cf_tab>
		</cfif>
	</cf_tabs>
		<center><input type="button" name="irLista" value="Volver a la lista" onclick="javascript: document.location.href= '/cfmx/mig/catalogos/Indicadores.cfm?PageNum_lista1=#pagenum#'"/></center>
	<!--- Validaciones por medio de JavaScript --->
	<script type="text/javascript">
		<!--
		function tab_set_current (n){
			<cfif isdefined('form.MIGMid')and len(trim(form.MIGMid))>
				document.location.href='Indicadores.cfm?o='+escape(n)+'&tab='+escape(n)+'&sel=1'+'&MIGMid=#form.MIGMid#&MODO=CAMBIO&pagenum1=#pagenum#';
			<cfelse>
				document.location.href='Indicadores.cfm?o='+escape(n)+'&tab='+escape(n)+'&sel=1'+'&MODO=ALTA&pagenum1=#pagenum#';
			</cfif>
		}
		//-->
	</script>

</cfoutput>

<!---ValidacionesFormulario--->

<script type="text/javascript">

	var popUpWinSN=0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWinSN) {
			if(!popUpWinSN.closed) popUpWinSN.close();
		}
		popUpWinSN = open(URLStr, 'popUpWinSN', 'toolbar=no,location=no,directories=no,status=no,menub ar=no,scrollbar=yes,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
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
			popUpWindow("IndicadoresCalculaFiltros.cfm"+params,250,200,550,350);
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
			if(confirm('Desea realizar el recalculo de este Indicador?') ){
				doCalculosFiltros(true);
				return(false);
			}
			return(false);
		}
		if (btnSelected('Calcular',document.form1)){
				doCalculosFiltros(false);
				return(false);
		}

		if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('Lista',document.form1) && !btnSelected('Formular',document.form1) && !btnSelected('Calcular',document.form1) && !btnSelected('Recalcular',document.form1)){
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
				error_msg += "\n - El codigo no puede quedar en blanco.";
				error_input = formulario.MIGMcodigo;
			}
	</cfif>
		desp = document.form1.MIGMnombre.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		if (desp.length==0){
			error_msg += "\n - El nombre de Indicador no puede quedar en blanco.";
			error_input = formulario.MIGMnombre;
		}
		if (formulario.IDdue.value == "") {
			error_msg += "\n - El Dueño no puede quedar en blanco.";
			error_input = formulario.IDdue;
		}
		if (formulario.IDresp.value == "") {
			error_msg += "\n - El Responsable no puede quedar en blanco.";
			error_input = formulario.IDresp;
		}
		if (formulario.IDFM.value == "") {
			error_msg += "\n - El Responsable de Fijar la Meta no puede quedar en blanco.";
			error_input = formulario.IDFM;
		}
		if (formulario.Ucodigo.value == "") {
			error_msg += "\n - Las Unidades no pueden quedar en blanco.";
			error_input = formulario.Ucodigo;
		}
		if (formulario.MIGPerid.value == "") {
			error_msg += "\n - La Perspectiva no pueden quedar en blanco.";
			error_input = formulario.MIGPerid;
		}
		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>




