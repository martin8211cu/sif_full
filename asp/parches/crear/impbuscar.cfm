<cf_templateheader title="Creación de Parches">
<cfinclude template="mapa.cfm">
<cfparam name="url.EImodulo" default="">
<h1>Seleccionar importaciones</h1>

<cfquery datasource="sifcontrol" name="eis">
	select EIid, rtrim(EIcodigo) as EIcodigo, rtrim(EImodulo) as EImodulo, EIdescripcion
	from EImportador
	where EIcodigo not like '%.%'
	<cfif StructCount(session.parche.importar)>
	  and EIcodigo not in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#StructKeyList(session.parche.importar) #" list="yes">)
	 </cfif>
	order by upper(EImodulo), upper(EIcodigo)
</cfquery>

<cfform height="170" width="700" id="form1" name="form1" method="post" action="impbuscar-control.cfm" format="#session.parche.form_format#" timeout="60" >
<cfif session.parche.form_format EQ 'html'>
	<cfset onchangemod = "change_mod(this,this.form.EIcodigo)">
	
	<script type="text/javascript">
	function change_mod(mod,ei){
		while (ei.length>0){ei.remove(0);}
		<cfoutput query="eis" group="EImodulo">
		if(mod.value=='# JSStringFormat(EImodulo) #'){<cfoutput>
			ei.length++;
			ei.options[ei.length-1].value = '# JSStringFormat(EIcodigo) #';
			ei.options[ei.length-1].text = '# JSStringFormat(EIdescripcion) #';</cfoutput>
		}
		</cfoutput>
	}
	</script>
<cfelse>
	<cfsavecontent variable="onchangemod">
		while(EIcodigo.getLength()>0)EIcodigo.removeItemAt(0);
		<cfoutput query="eis" group="EImodulo">
		if(EImodulo.value=='# JSStringFormat(EImodulo) #'){<cfoutput>
			EIcodigo.addItem('# JSStringFormat(EIdescripcion) #','# JSStringFormat(EIcodigo) #');</cfoutput>
		}
		</cfoutput>
	</cfsavecontent>

</cfif>
<cf_web_portlet_start width="700" titulo="Seleccione las definiciones del importador que desea agregar al parche">
<cfformgroup type="panel" label="Seleccione las definiciones del importador que desea agregar al parche">
	<table>
	<tr><td><label for="EImodulo">Módulo</label></td><td>
<cfselect name="EImodulo" label="Módulo" width="350" style="width:350px"  
	onChange="#onchangemod#">
<option value="*">(seleccione)</option>
<cfoutput query="eis" group="EImodulo">
<option value="# HTMLEditFormat(EImodulo) #" <cfif url.EImodulo EQ eis.EImodulo>selected</cfif>># HTMLEditFormat(EImodulo) #</option>
</cfoutput>
</cfselect>
	</td></tr>
	<tr><td><label for="EIcodigo">Código</label></td><td>
<cfselect name="EIcodigo" label="Código" width="350" style="width:350px" required="yes">
<cfoutput query="eis" group="EImodulo">
<cfif url.EImodulo EQ eis.EImodulo>
<cfoutput>
<option value="# HTMLEditFormat(EIcodigo) #"># HTMLEditFormat(EIdescripcion) #</option>
</cfoutput>
</cfif>
</cfoutput>
</cfselect>
	</td></tr>
	<tr><td colspan="2">
<cfinput type="submit" name="Submit" value="Agregar" class="btnGuardar" />
	</td></tr>
</table>
</cfformgroup><cf_web_portlet_end></cfform>


<cfif StructCount(session.parche.importar)>
<cfinclude template="impconfirmar.cfm">
</cfif>

<cf_templatefooter>
