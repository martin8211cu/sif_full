
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Administracion_de_Personas"
Default="Administraci&oacute;n de Personas"
returnvariable="LB_Administracion_de_Personas"/>
<!--- 
<cfinclude template="/rh/Utiles/params.cfm">
		<cfset Session.Params.ModoDespliegue = 1>
		<cfset Session.cache_empresarial = 0> --->

<cf_templateheader title="#LB_Administracion_de_Personas#">
	<cfif isdefined("Url.o") and not isdefined("Form.o")>
		<cfset Form.o = Url.o>
	</cfif>
	<script language="javascript" type="text/javascript">
		function showList(arg) {
			var a = document.getElementById("divPersonas");
			var b = document.getElementById("divForm");
			if (a != null && b != null) {
				if (arg) {
					a.style.display = ''
					b.style.display = 'none'
				} else {
					a.style.display = 'none'
					b.style.display = ''
				}
			}
		}
	</script>
	

	<!--- Archivo que carga datos en session 
	<cfinclude template="../Proyecto/frame-config.cfm">--->


<div id="divPersonas" style="display: none; ">
<cfinclude template="expediente-lista.cfm">
	</div>
	<div id="divForm">
	
		<table width="100%" border="0" cellpadding="4" cellspacing="0">
			<tr>
				<td valign="top">
					<!--- <cfinclude template="../Proyecto/frame-header.cfm"> --->
				</td>
			</tr>
			
			<tr>
				<td valign="top">
				<!--- <cfinclude template="DatosEmpleado.cfm">	 --->
				</td>
			</tr>
		</table>
	</div>
<cfif isdefined("Form.o") and Form.o EQ 1>
		<script language="javascript" type="text/javascript">
			showList(true);
		</script>
	</cfif>

<cf_templatefooter>
