<cfif isdefined('url.Ocodigo') and not isdefined('form.Ocodigo')>
	<cfset form.Ocodigo=url.Ocodigo>
</cfif>
<cfif isdefined('url.fEMAfecha') and not isdefined('form.fEMAfecha')>
	<cfset form.fEMAfecha=url.fEMAfecha>
</cfif>
<cfif isdefined('url.EMAfecha') and not isdefined('form.EMAfecha')>
	<cfset form.EMAfecha=url.EMAfecha>
</cfif>
<cfif isdefined('url.EMAid') and not isdefined('form.EMAid')>
	<cfset form.EMAid=url.EMAid>
</cfif>
<cfif isdefined('form.EMAid') and form.EMAid NEQ ''>
	<cfquery name="rsform" datasource="#session.DSN#">
		Select ea.EMAid
			, ea.EMAfecha
			, ea.Ocodigo
			, o.Odescripcion
			, ea.EMAobs
			, ea.EMAestado
			, case ea.EMAestado
				when 0 then 'En Proceso'
				when 10 then 'Aplicado'
			end EMAestadoDesc
			,ea.ts_rversion
		from EMAlmacen ea
			inner join Oficinas o
				on o.Ecodigo=ea.Ecodigo
					and o.Ocodigo=ea.Ocodigo
		
		where ea.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and ea.EMAid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EMAid#">
	</cfquery>	
</cfif>

<cfset varPista = ''>		  
	<cfoutput> 
	  <table width="100%"  border="0">
        <tr>
          <td colspan="6" class="tituloListas">Movimientos de Mercancía del Dep&oacute;sito en Estaciones de Servicio </td>
        </tr>
        <tr>
          <td colspan="6">&nbsp;		  </td>
        </tr>
        <tr>
          <td width="11%" align="right"><strong>Estaci&oacute;n:</strong></td>
          <td width="23%"> #rsform.Odescripcion#
              <input type="hidden" name="Ocodigo" value="#rsForm.Ocodigo#">          </td>
          <td width="5%" align="right"><strong>Fecha:</strong></td>
          <td width="27%">
			<cfif isdefined("form.fEMAfecha") and len(form.fEMAfecha)>
				<input type="hidden" name="fEMAfecha" value="#DateFormat(form.fEMAfecha, 'dd/mm/yyyy')#">					
			</cfif> 		  
          	<cfif isdefined('rsForm.EMAfecha') and rsForm.EMAfecha NEQ ''>
        		#DateFormat(rsform.EMAfecha, "dd/mmm/yyyy")#
          		<input type="hidden" name="EMAfecha" value="#DateFormat(rsForm.EMAfecha, 'dd/mm/yyyy')#">
          	<cfelse>
				#DateFormat(Now(), "dd/mmm/yyyy")#
				<input type="hidden" name="EMAfecha" value="#DateFormat(Now(), 'dd/mm/yyyy')#">
            </cfif>		  </td>
          <td width="4%" rowspan="2" align="center" valign="middle" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td width="28%" rowspan="2" align="center" valign="middle" nowrap>

			<cfif isdefined('rsform') and rsform.EMAestado EQ '0'>
				<input type="submit" align="middle" name="btnGuardar" value="Guardar">
 				<input type="submit" align="middle" name="btnAplicar" value="Aplicar" onClick="return confirm('Desea aplicar el registro?');"> 
<!---<input type="submit" align="middle" onclick="javascript: return aplica();" name="btnAplicar" value="Aplicar">--->
 					<input type="submit" align="middle" onclick="javascript: return confirm('Desea borrar los datos ?');" name="btnBorrar" value="Borrar">					
			</cfif> 
			      
            <input type="submit" align="middle" name="btnCancelar" value="Cancelar">
			
			<cfif isdefined("form.EMAid") and len(form.EMAid)>
				<input type="hidden" name="EMAid" value="#form.EMAid#">
			<cfelse>
				<input type="hidden" name="EMAid" value="">
			</cfif>
		  	<cfif isdefined('rsform') and rsform.EMAid NEQ ''>
				<cfset ts = "">	
				<cfinvoke 
					component="sif.Componentes.DButils"
					method="toTimeStamp"
					returnvariable="ts">
					<cfinvokeargument name="arTimeStamp" value="#rsform.ts_rversion#"/>
				</cfinvoke>
				<input type="hidden" name="ts_rversion" value="#ts#">				
			</cfif>          </td>
        </tr>
        <tr>
          <td align="right" valign="top"><strong>Observaciones:</strong> </td>
          <td colspan="3">
            <textarea name="EMAobs" cols="60" rows="3" id="EMAobs">#rsform.EMAobs#</textarea>
          </td>
          <td width="1%">&nbsp;</td>
          <td width="1%">&nbsp;</td>
        </tr>		
      </table>
	</cfoutput>
		
<script language="javascript" type="text/javascript">
	function validaMov(){
		if(document.form_Salidas.Ocodigo.value == ''){
			alert('Error, primero debe seleccionar una estación');
			
			return false;
		}

		if(new Number(document.form_Salidas.cantReg.value) > 0){
			var cantR = new Number(document.form_Salidas.cantReg.value);
			var valor = 0;
			var vInvIni = 0;
			var vCompras = 0;
			var vInvFin = 0;
			var vDescrArt = '';			

			for (var i=1; i < cantR; i++){
					valor = eval("new Number(document.form_Salidas.idDetSuma_" + i + ".value)");
					vInvIni = eval("new Number(document.form_Salidas.DMAinvIni_" + i + ".value)");
					vCompras = eval("new Number(document.form_Salidas.DMAcompra_" + i + ".value)");
					vInvFin = eval("new Number(document.form_Salidas.DMAinvFin_" + i + ".value)");
					vDescrArt = eval("document.form_Salidas.articuloDescr_" + i + ".value");					
			
				if(vInvFin < (vInvIni + vCompras)){
					var invFinAct= (vInvIni + vCompras) - vInvFin;
					if((valor > invFinAct) || (valor < invFinAct)){
						alert("Error, las unidades por salidas reportadas para el articulo " + vDescrArt + " son diferentes a las faltantes en el inventario final (" + invFinAct + ")");
						return false;
					}
				}
			}
		}
				
		return true;
	}

	function refresca(){
		document.form_Salidas.action = 'capturaSalidas-Mant.cfm';
		document.form_Salidas.submit();
	}
	
	function aplica(){
		if(confirm('Desea aplicar el registro?')){
			alert('APLICACION A INVENTARIO');
		}
		
		return false;
	}
</script>