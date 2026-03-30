<!--- Rodolfo Jimenez Jara, Soluciones Integrales S.A., Costa Rica, America Central, 21/04/2003 --->
	<cfif isdefined("Url.btnGenerar") and not isdefined("Form.btnGenerar")>
		<cfparam name="Form.btnGenerar" default="#Url.btnGenerar#">
	</cfif> 

	<!--- <cfif isdefined("url.id_documento") and not isdefined("Form.id_documento")>
		<cfparam name="Form.id_documento" default="#url.id_documento#">
	</cfif> --->
	
	<cfif isdefined("url.atributo") and not isdefined("Form.atributo")>
		<cfparam name="Form.atributo" default="#url.atributo#">
	</cfif>
	
<!--- 	<cfif isdefined("url.tipo") and not isdefined("Form.tipo")>
		<cfparam name="Form.tipo" default="#url.tipo#">
	</cfif> --->
	<cfif isdefined("url.valor_atributo") and not isdefined("Form.valor_atributo")>
		<cfparam name="Form.valor_atributo" default="#url.valor_atributo#">
	</cfif>
	<cfif isdefined("url.valor") and not isdefined("Form.valor")>
		<cfparam name="Form.valor" default="#url.valor#">
	</cfif>
	

<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<!--- <cfquery datasource="#Session.DSN#" name="rsMABiblioteca">
	select convert(varchar,a.id_biblioteca) as id_biblioteca , a.nombre_biblio 
	from MABiblioteca a, BibliotecaCentroE b
	where a.id_biblioteca = b.id_biblioteca
	  and b.CEcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#"> 
</cfquery> --->

<cfquery datasource="#Session.DSN#" name="rsCentroEducativo">
	select CEnombre from CentroEducativo
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.CEcodigo#">
</cfquery>			
<!---------------------------------------------------------------------------------- --->
<cfif isdefined("Form.btnGenerar")>
<!--- <cfdump var="#form#"> --->
		<!--- <cfstoredproc datasource="#Session.DSN#" procedure="sp_CONSULTAMATERIAL" returncode="yes">
			<cfprocresult name="cons1">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@CCentro"    value="#Session.CEcodigo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@MateriaTipo"      value="#Form.codigo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Documento"    value="#Form.id_documento#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@TipoDoc"    value="#Form.tipo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Atributo" value="#Form.atributo#">
			<cfprocparam cfsqltype="cf_sql_numeric" dbvarname="@Valor"    value="#Form.valor#">
		</cfstoredproc> --->
		<cfquery datasource="#Session.DSN#" name="rsConsultaMaterial">
			set nocount on
			exec sp_CONSULTAMATERIAL 
				@CCentro=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
				<cfif isdefined('form.codigo') and form.codigo NEQ '-1' and len(trim(form.codigo)) NEQ 0>
					,@MateriaTipo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.codigo#">			
				</cfif>
				<cfif isdefined('form.id_documento') and form.id_documento NEQ '-1' and len(trim(form.id_documento)) NEQ 0>
					,@Documento=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_documento#">			
				</cfif>
				<cfif isdefined('form.tipo') and form.tipo NEQ '-1' and len(trim(form.tipo)) NEQ 0>
					,@TipoDoc=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.tipo#">			
				</cfif>
				<cfif isdefined('form.atributo') and form.atributo NEQ '-1' and len(trim(form.atributo)) NEQ 0>
					,@Atributo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.atributo#">			
				</cfif>
				<cfif isdefined('form.valor') and form.valor NEQ '-1' and len(trim(form.valor)) NEQ 0>
					,@Valor=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.valor#">			
				</cfif>
				<cfif isdefined('form.tipo_contenido') and form.tipo_contenido NEQ '-1' and len(trim(form.tipo_contenido)) NEQ 0>
					,@Contenido=<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.tipo_contenido#">			
				</cfif>
				
			set nocount off
		</cfquery>	
		
		
