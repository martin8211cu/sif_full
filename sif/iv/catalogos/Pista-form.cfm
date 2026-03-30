<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript" type="text/JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>

<cfset modo='ALTA'>
<cfif isdefined("form.Pista_id") and len(trim(form.Pista_id))>
	<cfset modo = 'CAMBIO'> 
</cfif>

<cfif modo NEQ 'ALTA'>
	<cfquery name = "rsdata" datasource="#session.DSN#">
		select Pista_id, Ecodigo, Ocodigo, Codigo_pista, Descripcion_pista, Pestado, BMUsucodigo, ts_rversion
		from   Pistas
		where  Pista_id = <cfqueryparam cfsqltype="cf_sql_numeric" value= "#form.Pista_id#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value= "#session.Ecodigo#">
	</cfquery>
	
	<cfquery name="rsExisteArtxpista" datasource="#session.DSN#">	
		select count(1) as Existe
		from Pistas p 
		  inner join Artxpista ap
		  on p.Ecodigo = ap.Ecodigo
			and p.Pista_id = ap.Pista_id
		where ap.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value= "#session.Ecodigo#">
			and p.Pista_id=<cfqueryparam cfsqltype="cf_sql_numeric" value= "#form.Pista_id#">	
	</cfquery>		
</cfif>

<!--- registros existentes --->
<cfquery name="rsCodigosPistas" datasource="#session.DSN#">
	select  upper(Codigo_pista) as Codigo_pista
		from Pistas
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<table width="100%" cellpadding="2" cellspacing="0">
	<tr> 
    	<td colspan="2"><cfinclude template="../../portlets/pNavegacionIV.cfm"></td>
    </tr>
	<tr>
		<td valign="top" width="50%">
			<cfquery name="rsEstados" datasource="#session.DSN#">
					select -1 as value, '--Todos--' as description, 1 as orden
					from dual
				union 
					select 1 as value, 'Activa' as description, 2 as orden
					from dual
				union 
					select 0 as value, 'Inactiva' as description, 3 as orden
					from dual
				order by orden		
			</cfquery>
			
			<cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaRH"
				returnvariable="pListaRet">
				<cfinvokeargument name="tabla" value="Pistas"/>
				<cfinvokeargument name="columnas" value="Pista_id
										, Ecodigo
										, Ocodigo
										, Codigo_pista 
										, Descripcion_pista
										, case  
											when Pestado = 1 then 'Activo' 
										 	when Pestado = 0 then 'Inactivo' end as Pestado
			    						, BMUsucodigo"/> 
				<cfinvokeargument name="desplegar" value="Codigo_pista, Descripcion_pista, Pestado"/> 				
				<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n, Estado"/> 
				<cfinvokeargument name="filtrar_por_array" value="#ListToArray('Codigo_pista|Descripcion_pista|Pestado','|')#"/> 				
				<cfinvokeargument name="formatos" value="S,S,I"/> 
				<cfinvokeargument name="filtro" value="Ecodigo = #Session.Ecodigo#
														order by Descripcion_pista"/> 
				<cfinvokeargument name="rsPestado" value="#rsEstados#"/> 														
				<cfinvokeargument name="align" value="left,left,left"/> 
				<cfinvokeargument name="ajustar" value="N"/> 
				<cfinvokeargument name="checkboxes" value="N"/> 
				<cfinvokeargument name="irA" value="Pista.cfm"/> 
				<cfinvokeargument name="showEmptyListMsg" value="true"/>
				<cfinvokeargument name="keys" value="Pista_id"/> 
				<cfinvokeargument name="debug" value="N"/>
				<cfinvokeargument name="maxRows" value="#form.MaxRows#"/>	
				<cfinvokeargument name="mostrar_filtro" value="true"/>
				<cfinvokeargument name="filtrar_automatico" value="true"/>																													
			</cfinvoke>			
		</td>
		<td valign="top">
			<cfoutput>		
			<form name="form1" method="post" action="Pista-SQL.cfm" onSubmit="javascript: return valida();">
				<input name="Pagina" type="hidden" tabindex="-1" value="#form.Pagina#">	
				<input name="MaxRows" type="hidden" tabindex="-1" value="#form.MaxRows#">		
				<input type="hidden" name="filtro_Codigo_pista" value="<cfif isdefined('form.filtro_Codigo_pista') and form.filtro_Codigo_pista NEQ ''>#form.filtro_Codigo_pista#</cfif>">
				<input type="hidden" name="filtro_Descripcion_pista" value="<cfif isdefined('form.filtro_Descripcion_pista') and form.filtro_Descripcion_pista NEQ ''>#form.filtro_Descripcion_pista#</cfif>">		
				<input type="hidden" name="filtro_Pestado" value="<cfif isdefined('form.filtro_Pestado') and form.filtro_Pestado NEQ ''>#form.filtro_Pestado#</cfif>">						
										
				<table width="100%" border="0">
					<tr>
						<td width="41%" align="right"><strong>C&oacute;digo Pista:</strong></td>
						<td width="59%">
						  	<input name="Codigo_pista" type="text" tabindex="1" size="8" maxlength="5" value="<cfif modo neq 'ALTA'>#rsData.Codigo_pista#</cfif>">
							<input type="hidden" name="ExisteArtxpista" id="ExisteArtxpista" value="<cfif isdefined("rsExisteArtxpista") and rsExisteArtxpista.RecordCount NEQ 0>#rsExisteArtxpista.Existe#<cfelse>0</cfif>">
						<cfif modo NEQ 'ALTA'>
							<input type = "hidden" name="Pista_id" value="#rsdata.Pista_id#">
						</cfif>	
						</td>
					</tr>
					</cfoutput>
					<tr>
						<td nowrap align="right"><strong>Estación:</strong></td>
						<td nowrap>							
							<cfif modo NEQ 'ALTA'>
								<cf_sifoficinas tabindex="1" form="form1" id="#rsdata.Ocodigo#">
							<cfelse>
								<cf_sifoficinas tabindex="1" form="form1" Ocodigo="Ocodigo">
							</cfif>							
						</td>
					</tr>
					<cfoutput>
					<tr>
                      <td align="right"><strong>Descripci&oacute;n:</strong></td>
                      <td>
						  <input name="Descripcion_pista" tabindex="1" onFocus="this.select();" type="text" size="40" maxlength="80" value="<cfif modo neq 'ALTA'>#rsData.Descripcion_pista#</cfif>">
                      </td>
				  	</tr>
					<tr>
						<td nowrap align="right"><strong>Estado:</strong>
						</td>
						<td>
							<select name="Pestado" tabindex="1" >
							  <option value="1" <cfif modo NEQ 'ALTA' and isdefined("rsdata") and rsdata.Pestado eq '1'>selected</cfif> >Activa</option>
							  <option value="0" <cfif modo NEQ 'ALTA' and isdefined("rsdata") and rsdata.Pestado eq '0'>selected</cfif> >Inactiva</option>
							</select>
						</td>
					</tr>
					<tr><td colspan="2">&nbsp;</td></tr>
					<tr>
						<td colspan="2" align="center">
							<cf_Botones modo="#modo#" tabindex="1">

							<cfif modo NEQ "ALTA">
								<cfset ts = "">
								<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" artimestamp= "#rsdata.ts_rversion#" returnvariable="ts">
								</cfinvoke>
								<input type="hidden" name = "ts_rversion" value ="#ts#">
							</cfif>
						</td>	
					</tr>
				</table>
				</cfoutput>
			</form>			
		</td>
	</tr>
