<cf_templateheader title="Datos Empresa">
<script language="javascript" type="text/javascript">
	function socios_validateForm(form) { //MM_validateForm modificado para recibir argumento form
		var i,p,q,nm,test,num,min,max,errors='',args=socios_validateForm.arguments;
		for (i=1; i<(args.length-2); i+=3) {
			test=args[i+2];
			val=form[args[i]];
			if (val) {
				if (val.alt!="") nm=val.alt; else nm=val.name; if ((val=val.value)!="") {
					if (test.indexOf('isEmail')!=-1) {
			  			p=val.indexOf('@');
						if (p<1 || p==(val.length-1)) errors+='- '+nm+' no es una dirección de correo electrónica válida.\n';
				  		}
				  	else if (test!='R') {
				  		num = parseFloat(val);
						if (isNaN(val)) errors+='- '+nm+' debe ser numérico.\n';
						if (test.indexOf('inRange') != -1) {
							p=test.indexOf(':');
				  			min=test.substring(8,p);
				  			max=test.substring(p+1);
				  			if (num<min || max<num) errors+='- '+nm+' debe ser un número entre '+min+' y '+max+'.\n';
							}
						}
				  	}
				else if (test.charAt(0) == 'R') errors += '- '+nm+' es requerido.\n';
				}
			}
	  if (errors) alert('Se presentaron los siguientes errores:\n\n'+errors);
	  document.MM_returnValue = (errors == '');
	}
</script>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Datos Empresa'>
		<cfinclude template="../../portlets/pNavegacion.cfm">
		<cfif isdefined('url.Ecodigos') and not isdefined('form.Ecodigos')>
			<cfset form.Ecodigos = url.Ecodigos>
		</cfif>
		<table width="100%" align="center" border="0" cellpadding="0" cellspacing="0">
			<tr>
				<td width="50%" valign="top">
					<cfinclude template="DatosEmpresas_lista.cfm">
				</td>
				<td align="center" style="vertical-align:top" width="50%">
					<cfif isdefined('form.Ecodigos') and len(trim(form.Ecodigos))>
						<cfinclude template="DatosEmpresas_form.cfm">
					</cfif>
				</td>
			</tr>
		</table>
<cf_web_portlet_end>
<cf_templatefooter>
