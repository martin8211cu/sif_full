<cfif isdefined("Form.Cambio")>  
	<cfset modo="CAMBIO">
<cfelse>  
	<cfif not isdefined("Form.modo")>    
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>  
</cfif>
<cfif isdefined("url.id_agenda") and Len("url.id_agenda") gt 0 >
	<cfset form.id_agenda = url.id_agenda >
</cfif>

<cfquery name="rsTipoRec" datasource="#session.tramites.dsn#">
	select id_tiporecurso
		, Codigo_Recurso
		, Nombre_Recurso
	from TPTipoRecurso
	order by Nombre_Recurso
</cfquery>

<cfif isdefined("Form.id_inst") AND Len(Trim(Form.id_inst)) GT 0 
		and isdefined("Form.id_agendaserv") AND Len(Trim(Form.id_agendaserv)) GT 0 >
	<cfset modo="CAMBIO">
	
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		SELECT 
			id_agendaserv
			, id_sucursal
			, id_tiposerv
			, id_tiporecurso
			, hora_desde
			, hora_hasta
			, hora_inicomida
			, hora_fincomida
			, periodicidad
			, cupo
			, dia_semanal
			, BMUsucodigo
			, BMfechamod
			, ts_rversion
		from TPAgendaServicio 
		where id_agendaserv = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.id_agendaserv#">
	</cfquery>
</cfif>

