<cfif IsDefined('url.sentok') and url.sentok is 1>
	<strong>La factura ha sido reenviada</strong>
</cfif>
<cfinvoke component="sif.Componentes.pListas" method="pLista"
	tabla="ISBfacturaMedios"
	columnas="LFlote,LFnumero,case LFestado when 'C' then 'Creado' when 'E' then 'Enviado' when 'R' then 'Respondido' else LFestado end as estado,
	(cantEnviadas+cantAplicadas+cantInconsistentes+cantMorosas) as total,cantAplicadas,cantLiquidadas"
	filtro=""
	desplegar="LFnumero,estado,total,cantAplicadas,cantLiquidadas"
	etiquetas="Número,Estado,Total,Aplicadas,Liquidadas"
	formatos="S,S,S,S,S"
	align="left,left,left,left,left"
	ira="ISBfacturaMedios-apply.cfm"
	funcion="DetalleFactura"
	fparams="LFlote"
	form_method="post"
	formName="listaFacturas"
	keys="LFlote"
	mostrar_filtro="yes"
	filtrar_automatico="yes"
	botones="Facturar_Pendientes,Reenviar"
	checkboxes="S"
	checkedcol=""
/>
<form name="hiddenform" action="ISBfacturaMedios-apply.cfm" style="margin:0" method="post">
<input type="hidden" name="chk" id="hiddenchk" />
<input type="hidden" name="" id="hiddenbutton"/>
</form>
<script type="text/javascript">
<!--
	<!---function chks() {
		var s = '', f = document.listaFacturas;
		if (f.chk.length) {
			for(var i=0; i < f.chk.length; i++)
				if (f.chk[i].checked) {
					if (s.length) s += ',';
					s += escape(f.chk[i].value);
				}
		} else if (f.chk.checked) {
			s = 'chk=' + escape(f.chk.value);
		}
		return s;
	}
	function funcReenviar() {
		var ch = chks();
		if (ch.length) {
			document.hiddenform.chk.value = ch;
			document.hiddenform.hiddenbutton.name = 'Reenviar';
			document.hiddenform.submit();
		} else {
			alert('Seleccione los documentos que desea reenviar.');
		}
		return false;
	}
	function funcFacturar_Pendientes() {
		document.hiddenform.hiddenbutton.name = 'Nueva';
		document.hiddenform.submit();
		return false;
	}--->
	function DetalleFactura(LFlote){
		document.location.href = 'index.cfm?tab=<cfoutput>#url.tab#</cfoutput>&LFlote=' + escape(LFlote);
	}
-->
</script>