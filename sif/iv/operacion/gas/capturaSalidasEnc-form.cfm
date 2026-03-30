<cfif isdefined('url.Ocodigo') and not isdefined('form.Ocodigo')>
	<cfset form.Ocodigo=url.Ocodigo>
</cfif>
<cfif isdefined('url.pista') and not isdefined('form.pista')>
	<cfset form.pista=url.pista>
</cfif>
<cfif isdefined('url.turno') and not isdefined('form.turno')>
	<cfset form.turno=url.turno>
</cfif>
<cfif isdefined('url.fSPfecha') and not isdefined('form.fSPfecha')>
	<cfset form.fSPfecha=url.fSPfecha>
</cfif>
<cfif isdefined('url.ID_salprod') and not isdefined('form.ID_salprod')>
	<cfset form.ID_salprod=url.ID_salprod>
</cfif>

<cfif isdefined('form.Ocodigo') and form.Ocodigo NEQ '' and isdefined('form.pista') and form.pista NEQ '' and isdefined('form.turno') and form.turno NEQ ''>
	<cfquery name="rsform" datasource="#session.DSN#">
		Select esp.ID_salprod,esp.Observaciones,esp.SPestado,SPfecha,o.Ocodigo, Oficodigo, Odescripcion,tof.Turno_id,Tdescripcion
		,HI_turno,HF_turno,p.Pista_id,Descripcion_pista,esp.ts_rversion
		from Oficinas o
			inner join Turnoxofi tof
				on o.Ocodigo=tof.Ocodigo
					and o.Ecodigo=tof.Ecodigo
		
			inner join Turnos tu
				on tof.Turno_id=tu.Turno_id
					and tof.Ecodigo=tu.Ecodigo
					and tof.Turno_id=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.turno#">
			inner join Pistas p
				on o.Ocodigo=p.Ocodigo
					and o.Ecodigo=p.Ecodigo
					and p.Pista_id=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.pista#">	
			left outer join ESalidaProd esp
				on o.Ecodigo=esp.Ecodigo
					and o.Ocodigo=esp.Ocodigo
					and p.Pista_id=esp.Pista_id
					and tu.Turno_id=esp.Turno_id
					<cfif isdefined('form.ID_salprod') and form.ID_salprod NEQ ''>
						and esp.ID_salprod=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ID_salprod#">
					</cfif>					
  					 <cfif isdefined("form.fSPfecha") and len(form.fSPfecha)>
						and esp.SPfecha >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fSPfecha)#">
					</cfif>
		where o.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and o.Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">		
			and Testado=1
			and Pestado=1
	</cfquery>
	
<!--- 
	Nota: La linea de la fecha invalidada en el query de abajo estaba produciendo que no se pintara ninguno de los 
	botones del mantenimiento, por tal motivo descomente las lineas que hab[ian comentado y comente la que esta
	actualmente comentada y que impedia que se pintaran los botones para el mantenimiento.
	Roy P.
 --->	
	
	<cfquery name="rsPistasTurnos" datasource="#session.DSN#">
		Select esp.ID_salprod,SPfecha,SPestado,tof.Turno_id,Tdescripcion,HI_turno,HF_turno,p.Pista_id,Descripcion_pista
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
					and esp.SPfecha <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fSPfecha)#"> 					
		where o.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and o.Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">
			and Testado=1
			and Pestado=1			
	</cfquery>

	<cfquery name="rsTurnos" dbtype="query">
		Select distinct Turno_id,Tdescripcion,HI_turno,HF_turno
		from rsPistasTurnos
		order by Turno_id
	</cfquery> 	

	<cfquery name="rsPistas" dbtype="query">
		Select Turno_id,Pista_id,Descripcion_pista, SPfecha,ID_salprod
		from rsPistasTurnos
		order by Turno_id,Pista_id,Descripcion_pista
	</cfquery>	
</cfif>
<cfset varPista = ''>		  
<cfif isdefined('form.pista') and form.pista NEQ ''>
	<cfset varPista = form.pista>
</cfif>	
	<cfoutput> 
	  <table width="100%"  border="0">
        <tr>
          <td colspan="6" class="tituloListas">Salidas en Estaciones de Servicio </td>
        </tr>
        <tr>
          <td colspan="6">&nbsp;		  </td>
        </tr>
        <tr>
          <td width="10%" align="right"><strong>Estaci&oacute;n:</strong></td>
          <td width="35%"> #rsform.Odescripcion#
              <input type="hidden" name="Ocodigo" value="#rsForm.Ocodigo#">          </td>
          <td width="8%" align="right"><strong>Turno:</strong></td>
          <td width="21%"><select name="turno"  onChange="javascript:cambiar_turno(this.value,#varPista#);cambiaPista(this.form.pista_cb);refresca();">
              <cfif isdefined('rsTurnos') and rsTurnos.recordCount GT 0>
                <cfloop query="rsTurnos">
					<option value="#rsTurnos.Turno_id#" <cfif isdefined('form.turno') and form.turno NEQ '' and form.turno EQ rsTurnos.Turno_id> selected</cfif>> #rsTurnos.Tdescripcion#&nbsp;&nbsp;(#TimeFormat(rsTurnos.HI_turno, "hh:mm:sstt")#--#TimeFormat(rsTurnos.HF_turno, "hh:mm:sstt")#) </option>
                </cfloop>
              </cfif>
          </select></td>
          <td width="21%" rowspan="2" align="center" valign="middle" nowrap>&nbsp;&nbsp;&nbsp;&nbsp;</td>
          <td width="21%" rowspan="2" align="center" valign="middle" nowrap>
		  
		  <cfif isdefined('rsform') and rsform.SPestado NEQ '10'>
			<cfif isdefined('rsform') and rsform.SPestado EQ ''>
				<input type="submit" align="middle" name="btnAgregar" value="Agregar">
			</cfif>
			<cfif isdefined('rsform') and rsform.SPestado EQ '0'>
				<input type="submit" align="middle" name="btnGuardar" value="Guardar">
