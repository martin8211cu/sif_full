<cfinvoke key="LB_RecursosHumanos" default="Recursos Humanos" returnvariable="LB_RecursosHumanos" component="sif.Componentes.Translate" method="Translate"	xmlfile="/rh/generales.xml"/>

<cfif  isdefined("url.CFid") and len(trim(url.CFid))>
	<!--- Centro funcional --->
	<cfquery name="rsCF" datasource="#session.DSN#">
		select CFid ,CFcodigo,CFdescripcion 
		from CFuncional
		where  CFid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.CFid#">
		and   Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>	
</cfif>

<cf_templateheader title="#LB_RecursosHumanos#" template="#session.sitio.template#">
<cf_web_portlet_start titulo=" Gr&aacute;fico Salarios vs Encuestas" width="100%">
	<cfinclude template="/home/menu/pNavegacion.cfm">
	
	<!--- empresas encuestadoras --->
	<cfquery name="empresas" datasource="#session.DSN#">
		select a.EEid, b.EEcodigo, b.EEnombre
		from RHEncuestadora a
		
		inner join EncuestaEmpresa b
		on a.EEid=b.EEid
		
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>
	
	<!--- encuestas --->
	<cfquery name="encuestas" datasource="#session.DSN#">
		select distinct a.EEid, a.ETid, a.Eid, a.Moneda, b.Edescripcion 
		from EncuestaSalarios a
		
		inner join Encuesta b
		on a.Eid=b.Eid
	</cfquery>

	<!--- monedas --->
	<cfquery name="monedas" datasource="#session.DSN#">
		select distinct Moneda, Mnombre 
		from EncuestaSalarios a
		
		inner join Monedas b
		on b.Mcodigo=a.Moneda
		and b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">

		where a.Moneda in ( select distinct Moneda 
							from EncuestaSalarios a
							
							inner join EncuestaEmpresa b
							on a.EEid=b.EEid
							
							inner join RHEncuestadora c
							on b.EEid=c.EEid
							and c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> )
	</cfquery>

	<!--- encuestas --->
	<cfquery name="organizacion" datasource="#session.DSN#">
		select EEid,ETid, ETdescripcion
		from EmpresaOrganizacion
		order by ETdescripcion
	</cfquery>
	
<script language="JavaScript" src="/cfmx/sif/js/qForms/qforms.js"></script>
	<form method="post" name="form1" action="comparativo.cfm" style="MARGIN:0;">
	<table width="100%" cellpadding="2" cellspacing="0">
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="right" width="50%"><strong>Empresa Encuestadora:&nbsp;</strong></td>
			<td>
				<select name="EEid" onchange="javascript:cambio_empresa(this);">
					<option value="">-- seleccionar --</option>
					<cfoutput query="empresas">
						<option value="#empresas.EEid#">#empresas.EEnombre#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right" width="50%"><strong>Tipo de Organizaci&oacute;n:&nbsp;</strong></td>
			<td>
				<select name="ETid" id="ETid" onchange="javascript:cambio_tipo(this);">
					<option value="">-- seleccionar --</option>
				</select>
			</td>
		</tr>
		<tr>
		  <td align="right"><strong>Centro Funcional:</strong>&nbsp;</td>
		  <td colspan="2">
			<cfif isdefined("url.CFid") and len(trim(url.CFid))>
				<cf_rhcfuncional query="#rsCF#">
			<cfelse>
				<cf_rhcfuncional>
			</cfif>
		  </td>
		</tr>
		<tr>
			<td>&nbsp;</td>
		  <td>
		  	<table width="100%" cellpadding="0" cellspacing="0">
				<tr>
					<td width="1%" valign="middle"><input type="checkbox" name="dependencias" /></td>
					<td valign="middle"><strong><cf_translate key="LB_Incluir_Dependencias">Incluir Dependencias</cf_translate></strong>&nbsp;</td>
				</tr>
			</table>
		  </td>
		</tr>
		<tr>
			<td align="right" width="50%"><strong>Encuesta:&nbsp;</strong></td>
			<td>
				<select name="Eid" id="Eid">
					<option value="">-- seleccionar --</option>
				</select>
			</td>
		</tr>

		<tr>
			<td align="right" width="50%"><strong>Moneda:&nbsp;</strong></td>
			<td>
				<select name="Mcodigo" id="Mcodigo">
					<option value="">-- seleccionar --</option>
					<cfoutput query="monedas">
						<option value="#monedas.moneda#">#monedas.Mnombre#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center"><input type="submit" name="Consultar" value="Consultar"></td>
		</tr>
		
		<tr><td>&nbsp;</td></tr>
	</table>
	</form>
	
	<script language="JavaScript1.2">
		<!--//
		// specify the path where the "/qforms/" subfolder is located
		qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
		// loads all default libraries
		qFormAPI.include("*");
		//-->
	
		function Lista() {
			location.href = 'listaDatosEncuestas.cfm';
		}
		
		function setBtn(obj) {
			botonActual = obj.name;
		}
		
		function cambio_empresa(obj){
			var form = obj.form;
			var combo = form.ETid;
			
			combo.length = 1;
			combo.options[0].text = '-- seleccionar --';
			combo.options[0].value = '';

			var i = 1;
			<cfoutput query="organizacion">
				var tmp = #organizacion.EEid# ;
				if ( obj.value != '' && tmp != '' && parseFloat(obj.value) == parseFloat(tmp) ) {
					combo.length++;
					combo.options[i].text = '#organizacion.ETdescripcion#';
					combo.options[i].value = '#organizacion.ETid#';
					i++;
				}
			</cfoutput>
		}

		function cambio_tipo(obj){
			var form = obj.form;
			var combo = form.Eid;
			
			combo.length = 1;
			combo.options[0].text = '-- seleccionar --';
			combo.options[0].value = '';

			var i = 1;
			<cfoutput query="encuestas">
				var encuesta = #encuestas.ETid#;
				var empresa = #encuestas.EEid#;

				if ( obj.value !='' && encuesta!='' && form.EEid.value !='' && empresa != '' && parseFloat(obj.value) == parseFloat(encuesta) && parseFloat(form.EEid.value) == parseFloat(empresa) ) {
					combo.length++;
					combo.options[i].text = '#encuestas.Edescripcion#';
					combo.options[i].value = #encuestas.Eid#;
					i++;
				}	
			</cfoutput>
		}
			
		qFormAPI.errorColor = "#FFFFCC";
		objForm = new qForm("form1");
	
		objForm.EEid.required = true;
		objForm.EEid.description="Empresa Encuestadora";
		objForm.ETid.required = true;
		objForm.ETid.description="Tipo de Organización";
		objForm.Eid.required = true;
		objForm.Eid.description="Encuesta";
		objForm.Mcodigo.required = true;
		objForm.Mcodigo.description="Moneda";
	
	</script>	
<cf_web_portlet_end>
<cf_templatefooter>	