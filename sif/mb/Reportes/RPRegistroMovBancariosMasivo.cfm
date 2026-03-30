<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 26 de mayo del 2005
	Motivo:	Nuevo reporte de Movimientos bancarios
----------->
<cfif isdefined("form.lista") and  not isdefined("url.lista")>
	<cfset form.lista = form.lista>
</cfif>
<cfif not isdefined("form.lista") and  isdefined("url.lista")>
	<cfset form.lista = url.lista>
</cfif>



<form name="form1" method   = "post" name = "movimiento" >
 <table border="0" cellspacing="0" cellpadding="0" align="center">
	<tr>
		<td><strong>Visualizar en formato:</strong></td>
		<td>
			<select name="formato">
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
<cfif not isdefined('form.Formato')>
	<cfset form.formato = 'flashpaper'>
</cfif>
<iframe id="frReporteMovimientos" frameborder="0" width="100%" 
height="85%" src="RPRegistroMovBancariosMasivo-frame.cfm?lista=#form.lista#<cfif isdefined('form.Formato')>&formato=#form.formato#</cfif>"></iframe></cfoutput>
