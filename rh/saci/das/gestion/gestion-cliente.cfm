<cf_tabs width="100%">
	<cf_tab text="Registro de Cliente" selected="#form.tab eq 1#">
		<div style="vertical-align:top;">
			<cfif form.tab eq 1>
				<cfinclude template="gestion-cliente-datos.cfm">
			</cfif>
		</div>
	</cf_tab>
	<cf_tab text="Registro de Contactos" selected="#form.tab eq 2#">
		<div style="vertical-align:top;">
			<cfif form.tab eq 2>
				<cfinclude template="gestion-representantes.cfm">
			</cfif>
		</div>
	</cf_tab>
	<cf_tab text="Usuario SACI" selected="#form.tab eq 3#">
		<div style="height: 300; vertical-align:top; ">
			<cfif form.tab eq 3>
				<cfinclude template="gestion-usuario.cfm">
			</cfif>
		</div>
	</cf_tab>
</cf_tabs>
	
	<script type="text/javascript" language="javascript">
		function tab_set_current (n,f) {
			
			var params = '';
			var cli = '';
			
			if ( f == undefined){
				var f = document.forms.form1;
			}
			
			if (f.Pquien != undefined && f.Pquien.value != '') {
				cli = f.Pquien.value;
				f.cli.value = cli;
				params = params + '&cli=' + cli;
			} else if (n != '1') {
				alert('Debe registrar o seleccionar un cliente antes de continuar');
				return false;
			}
			
			if(f.botonSel != undefined){
				if(n==2 && f.botonSel.value =="Nuevo")	params = params + '&Nuevo=Nuevo';
				if(n==2 && f.botonSel.value =="Filtrar" && arguments[2] != undefined)params = params + '&' + arguments[2];
			}
			
			<cfoutput>
			location.href = '#CurrentPage#?tab='+escape(n)+params;
			</cfoutput>										
		}
	</script>
	