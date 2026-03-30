<cfif isdefined("Form.Cambio")>  
	<cfset modoAgenda="CAMBIO">
<cfelse>  
	<cfif not isdefined("Form.modoAgenda")>    
		<cfset modoAgenda="ALTA">
	<cfelseif Form.modoAgenda EQ "CAMBIO">
		<cfset modoAgenda="CAMBIO">
	<cfelse>
		<cfset modoAgenda="ALTA">
	</cfif>  
</cfif>
<cfif isdefined("url.id_agenda") and Len("url.id_agenda") gt 0 >
	<cfset form.id_agenda = url.id_agenda >
</cfif>

<cfquery name="rsTipoServ" datasource="#session.tramites.dsn#">
	select id_tiposerv,codigo_tiposerv,nombre_tiposerv
	from TPTipoServicio
	where id_inst=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
	order by nombre_tiposerv
</cfquery>

<cfif isdefined('rsTipoServ') and rsTipoServ.recordCount GT 0>
	<cfquery name="rsTipoServID" dbtype="query">
		select id_tiposerv
		from rsTipoServ
	</cfquery>

	<cfquery name="rsRequisito" datasource="#session.tramites.dsn#">
		Select id_requisito,id_tiposerv,codigo_requisito,nombre_requisito
		from TPRequisito
		where getDate() between vigente_desde and vigente_hasta
			<cfif isdefined('rsTipoServID') and rsTipoServID.recordCount GT 0>
 				and id_tiposerv in (#ValueList(rsTipoServID.id_tiposerv)#)
			</cfif>
		order by nombre_requisito
	</cfquery>
</cfif>

<cfquery name="rsRecurso" datasource="#session.tramites.dsn#">
	Select i.id_inst
		, id_recurso
		, r.id_sucursal
		, r.id_direccion
		, codigo_recurso
		, nombre_recurso
		, nombre_sucursal
		, ('(' || rtrim(codigo_recurso) || ')- ' || nombre_recurso) as sucursal
	
	from TPRecurso r
		inner join TPSucursal s
			on s.id_sucursal=r.id_sucursal
		inner join TPInstitucion i
			on i.id_inst=s.id_inst
				and i.id_inst=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
	where id_recurso=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_recurso#">
</cfquery>

<cfif isdefined('rsRecurso') and rsRecurso.recordCount GT 0>
	<cfquery name="rsDireccion" datasource="#session.tramites.dsn#">
		select id_direccion,direccion1, direccion2,ciudad, pais
		from TPDirecciones
		where id_direccion=<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsRecurso.id_direccion#">
	</cfquery>
</cfif>

<cfif isdefined("Form.id_recurso") AND Len(Trim(Form.id_recurso)) GT 0 
		and isdefined("Form.id_inst") AND Len(Trim(Form.id_inst)) GT 0 
		and isdefined("Form.id_agenda") AND Len(Trim(Form.id_agenda)) GT 0 >
	<cfset modoAgenda="CAMBIO">
	
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		Select id_agenda
			, id_tiposerv
			, id_recurso
			, id_direccion
			, id_inst
			, id_sucursal
			, id_responsable
			, hora_desde
			, hora_hasta
			, id_requisito
			, cupo
			, vigente_desde
			, vigente_hasta
			, dia_semanal
			, ts_rversion
		from TPAgenda 
		where id_agenda=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_agenda#">
	</cfquery>
</cfif>

<cfoutput>
	<form method="post" name="formAgenda" action="recursos/agendaIn-sql.cfm">
		<cfif isdefined('rsRecurso') and rsRecurso.recordCount GT 0>
			<input type="hidden" name="id_inst" value="#rsRecurso.id_inst#">				
			<input type="hidden" name="id_recurso" value="#rsRecurso.id_recurso#">
		</cfif>	
		<cfif isdefined('rsDireccion') and rsDireccion.recordCount GT 0>
			<input type="hidden" name="id_direccion" value="#rsDireccion.id_direccion#">	
		</cfif>
								
        <table align="center" width="78%" cellpadding="2" cellspacing="0">
          <tr>
            <td colspan="2">&nbsp;</td>
          </tr>
          <tr valign="baseline">
            <td width="14%" align="right" nowrap><strong>Sucursal:</strong></td>
            <td width="86%">
              <cfif isdefined('rsRecurso') and rsRecurso.recordCount GT 0>
&nbsp;&nbsp;#rsRecurso.nombre_sucursal#
        <input type="hidden" name="id_sucursal" value="#rsRecurso.id_sucursal#">
        <cfelse>
&nbsp;
              </cfif>
            </td>
          </tr>
          <tr valign="baseline">
            <td width="14%" align="right" nowrap><strong>Tipo de Servicio:</strong></td>
            <td width="86%">
              <select name="id_tiposerv" id="select" onChange="javascript: cargaReq(this.value,<cfif modoAgenda NEQ "ALTA" and rsDatos.id_requisito NEQ ''>#rsDatos.id_requisito#<cfelse>'*'</cfif>);">
                <option value="-1">- Ninguno -</option>
                <cfif isdefined('rsTipoServ') and rsTipoServ.recordCount GT 0>
                  <cfloop query="rsTipoServ">
                    <option value="#rsTipoServ.id_tiposerv#" <cfif modoAgenda NEQ "ALTA" and rsDatos.id_tiposerv EQ rsTipoServ.id_tiposerv> selected</cfif>>(#rsTipoServ.codigo_tiposerv#) #rsTipoServ.nombre_tiposerv#</option>
                  </cfloop>
                </cfif>
              </select>
            </td>
          </tr>
          <tr valign="baseline">
            <td nowrap align="right"><strong>Requisito :</strong></td>
            <td>
              <select name="id_requisito" id="select2">
                <option value="*">- Seleccione un tipo de servicio -</option>
              </select>
            </td>
          </tr>
          <tr valign="baseline">
            <td width="14%" align="right" nowrap><strong>Responsable:</strong></td>
            <td width="86%">
              <cfset values = "">
              <cfif modoAgenda NEQ "ALTA" and rsDatos.id_responsable NEQ ''>
                <cfquery name="rsFuncio" datasource="#session.tramites.dsn#">
        select id_inst ,id_funcionario, nombre, apellido1, apellido2 from TPFuncionario f inner join TPPersona p on p.id_persona=f.id_persona where id_inst = 3 and id_funcionario =
        <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.id_responsable#">
                </cfquery>
                <cfif isdefined('rsFuncio') and rsFuncio.recordCount GT 0>
                  <cfset values = rsFuncio.id_funcionario & "," & rsFuncio.nombre & "," & rsFuncio.apellido1 & "," & rsFuncio.apellido2>
                </cfif>
              </cfif>
              <cf_conlis title="Lista de Funcionarios"
					campos = "id_funcionario,nombre,apellido1,apellido2" 
					desplegables = "N,S,S,S" 
					size = "0,30,20,20"
					values="#values#"
					tabla="TPFuncionario f
							inner join TPPersona p
								on p.id_persona=f.id_persona"
					columnas="id_funcionario,nombre,apellido1,apellido2"
					filtro="id_inst = #form.id_inst# and getDate() between vigente_desde and vigente_hasta
							order by nombre, apellido1, apellido2"
					desplegar="nombre,apellido1,apellido2"
					etiquetas="Nombre,Primer Apellido,Segundo Apellido"
					formatos="S,S,S"
					align="left,left,left"
					asignar="id_funcionario,nombre,apellido1,apellido2"
					conexion="#session.tramites.dsn#"
					form = "formAgenda"> </td>
          </tr>
          <tr valign="baseline">
            <td nowrap align="right"><strong>Hora desde :</strong></td>
            <td>
              <cfif modoAgenda NEQ "ALTA">
                <cfset hora_D = LSTimeFormat(rsDatos.hora_desde, 'HH')>
                <cfset minut_D = LSTimeFormat(rsDatos.hora_desde, 'mm')>
                <cfset hora_H = LSTimeFormat(rsDatos.hora_hasta, 'HH')>
                <cfset minut_H = LSTimeFormat(rsDatos.hora_hasta, 'mm')>
              </cfif>
              <select name="hora_desde" id="select3">
                <option value="00" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '00'> selected</cfif>>00</option>
                <option value="01" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '01'> selected</cfif>>01</option>
                <option value="02" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '02'> selected</cfif>>02</option>
                <option value="03" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '03'> selected</cfif>>03</option>
                <option value="04" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '04'> selected</cfif>>04</option>
                <option value="05" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '05'> selected</cfif>>05</option>
                <option value="06" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '06'> selected</cfif>>06</option>
                <option value="07" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '07'> selected</cfif>>07</option>
                <option value="08" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '08'> selected</cfif>>08</option>
                <option value="09" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '09'> selected</cfif>>09</option>
                <option value="10" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '10'> selected</cfif>>10</option>
                <option value="11" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '11'> selected</cfif>>11</option>
                <option value="12" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '12'> selected</cfif>>12</option>
                <option value="13" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '13'> selected</cfif>>13</option>
                <option value="14" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '14'> selected</cfif>>14</option>
                <option value="15" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '15'> selected</cfif>>15</option>
                <option value="16" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '16'> selected</cfif>>16</option>
                <option value="17" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '17'> selected</cfif>>17</option>
                <option value="18" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '18'> selected</cfif>>18</option>
                <option value="19" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '19'> selected</cfif>>19</option>
                <option value="20" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '20'> selected</cfif>>20</option>
                <option value="21" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '21'> selected</cfif>>21</option>
                <option value="22" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '22'> selected</cfif>>22</option>
                <option value="23" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '23'> selected</cfif>>23</option>
                <option value="24" <cfif modoAgenda NEQ "ALTA" and hora_D EQ '24'> selected</cfif>>24</option>
              </select>
              <select name="min_desde" id="min_desde">
                <option value="00" <cfif modoAgenda NEQ "ALTA" and minut_D EQ '00'> selected</cfif>>00</option>
                <option value="05" <cfif modoAgenda NEQ "ALTA" and minut_D EQ '05'> selected</cfif>>05</option>
                <option value="10" <cfif modoAgenda NEQ "ALTA" and minut_D EQ '10'> selected</cfif>>10</option>
                <option value="15" <cfif modoAgenda NEQ "ALTA" and minut_D EQ '15'> selected</cfif>>15</option>
                <option value="20" <cfif modoAgenda NEQ "ALTA" and minut_D EQ '20'> selected</cfif>>20</option>
                <option value="25" <cfif modoAgenda NEQ "ALTA" and minut_D EQ '25'> selected</cfif>>25</option>
                <option value="30" <cfif modoAgenda NEQ "ALTA" and minut_D EQ '30'> selected</cfif>>30</option>
                <option value="35" <cfif modoAgenda NEQ "ALTA" and minut_D EQ '35'> selected</cfif>>35</option>
                <option value="40" <cfif modoAgenda NEQ "ALTA" and minut_D EQ '40'> selected</cfif>>40</option>
                <option value="45" <cfif modoAgenda NEQ "ALTA" and minut_D EQ '45'> selected</cfif>>45</option>
                <option value="50" <cfif modoAgenda NEQ "ALTA" and minut_D EQ '50'> selected</cfif>>50</option>
                <option value="55" <cfif modoAgenda NEQ "ALTA" and minut_D EQ '55'> selected</cfif>>55</option>
                <option value="60" <cfif modoAgenda NEQ "ALTA" and minut_D EQ '60'> selected</cfif>>60</option>
              </select>
      hora/min</td>
          </tr>
          <tr valign="baseline">
            <td nowrap align="right"><strong>Hora hasta :</strong></td>
            <td>
              <select name="hora_hasta" id="hora_hasta">
                <option value="00" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '00'> selected</cfif>>00</option>
                <option value="01" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '01'> selected</cfif>>01</option>
                <option value="02" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '02'> selected</cfif>>02</option>
                <option value="03" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '03'> selected</cfif>>03</option>
                <option value="04" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '04'> selected</cfif>>04</option>
                <option value="05" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '05'> selected</cfif>>05</option>
                <option value="06" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '06'> selected</cfif>>06</option>
                <option value="07" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '07'> selected</cfif>>07</option>
                <option value="08" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '08'> selected</cfif>>08</option>
                <option value="09" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '09'> selected</cfif>>09</option>
                <option value="10" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '10'> selected</cfif>>10</option>
                <option value="11" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '11'> selected</cfif>>11</option>
                <option value="12" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '12'> selected</cfif>>12</option>
                <option value="13" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '13'> selected</cfif>>13</option>
                <option value="14" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '14'> selected</cfif>>14</option>
                <option value="15" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '15'> selected</cfif>>15</option>
                <option value="16" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '16'> selected</cfif>>16</option>
                <option value="17" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '17'> selected</cfif>>17</option>
                <option value="18" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '18'> selected</cfif>>18</option>
                <option value="19" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '19'> selected</cfif>>19</option>
                <option value="20" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '20'> selected</cfif>>20</option>
                <option value="21" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '21'> selected</cfif>>21</option>
                <option value="22" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '22'> selected</cfif>>22</option>
                <option value="23" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '23'> selected</cfif>>23</option>
                <option value="24" <cfif modoAgenda NEQ "ALTA" and hora_H EQ '24'> selected</cfif>>24</option>
              </select>
              <select name="min_hasta" id="select6">
                <option value="00" <cfif modoAgenda NEQ "ALTA" and minut_H EQ '00'> selected</cfif>>00</option>
                <option value="05" <cfif modoAgenda NEQ "ALTA" and minut_H EQ '05'> selected</cfif>>05</option>
                <option value="10" <cfif modoAgenda NEQ "ALTA" and minut_H EQ '10'> selected</cfif>>10</option>
                <option value="15" <cfif modoAgenda NEQ "ALTA" and minut_H EQ '15'> selected</cfif>>15</option>
                <option value="20" <cfif modoAgenda NEQ "ALTA" and minut_H EQ '20'> selected</cfif>>20</option>
                <option value="25" <cfif modoAgenda NEQ "ALTA" and minut_H EQ '25'> selected</cfif>>25</option>
                <option value="30" <cfif modoAgenda NEQ "ALTA" and minut_H EQ '30'> selected</cfif>>30</option>
                <option value="35" <cfif modoAgenda NEQ "ALTA" and minut_H EQ '35'> selected</cfif>>35</option>
                <option value="40" <cfif modoAgenda NEQ "ALTA" and minut_H EQ '40'> selected</cfif>>40</option>
                <option value="45" <cfif modoAgenda NEQ "ALTA" and minut_H EQ '45'> selected</cfif>>45</option>
                <option value="50" <cfif modoAgenda NEQ "ALTA" and minut_H EQ '50'> selected</cfif>>50</option>
                <option value="55" <cfif modoAgenda NEQ "ALTA" and minut_H EQ '55'> selected</cfif>>55</option>
                <option value="60" <cfif modoAgenda NEQ "ALTA" and minut_H EQ '60'> selected</cfif>>60</option>
              </select>
      hora/min </td>
          </tr>
          <tr valign="baseline">
            <td nowrap align="right"><strong>Cupo :</strong></td>
            <td>
              <input type="text" name="cupo" value="<cfif modoAgenda NEQ 'ALTA'>#rsDatos.cupo#<cfelse>0</cfif>" tabindex="1" size="4" maxlength="4" style="text-align: right;" onBlur="javascript:fm(this,-1);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" >
            </td>
          </tr>
          <tr valign="baseline">
            <td nowrap align="right" valign="middle"> <strong>Vigente desde :</strong></td>
            <td>
				<cfif modoAgenda NEQ 'ALTA'>
				  <cf_sifcalendario form="formAgenda" name="vigente_desde" value="#LSDateFormat(rsDatos.vigente_desde,'dd/mm/yyyy')#" tabindex="1">
				  <cfelse>
				  <cf_sifcalendario form="formAgenda" name="vigente_desde" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
				</cfif>			
			</td>
          </tr>
          <tr valign="baseline">
            <td nowrap align="right" valign="middle"> <strong>Vigente hasta :</strong></td>
            <td>
				<cfif modoAgenda NEQ 'ALTA'>
				  <cf_sifcalendario form="formAgenda" name="vigente_hasta" value="#LSDateFormat(rsDatos.vigente_hasta,'dd/mm/yyyy')#" tabindex="1">
				  <cfelse>
				  <cf_sifcalendario form="formAgenda" name="vigente_hasta" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
				</cfif>	
			</td>
          </tr>  
          <tr valign="baseline">
            <td nowrap align="right" valign="top"><strong>D&iacute;a de la semana :</strong></td>
            <td>
              <table width="100%"  border="0" cellspacing="0" cellpadding="0">
                <tr align="center">
                  <td>Domingo</td>
                  <td>Lunes</td>
                  <td>Martes</td>
                  <td>Mi&eacute;rcoles</td>
                  <td>Jueves</td>
                  <td>Viernes</td>
                  <td>S&aacute;bado</td>
                </tr>
				
				<cfif modoAgenda NEQ 'ALTA'>
					<cfset arrayDias = ListToArray(rsDatos.dia_semanal,',')>
				</cfif>
				
                <tr align="center">
                  <td><input type="checkbox" name="dia_1" value="1" <cfif modoAgenda NEQ 'ALTA' and isdefined('arrayDias') and arrayDias[1] EQ 1> checked</cfif>></td>
                  <td><input type="checkbox" name="dia_2" value="1" <cfif modoAgenda NEQ 'ALTA' and isdefined('arrayDias') and arrayDias[2] EQ 1> checked</cfif>></td>
                  <td><input type="checkbox" name="dia_3" value="1" <cfif modoAgenda NEQ 'ALTA' and isdefined('arrayDias') and arrayDias[3] EQ 1> checked</cfif>></td>
                  <td><input type="checkbox" name="dia_4" value="1" <cfif modoAgenda NEQ 'ALTA' and isdefined('arrayDias') and arrayDias[4] EQ 1> checked</cfif>></td>
                  <td><input type="checkbox" name="dia_5" value="1" <cfif modoAgenda NEQ 'ALTA' and isdefined('arrayDias') and arrayDias[5] EQ 1> checked</cfif>></td>
                  <td><input type="checkbox" name="dia_6" value="1" <cfif modoAgenda NEQ 'ALTA' and isdefined('arrayDias') and arrayDias[6] EQ 1> checked</cfif>></td>
                  <td><input type="checkbox" name="dia_7" value="1" <cfif modoAgenda NEQ 'ALTA' and isdefined('arrayDias') and arrayDias[7] EQ 1> checked</cfif>></td>
                </tr>
            </table></td>
          </tr>
          <tr>
            <td>&nbsp;</td>
          </tr>
          <tr valign="baseline">
            <td colspan="2" align="center" nowrap> <cf_botones modo="#modoAgenda#" sufijo="_Ag" include="btnLista" includevalues="Lista de Recursos"> </td>
          </tr>
          <cfset ts = "">
          <cfif modoAgenda NEQ "ALTA">
            <cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsDatos.ts_rversion#" returnvariable="ts"> </cfinvoke>
            <input type="hidden" name="ts_rversion" value="<cfif modoAgenda NEQ "ALTA">#ts#</cfif>">
            <input type="hidden" name="id_agenda" value="#form.id_agenda#">
          </cfif>
      </table>
	</form>
</cfoutput>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm_Agenda = new qForm("formAgenda");
	
	function _isFechasAgen(){
		var valorINICIO=0;
		var valorFIN=0;
		var INICIO = document.formAgenda.vigente_desde.value;
		var FIN = this.value;
		
		INICIO = INICIO.substring(6,10) + INICIO.substring(3,5) + INICIO.substring(0,2)
		FIN = FIN.substring(6,10) + FIN.substring(3,5) + FIN.substring(0,2)
		valorINICIO = parseInt(INICIO)
		valorFIN = parseInt(FIN)

		if (valorINICIO > valorFIN)
			this.error="Error, la fecha de inicio de vigencia (" + document.formAgenda.vigente_desde.value + ") no debe ser mayor que la fecha final de vigencia (" + this.value + ")";
	}	
	function _isHoras(){
		var horaIni=document.formAgenda.hora_desde.value;
		var minIni=document.formAgenda.min_desde.value;	
		var horaFin=this.value;
		var minFin = document.formAgenda.hora_hasta.value;		

		if ((parseInt(horaIni) > parseInt(horaFin)) || ((parseInt(horaIni) == parseInt(horaFin)) && 
				(parseInt(minIni) > parseInt(minFin))))
			this.error="Error, la hora de inicio no debe ser mayor que la hora final. ";
	}		
	
	_addValidator("isFechasAgen", _isFechasAgen);	
	_addValidator("isHoras", _isHoras);			
	objForm_Agenda.id_recurso.required = true;
	objForm_Agenda.id_recurso.description="Recurso";				
	objForm_Agenda.hora_desde.required = true;
	objForm_Agenda.hora_desde.description="Hora desde";	
	
	function funcAlta_Ag(){
		objForm_Agenda.vigente_hasta.validateFechasAgen();
		objForm_Agenda.hora_hasta.validateHoras();
	}	
	function funcCambio_Ag(){
		objForm_Agenda.vigente_hasta.validateFechasAgen();
		objForm_Agenda.hora_hasta.validateHoras();
	}		
	function funcNuevo_Ag(){
		deshabilitarValidacionAg();
	}
	function funcBaja_Ag(){
		deshabilitarValidacionAg();
		if( confirm('¿Desea Eliminar el Registro?') )
			return true;
		
		return false;
	}		
	function deshabilitarValidacionAg(){
		objForm_Agenda.id_recurso.required = false;
		objForm_Agenda.hora_desde.required = false;
		objForm_Agenda.hora_hasta.required = false;
		objForm_Agenda.vigente_hasta.required = false;
	}	

	function cargaReq(valor,requisito){
		var form = document.formAgenda;
		var combo = form.id_requisito;
				
		// borrar combo de requisitos
		var opcion = combo.firstChild;
		while (opcion != null) {
			var siguiente = opcion.nextSibling;
			combo.removeChild(opcion);
			opcion = siguiente;
		}
		<cfif isdefined('rsRequisito') and rsRequisito.recordCount GT 0>
			if(valor != '-1'){
				opcion = document.createElement("OPTION");
				opcion.value = '-1';
				var texto = document.createTextNode('- Ninguno -');
				opcion.appendChild(texto);
				combo.appendChild(opcion);		
				<cfoutput query="rsRequisito">
					var tmp = #rsRequisito.id_tiposerv#;
					if ( valor != '' && tmp != '' && parseFloat(valor) == parseFloat(tmp) ) {
						opcion = document.createElement("OPTION");
						opcion.value = '#trim(rsRequisito.id_requisito)#';
						
						texto = document.createTextNode('(#rsRequisito.codigo_requisito#) #rsRequisito.nombre_requisito#');
						opcion.appendChild(texto)
						if ((requisito != '*') && ('#rsRequisito.id_requisito#' == requisito)) {
							opcion.setAttribute("selected","selected")
						}
						combo.appendChild(opcion)
					}
				</cfoutput>
			}else{
				opcion = document.createElement("OPTION");
				opcion.value = '*';
				var texto = document.createTextNode('- Seleccione un tipo de servicio -');
				opcion.appendChild(texto);
				combo.appendChild(opcion);					
			}
		<cfelse>
			opcion = document.createElement("OPTION");
			opcion.value = '*';
			var texto = document.createTextNode('- Seleccione un tipo de servicio -');
			opcion.appendChild(texto);
			combo.appendChild(opcion);		
		</cfif>
	}
	function funcbtnLista_Ag(){
		deshabilitarValidacionAg();
	}
	<cfif modoAgenda NEQ "ALTA">
		<cfif rsDatos.id_requisito NEQ ''>
			cargaReq(document.formAgenda.id_tiposerv.value,'<cfoutput>#rsDatos.id_requisito#</cfoutput>');	
		<cfelse>
			cargaReq(document.formAgenda.id_tiposerv.value,'*');	
		</cfif>	
	<cfelse>
		cargaReq(document.formAgenda.id_tiposerv.value,'*');	
	</cfif>	
</SCRIPT>

