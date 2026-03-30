<cfif isdefined('url.modo') and not isdefined('form.modo')>
	<cfset form.modo = url.modo>
</cfif>

<cfif isdefined('url.RHFid') and not isdefined('form.RHFid')>
	<cfset form.RHFid = url.RHFid>
</cfif>

<!--- Establecimiento del modo --->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>


<!--- Consultas --->

<cfquery name="rsOrden" datasource="#session.DSN#">
		Select coalesce(max(RHFOrden),0) as RHFOrden
		from RHFirmasAccion
		where RHTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHTid#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery> 

<cfset lvar_Orden = rsOrden.RHFOrden +10 >

 
<cfif modo NEQ "ALTA">
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select 
			RHFid, RHTid, RHFtipo, RHFautorizador, DEid, CFid, RHFOrden, ts_rversion
		from RHFirmasAccion
		where RHFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.RHFid#">
		  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>	
	<cfif isdefined("rsForm.CFid") and len(trim(rsForm.CFid)) >
		<cfquery name="rsForm1" datasource="#session.DSN#">
			Select CFid, CFcodigo, CFdescripcion
			from CFuncional
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and 
					CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CFid#"> 
		</cfquery> 
	</cfif>	
	<cfif isdefined("rsForm.DEid") and len(trim(rsForm.DEid)) >
		<cfquery name="rsForm2" datasource="#session.DSN#">
			Select
				DEid, DEidentificacion,	NTIcodigo,
				<cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,'  ',DEapellido2"> as NombreEmp
			from DatosEmpleado
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and 
					DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.DEid#"> 
		</cfquery> 
	</cfif>	
</cfif>


<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>

<!--- Hace el llamado a la parte de SQL donde se hace el mantenimiento --->
<form name="form1" method="post" action="SQLTipoAccionFirmas.cfm">
<!--- 	<cfif isdefined('PageNum')>
		<input name="PageNum" type="hidden" value="<cfoutput>#PageNum#</cfoutput>"/>
	</cfif> 
--->	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
			<tr>
				<td align="right" width="25%" valign="top"><cf_translate  key="LB_Firmas">Firmas</cf_translate>:&nbsp;</td>
				<td>
					<table width="100%"  border="0" cellspacing="0" cellpadding="0">
						<tr>
							<td valign="middle">
							<input  onclick="javascript:motrarTR(1);" type="radio" name="RHFtipo" value="1" <cfif modo EQ 'ALTA' or  rsForm.RHFtipo EQ 1>checked</cfif>/>
							<cf_translate  key="RAD_Autorizador">Autorizador</cf_translate></td>
						</tr>
						<tr>
							<td  valign="middle">
							<input onclick="javascript:motrarTR(2);" type="radio" name="RHFtipo" value="2" <cfif modo NEQ 'ALTA' and rsForm.RHFtipo EQ 2>checked</cfif>/>
							<cf_translate  key="RAD_Empleado">Empleado</cf_translate></td>
						</tr>
						<tr>
							<td  valign="middle">
							<input onclick="javascript:motrarTR(3);" type="radio" name="RHFtipo" value="3" <cfif modo NEQ 'ALTA' and rsForm.RHFtipo EQ 3>checked</cfif>/>
							<cf_translate  key="RAD_Firmadelinvolucradoenlaccion">Firma del Involucrado en la Acci&oacute;n</cf_translate></td>
						</tr>
						<tr>
							<td  valign="middle">
							<input onclick="javascript:motrarTR(4);" type="radio" name="RHFtipo" value="4" <cfif modo NEQ 'ALTA' and rsForm.RHFtipo EQ 4>checked</cfif>/>
							<cf_translate  key="RAD_JefedelInvolucradoenlaAccion">Jefe del Involucrado en la Acci&oacute;n</cf_translate></td>
						</tr>
						<tr>
							<td  valign="middle">
							<input onclick="javascript:motrarTR(5);" type="radio" name="RHFtipo" value="5" <cfif modo NEQ 'ALTA' and rsForm.RHFtipo EQ 5>checked</cfif>/>
							<cf_translate  key="RAD_EncargadoCentroFuncional">Encargado Centro Funcional</cf_translate></td>
						</tr>
					</table></td>
			</tr>
			
		  
			<tr id="TR_RHFtipo1" style=" display:none">
				<td align="right" width="25%" valign="top"><cf_translate  key="LB_FAutorizador">Autorizador</cf_translate>:&nbsp;</td>
				<td valign="top">
					<input type="text" name="RHFautorizador" value="<cfif isdefined("rsForm.RHFautorizador") and len(trim(rsForm.RHFautorizador)) gt 0 ><cfoutput>#rsForm.RHFautorizador#</cfoutput></cfif>" size="60" maxlength="100" onFocus="javascript:this.select();" >				</td>
			</tr>
			
			<tr id="TR_RHFtipo2" style=" display:none">
				<td align="right" width="25%" valign="top"><cf_translate  key="LB_Empleado">Empleado</cf_translate>:&nbsp;</td>
				<td valign="top">
				<cfif modo NEQ "ALTA">
					<cfif isdefined("rsForm2") >
						<cf_rhempleado query="#rsForm2#" tabindex="1" >
					<cfelse>
						<cf_rhempleado tabindex="1">
					</cfif>
                <cfelse>
					<cf_rhempleado tabindex="1">
                </cfif>	</td>
			</tr>

			<tr id="TR_RHFtipo3" style=" display:none">
				<td align="right" width="25%" valign="top"><cf_translate  key="LB_Empleado">Centro Funcional</cf_translate>:&nbsp;</td>
				<td valign="top">				
					<cfif modo NEQ "ALTA">
						<cfif isdefined("rsForm1") >
						<cf_rhcfuncional query="#rsForm1#" tabindex="1">
						<cfelse>
						<cf_rhcfuncional tabindex="1">
						</cfif>
					<cfelse>
						<cf_rhcfuncional tabindex="1">
					</cfif>				</td>
			</tr>
			<tr>
			  <td align="right" valign="top"><cf_translate  key="LB_Orden">Orden</cf_translate>:</td>
			  <td valign="top"><input onfocus="this.select();" 
					onblur="javascript: fm(this,-1);"  
					onkeyup="if(snumber(this,event,-1)){ if(Key(event)=='13') {this.blur();}}" 
					style="text-align:right;" 
					type="text" name="RHFOrden"
					value="<cfif isdefined("rsForm.RHFOrden") and len(trim(rsForm.RHFOrden)) gt 0 >#rsForm.RHFOrden#<cfelseif modo eq "ALTA">#lvar_Orden#</cfif>" size="4" maxlength="4"/></td>
		  	</tr>
			<tr>
			  <td colspan="2">				
	 			  <cfset regresa = 'TipoAccion.cfm?RHTid=' & form.RHTid>
				  <cfif modo neq "ALTA">
					  <cf_botones modo="#modo#" regresar="#regresa#">
				  <cfelse>
					  <cf_botones modo="#modo#" regresar="#regresa#">
				  </cfif></td>
			</tr>
		</table>
		<input type="hidden" name="RHFid" value="<cfif modo NEQ 'ALTA'>#rsForm.RHFid#</cfif>" />
		<input type="hidden" name="RHTid" value="#Form.RHTid#">
		<!--- ts_rversion --->
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
			</cfinvoke>
		</cfif>
		<input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'>#ts#</cfif>">					
	</cfoutput>
