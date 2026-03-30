<!--- Modo del pintado de los campos     --->
<!--- pinta los campos según 3 estados   --->
<!--- si hay el catalogo que buscamos esta en la tabla  OrigenDocumentos  pinta un combo las cuentas en   OrigenCtaMayor--->
<!--- si sucede lo anterior y ademas el catalogo que buscamos tambien se encuentra la tabla OrigenNivelProv  se agrega un campo imput --->
<!--- si susede solamente el 2 caso se pinta una lista de la cuentas localizadas en  OrigenNivelProv y se les agrega un imput a cada una   --->

<form method="post" name="form1"  action="SQLMantComp_Finacieros.cfm">

	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td  style="background-color:#CCCCCC" align="center" colspan="3">
			<cfoutput>
			<strong><font size="2">#form.OPtabla_F#:&nbsp;#form.ODchar_F#</font></strong>
			</cfoutput></td>
		</tr>
		<tr>
			<td colspan="3">&nbsp;</td>
		</tr>				</table> 
	<cf_sifcomplementofinanciero action='display'
		tabla="#form.OPtabla_F#"
		llave="#form.ODchar_F#" /> 
	<center>	
				<input type="submit" name="Alta" value="Guardar">
				<input type="submit" name="Baja" value="Borrar">
		</center>
</form>
