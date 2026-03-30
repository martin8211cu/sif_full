<form action="GeneraPagadoPresupuesto.cfm" method="post" onsubmit="return confirma()">		
	<table align="center" width="80%">
		<tr>
			<td align="right">
				Numero de NAP:
			</td>
			<td>
				<input name="CPNAPNUM" id="CPNAPNUM"   type="text" size="10" maxlength="20" placeholder="NAP">	
			</td>
		</tr>
		<tr>
			<td align="right">
				Pasar <strong>TODO</strong> el NAP de Ejecusion a Pagado(1)
			</td>
			<td align="left">
				<input type="radio" name="Tipo" id="Tipo" value="T" checked="checked" />
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>EXCLUIR</strong> cuentas especiales de RH (2): 
			</td>
			<td align="left">
				<input type="radio" name="Tipo" id="Tipo" value="E" />
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>SOLAMENTE</strong> cuentas especiales de RH (3): 
			</td>
			<td align="left">
				<input type="radio" name="Tipo" id="Tipo" value="I" />
			</td>
		</tr>
		<tr>
			<td align="right">
				Pasar <strong>TODO</strong> el NAP de Ejecusion a Pagado MES SIGUIENTE(4)
			</td>
			<td align="left">
				<input type="radio" name="Tipo" id="Tipo" value="S"/>
			</td>
		</tr>
		<tr>
			<td align="right">
				<strong>SOLAMENTE</strong> Provicion de Aguinaldo (5): 
			</td>
			<td align="left">
				<input type="radio" name="Tipo" id="Tipo" value="A" />
			</td>
		</tr>
		<tr>
			<td colspan="2" align="center">
				<input name="btnGenerar" type="submit" value="Generar NAP de Pagado">	
			</td>
		</tr>
		<tr>
			<td colspan="2">
				<br /><font size="-1">(1) Este proceso lo que hara es tomar un Nap y generar un nuevo Nap de Pagado con todas las cuentas que movieron Ejecucion y aun movieron Pagado</font>
					<ul>
						<li><strong>SIN EXCLUCIONES</strong></li>
					</ul>
				<br />
					<font size="-1">(2) Este proceso lo que hara es tomar un Nap y generar un nuevo Nap de Pagado con todas las cuentas que movieron Ejecucion y aun no movieron Pagado
						<ul>
							<li><strong>CON EXCLUCIONES</strong></li>
							<li>0005-0-03-03% Provicion de Aguinaldo</li>
							<li>0005-0-04% 	  Cargas Sociales</li>
							<li>0005-0-05%    Carga Sociales Excepto 0005-0-05-05% Asociación Solidarista</li>
						</ul>
					</font>
					<font size="-1">(3) Este proceso lo que hara es tomar un Nap y generar un nuevo Nap de Pagado con todas las cuentas que movieron Ejecucion y aun no movieron Pagado
						<ul>
							<li><strong>UNICAMENTE</strong></li>
							<li>0005-0-04% 	  Cargas Sociales</li>
							<li>0005-0-05%    Carga Sociales Excepto 0005-0-05-05% Asociación Solidarista</li>
							<li><strong>ADEMAS</strong></li>
							<li>El Nap Afecta el Mes siguiente</li>
						</ul>
					</font>
					<font size="-1">(4) Este proceso lo que hara es tomar un Nap y generar un nuevo Nap de Pagado con todas las cuentas que movieron Ejecucion y aun no movieron Pagado
						<ul>
							<li><strong>SIN EXCLUCIONES</strong></li>
							<li><strong>ADEMAS</strong></li>
							<li>El Nap Afecta el Mes siguiente</li>
						</ul>
					</font>
					<font size="-1">(5) Este proceso lo que hara es tomar un Nap y generar un nuevo Nap de Pagado con todas las cuentas que movieron Ejecucion y aun no movieron Pagado
						<ul>
							<li><strong>UNICAMENTE</strong></li>
							<li>0005-0-03-03% Provicion de Aguinaldo</li>
						</ul>
					</font>
			</td>
		</tr>
	</table>
</form>
<script>
	function confirma(){
		if (document.getElementById('CPNAPNUM').value == '')
		{	
			alert('Debe especificar el numero de NAP');
			return false;
		}
		var Tipos = document.getElementsByName('Tipo');
		var Mensaje;
		for(var i = 0; i < Tipos.length; i++){
			if(Tipos[i].checked){
				if(Tipos[i].value == 'T')
					Mensaje = 'SIN EXCEPCION';
				else if (Tipos[i].value == 'E') 
					Mensaje = 'CON EXCEPCION';
				else if (Tipos[i].value == 'I') 
					Mensaje = 'UNICAMENTE EXCEPCION';
				else if (Tipos[i].value == 'S') 
					Mensaje = 'TODO MES SIGUIENTE';
				else if (Tipos[i].value == 'A') 
					Mensaje = 'UNICAMENTE PROVISION DE AGUINALDO ';
			}
		}
		if (confirm('SEGURO QUE DESEA PROCESAR EL NAP:' + document.getElementById('CPNAPNUM').value + '\n ' + Mensaje))
			return true;
		else
			return false;
	}
</script>
<cfif isdefined('form.btnGenerar')>
	<cfif NOT LEN(TRIM(form.CPNAPNUM))>
		<script>
			alert('No especifico el numero de NAP');
		</script>
	<cfelse>
		<cfinvoke component="sif.Componentes.PRES_Presupuesto" method="GenerarPagado" returnvariable="LvarNuevoNAP">
				<cfinvokeargument name="CPNAPNUM" value="#form.CPNAPNUM#">
			<cfif isdefined('form.Tipo') and form.Tipo EQ 'E'>
				<cfinvokeargument name="FiltroExtra" value="and  cp.CPformato NOT LIKE '0005-0-03-03%'
													        and  cp.CPformato NOT LIKE '0005-0-04%'
													        and (cp.CPformato NOT LIKE '0005-0-05%' OR cp.CPformato like '0005-0-05-05%')">
			<cfelseif isdefined('form.Tipo') and form.Tipo EQ 'I'>
				<cfinvokeargument name="AfectaMesSiguiente" value="true">
				<cfinvokeargument name="NumeroReferencia"   value="NAP Manual(Excepción)">
				<cfinvokeargument name="FiltroExtra" value="and (cp.CPformato LIKE '0005-0-04%'
													             OR (cp.CPformato LIKE '0005-0-05%' AND cp.CPformato NOT LIKE '0005-0-05-05%')
																 )">
			<cfelseif isdefined('form.Tipo') and form.Tipo EQ 'S'>
				<cfinvokeargument name="AfectaMesSiguiente" value="true">
			<cfelseif isdefined('form.Tipo') and form.Tipo EQ 'A'>
				<cfinvokeargument name="NumeroReferencia"   value="NAP Manual(Excepción)">
				<cfinvokeargument name="FiltroExtra" value="and cp.CPformato LIKE '0005-0-03-03%'">
			</cfif>
		</cfinvoke>
		<cfoutput>
			NAP DE EJECUCION: #form.CPNAPNUM#
			NAP DE PAGADO: #LvarNuevoNAP#
		</cfoutput>
	</cfif>
</cfif>