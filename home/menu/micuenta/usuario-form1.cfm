<!--- Consultas --->

<cfquery name="rsData" datasource="asp">
	select a.id_direccion,
		   a.datos_personales,
		   a.Ufhasta,
		   a.Uestado,
		   rtrim(a.LOCIdioma) as LOCIdioma,
		   a.Usulogin,
		   (case when a.Uestado = 0 then 'Inactivo' when a.Uestado = 1 and a.Utemporal = 1 then 'Temporal' when a.Uestado = 1 and a.Utemporal = 0 then 'Activo' else '' end) as estado
	from Usuario a
	where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
</cfquery>


<cfsetting enablecfoutputonly="no">

			<form name="form1" method="post" action="usuario-apply1.cfm" style="margin:0 ">
<cfoutput>
<table border="0" cellspacing="0" cellpadding="2" align="center">
		  <tr>
		    <td colspan="2" align="left" nowrap>
				<cf_datospersonales form="form1" action="input" key="#rsData.datos_personales#" screen="Preferencias">
			</td>
		  </tr>
		  <tr>
		    <td colspan="2" align="left" nowrap>&nbsp;</td>
		    </tr>
		  <tr>
		    <td colspan="2" align="left" nowrap>&nbsp;</td>
		    </tr>
		  <tr>
		    <td colspan="2" align="center" nowrap>
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Modificar"
						Default="Modificar"
						returnvariable="BTN_Modificar"/>		
						
						<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="BTN_Restablecer"
						Default="Restablecer"
						returnvariable="BTN_Restablecer"/>				
						<cfoutput>
						<input name="Cambio" type="submit" class="btnGuardar" onClick="javascript: if (window.habilitarValidacion) habilitarValidacion(); " value="#BTN_Modificar#">
						<input name="Reset" type="reset" class="btnLimpiar" value="#BTN_Restablecer#">
						</cfoutput>
			</td>
		  </tr>
		  <tr>
		    <td colspan="2" align="center" nowrap>&nbsp;</td>
      </tr>
		</table>
</cfoutput>
</form>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Identificacion"
Default="Identificación"
returnvariable="LB_Identificacion"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Nombre"
Default="Nombre"
returnvariable="LB_Nombre"/> 

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Email"
Default="Email"
returnvariable="LB_Email"/> 

<cfoutput>
<script language="JavaScript1.2" type="text/javascript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	
	qFormAPI.errorColor = "##FFFFCC";
	objForm = new qForm("form1");
	
	objForm.id.required = true;
	objForm.id.description = "#LB_Identificacion#";
	objForm.nombre.required = true;
	objForm.nombre.description = "#LB_Nombre#";

	objForm.email1.required = true;
	objForm.email1.description = "#LB_Email#";
</script>
</cfoutput>