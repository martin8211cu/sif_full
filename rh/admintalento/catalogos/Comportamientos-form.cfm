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

<cfif isdefined('url.RHCOid') and len(trim(url.RHCOid))>
	<cfset form.RHCOid = url.RHCOid>
	<cfset modo = "CAMBIO">
<cfelseif isdefined('form.RHCOid') and len(trim(form.RHCOid))>
	<cfset modo = "CAMBIO">
</cfif>

<cfset va_arrayHabilidad=ArrayNew(1)>
<cfset va_arrayGrupos=ArrayNew(1)>

<cfif modo neq 'ALTA' >
	<cfquery name="rs" datasource="#Session.DSN#">
		select 	a.RHCOid, a.RHCOcodigo, a.RHCOdescripcion, a.RHHid, 
				a.RHGNid, a.RHCOpeso, a.ts_rversion,
				b.RHHid, b.RHHcodigo, b.RHHdescripcion,
				c.RHGNid, c.RHGNcodigo, c.RHGNdescripcion
		from RHComportamiento a
			inner join RHHabilidades b
				on a.RHHid = b.RHHid		
			inner join RHGrupoNivel c
				on a.RHGNid = c.RHGNid 			
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and a.RHCOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.RHCOid#">
	</cfquery>	
	<!---Arreglo para conlis de habilidades---->
	<cfif isdefined("rs.RHHid")>
		<cfset ArrayAppend(va_arrayHabilidad, rs.RHHid)>
	</cfif>
	<cfif isdefined("rs.RHHcodigo")>
		<cfset ArrayAppend(va_arrayHabilidad, rs.RHHcodigo)>
	</cfif>
	<cfif isdefined("rs.RHHdescripcion")>
		<cfset ArrayAppend(va_arrayHabilidad, rs.RHHdescripcion)>
	</cfif>
	<!----Arreglo para el conlis de grupos de nivel----->
	<cfif isdefined("rs.RHGNid")>
		<cfset ArrayAppend(va_arrayGrupos, rs.RHGNid)>
	</cfif>
	<cfif isdefined("rs.RHGNcodigo")>
		<cfset ArrayAppend(va_arrayGrupos, rs.RHGNcodigo)>
	</cfif>
	<cfif isdefined("rs.RHGNdescripcion")>
		<cfset ArrayAppend(va_arrayGrupos, rs.RHGNdescripcion)>
	</cfif>
</cfif>

<!--- FIN CONSULTAS --->
<script src="/cfmx/rh/js/utilesMonto.js"></script>
<script src="/cfmx/sif/js/qForms/qforms.js"></script>

<cfoutput>
<form name="form1" method="post" action="Comportamientos-sql.cfm" >
	<table width="100%" border="0" cellspacing="0" cellpadding="3">
		<tr> 
			<td align="right" class="fileLabel">#LB_CODIGO#:</td>
			<td>
				<input name="RHCOcodigo" type="text" id="RHCOcodigo" size="10" maxlength="10" value="<cfif modo NEQ "ALTA">#rs.RHCOcodigo#</cfif>" onfocus="this.select();">
			</td>
		</tr>
		<tr> 
			<td align="right" class="fileLabel" valign="top">#LB_DESCRIPCION#:</td>
			<td>
				<textarea name="RHCOdescripcion" id="RHCOdescripcion" cols="50" rows="7"><cfif modo NEQ "ALTA">#rs.RHCOdescripcion#</cfif></textarea>				
			</td>
		</tr>
		<tr> 
			<td align="right" class="fileLabel">#LB_Habilidad#:</td>
			<td>
				<cf_conlis title="#LB_ListaHabilidades#"
						campos = "RHHid,RHHcodigo,RHHdescripcion" 
						desplegables = "N,S,S" 
						modificables = "N,S,N" 
						size = "0,10,30"
						asignar="RHHid,RHHcodigo,RHHdescripcion"
						asignarformatos="I,S,S"
						tabla="	RHHabilidades a"																	
						columnas="a.RHHid,a.RHHcodigo,a.RHHdescripcion"
						filtro="a.Ecodigo =#session.Ecodigo#"
						desplegar="RHHcodigo,RHHdescripcion"
						etiquetas="	#LB_CODIGO#, 
									#LB_DESCRIPCION#"
						formatos="S,S"
						align="left,left"
						showEmptyListMsg="true"
						debug="false"
						form="form1"
						width="800"
						height="500"
						left="70"
						top="20"
						filtrar_por="RHHcodigo,RHHdescripcion"
						valuesarray="#va_arrayHabilidad#">
			</td>
		</tr>
		<tr> 
			<td align="right" class="fileLabel">#LB_Peso#:</td>
			<td>
				<input name="RHCOpeso"  value="<cfif modo NEQ "ALTA">#LSCurrencyFormat(rs.RHCOpeso, 'none')#<cfelse>1</cfif>" type="text" size="5" 
				onfocus="this.value=qf(this); this.select();" onblur="javascript: fm(this,0);"  
				onkeyup="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;"  tabindex="6">
			</td>
		</tr>
		<tr> 
			<td align="right" class="fileLabel">#LB_GrupoDeNiveles#:</td>
			<td>
				<cf_conlis title="#LB_ListaDeGruposDeNivel#"
						campos = "RHGNid,RHGNcodigo,RHGNdescripcion" 
						desplegables = "N,S,S" 
						modificables = "N,S,N" 
						size = "0,10,30"
						asignar="RHGNid,RHGNcodigo,RHGNdescripcion"
						asignarformatos="I,S,S"
						tabla="	RHGrupoNivel a"																	
						columnas="a.RHGNid,a.RHGNcodigo,a.RHGNdescripcion"
						filtro="a.Ecodigo =#session.Ecodigo#"
						desplegar="RHGNcodigo,RHGNdescripcion"
						etiquetas="	#LB_CODIGO#, 
									#LB_DESCRIPCION#"
						formatos="S,S"
						align="left,left"
						showEmptyListMsg="true"
						debug="false"
						form="form1"
						width="800"
						height="500"
						left="70"
						top="20"
						filtrar_por="RHGNcodigo,RHGNdescripcion"
						valuesarray="#va_arrayGrupos#">
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr> 
        	<td colspan="4" align="center"> 
				<cf_botones modo="#modo#">
			</td>
		</tr>
	</table>
	<cfset ts = "">
	<cfif modo NEQ "ALTA">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#rs.ts_rversion#" returnvariable="ts"></cfinvoke>
	</cfif>
	<cfif modo NEQ "ALTA">
		<input type="hidden" name="RHCOid" value="#rs.RHCOid#">
	</cfif>
	<input type="hidden" name="ts_rversion" value="<cfif modo NEQ "ALTA">#ts#</cfif>">
</form>

</cfoutput>


<script language="JavaScript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");	//-->

	function deshabilitarValidacion(){
		objForm.RHCOcodigo.required = false;
		objForm.RHCOdescripcion.validate = false;
		objForm.RHGNid.required = false;
		objForm.RHHid.required = false;
	}
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	
	objForm.RHCOcodigo.required = true;
	objForm.RHCOcodigo.description = "<cfoutput>#LB_Codigo#</cfoutput>";
	objForm.RHCOdescripcion.validate=true;
	objForm.RHCOdescripcion.description = "<cfoutput>#LB_Descripcion#</cfoutput>";
	objForm.RHGNid.required = true;
	objForm.RHGNid.description = "<cfoutput>#LB_GrupoDeNiveles#</cfoutput>";
	objForm.RHHid.required = true;
	objForm.RHHid.description = "<cfoutput>#LB_Habilidad#</cfoutput>";	
	
</script>