</table>

<script language="JavaScript1.2" type="text/javascript">
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	function deshabilitarValidacion(){
		objForm.Codigo_pista.required = false;
		objForm.Descripcion_pista.required = false;
		objForm.Ocodigo.required = false;
	}
	
	function valida(){				
		if (btnSelected("Alta",document.form1)) {	
			if (existeFormatoCuenta(document.form1.Codigo_pista.value)) {
				alert('Codigo de Pista ya existe'); 
				
				return false;
			}
			
		}
		if (btnSelected("Baja",document.form1)) {	
			if (existeArtxpista(document.form1.ExisteArtxpista.value)) {
				alert('Existen dependencias en Artículos por Pista, por favor verifique.'); 
				
				return false;
			}
			
		}
		document.form1.Codigo_pista.disabled = false;
		document.form1.Descripcion_pista.disabled = false;
		return true;		
	}

	function existeFormatoCuenta(dato) {
		var Existe_formato = false;
		<cfloop query="rsCodigosPistas">
			if (dato == "<cfoutput>#rsCodigosPistas.Codigo_pista#</cfoutput>") 
				Existe_formato = true;		
		</cfloop>
		return Existe_formato;
	}
	<cfif modo NEQ 'ALTA'>
		function existeArtxpista() {
			var Existe_Art = false;
			if(document.form1.ExisteArtxpista.value > 0)
				Existe_Art = true;	
			return Existe_Art;
		}		
	</cfif>
	
	objForm.Codigo_pista.required = true;
	objForm.Codigo_pista.description="Código de la Pista";

	objForm.Descripcion_pista.required = true;
	objForm.Descripcion_pista.description="Descripcion";
	
	objForm.Ocodigo.required = true;
	objForm.Ocodigo.description="Código Oficina";
	
	document.form1.Codigo_pista.focus();
</script>

	