</cfif> 
<script language="JavaScript" src="../../js/qForms/qforms.js"></script>
<script language="JavaScript" type="text/JavaScript">

	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	var popUpWin=0; 
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin)
	  {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
</script>
	<link href="/cfmx/edu/css/edu.css" rel="stylesheet" type="text/css">		
<!--- <form name="form1" method="post" action="../../ced/alumno/SQLBiblioteca.cfm"> --->
	<cfoutput>
		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr class="area"> 
				<td colspan="2">Servicios Digitales al Ciudadano</td>
				<!--- <td width="20%">&nbsp;</td> --->
				<td  align="right">Fecha: <cfoutput>#LSdateFormat(Now(),'dd/MM/YY')#</cfoutput> </td>
			</tr>
				<tr class="area"> 
				<td colspan="2">www.migestion.net</td>
				<!--- <td>&nbsp;</td> --->
			<td align="right">Hora: <cfoutput>#TimeFormat(Now(),"hh:mm:ss")# </cfoutput></td>
			</tr>
				<tr class="area" align="center"> 
					
			<td colspan="3" class="tituloAlterno" align="center"><strong>Consulta de Material de Apoyo</strong></td>
				</tr>
			<tr> 
				<td colspan="3" class="tituloAlterno" align="center"><cfoutput>#rsCentroEducativo.CEnombre#</cfoutput></td>
			</tr>
			<tr> 
				<td colspan="3">&nbsp;</td>
			</tr>
			<tr> 
				<td colspan="3">&nbsp;</td>
			</tr>
		 </table> 
		<table width="100%" cellpadding="2" cellspacing="2" border="0">
			<tr> 
				
        <td align="right" nowrap>&nbsp;</td>
        <td nowrap>&nbsp;</td>
			</tr>
			<tr> 
				<td align="right" nowrap>&nbsp; </td>
				<td width="70%" nowrap>&nbsp; </td>
					
					<cfif modo NEQ "ALTA" and isdefined("Form.tipo")>
						<input type="hidden" name="HayMADocumento" value="#rsHayMADocumento.recordCount#" >
					</cfif>
			</tr>
		</table>
	</cfoutput> 
	<cfif rsConsultaMaterial.recordCount GT 0>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr class="subTitulo"> 
			<td class="encabReporte"><strong>Titulo</strong></td>
			<td class="encabReporte"><strong>Resumen</strong></td>
			<td class="encabReporte"><strong>Fecha</strong></td>
			<td class="encabReporte"><strong>Autor</strong></td>
			<td class="encabReporte"><strong>Tipo</strong></td>
			<td class="encabReporte"><strong>Nombre Archivo</strong></td>
		  </tr>
		  <cfoutput> 
			<cfloop query="rsConsultaMaterial">
			  <tr> 
				<td>#rsConsultaMaterial.titulo#</td>
				<td>#rsConsultaMaterial.resumen#</td>
				<td>#rsConsultaMaterial.fecha#</td>
				<td>#rsConsultaMaterial.autor#</td>
				<td>#rsConsultaMaterial.tipo_contenido#</td>
				<td>#rsConsultaMaterial.nom_archivo#</td>
				<!--- <cfif #rsConsultaMaterial.tipo_contenido# EQ "L">
							<td><a href="#rsConsultaMaterial.nom_archivo#"></a></td>
						<cfelse>
							<td>#rsConsultaMaterial.nom_archivo#</td>
						</cfif> --->
			  </tr>
			  <tr> 
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			  <tr> 
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
				<td>&nbsp;</td>
			  </tr>
			</cfloop>
			<table width="100%"  border="0" cellspacing="0">
				<tr> 
					<td colspan="4">&nbsp;</td>
				</tr>
				<tr> 
					<td colspan="4" align="center"> ------------------ Fin de la Consulta ------------------ </td>
				</tr>
			</table>
		  </cfoutput> 
		</table>
	<cfelse>
		<table width="100%" border="0" cellspacing="0"> 			
			<tr> 
				<td colspan="4" class="subTitulo" >No existen documentos</td>
			</tr>
			<tr> 
				<td colspan="4" align="center"> ------------------ 1 - La materia solicitada no tiene documentos en esta biblioteca  ------------------ </td>
			</tr>
			<tr> 
				<td colspan="4">&nbsp;</td>
			</tr>
			<tr> 
				<td colspan="4" align="center"> ------------------ Fin de la Consulta ------------------ </td>
			</tr>
		</table>
	</cfif>
<!--- </form> --->