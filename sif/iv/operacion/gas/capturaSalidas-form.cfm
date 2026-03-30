<!--- <cfdump var="#form#"> --->
	<cfset totalCreditos = 0>
	<cfset totalDebitos = 0>
<cfif isdefined('form.fSPfecha') and form.fSPfecha NEQ '' and isdefined('form.f_Ocodigo') and form.f_Ocodigo NEQ ''>
	<cfquery name="rsSalidas" datasource="#session.DSN#">
		Select esp.ID_salprod
				, esp.SPestado
				, SPfecha
				, o.Ocodigo
				, Oficodigo
				, Odescripcion
				, tof.Turno_id
				, Tdescripcion
				, HI_turno
				, HF_turno
				, p.Pista_id
				, Descripcion_pista
		from Oficinas o
			inner join Turnoxofi tof
				on o.Ocodigo=tof.Ocodigo
					and o.Ecodigo=tof.Ecodigo
		
			inner join Turnos tu
				on tof.Turno_id=tu.Turno_id
					and tof.Ecodigo=tu.Ecodigo
		
			inner join Pistas p
				on o.Ocodigo=p.Ocodigo
					and o.Ecodigo=p.Ecodigo
		
			left outer join ESalidaProd esp
				on o.Ecodigo=esp.Ecodigo
					and o.Ocodigo=esp.Ocodigo
					and p.Pista_id=esp.Pista_id
					and tu.Turno_id=esp.Turno_id
					and esp.SPfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fSPfecha)#">					
		where o.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and o.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">		
			and Testado=1
			and Pestado=1
		order by Turno_id,Pista_id
	</cfquery>
	
	<cfquery name="rsTotCuentas" datasource="#session.DSN#">
		Select a.ID_salprod,SPfecha
		from ESalidaProd a
			inner join TotDebitosCreditos b
				on b.Ecodigo=a.Ecodigo
					and b.ID_salprod=a.ID_salprod
		
		where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">
			and SPfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fSPfecha)#">
	</cfquery>	
	
	<cfif isdefined('rsSalidas') and rsSalidas.recordCount GT 0>
		<cfquery name="rsEnProceso" dbtype="query">
			Select *
			from rsSalidas
			where SPestado = 0
		</cfquery>
		
		<cfif isdefined('form.fSPfecha') and form.fSPfecha NEQ ''
				and isdefined('rsEnProceso') and rsEnProceso.recordCount GT 0>
			<cfquery name="rsTotCreditos" datasource="#session.DSN#">
				select 
						sum((coalesce(b.Unidades_vendidas,0) * (coalesce(b.Precio,0))) + 
						(((coalesce(b.Unidades_vendidas,0) * (coalesce(b.Precio,0))) * coalesce(c1.Iporcentaje,0)) / 100
						)) as totCreditos
				from ESalidaProd a
					inner join DSalidaProd b
						on b.Ecodigo=a.Ecodigo	
							and b.ID_salprod=a.ID_salprod
				
					inner join Articulos c
						on c.Ecodigo=b.Ecodigo
							and c.Aid=b.Aid
				
					left outer join Impuestos c1
						on c1.Ecodigo=c.Ecodigo
							and c1.Icodigo=c.Icodigo	
	
				where a.SPestado = 0
					and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">
					and a.SPfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fSPfecha)#">
			</cfquery>					
			<cfquery name="rsTotCreditos_totales" datasource="#session.DSN#">
				select sum(coalesce(a.TDCtotal,0)) as totalCred
				from TotDebitosCreditos a
					inner join ESalidaProd b
						on b.Ecodigo=a.Ecodigo
							and b.SPestado = 0
							and b.ID_salprod=a.ID_salprod
							and b.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">
							and b.SPfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fSPfecha)#">
				
				where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.TDCtipo='C'				
			</cfquery>	
			<cfquery name="rsTotDebitos_totales" datasource="#session.DSN#">
				select sum(coalesce(a.TDCtotal,0)) as totalDeb
				from TotDebitosCreditos a
					inner join ESalidaProd b
						on b.Ecodigo=a.Ecodigo
							and b.SPestado = 0
							and b.ID_salprod=a.ID_salprod
							and b.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">
							and b.SPfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fSPfecha)#">
				
				where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and a.TDCtipo='D'
			</cfquery>						
			<cfif isdefined('rsTotCreditos') and rsTotCreditos.recordCount GT 0 and rsTotCreditos.totCreditos GT 0>
				<cfset totalCreditos = totalCreditos + rsTotCreditos.totCreditos>
			</cfif>
			<cfif isdefined('rsTotCreditos_totales') and rsTotCreditos_totales.recordCount GT 0 and rsTotCreditos_totales.totalCred GT 0>
				<cfset totalCreditos = totalCreditos + rsTotCreditos_totales.totalCred>
			</cfif>
			<cfif isdefined('rsTotDebitos_totales') and rsTotDebitos_totales.recordCount GT 0 and rsTotDebitos_totales.totalDeb GT 0>
				<cfset totalDebitos = totalDebitos + rsTotDebitos_totales.totalDeb>
			</cfif>	
		</cfif>			
	</cfif>