<!---  					<input type="submit" align="middle" onclick="javascript: return aplica();" name="btnAplicar" value="Aplicar"> --->
 					<input type="submit" align="middle" onclick="javascript: return confirm('Desea borrar los datos ?');" name="btnBorrar" value="Borrar">					
			</cfif> 
		  </cfif>
			      
            <input type="submit" align="middle" name="btnCancelar" value="Cancelar">
			
			<cfif isdefined("form.ID_salprod") and len(form.ID_salprod)>
				<input type="hidden" name="ID_salprod" value="#form.ID_salprod#">
			<cfelse>
				<input type="hidden" name="ID_salprod" value="">
			</cfif>
		  	<cfif isdefined('rsform') and rsform.ID_salprod NEQ ''>
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
          <td align="right"><strong>Fecha:</strong></td>
          <td>
			<cfif isdefined("form.fSPfecha") and len(form.fSPfecha)>
				<input type="hidden" name="fSPfecha" value="#DateFormat(form.fSPfecha, 'dd/mm/yyyy')#">					
			</cfif> 		  
          	<cfif isdefined('rsForm.SPfecha') and rsForm.SPfecha NEQ ''>
        		#DateFormat(rsform.SPfecha, "dd/mmm/yyyy")#
          		<input type="hidden" name="SPfecha" value="#DateFormat(rsForm.SPfecha, 'dd/mm/yyyy')#">
          	<cfelse>
				#DateFormat(Now(), "dd/mmm/yyyy")#
				<input type="hidden" name="SPfecha" value="#DateFormat(Now(), 'dd/mm/yyyy')#">
            </cfif>          </td>
          <td align="right"><strong>Pista:</strong></td>
          <td>
            <select name="pista_cb" onChange="javascript: cambiaPista(this); refresca();">
            </select>			
          <input type="hidden" name="pista" value="">          </td>
        </tr>
        <tr>
          <td valign="top"><strong>Observaciones:</strong></td>
          <td colspan="3"><textarea name="Observaciones" cols="60" rows="3" id="Observaciones">#rsform.Observaciones#</textarea></td>
          <td align="center">&nbsp;
		  </td>
          <td>&nbsp;</td>
        </tr>		
      </table>
	</cfoutput>

<script language="javascript" type="text/javascript">
	function valida(){
		if(document.form_Salidas.Ocodigo.value == ''){
			alert('Error, primero debe seleccionar una estación');
			
			return false;
		}
		if(document.form_Salidas.turno.value == ''){
			alert('Error, primero debe seleccionar un turno');
			
			return false;
		}		
		if(document.form_Salidas.pista_cb.value == ''){
			alert('Error, primero debe seleccionar una pista');
			
			return false;
		}		
				
		return true;
	}
	
	function cambiar_turno(valor, selected ){
		if ( valor!= "" ) {
			// Pistas por turno
			document.form_Salidas.pista_cb.length = 0;
			i = 0;
						
			<cfoutput query="rsPistas">
				if ( #Trim(rsPistas.Turno_id)# == valor ){
					document.form_Salidas.pista_cb.length = i+1;
					<cfif isdefined('rsPistas.ID_salprod') and rsPistas.ID_salprod NEQ ''>
						document.form_Salidas.pista_cb.options[i].value = '#rsPistas.pista_id#~#rsPistas.ID_salprod#';
					<cfelse>
						document.form_Salidas.pista_cb.options[i].value = '#rsPistas.pista_id#~*';
					</cfif>								
					
					<cfif isdefined('rsPistas.SPfecha') and rsPistas.SPfecha NEQ ''>
						document.form_Salidas.pista_cb.options[i].text  = "#rsPistas.Descripcion_pista# ( #DateFormat(rsPistas.SPfecha, 'mm/dd/yyyy')# )";					
					<cfelse>
						document.form_Salidas.pista_cb.options[i].text  = "#rsPistas.Descripcion_pista#";					
					</cfif>						

					if ( selected == #Trim(rsPistas.Pista_id)# ){
						<cfif isdefined('form.ID_salprod') and form.ID_salprod NEQ '' and isdefined('rsPistas.ID_salprod') and rsPistas.ID_salprod NEQ ''>
							if ( '#form.ID_salprod#' == '#rsPistas.ID_salprod#' ){
								document.form_Salidas.pista_cb.options[i].selected=true;
							}
						<cfelse>
							document.form_Salidas.pista_cb.options[i].selected=true;
						</cfif>						
					}
					i++;
				};
			</cfoutput>
		}
		return;
	}
	
	function cambiaPista(pista){
		var valPista = pista.value;
		var p = valPista.split("~");
		document.form_Salidas.pista.value = p[0];
		if(p[1] != '*')
			document.form_Salidas.ID_salprod.value = p[1];
		else
			document.form_Salidas.ID_salprod.value = '';
	}
		
	function refresca(){
		document.form_Salidas.action = 'capturaSalidas-Mant.cfm';
		
		document.form_Salidas.submit();
	}
	
	function aplica(){
		if(confirm('Desea aplicar el registro?')){
			alert('PROCESO DE APLICACION PENDIENTE');
		}
		
		return false;
	}
	
	cambiar_turno(document.form_Salidas.turno.value,<cfoutput>#varPista#</cfoutput>);
	cambiaPista(document.form_Salidas.pista_cb);	
</script>