</form>
<cf_qforms> <!--- Siempre debe de ir al final despues del </form> --->

<script language="JavaScript1.2" type="text/javascript">
	<cfoutput>
	
	objForm.RHFtipo.required  			= true;				<!--- nombre del campo estado de requerido true / false --->
	objForm.RHFtipo.description     	= "#LB_Firmante#";	<!--- Etiqueta del campo para desplegar en el mensaje   --->
	objForm.RHFOrden.required  			= true;
	objForm.RHFOrden.description     	= "#LB_Orden#";
	
	function habilitarValidacion(){
		objForm.RHFtipo.required  			= true;
		objForm.RHFOrden.required  			= true;
	}
	function deshabilitarValidacion(){
		objForm.RHFtipo.required  			= false;
		objForm.RHFOrden.required  			= false;
		objForm.RHFautorizador.required  	= false;
		objForm.DEid.required  				= false;
		objForm.CFid.required  				= false;
	}		
	function motrarTR(opcion){
		var TR_RHFtipo1	 = document.getElementById("TR_RHFtipo1");
		var TR_RHFtipo2	 = document.getElementById("TR_RHFtipo2");
		var TR_RHFtipo3	 = document.getElementById("TR_RHFtipo3");

		switch(opcion){
			case 1:{
				TR_RHFtipo1.style.display = "";
				TR_RHFtipo2.style.display = "none";
				TR_RHFtipo3.style.display = "none";
				objForm.RHFautorizador.required  	= true;
				objForm.RHFautorizador.description  = "#LB_Autorizador#";
				objForm.DEid.required  				= false;
				objForm.CFid.required  				= false;
			}
			break;
			case 2:{
				TR_RHFtipo1.style.display = "none";
				TR_RHFtipo2.style.display = "";
				TR_RHFtipo3.style.display = "none";
				objForm.DEid.required  				= true;
				objForm.DEid.description     		= "#LB_Usuario#";
				objForm.RHFautorizador.required  	= false;
				objForm.CFid.required  				= false;
			}
			break;
			case 3:{
				TR_RHFtipo1.style.display = "none";
				TR_RHFtipo2.style.display = "none";
				TR_RHFtipo3.style.display = "none";
				objForm.RHFautorizador.required  	= false;
				objForm.DEid.required  				= false;
				objForm.CFid.required  				= false;				
			}
			break;
			case 4:{
				TR_RHFtipo1.style.display = "none";
				TR_RHFtipo2.style.display = "none";
				TR_RHFtipo3.style.display = "none";
				objForm.RHFautorizador.required  	= false;
				objForm.DEid.required  				= false;
				objForm.CFid.required  				= false;				
			}
			break;
			case 5:{
				TR_RHFtipo1.style.display = "none";
				TR_RHFtipo2.style.display = "none";
				TR_RHFtipo3.style.display = "";
				objForm.CFid.required  				= true;
				objForm.CFid.description     		= "#LB_EncargadoCF#";
				objForm.RHFautorizador.required  	= false;
				objForm.DEid.required  				= false;
			}
			break;
		}
	}
	<cfif modo neq "ALTA">
		motrarTR(<cfoutput>#rsForm.RHFtipo#</cfoutput>);
	<cfelse>
		motrarTR(1);
	</cfif>
	
	function funcRegresar(id){
		document.location.href = 'TipoAccion.cfm?RHTid=' & id;
	}
	</cfoutput>
</script>
