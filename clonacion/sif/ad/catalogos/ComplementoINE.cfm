<!---
	Autor: Ing. Oscar Orlando Parrales Villanueva
	Fecha: 03/05/2016
	Descripcion: (Complemento INE)
				Pantalla que servira para asignar al Socio de Negocios
				un Tipo Politico y un IdContabilidad cuando este sea
				necesario.
 --->
<cfset 	socActual = #form.SNcodigo#>
<cfquery name="datos" datasource="#session.dsn#">
	select
		SNTipoPoliticoINE as politico,
		SNIDContabilidadINE as contabilidad
	from
		SNegocios s
	where
		s.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#socActual#">
</cfquery>
<html>
	<body >
		<form action="ComplementoINE-sql.cfm" onsubmit="return validaContenido()" method="post" name="form" id="form1">
			<input type="hidden" id="socioActual" name="socioActual" value='<cfoutput>#socActual#</cfoutput>'>
			<table align="center">
				<tr>
					<td><h1>Tipo Politico:</h1></td>
					<td>
						<select id="tipoPolitico" name="tipoPolitico">
							<option value="N">-- Seleccione --</option>
							<cfif datos.RecordCount gt 0>
								<cfif datos.politico eq 'C'>
									<option value="C" selected="true">Candidato</option>
						  			<option value="P">Partido Pol&iacute;tico</option>
						  		<cfelseif datos.politico eq 'P'>
						  			<option value="C">Candidato</option>
						  			<option value="P" selected="true">Partido Pol&iacute;tico</option>
						  		<cfelse>
									<option value="C">Candidato</option>
							  		<option value="P">Partido Pol&iacute;tico</option>
								</cfif>
							<cfelse>
								<option value="C">Candidato</option>
						  		<option value="P">Partido Pol&iacute;tico</option>
							</cfif>
						</select>
					</td>
				</tr>
				<tr>
					<td><h1>Id Contabilidad INE:&nbsp;</h1></td>
					<cfset idConta = (datos.RecordCount gt 0) ? datos.contabilidad : "">
					<td><input type="text" name="IDContable" id="IDContable" value="<cfoutput>#idConta#</cfoutput>" maxlength="6" size="13" onKeypress="if (event.keyCode < 45 || event.keyCode > 57) event.returnValue = false;"></td>

				</tr>
				<tr>
				</tr>
			</table>
			<div align="center">
				<cf_botones names="Cambio" values="Guardar">
				<!--- <input type="submit" title="Nuevo" > --->
			</div>
		</form>
	</body>
</html>

<script>
	function validaContenido()
	{
		if(document.getElementById('tipoPolitico').value == 'N' && document.getElementById('IDContable').value.length > 0)
		{
			alert('Seleccione un tipo politico');
			return false;
		}
		if(document.getElementById('tipoPolitico').value == 'C')
		{
			if(document.getElementById('IDContable').value.length < 6)
			{
				alert("La cantidad de numeros del IdContabilidad debe ser de 6 digitos");
				return false;
			}
		}
		if(document.getElementById('tipoPolitico').value == 'P')
		{
			if(document.getElementById('IDContable').value.length < 5 || document.getElementById('IDContable').value.length > 5)
			{
				alert("La cantidad de numeros del IdContabilidad debe ser de 5 digitos");
				return false;
			}
		}
		return true;
	}
</script>