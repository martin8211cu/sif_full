<cf_templateheader title="Facturas">
	<cf_web_portlet_start titulo="Facturas">
		<cfif isdefined("url.reporte") and not isdefined("form.reporte")>
			<cfset form.reporte = url.reporte>
		</cfif>
		<cfif isdefined("url.ImpAsiento") and not isdefined("form.ImpAsiento")>
			<cfset form.ImpAsiento = url.ImpAsiento>
		</cfif>
		<cfif isdefined("url.Fechades") and not isdefined("form.Fechades")>
			<cfset form.Fechades = url.Fechades>
		</cfif>
		<cfif isdefined("url.FechaHas") and not isdefined("form.FechaHas")>
			<cfset form.FechaHas = url.FechaHas>
		</cfif>
		<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
			<cfset form.SNcodigo = url.SNcodigo>
		</cfif>
		<cfif isdefined("url.Ddocumento") and not isdefined("form.Ddocumento")>
			<cfset form.Ddocumento = url.Ddocumento>
		</cfif>
		<cfif (not isdefined("form.reporte") and not isdefined("form.chk")) or isdefined("url.Imprime")>
	
				<form name="form1" action="CC_ImprimeFacturaSimple_form.cfm" onSubmit="return validar(this);" method="post" id="form1">
					<table border="0" cellpadding="0" cellspacing="2" align="center">
						<tr>
							<td>&nbsp;</td>
							<td align="right">Fecha Desde:&nbsp;</td>
							<td align="left">&nbsp;<cf_sifcalendario name="fechaDes" value="#LSDateFormat(now(),'dd/mm/yyyy')#"  tabindex="1"></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td align="right">Fecha Hasta:&nbsp;</td>
							<td align="left"><cf_sifcalendario name="fechaHas" value="#LSDateFormat(now(),'dd/mm/yyyy')#"  tabindex="1"></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td>&nbsp;</td>
							<td align="right">Socio:&nbsp;</td>
							<td align="left"><cf_sifsociosnegocios2  tabindex="1"></td>
							<td>&nbsp;</td>
						</tr>
						 <tr>
							<td>&nbsp;</td>
							<td align="right">Documento:&nbsp;</td>
							<td align="left"><input name="Ddocumento" id="Ddocumento" type="text" value="" tabindex="1"/> </td>
							<td>&nbsp;</td>
						</tr>
						 <tr>
							<td>&nbsp;</td>
							<td align="right"><input name="ImpAsiento" id="ImpAsiento" type="checkbox" value="1" tabindex="1"/> </td>
							<td align="left"><label for="ImpAsiento">&nbsp;Imprimir información Contable</label></td>
							<td>&nbsp;</td>
						</tr>
						<tr>
							<td colspan="4" align="center"><cf_botones values='Filtrar' tabindex="1"></td>
						</tr>
					</table>
					<input value="1" name="reporte" type="hidden" />
				</form>
		</cfif>

		<cfif isdefined("form.reporte") and not isdefined('url.Imprime')>
			<cfquery name="rsDocumentoss" datasource="#session.DSN#">
				select 
					d.Ddocumento,
					d.CCTcodigo,
					d.SNcodigo,
					d.Ecodigo,
					s.SNnombre,
					d.Dtotal,
					1 as lista1,
					1 as reporte,
					<cfif isdefined('form.ImpAsiento')>
						'#form.ImpAsiento#'
					<cfelse>
						'0'
					</cfif>  as ImpAsiento
				From Documentos	d
				inner join SNegocios s
					on s.Ecodigo = d.Ecodigo
				   and s.SNcodigo = d.SNcodigo
				where d.Ecodigo = #session.Ecodigo#
				
				<cfif isdefined('form.fechaDes') and len(trim(form.fechaDes))>
					and d.Dfecha >= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.fechaDes,'DD-MM-YYYY')#">
				</cfif>
				<cfif isdefined('form.fechaHas') and len(trim(form.fechaHas))>
					and d.Dfecha <= <cfqueryparam cfsqltype="cf_sql_date" value="#dateformat(form.fechaHas,'DD-MM-YYYY')#">
				</cfif>
				
				<cfif isdefined('form.SNcodigo') and len(trim(form.SNcodigo))>
					and d.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
				</cfif>
				<cfif isdefined('form.Ddocumento') and len(trim(form.Ddocumento))>
					and upper(d.Ddocumento) like '%#Ucase(form.Ddocumento)#%'
				</cfif>

				order by SNnombre, CCTcodigo, Ddocumento
			</cfquery>
			
			<cfset navegacion = "">
			<cfif isdefined("form.reporte") and len(trim(form.reporte))>
				<cfset navegacion = navegacion & 'reporte='&form.reporte>
			</cfif>
			<cfif isdefined("form.ImpAsiento") and len(trim(form.ImpAsiento))>
				<cfset navegacion = navegacion & '&ImpAsiento='&form.ImpAsiento>
			</cfif>
			<cfif isdefined("form.fechaDes") and len(trim(form.fechaDes))>
				<cfset navegacion = navegacion & '&fechaDes='&form.fechaDes>
			</cfif>
			<cfif isdefined("form.fechaHas") and len(trim(form.fechaHas))>
				<cfset navegacion = navegacion & '&fechaHas='&form.fechaHas>
			</cfif>
			<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
				<cfset navegacion = navegacion & '&SNcodigo='&form.SNcodigo>
			</cfif>
			<cfif isdefined("form.Ddocumento") and len(trim(form.Ddocumento))>
				<cfset navegacion = navegacion & '&Ddocumento='&form.Ddocumento>
			</cfif>
			
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="pListaRet"
				query ="#rsDocumentoss#"
				desplegar	="Ddocumento, CCTcodigo, Dtotal"
				etiquetas	="Documento, Transacci&oacute;n, Total"
				formatos	="S,S,M"
				align		="left, left, right"
				ajustar		="S"
				checkboxes	="S"
				cortes 		="SNnombre"
				irA			="CC_ImprimeFacturaSimple_sql.cfm"
				botones		="Generar1"
				showEmptyListMsg="true"
				showLink	="false"
				navegacion	="#navegacion#"
				keys		="Ecodigo,CCTcodigo,Ddocumento,ImpAsiento"
				maxRows		="25"
				formname	="lista"
				incluyeform	="true"	
				funcion    ="Validar2()"/>
		</cfif>
