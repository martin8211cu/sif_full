<cfif isdefined("url.RHEJid")and len(trim(url.RHEJid))NEQ 0>
	 <cfset form.RHEJid = url.RHEJid>
</cfif>

<!--- Definir el modo --->
 <cfif isdefined("form.RHEJid") and len(trim(form.RHEJid))>
	<cfset modo='CAMBIO'>
<cfelse>
	<cfset modo='ALTA'>
</cfif> 

<cfif modo EQ 'CAMBIO'>
	<cfquery name="rsExcepciones" datasource="#session.DSN#">
		select * from RHExcepcionesJornada 
		where RHEJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEJid#">
 	</cfquery>
	<cfquery name="rsHora" datasource="#session.DSN#">
		select case when datepart(hh, a.RHEJhorainicio) > 12 then datepart(hh, a.RHEJhorainicio) - 12 when datepart(hh, a.RHEJhorainicio) = 0 then 12 else datepart(hh, a.RHEJhorainicio) end as hinicio,
			   datepart(mi, a.RHEJhorainicio) as minicio,
			   case when datepart(hh, a.RHEJhorainicio) < 12 then 'AM' else 'PM' end as tinicio,
			   case when datepart(hh, a.RHEJhorafinal) > 12 then datepart(hh, a.RHEJhorafinal) - 12 when datepart(hh, a.RHEJhorafinal) = 0 then 12 else datepart(hh, a.RHEJhorafinal) end as hfinal,
			   datepart(mi, a.RHEJhorafinal) as mfinal,
			   case when datepart(hh, a.RHEJhorafinal) < 12 then 'AM' else 'PM' end as tfinal
		from RHExcepcionesJornada a
		where RHEJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHEJid#">
 	</cfquery>
	
</cfif>

<cfquery name="rsJornadas" datasource="#Session.DSN#">
	select 	RHJid, {fn concat(rtrim(RHJcodigo),{fn concat(' - ',RHJdescripcion)})} as Descripcion
	from RHJornadas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsIncidencias" datasource="#Session.DSN#">
	select CIid, {fn concat(rtrim(CIcodigo),{fn concat(' - ',CIdescripcion)})} as Descripcion
	from CIncidentes
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	  and CIcarreracp = 0
</cfquery>

<!----====================== TRADUCCION ========================---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Jornada"
	default="Jornada"	
	returnvariable="LB_Jornada"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Incidencia"
	default="Incidencia"	
	returnvariable="LB_Incidencia"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Dia"
	default="Día"	
	returnvariable="LB_Dia"/>

