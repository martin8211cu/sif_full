<cfif isdefined("Form.Eid") and len(trim(Form.Eid))>
	<cfquery name="rsEncu"  datasource="#session.dsn#">
		select Edescripcion
		from Encuesta e
			inner join EncuestaEmpresa ee
				on e.EEid=ee.EEid
		where Eid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Eid#">
	</cfquery>
</cfif>
<!--- Pantalla --->
<cfset titulo = "">
<cfset indicacion = "">
<cfif form.Paso EQ 0>
	<cfset titulo = "Registro de Encuestas Salariales">
	<cfset indicacion = "Defina aqui una encuesta salarial">
<cfelseif form.Paso EQ 1>
	<cfset titulo = "Encuestas">
	<cfif isdefined("Form.Eid") and len(trim(Form.Eid))>
		<cfset indicacion = "#rsEncu.Edescripcion#">
	<cfelse>
		<cfset indicacion = "Nueva Encuesta">
	</cfif>
<cfelseif form.Paso EQ 2>
	<cfset titulo = "Registro de los datos para la encuesta">
	<cfset indicacion = "#rsEncu.Edescripcion#">
</cfif>
<style type="text/css">
<!--
.style1 {font-size: 14px}
-->
</style>

<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="4">
		<tr>
			<td width="1%" align="right">
				<img border="0" src="/cfmx/rh/imagenes/number#form.Paso#_64.gif" align="absmiddle">
			</td>
			<td style="padding-left: 10px;" valign="top">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td style="border-bottom: 1px solid black " nowrap><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#titulo#</strong></td>
					</tr>
					<tr>
						<td strong align="left" nowrap bgcolor="##F2F2F2" class="tituloPersona style1"><font size="4">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</font> #indicacion#</td>
					</tr>
				</table>
			</td>
	  	</tr>	
	</table>
</cfoutput>