<script type="text/javascript">
function funcGenerar1()
{
	LvarErr = false;
	if (!document.lista.chk)
	{
		LvarErr = true;
	}
	else if(document.lista.chk[0])
	{
		LvarErr = true;
		for(var i=0; i<document.lista.chk.length; i++)
		{
			if (document.lista.chk[i].checked)
			{
				LvarErr = false;
				break;
			}
		}
	}
	else
	{
		LvarErr = !document.lista.chk.checked;
	}
	if (LvarErr)
	{
		alert ("Debe escoger por lo menos un chekcito para continuar");
		return false;
	}
	return true;
}
	
<!---	function validar(formulario)
	{
		if (!btnSelected('Generar',document.form1))
		{
			var error_input;
			var error_msg = '';
			
			if (formulario.chk.value == "")
			{
				error_msg += "\n - Debe seleccionar al menor un documento";
				error_input = formulario.chk;
			}	
				
			// Validacion terminada
			if (error_msg.length != "") 
			{
				alert("Por favor revise los siguiente datos:"+error_msg);
				return false;
			}
		}
	}--->
	function Validar2(m)
	{
	alert ('entre');
		if (!btnSelected('Generar',document.form1))
		{
			var error_input;
			var error_msg = '';
			
			if (lista.chk.value == "")
			{
				error_msg += "\n - Debe seleccionar al menor un documento";
				error_input = lista.chk;
			}	
				
			// Validacion terminada
			if (error_msg.length != "") 
			{
				alert("Por favor revise los siguiente datos:"+error_msg);
				return false;
			}
			}
	}
</script>	
		
	<cf_web_portlet_end>
<cf_templatefooter>