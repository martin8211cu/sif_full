<!--- Pantalla --->
<cfset titulo = "">
<cfset indicacion = "">
<cfif Paso EQ 1>
	<cfset titulo = "Par&aacute;metros Generales">
	<cfset indicacion = "Definici&oacute;n de Par&aacute;metros del Sistema">
<cfelseif Paso EQ 2>
	<cfset titulo = "Par&aacute;metros Varios">
	<cfset indicacion = "Definici&oacute;n de Par&aacute;metros del Sistema">
<cfelseif Paso EQ 3>
	<cfset titulo = "Formas de Pago">
	<cfset indicacion = "Definici&oacute;n de Par&aacute;metros del Sistema">
<cfelseif Paso EQ 4>
	<cfset titulo = "Otros Par&aacute;metros">
	<cfset indicacion = "Definici&oacute;n de Par&aacute;metros del Sistema">
</cfif>
<cfoutput>
	<table width="100%" border="0" cellspacing="0" cellpadding="4">
	  <tr>
			<td width="1%" align="right">
				<img border="0" src="/cfmx/sif/imagenes/number#Paso#_64.gif" align="absmiddle">
			</td>
			<td style="padding-left: 10px;" valign="top">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
					<td style="border-bottom: 1px solid black " nowrap><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#titulo#</strong></td>
					</tr>
					<tr>
						<td class="tituloPersona" align="left" style="text-align:left" nowrap>#indicacion#</td>
					</tr>
				</table>
			</td>
	  </tr>
	</table>
</cfoutput>