<cfoutput>
<form name="form1" action="ExcepcionesJornada-sql.cfm" method="post" ><!--- <cfif modo EQ "ALTA">onSubmit="javascript: return validaDias(this);"</cfif> --->
	<cfif modo neq "ALTA">
		<input name="RHEJid" type="hidden" value="<cfoutput>#form.RHEJid#</cfoutput>">
	</cfif>
	<table width="100%">
		<tr>
			<td align="right"><strong>#LB_Jornada#:</strong></td>
			<td nowrap>
				<select name="RHJid">
					<option value=""></option>
				<cfloop query="rsJornadas">
					<option <cfif isdefined("rsExcepciones")and rsExcepciones.recordCount NEQ 0 and rsExcepciones.RHJid eq RHJid>selected</cfif>  value="<cfoutput>#RHJid#</cfoutput>"><cfoutput>#Descripcion#</cfoutput></option>
				</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td align="right"><strong>#LB_Incidencia#:</strong></td>
			<td nowrap>
				<select id="CIid" name="CIid" >
					<option value=""></option>
				<cfloop query="rsIncidencias">
					<option <cfif isdefined("rsExcepciones")and rsExcepciones.recordCount NEQ 0 and rsExcepciones.CIid eq CIid>selected</cfif>  value="<cfoutput>#CIid#</cfoutput>"><cfoutput>#Descripcion#</cfoutput></option>
				</cfloop>
				</select>
			</td>
		</tr>
		<tr>
			<td nowrap align="right"><strong><cf_translate key="LB_Hora_inicial">Hora inicial:</cf_translate></strong></td>
			<td>
				<select  id="RHEJhorainicio_h" name='RHEJhorainicio_h'>
				  <cfloop index="i" from="1" to="12">
					<option value="<cfoutput>#i#</cfoutput>"  <cfif modo EQ "CAMBIO" and rsHora.hinicio EQ i> selected</cfif>> <cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
				  </cfloop>
				</select> :
				<select id="RHEJhorainicio_m" name='RHEJhorainicio_m'>
				  <cfloop index="i" from="0" to="59">
					<option value="<cfoutput>#i#</cfoutput>" <cfif modo EQ "CAMBIO" and rsHora.minicio EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
				  </cfloop>
				</select>
				<select id="RHEJhorainicio_s"  name="RHEJhorainicio_s">
					<option value="AM" <cfif modo EQ "CAMBIO" and rsHora.tinicio EQ 'AM'> selected</cfif>>AM</option>
					<option value="PM" <cfif modo EQ "CAMBIO" and rsHora.tinicio EQ 'PM'> selected</cfif>>PM</option>
				</select>
			</td>
		</tr>
		
		<tr>
			<td nowrap align="right"><strong><cf_translate key="LB_Hora_final">Hora final:</cf_translate></strong></td>
			<td>
				<select  id="RHEJhorafinal_h" name='RHEJhorafinal_h'>
				  <cfloop index="i" from="1" to="12">
					<option value="<cfoutput>#i#</cfoutput>" <cfif modo EQ "CAMBIO" and rsHora.hfinal EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
				  </cfloop>
				</select> :
				<select id="RHEJhorafinal_m" name='RHEJhorafinal_m'>
				  <cfloop index="i" from="0" to="59">
					<option value="<cfoutput>#i#</cfoutput>" <cfif modo EQ "CAMBIO" and rsHora.mfinal EQ i> selected</cfif>><cfif Len(Trim(i)) EQ 1><cfoutput>0</cfoutput></cfif><cfoutput>#i#</cfoutput></option>
				  </cfloop>
				</select>
				<select id="RHEJhorafinal_s"  name="RHEJhorafinal_s">
					<option value="AM" <cfif modo EQ "CAMBIO" and rsHora.tfinal EQ 'AM'> selected</cfif> >AM</option>
					<option value="PM" <cfif modo EQ "CAMBIO" and rsHora.tfinal EQ 'PM'> selected</cfif>>PM</option>
				</select>
			</td>
		</tr>
		
		<tr valign="top">
			<td align="right"><strong>#LB_Dia#:</strong></td>
			<td>
				<input name="dia" id="dia" type="hidden" value="">
				<table border="0" width="100%" cellpadding="0" cellspacing="0" align="center">
				<tr>
					<td width="1%" nowrap>
						<cfif modo neq 'ALTA' and isdefined("rsExcepciones") and  rsExcepciones.RHEJlunes EQ 1>
							<input type="checkbox" id="RHEJlunes" name="RHEJlunes" value="1" checked>
						<cfelse>
							<input type="checkbox" id="RHEJlunes" name="RHEJlunes" value="0" onclick="">
						</cfif>
					</td>
					<td nowrap><cf_translate key="LB_Lunes">Lunes</cf_translate></td>
				</tr>	

				<tr>
					<td width="1%" nowrap>
						<cfif modo neq 'ALTA' and isdefined("rsExcepciones") and  rsExcepciones.RHEJmartes EQ 1>
							<input type="checkbox" id="RHEJmartes" name="RHEJmartes" value="1" checked>
						<cfelse>
							<input type="checkbox" id="RHEJmartes" name="RHEJmartes" value="0">
						</cfif>
					</td>
					<td nowrap><cf_translate key="LB_Martes">Martes</cf_translate></td>
				</tr>	

				<tr>
					<td width="1%" nowrap>
						<cfif modo neq 'ALTA' and isdefined("rsExcepciones") and  rsExcepciones.RHEJmiercoles EQ 1>
							<input type="checkbox" id="RHEJmiercoles" name="RHEJmiercoles" value="1" checked>
						<cfelse>
							<input type="checkbox" id="RHEJmiercoles" name="RHEJmiercoles" value="0">
						</cfif>
					</td>
					<td nowrap><cf_translate key="LB_Miercoles">Mi&eacute;rcoles</cf_translate></td>
				</tr>	

				<tr>
					<td width="1%" nowrap>
						<cfif modo neq 'ALTA' and isdefined("rsExcepciones") and  rsExcepciones.RHEJjueves EQ 1>
							<input type="checkbox" id="RHEJjueves" name="RHEJjueves" value="1" checked>
						<cfelse>
							<input type="checkbox" id="RHEJjueves" name="RHEJjueves" value="0">
						</cfif>
					</td>
					<td nowrap><cf_translate key="LB_Jueves">Jueves</cf_translate></td>
				</tr>

				<tr>
					<td width="1%" nowrap>
						<cfif modo neq 'ALTA' and isdefined("rsExcepciones") and  rsExcepciones.RHEJviernes EQ 1>
							<input type="checkbox" id="RHEJviernes" name="RHEJviernes" value="1" checked>
						<cfelse>
							<input type="checkbox" id="RHEJviernes" name="RHEJviernes" value="0">
						</cfif>
					</td>
					<td nowrap><cf_translate key="LB_Viernes">Viernes</cf_translate></td>
				</tr>	

				<tr>
					<td width="1%" nowrap>
						<cfif modo neq 'ALTA' and isdefined("rsExcepciones") and  rsExcepciones.RHEJsabado EQ 1>
							<input type="checkbox" id="RHEJsabado" name="RHEJsabado" value="1" checked>
						<cfelse>
							<input type="checkbox" id="RHEJsabado" name="RHEJsabado" value="0">
						</cfif>
					</td>
					<td nowrap><cf_translate key="LB_Sabado">S&aacute;bado</cf_translate></td>
				</tr>	

				<tr>
					<td width="1%" nowrap>
						<cfif modo neq 'ALTA' and isdefined("rsExcepciones") and  rsExcepciones.RHEJdomingo EQ 1>
							<input type="checkbox" id="RHEJdomingo" name="RHEJdomingo" value="1" checked>
						<cfelse>
							<input type="checkbox" id="RHEJdomingo" name="RHEJdomingo" value="0">
						</cfif>
					</td>
					<td nowrap><cf_translate key="LB_Domingo">Domingo</cf_translate></td>
				</tr>
			</table>
			</td>
		</tr>
		<tr>
			<td colspan="2" valign="top">
				<cfif modo neq 'ALTA'  >
					<cf_botones modo='CAMBIO'>
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>
	</table>
</form>
</cfoutput>
<cf_qforms>
<script language="javascript" type="text/javascript">
	
	function habilitarValidacion(){
		<cfoutput>
		objForm.RHJid.required = true;
		objForm.RHJid.description = "#LB_Jornada#";
		
		objForm.CIid.required = true;
		objForm.CIid.description = "#LB_Incidencia#";
		 if(validaDias()==false)
		{
			objForm.dia.required = true;
			objForm.dia.description = "#LB_Dia#";
		} 
		</cfoutput>
	}

	function deshabilitarValidacion(){
		objForm.RHJid.required = false;
		objForm.CIid.required = false;
		objForm.dia.required = false;
	}
habilitarValidacion();

function validaDias(){

	with(document.form1){
		if( (RHEJlunes.checked == false) && (RHEJmartes.checked == false) && (RHEJmiercoles.checked == false) && (RHEJjueves.checked== false) && (RHEJviernes.checked == false) && (RHEJsabado.checked == false) &&(RHEJdomingo.checked == false) ){
			dia.value='';
			return(false);
		}
		else{
			dia.value='Correcto'; 
			return(true);
		}
	}	
}
</script>




