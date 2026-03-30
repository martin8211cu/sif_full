<!--- 
	Modificado por: Ana Villavicencio R.
	Fecha: 16 de setiembre del 2005
	Motivo: Cambiar el formato de la forma. Utilizar el estandar, con los botones arriba en el filtro.
			Se agregaron dos nuevos criterios en el filtro, Periodo y Mes.
			Se modifico la consulta de las facturas a imprimir.  Anteriormente se hacia tomando en cuenta el tipo de movimiento 
			y el monto del documento si CCTipo = 'D' ent a.Dtotal >= 0 sino and a.Dtotal < 0, esta condicion no es correcta debia 
			ser si son documentos de Debito: CCTtipo = 'D' y Dtota > 0, 
			si son documentos de credito: CCTtipo = 'D' y Dtotal < 0 o CCTtipo = 'C' y Dtotal > 0
			
	Modificado por: Ana Villavicencio R.	
	Fecha: 20 de setiembre del 2005
	Motivo: La consulta de la lista de los documentos a imprimir lo estaba haciendo sobre la tabla Documentos, 
			cuando en realidad se tiene que hacer sobre HDocumentos.
			
	Modificado por: Ana Villavicencio
	Fecha: 23 de setiembre del 2005
	Motivo: No estaba haciendo la consulta correctamente, se estaba tomando como periodo y mes, el año  y mes de la fecha del documento.
			Se tiene q hacer la consulta del periodo y mes del movimiento.
			
	Modificado por: Ana Villavicenio
	Fecha: 27 de setiembre del 2005
	Motivo: Se cambio la consulta de las monedas para que tomara en cuenta las monedas q utiliza la empresa
	
	Modificado: Rodolfo Jimenez Jara
	Fecha:		03 de Diciembre del 2005
	Linea 138:		Se arregló para que validara el que SIEMPRE se pidiera el Código del socio, con la función: ValidaSocio();
		
 --->

<cfif isdefined("url.SNcodigo") and not isdefined("form.SNcodigo")>
	<cfparam name="form.SNcodigo" default="#url.SNcodigo#">
</cfif>
<cfif isdefined("url.CCtipo") and not isdefined("form.CCtipo")>
	<cfparam name="form.CCtipo" default="#url.CCtipo#">
</cfif>
<cfif isdefined("url.Mcodigo") and not isdefined("form.Mcodigo")>
	<cfparam name="form.Mcodigo" default="#url.Mcodigo#">
</cfif>
<cfif isdefined("url.Periodo") and not isdefined("form.Periodo")>
	<cfparam name="form.Periodo" default="#url.Periodo#">
</cfif>
<cfif isdefined("url.Mes") and not isdefined("form.Mes")>
	<cfparam name="form.Mes" default="#url.Mes#">
</cfif>

<cfquery name="dataMonedas" datasource="#session.DSN#">
	select Mcodigo, Mnombre
	from Monedas 
	where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	order by Mnombre
</cfquery>

	<cfquery name ="rsPeriodos" datasource="#Session.DSN#">
			select 
				distinct Speriodo 
			from SaldosContables 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
			order by Speriodo desc
	</cfquery>
	<cfquery name="rsPeriodo" datasource="#session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		  and Pcodigo = 30
	</cfquery>
 	<cfset periodo=rsPeriodo.Pvalor>
	<cfquery name="rsMes" datasource="#session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
		  and Pcodigo = 40
	</cfquery>
	<cfset mes=rsMes.Pvalor>
