<style type="text/css">

<!--
.topmenu,.topmenu a {font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; color:#000000 }
.topmenusel,.topmenusel a {font-family: Verdana, Arial, Helvetica, sans-serif; font-weight:bold;
 font-size: 12px; background-color:#3366CC; color:white}
-->
</style>
<cfif not isdefined("url.tab")>
 <cfparam name="url.tab" default="1">
</cfif>


<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_DatosPersonales"
Default="Datos Personales"
returnvariable="LB_DatosPersonales"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_CambiarContrasena"
Default="Cambiar contraseña"
returnvariable="LB_CambiarContrasena"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Direccion"
Default="Direcci&oacute;n"
returnvariable="LB_Direccion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Preferencias"
Default="Preferencias"
returnvariable="LB_Preferencias"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_MisServicios"
Default="Mis Servicios"
returnvariable="LB_MisServicios"/>
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Ayuda"
Default="Ayuda"
xmlFile="/rh/generales.xml"
returnvariable="LB_Ayuda"/>

<table border="0" cellpadding="4" cellspacing="1" bordercolor="#999999">
 	<tr>
   		<td>
			<cf_tabs width="100%">
				<cf_tab text="#LB_DatosPersonales#" id="1" selected="#url.tab eq 1#">
					<cfif url.tab EQ 1>
						<cfinclude template="usuario-form1.cfm">
					</cfif>
			 	</cf_tab>
			 	
				<cf_tab text="#LB_CambiarContrasena#" id="5" selected="#url.tab eq 5#">
					<cfif url.tab EQ 5>
						<cfinclude template="usuario-form5.cfm">
					</cfif>
			 	</cf_tab> 
			 
			 	<cf_tab text="#LB_Direccion#" id="2" selected="#url.tab eq 2#">
					<cfif url.tab EQ 2>
						<cfinclude template="usuario-form2.cfm">
					</cfif>
			 	</cf_tab> 
			 
				<cf_tab text="#LB_Preferencias#" id="3" selected="#url.tab eq 3#">
					<cfif url.tab EQ 3>
						<cfinclude template="usuario-form3.cfm">
					</cfif>
			 	</cf_tab> 
			 	
				<cf_tab text="#LB_MisServicios#" id="4" selected="#url.tab eq 4#">
					<cfif url.tab EQ 4>
						<cfinclude template="usuario-form4.cfm">
					</cfif>
			 	</cf_tab> 
				<cf_tab text="#LB_Ayuda#" id="6" selected="#url.tab eq 6#">
					<cfif url.tab EQ 6>
						<cfset invokePreferencias=true>
						<cfinclude template="usuario-formAyuda.cfm">
					</cfif>
			 	</cf_tab> 
			 </cf_tabs> 
		</td>
	</tr> 
</table>

<script language="javascript" type="text/javascript">
	function tab_set_current (n){ 
		location.href='index.cfm?tab='+escape(n);
	}	
</script>
