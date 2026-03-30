<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 26 de mayo del 2005
	Motivo:	Nuevo reporte de Movimientos bancarios
----------->
<!----
		Modificado por Hector Garcia Beita
		Motivo: validador para la redirección en caso de ser invocada desde la 
		opcion de conciliacion bancaria de el modulo de tarjetas de
		credito empresariales mediante un include
---> 

<cfset LvarIrARPRegisMovBancFrame="RPRegistroMovBancarios-frame.cfm">
 <cfif isdefined("LvarTCERPRegisMovBanca")>
	<cfset LvarIrARPRegisMovBancFrame="TCERPRegistroMovBancarios-frame.cfm">
</cfif>


<cfif isdefined("url.EMid") and  not isdefined("form.EMid")>
	<cfset form.EMid = url.EMid>
</cfif>


<form name="form1" method   = "post" name = "movimiento" >
 <table border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td><strong>Visualizar en formato:</strong></td>
		<td>
			<select name="formato">
				<option value="">---SELECCIONE UN FORMATO---</option>
				<option value="flashpaper">FLASHPAPER</option>
				<option value="pdf">PDF</option>
				<option value="excel">EXCEL</option>
			</select>
		</td>
		<td><input name="visualiza" type="submit" value="Generar"></td>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
</form>
<cfoutput>
<iframe id="frReporteMovimientos" frameborder="0" width="100%" 
	height="85%" src="<cfoutput>#LvarIrARPRegisMovBancFrame#</cfoutput>?EMid=#form.EMid#<cfif isdefined('form.Formato')>&formato=#form.formato#</cfif>"></iframe></cfoutput>
