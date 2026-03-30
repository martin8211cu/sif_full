<cf_templateheader title="Creación de Parches">
<cfinclude template="mapa.cfm">
<h1>Seleccionar seguridad</h1>
<p>
Seleccione el sistema, módulo o procesos cuya seguridad desea incluir dentro del parche.</p>
<p>Se incluirán en el parche las instrucciones SQL necesarias para actualizar la seguridad.  </p>
<cfparam name="url.SScodigo" default="">
<cfquery datasource="asp" name="sis">
	select rtrim(SScodigo) as SScodigo, SSdescripcion
	from SSistemas
	order by SSdescripcion, SScodigo
</cfquery>
<cfquery datasource="asp" name="mod">
	select rtrim(SScodigo) as SScodigo, rtrim(SMcodigo) as SMcodigo,
		SMdescripcion
	from SModulos
	order by SScodigo, SMdescripcion, SMcodigo
</cfquery>
<cfform height="300" width="700" id="form1" name="form1" 
	method="post" action="segbuscar-control.cfm" format="#session.parche.form_format#"
	timeout="60" >
<cfif session.parche.form_format EQ 'html'>
	<cfset onchangess = "change_ss(this,this.form.SMcodigo)">
	<cfset onchangesm = "change_sm(this.form.SScodigo,this)">
	
	<script type="text/javascript">
	function change_ss(ss,sm){
		while (sm.length>1){sm.remove(1);}
		<cfoutput query="mod" group="SScodigo">
		if(ss.value=='# JSStringFormat(SScodigo) #'){<cfoutput>
			sm.length++;
			sm.options[sm.length-1].value = '# JSStringFormat(SMcodigo) #';
			sm.options[sm.length-1].text = '# JSStringFormat(SMdescripcion) #';</cfoutput>
		}
		</cfoutput>
	}
	</script>
<cfelse>
	<cfsavecontent variable="onchangess">
		while(SMcodigo.getLength()>1)SMcodigo.removeItemAt(1);
		<cfoutput query="mod" group="SScodigo">
		if(SScodigo.value=='# JSStringFormat(SScodigo) #'){<cfoutput>
			SMcodigo.addItem('# JSStringFormat(SMdescripcion) #','# JSStringFormat(SMcodigo) #');</cfoutput>
		}
		</cfoutput>
	</cfsavecontent>

</cfif>
<cf_web_portlet_start width="700" titulo="Seleccione los sistemas, módulos o procesos cuya seguridad desea incluir en el parche">
<cfformgroup type="panel" label="Seleccione los sistemas, módulos o procesos cuya seguridad desea incluir en el parche">
	<table>
	<tr><td><label for="SScodigo">Sistema</label></td><td>
<cfselect name="SScodigo" label="Sistema" width="350" style="width:350px" query="sis" value="SScodigo" display="SSdescripcion"
	selected="#url.SScodigo#" onChange="#onchangess#" queryPosition="below" required="yes">
<option value="" selected="selected">- Seleccione un sistema -</option>
<option value="*">(todo)</option>
</cfselect>
	</td></tr>
	<tr><td><label for="SMcodigo">Módulo</label></td><td>
<cfselect name="SMcodigo" label="Módulo" width="350" style="width:350px">
<option value="*" >(todo)</option>
</cfselect>
	</td></tr>
	<tr><td colspan="2">
<cfinput type="submit" name="Submit" value="Agregar" class="btnGuardar" />
	</td></tr>
</table>
</cfformgroup><cf_web_portlet_end></cfform>
<cf_templatefooter>