<cfoutput>
<form name="form1" method="post" action="impresionFacturas-sql.cfm" style="margin:0;">

	<table width="98%" align="center" cellpadding="0" cellspacing="0" border="0">
		<tr>
			<td colspan="8">
				<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro"  >
					<tr>
						<td><strong>Socio:&nbsp;</strong></td>
						<td>
							<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
								<cf_sifsociosnegocios2 idquery="#form.SNcodigo#">
							<cfelse>
								<cf_sifsociosnegocios2>
							</cfif>
						</td>
						<td><strong>Tipo de Movimiento :&nbsp;</strong></td>
						<td>
							<select name="CCtipo">
								<option value="D" <cfif isdefined("form.CCTipo") and form.CCTipo eq 'D'>selected</cfif> >D&eacute;bito</option>
								<option value="C" <cfif isdefined("form.CCTipo") and form.CCTipo eq 'C'>selected</cfif> >Cr&eacute;dito</option>
							</select>
						</td>

						<td><strong>Moneda:&nbsp;</strong></td>
						<td>
							<select name="Mcodigo">
								<cfloop query="dataMonedas">
									<option value="#dataMonedas.Mcodigo#" 
									<cfif isdefined("form.Mcodigo") and form.Mcodigo eq dataMonedas.Mcodigo>selected</cfif> >#dataMonedas.Mnombre#</option>
								</cfloop>
							</select>
						</td>
					</tr>
					<tr>
						<td><strong>Periodo:&nbsp;</strong></td>
						<td>
							<select name="periodo"><cfoutput>
								<!--- <option value="2005">2005</option> --->
								<cfloop query = "rsPeriodos">
									<option value="#rsPeriodos.Speriodo#"
									<cfif isdefined('form.periodo') and form.periodo EQ #rsPeriodos.Speriodo#>selected</cfif>>#rsPeriodos.Speriodo#</option>
								</cfloop>
							</select></cfoutput>
						</td>
						<td><strong>Mes:&nbsp;</strong></td>	
						<td>
							<select name="mes" size="1">
								  <option value="1" <cfif isdefined('form.mes') and form.mes EQ 1>selected</cfif>>Enero</option>
								  <option value="2" <cfif isdefined('form.mes') and form.mes EQ 2>selected</cfif>>Febrero</option>
								  <option value="3" <cfif isdefined('form.mes') and form.mes EQ 3>selected</cfif>>Marzo</option>
								  <option value="4" <cfif isdefined('form.mes') and form.mes EQ 4>selected</cfif>>Abril</option>
								  <option value="5" <cfif isdefined('form.mes') and form.mes EQ 5>selected</cfif>>Mayo</option>
								  <option value="6" <cfif isdefined('form.mes') and form.mes EQ 6>selected</cfif>>Junio</option>
								  <option value="7" <cfif isdefined('form.mes') and form.mes EQ 7>selected</cfif>>Julio</option>
								  <option value="8" <cfif isdefined('form.mes') and form.mes EQ 8>selected</cfif>>Agosto</option>
								  <option value="9" <cfif isdefined('form.mes') and form.mes EQ 9>selected</cfif>>Setiembre</option>
								  <option value="10" <cfif isdefined('form.mes') and form.mes EQ 10>selected</cfif>>Octubre</option>
								  <option value="11" <cfif isdefined('form.mes') and form.mes EQ 11>selected</cfif>>Noviembre</option>
								  <option value="12" <cfif isdefined('form.mes') and form.mes EQ 12>selected</cfif>>Diciembre</option>
								</select>
						</td>
						<td align="center" colspan="2">
							<input type="submit" name="Filtrar" value="Ver Resultados" onClick=" return ValidaSocio();">
							<input type="button" name="Aplicar" value="Aplicar" onClick="validar(); ">
							<input type="button" name="Limpiar" value="Limpiar" onClick="limpiar();">
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo)) and isdefined("form.CCtipo") and len(trim(form.CCtipo)) and isdefined("form.Mcodigo") and len(trim(form.Mcodigo)) >
			<!--- DATOS DE LA LISTA 
			<cfif isdefined('form.periodo') and isdefined('form.mes')>
				<cfset fecha = '01/'& form.mes & '/'&form.periodo>
			</cfif>
			<cfdump var="#fecha#">--->
			<cfquery name="data" datasource="#session.DSN#">
				select a.SNcodigo, 
					   c.SNnumero, 
					   c.SNnombre, 
					   a.CCTcodigo, 
					   b.CCTdescripcion, 
					   a.Ddocumento, 
					   a.Mcodigo, 
					   d.Mnombre, 
					   a.Dtipocambio, 
					   a.Dtotal, 
					   a.Dfecha
				from SNegocios c
				inner join HDocumentos a
				   on a.Ecodigo   = c.Ecodigo
				  and a.SNcodigo = c.SNcodigo

					inner join CCTransacciones b
				   on b.Ecodigo=a.Ecodigo
				  and b.CCTcodigo=a.CCTcodigo
				  and b.CCTpago = 0

				inner join BMovimientos bm
				   on bm.Ecodigo 	= a.Ecodigo
				  and bm.CCTcodigo 	= a.CCTcodigo
				  and bm.Ddocumento = a.Ddocumento
				  and bm.SNcodigo 	= a.SNcodigo
				  and bm.CCTRcodigo = a.CCTcodigo
				  and bm.DRdocumento = a.Ddocumento

				inner join Monedas d
				   on a.Mcodigo = d.Mcodigo
				  and a.Ecodigo = d.Ecodigo
				
				where c.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				  and a.Dreferencia is null 
				  <cfif isdefined('form.CCTipo') and trim(form.CCTipo) EQ 'D'>
					and b.CCTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTipo#">
					and a.Dtotal  > 0
				  <cfelse>
				  	and ((b.CCTtipo = <cfqueryparam cfsqltype="cf_sql_char" value="D"> and a.Dtotal < 0) or 
						 (b.CCTtipo =  <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTipo#"> and a.Dtotal > 0)
					)
				  </cfif>

				  <!---cfif Year(Arguments.Efecha) NEQ Arguments.Eperiodo or Month(Arguments.Efecha) NEQ Arguments.Emes--->
				  <cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
					  and c.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
				  </cfif>
				  
				  <cfif isdefined("form.Mcodigo") and len(trim(form.Mcodigo))>
					  and a.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.Mcodigo)#">
				  </cfif>
				  <cfif isdefined("form.Periodo") and LEN(TRIM(form.periodo))>
				  	  and bm.BMperiodo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.Periodo)#">
				  </cfif>
				  <cfif isdefined("form.Mes") and LEN(TRIM(form.Mes))>
				  	  and bm.BMmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.Mes)#">
				  </cfif>
				order by c.SNnumero, a.CCTcodigo, a.Dfecha
			</cfquery>

			<cfquery name="dataTransaccion" datasource="#session.DSN#">
				select CCTcodigo, CCTdescripcion
				from CCTransacciones
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				order by CCTcodigo
			</cfquery>
			
			<cfset corte = ''>
			<tr>
				<td class="tituloListas"><input type="checkbox" name="chk_all" onClick="javascript:check_all(this);"></td>
				<td class="tituloListas" colspan="2">Transacci&oacute;n</td>
				<td class="tituloListas">Documento</td>
				<td class="tituloListas">Fecha</td>
				<td class="tituloListas">Moneda</td>
				<td class="tituloListas" nowrap align="right">Tipo de Cambio</td>
				<td class="tituloListas" align="right">Monto</td>
			</tr>
			
			<cfif data.RecordCount gt 0>
				<cfloop query="data">
					<cfif corte neq data.SNcodigo>
						<tr class='listaCorte'><td colspan="8" style="padding:2px ">
							<strong>Socio: #trim(data.SNnumero)#, #data.SNnombre#</strong>
						</td></tr>
					</cfif>
					
					<tr class="<cfif data.CurrentRow mod 2 eq 0 >listaPar<cfelse>listaNon</cfif>" >
						<td width="1%" style="padding-left:25px;">
							<input type="checkbox" name="chk" value="#data.CurrentRow#" onClick="javascript:contador(this);" >
							<input type="hidden" name="CCTcodigo_#data.CurrentRow#" value="#data.CCTcodigo#">
							<input type="hidden" name="Ddocumento_#data.CurrentRow#" value="#data.Ddocumento#">
							<input type="hidden" name="Dtotal_#data.CurrentRow#" value="#data.Dtotal#">
							<input type="hidden" name="Dfecha_#data.CurrentRow#" value="#LSDateFormat(data.Dfecha,'dd/mm/yyyy')#">
						</td>
						<td>#data.CCTcodigo#</td>
						<td>#data.CCTdescripcion#</td>
						<td>#data.Ddocumento#</td>
						<td>#LSDateFormat(data.Dfecha,'dd/mm/yyyy')#</td>
						<td>#data.Mnombre#</td>
						<td align="right">#LSNumberFormat(data.Dtipocambio,',9.00')#</td>
						<td align="right">#LSNumberFormat(data.Dtotal,',9.00')#</td>
					</tr>
					<cfset corte = data.SNcodigo >
				</cfloop>
			<cfelse>
				<tr><td colspan="8" align="center"><strong>No se encontraron registros</strong></td></tr>
			</cfif>
	
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td colspan="8" align="center">
					<!--- <input type="submit" name="Aplicar" value="Aplicar" onClick="return validar();"> --->
					<input type="hidden" name="cantidad" value="#data.RecordCount#">
				</td>
			</tr>
		<cfelse>
			<tr><td>&nbsp;</td></tr>
			<tr><td colspan="8" align="center">
				<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
					<tr><td><strong>Agrupaci&oacute;n de Facturas</strong></td></tr>
					<tr><td >Para el proceso de agrupaci&oacute;n de documentos, debe seleccionar un valor para los siguientes criterios de agrupaci&oacute;n:</td></tr>
					<tr><td style="padding-left:20px;"><li>Socio de Negocios</li></td></tr>
					<tr><td style="padding-left:20px;"><li>Tipo de Documento (D&eacute;bito, Cr&eacute;dito)</li></td></tr>
					<tr><td style="padding-left:20px;"><li>Moneda</li></td></tr>
				</table>
			</td></tr>
		</cfif>

	</table>
	<input name="fechaFact" type="hidden" value="">
	<input name="idioma" type="hidden" value="">
	<input name="firmaAutorizada" type="hidden" value="">
