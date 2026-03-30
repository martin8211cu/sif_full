<cfinclude template="materiaCicloLectivo_fnSQL.cfm">
	<cftry>
		<cfscript>
		  if (isdefined("Form.btnMCLagregar"))
		  {
		  	fnCicloLectivoMateria_Alta(
				form.Mcodigo, form.CILcodigo, form.MCLtipoCicloDuracion, form.MCLmetodologia, 
				form.TRcodigo, form.PEVcodigo, form.MCLtipoCalificacion, 
				form.MCLpuntosMax, form.MCLunidadMin, form.MCLredondeo, form.TEcodigo);
		  }
		  else if (isdefined("Form.btnMCLmodificar"))
		  {
			LvarCambiarTipoDuracion = (form.MCLtipoCicloDuracion NEQ form.MCLtipoCicloDuracionAnterior);
		  	fnCicloLectivoMateria_Cambio(
				form.Mcodigo, form.CILcodigo, form.MCLtipoCicloDuracion, form.MCLmetodologia, 
				form.TRcodigo, form.PEVcodigo, form.MCLtipoCalificacion, 
				form.MCLpuntosMax, form.MCLunidadMin, form.MCLredondeo, form.TEcodigo, LvarCambiarTipoDuracion);
		  }
		  else if (isdefined("Form.btnMCLeliminar"))
		  {
		  	fnCicloLectivoMateria_Baja(form.Mcodigo, form.CILcodigo);
		  }
		</cfscript>
	<cfcatch type="any">
		<cfinclude template="../../errorpages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>		
<cfoutput>

<form action="materia.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="CAMBIO">
	<input name="Mcodigo" type="hidden" value="<cfif isdefined("Form.Mcodigo")>#Form.Mcodigo#</cfif>">
	<input name="CILcodigo"  type="hidden" value="<cfif isdefined("Form.CILcodigo")>#Form.CILcodigo#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