</cfif>
<style type="text/css">
<!--
.style1 {color: #0000CC}
.style3 {color: #996600}
.style4 {color: #6699CC}
-->
</style>

<cf_templatecss>
<form name="form_fSalidas" method="post" action="" onSubmit="javascript: return valida(this);">
	<input type="hidden" name="montoDebitos" value="<cfif totalDebitos GT 0><cfoutput>#totalDebitos#</cfoutput><cfelse>0</cfif>"/>
	<input type="hidden" name="montoCreditos" value="<cfif totalCreditos GT 0><cfoutput>#totalCreditos#</cfoutput><cfelse>0</cfif>"/>
	
  <table width="99%" align="center" border="0" cellpadding="0" cellspacing="0">
	  <tr>
		  <td width="10%" align="right">
			<strong>Estaci&oacute;n</strong>:</td>
		  <td width="35%">
		  	<cfif isdefined('form.f_Ocodigo') and form.f_Ocodigo NEQ ''>
				<cf_sifoficinas form="form_fSalidas" Ocodigo="f_Ocodigo" id="#form.f_Ocodigo#">
			<cfelse>
				<cf_sifoficinas form="form_fSalidas" Ocodigo="f_Ocodigo">
			</cfif>
		  </td>
		  <td width="17%" rowspan="2" align="center" valign="middle">
		  	<input type="submit" align="middle" name="btnConsultar" value="Consultar">			
			<cfif isdefined('form.f_Ocodigo') and form.f_Ocodigo NEQ ''
					and isdefined('form.fSPfecha') and form.fSPfecha NEQ ''
					and isdefined('rsSalidas') and rsSalidas.recordCount GT 0
					and isdefined('rsEnProceso') and rsEnProceso.recordCount GT 0>
			  	<input type="submit" align="middle" name="btnBorrar" onclick="javascript:return borrando();" value="Borrar">
  				<input type="submit" align="middle" name="btnAplicar" value="Aplicar" onClick="return aplicando();">				
			</cfif>
		  </td>
	</tr>
		<tr>
		  <td align="right"><strong>Fecha</strong>:</td>
		  <td>
			<cfif isdefined("form.fSPfecha") and len(trim(form.fSPfecha))>
				<cf_sifcalendario form="form_fSalidas" name="fSPfecha" value="#form.fSPfecha#">
			<cfelse>
				<cf_sifcalendario form="form_fSalidas" name="fSPfecha" value="#DateFormat(Now(), 'dd/mm/yyyy')#">
			</cfif>			  
		  </td>
	  </tr>
		<cfif isdefined('rsSalidas') and rsSalidas.recordCount GT 0>
		  <tr>
			  <td colspan="3">&nbsp;</td>
		  </tr>
		  <tr>
			  <td colspan="3"><hr></td>
		  </tr>
		</cfif>
  </table>
</form>
	
	
<script language="javascript" type="text/javascript">
	var popUpWin=0;
	function popUpWindow(URLStr, left, top, width, height){
		if(popUpWin) {
			if(!popUpWin.closed) popUpWin.close();
		}
		popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbars=yes,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
		window.onfocus = closePopUp;
	}
	function closePopUp(){
		if(popUpWin) {
			if(!popUpWin.closed) popUpWin.close();
			popUpWin=null;
		}
	}
	function valida(f){
		if(f.f_Ocodigo.value == ''){
			alert('Error, primero debe seleccionar una estación');		
			
			return false;
		}
		if(f.fSPfecha.value == ''){
			alert('Error, la fecha es requerida');
			f.fSPfecha.focus();
			return false;
		}		
		
		return true;
	}
	
	function borrando(){
		if(confirm('Desea borrar los datos ?'))
			document.form_fSalidas.action = 'borraAplicaSalidas.cfm';
		else
			return false;
			
		return true;
	}
	function aplicando(){
		if(confirm('Desea aplicar los datos ?')){
			var numMontoDebitos = new Number(document.form_fSalidas.montoDebitos.value);
			var numMontoCreditos = new Number(document.form_fSalidas.montoCreditos.value);			
			
			if((numMontoDebitos > numMontoCreditos) || (numMontoDebitos < numMontoCreditos)){
				alert('Error, el registro de las ventas no esta balanceado. Débitos: ' + numMontoDebitos + ' y Créditos: ' + numMontoCreditos + ', por tal motivo no se permite postear.');
				return false;
			}else{
				document.form_fSalidas.action = 'borraAplicaSalidas.cfm';
			}
			
//			alert('PROCESO DE APLICACION PENDIENTE');
//			return false;
		}else{
			return false;
		}
			
		
		return true;
	}
	
	function doConlisTotales(par){
		if(par != '')
			popUpWindow("/cfmx/sif/iv/operacion/gas/totalesImportados.cfm?ID_salprod=" + par,250,200,650,400);
	}	

</script>	
	
	
<cfif isdefined('rsSalidas') and rsSalidas.recordCount GT 0>
	<table width="90%"  cellpadding="0" cellspacing="0" border="0">
	  <tr>
		<td colspan="3" class="tituloListas">Lista de Salidas de Mercanc&iacute;as</td>
	  </tr>
	  <cfif isdefined('form.fSPfecha') and form.fSPfecha NEQ ''>
		  <cfoutput>
			<tr class="tituloListas">
				<td colspan="3">
					<strong>
						#DayofWeekAsString(DayOfWeek(LSParseDateTime(form.fSPfecha)))# #Day(LSParseDateTime(form.fSPfecha))# de #MonthAsString(Month(LSParseDateTime(form.fSPfecha)))# del #Year(LSParseDateTime(form.fSPfecha))# 
					</strong>			  
				  <cfif isdefined('rsTotCuentas') and rsTotCuentas.recordCount GT 0>
					  <a href="##" tabindex="-1">
							<img id="VendImagen" src="/cfmx/sif/imagenes/Description.gif" alt="Montos Totales por Cuenta" name="VendImagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisTotales('#rsTotCuentas.ID_salprod#');">
					  </a>				  
				  <cfelse>
					&nbsp;			  
				  </cfif>						
				</td>
			</tr>	  
		</cfoutput>
	  </cfif>	  
			 
	  <cfset vTurno = "">
	  
	  <cfoutput query="rsSalidas">
			<cfset params="?Ocodigo=#form.f_Ocodigo#&turno=#rsSalidas.Turno_id#&pista=#rsSalidas.Pista_id#">
			<cfif isdefined('form.fSPfecha') and len(trim(form.fSPfecha))>
				<cfset params=params & "&fSPfecha=#form.fSPfecha#">
			</cfif>	  
			<cfif vTurno NEQ rsSalidas.Turno_id>
				<cfset vTurno = rsSalidas.Turno_id>
	
				<tr class="tituloListas">
					<td width="8%">&nbsp;</td>
					<td colspan="2">
						<strong>
							#rsSalidas.Tdescripcion# (#TimeFormat(rsSalidas.HI_turno, "hh:mm:sstt")# -- #TimeFormat(rsSalidas.HF_turno, "hh:mm:sstt")#)
						</strong>
					</td>
				</tr>			
			</cfif>		
		  
			<cfset LvarListaNon = (CurrentRow MOD 2)>
		  <tr class=<cfif LvarListaNon>"listaNon"<cfelse>"listaPar"</cfif> onmouseover="this.className='listaParSel';" onmouseout="this.className='<cfif LvarListaNon>listaNon<cfelse>listaPar</cfif>';">
			<td>&nbsp;</td>
			<td width="9%">&nbsp;</td>
			<td width="83%">
				<cfif rsSalidas.SPestado EQ ''>
					<a href="capturaSalidas-Mant.cfm#params#">
						#rsSalidas.Descripcion_pista#, <span class="style1">pendiente (elija para agregar)</span> 
					</a>
				<cfelseif rsSalidas.SPestado EQ 0>
					<a href="capturaSalidas-Mant.cfm#params#&ID_salprod=#rsSalidas.ID_salprod#">
						#rsSalidas.Descripcion_pista#, <span class="style3"> en proceso</span>			  
					</a>	
				<cfelseif rsSalidas.SPestado EQ 10>			
					<a href="capturaSalidas-Mant.cfm#params#">
						#rsSalidas.Descripcion_pista#, <span class="style4">aplicada (solo consulta)</span>
					</a>	
				</cfif>
			</td>
		  </tr>
		</cfoutput>	  
	</table>
</cfif>