</form>
</cfoutput>

<script type="text/javascript" language="javascript1.2">
	var checkeados = 0;

	function limpiar(){
		document.form1.SNcodigo.value = '';
		document.form1.SNnumero.value = '';
		document.form1.SNnombre.value = '';
		document.form1.CCtipo.value = '';
	}
	
	function checks(f){
		if (f.chk.length){
			//alert('arreglo')
		}
		else{
			//alert('obj')
		}
	}

	function validar(){
		var f = document.form1;

		if ( checkeados == 0 ){
			alert('No ha seleccionado registros para el proceso.');
			return false
		}
		confirmacion();
		//f.action = 'impresionFacturas-sql.cfm';
		//return true;
	}
	function ValidaSocio(){
		var f = document.form1;

		if ( f.SNcodigo.value == '' ){
			alert('No ha seleccionado el Socio para el proceso.');
			return false
		}
	}
	
	function contador(obj){
		if (obj.checked) {
			checkeados = checkeados + 1;
		}
		else{
			if (checkeados >= 1 ){
				checkeados = checkeados - 1;
			}
		}
	}
	
	function checkAll(f, valor){
		if (f.chk.length){
			for (var i=0; i<f.chk.length; i++ ){
				f.chk[i].checked = valor;
			}
		}
		else{
			f.chk.checked = valor;
		}
	}

	function check_all(obj){
		var f = document.form1;
		if ( obj.checked ){
			checkeados = f.cantidad.value;
			checkAll(f, true);
		}
		else{
			checkeados = 0;
			checkAll(f, false);
		}
	}

	var popUpWin = 0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin){
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=yes,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}

	function confirmacion(){
		popUpWindow("/cfmx/sif/iv/operacion/datosImpresion.cfm",250,200,500,200);
	}
	
</script>