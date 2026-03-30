<cfif Len(session.saci.agente.id) is 0 or session.saci.agente.id is 0>
  <cfthrow message="Usted no está registrado como agente autorizado, por favor verifíquelo.">
</cfif>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>

	<cfif isdefined("url.tab") and Len(Trim(url.tab))>
		<br />
		<cfinclude template="vendedor-params.cfm">
		<cf_tabs width="100%">
			<cf_tab text="Registro de Vendedor" selected="#form.tab eq 1#">
				<div style="vertical-align:top;">
					<cfif form.tab eq 1>
						<cfinclude template="vendedor-registro.cfm">
					</cfif>
				</div>
			</cf_tab>
			<!---<cf_tab text="Registro de Representantes" selected="#form.tab eq 2#">
				<div style="vertical-align:top; ">
					<cfif form.tab eq 2>
						<cfinclude template="vendedor-representantes.cfm">
					</cfif>
				</div>
			</cf_tab>--->
			<cf_tab text="Usuario SACI" selected="#form.tab eq 2#">
				<div style="height: 300; vertical-align:top; ">
					<cfif form.tab eq 2>
						<cfinclude template="vendedor-usuario.cfm">
					</cfif>
				</div>
			</cf_tab>
		</cf_tabs>
		<br />
	
		<script type="text/javascript" language="javascript">
			function funcLista() {
				var params = '';

				<!--- Variables de la lista --->
				if (document.form1.PageNum_listaroot != undefined && document.form1.PageNum_listaroot.value != '') {
					params = params + '&PageNum_listaroot=' + document.form1.PageNum_listaroot.value;
				}
				if (document.form1.Filtro_Ppersoneria != undefined && document.form1.Filtro_Ppersoneria.value != '') {
					params = params + '&Filtro_Ppersoneria=' + document.form1.Filtro_Ppersoneria.value;
					params = params + '&hFiltro_Ppersoneria=' + document.form1.Filtro_Ppersoneria.value;
				}
				if (document.form1.Filtro_Pid != undefined && document.form1.Filtro_Pid.value != '') {
					params = params + '&Filtro_Pid=' + document.form1.Filtro_Pid.value;
					params = params + '&hFiltro_Pid=' + document.form1.Filtro_Pid.value;
				}
				if (document.form1.Filtro_nom_razon != undefined && document.form1.Filtro_nom_razon.value != '') {
					params = params + '&Filtro_nom_razon=' + document.form1.Filtro_nom_razon.value;
					params = params + '&hFiltro_nom_razon=' + document.form1.Filtro_nom_razon.value;
				}
				if (document.form1.Filtro_Habilitado != undefined && document.form1.Filtro_Habilitado.value != '') {
					params = params + '&Filtro_Habilitado=' + document.form1.Filtro_Habilitado.value;
					params = params + '&hFiltro_Habilitado=' + document.form1.Filtro_Habilitado.value;
				}
				
				<cfoutput>
				location.href = '#CurrentPage#?tab='+params;
				</cfoutput>
				return false;
			}

			function tab_set_current (n) {
				var params = '';
				var ven = '';
				if (document.form1.Vid != undefined && document.form1.Vid.value != '') {
					ven = document.form1.Vid.value;
					document.form1.ven.value = document.form1.Vid.value;
					params = params + '&ven=' + document.form1.ven.value;
				} else if (n != '1') {
					alert('Debe registrar o seleccionar un vendedor antes de continuar');
					return false;
				}

				<!--- Variables de la lista --->
				if (document.form1.PageNum_listaroot != undefined && document.form1.PageNum_listaroot.value != '') {
					params = params + '&PageNum_listaroot=' + document.form1.PageNum_listaroot.value;
				}
				if (document.form1.Filtro_Ppersoneria != undefined && document.form1.Filtro_Ppersoneria.value != '') {
					params = params + '&Filtro_Ppersoneria=' + document.form1.Filtro_Ppersoneria.value;
					params = params + '&hFiltro_Ppersoneria=' + document.form1.Filtro_Ppersoneria.value;
				}
				if (document.form1.Filtro_Pid != undefined && document.form1.Filtro_Pid.value != '') {
					params = params + '&Filtro_Pid=' + document.form1.Filtro_Pid.value;
					params = params + '&hFiltro_Pid=' + document.form1.Filtro_Pid.value;
				}
				if (document.form1.Filtro_nom_razon != undefined && document.form1.Filtro_nom_razon.value != '') {
					params = params + '&Filtro_nom_razon=' + document.form1.Filtro_nom_razon.value;
					params = params + '&hFiltro_nom_razon=' + document.form1.Filtro_nom_razon.value;
				}
				if (document.form1.Filtro_Habilitado != undefined && document.form1.Filtro_Habilitado.value != '') {
					params = params + '&Filtro_Habilitado=' + document.form1.Filtro_Habilitado.value;
					params = params + '&hFiltro_Habilitado=' + document.form1.Filtro_Habilitado.value;
				}
				
				<cfoutput>
				location.href = '#CurrentPage#?tab='+escape(n)+params;
				</cfoutput>
			}
		</script>

	<cfelse>
		<cf_web_portlet_start titulo="Lista de Vendedores">
			<cfinclude template="vendedor-lista.cfm">
		<cf_web_portlet_end>
	</cfif>
		
<cf_templatefooter>