<script src="/cfmx/sif/js/qForms/qforms.js"></script>
<script src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfoutput>							
	<cfif isdefined('form.tabsuc')>
		<input type="hidden" name="tabsuc" value="#form.tabsuc#">
	</cfif>			  
	<cfif isdefined('form.tabserv')>
		<input type="hidden" name="tabserv" value="#form.tabserv#">
	</cfif>		
	<input type="hidden" name="tab" value="#form.tab#">
	
	<table align="center" width="85%" cellpadding="2" cellspacing="0">
	  <tr>
		<td colspan="2">&nbsp;</td>
	  </tr>	 	
	  <tr>
		<td align="right"><strong>Tipo de Agenda: </strong></td>
		<td>
		  <select name="id_tiporecurso" id="id_tiporecurso">
			<cfif isdefined('rsTipoRec') and rsTipoRec.recordCount GT 0>
			  <cfloop query="rsTipoRec">
				<option value="#rsTipoRec.id_tiporecurso#" <cfif modo NEQ "ALTA" and rsDatos.id_tiporecurso EQ rsTipoRec.id_tiporecurso> selected</cfif>>(#rsTipoRec.Codigo_Recurso#) #rsTipoRec.Nombre_Recurso#</option>
			  </cfloop>
			</cfif>
		  </select>		
		</td>		
	  </tr> 
	  <tr valign="baseline">
		<td nowrap align="right"><strong>Hora desde :</strong></td>
		<td>
		  <cfif modo NEQ "ALTA">
			<cfset hora_D = LSTimeFormat(rsDatos.hora_desde, 'HH')>
			<cfset minut_D = LSTimeFormat(rsDatos.hora_desde, 'mm')>
			<cfset hora_H = LSTimeFormat(rsDatos.hora_hasta, 'HH')>
			<cfset minut_H = LSTimeFormat(rsDatos.hora_hasta, 'mm')>
		  </cfif>
		  <select name="hora_desde" id="hora_desde">
			<option value="0" <cfif modo NEQ "ALTA" and hora_D EQ '00'> selected</cfif>>00</option>
			<option value="1" <cfif modo NEQ "ALTA" and hora_D EQ '01'> selected</cfif>>01</option>
			<option value="2" <cfif modo NEQ "ALTA" and hora_D EQ '02'> selected</cfif>>02</option>
			<option value="3" <cfif modo NEQ "ALTA" and hora_D EQ '03'> selected</cfif>>03</option>
			<option value="4" <cfif modo NEQ "ALTA" and hora_D EQ '04'> selected</cfif>>04</option>
			<option value="5" <cfif modo NEQ "ALTA" and hora_D EQ '05'> selected</cfif>>05</option>
			<option value="6" <cfif modo NEQ "ALTA" and hora_D EQ '06'> selected</cfif>>06</option>
			<option value="7" <cfif modo NEQ "ALTA" and hora_D EQ '07'> selected</cfif>>07</option>
			<option value="8" <cfif modo NEQ "ALTA" and hora_D EQ '08'> selected</cfif>>08</option>
			<option value="9" <cfif modo NEQ "ALTA" and hora_D EQ '09'> selected</cfif>>09</option>
			<option value="10" <cfif modo NEQ "ALTA" and hora_D EQ '10'> selected</cfif>>10</option>
			<option value="11" <cfif modo NEQ "ALTA" and hora_D EQ '11'> selected</cfif>>11</option>
			<option value="12" <cfif modo NEQ "ALTA" and hora_D EQ '12'> selected</cfif>>12</option>
			<option value="13" <cfif modo NEQ "ALTA" and hora_D EQ '13'> selected</cfif>>13</option>
			<option value="14" <cfif modo NEQ "ALTA" and hora_D EQ '14'> selected</cfif>>14</option>
			<option value="15" <cfif modo NEQ "ALTA" and hora_D EQ '15'> selected</cfif>>15</option>
			<option value="16" <cfif modo NEQ "ALTA" and hora_D EQ '16'> selected</cfif>>16</option>
			<option value="17" <cfif modo NEQ "ALTA" and hora_D EQ '17'> selected</cfif>>17</option>
			<option value="18" <cfif modo NEQ "ALTA" and hora_D EQ '18'> selected</cfif>>18</option>
			<option value="19" <cfif modo NEQ "ALTA" and hora_D EQ '19'> selected</cfif>>19</option>
			<option value="20" <cfif modo NEQ "ALTA" and hora_D EQ '20'> selected</cfif>>20</option>
			<option value="21" <cfif modo NEQ "ALTA" and hora_D EQ '21'> selected</cfif>>21</option>
			<option value="22" <cfif modo NEQ "ALTA" and hora_D EQ '22'> selected</cfif>>22</option>
			<option value="23" <cfif modo NEQ "ALTA" and hora_D EQ '23'> selected</cfif>>23</option>
			<option value="24" <cfif modo NEQ "ALTA" and hora_D EQ '24'> selected</cfif>>24</option>
		  </select>
		  <select name="min_desde" id="min_desde">
			<option value="0" <cfif modo NEQ "ALTA" and minut_D EQ '00'> selected</cfif>>00</option>
			<option value="5" <cfif modo NEQ "ALTA" and minut_D EQ '05'> selected</cfif>>05</option>
			<option value="10" <cfif modo NEQ "ALTA" and minut_D EQ '10'> selected</cfif>>10</option>
			<option value="15" <cfif modo NEQ "ALTA" and minut_D EQ '15'> selected</cfif>>15</option>
			<option value="20" <cfif modo NEQ "ALTA" and minut_D EQ '20'> selected</cfif>>20</option>
			<option value="25" <cfif modo NEQ "ALTA" and minut_D EQ '25'> selected</cfif>>25</option>
			<option value="30" <cfif modo NEQ "ALTA" and minut_D EQ '30'> selected</cfif>>30</option>
			<option value="35" <cfif modo NEQ "ALTA" and minut_D EQ '35'> selected</cfif>>35</option>
			<option value="40" <cfif modo NEQ "ALTA" and minut_D EQ '40'> selected</cfif>>40</option>
			<option value="45" <cfif modo NEQ "ALTA" and minut_D EQ '45'> selected</cfif>>45</option>
			<option value="50" <cfif modo NEQ "ALTA" and minut_D EQ '50'> selected</cfif>>50</option>
			<option value="55" <cfif modo NEQ "ALTA" and minut_D EQ '55'> selected</cfif>>55</option>
			<option value="60" <cfif modo NEQ "ALTA" and minut_D EQ '60'> selected</cfif>>60</option>
		  </select>
  hora/min</td>
	  </tr>
	  <tr valign="baseline">
		<td nowrap align="right"><strong>Inicio Comida  :</strong></td>
		<td>
		  <cfif modo NEQ "ALTA">
			<cfset hora_D = LSTimeFormat(rsDatos.hora_desde, 'HH')>
			<cfset minut_D = LSTimeFormat(rsDatos.hora_desde, 'mm')>
			<cfset hora_H = LSTimeFormat(rsDatos.hora_hasta, 'HH')>
			<cfset minut_H = LSTimeFormat(rsDatos.hora_hasta, 'mm')>
		  </cfif>
		  <select name="hora_inicomida" id="hora_inicomida">
			<option value="0" <cfif modo NEQ "ALTA" and hora_D EQ '00'> selected</cfif>>00</option>
			<option value="1" <cfif modo NEQ "ALTA" and hora_D EQ '01'> selected</cfif>>01</option>
			<option value="2" <cfif modo NEQ "ALTA" and hora_D EQ '02'> selected</cfif>>02</option>
			<option value="3" <cfif modo NEQ "ALTA" and hora_D EQ '03'> selected</cfif>>03</option>
			<option value="4" <cfif modo NEQ "ALTA" and hora_D EQ '04'> selected</cfif>>04</option>
			<option value="5" <cfif modo NEQ "ALTA" and hora_D EQ '05'> selected</cfif>>05</option>
			<option value="6" <cfif modo NEQ "ALTA" and hora_D EQ '06'> selected</cfif>>06</option>
			<option value="7" <cfif modo NEQ "ALTA" and hora_D EQ '07'> selected</cfif>>07</option>
			<option value="8" <cfif modo NEQ "ALTA" and hora_D EQ '08'> selected</cfif>>08</option>
			<option value="9" <cfif modo NEQ "ALTA" and hora_D EQ '09'> selected</cfif>>09</option>
			<option value="10" <cfif modo NEQ "ALTA" and hora_D EQ '10'> selected</cfif>>10</option>
			<option value="11" <cfif modo NEQ "ALTA" and hora_D EQ '11'> selected</cfif>>11</option>
			<option value="12" <cfif modo NEQ "ALTA" and hora_D EQ '12'> selected</cfif>>12</option>
			<option value="13" <cfif modo NEQ "ALTA" and hora_D EQ '13'> selected</cfif>>13</option>
			<option value="14" <cfif modo NEQ "ALTA" and hora_D EQ '14'> selected</cfif>>14</option>
			<option value="15" <cfif modo NEQ "ALTA" and hora_D EQ '15'> selected</cfif>>15</option>
			<option value="16" <cfif modo NEQ "ALTA" and hora_D EQ '16'> selected</cfif>>16</option>
			<option value="17" <cfif modo NEQ "ALTA" and hora_D EQ '17'> selected</cfif>>17</option>
			<option value="18" <cfif modo NEQ "ALTA" and hora_D EQ '18'> selected</cfif>>18</option>
			<option value="19" <cfif modo NEQ "ALTA" and hora_D EQ '19'> selected</cfif>>19</option>
			<option value="20" <cfif modo NEQ "ALTA" and hora_D EQ '20'> selected</cfif>>20</option>
			<option value="21" <cfif modo NEQ "ALTA" and hora_D EQ '21'> selected</cfif>>21</option>
			<option value="22" <cfif modo NEQ "ALTA" and hora_D EQ '22'> selected</cfif>>22</option>
			<option value="23" <cfif modo NEQ "ALTA" and hora_D EQ '23'> selected</cfif>>23</option>
			<option value="24" <cfif modo NEQ "ALTA" and hora_D EQ '24'> selected</cfif>>24</option>
		  </select>
		  <select name="min_inicomida" id="min_inicomida">
			<option value="0" <cfif modo NEQ "ALTA" and minut_D EQ '00'> selected</cfif>>00</option>
			<option value="5" <cfif modo NEQ "ALTA" and minut_D EQ '05'> selected</cfif>>05</option>
			<option value="10" <cfif modo NEQ "ALTA" and minut_D EQ '10'> selected</cfif>>10</option>
			<option value="15" <cfif modo NEQ "ALTA" and minut_D EQ '15'> selected</cfif>>15</option>
			<option value="20" <cfif modo NEQ "ALTA" and minut_D EQ '20'> selected</cfif>>20</option>
			<option value="25" <cfif modo NEQ "ALTA" and minut_D EQ '25'> selected</cfif>>25</option>
			<option value="30" <cfif modo NEQ "ALTA" and minut_D EQ '30'> selected</cfif>>30</option>
			<option value="35" <cfif modo NEQ "ALTA" and minut_D EQ '35'> selected</cfif>>35</option>
			<option value="40" <cfif modo NEQ "ALTA" and minut_D EQ '40'> selected</cfif>>40</option>
			<option value="45" <cfif modo NEQ "ALTA" and minut_D EQ '45'> selected</cfif>>45</option>
			<option value="50" <cfif modo NEQ "ALTA" and minut_D EQ '50'> selected</cfif>>50</option>
			<option value="55" <cfif modo NEQ "ALTA" and minut_D EQ '55'> selected</cfif>>55</option>
			<option value="60" <cfif modo NEQ "ALTA" and minut_D EQ '60'> selected</cfif>>60</option>
		  </select>
  hora/min</td>
	  </tr>
	  <tr valign="baseline">
		<td nowrap align="right"><strong>Fin Comida </strong></td>
		<td>
		  <select name="hora_fincomida" id="hora_fincomida">
			<option value="0" <cfif modo NEQ "ALTA" and hora_H EQ '00'> selected</cfif>>00</option>
			<option value="1" <cfif modo NEQ "ALTA" and hora_H EQ '01'> selected</cfif>>01</option>
			<option value="2" <cfif modo NEQ "ALTA" and hora_H EQ '02'> selected</cfif>>02</option>
			<option value="3" <cfif modo NEQ "ALTA" and hora_H EQ '03'> selected</cfif>>03</option>
			<option value="4" <cfif modo NEQ "ALTA" and hora_H EQ '04'> selected</cfif>>04</option>
			<option value="5" <cfif modo NEQ "ALTA" and hora_H EQ '05'> selected</cfif>>05</option>
			<option value="6" <cfif modo NEQ "ALTA" and hora_H EQ '06'> selected</cfif>>06</option>
			<option value="7" <cfif modo NEQ "ALTA" and hora_H EQ '07'> selected</cfif>>07</option>
			<option value="8" <cfif modo NEQ "ALTA" and hora_H EQ '08'> selected</cfif>>08</option>
			<option value="9" <cfif modo NEQ "ALTA" and hora_H EQ '09'> selected</cfif>>09</option>
			<option value="10" <cfif modo NEQ "ALTA" and hora_H EQ '10'> selected</cfif>>10</option>
			<option value="11" <cfif modo NEQ "ALTA" and hora_H EQ '11'> selected</cfif>>11</option>
			<option value="12" <cfif modo NEQ "ALTA" and hora_H EQ '12'> selected</cfif>>12</option>
			<option value="13" <cfif modo NEQ "ALTA" and hora_H EQ '13'> selected</cfif>>13</option>
			<option value="14" <cfif modo NEQ "ALTA" and hora_H EQ '14'> selected</cfif>>14</option>
			<option value="15" <cfif modo NEQ "ALTA" and hora_H EQ '15'> selected</cfif>>15</option>
			<option value="16" <cfif modo NEQ "ALTA" and hora_H EQ '16'> selected</cfif>>16</option>
			<option value="17" <cfif modo NEQ "ALTA" and hora_H EQ '17'> selected</cfif>>17</option>
			<option value="18" <cfif modo NEQ "ALTA" and hora_H EQ '18'> selected</cfif>>18</option>
			<option value="19" <cfif modo NEQ "ALTA" and hora_H EQ '19'> selected</cfif>>19</option>
			<option value="20" <cfif modo NEQ "ALTA" and hora_H EQ '20'> selected</cfif>>20</option>
			<option value="21" <cfif modo NEQ "ALTA" and hora_H EQ '21'> selected</cfif>>21</option>
			<option value="22" <cfif modo NEQ "ALTA" and hora_H EQ '22'> selected</cfif>>22</option>
			<option value="23" <cfif modo NEQ "ALTA" and hora_H EQ '23'> selected</cfif>>23</option>
			<option value="24" <cfif modo NEQ "ALTA" and hora_H EQ '24'> selected</cfif>>24</option>
		  </select>
		  <select name="min_fincomida" id="min_fincomida">
			<option value="0" <cfif modo NEQ "ALTA" and minut_H EQ '00'> selected</cfif>>00</option>
			<option value="5" <cfif modo NEQ "ALTA" and minut_H EQ '05'> selected</cfif>>05</option>
			<option value="10" <cfif modo NEQ "ALTA" and minut_H EQ '10'> selected</cfif>>10</option>
			<option value="15" <cfif modo NEQ "ALTA" and minut_H EQ '15'> selected</cfif>>15</option>
			<option value="20" <cfif modo NEQ "ALTA" and minut_H EQ '20'> selected</cfif>>20</option>
			<option value="25" <cfif modo NEQ "ALTA" and minut_H EQ '25'> selected</cfif>>25</option>
			<option value="30" <cfif modo NEQ "ALTA" and minut_H EQ '30'> selected</cfif>>30</option>
			<option value="35" <cfif modo NEQ "ALTA" and minut_H EQ '35'> selected</cfif>>35</option>
			<option value="40" <cfif modo NEQ "ALTA" and minut_H EQ '40'> selected</cfif>>40</option>
			<option value="45" <cfif modo NEQ "ALTA" and minut_H EQ '45'> selected</cfif>>45</option>
			<option value="50" <cfif modo NEQ "ALTA" and minut_H EQ '50'> selected</cfif>>50</option>
			<option value="55" <cfif modo NEQ "ALTA" and minut_H EQ '55'> selected</cfif>>55</option>
			<option value="60" <cfif modo NEQ "ALTA" and minut_H EQ '60'> selected</cfif>>60</option>
		  </select>
  hora/min </td>
	  </tr>
	  <tr valign="baseline">
		<td nowrap align="right"><strong>Hora hasta :</strong></td>
		<td>
		  <select name="hora_hasta" id="hora_hasta">
			<option value="0" <cfif modo NEQ "ALTA" and hora_H EQ '00'> selected</cfif>>00</option>
			<option value="1" <cfif modo NEQ "ALTA" and hora_H EQ '01'> selected</cfif>>01</option>
			<option value="2" <cfif modo NEQ "ALTA" and hora_H EQ '02'> selected</cfif>>02</option>
			<option value="3" <cfif modo NEQ "ALTA" and hora_H EQ '03'> selected</cfif>>03</option>
			<option value="4" <cfif modo NEQ "ALTA" and hora_H EQ '04'> selected</cfif>>04</option>
			<option value="5" <cfif modo NEQ "ALTA" and hora_H EQ '05'> selected</cfif>>05</option>
			<option value="6" <cfif modo NEQ "ALTA" and hora_H EQ '06'> selected</cfif>>06</option>
			<option value="7" <cfif modo NEQ "ALTA" and hora_H EQ '07'> selected</cfif>>07</option>
			<option value="8" <cfif modo NEQ "ALTA" and hora_H EQ '08'> selected</cfif>>08</option>
			<option value="9" <cfif modo NEQ "ALTA" and hora_H EQ '09'> selected</cfif>>09</option>
			<option value="10" <cfif modo NEQ "ALTA" and hora_H EQ '10'> selected</cfif>>10</option>
			<option value="11" <cfif modo NEQ "ALTA" and hora_H EQ '11'> selected</cfif>>11</option>
			<option value="12" <cfif modo NEQ "ALTA" and hora_H EQ '12'> selected</cfif>>12</option>
			<option value="13" <cfif modo NEQ "ALTA" and hora_H EQ '13'> selected</cfif>>13</option>
			<option value="14" <cfif modo NEQ "ALTA" and hora_H EQ '14'> selected</cfif>>14</option>
			<option value="15" <cfif modo NEQ "ALTA" and hora_H EQ '15'> selected</cfif>>15</option>
			<option value="16" <cfif modo NEQ "ALTA" and hora_H EQ '16'> selected</cfif>>16</option>
			<option value="17" <cfif modo NEQ "ALTA" and hora_H EQ '17'> selected</cfif>>17</option>
			<option value="18" <cfif modo NEQ "ALTA" and hora_H EQ '18'> selected</cfif>>18</option>
			<option value="19" <cfif modo NEQ "ALTA" and hora_H EQ '19'> selected</cfif>>19</option>
			<option value="20" <cfif modo NEQ "ALTA" and hora_H EQ '20'> selected</cfif>>20</option>
			<option value="21" <cfif modo NEQ "ALTA" and hora_H EQ '21'> selected</cfif>>21</option>
			<option value="22" <cfif modo NEQ "ALTA" and hora_H EQ '22'> selected</cfif>>22</option>
			<option value="23" <cfif modo NEQ "ALTA" and hora_H EQ '23'> selected</cfif>>23</option>
			<option value="24" <cfif modo NEQ "ALTA" and hora_H EQ '24'> selected</cfif>>24</option>
		  </select>
		  <select name="min_hasta" id="min_hasta">
			<option value="0" <cfif modo NEQ "ALTA" and minut_H EQ '00'> selected</cfif>>00</option>
			<option value="5" <cfif modo NEQ "ALTA" and minut_H EQ '05'> selected</cfif>>05</option>
			<option value="10" <cfif modo NEQ "ALTA" and minut_H EQ '10'> selected</cfif>>10</option>
			<option value="15" <cfif modo NEQ "ALTA" and minut_H EQ '15'> selected</cfif>>15</option>
			<option value="20" <cfif modo NEQ "ALTA" and minut_H EQ '20'> selected</cfif>>20</option>
			<option value="25" <cfif modo NEQ "ALTA" and minut_H EQ '25'> selected</cfif>>25</option>
			<option value="30" <cfif modo NEQ "ALTA" and minut_H EQ '30'> selected</cfif>>30</option>
			<option value="35" <cfif modo NEQ "ALTA" and minut_H EQ '35'> selected</cfif>>35</option>
			<option value="40" <cfif modo NEQ "ALTA" and minut_H EQ '40'> selected</cfif>>40</option>
			<option value="45" <cfif modo NEQ "ALTA" and minut_H EQ '45'> selected</cfif>>45</option>
			<option value="50" <cfif modo NEQ "ALTA" and minut_H EQ '50'> selected</cfif>>50</option>
			<option value="55" <cfif modo NEQ "ALTA" and minut_H EQ '55'> selected</cfif>>55</option>
			<option value="60" <cfif modo NEQ "ALTA" and minut_H EQ '60'> selected</cfif>>60</option>
		  </select>
  hora/min </td>
	  </tr>	  
	  <tr>
		<td align="right"><strong>Periodicidad:</strong></td>
		<td><input type="text" name="periodicidad" value="<cfif modo NEQ 'ALTA'>#rsDatos.periodicidad#<cfelse>60</cfif>" tabindex="1" size="6" maxlength="4" style="text-align: right;" onBlur="javascript:fm(this,-1);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" > 
	    min </td>
	  </tr>
	  <tr>
		<td align="right"><strong>Cupo est&aacute;ndar: </strong></td>
		<td><input type="text" name="cupo" value="<cfif modo NEQ 'ALTA'>#rsDatos.cupo#<cfelse>0</cfif>" tabindex="1" size="6" maxlength="4" style="text-align: right;" onBlur="javascript:fm(this,-1);"  onFocus="javascript:this.value=qf(this); this.select();"  onKeyUp="javascript:if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" ></td>
	  </tr>	
	  <tr valign="baseline">
		<td colspan="2" align="right" valign="top" nowrap>
		  <table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
			  <td colspan="3"><strong>D&iacute;a :</strong></td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
			  <td>&nbsp;</td>
		    </tr>
			<tr align="center">
			  <td>Domingo</td>
			  <td>Lunes</td>
			  <td>Martes</td>
			  <td>Mi&eacute;rcoles</td>
			  <td>Jueves</td>
			  <td>Viernes</td>
			  <td>S&aacute;bado</td>
			</tr>
			
			<cfif modo NEQ 'ALTA'>
				<cfset arrayDias = ListToArray(rsDatos.dia_semanal,',')>
			</cfif>
			
			<tr align="center">
			  <td><input type="checkbox" name="dia_1" value="1" <cfif modo NEQ 'ALTA' and isdefined('arrayDias') and arrayDias[1] EQ 1> checked</cfif>></td>
			  <td><input type="checkbox" name="dia_2" value="1" <cfif modo NEQ 'ALTA' and isdefined('arrayDias') and arrayDias[2] EQ 1> checked</cfif>></td>
			  <td><input type="checkbox" name="dia_3" value="1" <cfif modo NEQ 'ALTA' and isdefined('arrayDias') and arrayDias[3] EQ 1> checked</cfif>></td>
			  <td><input type="checkbox" name="dia_4" value="1" <cfif modo NEQ 'ALTA' and isdefined('arrayDias') and arrayDias[4] EQ 1> checked</cfif>></td>
			  <td><input type="checkbox" name="dia_5" value="1" <cfif modo NEQ 'ALTA' and isdefined('arrayDias') and arrayDias[5] EQ 1> checked</cfif>></td>
			  <td><input type="checkbox" name="dia_6" value="1" <cfif modo NEQ 'ALTA' and isdefined('arrayDias') and arrayDias[6] EQ 1> checked</cfif>></td>
			  <td><input type="checkbox" name="dia_7" value="1" <cfif modo NEQ 'ALTA' and isdefined('arrayDias') and arrayDias[7] EQ 1> checked</cfif>></td>
			</tr>
		  </table></td>
	  </tr>	
	      
	  <tr>
		<td align="right">&nbsp;</td>
		<td>&nbsp;</td>
	  </tr>
	  <tr>
		<td colspan="2" align="center">
			<cfif isdefined('modo') and modo NEQ 'ALTA'>
				<cf_botones modo="#modo#"> 		
			<cfelse>
				<cf_botones modo="#modo#" include="Generar" includevalues="Generar" exclude="ALTA"> 		
			</cfif>	 		
		</td>
	  </tr>
  

	  <cfset ts = "">
	  <cfif modo NEQ "ALTA">
		<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp="#rsDatos.ts_rversion#" returnvariable="ts"> </cfinvoke>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
		<input type="hidden" name="id_agenda" value="#form.id_agenda#">
	  </cfif>
  </table>
</cfoutput>
<SCRIPT LANGUAGE="JavaScript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formAgendaServ");
	
	function _isHoras(horaInicio,minInicio,minFinal,opc){
		var horaIni=horaInicio;
		var minIni=minInicio;	
		var horaFin=this.value;
		var minFin = minFinal;
			
		switch(opc){
			case 1:{
						if ((parseInt(horaIni) > parseInt(horaFin)) || ((parseInt(horaIni) == parseInt(horaFin)) && 
								(parseInt(minIni) > parseInt(minFin)))){
							this.error="Error, la Hora Desde no debe ser mayor que la Hora Hasta. ";					
						}			
					
			break;}
			case 2:{
						if(parseInt(horaFin) > 0){
							if ((parseInt(horaIni) > parseInt(horaFin)) || ((parseInt(horaIni) == parseInt(horaFin)) && 
									(parseInt(minIni) > parseInt(minFin)))){
								this.error="Error, la Hora Desde no debe ser mayor que la hora de inicio de la comida. ";					
							}			
						}
					
			break;			}	
			case 3:{
						if(parseInt(horaIni) > 0){
							if ((parseInt(horaIni) > parseInt(horaFin)) || ((parseInt(horaIni) == parseInt(horaFin)) && 
									(parseInt(minIni) > parseInt(minFin)))){
								this.error="Error, la hora de inicio de la comida no debe ser mayor que la hora final de la comida. ";
							}			
						}			
					
			break;			}	
			case 4:{
						if(parseInt(horaIni) > 0){
							if ((parseInt(horaIni) > parseInt(horaFin)) || ((parseInt(horaIni) == parseInt(horaFin)) && 
									(parseInt(minIni) > parseInt(minFin)))){
								this.error="Error, la hora final de la comida no debe ser mayor que la Hora Hasta. ";
							}			
						}			
					
			break;		}		
		}			
	}		
	function _isValPeriodicidad(){
		if (parseInt(this.value) > 60)
			this.error="Error, la periodicidad no puede ser mayor a 60 minutos.";
			
		if (parseInt(this.value) < 0)
			this.error="Error, la periodicidad no puede ser negativa.";
	}			
	function _isHora2Ok(){
		var _horadesde = parseInt(objForm.hora_desde.getValue());
		var _horainicomida = parseInt(objForm.hora_inicomida.getValue());
		var _horafincomida = parseInt(objForm.hora_fincomida.getValue());
		var _horahasta = parseInt(objForm.hora_hasta.getValue());
		
		var _mindesde = parseInt(objForm.min_desde.getValue());
		var _mininicomida = parseInt(objForm.min_inicomida.getValue());
		var _minfincomida = parseInt(objForm.min_fincomida.getValue());
		var _minhasta = parseInt(objForm.min_hasta.getValue());
		
		if (_horainicomida!=0||_mininicomida!=0){
			if (_horainicomida<_horadesde||(_horainicomida==_horadesde&&_mininicomida<_mindesde)){
				this.error="La Hora de Inicio de Comida es Incorrecta!";
			}
		}
	}
	function _isHora3Ok(){
		var _horadesde = parseInt(objForm.hora_desde.getValue());
		var _horainicomida = parseInt(objForm.hora_inicomida.getValue());
		var _horafincomida = parseInt(objForm.hora_fincomida.getValue());
		var _horahasta = parseInt(objForm.hora_hasta.getValue());
		
		var _mindesde = parseInt(objForm.min_desde.getValue());
		var _mininicomida = parseInt(objForm.min_inicomida.getValue());
		var _minfincomida = parseInt(objForm.min_fincomida.getValue());
		var _minhasta = parseInt(objForm.min_hasta.getValue());
		
		if (_horafincomida<_horainicomida||(_horafincomida==_horainicomida&&_minfincomida<_mininicomida)){
			this.error="La Hora de Fin de Comida es Incorrecta!";
		}
	}
	function _isHora4Ok(){
		var _horadesde = parseInt(objForm.hora_desde.getValue());
		var _horainicomida = parseInt(objForm.hora_inicomida.getValue());
		var _horafincomida = parseInt(objForm.hora_fincomida.getValue());
		var _horahasta = parseInt(objForm.hora_hasta.getValue());
		
		var _mindesde = parseInt(objForm.min_desde.getValue());
		var _mininicomida = parseInt(objForm.min_inicomida.getValue());
		var _minfincomida = parseInt(objForm.min_fincomida.getValue());
		var _minhasta = parseInt(objForm.min_hasta.getValue());
		
		//val1
		if(_horainicomida!=0||_mininicomida!=0){
			if (_horahasta<_horafincomida||(_horahasta==_horafincomida&&_minhasta<_minfincomida)){
				this.error="La Hora Final es Incorrecta!";
			}
		} else {
			if (_horahasta<_horadesde||(_horahasta==_horadesde&&_minhasta<_mindesde)){
				this.error="La Hora Final es Incorrecta!";
			}
		}
	}
	_addValidator("isHora2Ok", _isHora2Ok);
	_addValidator("isHora3Ok", _isHora3Ok);
	_addValidator("isHora4Ok", _isHora4Ok);
	
	_addValidator("isHoras", _isHoras);
	_addValidator("isValPeriodicidad", _isValPeriodicidad);

	objForm.hora_desde.required = true;
	objForm.hora_desde.description="Hora Desde";		
	objForm.hora_inicomida.required = true;
	objForm.hora_inicomida.description="Hora inicio de comida";	
	objForm.periodicidad.required = true;
	objForm.periodicidad.description="Periodicidad";	

	objForm.hora_inicomida.validateHora2Ok();
	objForm.hora_fincomida.validateHora3Ok();
	objForm.hora_hasta.validateHora4Ok();

	function funcNuevo_Ag(){
		deshabilitarValidacion();
	}
	function funcBaja_Ag(){
		deshabilitarValidacion();
		if( confirm('¿Desea Eliminar el Registro?') )
			return true;
		
		return false;
	}		
	function deshabilitarValidacion(){
		objForm.hora_desde.required = false;
		objForm.hora_inicomida.required = false;
		objForm.periodicidad.required = false;
	}	
	function funcbtnLista_Ag(){
		deshabilitarValidacion();
	}
	function funcGenerar(){
		if (algunoMarcado()){
			document.formAgendaServ.ID_INST.value = "<cfoutput>#form.id_inst#</cfoutput>";
			<cfif isdefined('form.id_tiposerv') and form.id_tiposerv NEQ ''>
				document.formAgendaServ.ID_TIPOSERV.value = "<cfoutput>#form.id_tiposerv#</cfoutput>";
			<cfelseif isdefined('form.id_sucursal') and form.id_sucursal NEQ ''>
				document.formAgendaServ.ID_SUCURSAL.value = "<cfoutput>#form.id_sucursal#</cfoutput>";
			</cfif>
			objForm.periodicidad.validateValPeriodicidad();				
		}else{
			return false;
		}
	}		
</SCRIPT>

